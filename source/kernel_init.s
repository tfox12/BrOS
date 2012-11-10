.section .init
.globl _start
_start:

b kernel_main

.section .text

init_OK_LED:
    push {r0,r1}

    ldr r0, =0x20200000
    mov r1, #1
    lsl r1, #18
    str r1, [r0,#4]

    pop {r0,r1}

mov pc, lr

.globl turn_on_OK_LED
turn_on_OK_LED:
    push {r0,r1}

    ldr r0, =0x20200000
    mov r1, #1
    lsl r1, #16
    str r1, [r0,#40]

    pop {r0,r1}

mov pc, lr

.globl turn_off_OK_LED
turn_off_OK_LED:
    push {r0,r1}

    ldr r0, =0x20200000
    mov r1, #1
    lsl r1, #16
    str r1, [r0,#28]

    pop {r0,r1}

mov pc, lr

.globl kernel_main
kernel_main:

    mov sp, #0x8000

    bl init_OK_LED
    bl turn_on_OK_LED

    /* send the frame buffer data to the GPU  */
    ldr r0, =frame_buffer_info
    mov r2, r0
    mov r1, #1
    bl postman_deliver_mail

    /* read the result */
    mov r0, #1
    bl postman_receive_mail
    teq r1, #0
    beq kernel_end

    /* wait until buffer pointer is set */
  test_loop:
    ldr r0, =frame_buffer_info
    ldr r0, [r0,#0x20]
    teq r0, #0
    beq test_loop

    bl turn_off_OK_LED

    bl clear_screen

kernel_end:
    b kernel_end
