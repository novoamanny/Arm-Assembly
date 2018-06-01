@ Manuel Novoa
@ 1001411279

.global main
.func main

main:
MOV R0, #0              @ initialze index variable

writeloop:
CMP R0, #10            @ check to see if we are done iterating
BEQ writedone           @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
PUSH {R0}               @ backup iterator before procedure call
PUSH {R2}               @ backup element address before procedure call

BL _prompt
BL _scanf             @ get a number

POP {R2}                    @ restore element address
STR R0, [R2]            @ write the address of a[i] to a[i]
POP {R0}                @ restore iterator
ADD R0, R0, #1          @ increment index
B   writeloop           @ branch to next loop iteration
writedone:
MOV R0, #0              @ initialze index variable
readloop:
CMP R0, #10            @ check to see if we are done iterating
BEQ _search            @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
LDR R1, [R2]            @ read the array at address
PUSH {R0}               @ backup register before printf
PUSH {R1}               @ backup register before printf
PUSH {R2}               @ backup register before printf
MOV R2, R1              @ move array value to R2 for printf
MOV R1, R0              @ move array index to R1 for printf
BL  _printf             @ branch to print procedure with return
POP {R2}                @ restore register
POP {R1}                @ restore register
POP {R0}                @ restore register
ADD R0, R0, #1          @ increment index
B   readloop            @ branch to next loop iteration

_search:
BL _prompt2
BL _scanf2
MOV R0, #0              @ initialze index variable
MOV R7, #0
readloop2:
CMP R0, #10            @ check to see if we are done iterating
BEQ readdone            @ exit loop if done
LDR R1, =a              @ get address of a
LSL R2, R0, #2          @ multiply index*4 to get array offset
ADD R2, R1, R2          @ R2 now has the element address
LDR R1, [R2]            @ read the array at address
PUSH {R0}               @ backup register before printf
PUSH {R1}               @ backup register before printf
PUSH {R2}               @ backup register before printf
MOV R2, R1              @ move array value to R2 for printf
MOV R1, R0              @ move array index to R1 for printf
CMP R5, R2
BLEQ  _printf             @ branch to print procedure with return
ADDEQ R7, R7, #1

POP {R2}                @ restore register
POP {R1}                @ restore register
POP {R0}                @ restore register
ADD R0, R0, #1          @ increment index
B   readloop2            @ branch to next loop iteration

readdone:
CMP R7, #0
BLEQ _printf2

B _exit                 @ exit if done

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

_prompt2:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #31             @ print string length
LDR R1, =prompt_str2     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_printf:
PUSH {LR}               @ store the return address
LDR R0, =printf_str     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

_printf2:
PUSH {LR}               @ store the return address
LDR R0, =printf_str2     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ restore the stack pointer and return

_scanf:
PUSH {LR}               @ backup return address
SUB SP, SP, #4
LDR R0, =format_str
MOV R1, SP
BL scanf
LDR R0, [SP]
ADD SP, SP, #4
POP {PC}                @ return

_scanf2:
PUSH {LR}               @ backup return address
SUB SP, SP, #4
LDR R0, =format_str
MOV R1, SP
BL scanf
LDR R5, [SP]
ADD SP, SP, #4
POP {PC}                @ return

.data

.balign 4
a:              .skip       40
format_str:     .asciz      "%d"
printf_str:     .asciz      "array_a[%d] = %d\n"
printf_str2:     .asciz      "That value does not exist in the array!\n"
prompt_str:     .asciz      "Type a number and press enter: "
exit_str:       .ascii      "Terminating program.\n"
prompt_str2:     .asciz      "Enter a Search Value: "
