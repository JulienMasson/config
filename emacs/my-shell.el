;;; my-shell.el --- Shell Configuration

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

;; set default shell
(setq explicit-shell-file-name "/bin/bash")

;; clear shell screen
(defun shell-clear ()
  (interactive)
  (erase-buffer)
  (comint-send-input))

;; bash completion
(require 'bash-completion)
(bash-completion-setup)

;; multi term plus
(require 'multi-term-plus)
(setq multi-term-program explicit-shell-file-name)
(defalias 'term 'multi-term)


(provide 'my-shell)
