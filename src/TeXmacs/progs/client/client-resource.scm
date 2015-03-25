
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : client-resource.scm
;; DESCRIPTION : resource management on the client side
;; COPYRIGHT   : (C) 2013  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (client client-resource)
  (:use (client client-base)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Local cache with resource properties
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define resource-cache (make-ahash-table))

(tm-define (resource-cache-set-all u props)
  (ahash-set! resource-cache u props)
  (when (buffer-exists? u)
    (let* ((name (url->string (url-tail u)))
           (title (resource-cache-get-first u "title" name)))
      (buffer-set-title u title))))

(tm-define (resource-cache-get-all u)
  (ahash-ref resource-cache u))

(tm-define (resource-cache-get u attr)
  (or (assoc-ref (resource-cache-get-all u) attr) '()))

(tm-define (resource-cache-get-first u attr default)
  (with vals (resource-cache-get u attr)
    (if (null? vals) default (car vals))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Properties on the server side
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (strip-remote-file fname)
  (set! fname (url->string fname))
  (cond ((string-starts? fname "tmfs://remote-file/")
         (substring fname 19 (string-length fname)))
        ((string-starts? fname "tmfs://remote-dir/")
         (substring fname 18 (string-length fname)))
        (else #f)))
