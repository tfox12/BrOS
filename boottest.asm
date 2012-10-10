org 0x7c00


;--------------------------------------------------;
; Set up interrupts
;--------------------------------------------------;
cli

mov bx, 0x09 ; interrupt 0x09 is keyboard access
shl bx, 2    ; multiply by 4, 4 bytes per idt entry
xor ax, ax
mov gs, ax
mov ds, ax
mov [gs:bx], WORD keyboard_interrupt_routine
mov [gs:bx+2], ds

sti

;--------------------------------------------------;
; Set print information
;--------------------------------------------------;
mov ax, 0xb800
mov es, ax
mov ah, 0xff

call clear_screen

mov DWORD [cursor], 0

jmp $

;--------------------------------------------------;
; print_char_to_location
; IN:   
;   ah -> Forground and Bacground Color
;   al -> ascii character to print
;--------------------------------------------------;    
print_char_to_cursor:

    ; registers used must be stored before hand
    push ax
    push bx
    push cx
    push di

    mov bx, [cursor]                ; load cursor position
    mov cx, ax                      ; save ax

    ; calculate offset to write character
    movzx ax, bh    
    mov dx, 160 
    mul dx
    movzx bx, bl
    shl bx, 1

    ; put the offset into di
    mov di, 0
    add di, ax
    add di, bx

    ; write the character
    mov ax, cx
    stosw

    ; restore register state
    pop di
    pop cx
    pop bx
    pop ax

ret


;--------------------------------------------------;    
; advance_cursor
;   Will either move the cursor to the right 1,
;   or will move the the start of the next line
;--------------------------------------------------;
advance_cursor:

    ; save the state of the used registers
    push ax

    mov ax, [cursor]                ; load the cursor into ax
    cmp al, 79                      ; is the cursor on the 79th col
    je advance_cursor_next_line     ; if so we want to go to the next line
    add al, 1                       ; otherwise we up the column
    jmp advance_cursor_exit

advance_cursor_next_line:
    xor al, al                      ; reset column to 0
    add ah, 1                       ; increment the row

advance_cursor_exit:
    mov [cursor], ax                ; save the position

    ; revert back to previous state
    pop ax

ret

;--------------------------------------------------;    
; clear_screen
; IN:
;   ah -> background color
;--------------------------------------------------;    
clear_screen:
    
    mov ah, 0xff                    ; set the clear color
    mov al, 0x20                    ; the space character
    mov DWORD [cursor], 0            ; set the cursor to 0,0
    mov cx, 2000                    ; we wanna run 2000 times

clear_screen_loop:
    call print_char_to_cursor
    call advance_cursor
    loop clear_screen_loop

ret

;--------------------------------------------------;
; Print Hex Value
;   prints a hex representation of byte in al
;--------------------------------------------------;
print_hex_at_cursor:
    
    push ax
    push bx
    push cx

    mov ch, al
    mov cl, al
    and ch, 0xf0
    and cl, 0x0f
    rol ch, 4
    
    mov ah, 0xf1

    movzx bx, ch
    mov al, BYTE [hextable + bx]
    call print_char_to_cursor
    call advance_cursor

    movzx bx, cl
    mov al, BYTE [hextable + bx]
    call print_char_to_cursor
    call advance_cursor

    pop cx
    pop bx
    pop ax

ret
    

;--------------------------------------------------;    
; Keyboard Interrupt
;--------------------------------------------------;    
keyboard_interrupt_routine:

    in al, 0x60
    test al, 0x80
    jz keyboard_interrupt_routine_keydown
    jmp keyboard_interrupt_routine_keyup

keyboard_interrupt_routine_keydown:

    movzx bx, al
    mov al, BYTE [lowercase_keys + bx]
    mov ah, 0xf1
    call print_char_to_cursor
    call advance_cursor

keyboard_interrupt_routine_keyup:

keyboard_interrupt_routine_done:
    
    mov ax, 0x20
    out 0x20, ax

iret


;-------------------------------------------------;
; System Variables
;-------------------------------------------------;

cursor dw 0

lowercase_keys db 0x00,0x00,'1','2','3','4','5','6','7','8','9','0','-','=',0x00,0x00,'q','w','e','r','t','y','u','i','o','p','[',']',0x00,0x00,'a','s','d','f','g','h','j','k','l',0x3b,0x27,0x00,0x00,0x5c,'z','x','c','v','b','n','m',0x02c,'.','/'


hextable db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

times 510-($-$$) db 0

db 0x55
db 0xAA
