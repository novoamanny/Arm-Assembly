@Manuel Novoa
@1001411279
	.global main
	.func main

main:
    B _loop

_loop:
    BL _prompt
    BL _scanf
    MOV R5, R0
    VMOV S0, R0
    VCVT.F32.U32 S0, S0
    BL _printf
    BL _prompt
    BL _scanf
    MOV R7, R0
    VMOV S1, R0
    VCVT.F32.U32 S1, S1
    BL _printf2


    BL _divide

    BL _printf_result

    B _loop
   
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
       
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R5              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return

_printf2:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R7              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf

    LDR R0, =printf_n     @ R0 contains formatted string address
    MOV R1, R5              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf

    LDR R0, =printf_d     @ R0 contains formatted string address
    MOV R1, R7              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf

    MOV PC, R4              @ return
    
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_divide:
    VDIV.F32 S2, S0, S1

    VCVT.F64.F32 D4, S2
    VMOV R1, R2, D4




_printf_result:
    PUSH {LR}               @ push LR to stack
    LDR R0, =result_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ pop LR from stack and return


.data
format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a number and press enter: "
prompt_str2:	.asciz	    "Type a second number and press enter:"
printf_str:     .asciz      "The number entered was: %d\n"
printf_n:       .asciz      "%d / "
printf_d:       .asciz      "%d = "
result_str:     .asciz      "%f \n"
exit_str:       .ascii      "Terminating program.\n"
