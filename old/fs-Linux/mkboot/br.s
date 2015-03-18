;
; br.s -- the boot record
;

; Runtime environment:
;
; This code must be loaded and started at 0xC0010000.
; It allocates a stack from 0xC0011000 downwards. So
; it must run within 4K (code + data + stack).
;
; This code expects the disk number of the boot disk
; in $16, the start sector of the disk or partition
; to be booted in $17 and its size in $18.
;
; The Linux binary image (together with the tiny "mvstrt"
; program), which is loaded by this code, must be in
; standalone (headerless) executable format, stored at
; partition relative disk sectors 1..8192, and gets
; loaded and started at 0xC0400000.

	.set	stacktop,0xC0011000	; top of stack
	.set	loadaddr,0xC0400000	; where to load the image

	.set	cout,0xC0000020		; the monitor's console output
	.set	dskio,0xC0000028	; the monitor's disk I/O

	; load the image and start it
start:
	add	$29,$0,stacktop		; setup stack
	add	$4,$0,strtmsg		; say what is going on
	jal	msgout
	; $19 = sector number
	; $20 = load address
	; $21 = sectors left
	add	$19,$0,1		; start loading with sector 1
	add	$20,$0,loadaddr		; where to load the image
	add	$21,$0,8192		; how many sectors to load
start1:
	add	$4,$0,'.'
	jal	chrout
	add	$4,$0,$19
	add	$5,$0,$20
	and	$5,$5,0x3FFFFFFF
	add	$6,$0,256		; load in pieces of 256 sectors
	jal	rdsct
	add	$19,$19,256
	add	$20,$20,256*512
	sub	$21,$21,256
	bgt	$21,$0,start1
	add	$4,$0,mvmsg		; say what is going on
	jal	msgout
	add	$8,$0,loadaddr		; start executing mvstrt
	jr	$8

	; read disk sectors
	;   $4 start sector number (disk or partition relative)
	;   $5 transfer address
	;   $6 number of sectors
rdsct:
	sub	$29,$29,32
	stw	$31,$29,20
	stw	$6,$29,16		; sector count
	add	$7,$5,$0		; transfer address
	add	$6,$4,$17		; relative sector -> absolute
	add	$5,$0,'r'		; command
	add	$4,$0,$16		; disk number
	add	$8,$0,dskio
	jalr	$8
	bne	$2,$0,rderr		; error?
	ldw	$31,$29,20
	add	$29,$29,32
	jr	$31

	; disk read error
rderr:
	add	$4,$0,dremsg
	jal	msgout
	j	halt

	; output message
	;   $4 pointer to string
msgout:
	sub	$29,$29,8
	stw	$31,$29,4
	stw	$16,$29,0
	add	$16,$4,0		; $16: pointer to string
msgout1:
	ldbu	$4,$16,0		; get character
	beq	$4,$0,msgout2		; done?
	jal	chrout			; output character
	add	$16,$16,1		; bump pointer
	j	msgout1			; continue
msgout2:
	ldw	$16,$29,0
	ldw	$31,$29,4
	add	$29,$29,8
	jr	$31

	; output character
	;   $4 character
chrout:
	sub	$29,$29,4
	stw	$31,$29,0
	add	$8,$0,cout
	jalr	$8
	ldw	$31,$29,0
	add	$29,$29,4
	jr	$31

	; halt execution by looping
halt:
	add	$4,$0,hltmsg
	jal	msgout
halt1:
	j	halt1

	; messages
strtmsg:
	.byte	"Loading image ", 0
mvmsg:
	.byte	0x0D, 0x0A, "Moving image", 0x0D, 0x0A, 0
dremsg:
	.byte	"Disk read error", 0x0D, 0x0A, 0
hltmsg:
	.byte	"Bootstrap halted", 0x0D, 0x0A, 0

	; boot record signature
	.locate	512-2
	.byte	0x55, 0xAA
