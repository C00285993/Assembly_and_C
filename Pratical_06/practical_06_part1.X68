*-----------------------------------------------------------
* Title      :Part 1
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:           

    ;Move trap task to D0
    MOVE.B  #2, D0
    ;Interupt and Trap Task
    TRAP    #15

    LEA     MESSAGE, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    SIMHALT   
          
MESSAGE:    DC.B   'TRAP TASK TEST', 0

    END    START        
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
