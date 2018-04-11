;;; init.el --- chckyn's Emacs setup
;;; Commentary:

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; TODO auto-fill-mode has this annoying problem where the
;;; beginning of the line will get shifted if it wraps a line
;;; that is too long.
;; (use-package simple
;;  :commands (move-beginning-of-line move-end-of-line)
;;  :config
;;  (defun auto-fill-function ()
;;         (move-beginning-of-line nil)
;;         (move-end-of-line nil)))


(use-package monokai-theme
  :ensure t
  :config (load-theme 'monokai t))


(use-package cus-edit
  :config
  (setq custom-file "~/.emacs.d/custom.el")
  (load custom-file))

;;; Shorten the command to comment a single line.
;;; M-; inserts a comment line.
(use-package newcomment
  :commands (comment-line)
  :bind ("C-;" . comment-line))

;;; Show commands for potential key bindings.
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;;; Use C-c <left> or <right> to undo and redo
;;; window changes.
(use-package winner
  :commands (winner-undo)
  :config
  (winner-mode 1))

(use-package ediff
  :config (add-hook 'ediff-after-quit-hook-internal 'winner-undo))

;;; Some fancy stuff for when calling C-x o or M-p
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (global-set-key (kbd "M-p") 'ace-window)
    (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

(defun kill-process-buffer-when-done ()
  "Attach function to process buffer to watch for `finished \n`.
Got this nugget from oremacs.com."
  (let* ((buff (current-buffer))
         (proc (get-buffer-process buff)))
    (set-process-sentinel
     proc
     `(lambda (process event)
        (if (string= event "finished\n")
            (kill-buffer ,buff))))))

(use-package term
  :ensure t
  :commands (terminal term-send-string)
  :bind (("M-t" . terminal)
         ("M-n" . named-terminal)
         :map term-raw-map
         ("C-c C-y" . term-paste))
  :config
  (defun terminal ()
    "Switch to terminal.  Launch if nonexistent.
     Multiple terminals should be created by renaming each
     terminal buffer. For example, a terminal with the Python interpreter
     running might be renamed *python*."
        (interactive)
    (if (get-buffer "*ansi-term*")
        (switch-to-buffer "*ansi-term*")
      (ansi-term (getenv "SHELL")))
    (centered-cursor-mode -1)
    (get-buffer-process "*ansi-term*"))
  (defun named-terminal (name)
    "Start a long running process such as an interpreter."
    (interactive "sName: ")             ; The 's' here means a string is passed as NAME
    (ansi-term (getenv "SHELL") name))
  :hook
  ((term-exec . kill-process-buffer-when-done)))

(use-package paredit
  :ensure t
             :commands enable-paredit-mode
  :hook ((racket-mode racket-repl-mode emacs-lisp-mode) . enable-paredit-mode))

(use-package rainbow-delimiters
             :ensure t
             :commands rainbow-delimiters-mode
             :hook ((racket-mode racket-repl-mode emacs-lisp-mode) . rainbow-delimiters-mode))

(use-package racket-mode
  :ensure t
  :bind (()
         :map racket-mode-map
         ("C-l" . (lambda ()
                    "Insert an empty lambda expression."
                    (interactive)
                    (insert "(λ ())")
                    (backward-char 2)))
         ("C-c C-k" . racket-run-and-switch-to-repl)
         :map racket-repl-mode-map
         ("TAB" . complete-symbol)))

(use-package racket-repl-mode
  :bind (()
         :map racket-repl-mode-map
         ("TAB" . complete-symbol))
  :hook ((racket-repl-mode . (lambda () (centered-cursor-mode -1)))
         (racket-repl-mode . kill-process-buffer-when-done)))



;;; For a prettier org-mode presentation in Emacs GUI
(use-package org-bullets
 :ensure t
 :hook ((org-mode . (lambda () (org-bullets-mode 1)))))

;;; My custom keyboard macro for adding checkboxes.
(use-package org
  :commands (org-store-link org-capture org-agenda org-iswitchb)
  :ensure t
  :bind (("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c b" . org-iswitchb)
         :map org-mode-map
         ("C-c n" . "\C-m- [ ] ")
         ("C-c i" . org-toggle-item)
         ("C-c e" . org-edit-src-code))
  :hook ((org-mode . auto-fill-mode)))

(use-package counsel
  :ensure t
  :commands (counsel-M-x
             counsel-find-file
             counsel-describe-function
             counsel-describe-variable
             counsel-load-library
             counsel-info-lookup-symbol
             counsel-unicode-char
             counsel-git
             counsel-git-grep
             counsel-ag
             counsel-locate
             counsel-rhythmbox
             counsel-minibuffer-history)
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ;; ("<f1> f" . counsel-describe-function)
         ;; ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-load-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ;; ("C-c k" . counsel-ag)
         ;; ("C-H-o" . counsel-rhythmbox)
         ("C-x l" . counsel-locate)
         ("C-c o" . counsel-mac-app)
         :map read-expression-map
         ("C-r" . counsel-minibuffer-history)))

(use-package swiper
  :ensure t)

(use-package ivy
  :ensure t
  :after (swiper)
  :commands (ivy-mode
             ivy-resume)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  ;; (setq ivy-re-builders-alist
  ;;      '((read-file-name-internal . ivy--regex-fuzzy)
  ;;        (t . ivy--regex-plus)))
  :bind (("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("C-c v" . ivy-push-view)
         ("C-c V" . ivy-pop-view)
         ("C-x b" . ivy-switch-buffer)
         ("C-s" . swiper)))

;;; Keep the cursor centered in every buffer.
(use-package centered-cursor-mode
  :ensure t
  :demand t
  :commands global-centered-cursor-mode
  :config (global-centered-cursor-mode +1))

(use-package company
  :commands global-company-mode
  :config (global-company-mode))

(use-package avy
  :ensure t
  :bind  (("H-s" . avy-goto-char-timer)
          ("M-g f" . avy-goto-line)))

(use-package dired
  :commands (dired-current-directory)
  :bind (:map dired-mode-map
              ("`" . (lambda ()
                       "Open an `ansi-term' that corresponds to current directory."
                       (interactive)
                       (let ((current-dir (dired-current-directory)))
                         (term-send-string
                          (terminal)
                          ;; ssh if necessary
                          ;; (if (file-remote-p current-dir)
                          ;;    (let ((v (tramp-dissect-file-name current-dir t)))
                          ;;      (format "ssh %s@%s\n"
                          ;;              (aref v 1) (aref v 2)))
                          ;;  (format "cd '%s'\n" current-dir))
                          (format "cd '%s'\n" current-dir))))))
  :config
  (setq dired-listing-switches "-laGh1v --group-directories-first"))

;;;;;; Some custom functions for mac
;;;(use-package ns-win
;;; :config
;;; (setq mac-function-modifier 'hyper)
;;; (setq mac-option-modifier 'meta)
;;; (setq mac-right-option-modifier 'meta)
;;; (setq mac-control-modifier 'ctrl)
;;; (setq mac-right-control-modifier 'ctrl)
;;; (setq mac-command-modifier 'super)
;;; (setq mac-right-command-modifier 'super))

(use-package go-mode
  :ensure t
  :config
  :hook ((before-save . gofmt-before-save)))

(provide 'init)
;;; init.el ends here
