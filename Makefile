
all:
	make update
	make libracc.rb


DEBUG = #-g
TMP = ${DEBUG} -v#P
RUBYPATH = /usr/local/bin/ruby
DRACC    = racc ${TMP} -e${RUBYPATH}


# app data

VERSION  = 0.9.5
APPNAME  = racc


# dirs

include ../makefile.common


##### source file

BACKUPF  = ${RACCSRC} ${RACCTOOL} ${RACCBIN} \
           ${CALCSRC} ${CALCTOOL}

RACCBIN  = racc
RACCRB   = racc libracc.rb

RACCSRC  = \
           d.head.rb   \
           d.facade.rb \
	         d.scan.rb   \
	         d.parse.rb  \
           d.rule.rb   \
	         d.state.rb  \
           d.format.rb \
					 parser.rb

RACCTOOL = Makefile bld.rb

LIBSRC   = \
           extmod.rb   \
					 must.rb     \
					 bug.rb      \
					 scanner.rb  \
					 #

CALCSRC  = calc.y
CALCTOOL = calc.makefile

HTML     = \
           index.html   \
           command.html \
           grammer.html \
           changes.html \
           debug.html

TEXT     = README.ja README.en

#-------------------------------------------------------------

libracc.rb: ${RACCTOOL} ${RACCSRC}
	./bld.rb &> er

debug: ${RACCTOOL} ${RACCSRC}
	update -w2 -v${VERSION} ${RACCSRC} ${RACCBIN}
	./bld.rb -g &> er

#-------------------------------------------------------------

e: all e.racc.y
	${DRACC} -oout e.racc.y &> er

test: debug
	${DRACC} -ochk.rb chk.y &> er
	./chk.rb

calc: libracc.rb racc
	make -f calc.makefile

rmcalc:
	rm -f calc.rb calc.output

#-------------------------------------------------------------

clean:
	rm -f libracc.rb racc-*.tar.gz chk.rb
	cd ${BINDIR} ; rm -f racc
	cd ${LIBDIR} ; rm -f libracc.rb

install: racc libracc.rb
	mupdate racc ${BINDIR}/racc
	mupdate libracc.rb ${LIBDIR}/libracc.rb

pack:
	make update
	make archive

update:
	cupdate -t -w2 -v${VERSION} ${RACCSRC} ${RACCBIN}

#-------------------------------------------------------------

archive: ${ARC}

set_arcsource: set_ruby set_lib set_calc set_text set_html

set_ruby:
	cupdate -t -v${VERSION} -c -s. -d${ARCDIR} ${RACCRB}

set_lib:
	cupdate -t -c -s${LIBDIR} -d${ARCDIR} ${LIBSRC}

set_calc:
	cupdate -t -c -s. -d ${ARCDIR} ${CALCSRC}
	mupdate calc.makefile ${ARCDIR}/Makefile

set_html:
	cupdate -c -s${HTMLDIR}/ja -d${ARCDIR}/doc.ja ${HTML}
	cupdate -c -s${HTMLDIR}/en -d${ARCDIR}/doc.en ${HTML}

set_text:
	tab ${TEXTDIR}/*.en
	cupdate -c -s${TEXTDIR} -d${ARCDIR} ${TEXT}

#-------------------------------------------------------------

site:
	rm -f ${SITEDIR}/${APPNAME}-*.tar.gz
	cp ${ARC} ${SITEDIR}/${ARC}
	cupdate -c -s${HTMLDIR}/ja -d${JSITEDOC} ${HTML}
	cupdate -c -s${HTMLDIR}/en -d${ESITEDOC} ${HTML}

#-------------------------------------------------------------