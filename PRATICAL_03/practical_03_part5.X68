*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:         

    MOVEA.L #ACHIEVEMENT_POINTS, A1
    MOVE.L #0, D0

    MOVE.L  (A1)+, D2

    ADD.L   D2, D0

    MOVE.L  (A1)+, D2
    ADD.L   D2, D0

    MOVE.L  (A1)+, D2
    ADD.L   D2, D0

    MOVE.L  (A1)+, D2
    ADD.L   D2, D0

    MOVE.L  (A1)+, D2

    ADD.L D2, D0
    ACHIEVEMENT_POINTS: DC.L 5, 10, 15, 20, 30
     
    SIMHALT             

    END    START        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
