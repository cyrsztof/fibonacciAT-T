
READ = 0
WRITE = 1
STDIN = 0
STDOUT = 1
STDERR = 2
SYSEXIT = 60
MAX_LICZBA = 40 # okresla do jakiej liczby ma szukac

.bss
.comm wynik, 512
.comm inv, 512
.text
.globl main

main:

mov $MAX_LICZBA, %rax
push %rax

call fibonacci


mov %rcx, %rax
#wypisanie wyniku
mov $10, %rbx
mov $0, %rcx

petla_wypisz:
    mov $0, %rdx
    div %rbx
    add $'0', %rdx
    mov %dl, inv(, %rcx, 1)
    inc %rcx
    cmp $0, %rax
    jne petla_wypisz

    mov $0, %rdi
    mov %rcx, %rsi
    dec %rsi

petla_wypisz2:

    mov inv(, %rsi, 1), %rax
    mov %rax, wynik(, %rdi, 1)

    inc %rdi
    dec %rsi
    cmp %rcx, %rdi
    jle petla_wypisz2

    movb $'\n', wynik(, %rcx, 1)    # dodanie znaku konca linii
    inc %rcx

mov $WRITE, %rax
mov $STDOUT, %rdi
mov $wynik, %rsi
mov %rcx, %rdx
syscall

#koniec programu
mov $SYSEXIT, %rax
syscall

#funkcja rekurencyjna liczaca kolejne liczby fibonacciego

.type fibonacci @function
fibonacci:

    push %rbp
    mov %rsp, %rbp

    mov 16(%rbp), %rax

    cmp $2, %rax    # N <= 1?
    jg rekurencja   # nie, rób rekurencje
    mov $1, %rcx    # tak, fib(1) = 1
    jmp koniec_rekurencji

    rekurencja:
        
        dec %rax        # N-1
        mov %rax, %rdx  # N-1
        push %rdx       # na stos N-1
        push %rax       # nowy arg. to N-1
    
        call fibonacci  # Fib (N-1) 
    
        pop %rax        # zdejmij N-1
        dec %rax        # N-2
        push %rcx       # zapisz Fib (N-1)
        push %rax       # nowy arg. to N-2
    
        call fibonacci  # Fib (N-2)
        
        pop %rax        # (N-1)  
        pop %rax        # Fib (N-1)

        add %rax, %rcx  # Fib (N-1) + Fib (N -2)

    koniec_rekurencji:  # reset stosu do wartosci na wejsciu funkcji
                        # i powrot
        
        mov %rbp, %rsp 
        pop %rbp
        ret



