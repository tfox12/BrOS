.section .text

.globl clear_screen
clear_screen:

  clear_screen_store_registers:
    push {r3,r4,r5,r6,r7}
  
  clear_screen_load_buffer_location:
    ldr r3, =frame_buffer_info
    teq r3, #0
    beq clear_screen_restore_registers

  clear_screen_get_buffer_size:
    ldr r4, [r3       ]
    ldr r5, [r3, #0x04]
    mul r6, r4, r5
    lsl r6, #1

  clear_screen_set_background_color:
    ldrh r7, =0x0000FFFF
    ldr r4, [r3, #0x20]

  clear_screen_clear_loop:
    sub r6, r6, #2
    strh r7, [r4, r6]
    teq r6, #0
    bne clear_screen_clear_loop

  clear_screen_restore_registers:
    pop {r3,r4,r5,r6,r7}

mov pc, lr
