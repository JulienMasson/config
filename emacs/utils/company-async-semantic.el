;;; company-async-semantic.el --- Custom company-mode completion backend

;; Copyright (C) 2019 Julien Masson

;; Author: Julien Masson <massonju.eseo@gmail.com>
;; URL: https://github.com/JulienMasson/jm-config/

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'async-semantic)

;;; Customization

(defcustom company-async-semantic-modes '(c-mode c++-mode)
  "List of mode when `company-async-semantic' is enabled"
  :type 'list
  :group 'company)

(defcustom company-async-semantic-enabled t
  "Enable/Disable `company-async-semantic', by default it's enabled"
  :type 'boolean
  :group 'company)


;;; Internal Variables

(defvar company-async-semantic--cache nil)

(defvar-local company-async-semantic--files-dep nil)

(defvar company-async-semantic--parsing-ongoing nil)

;;; Internal Functions

(defun company-async-semantic--find-dep (include)
  (when-let ((default-dir (expand-file-name default-directory))
	     (path (append (list default-dir) async-semantic-default-path))
	     (file (semantic-tag-name include)))
    (locate-file file path)))

(defun company-async-semantic--get-includes-files-dep (file)
  (when-let* ((tags (assoc-default file company-async-semantic--cache))
	      (includes (seq-filter (lambda (tag)
				      (eq (semantic-tag-class tag) 'include))
				    tags)))
    (mapc (lambda (include)
	    (unless (member include company-async-semantic--files-dep)
	      (add-to-list 'company-async-semantic--files-dep include t)
	      (company-async-semantic--get-includes-files-dep include)))
	  (mapcar #'company-async-semantic--find-dep includes))))

(defun company-async-semantic--get-files-dep ()
  (let ((file (file-truename (buffer-file-name))))
    (setq company-async-semantic--files-dep (list file))
    (company-async-semantic--get-includes-files-dep file)))

(defun company-async-semantic--get-tags (files)
  (let (tags)
    (dolist (file files)
      (when-let ((tag (assoc-default file company-async-semantic--cache)))
	(setq tags (append tags tag))))
    tags))

(defun company-async-semantic--match (tag prefix)
  (let ((func (car tag))
	(class (semantic-tag-class tag)))
    (when (and (or (eq class 'function)
		   (eq class 'variable))
	       (string-prefix-p prefix func))
      func)))

(defun company-async-semantic--completions-system (prefix)
  (let* ((files company-async-semantic--files-dep)
	 (tags (company-async-semantic--get-tags files)))
    (delq nil (mapcar (lambda (tag)
			(company-async-semantic--match tag prefix))
		      tags))))

(defun company-async-semantic--completions-scope (prefix)
  )

(defun company-async-semantic--find-tag (pos)
  (when-let ((file (file-truename (buffer-file-name)))
	     (tags (assoc-default file company-async-semantic--cache)))
    (seq-find (lambda (tag)
		(when-let* ((range (semantic-tag-overlay tag))
			    (beg (aref range 0))
			    (end (aref range 1)))
		  (and (> pos beg) (< pos end))))
	      tags)))

(defun company-async-semantic--completions-local (prefix)
  (when-let* ((tag (company-async-semantic--find-tag (point)))
	      (attr (semantic-tag-attributes tag))
	      (arguments (plist-get attr :arguments)))
    (seq-filter (lambda (var)
		  (string-prefix-p prefix var))
		(mapcar #'car arguments))))

(defun company-async-semantic--completions (prefix)
  (delq nil (append (company-async-semantic--completions-local prefix)
		    (company-async-semantic--completions-scope prefix)
		    (company-async-semantic--completions-system prefix))))

(defun company-async-semantic--completions-raw (prefix)
  nil)

(defun company-async-semantic--update-cache (file)
  (when-let* ((filename (file-name-nondirectory file))
	      (dir (file-name-directory file))
	      (cache-file (semanticdb-cache-filename semanticdb-new-database-class dir))
	      (db (semanticdb-load-database cache-file))
	      (table (seq-find (lambda (table)
				 (string= filename (oref table file)))
			       (oref db tables)))
	      (tags (oref table tags)))
    (if (assoc file company-async-semantic--cache)
	(setcdr (assoc file company-async-semantic--cache) tags)
      (add-to-list 'company-async-semantic--cache (cons file tags)))))

(defun company-async-semantic--check-deps ()
  (let ((files-dep company-async-semantic--files-dep))
    (company-async-semantic--get-files-dep)
    (cl-subsetp company-async-semantic--files-dep files-dep)))

(defun company-async-semantic--parse-done (files)
  (mapc #'company-async-semantic--update-cache files)
  (setq company-async-semantic--parsing-ongoing nil))

(defun company-async-semantic--run-parse (&optional recursive)
  (setq company-async-semantic--parsing-ongoing t)
  (async-semantic-buffer #'company-async-semantic--parse-done recursive))

(defun company-async-semantic--need-parse ()
  (not (assoc (file-truename (buffer-file-name))
	      company-async-semantic--cache)))

(defun company-async-semantic--completion-raw-p (arg)
  (and (equal arg "") (not (looking-back "->\\|\\.\\|::" (- (point) 2)))))

(defun company-async-semantic--candidates (arg)
  (let (candidates)
    (if (or (company-async-semantic--need-parse)
	    (not (company-async-semantic--check-deps)))
	(company-async-semantic--run-parse t)
      (setq candidates (if (company-async-semantic--completion-raw-p arg)
			   (company-async-semantic--completions-raw arg)
			 (company-async-semantic--completions arg))))
    candidates))

(defun company-async-semantic--prefix ()
  (and company-async-semantic-enabled
       (memq major-mode company-async-semantic-modes)
       (not (company-in-string-or-comment))
       (not company-async-semantic--parsing-ongoing)
       (or (company-grab-symbol-cons "\\.\\|->\\|::" 2) 'stop)))

(defun company-async-semantic--after-save ()
  (when (and (memq major-mode company-async-semantic-modes)
	     (not (company-async-semantic--need-parse)))
    (company-async-semantic--run-parse)))

(defun company-async-semantic--enable ()
  (add-hook 'after-save-hook 'company-async-semantic--after-save nil t))

(defun company-async-semantic--disable ()
  (remove-hook 'after-save-hook 'company-async-semantic--after-save t))

(defun company-async-semantic--global-check ()
  (let ((func (if company-async-semantic-enabled
		  'company-async-semantic--enable
		'company-async-semantic--disable)))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
	(when (memq major-mode company-async-semantic-modes)
	  (funcall func))))))

(defun company-async-semantic--setup ()
  (if company-async-semantic-enabled
      (company-async-semantic--enable)
    (company-async-semantic--disable)))

;;; External Functions

(defun company-async-semantic-clear-cache ()
  (interactive)
  (setq company-async-semantic--cache nil))

(defun company-async-semantic-setup ()
  (if company-async-semantic-enabled
      (dolist (mode-hook (list 'c-mode-hook 'c++-mode-hook))
	(add-hook mode-hook 'company-async-semantic--setup))
    (dolist (mode-hook (list 'c-mode-hook 'c++-mode-hook))
      (remove-hook mode-hook 'company-async-semantic--setup)))
  (company-async-semantic--global-check))

(defun company-async-semantic-toggle ()
  (interactive)
  (setq company-async-semantic-enabled (not company-async-semantic-enabled))
  (message (concat "Company Async Semantic: " (if company-async-semantic-enabled
						  (propertize "Enabled" 'face 'success)
						(propertize "Disabled" 'face 'error))))
  (company-async-semantic-setup))

(defun company-async-semantic (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-async-semantic))
    (prefix (company-async-semantic--prefix))
    (candidates (company-async-semantic--candidates arg))
    (duplicates t)))

(provide 'company-async-semantic)
