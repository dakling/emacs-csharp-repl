;;; csharp-repl.el --- Comint mode for the C#-Mono-REPL

;; Copyright (C) 2019 Dario Klingenberg

;; Author: Dario Klingenberg <dario.klingenberg@web.de>
;; Created: 30 Aug 2019
;; Keywords: languages
;; Homepage: http://github.com/dakling/emacs-csharp-repl
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This file is free software...
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Code:
(defvar csharp-repl-path "/usr/bin/csharp"
  "The path to the C#-REPL executable")

(defvar csharp-repl-arguments '()
  "Arguments passed to the REPL command")

(defvar csharp-repl-mode-map (make-sparse-keymap)
  "Keymap for C# REPL")


(defvar csharp-repl-prompt-regexp "^\\(?:\\[[^@]+@[^@]+\\]\\)")

(defun run-csharp-repl ()
  "Start a new C# REPL or switch to running one"
  (interactive)
  (let* ((csharp-program csharp-repl-path)
	 (buffer (comint-check-proc "csharp")))
    (pop-to-buffer-same-window
     (if (or buffer (not (derived-mode-p 'csharp-mode))
	     (comint-check-proc (current-buffer)))
	 (get-buffer-create (or buffer "*csharp*"))
       (current-buffer)))
    (unless buffer
      (apply 'make-comint-in-buffer "csharp" buffer
       csharp-program csharp-repl-arguments)
      (csharp-repl-mode))))

(defun csharp--repl-initialize ()
  "Commands to run when starting up"
  (setq comint-process-echoes t)
  (setq comint-use-prompt-regexp t))

(define-derived-mode csharp-repl-mode comint-mode "csharp-repl"
  "Define the mode"
  (setq comint-prompt-regexp csharp-repl-prompt-regexp)
  (setq comint-prompt-read-only t)
  (set (make-local-variable 'paragraph-separate) "\\'")
  (set (make-local-variable 'paragraph-start) csharp-repl-prompt-regexp))

(add-hook 'csharp-repl-mode-hook 'csharp--repl-initialize)

(defun run-csharp-repl-other-window ()
  "Lauch REPL in other window"
    (interactive)
    (switch-to-buffer-other-window "*csharp*")
    (run-csharp-repl))

(defun csharp-repl-send-region (beg end)
  "Send active region to C#-process"
  (interactive "r")
  (comint-send-region "*csharp*" beg end))

(provide 'csharp-repl)

;;; csharp-repl.el ends here
