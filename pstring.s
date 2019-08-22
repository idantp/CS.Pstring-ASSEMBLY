    #311125249 idan twito
.data
.section .rodata
invalidMsg: .string "invalid input!\n"
.text
    .type pstrlen, @function
.global pstrlen
pstrlen:
    movzbq  (%rdi),%rax
    ret
.global replaceChar
replaceChar:
    movzbq  (%rdi),%rcx     #gets the size of pString
    movq    %rdi,%r8        #assign another register for a copy of pString
    leaq    1(%r8),%r8
.whileCondition:
    cmpb    $0,%cl          #if the %cl is 0 or less end loop
    jle     .exitWhile  
    cmpb    (%r8),%sil      #check if the current element in the array == oldChar
    je      .swapChars      #if they are equal go to .SwapChars
    jmp     .nextIteration
.swapChars:
    movb    %dl,(%r8)       #replace the given char with newChar.
.nextIteration:
    leaq    1(%r8),%r8      # %r8 points on the second next char in the array
    subb    $1,%cl          # %cl= %cl - 1
    jmp     .whileCondition
.exitWhile:
    movq    %rdi,%rax
    ret

.global pstrijcpy
pstrijcpy:
    movq    %rdi,%rax       #save dst point int %rax
    cmpb    %dl,(%rdi)      #if dst.len <= i then: Error
    jle      .printCpyError
    cmpb    %dl,(%rsi)      #if src.len <= i then: Error
    jle      .printCpyError
    cmpb    %cl,(%rdi)      #if dst.len <= j then: Error
    jle      .printCpyError
    cmpb    %cl,(%rsi)      #if src.len <= j then: Error
    jle      .printCpyError
    cmpb    %dl,%cl         #if j<i then: Error
    jl      .printCpyError
    cmpq    $0,%rdx         #if i<0 then: Error
    jl      .printCpyError
.pstCpyWhile:
    cmpb    %cl,%dl         #if i<=j make an override
    jle     .dstCharOverride
    jmp     .exitijCpy
.dstCharOverride:    
    movb    1(%rsi,%rdx),%r8b # src[i] -> charX
    movb    %r8b,1(%rdi,%rdx) # charX  -> dst[i]
    addq    $1,%rdx         # i++
    jmp     .pstCpyWhile
.printCpyError:
    pushq   %rbx            #back up %rbx in the stack before using this register
    movq    %rdi,%rbx       # %rdi (dst) at %rbx
    movq    $invalidMsg,%rdi
    movq    $0,%rax
    call    printf
    movq    %rbx,%rax
    popq    %rbx            #restoring callee-save register that i've changed
.exitijCpy:
    ret
.global pstrijcmp
pstrijcmp:
    cmpb    %dl,(%rdi)      #if pstr1.len <= i then: Error
    jle     .printCmpError
    cmpb    %dl,(%rsi)      #if pstr2.len <= i then: Error
    jle     .printCmpError
    cmpb    %cl,(%rdi)      #if pstr1.len <= j then: Error
    jle     .printCmpError
    cmpb    %cl,(%rsi)      #if pstr2.len <= j then: Error
    jle     .printCmpError
    cmpb    %dl,%cl         #if j<i then: Error
    jl      .printCmpError
    cmpq    $0,%rdx         #if i<0 then: Error
    jl      .printCmpError  
    .pstCmpWhile:
    cmpb    %cl,%dl         #if i<=j make a comparison
    jle     .pstrCharCompare
    jmp     .returnZero     #else if i>j then return 0.
.pstrCharCompare:
    movb    1(%rdi,%rdx),%r8b # pstr1[i] -> charX
    movb    1(%rsi,%rdx),%r9b # pstr2[i] -> charY
    cmpb    %r9b,%r8b
    jg      .returnOne      # if pstr1[i] > pstr2[i] return 1
    jl      .returnOneMinus # if pstr1[i] > pstr2[i] return -1
    addq    $1,%rdx         # i++
    jmp     .pstCmpWhile
.returnOne:
    movq    $1,%rax
    ret
.returnOneMinus:
    movq    $-1,%rax
    ret
.printCmpError:
    movq    $invalidMsg,%rdi
    movq    $0,%rax
    call    printf
    movq    $-2,%rax
    ret    
.returnZero:
    movq    $0,%rax
    ret
    
.global swapCase
swapCase:
    movb    (%rdi),%sil     #gets the size of pstring
    leaq    1(%rdi),%rdx    #assign another register that points to pstr+1
.swapCaseWhile:
    cmpb    $0,%sil
    jle     .exitSwapCaseWhile
    cmpb    $'A',(%rdx)
    jl      .nextIterSwapCaseWhile
    cmpb    $'z',(%rdx)
    jg      .nextIterSwapCaseWhile
    cmpb    $'Z',(%rdx)
    jle     .bigCharToLow
    cmpb    $'a',(%rdx)
    jge     .lowCharToBig
    jmp     .nextIterSwapCaseWhile    #for chars between 'Z' to 'a' - skip them
.lowCharToBig:
    movb    (%rdx),%cl      # make a copy of the given char into %cl
    subb    $32,%cl         # %cl contains the Capital letter of (%rdx)
    movb    %cl,(%rdx)      # make the swap
    jmp     .nextIterSwapCaseWhile
.bigCharToLow:
    movb    (%rdx),%cl      # make a copy of the given char into %cl
    addb    $32,%cl         # %cl contains the lower letter of (%rdx)
    movb    %cl,(%rdx)      # make the swap
    jmp     .nextIterSwapCaseWhile    
.nextIterSwapCaseWhile:
    leaq    1(%rdx),%rdx
    subb    $1,%sil
    jmp     .swapCaseWhile
.exitSwapCaseWhile:
    movq    %rdi,%rax
    ret

