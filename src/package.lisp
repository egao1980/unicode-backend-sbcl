(defpackage #:unicode-backend-sbcl
  (:use #:cl #:unicode-protocol)
  (:export #:sbcl-backend
           #:use-sbcl-backend
           #:*sbcl-backend*))

(in-package #:unicode-backend-sbcl)

#-sbcl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (warn "unicode-backend-sbcl: requires SBCL with :sb-unicode."))
