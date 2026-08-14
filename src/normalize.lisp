(in-package #:unicode-backend-sbcl)

#+sbcl
(progn
  (defmethod backend-normalize ((backend sbcl-backend) string form)
    (declare (ignore backend))
    (ecase form
      ((:nfc :nfd :nfkc :nfkd)
       (sb-unicode:normalize-string (string string) form))
      (:nfkc-casefold
       (error 'unicode-unsupported
              :capability :nfkc-casefold
              :message "sbcl backend has no :nfkc-casefold"))))

  (defmethod backend-normalized-p ((backend sbcl-backend) string form)
    (declare (ignore backend))
    (ecase form
      ((:nfc :nfd :nfkc :nfkd)
       (sb-unicode:normalized-p (string string) form))
      (:nfkc-casefold nil)))

  (defmethod backend-quick-check ((backend sbcl-backend) string form)
    (if (backend-normalized-p backend string form) :yes :no))

  (defmethod backend-normalization-boundary-before-p ((backend sbcl-backend) code-point form)
    (declare (ignore backend code-point form))
    nil)

  (defmethod backend-normalization-boundary-after-p ((backend sbcl-backend) code-point form)
    (declare (ignore backend code-point form))
    nil)

  (defmethod backend-raw-decomposition ((backend sbcl-backend) code-point form)
    (declare (ignore backend))
    (let* ((ch (%char code-point))
           (norm-form (ecase form
                        ((:nfc :nfd) :nfd)
                        ((:nfkc :nfkd :nfkc-casefold) :nfkd)))
           (out (sb-unicode:normalize-string (string ch) norm-form)))
      (unless (and (= (length out) 1) (char= (char out 0) ch))
        out)))
) ; progn
