# cssed-manual Makefile (c) Iago Rubio 2003-2004
# Modified by Michele Garoche 24/08/2004

VERSION=0.3.0
MANUAL=cssed-manual
DSSSL=${MANUAL}.dsl
DB=${MANUAL}.sgml
TAR=${MANUAL}-${VERSION}.tar
BZIP=${MANUAL}-${VERSION}.bz2
MANUALSOURCE=${MANUAL}-sources
PNGS=figures/*.png
PSS=figures/*.eps
PDFS=figures/*.pdf
STYLESHEET_IMAGES=images

all:  builddate pdf ps html

ps: builddate $(DB) $(PNGS)
	./convertpngto $@
	./convertgif $@
	sed 's/è/\&\#232\;/g' < $(DB) > ${MANUAL}-eps.sgml
	jw -b ps -d "$$(pwd)/$(MANUAL)-ps.dsl" $(MANUAL)-eps.sgml -V paper-type=A4
	cp ${MANUAL}-eps.ps ${MANUAL}.ps
	-$(RM) ${MANUAL}-eps.ps
	-$(RM) ${MANUAL}-eps.sgml
	-$(RM) ${PSS}
	-$(RM) ${STYLESHEET_IMAGES}/*.eps
	
pdf: builddate $(DB) $(PNGS)
	./convertpngto $@
	./convertgif $@
	sed 's/è/\&\#232\;/g' < $(DB) > ${MANUAL}-pdf.sgml
	jw -b pdf -d "$$(pwd)/$(MANUAL)-pdf.dsl"  $(MANUAL)-pdf.sgml
	cp ${MANUAL}-pdf.pdf ${MANUAL}.pdf
	-$(RM) ${MANUAL}-pdf.pdf
	-$(RM) ${MANUAL}-pdf.sgml
	-$(RM) ${PDFS}
	-$(RM) ${STYLESHEET_IMAGES}/*.pdf
	
html: builddate $(DB) $(PNGS)
	-$(RM) -R $(MANUAL)
	mkdir -p $(MANUAL)/images
	cp -Rf  $(STYLESHEET_IMAGES)/*.png $(MANUAL)/images
	mkdir -p $(MANUAL)/figures
	cp -Rf  $(PNGS) ${MANUAL}/figures
	cp $(MANUAL).css $(MANUAL)
	cp COPYING-DOCS ${MANUAL}
	docbook2html -d "$$(pwd)/$(MANUAL)-html.dsl" -o $(MANUAL) $(DB)

builddate:
	echo -n `LC_ALL=en_US date "+%B %e, %Y"` > $@
	
clean:
	-$(RM) *.log *.dvi *.aux *.tex *.out
	-$(RM) builddate
	-$(RM) -r $(MANUAL) $(MANUAL).ps $(MANUAL).pdf
	-$(RM) ${PSS}
	-$(RM) ${PDFS}
	-$(RM) ${STYLESHEET_IMAGES}/*.eps
	-$(RM) ${STYLESHEET_IMAGES}/*.pdf
	-$(RM) ${TAR}.gz
	-$(RM) ${MANUAL}-sources.tgz

tar: html
	tar -czvf ${TAR}.gz ${MANUAL}

bzip:	tar
	bzip2 ${TAR}

tgz:	tar
	gzip -9 ${TAR}

dist: 
	-$(RM)  ${MANUALSOURCE}
	mkdir -p ${MANUALSOURCE}
	cp convertgif ${MANUALSOURCE}
	cp convertpngto ${MANUALSOURCE}
	cp COPYING-DOCS ${MANUALSOURCE}
	cp ${MANUAL}-*.dsl ${MANUALSOURCE}
	cp ${MANUAL}-*.sgml ${MANUALSOURCE}
	cp jadetex.cfg ${MANUALSOURCE}
	cp ${MANUAL}.css ${MANUALSOURCE}
	cp Makefile ${MANUALSOURCE}
	mkdir -p ${MANUALSOURCE}/figures
	mkdir -p ${MANUALSOURCE}/${STYLESHEET_IMAGES}
	cp -R ${PNGS} ${MANUALSOURCE}/figures
	cp -R ${STYLESHEET_IMAGES}/*.gif ${MANUALSOURCE}/${STYLESHEET_IMAGES}
	cp -R ${STYLESHEET_IMAGES}/*.png ${MANUALSOURCE}/${STYLESHEET_IMAGES}
	tar cvfz ${MANUALSOURCE}-${VERSION}.tgz ${MANUALSOURCE}
	rm -rf  ${MANUALSOURCE}

.PHONY: dist clean all builddate bzip2
