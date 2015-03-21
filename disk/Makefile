#
# Makefile for Linux disk tools
#

BUILD = ../build

DIRS = mkpboot mvstrt

.PHONY:		all install clean

all:
		for i in $(DIRS) ; do \
		  $(MAKE) -C $$i all ; \
		done

install:
		mkdir -p $(BUILD)/run/fs-Linux
		rm -rf $(BUILD)/run/fs-Linux/*
		cp Makefile.run $(BUILD)/run/fs-Linux/Makefile
		for i in $(DIRS) ; do \
		  $(MAKE) -C $$i install ; \
		done

clean:
		for i in $(DIRS) ; do \
		  $(MAKE) -C $$i clean ; \
		done
		rm -f *~
