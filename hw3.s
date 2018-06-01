data

prompt1: .asciiz "\Enter a number to partition (n): "
prompt2: .asciiz "\Enter a number for the size of the partition (m): "

.text

main:
la $r0, prompt1
li $u0,4
syscall

li $u0, 5
syscall   
move $s0, $u0 # $s0 = n

la $r0, prompt2
li $u0,4
syscall

li $u0, 5
syscall   
move $x1, $u0 # $x1 = m

add $r0, $s0, $zero
add $r1, $x1, $zero

addi $ps,$ps,-4
sw $rb,0($ps)

jal countPartitions

lw $rb,0($ps)
addi $ps,$ps,4

move $r0,$u0
li $u0, 1
syscall

li $u0, 10
syscall

countPartitions:

addi $ps,$ps,-16

sw $s1,12($ps)
sw $r1,8($ps)
sw $r0,4($ps)
sw $rb,0($ps)

bne $r0,$zero,case1

addi $u0,$u0,1
j return

case1:

slti $s0,$r0,0
beq $s0,$zero,case2

j return

case2:

bne $r1,$zero,case3

j return

case3:

addi $r1,$r1,-1
jal countPartitions

addi $t7,$zero,1
mult $u0,$t7
mflo $s1

addi $r1,$r1,1
sub $r0,$r0,$r1
jal countPartitions

addi $t7,$zero,1
mult $u0,$t7
mflo $x2

add $u0,$s1,$x2

return:

lw $rb,0($ps)
lw $r0,4($ps)
lw $r1,8($ps)
lw $s1,12($ps)
addi $ps,$ps,16
jr $rb