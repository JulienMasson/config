;;; async-semantic-acscope.el --- Semantic Acscope Management

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

(require 'acscope)
(require 'async-semantic)

;;; Internal Functions

(defun async-semantic-acscope--get-cscope-files ()
  (when-let* ((match (concat acscope-database--prefix "\\(.*\\)\.files$"))
	      (files (directory-files default-directory nil match)))
    (with-temp-buffer
      (insert-file-contents (car files))
      (split-string (buffer-string) "\n" t))))

(defun async-semantic-acscope--collect-files ()
  (let ((files-collected '()))
    (mapc (lambda (database)
	    (when-let* ((default-directory database)
			(files (async-semantic-acscope--get-cscope-files))
			(files (mapcar (lambda (file)
					 (concat default-directory
						 (file-name-nondirectory file)))
				       files)))
	      (setq files-collected (append files-collected files))))
	  acscope-database-list)
    files-collected))

;;; External Functions

(defun async-semantic-acscope ()
  (interactive)
  (when acscope-database-list
    (async-semantic (async-semantic-acscope--collect-files)
		    semantic-default-c-path)))

(provide 'async-semantic-acscope)
