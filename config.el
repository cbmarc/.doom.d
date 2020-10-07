;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;; Set global fonts
;;(add-to-list 'default-frame-alist '(font . "Ubuntu Mono 16" ))
;;(set-face-attribute 'default t :font "Ubuntu Mono 16" )
(never-add-to-list 'default-frame-alist '(font . "Fira Code 14" ))
(set-face-attribute 'default t :font "Fira Code 14" )

;; Reset treemacs icons
;;(with-eval-after-load "treemacs"
;;  (treemacs-reset-icons))
(add-hook-please! 'emacs-startup-hook
  (with-eval-after-load 'treemacs
    (treemacs-reset-icons)))

;; Window navigation
(global-set-key (kbd "C-<left>") 'evil-window-left)
(global-set-key (kbd "C-<right>") 'evil-window-right)
(global-set-key (kbd "C-S-<left>") 'evil-scroll-column-left)
(global-set-key (kbd "C-S-<right>") 'evil-scroll-column-right)

;; Magit fix TAB
(with-eval-after-load 'magit
  (define-key magit-mode-map "<tab>" 'magit-section-toggle))
;; js config
(after! js2-mode
  ;; use eslintd-fix so when i save it fixes dumb shit
  (add-hook 'js2-mode-hook #'eslintd-fix-mode)

  ;; Indent shit
  (setq js2-basic-offset 2))

;; html config
(after! web-mode
  (add-hook 'web-mode-hook #'flycheck-mode)

  (setq web-mode-markup-indent-offset 2 ;; Indentation
        web-mode-code-indent-offset 2
        web-mode-enable-auto-quoting nil ;; disbale adding "" after an =
        web-mode-auto-close-style 2))
;; Calendar
;;;###autoload
(defun cfw:open-org-calendar-with-werlabs ()
  (interactive)
  (let ((org-agenda-files '("~/org/calendars/werlabs.org")))
    (call-interactively '+calendar/open-calendar)))

(add-hook 'org-agenda-mode-hook 'org-gcal-fetch)
(add-hook 'org-capture-after-finalize-hook 'org-gcal-fetch)

;; org mode agenda
(setq org-agenda-files (list "~/org/agenda/agenda.org"
                             "~/org/calendars/werlabs.org"))
;; org projectile
(require 'org-projectile)
(setq org-projectile-projects-file
      "~/org/todo/todos.org")
(push (org-projectile-project-todo-entry) org-capture-templates)
(setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c n p") 'org-projectile-project-todo-completing-read)

;; Fira code ligatures
(defun fira-code-mode--make-alist (list)
  "Generate prettify-symbols alist from LIST."
  (let ((idx -1))
    (mapcar
     (lambda (s)
       (setq idx (1+ idx))
       (let* ((code (+ #Xe100 idx))
          (width (string-width s))
          (prefix ())
          (suffix '(?\s (Br . Br)))
          (n 1))
     (while (< n width)
       (setq prefix (append prefix '(?\s (Br . Bl))))
       (setq n (1+ n)))
     (cons s (append prefix suffix (list (decode-char 'ucs code))))))
     list)))

(defconst fira-code-mode--ligatures
  '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
    "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
    "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
    "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
    ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
    "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
    "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
    "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
    ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
    "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
    "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
    "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
    "x" ":" "+" "+" "*"))

(defvar fira-code-mode--old-prettify-alist)

(defun fira-code-mode--enable ()
  "Enable Fira Code ligatures in current buffer."
  (setq-local fira-code-mode--old-prettify-alist prettify-symbols-alist)
  (setq-local prettify-symbols-alist (append (fira-code-mode--make-alist fira-code-mode--ligatures) fira-code-mode--old-prettify-alist))
  (prettify-symbols-mode t))

(defun fira-code-mode--disable ()
  "Disable Fira Code ligatures in current buffer."
  (setq-local prettify-symbols-alist fira-code-mode--old-prettify-alist)
  (prettify-symbols-mode -1))

(define-minor-mode fira-code-mode
  "Fira Code ligatures minor mode"
  :lighter " Fira Code"
  (setq-local prettify-symbols-unprettify-at-point 'right-edge)
  (if fira-code-mode
      (fira-code-mode--enable)
    (fira-code-mode--disable)))

(defun fira-code-mode--setup ()
  "Setup Fira Code Symbols"
  (set-fontset-font t '(#Xe100 . #Xe16f) "Fira Code Symbol"))

(provide 'fira-code-mode)

;; Mysql
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))
