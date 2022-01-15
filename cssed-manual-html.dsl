<!DOCTYPE style-sheet PUBLIC
          "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY % html "IGNORE">
<![%html;[
<!ENTITY % print "IGNORE">
<!ENTITY dbstyle PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN"
         CDATA dsssl>
]]>
<!ENTITY % print "INCLUDE">
<![%print;[
<!ENTITY dbstyle PUBLIC
         "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN"
         CDATA dsssl>
]]>
]>

<style-sheet>

<!--      HTML       -->
<style-specification id="html" use="docbook">
<style-specification-body> 

;; this is necessary because right now jadetex does not understand
;; symbolic entities, whereas things work well with numeric entities.
(declare-characteristic preserve-sdata?
  "UNREGISTERED::James Clark//Characteristic::preserve-sdata?"
  #f)

;; TOC/LOT customization
;;--------------------

;; TOC depth
(define (toc-depth nd)
	3)

;; Which Lists of Titles should be produced for Books?
(define ($generate-book-lot-list$)
  (list (normalize "figure")
		(normalize "table")))

;; fixes bug in Table of Contents generation
(define (list-element-list)
 '())

;; forces the Table of Contents on separate page
(define (chunk-skip-first-element-list)
  '())

;;Write chapter toc when only one element exists
(define %force-chapter-toc% 
	#t)

;;Admon Graphics customization
;;------------------

;;Should Admon Graphics be used?
(define %admon-graphics% 
	#t)

;;Where are those admon graphics?
(define %admon-graphics-path% 
	"./images/")

;; Name of the graphic for a given admonition.
(define ($admon-graphic$ #!optional (nd (current-node)))
  (cond ((equal? (gi nd) (normalize "tip"))
         (string-append %admon-graphics-path% "tip."
                        %graphic-default-extension%))
        ((equal? (gi nd) (normalize "note"))
         (string-append %admon-graphics-path% "note."
                        %graphic-default-extension%))
        ((equal? (gi nd) (normalize "important"))
         (string-append %admon-graphics-path% "important."
                        %graphic-default-extension%))
        ((equal? (gi nd) (normalize "caution"))
         (string-append %admon-graphics-path% "caution."
                        %graphic-default-extension%))
        ((equal? (gi nd) (normalize "home"))
         (string-append %admon-graphics-path% "home."
                        %graphic-default-extension%))
       ((equal? (gi nd) (normalize "warning"))
         (string-append %admon-graphics-path% "warning."
                        %graphic-default-extension%))
        (else (error (string-append (gi nd) " is not an admonition.")))))

;; Verbatim environments
;;-------------------

;;Should verbatim items be 'shaded' with a table?
(define %shade-verbatim% 
	#t)

;;Define shade-verbatim attributes
(define ($shade-verbatim-attr$)
  ;; Attributes used to create a shaded verbatim environment.
  (list
   (list "BORDER" "0")
   (list "BGCOLOR" "#CCDDBB")
   (list "WIDTH" ($table-width$))))

;; Navigation
;;---------

(define %navig-graphics-extension% 
	".png")

(define %navig-graphics-path%
 "./images/")

;; Tables customization
;;-----------------

;; Calculate table width
(define ($table-width$)
  (if (has-ancestor-member? (current-node) '("REVHISTORY"))
      "80%"
      "90%"))

(define ($cals-valign-default$) (normalize "middle"))

;; Graphics customization
;;-------------------

(define %graphic-extensions%
  ;; REFENTRY graphic-extensions
  ;; PURP List of graphic filename extensions
  ;; DESC
  ;; The list of extensions which may appear on a 'fileref'
  ;; on a 'Graphic' which are indicative of graphic formats.
  ;;
  ;; Filenames that end in one of these extensions will not have
  ;; the '%graphic-default-extension%' added to them.
  ;; /DESC
  ;; AUTHOR N/A
  ;; /REFENTRY
  '("gif" "jpg" "jpeg" "png" "tif" "tiff" "eps" "epsf" "tex"))

(define %graphic-default-extension% 
	"png")

(define preferred-mediaobject-notations
  (list "EPS" "PS" "JPG" "JPEG" "PNG" "TIFF" "linespecific"))

(define preferred-mediaobject-extensions
  (list "eps" "ps" "jpg" "jpeg" "png" "tiff"))

;; HTML parameters
;;--------------

;;Default extension for filenames?
(define %html-ext% 
  ".html")

;; Encoding
(define %html-header-tags%   '(("META" ("HTTP-EQUIV" "Content-Type") ("CONTENT" "text/html;charset=utf-8"))))

;; Name of the stylesheet
(define %stylesheet%
 "cssed-manual.css")

;; The filename of the root HTML document (e.g, "index").
(define %root-filename%
  "index")

;; Use id to build filenames
(define %use-id-as-filename%
 #t)

;; Miscellaneous
;;-----------

;; Full justification.
(define %default-quadding%
  "justify")

;; Footnotes at end
(define %footnotes-at-end%
	#t)

(define %bop-footnotes%
  ;; Make "bottom-of-page" footnotes?
  #t)

;; Titles of figures after the figures
 (define ($object-titles-after$)
  (list (normalize "figure")))

;; Make the formal para rendering better
(element formalpara
  (make element gi: "DIV"
	attributes: (list
		     (list "CLASS" (gi)))
  	(make element gi: "P"
	      (process-children))))

(element (formalpara title) 
  (make element gi: "B"
	($runinhead$)))

;; Title pages customization
;;---------------------

;; What's on the book titlepage. 
(define (book-titlepage-recto-elements)
  (list (normalize "title")
		(normalize "subtitle")
    (normalize "authorgroup")
		(normalize "author")
		(normalize "othercredit")
		(normalize "revhistory")
		(normalize "legalnotice")
		(normalize "abstract")
		(normalize "pubdate")
   	(normalize "copyright")))

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="dbstyle">

</style-sheet>
