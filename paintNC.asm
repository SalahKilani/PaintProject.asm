;written by : salah kilani

org 100h
     
;-------set mode-------                 
mov     ah, 0                                 
mov     al, 0h                          
int     10h                             
;======================

page_Main:
;-----clear screen-----                             
mov     dh, 25          ;from x         
mov     dl, 40          ;from y         
mov     al, 00h         ;everything     
mov     ah, 07h                         
int     10h                             
                                        
      ;first pixel                      
mov     dl, 0           ;row            
mov     dh, 0           ;column         
mov     bh, 0           ;page           
mov     bl, 00000000b   ;color
mov     cx, 1           ;times
mov     ah, 02h         ;move cursor
int     10h
mov     ah, 09h         ;draw
int     10h
   
;======================

;********************************************
;* the following print segments print the : *
;* title / name / id / hint / start button  *
;********************************************

;-----print title------
mov     si, offset msg1 ;index
mov     dl, 14          ;x
mov     dh, 8           ;y
mov     bh, 0           ;page
mov     bl, 00001110b   ;color
mov     cx, 1           ;times

l_t:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_t
             
    mov     ah, 09h
    int     10h
    
    add     si, 1       ;next index
    inc     dl          ;inc x
                                        
    inc     bl                          
    cmp     bl, 00010000b               
    jne     l_t:                        
    mov     bl, 00001001b               
jmp l_t
;======================

c_t:                    

;-----print name------
mov     si, offset msg2
mov     dl, 12
mov     dh, 10
mov     bh, 0
mov     bl, 00001111b   
mov     cx, 1           

l_n:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_n
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_n
;======================

c_n:                   

;------print ID-------
mov     si, offset msg3
mov     dl, 17
mov     dh, 11
mov     bh, 0
mov     bl, 00001111b  
mov     cx, 1          

l_i:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_i
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_i
;=====================

c_i:

;------print keys-----
mov     si, offset msg5
mov     dl, 13
mov     dh, 20
mov     bh, 0
mov     bl, 00001100b  
mov     cx, 1          

l_k:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_k
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_k
;=====================

c_k:

;------print hints-----
mov     si, offset msg6
mov     dl, 6
mov     dh, 22
mov     bh, 0
mov     bl, 00001100b  
mov     cx, 1          

l_h1:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_h1
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_h1

c_h1:

mov     si, offset msg7
mov     dl, 6
mov     dh, 23
mov     bh, 0
mov     bl, 00001100b  
mov     cx, 1          

l_h2:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      c_h2
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_h2
;=====================

c_h2:

;----print button-----
mov     si, offset msg4
mov     dl, 16
mov     dh, 15
mov     bh, 0
mov     bl, 11101100b  
mov     cx, 1           

l_btn:
        ;set cursor
    mov     ah, 02h
    int     10h

        ;print msg       
    mov     al, [si]
    
    cmp     al, '$'
    je      listener
             
    mov     ah, 09h
    int     10h
    
    add     si, 1
    inc     dl    
jmp l_btn
;=====================


;---mouse listener---- 
listener:
       
        ;get pos                        
    mov     ax, 3                       
    int     33h                         
                                        
        ;correct pos                    
    shr     cx, 1                       
                                        
        ;check click
    cmp     bl, 1
    jne     listener
    
        ;calc pos                       
    xchg    dh, dl                      
    shr     dh,3                        
    xchg    cl, dl                      
    shr     dl, 2                       
    
        ;check
    cmp     dh, 15                     
    jne     listener                                            
                                        
    cmp     dl, 16                      
    jl      listener                    
                                        
    cmp     dl, 24                     
    jg      listener                    
                                        
    jmp     start:
;=====================        
    

start:
;-----clear screen-----
mov     dh, 25
mov     dl, 40
mov     al, 00h
mov     ah, 07h
int     10h

    ;flush buffer
mov     ah, 0ch
int     21h
;======================

    
;--initiate variable--- 
char    DB '*'
color   DB 1010b    
jmp     colorDips
;======================

l1:
    
    ;--check buffer----    
    mov     ah, 1
    int     16h
    je      continue
    
        ;read    
    mov     ah, 0
    int     16h
    
        ;Red
    cmp     al, 72h
    je      setRed
    cmp     al, 52h
    je      setRed
    
        ;Yellow
    cmp     al, 79h
    je      setYellow
    cmp     al, 59h
    je      setYellow
    
        ;Green
    cmp     al, 67h
    je      setGreen
    cmp     al, 47h
    je      setGreen
     
        ;exit
    cmp     al, 1bh
    je      page_Main
    
        ;clear
    cmp     al, 63h
    je      clear_board
    cmp     al, 43h
    je      clear_board   
    ;==================
    
    
    continue:
    
    
    ;---mouse status---   
           
        ;get pos
    mov     ax, 3
    int     33h
          
        ;check click
    cmp     bl, 1
    jne     reJump
        
        ;validate pos y               
    cmp     dh, 01h                    
    jae      reJump                    
                                      
        ;validate pos x               
    cmp     ch, 00h
    je      draw
    cmp     ch, 02h
    jae     reJump
    cmp     cl, 3fh
    jae      reJump      
          
    ;==================
    
    draw:  
                     
    ;----Draw char-----   
    ;dl is the row
    ;dh is the column
    
        ;correct pos      
    shr     cx, 1
        ;calc pos
    xchg    dh, dl
    shr     dh,3   
    xchg    cl, dl
    shr     dl, 2
    
        ;input strip    
    cmp     dh, 0                     
    je     get_Input                   
                                      
        ;marker strip                  
    cmp     dh, 1
    je      reJump
    
        ;move cursor
    mov     bh, 0
    mov     ah, 02h
    int     10h       
    
        ;place char 
    mov     bl, color   ;color   
    mov     cx, 1       ;times
    mov     al, char    ;char
    mov     bh, 0       ;page     
    mov     ah, 09h
    int     10h
    jmp     reJump    
    ;==================
    
    ;-invalidation jmp-
    
    inv_co:
        call invalidate_color
        jmp reJump
        
    inv_ca:
        call invalidate_char
        
    ;==================
    
    reJump:
    mov     cx, 2     
            
loop l1

exit:    
ret        


;-------functions------

setRed:
    mov     color, 1100b
    mov     color_marker, 22
    jmp     inv_co
    
setYellow:
    mov     color, 1110b
    mov     color_marker, 14
    jmp     inv_co
    
setGreen:
    mov     color, 1010b
    mov     color_marker, 30
    jmp     inv_co

;**************************************************

clear_board:
    mov     dl, 0
    mov     dh, 2           
    mov     bh, 0           
    mov     bl, 00000000b   
    mov     cx, 1           
    mov     ah, 02h         
    int     10h
    mov     dx, offset msg10
    mov     ah, 9
    int     21h
    
    mov     cx, 40
    mov     dl, 0
    mov     dh, 24                     
    l_cb:                              
        ;set cursor                    
    mov     ah, 02h
    int     10h

        ;print      
    mov     al, ' '
     
    mov     ah, 09h
    int     10h
        
    loop    l_cb
    
    jmp     reJump
;**************************************************
    
colorDips:           
    mov     dl, 39              ;end of screen
    mov     dh, 0               ;first row
    mov     bh, 0       
    mov     bl, 77h
    
    next_Color:
        add     bl, 00010001b   ;inc color         
        mov     cx, 4           ;draw color x 4
        
        l2:
            push cx
            
            ;move cursor 
            mov     ah, 02h
            int     10h
            
            ;draw 
            mov     cx, 1       ;times 
            mov     al, char    ;char
            mov     bh, 0       ;page     
            mov     ah, 09h
            int     10h
        
            ;re-position    
            dec     dl
            
            pop cx
        loop l2
            
        cmp     dl, 7           ;all colors done
        je      letters
            
    jmp next_Color
    
;**************************************************            
            
letters:
    mov     dl, 0
    mov     dh, 0
    mov     bh, 0
    mov     bl, 0Fh 
    
    mov     cx, 4
    next_Letter:
        
        ;move cursor    
        mov     ah, 02h
        int     10h
               
        jmp loadLetter      ;load letter to al
        cb:
        
        ;draw
        push cx
        mov     cx, 1
        mov     bh, 0
        mov     ah, 09h
        int     10h          
        
        ;re-position    
        add     dl, 2
        pop     cx
    loop next_Letter
    
    call invalidate_color
    call invalidate_char
    jmp l1                  ;start the action
 

loadLetter:

    mov     al, '*'
    cmp     cx, 4
    je      cb

    mov     al, '#'
    cmp     cx, 3
    je      cb
    
    mov     al, 03h
    cmp     cx, 2
    je      cb

    mov     al, '$'
    cmp     cx, 1
    je      cb

;**************************************************

get_Input:
                                        
    cmp     dl, 7                     
    jle     get_Char                   
                                       
    jmp     get_Color                   
       
    
get_Char:
    mov     al, char        ;save char
    push    ax
        
    cmp     dl, 0
    mov     char, '*'
    mov     char_marker, 0
    je      inv_ca
        
    cmp     dl, 2
    mov     char, '#'
    mov     char_marker, 2
    je      inv_ca
        
    cmp     dl, 4
    mov     char, 03h 
    mov     char_marker, 4
    je      inv_ca
        
    cmp     dl, 6
    mov     char, '$'
    mov     char_marker, 6
    je      inv_ca
        
    pop     ax              ;if invalid
    mov     char, al
    jmp     reJump
    
    
get_Color:
    
    cmp     dl, 11
    mov     color, 0Fh
    mov     color_marker, dl
    jle     inv_co                     
                                        
    cmp     dl, 15                      
    mov     color, 0Eh                  
    mov     color_marker, dl           
    jle     inv_co                      
                                        
    cmp     dl, 19                      
    mov     color, 0Dh
    mov     color_marker, dl
    jle     inv_co 
    
    cmp     dl, 23
    mov     color, 0Ch
    mov     color_marker, dl
    jle     inv_co 
    
    cmp     dl, 27
    mov     color, 0Bh
    mov     color_marker, dl
    jle     inv_co 
    
    cmp     dl, 31
    mov     color, 0Ah
    mov     color_marker, dl
    jle     inv_co 
    
    cmp     dl, 35
    mov     color, 09h
    mov     color_marker, dl
    jle     inv_co 
    
    mov     color, 08h
    mov     color_marker, dl
    jmp     inv_co

;**************************************************                 
                 
invalidate_color PROC
    
    ;wipe old marker
    mov     dl, 8
    mov     dh, 1                       
    mov     bh, 0                      
    mov     bl, 00000000b              
    mov     cx, 1                       
    mov     ah, 02h                     
    int     10h                        
    mov dx, offset msg9                 
    mov ah, 9
    int 21h
    
    ;add new marker
    mov     al, 1Eh
    mov     dl, color_marker
    mov     dh, 1           
    mov     bh, 0           
    mov     bl, color  
    mov     cx, 1           
    mov     ah, 02h         
    int     10h
    mov     ah, 09h        
    int     10h      
    RET
invalidate_color ENDP

invalidate_char PROC
    
    ;wipe old marker
    mov     dl, 0
    mov     dh, 1           
    mov     bh, 0           
    mov     bl, 00000000b   
    mov     cx, 1           
    mov     ah, 02h         
    int     10h
    mov dx, offset msg8
    mov ah, 9
    int 21h
    
    ;add new marker
    mov     al, 18h
    mov     dl, char_marker
    mov     dh, 1           
    mov     bh, 0           
    mov     bl, 00001111b   
    mov     cx, 1           
    mov     ah, 02h         
    int     10h
    mov     ah, 09h        
    int     10h
    RET
invalidate_char ENDP

;**************************************************
    
msg1  DB "Paint Project$"
msg2  DB "By: Salah Kilani$"
msg3  DB "(20150035)$" 
msg4  DB "  Start  $"
msg5  DB "available keys$"
msg6  DB "< R:red, G:green, Y:yellow >$"
msg7  DB "< C:clear , ESC:title Page >$"

msg8  DB "       $"
msg9  DB "                               $"
msg10 DB 880 DUP(" "),"$"
char_marker DB 0
color_marker DB 30                    
END