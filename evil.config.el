;;; evil.config.el -*- lexical-binding: t; -*-

(use-package evil-matchit
  :config
  (global-evil-matchit-mode 1))

(evil-global-set-key 'normal (kbd "§") 'drag-stuff-up)
(evil-global-set-key 'normal (kbd "¶") 'drag-stuff-down)
