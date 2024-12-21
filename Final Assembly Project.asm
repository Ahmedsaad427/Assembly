.model small
.stack 100h
.data
; Option Property
wel db 10,13,"                   Welcome to Your Account $"
bal db 10,13,10,13,"1. Balance Inquiry $"
with db 10,13,"2. Money Withdraw $"
deposit db 10,13,"3. Deposit Money $"
ex db 10,13,"4. Exit $"
new db 10,13,"$"
inval db 10,13,"Invalid Input$"

; Message Property
thank db 10,13,10,13,"                   Thank You For Banking With Us. $"
totalbal db 10,13,"Your Total Balance is: $"
depositsuccess db 10,13,"Deposit Successful. $"
withdrawsuccess db 10,13,"Withdrawal Successful. $"
insufficient db 10,13,"Insufficient Balance! $"

; Withdraw and Deposit Options
fivehun db 10,13,"1. 500 USD$"
one db 10,13,"2. 1,000 USD$"
three db 10,13,"3. 3,000 USD$"
five db 10,13,"4. 5,000 USD$"
ten db 10,13,"5. 10,000 USD$"
fiften db 10,13,"6. 15,000 USD$"
tweenty db 10,13,"7. 20,000 USD$"

deposit1 db 10,13,"1. 500 USD$"
deposit2 db 10,13,"2. 1,000 USD$"
deposit3 db 10,13,"3. 3,000 USD$"
deposit4 db 10,13,"4. 5,000 USD$"
deposit5 db 10,13,"5. 10,000 USD$"
deposit6 db 10,13,"6. 15,000 USD$"
deposit7 db 10,13,"7. 20,000 USD$"
depositmsg db 10,13,"Enter Deposit Amount: $"

; Initial Available Balance
avail_balance dw 24900 ; Initial available balance (24,900 USD)

.code
main proc
    mov ax,@data
    mov ds,ax

mainpross:
    ; Display the main menu
    mov ah,9
    lea dx,wel
    int 21h
    mov ah,9
    lea dx,bal
    int 21h
    mov ah,9
    lea dx,with
    int 21h
    mov ah,9
    lea dx,deposit
    int 21h
    mov ah,9
    lea dx,ex
    int 21h
    mov ah,9
    lea dx,new
    int 21h
    mov ah,1
    int 21h
    mov bl,al

    ; Input Check
    cmp bl,49
    je blance
    cmp bl,50
    je withdraw
    cmp bl,51
    je depositmoney
    cmp bl,52
    je exit
    jmp err

blance:
    ; Balance Inquiry
    mov ah,9
    lea dx,totalbal
    int 21h

    ; Show updated balance
    call display_balance  ; Display balance after inquiry
    jmp mainpross  ; Back to main menu

withdraw:
    ; Display Withdraw Options
    mov ah,9
    lea dx,fivehun
    int 21h
    mov ah,9
    lea dx,one
    int 21h
    mov ah,9
    lea dx,three
    int 21h
    mov ah,9
    lea dx,five
    int 21h
    mov ah,9
    lea dx,ten
    int 21h
    mov ah,9
    lea dx,fiften
    int 21h
    mov ah,9
    lea dx,tweenty
    int 21h

    ; Get withdraw input
    mov ah,9
    lea dx,new
    int 21h
    mov ah,1
    int 21h
    mov bl,al

    ; Handle Withdraw Choices
    cmp bl,49
    je withdraw1
    cmp bl,50
    je withdraw2
    cmp bl,51
    je withdraw3
    cmp bl,52
    je withdraw4
    cmp bl,53
    je withdraw5
    cmp bl,54
    je withdraw6
    cmp bl,55
    je withdraw7
    jmp err

withdraw1:
    mov ax, 500
    jmp check_withdraw

withdraw2:
    mov ax, 1000
    jmp check_withdraw

withdraw3:
    mov ax, 3000
    jmp check_withdraw

withdraw4:
    mov ax, 5000
    jmp check_withdraw

withdraw5:
    mov ax, 10000
    jmp check_withdraw

withdraw6:
    mov ax, 15000
    jmp check_withdraw

withdraw7:
    mov ax, 20000
    jmp check_withdraw

check_withdraw:
    ; Check if sufficient balance is available
    mov bx, avail_balance
    cmp bx, ax
    jb insufficient_balance

    ; Deduct amount from available balance
    sub avail_balance, ax

    ; Display success message
    mov ah,9
    lea dx,withdrawsuccess
    int 21h

    ; Show updated balance
    call display_balance
    jmp mainpross

insufficient_balance:
    mov ah,9
    lea dx,insufficient
    int 21h
    jmp mainpross

depositmoney:
    ; Display Deposit Options
    mov ah,9
    lea dx,depositmsg
    int 21h

    mov ah,9
    lea dx,deposit1
    int 21h
    mov ah,9
    lea dx,deposit2
    int 21h
    mov ah,9
    lea dx,deposit3
    int 21h
    mov ah,9
    lea dx,deposit4
    int 21h
    mov ah,9
    lea dx,deposit5
    int 21h
    mov ah,9
    lea dx,deposit6
    int 21h
    mov ah,9
    lea dx,deposit7
    int 21h

    ; Get deposit input
    mov ah,9
    lea dx,new
    int 21h
    mov ah,1
    int 21h
    mov bl,al

    ; Handle Deposit Choices
    cmp bl,49
    je deposit1_option
    cmp bl,50
    je deposit2_option
    cmp bl,51
    je deposit3_option
    cmp bl,52
    je deposit4_option
    cmp bl,53
    je deposit5_option
    cmp bl,54
    je deposit6_option
    cmp bl,55
    je deposit7_option
    jmp err

deposit1_option:
    mov ax, 500
    jmp deposit_update

deposit2_option:
    mov ax, 1000
    jmp deposit_update

deposit3_option:
    mov ax, 3000
    jmp deposit_update

deposit4_option:
    mov ax, 5000
    jmp deposit_update

deposit5_option:
    mov ax, 10000
    jmp deposit_update

deposit6_option:
    mov ax, 15000
    jmp deposit_update

deposit7_option:
    mov ax, 20000
    jmp deposit_update

deposit_update:
    ; Update the available balance
    add avail_balance, ax

    ; Display success message
    mov ah,9
    lea dx,depositsuccess
    int 21h

    ; Show updated balance
    call display_balance
    jmp mainpross

display_balance:
    ; Display the updated balance
    mov ah,9
    lea dx,totalbal
    int 21h

    ; Convert the available balance to string and display
    mov ax, avail_balance
    call print_balance

    ret

exit:
    ; Exit the program
    mov ah,4ch
    int 21h

err:
    ; Invalid Input Handling
    mov ah,9
    lea dx,inval
    int 21h
    jmp mainpross ; Back to main menu

; Print balance procedure
print_balance proc
    ; Convert AX balance to string and print it
    push ax
    push bx
    mov bx, 10  ; Set base for division (decimal)
    mov cx, 0   ; Initialize counter for digits

convert_loop:
    xor dx, dx
    div bx           ; Divide AX by 10 (quotient in AX, remainder in DX)
    push dx          ; Store remainder (digit)
    inc cx           ; Increment digit counter
    test ax, ax      ; Check if AX is zero
    jnz convert_loop ; Repeat if AX is not zero

print_loop:
    pop dx
    add dl, '0'      ; Convert digit to ASCII
    mov ah, 2        ; Print character
    int 21h
    loop print_loop

    ; Print newline after the balance
    mov ah,9
    lea dx,new
    int 21h

    pop bx
    pop ax
    ret
print_balance endp

end main
