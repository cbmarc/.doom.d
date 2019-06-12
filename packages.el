;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)
;;(package! org-gcal :recipe (:fetcher github :repo "cbmarc/org-gcal.el"))
(package! org-gcal)

;; Themes
(package! zenburn-theme)
(package! solarized-theme)
(package! spacemacs-theme)
(package! color-theme-sanityinc-tomorrow)
(package! leuven-theme)
(package! color-theme-sanityinc-solarized)
(package! material-theme)

;; Org mode
(package! ox-slack :recipe (:fetcher github :repo titaniumbones/ox-slack))
(package! org-projectile)
(package! htmlize)

;; Groovy
(package! groovy-mode)

;; Yamel
(package! yaml-mode)
