;; -*- mode: Emacs-Lisp -*-
;; written by k-okada 2006.06.14
;;
;; changed by ueda 2009.04.21

;; (debian-startup 'emacs21)
;;; Global Setting Key
;;;
;;(require 'cask "~/.cask/cask.el")
;;(cask-initialize)

(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line)
(global-unset-key "\C-o" )

(setq visible-bell t)

;;; When in Text mode, want to be in Auto-Fill mode.
;;;
(defun my-auto-fill-mode nil (auto-fill-mode 1))
(setq text-mode-hook 'my-auto-fill-mode)
(setq mail-mode-hook 'my-auto-fill-mode)

;;; time
;;;
(load "time" t t)
(display-time)

;;;	for mew
;;;
;;;     explanation exists in /opt/src/Solaris/mew-1.03/00install.jis
;;;

(autoload 'mew "mew" nil t)
(autoload 'mew-read "mew" nil t)
(autoload 'mew-send "mew" nil t)

(setq mew-name "User Name")
(setq mew-user "user")
(setq mew-dcc "user@jsk.t.u-tokyo.ac.jp")

(setq mew-mail-domain "jsk.t.u-tokyo.ac.jp")
(setq mew-pop-server "mail.jsk.t.u-tokyo.ac.jp")
(setq mew-pop-auth 'apop)
(setq mew-pop-delete 3)
(setq mew-smtp-server "mail.jsk.t.u-tokyo.ac.jp")
(setq mew-fcc nil)
(setq mew-use-cached-passwd t)

;;
;; Optional setup (Read Mail menu for Emacs 21):
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(define-key ctl-x-map "r" 'mew)
(define-key ctl-x-map "m" 'mew-send)

;; (lookup)
;;
(setq lookup-search-agents '((ndtp "nfs")))
(define-key global-map "\C-co" 'lookup-pattern)
(define-key global-map "\C-cr" 'lookup-region)
(autoload 'lookup "lookup" "Online dictionary." t nil )

;; Japanese
;; uncommented by ueda. beacuse in shell buffer, they invokes mozibake
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(setq enable-double-n-syntax t)

(setq use-kuten-for-period nil)
(setq use-touten-for-comma nil)

;;(load-library "yc")

;;(load "migemo")

;;; Timestamp
;;;
(defun timestamp-insert ()
  (interactive)
  (insert (current-time-string))
  (backward-char))
(global-set-key "\C-c\C-d" 'timestamp-insert)

(global-font-lock-mode t)

;; M-n and M-p
(global-unset-key "\M-p")
(global-unset-key "\M-n")

(defun scroll-up-in-place (n)
       (interactive "p")
       (previous-line n)
       (scroll-down n))


(defun scroll-down-in-place (n)
       (interactive "p")
       (next-line n)
       (scroll-up n))

(global-set-key "\M-n" 'scroll-down-in-place)
(global-set-key "\M-p" 'scroll-up-in-place)

;; dabbrev
(global-set-key "\C-o" 'dabbrev-expand)

;; add by kojima
(require 'paren)
(show-paren-mode 1)
;; ;; C-qで移動
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        )
  )
(global-set-key "\C-q" 'match-paren)


(font-lock-add-keywords 'lisp-mode
	                (list
		          (list "\\(\\*\\w\+\\*\\)\\>"
			        '(1 font-lock-constant-face nil t))
		          (list "\\(\\+\\w\+\\+\\)\\>"
			        '(1 font-lock-constant-face nil t))))

(when nil
;; does not allow use hard tab.
(setq-default indent-tabs-mode nil)
)

;; ignore start message
(setq inhibit-startup-message t)

(when nil
;; add template.l by kojima
(require 'autoinsert)
(when (featurep 'emacs)
  (let (skeldir)
    (setq skeldir "~/prog/scripts/emacs-templates")
    (setq auto-insert-directory skeldir)
    (setq auto-insert-alist
	  (nconc '(
		   ("\\.l$" . "template.l")
		   ("\\.sh$" . "template.sh")
		   ("Makefile$" . "template.Makefile")
		   ("\\.cpp$" . "template.cpp")
		   ("\\.h$" . "template.h")
		    ) auto-insert-alist))
    (add-hook 'find-file-not-found-hooks 'auto-insert)
    )
  )
)

;; shell mode
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq explicit-shell-file-name shell-file-name)
(setq shell-command-option "-c")
(setq system-uses-terminfo nil)
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun lisp-other-window ()
  "Run Lisp on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*inferior-lisp*"))
  (run-lisp inferior-lisp-program))

(set-variable 'inferior-lisp-program "jskrbeusgl")
(global-set-key "\C-cE" 'lisp-other-window)

;; add color space,tab,zenkaku-space
;;(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-b-2 '((t (:background "red"))) nil)
(defface my-face-u-1 '((t (:background "red"))) nil)
;;(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ;;("\t" 0 my-face-b-1 append)
     ("　" 0 my-face-b-2 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; to change indent for euslisp's method definition ;; begin
(define-derived-mode euslisp-mode lisp-mode
  "EusLisp"
  "Major Mode for EusLisp"
  )
(defun lisp-indent-function (indent-point state)
  "This function is the normal value of the variable `lisp-indent-function'.
It is used when indenting a line within a function call, to see if the
called function says anything special about how to indent the line.

INDENT-POINT is the position where the user typed TAB, or equivalent.
Point is located at the point to indent under (for default indentation);
STATE is the `parse-partial-sexp' state for that position.

If the current line is in a call to a Lisp function
which has a non-nil property `lisp-indent-function',
that specifies how to do the indentation.  The property value can be
* `defun', meaning indent `defun'-style;
* an integer N, meaning indent the first N arguments specially
  like ordinary function arguments and then indent any further
  arguments like a body;
* a function to call just as this function was called.
  If that function returns nil, that means it doesn't specify
  the indentation.

This function also returns nil meaning don't specify the indentation."
  (let ((normal-indent (current-column)))
    (goto-char (1+ (elt state 1)))
    (parse-partial-sexp (point) calculate-lisp-indent-last-sexp 0 t)
    (if (and (elt state 2)
             (not (looking-at "\\sw\\|\\s_")))
        ;; car of form doesn't seem to be a symbol
        (progn
          (if (not (> (save-excursion (forward-line 1) (point))
                      calculate-lisp-indent-last-sexp))
		(progn (goto-char calculate-lisp-indent-last-sexp)
		       (beginning-of-line)
		       (parse-partial-sexp (point)
					   calculate-lisp-indent-last-sexp 0 t)))
	    ;; Indent under the list or under the first sexp on the same
	    ;; line as calculate-lisp-indent-last-sexp.  Note that first
	    ;; thing on that line has to be complete sexp since we are
          ;; inside the innermost containing sexp.
          (backward-prefix-chars)
          (current-column))
      (let ((function (buffer-substring (point)
					(progn (forward-sexp 1) (point))))
	    method)
	(setq method (or (get (intern-soft function) 'lisp-indent-function)
			 (get (intern-soft function) 'lisp-indent-hook)))
	(cond ((or (eq method 'defun)
		   (and
		    (eq major-mode 'euslisp-mode)
		    (string-match ":.*" function))
		   (and (null method)
			(> (length function) 3)
			(string-match "\\`def" function)))
	       (lisp-indent-defform state indent-point))
	      ((integerp method)
	       (lisp-indent-specform method state
				     indent-point normal-indent))
	      (method
		(funcall method indent-point state)))))))
;; to change indent for euslisp's method definition ;; end
;;Xwindow setting

(when nil
(set-foreground-color "white")
(set-background-color "black")
(set-scroll-bar-mode 'right)
(set-cursor-color "white")
)
;;
(line-number-mode t)
(column-number-mode t)

(when nil
;; stop auto scroll according to cursol
(setq comint-scroll-show-maximum-output nil)
)

(setq auto-mode-alist (cons (cons "\\.launch$" 'xml-mode) auto-mode-alist))

(when (eq 0 (shell-command "which rospack"))
(add-to-list 'load-path (substring (shell-command-to-string "rospack find rosemacs") 0 -1))
(require 'rosemacs)
(invoke-rosemacs)
(global-set-key "\C-x\C-r" ros-keymap)
)

;; vrml mode
(add-to-list 'load-path (format "%s/.emacs.d" (getenv "HOME")))
(when (file-exists-p (format "%s/.emacs.d/vrml-mode.el" (getenv "HOME")))
  (load "vrml-mode.el")
  (autoload 'vrml-mode "vrml" "VRML mode." t)
  (setq auto-mode-alist (append '(("\\.wrl\\'" . vrml-mode))
                                auto-mode-alist)))

;; matlab mode
;; (when (file-exists-p (format "%s/.emacs.d/matlab/matlab.el.1.10.1" (getenv "HOME")))
;;   (load "matlab/matlab.el.1.10.1" (getenv "HOME"))
;;   (setq auto-mode-alist (append '(("\\.m\\'" . matlab-mode))
;;                                 auto-mode-alist)))

;; for Arduino
(setq auto-mode-alist (append '(("\\.pde\\'" . c++-mode))
                             auto-mode-alist))

;; added by yusuke
(iswitchb-mode 1)
(xterm-mouse-mode 1)
(mwheel-install)

(setq mouse-wheel-follow-mouse t)


;(defun scroll-down-with-lines ()
;"" (interactive) (scroll-down 3))
;(defun scroll-up-with-lines ()
;"" (interactive) (scroll-up 3))
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control) . nil)))

(autoload 'trr "/usr/local/share/emacs/site-lisp/trr" nil t)
;;;rosemacs
;; (add-to-list 'load-path  "/opt/ros/electric/ros/tools/rosemacs")
;; (require 'rosemacs)
;; (invoke-rosemacs)
;;(global-set-key "\C-x\C-r" ros-keymap)


(cond (window-system
(setq x-select-enable-clipboard t)
))

(global-unset-key [mouse-2])

;; 行末の空白削除
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)



;; ;;c++ hokann
;; (require 'auto-complete-config)
;; (require 'auto-complete-clang)

;; ;;自動で補完画面を出すならt。補完キーを押すまで補完画面を出さないならnil
;; (setq ac-auto-start nil)

;; ;;補完キー指定。お好みで。
;; (ac-set-trigger-key "TAB")
;; ;;補完画面からさらにそのヘルプ画面が出るまでの遅延（秒）
;; (setq ac-quick-help-delay 0)

;; (defun my-ac-config ()
;;       (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))

;; (add-hook 'c++-mode-hook 'ac-cc-mode-setup)
;; (global-auto-complete-mode t))
;; (defun my-ac-cc-mode-setup ()
;;     (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources))
;;     (setq ac-clang-prefix-header "/プリコンパイル済みヘッダの場所/stdafx.pch")
;;     )

;; (my-ac-config)

;; ;;c++ hokann

;; (require 'bash-completion)
;; (bash-completion-setup)


;;-------------------tab化-----------------------------;;
;; グループ化せずに*scratch*以外のタブを表示
(require 'cl)
 (when (require 'tabbar nil t)
    (setq tabbar-buffer-groups-function
	      (lambda (b) (list "All Buffers")))
    (setq tabbar-buffer-list-function
          (lambda ()
            (remove-if
             (lambda(buffer)
	              (unless (string= (buffer-name buffer) "*shell*")
			 (find (aref (buffer-name buffer) 0) " *")))
             (buffer-list))))
    (tabbar-mode))

;; 左に表示されるボタンを無効化
(setq tabbar-home-button-enabled "")
(setq tabbar-scroll-left-button-enabled "")
(setq tabbar-scroll-right-button-enabled "")
(setq tabbar-scroll-left-button-disabled "")
(setq tabbar-scroll-right-button-disabled "")

;; 色設定
 (set-face-attribute
   'tabbar-default-face nil
   :background "gray90") ;バー自体の色
  (set-face-attribute ;非アクティブなタブ
   'tabbar-unselected-face nil
   :background "gray90"
   :foreground "black"
   :box nil)
  (set-face-attribute ;アクティブなタブ
   'tabbar-selected-face nil
   :background "black"
   :foreground "white"
   :box nil)

;; 幅設定
  (set-face-attribute
   'tabbar-separator-face nil
   :height 0.7)

;; Firefoxライクなキーバインドに
(global-set-key [(control tab)]       'tabbar-forward)
(global-set-key [(control shift iso-lefttab)] 'tabbar-backward)
;; -nw では効かないので別のキーバインドを割り当てる
(global-set-key (kbd "C-x n") 'tabbar-forward)
(global-set-key (kbd "C-x p") 'tabbar-backward)

;;F4ボタンで切り替え
(global-set-key [f4] 'tabbar-mode)
;;-------------------tab化-----------------------------;;

(add-hook 'c++-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'c-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'scheme-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'emacs-lisp-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'lisp-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'python-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(define-key global-map (kbd "C-\\") 'hs-toggle-hiding)

;;ポップアップにする
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;;マウスドラッグでコピーしない
(setq mouse-drag-copy-region nil) 

;;
;;(global-linum-mode)
(setq x-select-enable-clipboard t)


;;php-mode
;;(load-library "php-mode")
;;(require 'php-mode)


(autoload 'trr "/usr/local/share/emacs/site-lisp/trr" nil t)
(put 'upcase-region 'disabled nil)


;; ;;; clipboard
;; (if (display-graphic-p)
;;     (progn
;;       ;; if on window-system
;;       (setq x-select-enable-clipboard t)
;;       (global-set-key "\C-y" 'x-clipboard-yank))
;;   ;; else (on terminal)
;;   (setq interprogram-paste-function
;;         (lambda ()
;;           (shell-command-to-string "xsel -b -o")))
;;   (setq interprogram-cut-function
;;         (lambda (text &optional rest)
;;           (let* ((process-connection-type nil)
;;                  (proc (start-process "xsel" "*Messages*" "xsel" "-b" "-i")))
;;             (process-send-string proc text)
;;             (process-send-eof proc)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 行と桁の表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(line-number-mode t)
(column-number-mode t)
;; 選択範囲の情報表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%3d:%4d]"
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/Applications/git-modes")
(add-to-list 'load-path "~/Applications/magit")

(eval-after-load 'info
  '(progn (info-initialize)
          (add-to-list 'Info-directory-list "~/Applicaions/magit")))
(require 'magit)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-install
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install/"))
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete-config)
(ac-config-default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'package)

; Add package-archives
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

; Initialize
(package-initialize)
; melpa.el
;;(require 'melpa)


;;expand-region
(add-to-list 'load-path "~/.emacs.d/expand-region.el")
(require 'expand-region)
;;(global-set-key (kbd "C-@") 'er/expand-region)
;;(global-set-key (kbd "C-M-@") 'er/contract-region)


(add-to-list 'load-path "~/.emacs.d/elpa/")
(require 'multiple-cursors)
(require 'smartrep)

(declare-function smartrep-define-key "smartrep")

(global-set-key (kbd "C-M-c") 'mc/edit-lines)
(global-set-key (kbd "C-M-r") 'mc/mark-all-in-region)



(smartrep-define-key global-map "C-^"
  '(("C-^"      . 'mc/mark-next-like-this)
    ("n"        . 'mc/mark-next-like-this)
    ("p"        . 'mc/mark-previous-like-this)
    ("m"        . 'mc/mark-more-like-this-extended)
    ("u"        . 'mc/unmark-next-like-this)
    ("U"        . 'mc/unmark-previous-like-this)
    ("s"        . 'mc/skip-to-next-like-this)
    ("S"        . 'mc/skip-to-previous-like-this)
    ("*"        . 'mc/mark-all-like-this)
    ("d"        . 'mc/mark-all-like-this-dwim)
    ("i"        . 'mc/insert-numbers)
    ("o"        . 'mc/sort-regions)
    ("O"        . 'mc/reverse-regions)))



(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)

