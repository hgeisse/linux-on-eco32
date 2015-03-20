#
# Makefile for copying the Linux image to the proper place
#

BUILD = ../build

all:		vmlinux.bin

install:	vmlinux.bin
		mkdir -p $(BUILD)/run/fs-Linux
		cp vmlinux.bin $(BUILD)/run/fs-Linux

clean:
		rm -f *~
