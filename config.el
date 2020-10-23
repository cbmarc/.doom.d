;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(set-frame-font "Source Code Pro 18" nil t)

;; Clipboard
(use-package clipetty
  :ensure t
  :bind ("M-w" . clipetty-kill-ring-save))

;; JS
;; (after! dtrt-indent
;;   (add-to-list 'dtrt-indent-hook-mapping-list '(typescript-mode javascript typescript-tsx-mode js2-mode typescript-indent-level)))

(use-package emacs
  :preface
  (defvar ian/indent-width 2) ; change this value to your preferred width
  :config
  (setq
    ring-bell-function 'ignore       ; minimise distraction
    frame-resize-pixelwise t
    default-directory "~/")

  (tool-bar-mode -1)
  (menu-bar-mode -1)

  ;; increase line space for better readability
  (setq-default line-spacing 3)

  ;; Always use spaces for indentation
  (setq-default indent-tabs-mode nil
                tab-width ian/indent-width))


(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save idle-change))
  (setq flycheck-highlighting-mode 'symbols)
  ;; Show indicators in the left margin
  (setq flycheck-indication-mode 'left-margin)
  (setq flycheck-idle-change-delay 0)
  (add-hook 'typescript-mode-hook 'flycheck-mode)
  (add-hook 'typescript-tsx-mode-hook 'flycheck-mode))

;; Adjust margins and fringe widths…
(defun my/set-flycheck-margins ()
  (setq left-fringe-width 8 right-fringe-width 8
        left-margin-width 1 right-margin-width 0)
  (flycheck-refresh-fringes-and-margins))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)

  ;; …every time Flycheck is activated in a new buffer
  (add-hook 'flycheck-mode-hook #'my/set-flycheck-margins)
  (eldoc-mode +1)
  ;; (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  )

(use-package company
  :ensure t
  :config
  (setq company-show-numbers t)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

(use-package company-quickhelp
  :ensure t
  :init
  (company-quickhelp-mode 1)
  (use-package pos-tip
    :ensure t))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-block-padding 2
        web-mode-comment-style 2

        web-mode-enable-css-colorization t
        web-mode-enable-auto-pairing t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        )
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
		(setup-tide-mode))))
  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))

;; (add-hook 'js2-mode-hook 'prettier-js-mode)
;; (add-hook 'web-mode-hook 'prettier-js-mode)
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'prettier-js nil 'make-it-local)))

(use-package tide
  :init
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-tsx-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         ;; (web-mode . tide-hl-identifier-mode)
         (typescript-tsx-mode . tide-hl-identifier-mode)))


;; (use-package flycheck-posframe
;;   :ensure t
;;   :after flycheck
;;   :config (add-hook 'flycheck-mode-hook
;;                     (lambda ()
;;                       (flycheck-posframe-mode)
;;                       (flycheck-posframe-configure-pretty-defaults)
;;                       (setq flycheck-posframe-position 'window-bottom-left-corner)
;;                       )))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
