#!emacs --script

(defun main ()
  (put 'macro 'scheme-indent-function 1)
  (put 'when 'scheme-indent-function 1)
  (put 'unless 'scheme-indent-function 1)
  (let ((pwd default-directory))
    (mapcar
     (lambda (fname)
       (cd default-directory)
       (indent-file fname))
     command-line-args-left)))

(defun indent-file (fname)
  (find-file-existing fname)
  (scheme-mode)
  (replace-regexp
   "^ *;+ ?"
   ";; "
   nil (point-min) (point-max))
  (indent-region (point-min) (point-max))
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace (point-min) (point-max))
  (save-buffer)
  (kill-buffer))
