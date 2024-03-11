/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    /* initialize output state */
    LDR R2,=dividend
    STR R0,[R2]  // save R0=numerator into dividend output
    LDR R2,=divisor
    STR R1,[R2]  // save R1=denominator into divisor output
    MOV R3,0     // initial value
    LDR R2,=we_have_a_problem
    STR R3,[R2]  // save 0 into we_have_a_problem output
    LDR R2,=quotient
    STR R3,[R2]  // save 0 into quotient output
    LDR R2,=mod
    STR R3,[R2]  // save 0 into mod output
    
    /* check inputs for zeros */
    CMP R0,0        // numerator
    BEQ problem     // (Z=1) divisor == 0 => problem
    CMP R1,0        // divisor
    BEQ problem     // (Z=1) divisor == 0 => problem
    
    /* loop, taking away denom(R1) from numer(R0) util numer < denom */
    MOV R3,0        // initialise quotient counter = R3
 loop_check:
    CMP R0,R1        // is numer(R0) < denom(R1) ? & set flags
    BLO loop_exit    // *unsigned* lower
    SUB R0,R1        // subtract denom from numer 
    ADD R3,R3,1      // increment quotient counter
    B   loop_check
 loop_exit:
    
    /* save results */
    LDR R2,=quotient
    STR R3,[R2]   // save R3 result to quotient
    LDR R2,=mod
    STR R0,[R2]   // save R0 result to mod
    B   set_return

problem:
    MOV R3,1        // error value
    LDR R2,=we_have_a_problem
    STR R3,[R2]     // save into we_have_a_problem
    /* drop thru */
    
set_return:
    LDR R0,=quotient   // function return value (address of quotient)
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




