;;; languages.config.el -*- lexical-binding: t; -*-

(defun my/lsp-javascript-install-save-hooks ()
  (lsp)
  (lsp-ui-mode 1)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-semantic-highlighting nil)
  (setq web-mode-enable-current-element-highlight nil)
  (setq web-mode-enable-current-column-highlight nil)
  (global-hl-line-mode -1)
  (hl-line-mode -1)
  (add-hook 'before-save-hook prettier-js nil 'local))

(add-hook 'typescript-tsx-mode-hook
          'my/lsp-javascript-install-save-hooks)

(defun maybe-use-prettier ()
  "Enable prettier-js-mode if an rc file is located."
  (if (locate-dominating-file default-directory ".prettierrc")
      (prettier-js-mode +1)))

(add-hook 'typescript-mode-hook 'maybe-use-prettier nil 'local)
(add-hook 'js2-mode-hook 'maybe-use-prettier nil 'local)
(add-hook 'typescript-tsx-mode-hook 'maybe-use-prettier nil 'local)
(add-hook 'scss-mode-hook 'maybe-use-prettier nil 'local)

