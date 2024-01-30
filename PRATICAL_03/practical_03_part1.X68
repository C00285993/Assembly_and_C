*-----------------------------------------------------------
* Title      : practical_03_part1.X68
* Written by : Elvis Omorusi
* Date       : 30/01/2024
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:

    LEA $4000, A1
    MOVE.B #100,(A1)
                  
    SIMHALT             

    END    START        
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
