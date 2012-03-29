(require 'font-lock)

(defvar kolon-mode-hook nil)
(defvar kolon-keywords "block\\|override\\|cascade\\|include\\|super\\|before\\|after\\|around\\|with")
(defconst kolon-font-lock-keywords 
  (list
   ;; Fontify <: ... :> expressions
   ;;	(rx (group "<:") (group (1+ anything)) (group ":>"))
   ;;Original regex below:
   ;;'("\\(<:\\)\\(\\(?:.\\|
   ;;\\)+?\\)\\(:>\\)"  
   ;; (<:)((?:.|)+?)(:>)

   ;;'("\\(<?:\\)\\(\\(?:.\\|\\)+?\\)\\(\\(:>\\)\\|\\({\\)\\|\\(}\\)\\)"
   ;; '("\\(<?:\\)\\(\\(?:.\\|\\)+?\\)\\(\\(:>\\)\\|\\({}?\\)\\|\\(}\\)\\|\\(;\\)\\)"
   ;; 	 (1 font-lock-string-face t)
   ;; 	 (2 font-lock-variable-name-face t)
   ;; 	 (3 font-lock-string-face t))
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

(defvar kolon-indent-offset 4
  "*Indentation offset for kolon-mode'.")
(defun kolon-indent-line ()
  "Indent current line for Kolon mode."
  (let (previous-indentation)
	(save-excursion
	  (forward-line -1)
	  (setq previous-indentation (current-indentation)))
	(if (< (current-indentation) previous-indentation)
		(indent-line-to previous-indentation)
	  (indent-line-to (+ (current-indentation) kolon-indent-offset)))))

;; Using this because otherwise you end up with a single tab when otherwise you'd be at column 0
;; Note that this adds a tab after a line at column 0 anyway, but it stops doing it after that.
;; Confused yet?
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
   
   ;; Else (not on whitespace-only) insert a newline,
   ;; then add the appropriate indent:
   (t (insert "\n")
	  (indent-according-to-mode)))
  )


(define-derived-mode kolon-mode html-mode
;;  (setq font-lock-defaults '(kolon-font-lock-keywords))
  (font-lock-add-keywords nil kolon-font-lock-keywords)
  (make-local-variable 'kolon-indent-offset)
  (set (make-local-variable 'indent-line-function) 'kolon-indent-line)
  (setq mode-name "Kolon"))

(provide 'kolon-mode)