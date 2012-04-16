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

(defvar kolon-mode-map (make-keymap)
  "Keymap for `kolon-mode'.")

(defvar kolon-keywords "block\\|override\\|cascade\\|include\\|super\\|before\\|after\\|around\\|with")
(defconst kolon-font-lock-keywords 
  (list
   ;; Fontify <: ... :> expressions
   ;;	(rx (group "<:") (group (1+ anything)) (group ":>"))
   ;;Original regex below:
   ;;'("\\(<:\\)\\(\\(?:.\\|
   ;;\\)+?\\)\\(:>\\)"  
   ;; (<:)((?:.|)+?)(:>)
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

;; Prevents indentation at bob, bol, whitespace-only lines, or lines at column 0
(defun indent-newline ()
  "Newline and indents"
  (interactive)
  (cond
   ;; Beginning of buffer, or beginning of an existing line, don't indent:
   ((or (bobp) (bolp)) (newline))

   ;; If we're on a whitespace-only line,
   ((and (eolp)
		 (save-excursion (re-search-backward "^\\(\\s \\)*$"
											 (line-beginning-position) t)))
	;; ... delete the whitespace, then add another newline:
	(kill-line 0)
	(newline))

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