(in-package #:unicode-backend-sbcl)

(defclass sbcl-backend (unicode-backend) ()
  (:documentation "unicode-protocol backend over SBCL sb-unicode."))

(defvar *sbcl-backend* nil)

(defmethod backend-capabilities ((backend sbcl-backend))
  #+sbcl
  '(:properties :normalize :casefold :script :char-name)
  #-sbcl
  '())

(defun use-sbcl-backend (&optional (backend (or *sbcl-backend*
                                                (setf *sbcl-backend*
                                                      (make-instance 'sbcl-backend)))))
  (use-unicode-backend backend)
  backend)

#+sbcl
(use-sbcl-backend)
