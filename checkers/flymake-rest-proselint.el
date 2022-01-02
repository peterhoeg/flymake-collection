;;; flymake-rest-proselint.el --- Proselint diagnostic function -*- lexical-binding: t -*-

;; Copyright (c) 2021 Mohsin Kaleem

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Code:

(require 'flymake)
(require 'flymake-rest)

(eval-when-compile
  (require 'flymake-rest-define))

;;;###autoload (autoload 'flymake-rest-proselint "flymake-rest-proselint")
(flymake-rest-define-enumerate flymake-rest-proselint
  "Flymake checker using Proselint.

See URL `http://proselint.com/'."
  :title "proselint"
  :pre-let ((proselint-exec (flymake-rest-executable-find "proselint")))
  :pre-check (unless proselint-exec
               (error "Cannot find proselint executable"))
  :write-type 'pipe
  :command `(,proselint-exec "--json" "-")
  :generator
  (alist-get 'errors
   (alist-get 'data
    (car
     (flymake-rest-parse-json
      (buffer-substring-no-properties
       (point-min) (point-max))))))
  :enumerate-parser
  (let-alist it
    (list flymake-rest-source
          .start
          .end
          (pcase .severity
            ("suggestion" :note)
            ("warning" :warning)
            ((or "error" _) :error))
          (concat (propertize .check 'face 'flymake-rest-diag-id) " " .message))))

(provide 'flymake-rest-proselint)

;;; flymake-rest-proselint.el ends here
