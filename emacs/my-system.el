;;; my-system.el

;; Copyright (C) 2017 Julien Masson

;; This file is NOT part of GNU Emacs.

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

;; add packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; don't ask to follow symlink
(setq vc-follow-symlinks t)

;; disable erase-buffer
(put 'erase-buffer 'disabled nil)

;; delete recursively without asking
(setq dired-recursive-deletes 'always)

;; save password
(setq password-cache-expiry nil)

;; dired Extra
(add-hook 'dired-load-hook
            (function (lambda () (load "dired-x"))))

;; default dired setting
(put 'dired-find-alternate-file 'disabled nil)

;; virtual desktop
(require 'virtual-desktops)
(setq virtual-desktops-display-mode-line nil)
(virtual-desktops-mode 1)

;; edit file root
(defun sudo-edit (&optional arg)
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; buffer move
(require 'buffer-move)

;; copy buffer filename
(defun show-and-copy-buffer-filename ()
  "Show and copy the full path to the current file in the minibuffer."
  (interactive)
  ;; list-buffers-directory is the variable set in dired buffers
  (let ((file-name (or (buffer-file-name) list-buffers-directory)))
    (if file-name
        (message (kill-new file-name))
      (error "Buffer not visiting a file"))))

;; define key in help mode
(require 'help-mode)
(define-key help-mode-map "n" 'help-go-forward)
(define-key help-mode-map "p" 'help-go-back)

;; tramp config
(require 'my-tramp)

;; org config
(require 'my-org)

;; dired config
(require 'my-dired)

;; erc config
(require 'my-erc)

;; programming config
(require 'my-programming)

;; shell config
(require 'my-shell)

;; github config
(require 'my-github)

;; pdf tools
(require 'pdf-tools)
(require 'pdf-occur)
(pdf-tools-install)

;; set default web browser
(setq browse-url-browser-function 'browse-url-firefox
      browse-url-new-window-flag  t
      browse-url-firefox-new-window-is-tab t)


(provide 'my-system)