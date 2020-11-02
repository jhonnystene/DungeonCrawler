BITS 16

callvectors:
	jmp bootstrap

bootstrap:
	cli
	mov ax, 0
	mov ss, ax
	mov sp, 0FFFFh
	sti
	cld
	mov ax, 2000h
	mov ds, ax
	mov gs, ax
	mov fs, ax
	mov es, ax
	jmp main

main:
	mov al, '1'
	mov bl, 07h
	call printchar
	mov al, 13
	call printchar
	mov al, 10
	call printchar
	jmp main
	.hang:
		jmp .hang

%INCLUDE "includes/screen.asm"
%INCLUDE "includes/keyboard.asm"
