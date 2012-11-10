.section .text

.globl postman_deliver_mail
.globl postman_receive_mail

/*
 *  postman_deliver_mail:
 *  INPUT:  r0 <- message to write
 *          r1 <- which mailbox to write it to
 *  OUTPUT: --
 */
postman_deliver_mail:
  
  pdm_input_registers:
    message .req r0
    mailbox_number .req r1

  pdm_store_temp_registers:
    push {r2,r3}
    postman_base .req r2
    status .req r3

  pdm_get_mailbox_address:
    ldr postman_base, =postman_base_ptr
    ldr postman_base, [postman_base]

  pdm_check_status:
    ldr status, [postman_base, #0x18]
    tst status, #0xB0000000
    bne pdm_check_status
    
  pdm_deliver:
    and message, message, #0xFFFFFFF0
    and mailbox_number, mailbox_number, #0x0000000F
    add message, mailbox_number
    str message, [postman_base, #0x20]

  pdm_restore_temp_registers:
    .unreq postman_base
    .unreq status
    pop {r2,r3}

  pdm_resore_input_registers:
    .unreq message
    .unreq mailbox_number

mov pc, lr

/*
 *  postman_receive_mail:
 *  INPUT: r0 <- mailbox to read from
 *  OUTPUT: r1 <- data from mailbox
 */
postman_receive_mail:

  prm_input_registers:
    mailbox_number .req r0
    result_data .req r1

  prm_store_temp_registers:
    push {r2,r3,r4}
    postman_base .req r2
    status .req r3
    read_data .req r4

  prm_get_mailbox_address:
    ldr postman_base, =postman_base_ptr
    ldr postman_base, [postman_base]

  prm_check_status:
    ldr status, [postman_base, #0x18]
    tst status, #0x40000000
    bne prm_check_status

  prm_receive:
    ldr read_data, [postman_base]
    and mailbox_number, mailbox_number, #0x000000FF
    tst mailbox_number, read_data
    bne prm_check_status

  prm_prepare_data:
    and result_data, read_data, #0xFFFFFFF0

  prm_restore_temp_registers:
    .unreq postman_base
    .unreq status
    .unreq read_data
    pop {r2,r3,r4}

  prm_resore_input_registers:
    .unreq mailbox_number
    .unreq result_data  

mov pc, lr

.section .data
postman_base_ptr:
    .int 0x2000B880
