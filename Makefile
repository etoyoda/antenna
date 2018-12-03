
FILES = cron.sh post-none.xsl post-nws.xsl post-table.xsl

include .params.mk

install: .params.mk
	test -d $(DESTDIR)
	for f in $(FILES); do install $$f $(DESTDIR); done

.params.mk: Makefile
	echo -n DESTDIR: && read line && echo "DESTDIR=$$line" > .params && mv -f .params .params.mk
