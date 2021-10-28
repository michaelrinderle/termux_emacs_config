;; -*- lexical-binding: t; -*-


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL CONFIGURATIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; VERSIONING

(if (version< emacs-version "24.4")
  (error "Config riquires v%s or higher" minver)
  (if (version< emacs-version "26.1")
    (message "config limited in functions, < 26.1")))

;; FONTSETS

(set-face-attribute 'default nil
                    :font "source code pro"
                    :weight 'normal
                    :height 90)

(setq line-spaceing 1.5)

;; GLOBAL VARIABLE SETS

(setq
 user-full-name                            "michael g rinderle"
 user-mail-address                         "michael@sofdigital.net"
 column-number-mode                        t
 cua-enable-cua-keys                       nil
 cua-mode                                  t
 debug-on-error                            t
 display-line-numbers-type                 'relative
 echo-keystrokes                           1e-6                ;; display keys in the echo area asap
 gc-cons-percentage                        0.3
 gc-cons-threshold                         (* 4 1024 1024)
 global-hl-line-mode                       t
 gnutls-min-prime-bits                     1024                ;; suppress df 256 bit warning
 inhibit-compacting-font-caches            t
 inhibit-default-init                      t
 inhibit-splash-screen                     t
 inhibit-startup-buffer-menu               nil
 native-comp-async-report-warnings-errors  nil                 ;; silence compiler warnings
 make-backup-files                         nil                 ;; prevent creating a bckup file filename~
 ring-bell-function                        'ignore             ;; disable alarms
 site-run-file                             nil)

;; TERMUX SETTINGS
(xterm-mouse-mode t)
(global-set-key [mouse-4] '(lambda ()
(interactive)
(scroll-down 1)))
(global-set-key [mouse-5] '(lambda ()
(interactive)
(scroll-up 1)))

;; GLOBAL ENVIRONMENT SETTINGS

;; (desktop-save-mode 1)                                        ;; session storage
(display-time)                                                  ;; display time in mode-line
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'kill-ring)
(tab-bar-mode 1)                                                ;; show tab bar
(menu-bar-mode -1)                                              ;; hide menubar
;; (tool-bar-mode -1)                                              ;; hide toolbar
;; (toggle-scroll-bar -1)                                          ;; hide scrollbars
(line-number-mode t)                                            ;; show lines
(global-hl-line-mode t)                                         ;; highlight current line
(show-paren-mode t)                                             ;; highlight matching current bracket match
(turn-on-auto-fill)                                             ;; auto-wrap at 80 characters
(set-default-coding-systems 'utf-8)                             ;; default utf-8

(setq-default fill-column 80)
(setq-default auto-fill-function 'do-auto-fill)
(setq-default                                                   ;; search settings
 case-fold-search t                                             ;; case insensitive searches by default
  search-highlight t)                                           ;; hmatches when searching

(setq-default tab-width 2)                                      ;; tab settings
(setq-default indent-tabs-mode nil)

(setq epa-pinentry-mode 'loopback)                              ;; gpg pinentry

;; (run-with-idle-timer 5 t (lamda () save-some-buffers t))     ;; autosave every nth (5)

;; WARNINGS DISABLED

(setq byte-compile-warnings '(cl-functions))

;; OPTIMIZATION

(setq read-process-output-max (* 1024 1024)                     ;; io optimization
      gc-cons-threshold most-positive-fixnum                    ;; Minimize garbage collection during startup
      gc-cons-threshold (* 50 1000 1000))

(setq user-emacs-directory (expand-file-name "~/.cache/emacs/") ;; keep litter out of emacs.d
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; CUSTOMIZATION

(customize-set-variable 'tabbar-separator '(.8))                ;; tabbar customization


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; CONFIGURATION

(defvar current-user                                             ;; get user
  (getenv
    (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(defvar base-path t)                                             ;; set base path determined by os
(cond ((equal system-type 'windows-nt)                           ;; setting base emacs cloud path
       (setq base-path "c:/"))                                  ;; setting windows base path
      ((equal system-type 'gnu/linux)
       (when (string-match "Linux.*Microsoft.*Linux"
                           (shell-command-to-string "uname -a"))
         (setq base-path "/")))                                   ;; set wsl/linux base path
      ((equal system-type 'darwin
              (setq base-path "/idk/emacs"))))                         ;; set unknown osx path

(defun load-configuration ()
  "Load configuration file."
  (interactive)
  (find-file "/storage/emulated/0/Cloud/.emacs"))


(defun load-userspace-file (f)
  "Load userspace file."
  (interactive)
  (find-file f))

;; CUSTOM METHODS

(defun kill-buffers ()
  "Kill all buffers in window."
  (interactive)
  (mapc 'kill-buffer (cdr (buffer-list (current-buffer)))))

(defun fold-toggle ()
  "Fold toggle for folding purposes."
  (interactive)
  (save-excursion
    (end-of-line)
    (hs-toggle-hiding)))

;; (defun toggle-split()
;;   "Toggle window split."
;;   (interactive
;;   (if (> (length (window-list)) 2)
;;       (error "Can't toggle with more than 2 windows!")
;;     (let ((func (if (window-full-height-p)
;;                     #'split-window-vertically
;;                   #'split-window-horizontally)))
;;       (delete-other-windows)
;;       (funcall func)
;;       (save-selected-window
;;         (other-window 1)
;;         (switch-to-buffer (other-buffer)))))))

(defun strike-through-region (b e)
  "Strike through selected region."
  (interactive "r")
  (when (use-region-p)
    (save-mark-and-excursion
      (goto-char b)
      (while (and (<= (point) e)
                  (not(eobp)))
        (unless (looking-back "[[:space:]]" (1 -(point)))
          (insert-char #x336)
          (setq e (1+e)))
        (forward-char 1)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (add-hook 'emacs-startup-hook 'org-agenda)                       ;; start treemacs dir on startup
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda () (auto-fill-mode -1)))        ;; disable auto-fill-mode in programming mode

(add-hook 'emacs-startup-hook                                     ;; Lower threshold back to 8 MiB (default is 800kB)
  (lambda ()
    (setq gc-cons-threshold (expt 2 23))))

(add-hook 'emacs-startup-hook                                     ;; display startup time
 (lambda ()
   (message "%s w %d gcs." (format "%.2f seconds"
   (float-time (time-subtract after-init-time before-init-time))) gcs-done)))

(add-hook 'image-mode-hook
  (lambda ()
    (auto-revert-mode)
    (auto-image-file-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE MANAGEMENT (STRAIGHT.EL)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar bootstrap-version)                                        ;; straight.el bootstrap entry point
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(defmacro use-feature (name &rest args)
  "Like `use-package', but with `straight-use-package-by-default' disabled."
  (declare (indent defun))
  `(use-package ,name
     :straight nil
     ,@args))

(require 'straight-x)
(straight-use-package 'use-package)
(setq straight-use-package-by-default t
      use-package-always-defer t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PLUGINS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ace-jump-mode 
  :straight t)

(use-package alert
  :straight t
  :config
  (setq alert-default-style 'notification))

(use-package all-the-icons 
  :straight t)

(use-package auto-complete
  :straight t
  :config
  (require 'auto-complete-config)
  (add-hook 'python-mode-hook 'auto-complete-mode))

(use-package benchmark-init
  :straight t
  :hook (after-init . benchmark-init/deactivate))

(use-package calfw
  :straight t
  :demand t
  :commands cfw:open-org-calendar
  :config
  (setq
   cfw:fchar-junction ?╋
   cfw:fchar-vertical-line ?┃
   cfw:fchar-horizontal-line ?━
   cfw:fchar-left-junction ?┣
   cfw:fchar-right-junction ?┫
   cfw:fchar-top-junction ?┯
   cfw:fchar-top-left-corner ?┏
   cfw:fchar-top-right-corner ?┓))

(use-package calfw-cal
  :straight t
  :demand t
  :config 
  (setq diary-list-include-blanks nil))

(use-package calfw-org
  :straight t
  :demand t
  :config
  (setq cfw:org-agenda-schedule-args '(:timestamp)))

(use-package dired
  :straight (:type built-in)
  :demand t
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package doom-modeline
  :straight t
  :demand t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 5
        doom-modeline-modal-icon t
        doom-modeline-bar-width 5
        doom-modeline-mu4e t))
  ;; (mu4e-alert-enable-mode-line-display))

(use-package doom-themes                                ;; theme related plugins
  :straight t
  :demand t
  :config
  (load-theme 'doom-Iosvkem t)
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  ;; doom-themes-treemacs-theme "doom-atom")     ;; doom theme variable
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package emojify
  :straight t
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(use-package eshell
  :straight t
  :init
  (global-linum-mode t)
  (setq eshell-directory-name "~/.dotfiles/.emacs.d/eshell/"
        eshell-aliases-file (expand-file-name "~/.dotfiles/.emacs.d/eshell/alias")))

(use-package eshell-syntax-highlighting
  :straight t
  :after esh-mode
  :config
  (eshell-syntax-highlighting-global-mode +1))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package evil
  :straight t
  :init (setq evil-want-integration t
              evil-want-keybinding nil
              evil-want-C-u-scroll t
              evil-want-Y-yank-to-eol t
              evil-split-window-below t
              evil-vsplit-window-right t
              evil-respect-visual-line-mode t
              evil-undo-system 'undo-tree)
  :config
  ;; (add-hook 'evil-mode-hook 'ein/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (setq-default tab-width 2)
  (setq-default evil-shift-width tab-width)
  (setq-default indent-tabs-mode nil))

(use-package evil-commentary
  :straight t
  :demand t
  :config
  (evil-commentary-mode))

(use-package evil-collection
  :straight t
  :after (evil helm mu4e)
  :config
  (evil-collection-init)
  (setq evil-collection-company-use-tng nil)                          ;; bug in evil-collection
  (delete 'lispy evil-collection-mode-list)
  (delete 'org-present evil-collection-mode-list))

(use-package evil-org
  :straight t
  :demand t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-mode 1)
  (setq-default evil-shift-width tab-width)
  (setq evil-want-C-i-jump nil)
  (add-to-list 'load-path "~/.emacs.d/plugins/evil-org-mode")
  (add-hook 'org-mode-hook 'evil-org-mode)
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (evil-org-agenda-set-keys))

(use-package fzf
  :straight t
  :demand t
  :config
  (defun fzf-find-file (&optional directory)
    (interactive)
    (let ((d (fzf/resolve-directory directory)))
      (fzf
       (lambda (x)
         (let ((f (expand-file-name x d)))
           (when (file-exists-p f)
             (find-file f))))
       d))))

(use-package general
  :straight t
  :config
  (general-evil-setup t)
  (general-create-definer ein/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-M")
  (general-create-definer ein/ctrl-c-keys
    :prefix "C-c"))

(use-package helm
  :straight t
  :bind (("M-x"     . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b"   . helm-buffers-list)
         ("C-x c o" . helm-occur)) ;SC
  ("M-y"     . helm-show-kill-ring) ;SC
  ("C-x r b" . helm-filtered-bookmarks) ;SC
  :requires helm-config
  :config
  (helm-mode 1)
  (defun ein/helm-find-file-recursive ()
    (interactive)
    (helm-find 'ask for dir)))

(use-package hydra
  :straight t
  :config
  (global-linum-mode -1)
  (defhydra hydra-text-scale (:timeout 4)
    ("j" text-scale-increase "in")
    ("k" text-scale-decrease "out")
    ("f" nil "finish" :exit t)))

(use-package magit :straight t)

(use-package mode-icons
  :straight t 
  :demand t)

(use-package org
  :straight t
  :config
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil)

  ;; (setup org-faces
  ;; ;; Make sure org-indent face is available
  ;; (:also-load org-indent)
  ;; (:when-loaded
  ;;   ;; Increase the size of various headings
  ;;   (set-face-attribute 'org-document-title nil :font "open source pro" :weight 'bold :height 1.3)

  ;;   (dolist (face '((org-level-1 . 1.2)
  ;;                   (org-level-2 . 1.1)
  ;;                   (org-level-3 . 1.05)
  ;;                   (org-level-4 . 1.0)
  ;;                   (org-level-5 . 1.1)
  ;;                   (org-level-6 . 1.1)
  ;;                   (org-level-7 . 1.1)
  ;;                   (org-level-8 . 1.1)))
  ;;     (set-face-attribute (car face) nil :font "open source pro" :weight 'medium :height (cdr face)))

  ;;   ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  ;;   (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  ;;   (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  ;;   (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  ;;   (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  ;;   (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  ;;   (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  ;;   (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  ;;   (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  ;;   (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;;   ;; Get rid of the background on column views
  ;;   (set-face-attribute 'org-column nil :background nil)
  ;;   (set-face-attribute 'org-column-title nil :background nil)))

  (setq
   org-adapt-indentation nil
   org-cycle-separator-lines 2
   org-edit-src-content-indentation 2
   org-ellipsis " ▾"
   org-fontify-quote-and-verse-blocks t
   org-hide-block-startup nil
   org-hide-emphasis-markers t
   org-hide-leading-stars t
   org-image-actual-width nil
   org-image-actual-width nil
   org-src-fontify-natively t
   org-src-preserve-indentation nil
   org-src-tab-acts-natively t
   org-startup-folded 'content
   org-startup-truncated 1
   org-tags-column 75
   org-tags-column 75
   org-startup-truncated 1
   org-modules '(org-crypt
                 org-habit
                 org-bookmark
                 org-eshell)
   org-refile-targets '((nil :maxlevel . 1)
                        (org-agenda-files :maxlevel . 1))
   org-outline-path-complete-in-steps nil
   org-refile-use-outline-path t)

  (set-face-attribute 'org-document-title nil :font "source code pro" :weight 'bold :height 1.3)

  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "source code pro" :weight 'medium :height (cdr face)))

  (require 'org-indent)             ;; make sure org-indent face is available

  ;; ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;; get rid of the background on column views
  (set-face-attribute 'org-column nil :background nil)
  (set-face-attribute 'org-column-title nil :background nil)
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

  (setq org-todo-keywords
        '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELED")))

  (setq org-todo-keyword-faces
        '(("TODO" . "pink")
          ("IN-PROGRESS" . "orance")
          ("WAITING" . "magenta")
          ("CANCELED" . "red")
          ("DONE" . "green")
          ("CANCELED" . "grey")))

  (setq org-log-note-headings '((done        . "CLOSING NOTE %t")
                                (state       . "State %-12s from %-12S %t")
                                (note        . "Note taken on %t")
                                (reschedule  . "Schedule changed on %t: %S -> %s")
                                (delschedule . "Not scheduled, was %S on %t")
                                (redeadline  . "Deadline changed on %t: %S -> %s")
                                (deldeadline . "Removed deadline, was %S on %t")
                                (refile      . "Refiled on %t")
                                (clock-out   . "")))

  ;; add org src languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp t)))

  (setq org-babel-python-command "python3"
        org-confirm-babel-evaluate nil)

  ;; org mode src snippets
  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("li" . "src lisp"))
  (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
  (add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("go" . "src go"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))


  ;; set org directory
  (setq org-directory "/storage/emulated/0/Cloud/org/")
  (setq org-contacts-files "/storage/emulated/0/Cloud/org/records/contacts.org")
  (setq org-default-notes-file "/storage/emulated/0/Cloud/org/records/todo.org")

  ;; org agenda

(setq org-agenda-prefix-format
      (quote
       ((agenda . "%-20c%?-20t% s")
        (timeline . "% s")
        (todo . "%-20c")
        (tags . "%-20c")
        (search . "%-20c"))))

(setq org-agenda-inhibit-startup t)
(setq org-agenda-deadline-leaders (quote ("!D!: " "D%2d: " "")))
(setq org-agenda-scheduled-leaders (quote ("" "S%3d: ")))
(setq org-agenda-files (directory-files-recursively "/storage/emulated/0/Cloud/org/" "\\.org$"))
(setq org-agenda-start-on-weekday nil)

(setq org-capture-templates
  `(("t" "Todo" entry (file+headline "/storage/emulated/0/Cloud/org/records/todo.org" "Records") "**** TODO %?\n%a")
    ("a" "Appointment" entry (file+headline "/storage/emulated/0/Cloud/org/records/appointments.org" "Records") "**** Appointment %?\n:CREATED: %U\n:DATE:\n:EVENT:\n:CONTACT:\n:PHONE:\n:ADDRESS:\n:NOTES:\n:END:\n\n")
    ("c" "Contact" entry (file+headline "/storage/emulated/0/Cloud/org/records/contacts.org" "Records") "*%(org-contacts-template-name)\n:ADDRESS: %^{289 Cleveland St. Brooklyn, 11206 NY, USAy}\:BIRTHDAY:%^{yyyy-mm-dd}\n:EMAIL:%(org-contacts-template-email)\n:PHONE: %^{PHONE}\n:NOTE: %^{NOTE}\n:TAGS:%^{TAGS}\n:END:\n\n")
    ("o" "Opportunity" entry (file+headline "/storage/emulated/0/Cloud/org/records/opportunitys.org" "Record") "* Opportunity\n:COMPANY:\n:CREATED: %U\n:LINK:\n:POSITION:\n:PAY:\n:CONTACT:\n:NOTES:\n:END::\n\n"))))

(use-package org-journal
  :straight t
  :config
  (require 'org-journal)
  (setq org-journal-dir "/storage/emulated/0/Cloud/org/journal"))

(use-package org-roam
  :straight t
  :init
  (setq org-roam-v2-ack t)
  (setq ein/daily-note-filename "%<%Y-%m-%d>.org"
        ein/daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<%Y-%B>]]\n\n")
  :custom
  (org-id-values "/storage/emulated/0/Cloud/org/wiki/.org-id-locations")
  (org-roam-directory "/storage/emulated/0/Cloud/org/wiki/")
  (org-roam-dailies-directory "/storage/emulated/0/Cloud/org/wiki/journal")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :unnarrowed t)))
  (org-roam-dailies-capture-templates
   `(("d" "default" entry
      "* %?"
      :if-new (file+head ,ein/daily-note-filename
                         ,ein/daily-note-header))
     ("t" "task" entry
      "* TODO %?\n  %U\n  %a\n  %i"
      :if-new (file+head+olp ,ein/daily-note-filename
                             ,ein/daily-note-header
                             ("Tasks"))
      :empty-lines 1)
     ("l" "log entry" entry
      "* %<%I:%M %p> - %?"
      :if-new (file+head+olp ,ein/daily-note-filename
                             ,ein/daily-note-header
                             ("Log")))

     ("o" "opportunity" entry
      "* %<%I:%M %p> - Opportunity\n:COMPANY:\n:CREATED: %U\n:LINK:\n:POSITION:\n:PAY:\n:CONTACT:\n:NOTES:\n:END:\n\n"
      :if-new (file+head+olp ,ein/daily-note-filename
                             ,ein/daily-note-header
                             ("Log")))

     ("j" "journal" entry
      "* %<%I:%M %p> - Journal  :journal:\n\n%?\n\n"
      :if-new (file+head+olp ,ein/daily-note-filename
                             ,ein/daily-note-header
                             ("Log")))
     ("m" "meeting" entry
      "* %<%I:%M %p> - %^{Meeting Title}  :meetings:\n\n%?\n\n"
      :if-new (file+head+olp ,ein/daily-note-filename
                             ,ein/daily-note-header
                             ("Log")))))
  :bind (("C-c n l"   . org-roam-buffer-toggle)
         ("C-c n f"   . org-roam-node-find)
         ("C-c n d"   . org-roam-dailies-find-date)
         ("C-c n c"   . org-roam-dailies-capture-today)
         ("C-c n C r" . org-roam-dailies-capture-tomorrow)
         ("C-c n t"   . org-roam-dailies-goto-today)
         ("C-c n y"   . org-roam-dailies-goto-yesterday)
         ("C-c n r"   . org-roam-dailies-goto-tomorrow)
         ("C-c n g"   . org-roam-graph)
         :map org-mode-map
         (("C-c n i" . org-roam-node-insert)
                                        ;("C-c n I" . org-roam-insert-immediate
          ))
  :config
  (org-roam-db-autosync-mode))

(use-package org-ref
  :straight t
  :config
  (setq reftex-default-bibliography '("/storage/emulated/0/Cloud/org/records/references.bib")))

(use-package org-superstar
  :straight t
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package projectile
  :straight t
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package rainbow-delimiters
  :straight t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (set-face-attribute 'rainbow-delimiters-unmatched-face nil
                      :foreground "red"
                      :inherit 'error
                      :box t))

(use-package smartparens
  :straight t
  :hook (prog-mode . smartparens-mode))

(use-package super-save
  :straight t
  :defer 1
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(use-package treemacs
  :straight t
  :ensure t
  :config
  (treemacs-load-theme "Default")
  (setq treemacs-width-lock nil
        ;; treemacs-width      23
        treemacs-window-size-fixed nil
        treemacs-toggle-fixed-width t)
  (with-eval-after-load 'treemacs
    (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)))

(use-package treemacs-all-the-icons :straight t)

(use-package treemacs-evil :straight t)

(use-package undo-tree
  :straight t
  :config
  (global-undo-tree-mode 1)
  (global-set-key (kbd "C-z") 'undo)                    ;; make ctrl-z undo
  (defalias 'redo 'undo-tree-redo)                      ;; make ctrl-Z redo
  (global-set-key (kbd "C-S-z") 'redo))

(use-package which-key
  :straight t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEYBINDINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GLOBAL KEYBINDINGS

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)         ;; esc cancels all
(global-set-key (kbd "C-M-u") 'univeral-argument)               ;; rebind C-u

(global-set-key [M-left] 'tabbar-backward-tab)                  ;; easy tab navigation
(global-set-key [M-right] 'tabbar-forward-tab)

(global-set-key (kbd "C-c m c") 'mc/edit-lines)                 ;; multiple cursors

;; GLOBAL ORG KEYBINDINGS

(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])

(global-set-key [(meta up)] 'org-table-move-row-up)
(global-set-key [(meta down)] 'org-table-move-row-down)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)

;; EVIL KEYBINDINGS

(ein/leader-keys

  ;; application leaders
  "m"   '(hydra-buffer-menu/body :which-key "menu")
  "h"   '(helm-M-x :which-key "helm")

  ;; ace jump leaders
  "aw"   '(ace-jump-word-mode :whick-key "ace word")
  "ac"   '(ace-jump-char-mode :which-key "ace char")

  ;; dap leaders
  "de"  '(dap-mode :which-key "dap-mode")
  "dd"  '(dap-debug :which-key "dap-debug")

  ;; load leaders
  "lf"  '(load-file :which-key "load file")
  "lc"  '(load-configuration :which-key "load config")
  "le"  '(eshell :which-key "load eshell")
  "lm"  '(mu4e   :which-key "load mail")

  ;; tab leaders
  "tn"  '(tab-new :which-key "tab new")
  "tx"  '(tab-next :which-key "tab next")
  "tc"  '(tab-close :which-key "tab close")
  "tm"  '(tab-move :which-key "tab move")

  ;; toggle leaders
  "tt"  '(treemacs :which-key "toggle treemax")
  "tw"  '(treemacs-toggle-fixed-width :which-key "toggle treemacs width")
  "tan" '(origami-toggle-all-nodes :which-key "toggle all nodes")
  "tn"  '(origami-toggle-node :which-key "toggle no")

  ;; split leaders
  "sh"  '(split-window-horizontally :which-key "split horizontally")
  "sv"  '(split-window-vertically :which-key "split vertically")

  ;; org leaders
  "od"  '(org-time-stamp :which-key "org-time-stamp")
  "ot"  '(org-todo-list :which-key "todos")
  "oc"  '(org-capture t :which-key "capture")
  "ox"  '(org-export-dispatch t :which-key "export")
  "oa"  '(org-agenda :which-key "status")
  "ol"  '(cfw:open-org-calendar :which-key "calendar")

  ;; file leaders
  "ff"  '(fzf :which-key "find file")

  ;; eshell leaders
  "et"  '(eshell-toggle :which-key "eshell-toggle"))

(ein/ctrl-c-keys
  "p" '(hydra-text-scale/body :which-key "scale text")
  "t" '(fold-toggle :which-key "fold toggle"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STARTUP MENU
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defhydra hydra-buffer-menu (:color pink
                             :hint nil)
  "

  ^App^              ^File^              ^Org^             ^Captures
  ^^^^^^^^-----------------------------------------------------------------
  _a_: Agenda        _o_: Open          _M_: Master        _T_: Todos
  _c_: Calendar      _n_: New           _P_: Programming   _O_: Opportunity
  _r_: Roam          ^ ^                _D_: Admin         _C_: Contacts
  _e_: eShell        ^ ^                _X_: Medical
"
  ("a" org-agenda-list)
  ("c" cfw:open-org-calendar)
  ("m" mu4e)
  ("e" eshell)
  ("r" org-capture)
  ("o" find-file)
  ("n" (write-region "" nil custom-file))
  ("M" (load-userspace-file "/storage/emulated/0/Cloud/org/wiki/master.org"))
  ("P" (load-userspace-file "/storage/emulated/0/Cloud/org/wiki/tech/programming.org"))
  ("D" (load-userspace-file "/storage/emulated/0/Cloud/org/wiki/tech/administration.org"))
  ("X" (load-userspace-file "/storage/emulated/0/Cloud/org/wiki/personal/medical.org"))
  ("T" (load-userspace-file "/storage/emulated/0/Cloud/org/notes.org"))
  ("O" (load-userspace-file "/storage/emulated/0/Cloud/org/records/opportunity.org"))
  ("C" (load-userspace-file "/storage/emulated/0/Cloud/org/records/contacts.org"))
  ("s" nil "stall")
  ("q" quit-window "quit" :color blue))


(add-hook 'emacs-startup-hook (lambda ()
                                (when (get-buffer-window "*scratch*")
                                  (bury-buffer "*scratch*"))))

(add-hook 'after-init-hook                                       ;; startup hud
          (lambda ()   
            (hydra-buffer-menu/body)))

(defun display-startup-echo-area-message ()                      ;; echo startup msg
  "Displays initial message."
  (interactive)
  (message "follow the white rabbit, %s!" current-user))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1b1d1e" "#d02b61" "#60aa00" "#d08928" "#6c9ef8" "#b77fdb" "#00aa80" "#dddddd"])
 '(custom-enabled-themes '(doom-Iosvkem))
 '(custom-safe-themes
   '("97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "a6e620c9decbea9cac46ea47541b31b3e20804a4646ca6da4cce105ee03e8d0e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "7eea50883f10e5c6ad6f81e153c640b3a288cd8dc1d26e4696f7d40f754cc703" "7135f4d63b63311121c98f65fa97cbcf5c9fc4ce6e427ba2a5daf32a99ec2caf" "aee0e520d79b2fb54ae28d5ac336b154409fb6d69576999e910b7636f6a265ff" "6fbd14f99d61f40b4454079acfe9593f2cf282680936fafff087ef67f831a68b" default))
 '(exwm-floating-border-color "#303030")
 '(fci-rule-color "#505050")
 '(highlight-tail-colors ((("#212b1b" "#212b1b") . 0) (("#182b27" "#182b27") . 20)))
 '(jdee-db-active-breakpoint-face-colors (cons "#1b1d1e" "#fc20bb"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1b1d1e" "#60aa00"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1b1d1e" "#505050"))
 '(objed-cursor-color "#d02b61")
 '(pdf-view-midnight-colors (cons "#dddddd" "#1b1d1e"))
 '(rustic-ansi-faces
   ["#1b1d1e" "#d02b61" "#60aa00" "#d08928" "#6c9ef8" "#b77fdb" "#00aa80" "#dddddd"])
 '(tabbar-separator '(0.8) t)
 '(vc-annotate-background "#1b1d1e")
 '(vc-annotate-color-map
   (list
    (cons 20 "#60aa00")
    (cons 40 "#859f0d")
    (cons 60 "#aa931a")
    (cons 80 "#d08928")
    (cons 100 "#d38732")
    (cons 120 "#d6863d")
    (cons 140 "#da8548")
    (cons 160 "#ce8379")
    (cons 180 "#c281aa")
    (cons 200 "#b77fdb")
    (cons 220 "#bf63b2")
    (cons 240 "#c74789")
    (cons 260 "#d02b61")
    (cons 280 "#b0345c")
    (cons 300 "#903d58")
    (cons 320 "#704654")
    (cons 340 "#505050")
    (cons 360 "#505050")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


