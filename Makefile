#
# Makefile for Linux-on-ECO32 project
#

VERSION = 0.1

DIRS = disk os-bin
BUILD = ./build

all:		build-link
		for i in $(DIRS) ; do \
		  $(MAKE) -C $$i install ; \
		done

build-link:
		./make-link $(BUILD)

clean:
		for i in $(DIRS) ; do \
		  $(MAKE) -C $$i clean ; \
		done
		rm -f build
		rm -f *~
