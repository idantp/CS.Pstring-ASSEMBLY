    #311125249 idan twito
.data
.section .rodata
intSize:    .string "%d"
stringSize: .string "%s"

.text
.global main
main:
    pushq   %rbp            #callee save - backup %rbp
    movq    %rsp,%rbp       #since main is unknown for its Frame in compilation
    #pstring1 size scan:
    leaq    -8(%rsp),%rsp   #allocating bytes for int
    movq    $intSize,%rdi   #put size of integer into the first arg of scanf
    movq    %rsp,%rsi       #so scanf will write the int input to the end of the stack
    movq    $0,%rax
    call    scanf
    popq    %r14            #gets the int, rsp points back to where it did in the beginnig
    leaq    -1(%rsp),%rsp   #assign byte in the stack to write '\0' to the end of pstr1
    movb    $'\0',(%rsp)
    #writing pstring1 to the stack:
    subq    %r14,%rsp       #assign X bytes to write on (X = first int input,pstr1 length)
    xorq    %rdi,%rdi       #initialize %rdi
    movq    $stringSize,%rdi #put size of string into the first arg of scanf
    movq    %rsp,%rsi       #so scanf will write the string input to the end of the stack
    movq    $0,%rax         
    call    scanf           
    leaq    -1(%rsp),%rsp   #allocate byte in the stack
    movb    %r14b,(%rsp)    #write the size of pstring1
    movq    %rsp,%r12       #%r12 points to pstring1. 
    #pstring2 size scan:
    leaq    -8(%rsp),%rsp   #allocating bytes for int
    xorq    %rdi,%rdi       #initialize %rdi
    movq    $intSize,%rdi   #put size of integer into the first arg of scanf
    movq    %rsp,%rsi       #so scanf will write the int input to the end of the stack
    movq    $0,%rax
    call    scanf
    xorq    %r14,%r14       #initialize %r14
    popq    %r14            #gets the int, rsp points back to where it did in the beginnig
    leaq    -1(%rsp),%rsp   #assign byte in the stack to write '\0' to the end of pstr2
    movb    $'\0',(%rsp)
    #writing pstring2 to the stack:
    subq    %r14,%rsp       #assign Y bytes to write on (Y = second int input,pstr2 length)
    xorq    %rdi,%rdi       #initialize %rdi
    movq    $stringSize,%rdi #put size of string into the first arg of scanf
    movq    %rsp,%rsi       #so scanf will write the string input to the end of the stack
    movq    $0,%rax         
    call    scanf           
    leaq    -1(%rsp),%rsp   #allocate byte in the stack
    movb    %r14b,(%rsp)      #write the size of pstring1
    movq    %rsp,%r13       # %r13 points to pstring1. 
    #mission number scan:
    leaq    -8(%rsp),%rsp   #allocating bytes for int
    xorq    %rdi,%rdi       #initialize %rdi
    movq    $intSize,%rdi   #put size of integer into the first arg of scanf
    movq    %rsp,%rsi       #so scanf will write the int input to the end of the stack
    movq    $0,%rax
    call    scanf
    xorq    %r14,%r14       #initialize %r14
    popq    %r14            #gets the int, rsp points back to where it did in the beginnig
    
    movq    %r14,%rdi       #gets mission number       
    movq    %r12,%rsi       #gets pstring1
    movq    %r13,%rdx       #gets pstring2
    call    run_func
    movq    $0,%rax
    movq    %rbp,%rsp       #restoring the old Frame pointer
    popq    %rbp            #pointing back to caller's Return Adress
    ret

