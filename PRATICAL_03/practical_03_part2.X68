*-----------------------------------------------------------
* Title      : practical_03_part2.X68
* Written by : Elvis Omorusi
* Date       : 30/01/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:  


    LEA $4000, A2
    MOVE.B #100, (A2)
    SUB.B   #10,    (A2) 
                  
    SIMHALT             
    
    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
