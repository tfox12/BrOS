org 0x7c00

mov cx, 2000
mov di, 0xb800
mov ax, 0xff20
mov es, di
xor di, di

clear:
    stosw
loop clear

times 510-($-$$) db 0

db 0x55
db 0xAA
