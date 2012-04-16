;;; kolon-mode.el --- Syntax highlighting for Text::Xslate's Kolon syntax
;; 
;; Filename: kolon-mode.el
;; Description: Syntax highlighting for Text::Xslate's Kolon syntax
;; Author: Sam Tran
;; Maintainer: Sam Tran
;; Created: Mon Apr 16 09:26:25 2012 (-0500)
;; Version: 0.1
;; Last-Updated: Mon Apr 16 09:33:35 2012 (-0500)
;;           By: Sam Tran
;;     Update #: 2
;; URL: https://github.com/samvtran/kolon-mode
;; Keywords: xslate, perl
;; Compatibility: GNU Emacs: 23.x
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary: 
;; 
;; Highlights Text::Xslate files using the Kolon syntax
;; 
;; Some parts of this code originated from two other projects:
;;
;; https://github.com/yoshiki/tx-mode
;; https://bitbucket.org/lattenwald/.emacs.d/src/347b18c4f834/site-lisp/kolon-mode.el
;;
;; Commands (interactive functions):
;; `kolon-show-version'
;; `kolon-open-docs'
;;
;; Other functions:
;; `kolon-indent-line'
;; `indent-newline'
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Change Log:
;; 16-Apr-2012    Sam Tran  
;;    Last-Updated: Mon Apr 16 09:33:35 2012 (-0500) #2 (Sam Tran)
;;    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This code is free software; you can redistribute it and/or modify
;; it under the terms of the Artistic License 2.0. For details, see
;; http://www.perlfoundation.org/artistic_license_2_0
;; 
;; This program is distributed in the hope that it will be useful,
;; but it is provided "as is" and without any express or implied
;; warranties. For details, see 
;; http://www.perlfoundation.org/artistic_license_2_0
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code:

(require 'font-lock)
(require 'easymenu)

(defvar kolon-mode-hook nil)

;; Customizable things
(defconst kolon-mode-version "0.1"
  "The version of `kolon-mode'.")

(defgroup kolon nil
  "Major mode for the Xslate Kolon syntax."
  :group 'languages)

(defcustom kolon-indent-offset tab-width
  "Indentation offset for `kolon-mode'."
  :type 'integer
  :group 'kolon)

(defcustom kolon-newline-clear-whitespace nil
  "Clear whitespace on adding a newline."
  :type 'boolean
  :group 'kolon)

(defvar kolon-mode-map (make-keymap)
  "Keymap for `kolon-mode'.")

(defvar kolon-keywords "block\\|override\\|cascade\\|include\\|super\\|before\\|after\\|around\\|with")
(defconst kolon-font-lock-keywords 
  (list
   '("\\(<:\\)\\(\\(?:.\\|\\)+?\\)\\(:>\\)"
	 (1 font-lock-string-face t)
	 (2 font-lock-variable-name-face t)
	 (3 font-lock-string-face t))
   '("\\(^\t*:\\)\\(\\(?:.\\)*?\\)\\({[[:space:]]?}?;?\\|}\\|;\\|$\\)"
	 (1 font-lock-string-face t)
	 (2 font-lock-variable-name-face t)
	 (3 font-lock-string-face t))
   '("^\t*\\(:[[:space:]]*#\\)\\(.*\\)"
	 (1 font-lock-comment-delimiter-face t)
	 (2 font-lock-comment-face t))
   (list
   	(concat "\\b\\(" kolon-keywords "\\)\\b") 
   	1 font-lock-keyword-face t)
   )
  "Expressions to font-lock in kolon-mode.")

(defun kolon-indent-line ()
  "Indent current line for Kolon mode."
  (let (previous-indentation)
	(save-excursion
	  (forward-line -1)
	  (setq previous-indentation (current-indentation)))
	(if (< (current-indentation) previous-indentation)
		(indent-line-to previous-indentation)
	  (indent-line-to (+ (current-indentation) kolon-indent-offset)))))

;; Prevents indentation at bob, bol, whitespace-only lines (if enabled),
;; or lines at column 0
(defun indent-newline ()
  "Newline and indents"
  (interactive)
  (cond
   ;; If we're on a whitespace-only line,
   ;; AND only if kolon-newline-clear-whitespace is enabled
   ((and (eolp)
		 kolon-newline-clear-whitespace
   		 (save-excursion (re-search-backward "^\\(\\s \\)*$"
   											 (line-beginning-position) t)))
   	(kill-line 0)
   	(newline))

   ;; Catches bob, bol, and everything at column 0 (i.e., not indented)
   ((= 0 (current-indentation)) (newline))
   
   ;; Else (not on whitespace-only) insert a newline,
   ;; then add the appropriate indent:
   (t (insert "\n")
	  (indent-according-to-mode)))
  )

;; Menubar
(easy-menu-define kolon-mode-menu kolon-mode-map
  "Menu for `kolon-mode'."
  '("Kolon"
	["Kolon Docs" kolon-open-docs]
	["Version" kolon-show-version]
	))

;; Print version number
(defun kolon-show-version ()
  "Prints the version number of `kolon-mode'."
  (interactive)
  (message (concat "kolon-mode version " kolon-mode-version)))

;; Show Kolon docs
(defun kolon-open-docs ()
  "Shows Kolon syntax docs in the browser."
  (interactive)
  (browse-url "http://search.cpan.org/dist/Text-Xslate/lib/Text/Xslate/Syntax/Kolon.pm"))

(define-derived-mode kolon-mode html-mode
  (font-lock-add-keywords nil kolon-font-lock-keywords)
  (make-local-variable 'kolon-indent-offset)
  (set (make-local-variable 'indent-line-function) 'kolon-indent-line)

  ;; Keybindings
  (define-key kolon-mode-map (kbd "C-c C-k") 'kolon-open-docs)

  (setq mode-name "Kolon"))

(provide 'kolon-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; kolon-mode.el ends here
