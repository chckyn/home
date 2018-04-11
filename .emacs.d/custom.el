(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
	 [default default default italic underline success warning error])
 '(custom-file "~/.emacs.d/custom.el")
 '(desktop-path (quote ("~/.emacs.d/desktop")))
 '(ediff-diff-options "-w")
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(global-hl-line-mode t)
 '(grep-find-command (quote ("find . -type f -exec grep  -nH -e '{}' +" . 35)))
 '(grep-find-template "find <D> <X> -type f <F> -exec grep <C> -nH -e <R> '{}' +")
 '(grep-scroll-output t)
 '(org-capture-templates
	 (quote
		(("P" "Add a project idea" entry
			(file+headline "~/org/life.org" "Project Ideas")
			"* %?" :jump-to-captured t :empty-lines-before 1 :empty-lines-after 1)
		 ("N" "Take some notes on ...")
		 ("Nf" "fish" entry
			(file+headline "~/org/life.org" "Learning Fish")
			"* %?" :jump-to-captured t :empty-lines-before 1 :empty-lines-after 1)
		 ("Nr" "racket" entry
			(file+headline "~/org/life.org" "Learning Racket")
			"* %?" :jump-to-captured t :empty-lines-before 1 :empty-lines-after 1)
		 ("T" "Make a task entry related to ...")
		 ("Tg" "general" entry
			(file+headline "~/org/life.org" "Tasks")
			"* TODO %?" :empty-lines-after 1)
		 ("J" "Make a journal entry" entry
			(file+datetree "~/org/journal.org")
			"* %?
Entered on %U
  %i
  %a" :jump-to-captured t)
		 ("R" "Make an entry for something to read later")
		 ("Ro" "online reading" entry
			(file+headline "~/org/web.org" "Reading")
			"* TODO %t %^L %?"))))
 '(org-src-fontify-natively t)
 '(org-src-window-setup (quote other-window))
 '(package-archives
	 (quote
		(("gnu" . "https://elpa.gnu.org/packages/")
		 ("melpa-stable" . "https://stable.melpa.org/packages/")
		 ("melpa" . "https://melpa.org/packages/"))))
 '(tab-width 2)
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
