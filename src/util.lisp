(in-package #:unicode-backend-sbcl)

#+sbcl
(progn
  (defun %char (code-point)
    "CODE-POINT → CHARACTER (SBCL CHARACTER = Unicode scalar)."
    (code-char code-point))

  (defun %truth (x)
    "Normalize truthy sb-unicode predicate results (MEMBER tails, code points) → T/NIL."
    (and x t))

  (defun %name-spaces (name)
    "LATIN_CAPITAL_LETTER_A → LATIN CAPITAL LETTER A"
    (substitute #\Space #\_ (string name) :test #'char=))

  (defun %name-underscores (name)
    "LATIN CAPITAL LETTER A → LATIN_CAPITAL_LETTER_A"
    (substitute #\_ #\Space (string-upcase (string name)) :test #'char=))

  (defun %simple-from-string-map (mapper code-point)
    "Apply string mapper to a one-char string; return first code point if length=1 else CODE-POINT."
    (let* ((ch (%char code-point))
           (out (funcall mapper (string ch))))
      (if (= (length out) 1)
          (char-code (char out 0))
          code-point)))
) ; progn
