.section .data
.align 12
.globl frame_buffer_info
frame_buffer_info:
    .int    1024        /* #0x0: Width          */
    .int    760         /* #0x4: Height         */
    .int    1024        /* #0x8: Virtual Width  */
    .int    760         /* #0xC: Virtual Height */
    .int    0           /* #0x10: GPU - Pitch   */
    .int    16          /* #0x14: Bit Depth     */
    .int    0           /* #0x18: X             */
    .int    0           /* #0x1C: Y             */
    .int    0           /* #0x20: GPU - Pointer */
    .int    0           /* #0x24: GPU - Size    */
