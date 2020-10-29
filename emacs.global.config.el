;;; emacs.global.config.el -*- lexical-binding: t; -*-


(set-frame-font "Fira Code Retina 18" nil t)

(use-package emacs
  :preface
  (defvar small/indent-width 2) ; change this value to your preferred width
  :config
  (setq
    ring-bell-function 'ignore       ; minimise distraction
    frame-resize-pixelwise t
    default-directory "~/"))

  ;; increase line space for better readability
  (setq-default line-spacing 3)

  ;; Always use spaces for indentation
  (setq-default indent-tabs-mode nil
                tab-width small/indent-width)

(remove-hook 'minibuffer-setup-hook t)
(remove-hook 'minibuffer-exit-hook t)
