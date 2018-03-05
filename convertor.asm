%include "io.inc"

section .data
    %include "input.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp
    mov ecx, 1
    jmp first

convert:
    NEWLINE 
    
first:
    xor eax, eax 
    xor ebx, ebx
    xor edx, edx 
    cmp ecx, dword [nums] ;Verific pe ce pozitie din vector sunt
    jg return
    mov eax, dword [nums_array + 4*(ecx - 1)] ;Parcurg vectorul de numere
    cmp dword [base_array + 4*(ecx - 1)], 1 ;Verific daca baza este mai mare decat 1
    je baza_incorecta
    cmp dword [base_array + 4*(ecx - 1)], 16 ;Verific daca baza este mai mica decat 16
    jg baza_incorecta
    div dword [base_array + 4*(ecx - 1)] ;Efectuez impartirea
    push DX ;Pun pe stiva restul
    inc ebx ;Cu ajutorul registrului EBX contorizez cate resturi adaugam in stiva
    cmp eax, 0 ;Verific daca nu se mai pot efectua impartiri
    je print

repeat:
    xor edx, edx 
    div dword [base_array + 4*(ecx - 1)]
    push DX
    inc ebx
    cmp eax, 0
    jg repeat
    xor edx, edx
    
print:
    pop dx ;Scot din stiva resturile si le afisez
    cmp dx, 9 ;Daca restul este mai mare decat 9 inseamna ca este o litera
    jg letter
    PRINT_UDEC 2, DX
    jmp continue
    
letter:
    add dx, 87 ;Conversia la char
    PRINT_CHAR dx
    
continue:
    dec ebx
    cmp ebx, 0 ;Verificam daca mai avem elemente in stiva
    jg print
    jmp verif_continue
    
baza_incorecta: ;Tratam cazul in care baza nu se afla in intervalul [1;16]
    PRINT_STRING "Baza incorecta"
    jmp verif_continue
        
verif_continue: ;Verificam daca mai avem numere de convertit
    inc ecx
    cmp ecx, dword [nums]
    jbe convert
 
return:
    xor eax, eax
    ret