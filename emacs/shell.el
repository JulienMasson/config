;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;               SHELL CONFIG                ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; clear shell screen
(defun my-clear ()
      (interactive)
      (erase-buffer)
      (comint-send-input))
(defun my-shell-hook ()
  (local-set-key (kbd "C-c l") 'my-clear))
  (add-hook 'shell-mode-hook 'my-shell-hook)

;; history results
(defun search-history (pattern number)
  "Search in history"
  (interactive "sEnter pattern: \nnTail: ")
  (with-output-to-temp-buffer "*search-history-output*"
    (shell-command (format "cat ~/.zsh_history | grep %s | cut -c 16- | tail -n %d" pattern number)
                   "*search-history-output*"
                   "*Messages*")
    (pop-to-buffer "*search-history-output*")))
(global-set-key (kbd "C-c s") 'search-history)
