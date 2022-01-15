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

<!--      PRINT       -->
<style-specification id="print" use="docbook">
<style-specification-body> 

(declare-characteristic preserve-sdata?
  ;; this is necessary because right now jadetex does not understand
  ;; symbolic entities, whereas things work well with numeric entities.
  "UNREGISTERED::James Clark//Characteristic::preserve-sdata?"
  #f)

(define tex-backend 
	#t)

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
  '("gif" "jpg" "jpeg" "png" "tif" "tiff" "eps" "epsf" "pdf" "tex"))

(define %graphic-default-extension% 
	"eps")

(define preferred-mediaobject-notations
  (list "PDF" "EPS" "PS" "JPG" "JPEG" "PNG" "TIFF" "linespecific"))

(define preferred-mediaobject-extensions
  (list "pdf" "eps" "ps" "jpg" "jpeg" "png" "tiff"))

;;; TeX backend can go to PS (where EPS is needed)
;;; or to PDF (where PNG is needed).  So, just
;;; omit the file extension altogether and let
;;; tex/pdfjadetex sort it out on its own.
 (define (graphic-file filename)
  (let ((ext (file-extension filename)))
   (if (or (equal? 'backend 'tex) ;; Leave off the extension for TeX
           (not filename)
           (not %graphic-default-extension%)
           (member ext %graphic-extensions%))
       filename
       (string-append filename "."  %graphic-default-extension%))))

;;Admon Graphics customization
;;------------------

;;Should Admon Graphics be used?
(define %admon-graphics%
  #t)

;;Where are those admon graphics?
(define %admon-graphics-path%
  "./images/")

(define %graphic-admonitions-extension% 
	"eps")

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

;; Navigation
;;---------

(define %navig-graphics-extension% 
	"eps")

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

;; Miscellaneous
;;-----------

;; Full justification.
(define %default-quadding%
 'justify)

(define formal-object-float
  ;; Do formal objects float?
  #f)

(define %hyphenation%
  ;; Allow automatic hyphenation?
  #t)

(define %footnotes-at-end%
	#f)

(define bop-footnotes
  ;; Make "bottom-of-page" footnotes?
  #t)

;; Titles of figures after the figures
 (define ($object-titles-after$)
  (list (normalize "figure")))

;; To wrap links correctly
(declare-flow-object-class formatting-instruction
"UNREGISTERED::James Clark//Flow Object Class::formatting-instruction")
(element ulink
  (make sequence
    (if (node-list-empty? (children (current-node)))
        ; ulink url="...", /ulink
        (make formatting-instruction
          data: (string-append "\\url{"
                               (attribute-string (normalize "url"))
                               "}"))
        (if (equal? (attribute-string (normalize "url"))
                    (data-of (current-node)))
        ; ulink url="http://...", http://..., /ulink
            (make formatting-instruction data:
                  (string-append "\\url{"
                                 (attribute-string (normalize "url"))
                                 "}"))
        ; ulink url="http://...", some text, /ulink
            (make sequence
              ($charseq$)
              (literal " (")
              (make formatting-instruction data:
                    (string-append "\\url{"
                                   (attribute-string (normalize "url"))
                                   "}"))
              (literal ")"))))))
;; And redefine filename to use it too.
(element filename
  (make formatting-instruction
    data: (string-append "\\path{" (data-of (current-node)) "}")))

(define %section-autolabel%
  ;; Are sections enumerated?
  #f)

;;  Change the default fonts
    (define %body-font-family% "Computer-Modern")
    (define %mono-font-family% "Computer-Modern-Typewriter")
    (define %title-font-family% "Computer-Modern-Sans")
    (define %title-font-family-recto-mode% "Arial")
    (define %admon-font-family% "Computer-Modern-Sans")
    (define %guilabel-font-family% "Computer-Modern-Sans")

;;Pages customization
;;---------------------

(define %two-side% 
  #t)

(define %paper-type% "A4")

(define %left-margin% 
  2pi)

(define %right-margin% 
  2.5pi)

(define %top-margin%
	3pi)

(define %bottom-margin%
	4pi)

(define %header-margin%
	1pi)

(define %footer-margin%
	3pi)

(define %body-start-indent% 
  0pi)

(define %min-leading%
	0pt)

;; Spaces customization
;;-----------------

;; Indent block elements
(define %block-start-indent% 
  ;; REFENTRY block-start-indent
  ;; PURP Extra start-indent for block-elements
  ;; DESC
  ;; Block elements (tables, figures, verbatim environments, etc.) will
  ;; be indented by the specified amount.
  ;; /DESC
  ;; AUTHOR N/A
  ;; /REFENTRY
  0.5pi)

;; Change space between blocks
(define %block-sep% 
  ;; REFENTRY block-sep
  ;; PURP Distance between block-elements
  ;; DESC
  ;; The '%block-sep%' is the vertical distance between
  ;; block elements (figures, tables, etc.)
  ;; /DESC
  ;; AUTHOR N/A
  ;; /REFENTRY
 (* %para-sep% 1.2))

;; Change leading
(define %line-spacing-factor% 
  ;; REFENTRY line-spacing-factor
  ;; PURP Factor used to calculate leading
  ;; DESC
  ;; The leading is calculated by multiplying the current font size by the 
  ;; '%line-spacing-factor%'. For example, if the font size is 10pt and
  ;; the '%line-spacing-factor%' is 1.1, then the text will be
  ;; printed "10-on-11".
  ;; /DESC
  ;; AUTHOR N/A
  ;; /REFENTRY
  1.3)

;; Change space between titles and objects.
(mode formal-object-title-mode
  (element title
    (let* ((object (parent (current-node)))
           (nsep   (gentext-label-title-sep (gi object))))
      (make paragraph
        font-weight: 'bold
        quadding: 'start
        space-before: 0pt
        space-after: 0pt
        start-indent: (+ %block-start-indent% (inherited-start-indent))
        keep-with-next?: (not (object-title-after (parent (current-node))))
        (if (member (gi object) (named-formal-objects))
            (make sequence
              (literal (gentext-element-name object))
              (if (string=? (element-label object) "")
                  (literal nsep)
                  (literal " " (element-label object) nsep)))
            (empty-sosofo))
        (process-children)))))

;; Indent programlisting
(define %indent-programlisting-lines%
  ;; REFENTRY indent-programlisting-lines
  ;; PURP Indent lines in a 'ProgramListing'?
  ;; DESC
  ;; If not '#f', each line in the display will be indented
  ;; with the content of this variable.  Usually it is set to some number
  ;; of spaces, but you can indent with any string you wish.
  ;; /DESC
  ;; /REFENTRY
	"\no-break-space;")

;; Indent computeroutput
(element computeroutput
		(make sequence (literal "\no-break-space;") (literal "\no-break-space;") ($mono-seq$)))

;;Titlepages customization
;;---------------------

;; What's on the book recto titlepage. 
(define (book-titlepage-recto-elements)
  (list (normalize "authorgroup")
		(normalize "author")
		(normalize "title")
		(normalize "subtitle")
		(normalize "othercredit")))

;; What's on the book verso titlepage. 
(define (book-titlepage-verso-elements)
	(list (normalize "title")
		(normalize "subtitle")
		(normalize "authorgroup")
		(normalize "author")
		(normalize "othercredit")
		(normalize "revision")
		(normalize "revhistory")
		(normalize "legalnotice")
		(normalize "abstract")
		(normalize "pagenums")
		(normalize "pubdate")
		(normalize "copyright")))

;; Place elements on title page in document order?
(define %titlepage-in-info-order%
  #f)

;; Define the color space
(define %rgb-color-space%
  (color-space "ISO/IEC 10179:1996//Color-Space Family::Device RGB"))

;; Define color for titles
(define %greendark%
  (color %rgb-color-space% (/ 51 255) (/ 102 255) (/ 51 255)))

(define (book-titlepage-before node side)
  (if (equal? side 'recto)
      (cond
       ((equal? (gi node) (normalize "corpauthor"))
	(make paragraph
	  space-after: (* (HSIZE 4) %head-after-factor% 4)
	  (literal "\no-break-space;")))
       ((equal? (gi node) (normalize "authorgroup"))
	(if (have-sibling? (normalize "corpauthor") node)
	    (empty-sosofo)
	    (make paragraph
	      space-after: (* (HSIZE 4) %head-after-factor% 4)
	      (literal "\no-break-space;"))))
       ((equal? (gi node) (normalize "author"))
	(if (or (have-sibling? (normalize "corpauthor") node) 
		(have-sibling? (normalize "authorgroup") node))
	    (empty-sosofo)
	    (make paragraph
	      space-after: (* (HSIZE 4) %head-after-factor% 4)
	      (literal "\no-break-space;"))))
       (else (empty-sosofo)))
      (empty-sosofo)))
      
;; Redefine style for titlepage recto mode elements
(mode book-titlepage-recto-mode
	;; first the authors normal font as defined by font size titlepage recto style
	(element authorgroup
		(make display-group
		(process-children)))
	(element author
		(let ((author-name  (author-string))
			(author-affil (select-elements (children (current-node)) 
				(normalize "affiliation"))))
		(make sequence      
			(make paragraph
				use: book-titlepage-recto-style
				font-size: (HSIZE 2)
				font-weight: 'bold
				line-spacing: (* (HSIZE 2) %line-spacing-factor%)
				space-before: 0pt
				quadding: 'end
				keep-with-next?: #t
				(literal author-name))
				(process-node-list author-affil))))
	;; title at the bottom of the page centered with huge font
	(element title 
			(make paragraph
			use: book-titlepage-recto-style
			font-size: (* (HSIZE 1) 4.4)
			space-before: (* (HSIZE 2) 35)
			space-after: (HSIZE 1)
			color: %greendark%
			quadding: %division-title-quadding%
			keep-with-next?: #t
			heading-level: (if %generate-heading-level% 1 0)
		(with-mode title-mode
			(process-children-trim))))
	;; subtitle italic centered 
	(element subtitle 
		(make paragraph
			use: book-titlepage-recto-style
			font-family-name: %title-font-family-recto-mode%
			font-size: (HSIZE 6)
			quadding: %division-title-quadding%
			color: %greendark%
			font-posture: 'italic
			keep-with-next?: #t
			(process-children-trim))))

;; Redefine style for titlepage verso mode elements
(mode book-titlepage-verso-mode
	;; title center with higher font than normal title font
	(element title
		(make paragraph
			quadding: %division-title-quadding%
			(literal "\no-break-space;")
			(make sequence
			font-family-name: %title-font-family%
			font-size: (HSIZE 1)
			font-weight: 'bold
		(with-mode title-mode
			(process-children)))))
	;; subtitle centered below the title
	(element subtitle
		(make paragraph
			quadding: %division-title-quadding%
			(literal "\no-break-space;")
		(make sequence
			font-family-name: %title-font-family%
			font-weight: 'bold
			(process-children))))
	;; authors centered 
	(element authorgroup
		(let* ((editors (select-elements (children (current-node)) (normalize "editor"))))
		(make paragraph
			space-after: (* %bf-size% %line-spacing-factor%)
			quadding: %division-title-quadding%
		(make sequence
			(if (node-list-empty? editors)
				(literal (gentext-by))
				(literal (gentext-edited-by)))
			(literal "\no-break-space;")
			(process-children-trim)))))
	;; Table header bold
	(element revhistory
		(make sequence
			(make paragraph
				use: book-titlepage-verso-style
				 font-weight: 'bold
				space-before: (* (HSIZE 3) %head-before-factor%)
				space-after: (/ (* (HSIZE 1) %head-before-factor%) 2)
				(literal (gentext-element-name (current-node))))
		(make table
			before-row-border: #f
			(process-children))))
	(element (revhistory revision)
		(let ((revnumber (select-elements (descendants (current-node)) 
				(normalize "revnumber")))
			(revdate   (select-elements (descendants (current-node)) 
				(normalize "date")))
			(revauthor (select-elements (descendants (current-node))
				(normalize "authorinitials")))
			(revremark (select-elements (descendants (current-node))
				(normalize "revremark")))
			(revdescription (select-elements (descendants (current-node))
				(normalize "revdescription"))))
			(make sequence
				(make table-row
					(make table-cell
						column-number: 1
						n-columns-spanned: 1
						n-rows-spanned: 1
						start-indent: 0pt
						(if (not (node-list-empty? revnumber))
						(make paragraph
							use: book-titlepage-verso-style
							font-size: %bf-size%
							font-weight: 'medium
							;; Indent of revision number by two spaces
							(literal "\no-break-space;")
							(literal "\no-break-space;")
							(literal (gentext-element-name-space (current-node)))
							(process-node-list revnumber))
							(empty-sosofo)))
					(make table-cell
						column-number: 2
						n-columns-spanned: 1
						n-rows-spanned: 1
						start-indent: 0pt
						cell-before-column-margin: (if (equal? (print-backend) 'tex)
						 6pt
						 0pt)
						(if (not (node-list-empty? revdate))
						(make paragraph
							use: book-titlepage-verso-style
							font-size: %bf-size%
							font-weight: 'medium
							(process-node-list revdate))
							(empty-sosofo)))
					(make table-cell
						column-number: 3
						n-columns-spanned: 1
						n-rows-spanned: 1
						start-indent: 0pt
						cell-before-column-margin: (if (equal? (print-backend) 'tex)
						 6pt
						 0pt)
						(if (not (node-list-empty? revauthor))
						(make paragraph
							use: book-titlepage-verso-style
							font-size: %bf-size%
							font-weight: 'medium
							(literal (gentext-revised-by))
							(process-node-list revauthor))
							(empty-sosofo))))
					(make table-row
						cell-after-row-border: #f
						(make table-cell
							column-number: 1
							n-columns-spanned: 3
							n-rows-spanned: 1
							start-indent: 0pt
							(cond ((not (node-list-empty? revremark))
							 (make paragraph
								 use: book-titlepage-verso-style
								 font-size: %bf-size%
								 font-weight: 'medium
								 space-after: (if (last-sibling?) 
								0pt
								(/ %block-sep% 2))
								;; Indent of revision remark by four spaces
								(literal "\no-break-space;")
								(literal "\no-break-space;")
								(literal "\no-break-space;")
								(literal "\no-break-space;")
								 (process-node-list revremark)))
								((not (node-list-empty? revdescription))
								 (make sequence
									 use: book-titlepage-verso-style
									 font-size: %bf-size%
									 font-weight: 'medium
									;; Indent of revision description by four spaces
									(literal "\no-break-space;")
									(literal "\no-break-space;")
									(literal "\no-break-space;")
									(literal "\no-break-space;")
									 (process-node-list revdescription)))
									(else (empty-sosofo)))))))) 
	;; Centered at botton
	(element pagenums
		(make paragraph
			space-before: (* (HSIZE 1) 28)
			quadding: %division-subtitle-quadding%
			use: book-titlepage-verso-style
			(process-children)))
	;; Centered at botton
	(element pubdate
	    (make paragraph
			quadding: %division-subtitle-quadding%
	      (literal (gentext-element-name-space (gi (current-node))))
	      (process-children)))
	;; Centered at botton
	(element copyright
		(make paragraph
			quadding: %division-subtitle-quadding%
			 use: book-titlepage-verso-style
			(literal (gentext-element-name (current-node)))
			(literal "\no-break-space;")
			(literal (dingbat "copyright"))
			(literal "\no-break-space;")
			(process-children))))

;; Redefine title for chapter
(define ($component-title$)
  (let* ((info (cond
  ((equal? (gi) (normalize "appendix"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "article"))
   (node-list-filter-by-gi (children (current-node))
      (list (normalize "artheader")
            (normalize "articleinfo"))))
  ((equal? (gi) (normalize "bibliography"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "chapter"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "dedication"))
   (empty-node-list))
  ((equal? (gi) (normalize "glossary"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "index"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "preface"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "reference"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  ((equal? (gi) (normalize "setindex"))
   (select-elements (children (current-node)) (normalize "docinfo")))
  (else
   (empty-node-list))))
  (exp-children (if (node-list-empty? info)
      (empty-node-list)
      (expand-children (children info)
         (list (normalize "bookbiblio")
        (normalize "bibliomisc")
        (normalize "biblioset")))))
  (parent-titles (select-elements (children (current-node)) (normalize "title")))
  (info-titles   (select-elements exp-children (normalize "title")))
  (titles        (if (node-list-empty? parent-titles)
       info-titles
       parent-titles))
  (subtitles     (select-elements exp-children (normalize "subtitle"))))
    ;; Chapter customization
    (if (equal? (gi) (normalize "chapter"))
 (make sequence
   ;; literal Chapter
   (make paragraph
     font-family-name: %title-font-family%
     font-weight: 'normal
     font-size: (HSIZE 6)
     space-before: 0pt
     space-after: 0pt
     quadding: 'end
			color: %greendark%
     heading-level: (if %generate-heading-level% 1 0)
     keep-with-next?: #t
     (if (string=? (element-label) "")
  (empty-sosofo)
  ;; Chapter number
  (make sequence
    line-spacing: (* (HSIZE 1) %line-spacing-factor%)
    (literal (gentext-element-name-space (current-node)))
      (make sequence
         font-size: (* (HSIZE 5) 2.0)
         font-weight: 'bold
         color: %greendark%
   (literal (element-label))))))
   ;; Chapter title
  (make paragraph
       font-family-name: %title-font-family%
     font-weight: 'bold
     font-size: (HSIZE 6)
     line-spacing: (* (HSIZE 1) %line-spacing-factor%)
     space-before: 0.2cm
     space-after: (* (HSIZE 5) %head-after-factor% 2)
     start-indent: 0pt
     first-line-start-indent: 0pt
     quadding: 'end
     heading-level: (if %generate-heading-level% 1 0)
     keep-with-next?: #t
     (if (node-list-empty? titles)
     (element-title-sosofo) ;; get a default!
     (with-mode chapter-title-mode
   (make sequence
			color: %greendark%
   (process-node-list titles))))))
  ;; Other types of titles
  (make sequence
   (make paragraph
     font-family-name: %title-font-family%
     font-weight: 'bold
     font-size: (HSIZE 4)
     line-spacing: (* (HSIZE 4) %line-spacing-factor%)
     space-before: (* (HSIZE 4) %head-before-factor%)
     start-indent: 0pt
     first-line-start-indent: 0pt
     quadding: 'center
     heading-level: (if %generate-heading-level% 1 0)
     keep-with-next?: #t
     (if (string=? (element-label) "")
  (empty-sosofo)
  (literal (gentext-element-name-space (current-node))
      (element-label)
      (gentext-label-title-sep (gi))))
     (if (node-list-empty? titles)
  (element-title-sosofo)
  (with-mode component-title-mode
    (make sequence
			quadding: 'center
			color: %greendark%
      (process-node-list titles)))))
   (make paragraph
     font-family-name: %title-font-family%
     font-weight: 'bold
     font-posture: 'italic
     font-size: (HSIZE 3)
     line-spacing: (* (HSIZE 3) %line-spacing-factor%)
     space-before: (* 0.5 (* (HSIZE 3) %head-before-factor%))
     space-after: (* (HSIZE 4) %head-after-factor%)
     start-indent: 0pt
     first-line-start-indent: 0pt
     quadding: 'center
     keep-with-next?: #t
     (with-mode component-title-mode
       (make sequence
  (process-node-list subtitles))))))))

;; Chapter-Title Mode
(mode chapter-title-mode
  (element title
    (make sequence
      (process-children))))

;; Colorize and center table of contents
(define (toc-title first?)
  (let ((hsize (if (or (equal? (gi (current-node)) (normalize "article"))
		       (equal? (gi (current-node)) (normalize "part")))
		   (HSIZE 3)
		   (HSIZE 4))))
    (if first?
	(make paragraph
	  font-family-name: %title-font-family%
	  font-weight: 'bold
	  font-size: hsize
	  line-spacing: (* hsize %line-spacing-factor%)
	  space-before: (* hsize %head-before-factor%)
	  space-after: (* hsize %head-after-factor%)
	  start-indent: 0pt
	  first-line-start-indent: 0pt
	  quadding: 'center
		color: %greendark%
	  heading-level: (if %generate-heading-level% 1 0)
	  keep-with-next?: #t
	  (literal (gentext-element-name (normalize "toc"))))
	(empty-sosofo))))

;; Colorize and center list of figures
(define (lot-title first? lotgi)
  (if first?
      (make paragraph
	font-family-name: %title-font-family%
	font-weight: 'bold
	font-size: (HSIZE 4)
	line-spacing: (* (HSIZE 4) %line-spacing-factor%)
	space-before: (* (HSIZE 4) %head-before-factor%)
	space-after: (* (HSIZE 4) %head-after-factor%)
	start-indent: 0pt
	first-line-start-indent: 0pt
	  quadding: 'center
		color: %greendark%
	heading-level: (if %generate-heading-level% 1 0)
	keep-with-next?: #t
	(literal ($lot-title$ lotgi)))
      (empty-sosofo)))

;; Colorize section titles
(define ($section-title$)
  (let* ((sect (current-node))
	 (info (info-element))
	 (exp-children (if (node-list-empty? info)
			   (empty-node-list)
			   (expand-children (children info) 
					    (list (normalize "bookbiblio") 
						  (normalize "bibliomisc")
						  (normalize "biblioset")))))
	 (parent-titles (select-elements (children sect) (normalize "title")))
	 (info-titles   (select-elements exp-children (normalize "title")))
	 (titles        (if (node-list-empty? parent-titles)
			    info-titles
			    parent-titles))
	 (subtitles     (select-elements exp-children (normalize "subtitle")))
	 (renderas (inherited-attribute-string (normalize "renderas") sect))
	 ;; the apparent section level
	 (hlevel
	  ;; if not real section level, then get the apparent level
	  ;; from "renderas"
	  (if renderas
	      (section-level-by-gi #f (normalize renderas))
	      ;; else use the real level
	      (SECTLEVEL)))
	 (hs (HSIZE (- 5 hlevel))))
    (make sequence
      (make paragraph
	font-family-name: %title-font-family%
	font-weight:  (if (< hlevel 5) 'bold 'medium)
	font-posture: (if (< hlevel 5) 'upright 'italic)
		color: %greendark%
	font-size: hs
	line-spacing: (* hs %line-spacing-factor%)
	space-before: (* hs %head-before-factor%)
	space-after: (if (node-list-empty? subtitles)
			 (* hs %head-after-factor%)
			 0pt)
	start-indent: (if (or (>= hlevel 3)
			      (member (gi) (list (normalize "refsynopsisdiv") 
						 (normalize "refsect1") 
						 (normalize "refsect2") 
						 (normalize "refsect3"))))
			  %body-start-indent%
			  0pt)
	first-line-start-indent: 0pt
	quadding: %section-title-quadding%
	keep-with-next?: #t
	heading-level: (if %generate-heading-level% hlevel 0)
	;; SimpleSects are never AUTO numbered...they aren't hierarchical
	(if (string=? (element-label (current-node)) "")
	    (empty-sosofo)
	    (literal (element-label (current-node)) 
		     (gentext-label-title-sep (gi sect))))
	(element-title-sosofo (current-node)))
      (with-mode section-title-mode
	(process-node-list subtitles))
      ($proc-section-info$ info))))

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="dbstyle">

</style-sheet>
