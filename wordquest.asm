
# ==========================================================
# WORDQUEST - WORD SEARCH PUZZLE
# MIPS Assembly | MARS Simulator
# Horizontal + Vertical Word Search
# ==========================================================

.data

title:       .asciiz "\n========================================\n             WORDQUEST\n          WORD SEARCH PUZZLE\n========================================\n"

instructions: .asciiz "\nFind 8 hidden words in the 8 x 8 grid.\nWords can be horizontal or vertical.\nReverse directions are also accepted.\n"

gridTitle:   .asciiz "\n              LETTER GRID\n\n"
grid:        .asciiz "CATXPLANBRAVOQR TAPPLEMONBRAVOSSTMANGODEEHOUSEFGHLIGHTJKLSMILEPQR"

menu:        .asciiz "\n\n--------------- GAME MENU ---------------\n1. Find a word\n2. Get a hint (-5 points)\n3. Exit game\nChoose option: "

rowPrompt:   .asciiz "\nEnter starting row (1-8): "
colPrompt:   .asciiz "Enter starting column (1-8): "
endRowPrompt:.asciiz "Enter ending row (1-8): "
endColPrompt:.asciiz "Enter ending column (1-8): "

invalidInput:.asciiz "\nInvalid coordinates! Use numbers from 1 to 8.\n"
invalidLine: .asciiz "\nInvalid selection! Select a straight horizontal or vertical line.\n"
invalidLength:.asciiz "\nInvalid selection length!\n"
wrongWord:   .asciiz "\nNot a hidden word! Try again. One life lost.\n"
correctWord: .asciiz "\nExcellent! You found: "
duplicate:   .asciiz "\nYou already found that word!\n"

hintMenu:    .asciiz "\nChoose a word number for a hint (1-8): "
hintText:    .asciiz "\nHint: Starting position = Row "
hintCol:     .asciiz ", Column "
hintEnd:     .asciiz "\nEnding position = Row "
hintEndCol:  .asciiz ", Column "
hintLetter:  .asciiz "\nFirst letter = "
hintDone:    .asciiz "\nHint displayed. Keep searching!\n"

scoreText:   .asciiz "\nScore: "
livesText:   .asciiz "   Lives: "
foundText:   .asciiz "   Words found: "
slashText:   .asciiz "/8\n"

gameWin:     .asciiz "\n\n========================================\n       CONGRATULATIONS!\n       ALL WORDS FOUND!\n========================================\n"

gameLose:    .asciiz "\n\n========================================\n          GAME OVER!\n       No lives remaining.\n========================================\n"

missingText: .asciiz "\nWords you did not find:\n"
allFoundText:.asciiz "\nAll words were successfully found!\n"

finalScore:  .asciiz "\nFinal score: "
goodbye:     .asciiz "\nThanks for playing WORDQUEST!\n"

newline:     .asciiz "\n"
space:       .asciiz " "
bar:         .asciiz " | "

# Eight hidden words
word0: .asciiz "CAT"
word1: .asciiz "PLAN"
word2: .asciiz "ROSE"
word3: .asciiz "APPLE"
word4: .asciiz "MANGO"
word5: .asciiz "HOUSE"
word6: .asciiz "LIGHT"
word7: .asciiz "SMILE"

.align 2
wordTable:
    .word word0, word1, word2, word3
    .word word4, word5, word6, word7

# Word starting rows
startRows: .byte 1, 1, 2, 3, 5, 6, 7, 8

# Word starting columns
startCols: .byte 1, 5, 7, 1, 1, 1, 1, 1

# Word ending rows
endRows:   .byte 1, 1, 5, 3, 5, 6, 7, 8

# Word ending columns
endCols:   .byte 3, 8, 7, 5, 5, 5, 5, 5

# 0 = not found, 1 = found
foundFlags: .byte 0,0,0,0,0,0,0,0

selected:  .space 12
reversed:  .space 12

score:     .word 0
lives:     .word 6
foundCount:.word 0

.text
.globl main

main:

    # Display title
    li $v0, 4
    la $a0, title
    syscall

    li $v0, 4
    la $a0, instructions
    syscall

    # Display grid
    jal displayGrid

    # Main menu
mainMenu:

    jal displayStats

    li $v0, 4
    la $a0, menu
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, findWord
    beq $t0, 2, giveHint
    beq $t0, 3, exitGame

    li $v0, 4
    la $a0, invalidInput
    syscall

    j mainMenu


# ==========================================================
# DISPLAY GRID
# ==========================================================

displayGrid:

    li $v0, 4
    la $a0, gridTitle
    syscall

    li $t0, 0

gridLoop:

    bge $t0, 8, gridFinished

    li $t1, 0

columnLoop:

    bge $t1, 8, nextGridRow

    mul $t2, $t0, 8
    add $t2, $t2, $t1

    la $t3, grid
    add $t3, $t3, $t2

    lb $a0, 0($t3)

    li $v0, 11
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t1, $t1, 1
    j columnLoop

nextGridRow:

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j gridLoop

gridFinished:
    jr $ra


# ==========================================================
# DISPLAY SCORE, LIVES AND FOUND WORDS
# ==========================================================

displayStats:

    li $v0, 4
    la $a0, scoreText
    syscall

    lw $a0, score
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, livesText
    syscall

    lw $a0, lives
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, foundText
    syscall

    lw $a0, foundCount
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, slashText
    syscall

    jr $ra


# ==========================================================
# FIND WORD
# ==========================================================

findWord:

    # Read starting row
    li $v0, 4
    la $a0, rowPrompt
    syscall

    li $v0, 5
    syscall
    move $s0, $v0

    # Read starting column
    li $v0, 4
    la $a0, colPrompt
    syscall

    li $v0, 5
    syscall
    move $s1, $v0

    # Read ending row
    li $v0, 4
    la $a0, endRowPrompt
    syscall

    li $v0, 5
    syscall
    move $s2, $v0

    # Read ending column
    li $v0, 4
    la $a0, endColPrompt
    syscall

    li $v0, 5
    syscall
    move $s3, $v0

    # Validate coordinates
    blt $s0, 1, badCoordinates
    bgt $s0, 8, badCoordinates
    blt $s1, 1, badCoordinates
    bgt $s1, 8, badCoordinates
    blt $s2, 1, badCoordinates
    bgt $s2, 8, badCoordinates
    blt $s3, 1, badCoordinates
    bgt $s3, 8, badCoordinates

    # Convert to zero-based coordinates
    addi $s0, $s0, -1
    addi $s1, $s1, -1
    addi $s2, $s2, -1
    addi $s3, $s3, -1

    # Check horizontal or vertical
    beq $s0, $s2, horizontalLine
    beq $s1, $s3, verticalLine

    j badLine

horizontalLine:

    li $s4, 0

    sub $t0, $s3, $s1
    bltz $t0, horizontalReverse

    move $s5, $t0
    li $s6, 1
    j checkLength

horizontalReverse:

    sub $s5, $zero, $t0
    li $s6, -1
    j checkLength

verticalLine:

    li $s6, 0

    sub $t0, $s2, $s0
    bltz $t0, verticalReverse

    move $s5, $t0
    li $s4, 1
    j checkLength

verticalReverse:

    sub $s5, $zero, $t0
    li $s4, -1

checkLength:

    # Maximum length = 8
    bgt $s5, 7, badLength

    # Minimum length = 2
    blt $s5, 1, badLength

    # Actual selected length
    addi $s5, $s5, 1

    # Build selected word
    li $t0, 0
    move $t1, $s0
    move $t2, $s1

buildSelected:

    bge $t0, $s5, selectedFinished

    # Grid index = row * 8 + column
    mul $t3, $t1, 8
    add $t3, $t3, $t2

    la $t4, grid
    add $t4, $t4, $t3

    lb $t5, 0($t4)

    la $t6, selected
    add $t6, $t6, $t0
    sb $t5, 0($t6)

    add $t1, $t1, $s4
    add $t2, $t2, $s6

    addi $t0, $t0, 1
    j buildSelected

selectedFinished:

    la $t0, selected
    add $t0, $t0, $s5
    sb $zero, 0($t0)

    # Build reverse word
    li $t0, 0

reverseLoop:

    bge $t0, $s5, reverseFinished

    sub $t1, $s5, $t0
    addi $t1, $t1, -1

    la $t2, selected
    add $t2, $t2, $t1
    lb $t3, 0($t2)

    la $t4, reversed
    add $t4, $t4, $t0
    sb $t3, 0($t4)

    addi $t0, $t0, 1
    j reverseLoop

reverseFinished:

    la $t0, reversed
    add $t0, $t0, $s5
    sb $zero, 0($t0)

    # Compare against all hidden words
    li $s7, 0

compareWordLoop:

    bge $s7, 8, wrongAnswer

    # Skip already found words
    la $t0, foundFlags
    add $t0, $t0, $s7
    lb $t1, 0($t0)

    bne $t1, $zero, nextCompareWord

    # Get current word address
    sll $t0, $s7, 2
    la $t1, wordTable
    add $t1, $t1, $t0
    lw $t2, 0($t1)

    # Compare forward
    la $t3, selected
    move $t4, $t2

compareForward:

    lb $t5, 0($t3)
    lb $t6, 0($t4)

    bne $t5, $t6, compareBackwardStart

    beq $t5, $zero, wordMatched

    addi $t3, $t3, 1
    addi $t4, $t4, 1
    j compareForward

compareBackwardStart:

    # Compare reversed selection
    la $t3, reversed
    move $t4, $t2

compareBackward:

    lb $t5, 0($t3)
    lb $t6, 0($t4)

    bne $t5, $t6, nextCompareWord

    beq $t5, $zero, wordMatched

    addi $t3, $t3, 1
    addi $t4, $t4, 1
    j compareBackward

nextCompareWord:

    addi $s7, $s7, 1
    j compareWordLoop


# ==========================================================
# CORRECT WORD
# ==========================================================

wordMatched:

    # Mark word as found
    la $t0, foundFlags
    add $t0, $t0, $s7
    li $t1, 1
    sb $t1, 0($t0)

    # Update found count
    lw $t0, foundCount
    addi $t0, $t0, 1
    sw $t0, foundCount

    # Add 10 points
    lw $t0, score
    addi $t0, $t0, 10
    sw $t0, score

    # Print success message
    li $v0, 4
    la $a0, correctWord
    syscall

    sll $t0, $s7, 2
    la $t1, wordTable
    add $t1, $t1, $t0
    lw $a0, 0($t1)

    li $v0, 4
    syscall

    # Check if all words are found
    lw $t0, foundCount
    beq $t0, 8, winGame

    j mainMenu


# ==========================================================
# WRONG ANSWER
# ==========================================================

wrongAnswer:

    li $v0, 4
    la $a0, wrongWord
    syscall

    # Lose one life
    lw $t0, lives
    addi $t0, $t0, -1
    sw $t0, lives

    # Deduct 10 points, minimum 0
    lw $t0, score
    addi $t0, $t0, -10
    bgez $t0, saveWrongScore

    li $t0, 0

saveWrongScore:
    sw $t0, score

    lw $t0, lives
    beq $t0, $zero, loseGame

    j mainMenu


# ==========================================================
# HINT SYSTEM
# ==========================================================

giveHint:

    li $v0, 4
    la $a0, hintMenu
    syscall

    li $v0, 5
    syscall

    move $t0, $v0

    blt $t0, 1, invalidHint
    bgt $t0, 8, invalidHint

    addi $t0, $t0, -1

    # Check if already found
    la $t1, foundFlags
    add $t1, $t1, $t0
    lb $t2, 0($t1)

    bne $t2, $zero, alreadyFoundHint

    # Deduct 5 points
    lw $t2, score
    addi $t2, $t2, -5
    bgez $t2, saveHintScore

    li $t2, 0

saveHintScore:
    sw $t2, score

    # Display starting row
    li $v0, 4
    la $a0, hintText
    syscall

    la $t1, startRows
    add $t1, $t1, $t0
    lb $a0, 0($t1)

    li $v0, 1
    syscall

    # Display starting column
    li $v0, 4
    la $a0, hintCol
    syscall

    la $t1, startCols
    add $t1, $t1, $t0
    lb $a0, 0($t1)

    li $v0, 1
    syscall

    # Display ending row
    li $v0, 4
    la $a0, hintEnd
    syscall

    la $t1, endRows
    add $t1, $t1, $t0
    lb $a0, 0($t1)

    li $v0, 1
    syscall

    # Display ending column
    li $v0, 4
    la $a0, hintEndCol
    syscall

    la $t1, endCols
    add $t1, $t1, $t0
    lb $a0, 0($t1)

    li $v0, 1
    syscall

    # Display first letter of word
    li $v0, 4
    la $a0, hintLetter
    syscall

    sll $t1, $t0, 2
    la $t2, wordTable
    add $t2, $t2, $t1
    lw $t2, 0($t2)

    lb $a0, 0($t2)
    li $v0, 11
    syscall

    li $v0, 4
    la $a0, hintDone
    syscall

    j mainMenu

invalidHint:

    li $v0, 4
    la $a0, invalidInput
    syscall

    j mainMenu

alreadyFoundHint:

    li $v0, 4
    la $a0, duplicate
    syscall

    j mainMenu


# ==========================================================
# INVALID SELECTIONS
# ==========================================================

badCoordinates:

    li $v0, 4
    la $a0, invalidInput
    syscall

    j mainMenu

badLine:

    li $v0, 4
    la $a0, invalidLine
    syscall

    j mainMenu

badLength:

    li $v0, 4
    la $a0, invalidLength
    syscall

    j mainMenu


# ==========================================================
# WIN GAME
# ==========================================================

winGame:

    li $v0, 4
    la $a0, gameWin
    syscall

    j showFinalScore


# ==========================================================
# LOSE GAME AND SHOW MISSING WORDS
# ==========================================================

loseGame:

    li $v0, 4
    la $a0, gameLose
    syscall

    li $v0, 4
    la $a0, missingText
    syscall

    li $s7, 0

missingLoop:

    bge $s7, 8, showFinalScore

    la $t0, foundFlags
    add $t0, $t0, $s7
    lb $t1, 0($t0)

    bne $t1, $zero, nextMissing

    sll $t0, $s7, 2
    la $t1, wordTable
    add $t1, $t1, $t0
    lw $a0, 0($t1)

    li $v0, 4
    syscall

    li $v0, 4
    la $a0, newline
    syscall

nextMissing:

    addi $s7, $s7, 1
    j missingLoop


# ==========================================================
# FINAL SCORE
# ==========================================================

showFinalScore:

    li $v0, 4
    la $a0, finalScore
    syscall

    lw $a0, score
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j exitGame


# ==========================================================
# EXIT
# ==========================================================

exitGame:

    li $v0, 4
    la $a0, goodbye
    syscall

    li $v0, 10
    syscall
