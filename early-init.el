;;; early-init.el --- Early Initialization

;;; Code:

;; Garbage Collection
;; GC threshold
(setq gc-cons-percentage-original gc-cons-percentage
      gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 0.5)

;; Silence compiler warnings
(setq warning-minimum-level :emergency)
(setq warning-suppress-types '((comp)))
(setq comp-async-report-warnings-errors nil)
(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local cl-functions))

;; Warning; with 3, dangerous optimizations
(setq-default native-comp-seed 3)

;; Unwanted runtime compilation for gccemacs users
(setq native-comp-deferred-compilation nil)

;; Initialization occurs before `user-init-file', but after `early-init-file'
(setq package-enable-at-startup nil)

;; In noninteractive sessions, prioritize non-byte-compiled source files to prevent the use of stale byte-codes. Saves little IO time, skip mtime checks on *.elc file
(setq load-prefer-newer noninteractive)

;; Disable GUI elements
(setq tool-bar-mode nil
      menu-bar-mode nil
	  scroll-bar-mode nil)

;; Resizing at startup faster
(setq frame-inhibit-implied-resize t)

;; Ignore X resources
(advice-add #'x-apply-session-resources :override #'ignore)

;; Slow Emacs "updates" UI
(setq idle-update-delay 1.0)

;; Disable bidirectional text scanning
(setq-default bidi-siplay-reording 'left-to-right
	      bidi-paragraph-direction 'left-to-right)

;; Misc optimizations
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)

;;; early-init.el ends here
