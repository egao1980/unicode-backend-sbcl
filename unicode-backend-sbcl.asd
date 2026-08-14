(defsystem "unicode-backend-sbcl"
  :version "0.1.0"
  :description "unicode-protocol backend over SBCL sb-unicode (no IDNA/breaks/uset)"
  :author "egao1980"
  :license "MIT"
  :depends-on ("unicode-protocol")
  :serial t
  :pathname "src"
  :components ((:file "package")
               (:file "util")
               (:file "backend")
               (:file "properties")
               (:file "normalize")
               (:file "case"))
  :in-order-to ((test-op (test-op "unicode-backend-sbcl/tests"))))

(defsystem "unicode-backend-sbcl/tests"
  :depends-on ("unicode-backend-sbcl" "rove")
  :pathname "tests"
  :serial t
  :components ((:file "package")
               (:file "backend-test"))
  :perform (test-op (o c)
             (unless (symbol-call :rove :run c)
               (error "tests failed for ~A" (component-name c)))))
