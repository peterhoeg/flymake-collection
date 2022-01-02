;;; flymake-rest-jsonlint.el --- JSONLint diagnostic function -*- lexical-binding: t -*-

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

;;;###autoload (autoload 'flymake-rest-jsonlint "flymake-rest-jsonlint")
(flymake-rest-define-rx flymake-rest-jsonlint
  "A JSON syntax and style checker using jsonlint.

See URL `https://github.com/zaach/jsonlint'."
  :title "jsonlint"
  :pre-let ((jsonlint-exec (flymake-rest-executable-find "jsonlint")))
  :pre-check (unless jsonlint-exec
               (error "Cannot find jsonlint executable"))
  :write-type 'file
  :command (list jsonlint-exec "-c" "-q" flymake-rest-temp-file)
  :regexps
  ((error bol (file-name) ": line " line ", col " column ", " (message) eol)))

(provide 'flymake-rest-jsonlint)

;;; flymake-rest-jsonlint.el ends here
