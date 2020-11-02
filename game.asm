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
	mov byte [default_color], 0Fh
	call clearscreen
	
	mov si, msg_name_prompt
	call printstring
	
	mov ax, 64
	mov bx, player_name
	call getstring
	
	mov si, player_name
	call printstring
	
	mov si, msg_testmap
	call printmap
	
	.hang:
		jmp .hang

printplayerstats:
	pusha
	mov si, msg_hp
	call printstring
	mov al, [player_hp]
	call print2hex
	mov al, '/'
	call printchar
	mov al, [player_hp_max]
	call print2hex
	mov al, ' '
	call printchar
	
	mov si, msg_xp
	call printstring
	mov al, [player_xp]
	call print2hex
	mov al, '/'
	call printchar
	mov al, [player_xp_till]
	call print2hex
	mov al, ' '
	call printchar
	
	mov si, msg_level
	call printstring
	mov al, [player_level]
	call print2hex
	
	call newline
	popa
	ret
	
printmap:
	pusha
	call clearscreen
	
	.loop:
		lodsb
		cmp al, 0
		je .done
		
		mov bl, [color_white]
		
		cmp al, '#'
		je .green
		
		cmp al, '*'
		je .brown
		
		cmp al, '@'
		je .yellow
		
		cmp al, '$'
		je .blue
		
	.print:
		call printchar_color
		jmp .loop
		
	.green:
		mov bl, [color_green]
		jmp .print
	
	.brown:
		mov bl, [color_brown]
		jmp .print
	
	.yellow:
		mov bl, [color_yellow]
		jmp .print
	
	.blue:
		mov bl, [color_blue]
		jmp .print
	
	.done:
		popa
		ret
	
player_name		times 64 db 0
player_hp		db 100
player_hp_max	db 100
player_xp		db 0
player_xp_till	db 10
player_level	db 1

msg_name_prompt	db "What is your name? ", 0
msg_hp			db "HP: ", 0
msg_xp			db "XP: ", 0
msg_level		db "Level: ", 0

msg_testmap		db "###$", 13, 10, "#*#$", 13, 10, "@##$", 13, 10, "##*#", 13, 10, 0

%INCLUDE "includes/screen.asm"
%INCLUDE "includes/keyboard.asm"
%INCLUDE "includes/palette.asm"
