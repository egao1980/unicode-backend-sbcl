(in-package #:unicode-backend-sbcl)

#+sbcl
(progn
  (defmethod backend-casefold ((backend sbcl-backend) string &key)
    (declare (ignore backend))
    (sb-unicode:casefold (string string)))

  (defmethod backend-downcase ((backend sbcl-backend) string &key)
    (declare (ignore backend))
    (sb-unicode:lowercase (string string)))

  (defmethod backend-upcase ((backend sbcl-backend) string &key)
    (declare (ignore backend))
    (sb-unicode:uppercase (string string)))

  (defmethod backend-titlecase ((backend sbcl-backend) string &key)
    (declare (ignore backend))
    (sb-unicode:titlecase (string string)))

  (defmethod backend-simple-casefold ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (%simple-from-string-map #'sb-unicode:casefold code-point))

  (defmethod backend-simple-downcase ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (%simple-from-string-map #'sb-unicode:lowercase code-point))

  (defmethod backend-simple-upcase ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (%simple-from-string-map #'sb-unicode:uppercase code-point))

  (defmethod backend-simple-titlecase ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (%simple-from-string-map #'sb-unicode:titlecase code-point))
) ; progn
