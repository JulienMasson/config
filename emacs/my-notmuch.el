;;; my-notmuch.el --- Notmuch Configuration

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

;; load notmuch module
(require 'notmuch)

;; notmuch company
(require 'company)
(require 'notmuch-company)
(add-to-list 'company-backends 'notmuch-company)

;; no Fcc header added
(setq notmuch-fcc-dirs nil)

;; tree result format
(setq notmuch-tree-result-format `(("date" . "%-14s")
				   ("authors" . "%-16s")
				   ((("tree" . "%s")("subject" . "%s")) . "%s")))

;; message headers
(setq notmuch-message-headers '("From" "To" "Subject" "Date"))

;; message tree headers
(setq notmuch-tree-headers '(("Date" . "%-14s")
			     ("From" . "%-16s")
			     ("Subject" . "%s")))

;; remove wash citations from insert text hook
(setq notmuch-show-insert-text/plain-hook (remove 'notmuch-wash-excerpt-citations
						  notmuch-show-insert-text/plain-hook))

;; notmuch compose new mail
(defun notmuch-compose-new ()
  (notmuch-mua-mail))

(defun notmuch-user-name ()
  user-full-name)

(defun notmuch-user-primary-email ()
  user-mail-address)

(defun notmuch-get-current-account ()
  (let* ((maildir-path (notmuch-database-path))
	 (props (notmuch-show-get-message-properties))
	 (maildir (car (plist-get props :filename))))
    (string-match (concat maildir-path "/\\(.*?\\)/") maildir)
    (match-string 1 maildir)))

(defun notmuch-set-account-vars (args)
  ;; when args is non nil means we are replying/forwarding ...
  ;; We need to set account vars and reset From field
  (when args
    (mail-set-vars (notmuch-get-current-account))
    (setcdr (assq 'From (nth 2 args)) nil))
  args)

(require 'mu4e-compose)
(defun notmuch-compose-after (&rest _)
  (mu4e~compose-remap-faces))

(advice-add 'notmuch-mua-mail :filter-args #'notmuch-set-account-vars)
(advice-add 'notmuch-mua-mail :after #'notmuch-compose-after)

;; refresh management
(defvar notmuch-hello-buffer "*notmuch-hello*")
(defvar notmuch-refresh-cmd "offlineimap")
(defvar notmuch-refresh-timer nil)
(defvar notmuch-refresh-every 60)

(defun notmuch-refresh-done (process state)
  (when (equal state "finished\n")
    (with-current-buffer notmuch-hello-buffer
      (notmuch-poll-and-refresh-this-buffer))))

(defun notmuch-refresh ()
  (let ((process (start-process-shell-command
		  "notmuch-refresh" nil notmuch-refresh-cmd)))
    (set-process-sentinel process #'notmuch-refresh-done)))

(defun notmuch-refresh-hook ()
  (setq notmuch-refresh-timer (run-at-time 1 notmuch-refresh-every 'notmuch-refresh)))
(add-hook 'notmuch-hello-mode-hook #'notmuch-refresh-hook)

(defun notmuch-refresh-cancel ()
  (when (string= (buffer-name (current-buffer)) notmuch-hello-buffer)
    (cancel-timer notmuch-refresh-timer)))
(advice-add 'notmuch-bury-or-kill-this-buffer :before #'notmuch-refresh-cancel)

;; show unread messages
(defun notmuch-show-unread ()
  (interactive)
  (notmuch-tree "tag:unread"))

(defun notmuch-thread-remove-unread ()
  (interactive)
  (notmuch-tree-tag-thread '("-unread"))
  (notmuch-refresh-this-buffer))

(defun notmuch-thread-remove-unread-all ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (notmuch-tree-tag-thread '("-unread"))
      (notmuch-tree-next-thread)))
  (notmuch-refresh-this-buffer))

;; switch to buffer when RET on message
(defun notmuch-switch-to-buffer ()
  (switch-to-buffer-other-window notmuch-tree-message-buffer))
(advice-add 'notmuch-tree-show-message-in :after #'notmuch-switch-to-buffer)

;; notmuch header line format
(defun notmuch-header-line-format ()
  (setq-local header-line-format
	      (cons " " (mapcar (lambda (item)
				  (format (cdr item) (car item)))
				notmuch-tree-headers))))

;; notmuch tree custom visual
(defun notmuch-tree-custom-visual ()
  (notmuch-header-line-format)
  (set (make-local-variable 'hl-line-face) 'mu4e-header-highlight-face))
(advice-add 'notmuch-tree-refresh-view :after #'notmuch-tree-custom-visual)

;; use same buffer when display tree view
(defvar notmuch-tree-buffer-name "*notmuch-tree*")

(defun notmuch-tree (&optional query query-context target buffer-name open-target)
  (interactive)
  (if (null query)
      (setq query (notmuch-read-query "Notmuch tree view search: ")))
  (let ((buffer (get-buffer-create notmuch-tree-buffer-name))
	(inhibit-read-only t))
    (switch-to-buffer buffer)
    (erase-buffer))
  (set 'buffer-undo-list t)
  (notmuch-tree-worker query query-context target open-target)
  (notmuch-tree-custom-visual)
  (setq truncate-lines t))

;; my show next/prev message func
(defun my-notmuch-show-next-message ()
  (interactive)
  (switch-to-buffer-other-window notmuch-tree-buffer-name)
  (notmuch-tree-next-message))

(defun my-notmuch-show-prev-message ()
  (interactive)
  (switch-to-buffer-other-window notmuch-tree-buffer-name)
  (notmuch-tree-prev-message))

;; maildir view in hello sections
(defvar notmuch-maildir-data-cached nil)

(defun notmuch-maildir-folders ()
  (let* ((maildir-path (notmuch-database-path))
  	 (dirs (directory-files-recursively maildir-path "cur$" t))
  	 (subdirs (mapcar (lambda (dir)
  			    (replace-regexp-in-string
  			     (format "%s/\\(.*\\)/cur"
  				     (expand-file-name maildir-path))
  			     "\\1" dir)) dirs)))
    subdirs))

(defun notmuch-maildir-get-data (folders)
  (let (total-list unread-list data)
    (with-temp-buffer
      ;; insert queries
      (mapc (lambda (folder)
	      (let* ((query (concat "folder:" folder))
		     (query-unread (concat query " and tag:unread")))
		(insert query "\n")
		(insert query-unread "\n")))
	    folders)
      ;; run queries
      (call-process-region (point-min) (point-max) notmuch-command
			   t t nil "count" "--batch")
      ;; parse results
      (goto-char (point-min))
      (while (not (eobp))
	(push (string-to-number (buffer-substring (point) (point-at-eol)))
	      total-list)
	(forward-line 1)
	(push (string-to-number (buffer-substring (point) (point-at-eol)))
	      unread-list)
	(forward-line 1)))
    ;; set read/unread
    (cl-mapc (lambda (folder total unread)
	       (add-to-list 'data `(:folder ,folder :unread ,unread :total ,total) t))
	     folders (nreverse total-list) (nreverse unread-list))
    data))

(defun notmuch-create-data-assoc (data-list)
  (let (maildir-assoc)
    (mapc (lambda (data)
	    (let ((folder (plist-get data :folder))
		  (unread (plist-get data :unread))
		  (total (plist-get data :total)))
	      (cl-multiple-value-bind (account label)
		  (split-string folder "/")
		(when label
		  (let* ((new-label (replace-regexp-in-string "^.*\\." "" label))
			 (new `(:label ,new-label :folder ,folder :unread ,unread :total ,total)))
		    (if (assoc account maildir-assoc)
			(let ((folders (assoc-default account maildir-assoc)))
			  (setcdr (assoc account maildir-assoc)
				  (add-to-list 'folders new t)))
		      (add-to-list 'maildir-assoc
				   (cons account `(,new)) t)))))))
	  data-list)
    maildir-assoc))

(defun notmuch-insert-maildir (maildir)
  (widget-insert (propertize
		  (format "    * %s\n" (upcase (car maildir)))
		  'face 'font-lock-variable-name-face))
  (mapc (lambda (data)
  	  (let* ((label (plist-get data :label))
		 (folder (plist-get data :folder))
		 (query (concat "folder:" folder))
  		 (total (plist-get data :total))
		 (unread (plist-get data :unread))
  		 (widget-push-button-prefix "")
  		 (widget-push-button-suffix ""))
  	    (widget-insert "      ")
  	    (widget-create 'push-button
  			   :notify #'notmuch-hello-widget-search
  			   :notmuch-search-terms query
  			   :notmuch-search-oldest-first 'newest-first
  			   :notmuch-search-type 'tree
  			   (format "%-20s" label))
  	    (widget-insert (propertize
  			    (format "(%d/%d)\n" unread total)
  			    'face (if (> unread 0)
  				      'mu4e-unread-face
  				    'mu4e-header-face)))))
  	(cdr maildir))
  (widget-insert "\n"))

(defun notmuch-insert-maildir-header ()
  (widget-insert "\n")
  (widget-insert (propertize "  Accounts\n\n" 'face 'mu4e-title-face)))

(defun notmuch-hello-maildir ()
  (let* ((folders (notmuch-maildir-folders))
	 (data-list (notmuch-maildir-get-data folders))
	 (data-assoc (notmuch-create-data-assoc data-list)))
    (setq notmuch-maildir-data-cached data-assoc)
    (notmuch-insert-maildir-header)
    (mapc #'notmuch-insert-maildir data-assoc)))

(setq notmuch-hello-sections (list #'notmuch-hello-maildir))

;; redefine how to insert msg in notmuch-show
(defun notmuch-show-insert-msg (msg depth)
  (let* ((headers (plist-get msg :headers))
	 message-start message-end
	 content-start content-end
	 headers-start headers-end
	 (bare-subject (notmuch-show-strip-re (plist-get headers :Subject))))

    (setq message-start (point-marker))

    (setq content-start (point-marker))

    ;; Set `headers-start' to point after the 'Subject:' header to be
    ;; compatible with the existing implementation. This just sets it
    ;; to after the first header.
    (notmuch-show-insert-headers headers)
    (save-excursion
      (goto-char content-start)
      ;; If the subject of this message is the same as that of the
      ;; previous message, don't display it when this message is
      ;; collapsed.
      (when (not (string= notmuch-show-previous-subject
			  bare-subject))
	(forward-line 1))
      (setq headers-start (point-marker)))
    (setq headers-end (point-marker))

    (setq notmuch-show-previous-subject bare-subject)

    ;; A blank line between the headers and the body.
    (insert "\n")
    (notmuch-show-insert-body msg (plist-get msg :body)
			      (if notmuch-show-indent-content depth 0))
    ;; Ensure that the body ends with a newline.
    (unless (bolp)
      (insert "\n"))
    (setq content-end (point-marker))

    ;; Indent according to the depth in the thread.
    (if notmuch-show-indent-content
	(indent-rigidly content-start content-end (* notmuch-show-indent-messages-width depth)))

    (setq message-end (point-max-marker))

    ;; apply custom faces
    (mu4e~compose-remap-faces)
    (apply-minimal-diff-face-buffer)
    (mu4e~fontify-cited)
    (goto-char message-end)
    (local-set-key (kbd "C-c k") 'notmuch-bury-or-kill-this-buffer)

    ;; Save the extents of this message over the whole text of the
    ;; message.
    (put-text-property message-start message-end :notmuch-message-extent (cons message-start message-end))

    ;; Create overlays used to control visibility
    (plist-put msg :headers-overlay (make-overlay headers-start headers-end))
    (plist-put msg :message-overlay (make-overlay headers-start content-end))

    (plist-put msg :depth depth)

    ;; Save the properties for this message. Currently this saves the
    ;; entire message (augmented it with other stuff), which seems
    ;; like overkill. We might save a reduced subset (for example, not
    ;; the content).
    (notmuch-show-set-message-properties msg)

    ;; Set header visibility.
    (notmuch-show-headers-visible msg notmuch-message-headers-visible)

    ;; Message visibility depends on whether it matched the search
    ;; criteria.
    (notmuch-show-message-visible msg (and (plist-get msg :match)
					   (not (plist-get msg :excluded))))))

;; redesign how is display the tree
(defun notmuch-tree-insert-tree (tree depth tree-status first last)
  (let ((msg (car tree))
	(replies (cadr tree)))
    (cond
     ((and (< 0 depth) (not last))
      (push "  ┣" tree-status))
     ((and (< 0 depth) last)
      (push "  ┗" tree-status))
     ((and (eq 0 depth) first last)
      (push "  " tree-status))
     ((and (eq 0 depth) first (not last))
      (push "  ┳" tree-status))
     ((and (eq 0 depth) (not first) last)
      (push "  ┗" tree-status))
     ((and (eq 0 depth) (not first) (not last))
      (push "  ┣" tree-status)))

    (unless (= 0 depth)
      (push "━▶" tree-status))
    (setq msg (plist-put msg :first (and first (eq 0 depth))))
    (setq msg (plist-put msg :tree-status tree-status))
    (setq msg (plist-put msg :orig-tags (plist-get msg :tags)))
    (notmuch-tree-goto-and-insert-msg msg)
    (pop tree-status)
    (pop tree-status)

    (if last
	(push "  " tree-status)
      (push "  ┃" tree-status))
    (notmuch-tree-insert-thread replies (1+ depth) tree-status)))

;; fold mail thread
(defun notmuch-level-at-point ()
  (if (notmuch-tree-get-prop :previous-subject) 1 0))


(provide 'my-notmuch)
