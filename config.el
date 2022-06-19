;;; config.el --- Configuration

;;; Commentary:

;;; Code:

;; Garbage Collection
(defun my-minibuffer-setup-hook ()
  "GC will never occur."
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  "GC will kick off."
  (setq gc-cons-threshold gc-cons-threshold-original))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;; Async compilations focus suppress
(setq warning-suppress-types '((comp)))

;; Ad-redef warnings off
(setq ad-redefinition-action 'accept)

;; Speed up cursor operations
(setq auto-window-vscroll nil)

;; Default custom file
(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file nil t)

;; Load custom themes in `~/.emacs.d/themes'
(when (file-exists-p (expand-file-name "themes/" user-emacs-directory))
  (setq custom-sage-themes t)
  (add-to-list 'custom-theme-load-path (expand-file-name "themes/" user-emacs-directory)))

;; No confirmation opening when symlinked file
(setq vc-follow-symlinks t)

;; Disable backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq vc-make-backup-files nil)

;; Trailing whitespace deleted on save
(add-hook 'before-save-hook
	  'delete-trailing-whitespace)

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Pager
(setenv "PAGER" "cat")

;; Ring-bell disabled
(setq ring-bell-function 'ignore)

;; Scrolling
(setq scroll-margin 0)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position 1)
(setq fast-but-imprecise-scrolling t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Copy and paste
(setq select-enable-clipboard t)
(setq save-interprogram-paste-before-kill t)

;; Paren-mode
(setq show-paren-delay 0
		show-paren-style 'parenthesis)
(show-paren-mode 1)

;; Bracket pair-matching
(setq electric-pair-pairs '((?\{ . ?\})
							  (?\( . ?\))
							  (?\[ . ?\])
							  (?\" . ?\")))
(electric-pair-mode t)

;; Indentation
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq-default indent-tabs-mode t)
(setq-default electric-indent-inhibit nil)
(setq backward-delete-char-untabify-method 'nil)
(electric-indent-mode t) ;; Auto indentation

;; C tabs, braces, subword-mode
(setq c-default-style "linux")
(setq c-basic-offset tab-width)

(global-subword-mode 1)
(add-hook 'c-mode-common-hook
	  (lambda () (subword-mode 1)))

;; Font
(add-to-list 'default-frame-alist '(font . "Monospace-10"))

;; Fill-column
(setq-default fill-column 80)

;; Linum
(setq linum-format "%4d ")

;; Show trailing whitespace
(add-hook 'prog-mode-hook
			(lambda ()
			  (setq show-trailing-whitespace t)))

;; Unique buffer and Window title
(setq-default frame-title-format '("%b"))
(setq-default uniquify-buffer-name-style 'forward)

;; Internal Border Width
(add-to-list 'default-frame-alist '(internal-border-width . 0))

;; Fill space by WM
(setq window-resize-pixelwise t)
(setq frame-resize-pixelwise t)

;; Disable default startup screen
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; GUI disabled
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode 1)

;; Fringe
(fringe-mode nil) ;; Default fringe-mode.
(setq-default fringes-outside-margins nil)
(setq-default indicate-buffer-boundaries nil)
(setq-default indicate-empty-lines nil)
(setq-default overflow-newline-into-fringe t)

;; Scrollbar on the right
(set-scroll-bar-mode 'right)

;; Column-number-mode
(column-number-mode 1)

;; Global-highlight-line-mode
(global-hl-line-mode nil)

;; Line-numbers-mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; Enable visual-line-mode for text buffers & org mode
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

;; Aliases
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Use-package

;; dired
(use-package dired
	     :straight (:type built-in)
	     :commands (dired dired-jump)
	     :bind ("C-x C-j" . dired-jump)
	     :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-open
	     :commands (dired dired-jump)
	     :config
	     (setq dired-open-extensions '(("png" . "sxiv")
					   ("jpg" . "sxiv")
					   ("pdf" . "zathura")
					   ("djvu" . "zathura"))))

;; org
(use-package org
	     :straight t
	     :config
	     (setq initial-major-mode 'org-mode
		   org-display-inline-images t
		   org-redisplay-inline-images t
		   org-image-actual-width nil
		   org-startup-with-inline-images "inlineimages"
		   org-catch-invisible-edits 'smart
		   org-pretty-entities t)

	     (setq org-src-preserve-indentation nil
		   org-adapt-indentation nil)

	     (when (file-directory-p "~/org")
	       (setq org-directory "~/org"
		     org-agenda-files (list "~/org/personal.org"
					    "~/org/school.org"
					    "~/org/work.org"))
	       	(setq org-todo-keywords
		  '((sequence "TODO"
			      "WOP"
			      "DONE"
			      "DEFERRED"
			      "CANCELLED")))

		(when (file-directory-p "~/org/roam")
		  (use-package org-roam
			       :straight t
			       :after org
			       :init
			       (setq org-roam-v2-ack t)
			       :custom
			       (org-roam-directory "~/org/roam")
			       (org-roam-db-location "~/org/roam/org-roam.db")
			       (org-id-link-to-org-use-id 'create-if-interactive)
			       :bind (("C-c n l" . org-roam-buffer-toggle)
				      ("C-c n f" . org-roam-node-find)
				      ("C-c n i" . org-roam-node-insert)
				      :map org-mode-map
				      ("C-M-i"    . completion-at-point))
			       :config
			       (org-roam-setup)))))

(add-to-list 'org-file-apps '("\.pdf" . "zathura %s"))

;; Elisp
(use-package fn        :demand t) ; function

;; Async
(use-package async
	    :straight t
	    :demand t
	    :init
	    (dired-async-mode 1)
	    :config
	    (async-bytecomp-package-mode 1)
	    (add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil))))

;; GCMH
(use-package gcmh
	     :straight t
	     :init
	     (setq gcmh-idle-delay 15
		   gcmh-high-cons-threshold (* 16 1024 1024))
	     :config (gcmh-mode))

;; Modus-themes
(use-package emacs
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))
  :config
  ;; Load the theme of your choice:
  (load-theme 'modus-operandi))


;; Diminish
(use-package diminish
	     :straight t
	     :init
	     (diminish 'auto-revert-mode "")
	     (diminish 'abbrev-mode "")
	     (diminish 'subword-mode)
	     (diminish 'visual-line-mode)
	     (diminish 'outline-mode)
	     (diminish 'gcmh-mode)
	     :config
	     (eval-after-load "eldoc" '(diminish 'eldoc-mode))
	     (eval-after-load "c-mode" '(diminish 'c-mode))
	     (eval-after-load "c++-mode" '(diminish 'c++-mode))
	     (eval-after-load "which-key" '(diminish 'which-key-mode))
	     (eval-after-load "org" '(diminish 'org-indent-mode))
	     (eval-after-load "outline" '(diminish 'outline-minor-mode))
	     (eval-after-load "dired" '(diminish 'dired-async-mode))
	     (eval-after-load "dired" '(diminish 'dired-hide-dotfiles-mode))
	     (eval-after-load "dired" '(diminish 'all-the-icons-dired-mode))
	     (eval-after-load "magit" '(diminish 'auto-fill-mode ""))
	     (eval-after-load "magit" '(diminish 'with-editor-mode ""))
	     (eval-after-load "auto-revert-mode" '(diminish 'auto-revert-mode "")))

;; Golden-ratio
(use-package golden-ratio)

;; Rainbow-mode
(use-package rainbow-mode
	     :straight t
	     :diminish rainbow-mode
	     :hook prog-mode)

;; Rainbow-delimiters
(use-package rainbow-delimiters
	     :straight t
	     :hook (prog-mode . rainbow-delimiters-mode))

;; org-auto-tangle
(use-package org-auto-tangle
	     :straight t
	     :defer t
	     :diminish org-auto-tangle-mode
	     :hook (org-mode . org-auto-tangle-mode))

;; so-long
(use-package so-long
	     :defer t
	     :straight t
	     :bind
	     (:map so-long-mode-map
		   ("C-s" . isearch-forward)
		   ("C-r" . isearch-backward))
	     :config (global-so-long-mode 1))

;; yasnippet
(use-package yasnippet
	     :straight t
	     :diminish yas-minor-mode
	     :hook
	     ((cc-mode c-lang-common cmake-mode c++-mode c-mode
		       emacs-lisp-mode git-commit-mode fundamental-mode
		       makefile-mode makefile-automake-mode org-mode prog-mode
		       python-mode text-mode) . yas-minor-mode)
	     :config
	     (yas-reload-all))

(use-package yasnippet-snippets
	     :after yasnippet
	     :straight t)

(use-package consult-yasnippet
	     :straight t
	     :after (consult yasnippet)
	     :bind ("C-c y" . consult-yasnippet))

;; dashboard
(use-package dashboard
  :straight t
  :diminish dashboard-mode
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-items '((recents . 5)
						))
;; evil-mode
(use-package evil
  :straight t
  :defer nil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  ;; enable evil-mode
  (evil-mode 1)

  ;; more granular undo with evil
  (setq evil-want-fine-undo t)

  ;; set evil state on a per mode basis
  ;; insert
  (evil-set-initial-state 'vterm-mode 'insert)
  ;; normal
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  ;; emacs
  (evil-set-initial-state 'term-mode 'emacs)
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'inferior-scheme-mode 'emacs)

  ;; <tab> cycles org-mode visiblity
  (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)

  ;; :q kills buffer
  (evil-ex-define-cmd "q" 'delete-window))

;; flycheck
(use-package flycheck
	     :straight t
	     :hook (prog-mode . flycheck-mode))

;; htmlize
(use-package htmlize
	     :straight t)

;; magit
(use-package magit
	     :straight t)

;; which-key
(use-package which-key
	     :straight t
	     :init
	     (which-key-mode)
	     :config
	     (setq which-key-idle-dely 0.3))

;; switch-window
(use-package switch-window
	     :straight t
	     :config
	     (setq switch-window-input-style 'minibuffer)
	     (setq switch-window-increase 4)
	     (setq switch-window-threshold 2)
	     (setq switch-window-shortcut-style 'qwerty)
	     (setq switch-window-qwerty-shortcuts
		   '("a" "s" "d" "f" "j" "k" "l"))
	     :bind
	     ("C-x o" . switch-window))

;; dabbrev
(use-package dabbrev
	     :straight t
	     :bind (("M-/" . dabbrev-completion)
		    ("C-M-/" . dabbrev-expand)))

;; Corfu
(use-package corfu
	     :straight t
	     :demand t
	     :bind (:map corfu-map
			 ("<escape>". corfu-quit)
			 ("<return>" . corfu-insert)
			 ("C-h" . corfu-show-documentation)
			 ("M-l" . 'corfu-show-location)
			 ("RET" . nil)
			 ("TAB" . corfu-next)
			 ([tab] . corfu-next)
			 ("S-TAB" . corfu-previous)
			 ([backtab] . corfu-previous))
	     :custom
	     (corfu-auto t)
	     (corfu-auto-prefix 3)
	     (corfu-auto-delay 0)
	     (corfu-echo-documentation 0)
	     (corfu-preview-current nil)
	     (corfu-quit-no-match 'separator)
	     (corfu-separator ?\s)
	     :init (global-corfu-mode)
	     :config
	     (defun contrib/corfu-enable-always-in-minibuffer ()
	       (unless (bound-and-true-p vertico--input)
		 (corfu-mode 1)))
	     (add-hook 'minibuffer-setup-hook #'contrib/corfu-enable-always-in-minibuffer 1))

;; cape
(use-package cape
	     :straight t
	     :bind (("C-c p p" . completion-at-point)
		    ("C-c p d" . cape-dabbrev)
		    ("C-c p f" . cape-file)
		    ("C-c p s" . cape-symbol)
		    ("C-c p i" . cape-ispell))
	     :config
	     (setq cape-dabbrev-min-length 3)
	     (dolist (backend '( cape-symbol cape-keyword cape-file cape-dabbrev))
	       (add-to-list 'completion-at-point-functions backend)))

;; vertico
(use-package vertico
	     :straight (:files (:defaults "extensions/*"))
	     :bind (:map vertico-map
			 ("C-j" . vertico-next)
			 ("C-k" . vertico-previous)
			 ("M-j" . vertico-next)
			 ("M-k" . vertico-previous)
			 ("C-f" . vertico-exit)
			 :map minibuffer-local-map
			 ("M-h" . backward-kill-word))
	     :custom
	     (vertico-cycle t)
	     (vertico-resize t)
	     :init
	     (vertico-mode)
	     :config
	     (vertico-mouse-mode))

(use-package vertico-directory
	     :straight nil
	     :load-path "straight/repos/vertico/extensions"
	     :after vertico
	     :ensure nil
	     :bind (:map vertico-map
			 ("RET" . vertico-directory-enter)
			 ("DEL" . vertico-directory-delete-char)
			 ("M-DEL" . vertico-directory-delete-word)))

;; orderless
(use-package orderless
	     :straight t
	     :init
	     (setq completion-styles '(orderless basic)
		   completion-category-defaults nil
		   completion-category-overrides '((file (styles basic partial-completion)))))

;; marginalia
(use-package marginalia
	     :straight t
	     :after vertico
	     :init
	     (marginalia-mode))

;; Emacs adjustment to completion
(use-package emacs
	     :init
	     (defun crm-indicator (args)
	       (cons (concat "[CRM] " (car args)) (cdr args)))
	     (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

	     (setq minibuffer-prompt-properties
		   '(read-only t cursor-intangible t face minibuffer-prompt))
	     (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

	     (setq read-extended-command-predicate
		   #'command-completion-default-include-p)

	     (setq enable-recursive-minibuffers t)
	     (setq completion-ignore-case t)
	     (setq read-file-name-completion-ignore-case t)

	     (setq resize-mini-windows t))

;; deadgrep
(use-package deadgrep
	     :straight t
	     :commands deadgrep)

;; avy
(use-package avy
	     :straight t
	     :bind
	     ("M-s" .avy-goto-char))

;; deft
(when (file-directory-p "~/org")
  (use-package deft
	       :straight t
	       :config
	       (setq deft-directory org-directory
		     deft-recursive t
		     deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
		     deft-use-filename-as-title t)
	       :bind
	       ("C-c n d" . deft)))

;; C/C++
(use-package modern-cpp-font-lock
	     :straight t)

;; CLisp
(use-package slime
	     :straight t
	     :config
	     (setq inferior-lisp-program "/usr/bin/sbcl")
	     (setq slime-contribs '(slime-fancy slime-quicklisp)))

;; Python
(use-package python-mode
	     :straight t
	     :config
	     (setq python-indent-offset standard-indent)
	     (setq python-indent-guess-indent-offset t)
	     (setq python-indent-guess-indent-offset-verbose nil))

;;; Functions
(defun xah-open-in-external-app (&optional @fname)
  "Open the current file or dired marked files in external app.
When called in emacs lisp, if @fname is given, open that.
URL `http://xahlee.info/emacs/emacs/emacs_dired_open_file_in_ext_apps.html'
Version 2019-11-04 2021-02-16"
  (interactive)
  (let* (
         ($file-list
          (if @fname
              (progn (list @fname))
            (if (string-equal major-mode "dired-mode")
                (dired-get-marked-files)
              (list (buffer-file-name)))))
         ($do-it-p (if (<= (length $file-list) 5)
                       t
                     (y-or-n-p "Open more than 5 files? "))))
    (when $do-it-p
      (cond
       ((string-equal system-type "gnu/linux")
        (mapc
         (lambda ($fpath) (let ((process-connection-type nil))
                            (start-process "" nil "xdg-open" $fpath))) $file-list))))))

(defun external-shell-in-dir()
  (interactive)
  (start-process "xterm" nil "xterm"))

;;; Keybindings
(global-set-key (kbd "C-c C-o") #'xah-open-in-external-app)
(global-set-key (kbd "C-c C-t") #'external-shell-in-dir)
(global-set-key (kbd "C-x b") 'ibuffer)
(global-set-key (kbd "C-x C-d") 'dired)
(global-set-key (kbd "C-c a") 'org-agenda)

(provide 'config)
;;; config.el ends here
