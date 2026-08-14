(in-package #:unicode-backend-sbcl)

#+sbcl
(progn
  (defun %proplist-key (property)
    "Map protocol binary property → sb-unicode:proplist-p keyword, or NIL if unsupported."
    (case property
      (:white-space :white-space)
      (:hex-digit :hex-digit)
      (:ideographic :ideographic)
      (:emoji :emoji)
      (:emoji-presentation :emoji-presentation)
      (:emoji-modifier :emoji-modifier)
      (:emoji-modifier-base :emoji-modifier-base)
      (:emoji-component :emoji-component)
      (:extended-pictographic :extended-pictographic)
      (:soft-dotted :soft-dotted)
      (:dash :dash)
      (:hyphen :hyphen)
      (:quotation-mark :quotation-mark)
      (:terminal-punctuation :terminal-punctuation)
      (:diacritic :diacritic)
      (:extender :extender)
      (:deprecated :deprecated)
      (:variation-selector :variation-selector)
      (:regional-indicator :regional-indicator)
      (:sentence-terminal :sentence-terminal)
      (:pattern-white-space :pattern-white-space)
      (:pattern-syntax :pattern-syntax)
      (otherwise nil)))

  (defmethod backend-binary-property-p ((backend sbcl-backend) code-point property)
    (declare (ignore backend))
    (let ((ch (%char code-point)))
      (case property
        (:alphabetic (%truth (sb-unicode:alphabetic-p ch)))
        (:lowercase (%truth (sb-unicode:lowercase-p ch)))
        (:uppercase (%truth (sb-unicode:uppercase-p ch)))
        (:bidi-mirrored (%truth (sb-unicode:mirrored-p ch)))
        (:posix-blank
         (or (char= ch #\Tab)
             (eq (sb-unicode:general-category ch) :zs)))
        (otherwise
         (let ((key (%proplist-key property)))
           (and key (%truth (sb-unicode:proplist-p ch key))))))))

  (defmethod backend-int-property ((backend sbcl-backend) code-point property)
    (declare (ignore backend))
    (let ((ch (%char code-point)))
      (ecase property
        (:general-category (sb-unicode:general-category ch))
        (:bidi-class (sb-unicode:bidi-class ch))
        (:canonical-combining-class (sb-unicode:combining-class ch))
        (:block (sb-unicode:char-block ch))
        (:script (sb-unicode:script ch))
        (:east-asian-width (sb-unicode:east-asian-width ch))
        (:word-break (sb-unicode:word-break-class ch)))))

  (defmethod backend-script-extensions ((backend sbcl-backend) code-point)
    ;; sb-unicode has Script only, not Script_Extensions.
    (list (backend-int-property backend code-point :script)))

  (defmethod backend-char-name ((backend sbcl-backend) code-point &key (choice :unicode))
    (declare (ignore backend))
    (let ((ch (%char code-point)))
      (ecase choice
        (:unicode
         (let ((n (char-name ch)))
           (when n (%name-spaces n))))
        (:alias nil)
        (:extended
         (or (let ((n (char-name ch)))
               (when n (%name-spaces n)))
             (sb-unicode:unicode-1-name ch))))))

  (defmethod backend-lookup-name ((backend sbcl-backend) name)
    (declare (ignore backend))
    (let ((ch (or (name-char (%name-underscores name))
                  (name-char name))))
      (when ch (char-code ch))))

  (defmethod backend-numeric-value ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (sb-unicode:numeric-value (%char code-point)))

  (defmethod backend-digit-value ((backend sbcl-backend) code-point &key (radix 10))
    (declare (ignore backend))
    (let* ((ch (%char code-point))
           (v (or (sb-unicode:digit-value ch)
                  (digit-char-p ch radix))))
      (when (and (integerp v) (< v radix))
        v)))

  (defmethod backend-mirror-char ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (let ((m (sb-unicode:bidi-mirroring-glyph (%char code-point))))
      (if m (char-code m) code-point)))

  (defmethod backend-age ((backend sbcl-backend) code-point)
    (declare (ignore backend))
    (multiple-value-bind (major minor) (sb-unicode:age (%char code-point))
      (when major
        (list major (or minor 0)))))

  (defmethod backend-property-value-name ((backend sbcl-backend) property value &key short)
    (declare (ignore backend property short))
    (if (keywordp value)
        (string-downcase (symbol-name value))
        (princ-to-string value)))
) ; progn
