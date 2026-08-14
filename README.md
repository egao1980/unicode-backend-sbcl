# unicode-backend-sbcl

[`unicode-protocol`](https://github.com/egao1980/unicode-protocol) backend over **SBCL `sb-unicode`**.

Implements `:properties` `:normalize` `:casefold` `:script` `:char-name`.

**Not** implemented: `:idna` `:breaks` `:uset` `:nfkc-casefold`. Use
[`unicode-backend-cl-unicode`](https://github.com/egao1980/unicode-backend-cl-unicode)
or [`unicode-backend-icu`](https://github.com/egao1980/unicode-backend-icu) / ICU4J for those.

SBCL-only. On other implementations this system warns and reports no capabilities.

```lisp
(asdf:load-system "unicode-backend-sbcl")
(stack-unicode:normalize "é" :form :nfc)
(stack-unicode:casefold "Straße")
```

## License

MIT
