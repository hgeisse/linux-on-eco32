#
# Makefile to build the mvstrt program
#

BUILD = ../../build

.PHONY:		all install clean

all:		mvstrt.bin

install:	mvstrt.bin
		mkdir -p $(BUILD)/run/fs-Linux
		cp mvstrt.bin $(BUILD)/run/fs-Linux

mvstrt.bin:	mvstrt
		$(BUILD)/bin/load -p mvstrt mvstrt.bin

mvstrt:		mvstrt.o
		$(BUILD)/bin/ld -s mvstrt.lnk -o mvstrt mvstrt.o

mvstrt.o:	mvstrt.s
		$(BUILD)/bin/as -o mvstrt.o mvstrt.s

clean:
		rm -f *~ mvstrt.o mvstrt mvstrt.bin
