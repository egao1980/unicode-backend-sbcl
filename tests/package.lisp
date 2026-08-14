(defpackage #:unicode-backend-sbcl/tests
  (:use #:cl #:rove #:unicode-protocol #:unicode-backend-sbcl))

(in-package #:unicode-backend-sbcl/tests)

(defun %s (&rest cps)
  (map 'string #'code-char cps))

(deftest backend-installed
  (ok (typep *unicode-backend* 'sbcl-backend))
  (dolist (cap '(:properties :normalize :casefold :script :char-name))
    (ok (member cap (backend-capabilities *unicode-backend*))
        (format nil "capability ~s" cap)))
  (ok (not (member :idna (backend-capabilities *unicode-backend*))))
  (ok (not (member :breaks (backend-capabilities *unicode-backend*))))
  (ok (not (member :uset (backend-capabilities *unicode-backend*)))))

(deftest general-category-ascii
  (ok (eq (general-category #\A) :lu))
  (ok (eq (general-category #\a) :ll))
  (ok (eq (general-category #\1) :nd))
  (ok (eq (general-category #\Space) :zs)))

(deftest binary-predicates
  (ok (alphabetic-p #\A))
  (ok (not (alphabetic-p #\1)))
  (ok (uppercase-p #\A))
  (ok (lowercase-p #\a))
  (ok (digit-p #\7))
  (ok (whitespace-p #\Space))
  (ok (letter-p #\Z))
  (ok (letter-or-digit-p #\9))
  (ok (hex-digit-p #\F)))

(deftest numeric-and-names
  (ok (= (numeric-value #\5) 5))
  (ok (search "LATIN CAPITAL LETTER A" (unicode-name #\A)))
  (ok (= (lookup-name "LATIN CAPITAL LETTER A") #x0041)))

(deftest script-and-block
  (ok (eq (script #\A) :latin))
  (ok (eq (unicode-block #\A) :basic-latin)))

(deftest nfc-nfd
  (let* ((decomp (%s #x65 #x301))
         (comp (string (code-char #x00E9))))
    (ok (string= (normalize decomp :form :nfc) comp))
    (ok (string= (normalize comp :form :nfd) decomp))
    (ok (normalized-p comp :form :nfc))))

(deftest nfkc-ligature
  (ok (string= (normalize (string (code-char #xFB01)) :form :nfkc) "fi")))

(deftest casefold-and-string-case
  (ok (string= (casefold "ß") "ss"))
  (ok (string= (casefold "Straße") "strasse"))
  (ok (string= (downcase "AbC") "abc"))
  (ok (string= (upcase "AbC") "ABC"))
  (ok (string= (titlecase "hello world") "Hello World")))

(deftest mirror-and-age
  (ok (= (mirror-char #\() (char-code #\))))
  (ok (equal (age #\A) '(1 1))))
