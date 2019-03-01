;;; jm-theme.el --- My Custom Theme from zenburn

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

(deftheme jm "Julien Masson color theme")

;;; Color Palette

(defvar jm-colors-alist
  '(("jm-fg-1"     . "#c9c9c9")
    ("jm-fg"       . "#bdbdb3")
    ("jm-fg+1"     . "#9b9b9b")
    ("jm-bg-2"     . "#4c4c4c")
    ("jm-bg-1"     . "#3b3b3b")
    ("jm-bg-05"    . "#2e2e2e")
    ("jm-bg"       . "#212121")
    ("jm-bg+1"     . "#141414")
    ("jm-bg+2"     . "#0a0a0a")
    ("jm-bg+3"     . "#000000")
    ("jm-red+1"    . "#AA5542")
    ("jm-red"      . "#CC5542")
    ("jm-red-1"    . "#dd5542")
    ("jm-red-2"    . "#ee5542")
    ("jm-red-3"    . "#ff5542")
    ("jm-red-4"    . "#ff6642")
    ("jm-orange-1" . "#cc8512")
    ("jm-orange"   . "#fb8512")
    ("jm-yellow"   . "#7d7c61")
    ("jm-yellow-1" . "#bdbc61")
    ("jm-yellow-2" . "#baba36")
    ("jm-green-1"  . "#6abd50")
    ("jm-green"    . "#6aaf50")
    ("jm-green+1"  . "#6aa350")
    ("jm-green+2"  . "#6a9550")
    ("jm-green+3"  . "#6a8550")
    ("jm-green+4"  . "#6a7550")
    ("jm-cyan"     . "#9b55c3")
    ("jm-blue+1"   . "#6380b3")
    ("jm-blue"     . "#5180b3")
    ("jm-blue-1"   . "#528fd1")
    ("jm-blue-2"   . "#6CA0A3")
    ("jm-blue-3"   . "#5C888B")
    ("jm-blue-4"   . "#4C7073")
    ("jm-blue-5"   . "#366060")
    ("jm-magenta"  . "#DC8CC3")
    ("highlight"   . "#393939")
    ("contrast-bg" . "#515151")
    ("comment"     . "#999999")
    ("orange"      . "#fb8512")
    ("green"       . "#99cc99")
    ("blue"        . "#6699cc"))
  "List of Jm colors.
Each element has the form (NAME . HEX).

`+N' suffixes indicate a color is lighter.
`-N' suffixes indicate a color is darker.")

(defmacro jm-with-color-variables (&rest body)
  "`let' bind all colors defined in `jm-colors-alist' around BODY.
Also bind `class' to ((class color) (min-colors 89))."
  (declare (indent 0))
  `(let ((class '((class color) (min-colors 89)))
         ,@(mapcar (lambda (cons)
                     (list (intern (car cons)) (cdr cons)))
                   jm-colors-alist))
     ,@body))

;;; Theme Faces
(jm-with-color-variables
  (custom-theme-set-faces
   'jm
;;;; Built-in
;;;;; basic coloring
   '(button ((t (:underline t))))
   `(link ((t (:foreground ,jm-yellow :underline t :weight bold))))
   `(link-visited ((t (:foreground ,jm-yellow-2 :underline t :weight normal))))
   `(default ((t (:foreground ,jm-fg :background ,jm-bg))))
   `(cursor ((t (:foreground ,jm-fg :background ,jm-orange-1))))
   `(escape-glyph ((t (:foreground ,jm-yellow :bold t))))
   `(fringe ((t (:foreground ,jm-fg :background ,jm-bg))))
   `(header-line ((t (:foreground ,jm-yellow
                                  :background ,jm-bg-1
                                  :box (:line-width -1 :style released-button)))))
   `(highlight ((t (:background ,jm-bg-05))))
   `(success ((t (:foreground ,jm-green :weight bold))))
   `(warning ((t (:foreground ,jm-orange :weight bold))))
   `(error ((t (:foreground ,jm-red+1 :weight bold))))
   `(vertical-border ((t (:background "black" :foreground "black"))))
   `(minibuffer-prompt ((t (:foreground ,jm-yellow :weight bold))))
   `(menu ((t (:foreground ,jm-fg :background ,jm-bg))))
   `(minibuffer-prompt ((t (:foreground ,jm-yellow))))
   `(mode-line
     ((,class (:foreground ,jm-fg-1
                           :background ,jm-bg+3
                           :box (:line-width -1 :style released-button)))
      (t :inverse-video t)))
   `(mode-line-buffer-id ((t (:foreground ,jm-orange-1 :weight bold))))
   `(mode-line-inactive
     ((t (:foreground ,jm-fg+1
                      :background ,jm-bg-1
                      :box nil :weight light))))
   `(region ((,class (:background ,jm-bg-1))
             (t :inverse-video t)))
   `(secondary-selection ((t (:background ,jm-bg+2))))
   `(trailing-whitespace ((t (:background ,jm-red))))
   `(vertical-border ((t (:foreground ,jm-fg))))
   `(scroll-bar ((t (:background ,jm-bg+2 :foreground ,jm-fg+1))))
;;;;; compilation
   `(compilation-column-face ((t (:foreground ,jm-yellow))))
   `(compilation-enter-directory-face ((t (:foreground ,jm-green))))
   `(compilation-error-face ((t (:foreground ,jm-red-1 :weight bold :underline t))))
   `(compilation-face ((t (:foreground ,jm-fg))))
   `(compilation-info-face ((t (:foreground ,jm-blue))))
   `(compilation-info ((t (:foreground ,jm-green+4 :underline t))))
   `(compilation-leave-directory-face ((t (:foreground ,jm-green))))
   `(compilation-line-face ((t (:foreground ,jm-yellow))))
   `(compilation-line-number ((t (:foreground ,jm-yellow))))
   `(compilation-message-face ((t (:foreground ,jm-blue))))
   `(compilation-warning-face ((t (:foreground ,jm-orange :weight bold :underline t))))
   `(compilation-mode-line-exit ((t (:foreground ,jm-green+2 :weight bold))))
   `(compilation-mode-line-fail ((t (:foreground ,jm-red :weight bold))))
   `(compilation-mode-line-run ((t (:foreground ,jm-yellow :weight bold))))
;;;;; grep
   `(grep-context-face ((t (:foreground ,jm-fg))))
   `(grep-error-face ((t (:foreground ,jm-red-1 :weight bold :underline t))))
   `(grep-hit-face ((t (:foreground ,jm-blue))))
   `(grep-match-face ((t (:foreground ,jm-orange :weight bold))))
   `(match ((t (:background ,jm-bg-1 :foreground ,jm-orange :weight bold))))
;;;;; isearch
   `(isearch ((t (:foreground ,jm-yellow-2 :weight bold :background ,jm-bg-1))))
   `(isearch-fail ((t (:foreground ,jm-fg :background ,jm-red-4))))
   `(lazy-highlight ((t (:foreground ,jm-yellow-2 :weight bold :background ,jm-bg-05))))
;;;;; font lock
   `(font-lock-builtin-face ((t (:foreground ,jm-fg :weight bold))))
   `(font-lock-comment-face ((t (:foreground ,jm-green))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,jm-green-1))))
   `(font-lock-constant-face ((t (:foreground ,jm-green+4))))
   `(font-lock-doc-face ((t (:foreground ,jm-green+2))))
   `(font-lock-function-name-face ((t (:foreground ,jm-cyan))))
   `(font-lock-keyword-face ((t (:foreground ,jm-yellow :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,jm-yellow :weight bold))))
   `(font-lock-preprocessor-face ((t (:foreground ,jm-blue+1))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,jm-yellow :weight bold))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,jm-green :weight bold))))
   `(font-lock-string-face ((t (:foreground ,jm-red))))
   `(font-lock-type-face ((t (:foreground ,jm-blue-1))))
   `(font-lock-variable-name-face ((t (:foreground ,jm-orange))))
   `(font-lock-warning-face ((t (:foreground ,jm-yellow-2 :weight bold))))
   `(c-annotation-face ((t (:inherit font-lock-constant-face))))
;;;;; auctex
   `(font-latex-bold-face ((t (:inherit bold))))
   `(font-latex-warning-face ((t (:inherit font-lock-warning))))
   `(font-latex-sectioning-5-face ((t (:foreground ,jm-red :weight bold ))))
   `(font-latex-sedate-face ((t (:foreground ,jm-yellow))))
;;;;; diff
   `(diff-added ((,class (:foreground ,jm-green+4 :background nil))
                 (t (:foreground ,jm-green-1 :background nil))))
   `(diff-changed ((t (:foreground ,jm-yellow))))
   `(diff-removed ((,class (:foreground ,jm-red :background nil))
                   (t (:foreground ,jm-red-3 :background nil))))
   `(diff-refine-added ((t :inherit diff-added :weight bold)))
   `(diff-refine-change ((t :inherit diff-changed :weight bold)))
   `(diff-refine-removed ((t :inherit diff-removed :weight bold)))
   `(diff-header ((,class (:background ,jm-bg+2))
                  (t (:background ,jm-fg :foreground ,jm-bg))))
   `(diff-file-header
     ((,class (:background ,jm-bg+2 :foreground ,jm-fg :bold t))
      (t (:background ,jm-fg :foreground ,jm-bg :bold t))))
;;;;; erc
   `(erc-action-face ((t (:inherit erc-default-face))))
   `(erc-bold-face ((t (:weight bold))))
   `(erc-current-nick-face ((t (:foreground ,jm-blue :weight bold))))
   `(erc-dangerous-host-face ((t (:inherit font-lock-warning))))
   `(erc-default-face ((t (:foreground ,jm-fg))))
   `(erc-direct-msg-face ((t (:inherit erc-default))))
   `(erc-error-face ((t (:inherit font-lock-warning))))
   `(erc-fool-face ((t (:inherit erc-default))))
   `(erc-highlight-face ((t (:inherit hover-highlight))))
   `(erc-input-face ((t (:foreground ,jm-yellow))))
   `(erc-keyword-face ((t (:foreground ,jm-blue :weight bold))))
   `(erc-nick-default-face ((t (:foreground ,jm-yellow :weight bold))))
   `(erc-my-nick-face ((t (:foreground ,jm-red :weight bold))))
   `(erc-nick-msg-face ((t (:inherit erc-default))))
   `(erc-notice-face ((t (:foreground ,jm-green))))
   `(erc-pal-face ((t (:foreground ,jm-orange :weight bold))))
   `(erc-prompt-face ((t (:foreground ,jm-orange :background ,jm-bg :weight bold))))
   `(erc-timestamp-face ((t (:foreground ,jm-green+1))))
   `(erc-underline-face ((t (:underline t))))
;;;;; gnus
   `(gnus-group-mail-1 ((t (:bold t :inherit gnus-group-mail-1-empty))))
   `(gnus-group-mail-1-empty ((t (:inherit gnus-group-news-1-empty))))
   `(gnus-group-mail-2 ((t (:bold t :inherit gnus-group-mail-2-empty))))
   `(gnus-group-mail-2-empty ((t (:inherit gnus-group-news-2-empty))))
   `(gnus-group-mail-3 ((t (:bold t :inherit gnus-group-mail-3-empty))))
   `(gnus-group-mail-3-empty ((t (:inherit gnus-group-news-3-empty))))
   `(gnus-group-mail-4 ((t (:bold t :inherit gnus-group-mail-4-empty))))
   `(gnus-group-mail-4-empty ((t (:inherit gnus-group-news-4-empty))))
   `(gnus-group-mail-5 ((t (:bold t :inherit gnus-group-mail-5-empty))))
   `(gnus-group-mail-5-empty ((t (:inherit gnus-group-news-5-empty))))
   `(gnus-group-mail-6 ((t (:bold t :inherit gnus-group-mail-6-empty))))
   `(gnus-group-mail-6-empty ((t (:inherit gnus-group-news-6-empty))))
   `(gnus-group-mail-low ((t (:bold t :inherit gnus-group-mail-low-empty))))
   `(gnus-group-mail-low-empty ((t (:inherit gnus-group-news-low-empty))))
   `(gnus-group-news-1 ((t (:bold t :inherit gnus-group-news-1-empty))))
   `(gnus-group-news-2 ((t (:bold t :inherit gnus-group-news-2-empty))))
   `(gnus-group-news-3 ((t (:bold t :inherit gnus-group-news-3-empty))))
   `(gnus-group-news-4 ((t (:bold t :inherit gnus-group-news-4-empty))))
   `(gnus-group-news-5 ((t (:bold t :inherit gnus-group-news-5-empty))))
   `(gnus-group-news-6 ((t (:bold t :inherit gnus-group-news-6-empty))))
   `(gnus-group-news-low ((t (:bold t :inherit gnus-group-news-low-empty))))
   `(gnus-header-content ((t (:inherit message-header-other))))
   `(gnus-header-from ((t (:inherit message-header-from))))
   `(gnus-header-name ((t (:inherit message-header-name))))
   `(gnus-header-newsgroups ((t (:inherit message-header-other))))
   `(gnus-header-subject ((t (:inherit message-header-subject))))
   `(gnus-summary-cancelled ((t (:foreground ,jm-orange))))
   `(gnus-summary-high-ancient ((t (:foreground ,jm-blue))))
   `(gnus-summary-high-read ((t (:foreground ,jm-green :weight bold))))
   `(gnus-summary-high-ticked ((t (:foreground ,jm-orange :weight bold))))
   `(gnus-summary-high-unread ((t (:foreground ,jm-fg :weight bold))))
   `(gnus-summary-low-ancient ((t (:foreground ,jm-blue))))
   `(gnus-summary-low-read ((t (:foreground ,jm-green))))
   `(gnus-summary-low-ticked ((t (:foreground ,jm-orange :weight bold))))
   `(gnus-summary-low-unread ((t (:foreground ,jm-fg))))
   `(gnus-summary-normal-ancient ((t (:foreground ,jm-blue))))
   `(gnus-summary-normal-read ((t (:foreground ,jm-green))))
   `(gnus-summary-normal-ticked ((t (:foreground ,jm-orange :weight bold))))
   `(gnus-summary-normal-unread ((t (:foreground ,jm-fg))))
   `(gnus-summary-selected ((t (:foreground ,jm-yellow :weight bold))))
   `(gnus-cite-1 ((t (:foreground ,jm-blue))))
   `(gnus-cite-10 ((t (:foreground ,jm-yellow-1))))
   `(gnus-cite-11 ((t (:foreground ,jm-yellow))))
   `(gnus-cite-2 ((t (:foreground ,jm-blue-1))))
   `(gnus-cite-3 ((t (:foreground ,jm-blue-2))))
   `(gnus-cite-4 ((t (:foreground ,jm-green+2))))
   `(gnus-cite-5 ((t (:foreground ,jm-green+1))))
   `(gnus-cite-6 ((t (:foreground ,jm-green))))
   `(gnus-cite-7 ((t (:foreground ,jm-red))))
   `(gnus-cite-8 ((t (:foreground ,jm-red-1))))
   `(gnus-cite-9 ((t (:foreground ,jm-red-2))))
   `(gnus-group-news-1-empty ((t (:foreground ,jm-yellow))))
   `(gnus-group-news-2-empty ((t (:foreground ,jm-green+3))))
   `(gnus-group-news-3-empty ((t (:foreground ,jm-green+1))))
   `(gnus-group-news-4-empty ((t (:foreground ,jm-blue-2))))
   `(gnus-group-news-5-empty ((t (:foreground ,jm-blue-3))))
   `(gnus-group-news-6-empty ((t (:foreground ,jm-bg+2))))
   `(gnus-group-news-low-empty ((t (:foreground ,jm-bg+2))))
   `(gnus-signature ((t (:foreground ,jm-yellow))))
   `(gnus-x ((t (:background ,jm-fg :foreground ,jm-bg))))
;;;;; hl-line-mode
   `(hl-line-face ((,class (:background ,jm-bg-05))
                   (t :weight bold)))
   `(hl-line ((,class (:background ,jm-bg-05)) ; old emacsen
              (t :weight bold)))
;;;;; hl-sexp
   `(hl-sexp-face ((,class (:background ,jm-bg+1))
                   (t :weight bold)))
;;;;; ido-mode
   `(ido-first-match ((t (:foreground ,jm-orange :weight bold))))
   `(ido-only-match ((t (:foreground ,jm-green :weight bold))))
   `(ido-incomplete-regex ((t (:foreground ,jm-red-4))))
   `(ido-subdir ((t (:foreground ,jm-blue))))
;;;;; linum-mode
   `(linum ((t (:foreground ,jm-green+2 :background ,jm-bg))))
;;;;; magit
   `(magit-section-title ((t (:foreground ,jm-yellow :weight bold))))
   `(magit-header ((t (:foreground ,jm-yellow :weight bold))))
   `(magit-branch ((t (:foreground ,jm-orange :weight bold))))
   `(magit-item-highlight ((t (:background ,jm-bg+1 :bold nil))))
   `(magit-log-sha1 ((t (:foreground ,jm-blue-5))))
   `(magit-section-highlight ((t)))
   `(magit-section-heading ((t :inherit font-lock-keyword-face)))
   `(magit-diff-file-heading ((t)))
   `(magit-diff-added ((t :inherit diff-added)))
   `(magit-diff-added-highlight ((t :inherit diff-added)))
   `(magit-diff-removed ((t :inherit diff-removed)))
   `(magit-diff-removed-highlight ((t :inherit diff-removed)))
   `(magit-diff-file-heading-highlight ((t)))
   `(magit-diff-hunk-heading-highlight ((t)))
   `(magit-diff-context-highlight ((t)))
   `(magit-log-date ((t :foreground "DarkSlateGrey")))
;;;;; message-mode
   `(message-cited-text ((t (:inherit font-lock-comment))))
   `(message-header-name ((t (:foreground ,jm-green+1))))
   `(message-header-other ((t (:foreground ,jm-green))))
   `(message-header-to ((t (:foreground ,jm-yellow :weight bold))))
   `(message-header-from ((t (:foreground ,jm-yellow :weight bold))))
   `(message-header-cc ((t (:foreground ,jm-yellow :weight bold))))
   `(message-header-newsgroups ((t (:foreground ,jm-yellow :weight bold))))
   `(message-header-subject ((t (:foreground ,jm-orange :weight bold))))
   `(message-header-xheader ((t (:foreground ,jm-green))))
   `(message-mml ((t (:foreground ,jm-yellow :weight bold))))
   `(message-separator ((t (:inherit font-lock-comment))))
;;;;; mu4e
   `(mu4e-cited-1-face ((t (:foreground ,jm-blue    :slant italic))))
   `(mu4e-cited-2-face ((t (:foreground ,jm-green+2 :slant italic))))
   `(mu4e-cited-3-face ((t (:foreground ,jm-blue-2  :slant italic))))
   `(mu4e-cited-4-face ((t (:foreground ,jm-green   :slant italic))))
   `(mu4e-cited-5-face ((t (:foreground ,jm-blue-4  :slant italic))))
   `(mu4e-cited-6-face ((t (:foreground ,jm-green-1 :slant italic))))
   `(mu4e-cited-7-face ((t (:foreground ,jm-blue    :slant italic))))
   `(mu4e-replied-face ((t (:foreground ,jm-bg+3))))
   `(mu4e-trashed-face ((t (:foreground ,jm-bg+3 :strike-through t))))
;;;;; notmuch
   `(notmuch-tree-match-date-face ((t (:inherit font-lock-comment-face))))
   `(notmuch-tree-match-author-face ((t (:inherit font-lock-variable-name-face))))
;;;;; org-mode
   `(org-agenda-date-today
     ((t (:foreground "white" :slant italic :weight bold))) t)
   `(org-agenda-structure
     ((t (:inherit font-lock-comment-face))))
   `(org-archived ((t (:foreground ,jm-fg :weight bold))))
   `(org-checkbox ((t (:background ,jm-bg+2 :foreground "white"
                                   :box (:line-width 1 :style released-button)))))
   `(org-date ((t (:foreground ,jm-blue :underline t))))
   `(org-deadline-announce ((t (:foreground ,jm-red-1))))
   `(org-done ((t (:bold t :weight bold :foreground ,jm-green+3))))
   `(org-formula ((t (:foreground ,jm-yellow-2))))
   `(org-headline-done ((t (:foreground ,jm-green+3))))
   `(org-hide ((t (:foreground ,jm-bg-1))))
   `(org-level-1 ((t (:foreground ,jm-orange))))
   `(org-level-2 ((t (:foreground ,jm-green+4))))
   `(org-level-3 ((t (:foreground ,jm-blue-1))))
   `(org-level-4 ((t (:foreground ,jm-yellow-2))))
   `(org-level-5 ((t (:foreground ,jm-cyan))))
   `(org-level-6 ((t (:foreground ,jm-green+2))))
   `(org-level-7 ((t (:foreground ,jm-red-4))))
   `(org-level-8 ((t (:foreground ,jm-blue-4))))
   `(org-link ((t (:foreground ,jm-yellow-2 :underline t))))
   `(org-scheduled ((t (:foreground ,jm-green+4))))
   `(org-scheduled-previously ((t (:foreground ,jm-red-4))))
   `(org-scheduled-today ((t (:foreground ,jm-blue+1))))
   `(org-sexp-date ((t (:foreground ,jm-blue+1 :underline t))))
   `(org-special-keyword ((t (:foreground ,jm-fg-1 :weight normal))))
   `(org-table ((t (:foreground ,jm-green+2))))
   `(org-tag ((t (:bold t :weight bold))))
   `(org-time-grid ((t (:foreground ,jm-orange))))
   `(org-todo ((t (:bold t :foreground ,jm-red :weight bold))))
   `(org-upcoming-deadline ((t (:inherit font-lock-keyword-face))))
   `(org-warning ((t (:bold t :foreground ,jm-red :weight bold :underline nil))))
   `(org-column ((t (:background ,jm-bg-1))))
   `(org-column-title ((t (:background ,jm-bg-1 :underline t :weight bold))))
;;;;; show-paren
   `(show-paren-mismatch ((t (:foreground ,jm-red-3 :background ,jm-bg :weight bold))))
   `(show-paren-match ((t (:foreground ,jm-blue-1 :background ,jm-bg :weight bold))))
;;;;; term
   `(term-color-black ((t (:foreground ,jm-bg :background ,jm-bg-1))))
   `(term-color-red ((t (:foreground ,jm-red-2 :background ,jm-red-4))))
   `(term-color-green ((t (:foreground ,jm-green :background ,jm-green+2))))
   `(term-color-yellow ((t (:foreground ,jm-orange :background ,jm-yellow))))
   `(term-color-blue ((t (:foreground ,jm-blue-1 :background ,jm-blue-4))))
   `(term-color-magenta ((t (:foreground ,jm-magenta :background ,jm-red))))
   `(term-color-cyan ((t (:foreground ,jm-cyan :background ,jm-blue))))
   `(term-color-white ((t (:foreground ,jm-fg :background ,jm-fg-1))))
   '(term-default-fg-color ((t (:inherit term-color-white))))
   '(term-default-bg-color ((t (:inherit term-color-black))))
;;;;; web-mode
   `(web-mode-builtin-face ((t (:inherit ,font-lock-builtin-face))))
   `(web-mode-comment-face ((t (:inherit ,font-lock-comment-face))))
   `(web-mode-constant-face ((t (:inherit ,font-lock-constant-face))))
   `(web-mode-css-at-rule-face ((t (:foreground ,jm-orange ))))
   `(web-mode-css-prop-face ((t (:foreground ,jm-orange))))
   `(web-mode-css-pseudo-class-face ((t (:foreground ,jm-green+3 :weight bold))))
   `(web-mode-css-rule-face ((t (:foreground ,jm-blue))))
   `(web-mode-doctype-face ((t (:inherit ,font-lock-comment-face))))
   `(web-mode-folded-face ((t (:underline t))))
   `(web-mode-function-name-face ((t (:foreground ,jm-blue))))
   `(web-mode-html-attr-name-face ((t (:foreground ,jm-orange))))
   `(web-mode-html-attr-value-face ((t (:inherit ,font-lock-string-face))))
   `(web-mode-html-tag-face ((t (:foreground ,jm-cyan))))
   `(web-mode-keyword-face ((t (:inherit ,font-lock-keyword-face))))
   `(web-mode-preprocessor-face ((t (:inherit ,font-lock-preprocessor-face))))
   `(web-mode-string-face ((t (:inherit ,font-lock-string-face))))
   `(web-mode-type-face ((t (:inherit ,font-lock-type-face))))
   `(web-mode-variable-name-face ((t (:inherit ,font-lock-variable-name-face))))
   `(web-mode-server-background-face ((t (:background ,jm-bg))))
   `(web-mode-server-comment-face ((t (:inherit web-mode-comment-face))))
   `(web-mode-server-string-face ((t (:inherit web-mode-string-face))))
   `(web-mode-symbol-face ((t (:inherit font-lock-constant-face))))
   `(web-mode-warning-face ((t (:inherit font-lock-warning-face))))
   `(web-mode-whitespaces-face ((t (:background ,jm-red))))
;;;;; whitespace-mode
   `(whitespace-space ((t (:background ,jm-bg+1 :foreground ,jm-bg+1))))
   `(whitespace-hspace ((t (:background ,jm-bg+1 :foreground ,jm-bg+1))))
   `(whitespace-tab ((t (:background ,jm-red-1))))
   `(whitespace-newline ((t (:foreground ,jm-bg+1))))
   `(whitespace-trailing ((t (:background ,jm-red))))
   `(whitespace-line ((t (:background ,jm-bg :foreground ,jm-magenta))))
   `(whitespace-space-before-tab ((t (:background ,jm-orange :foreground ,jm-orange))))
   `(whitespace-indentation ((t (:background ,jm-yellow :foreground ,jm-red))))
   `(whitespace-empty ((t (:background ,jm-yellow))))
   `(whitespace-space-after-tab ((t (:background ,jm-yellow :foreground ,jm-red))))
;;;;; xcscope
   `(cscope-file-face ((t (:foreground ,jm-green+4))))
   `(cscope-function-face ((t :foreground ,jm-blue)))
   `(cscope-line-number-face ((t :foreground ,jm-red)))
   `(cscope-mouse-face ((t :foreground "white" :background "blue")))
   `(cscope-separator-face ((t :bold t :overline t :underline t :foreground ,jm-orange)))
;;;;; company
   `(company-preview ((t (:foreground ,comment :background ,contrast-bg))))
   `(company-preview-common ((t (:inherit company-preview :foreground ,orange))))
   `(company-preview-search ((t (:inherit company-preview :foreground ,blue))))
   `(company-tooltip ((t (:background ,contrast-bg))))
   `(company-tooltip-selection ((t (:background ,highlight))))
   `(company-tooltip-common ((t (:inherit company-tooltip :foreground ,orange))))
   `(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :foreground ,orange))))
   `(company-tooltip-search ((t (:inherit company-tooltip :foreground ,blue))))
   `(company-tooltip-annotation ((t (:inherit company-tooltip :foreground ,green))))
   `(company-tooltip-annotation-selection ((t (:inherit company-tooltip-selection :foreground ,green))))
   `(company-scrollbar-bg ((t (:inherit 'company-tooltip :background ,highlight))))
   `(company-scrollbar-fg ((t (:background ,contrast-bg))))
   `(company-echo-common ((t (:inherit company-echo :foreground ,orange))))
))

;;; Theme Variables
(jm-with-color-variables
  (custom-theme-set-variables
   'jm
;;;;; ansi-color
   `(ansi-color-names-vector [,jm-bg ,jm-red ,jm-green ,jm-yellow
                                          ,jm-blue ,jm-magenta ,jm-cyan ,jm-fg])
;;;;; fill-column-indicator
   `(fci-rule-color ,jm-bg-05)
;;;;; vc-annotate
   `(vc-annotate-color-map
     '(( 20. . ,jm-red-1)
       ( 40. . ,jm-red)
       ( 60. . ,jm-orange)
       ( 80. . ,jm-yellow-2)
       (100. . ,jm-yellow-1)
       (120. . ,jm-yellow)
       (140. . ,jm-green-1)
       (160. . ,jm-green)
       (180. . ,jm-green+1)
       (200. . ,jm-green+2)
       (220. . ,jm-green+3)
       (240. . ,jm-green+4)
       (260. . ,jm-cyan)
       (280. . ,jm-blue-2)
       (300. . ,jm-blue-1)
       (320. . ,jm-blue)
       (340. . ,jm-blue+1)
       (360. . ,jm-magenta)))
   `(vc-annotate-very-old-color ,jm-magenta)
   `(vc-annotate-background ,jm-bg-1)
   ))

;;; Footer

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))


(provide-theme 'jm)
