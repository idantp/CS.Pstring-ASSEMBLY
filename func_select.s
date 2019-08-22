    #311125249 idan twito
.data
.section .rodata
#encforces the next variable to be aligned in the next memory address which is multiple of 8
twoCharScan:        .string " %c %c"        #ignoring the '\0' or '\n'
intSize:            .string "%d"
invalidMsg:         .string "invalid option!\n"
pstrlenPrint:       .string "first pstring length: %d, second pstring length: %d\n"
replaceCharPrint:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
ijcpyPrint:         .string "length: %d, string: %s\nlength: %d, string: %s\n"
ijcmpPrint:         .string "compare result: %d\n"
swapCasePrint:      .string "length: %d, string: %s\nlength: %d, string: %s\n"
.align 8
.SwitchCase:
    .quad   .L50    #case 50
    .quad   .L51    #case 51
    .quad   .L52    #case 52
    .quad   .L53    #case 53
    .quad   .L54    #case 54

.text
.global run_func
run_func:
    pushq   %rbp            #callee save - backup %rbp
    #callee regs backup for pstr1 and pstr2:
    pushq   %rbx
    movq    %rsi,%rbx
    pushq   %r12
    movq    %rdx,%r12
    pushq   %r13
    pushq   %r14
    movq    %rsp,%rbp       #since this func is unknown for its Frame in compilation
    #switch case:
    leaq    -50(%rdi),%rdi  #missionNumber = missionNumber - 50
    cmpq    $5,%rdi
    jge     .printError
    cmpq    $0,%rdi
    jl      .printError
    jmp     *.SwitchCase(,%rdi,8)

.L50:
    #first call to pstrlen:
    movq    %rbx,%rdi       #arg1 points to pstring1
    call    pstrlen
    movq    %rax,%r13       #%r13 holds return val of pstrlen func
    #second call to pstrlen
    movq    %r12,%rdi       #arg1 points to pstring2
    call    pstrlen
    movq    %rax,%r14       #%r14 holds return val of pstrlen func
    #print result
    movq    $pstrlenPrint,%rdi
    movq    %r13,%rsi
    movq    %r14,%rdx
    movq    $0,%rax
    call    printf
    jmp     .return_func

.L51:
    #oldChar & newChar scanf:
    subq    $2,%rsp
    movq    %rsp,%rsi       #scan writes there oldChar
    leaq    1(%rsp),%rdx    #scan writes there newChar
    movq    $twoCharScan,%rdi
    movq    $0,%rax
    call    scanf
    movzbq  (%rsp),%r13     #%r13 holds oldChar
    movzbq  1(%rsp),%r14    #%r14 holds newChar
    #replaceChar on pstring1
    movq    %rbx,%rdi
    movq    %r13,%rsi
    movq    %r14,%rdx
    call    replaceChar
    leaq    1(%rax),%rbx    #%rbx points to the new pstring1
    #replaceChar on pstring2
    movq    %r12,%rdi
    movq    %r13,%rsi
    movq    %r14,%rdx
    call    replaceChar
    leaq    1(%rax),%r12    #%r12 points to the new pstring2
    #print:
    movq    $replaceCharPrint,%rdi
    movq    %r13,%rsi
    movq    %r14,%rdx
    movq    %rbx,%rcx
    movq    %r12,%r8
    movq    $0,%rax
    call    printf
    jmp     .return_func 
.L52:
    #start int index scanf:
    movq    $0,%rax
    subq    $4,%rsp         #allocating byte for char
    movq    $intSize,%rdi   #put size of integer into the first arg of scanf
    movq    %rsp,%rsi
    call    scanf
    movslq  (%rsp),%r13     #holds (int)start index might be negative
    #end int index scanf:
    movq    $0,%rax
    subq    $4,%rsp
    movq    $intSize,%rdi
    movq    %rsp,%rsi
    call    scanf
    movslq  (%rsp),%r14     #%r14 hold new char might be negative
    #call pstrijcpy:
    movq    %rbx,%rdi       #pstring1 (dst)
    movq    %r12,%rsi       #pstring2 (src)
    movq    %r13,%rdx       #int i
    movq    %r14,%rcx       #int j
    call    pstrijcpy
    movq    %rax,%rbx       #points to the new dst pstring1
    #print:
    movq    $ijcpyPrint,%rdi
    movzbq  (%rbx),%rsi     #the size of the new pstring1 (dst)
    movq    %rbx,%rdx       #the new pstring1 (dst)
    addq    $1,%rdx         #skip the index that describes the length
    movzbq  (%r12),%rcx     #the size of the pstring2 (src)
    movq    %r12,%r8        #pstring2
    addq    $1,%r8          #skip the index that describes the length
    movq    $0,%rax
    call    printf
    jmp     .return_func
    
    .L53:
    #two calls to swapCase:
    movq    %rbx,%rdi       #arg1 points to pstring1
    call    swapCase
    movq    %rax,%r13       #points to the new pstring1
    movq    %r12,%rdi       #arg1 points to pstring2
    call    swapCase
    movq    %rax,%r14       #points to the new pstring2
    #print results:
    movq    $swapCasePrint,%rdi
    movzbq  (%r13),%rsi     #pstring1 length
    movq    %r13,%rdx
    addq    $1,%rdx         #points to first letter of pstring1
    movzbq  (%r14),%rcx     #pstring2 length
    movq    %r14,%r8
    addq    $1,%r8          #points to first letter of pstring2
    movq    $0,%rax
    call    printf
    jmp     .return_func
    
.L54:
    #start int index scanf:
    movq    $0,%rax
    subq    $4,%rsp         #allocating byte for char
    movq    $intSize,%rdi   #put size of integer into the first arg of scanf
    movq    %rsp,%rsi
    call    scanf
    movslq  (%rsp),%r13     #holds (int)start index might be negative
    #end int index scanf:
    movq    $0,%rax
    subq    $4,%rsp
    movq    $intSize,%rdi
    movq    %rsp,%rsi
    call    scanf
    movslq  (%rsp),%r14     #%r14 hold new char might be negative
    #call pstrijcmp:
    movq    %rbx,%rdi       #pstring1
    movq    %r12,%rsi       #pstring2
    movq    %r13,%rdx       #int i
    movq    %r14,%rcx       #int j
    call    pstrijcmp
    movq    $0,%rsi
    movq    %rax,%rsi
    movq    $ijcmpPrint,%rdi
    movq    $0,%rax
    call    printf
    jmp     .return_func
                                                                                                                                                                  
.printError:
    movq    $0,%rax
    movq    $invalidMsg,%rdi
    call    printf
    jmp     .return_func
.return_func: 
    movq    %rbp,%rsp
    popq    %r14
    popq    %r13  
    pop     %r12
    pop     %rbx 
    popq    %rbp            #pointing back to caller's Return Adress
    ret
    