*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000


*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
*-------------------------------------------------------
EXIT        EQU 0      USED TO EXIT ASSEMBLY PROGRAM
MIN_POTIONS EQU 1      MIN NUMBER OF POTIONS
MAX_POTIONS EQU 9      MAX NUMBER OF POTIONS
MIN_WEAPONS EQU 1      MIN WEAPONS
MAX_WEAPONS EQU 3      MAX WEAPONS
WIN_POINT   EQU 5      POINTS ACCUMILATED ON WIN
LOSE_POINT  EQU 8      POINTS DEDUCTED ON A LOSS

MINE_LOC    EQU 100    USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP
                       * EXAMPLE FOR A HIT


*START OF GAME
START:
    MOVE.B  #100,$4000 PUT SCORE/HEALTH IN MEMORY LOCATION $4000
    LEA     $4000,A3   ASSIGN ADDRESS A3 TO THAT MEMORY LOCATION
    MOVE.B  #1, $7000   ;Deafult weapon Daggers
    MOVE.B  #100, $6400 ;Enemy1 Health
    MOVE.B  #125, $6500 ;Enemy2 Health
    MOVE.W  #200, $6600 ;Enemy3 Health
    MOVE.B  #20, $6700  ;PLAYER
    
    BSR     WELCOME    BRANCH TO THE WELCOME SUBROUTINE
    BSR     INTRODUCTION   
    BSR     INTRODUCTION2 
    BSR     GAME       BRANCH TO THE GAME SUBROUTINE
*GAME LOOP
    ORG     $3000      THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR     SCENE1     BRANCH TO SCENE1SUBROUTINE
    RTS                RETURN FROM GAME: SUBROUTINE
          
END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    BSR     ENDL            BRANCH TO ENDL SUBROUTINE
    LEA     WELCOME_MSG,A1  ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          MOVE LITERAL 14 TO DO
    TRAP    #15             TRAP AND INTERPRET VALUE IN D0
    LEA     CONTINUE_MSG, A1
    MOVE.B  #14,D0          
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    BSR     ENDL            BRANCH TO ENDL SUBROUTINE
    RTS                     RETURN FROM WELCOME: SUBROUTINE
*INTRODUCTION
INTRODUCTION:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     INTRODUCTION_MSG, A1
    MOVE.B  #14,D0         
    TRAP    #15             
    MOVE.B  #4,D0
    TRAP    #15
    BSR     ENDL            
    RTS  
INTRODUCTION2:
    BSR     CLEAR_SCREEN
    BSR     ENDL
    LEA     INTRODUCTION2_MSG, A1
    MOVE.B  #14,D0         
    TRAP    #15             
    MOVE.B  #4,D0
    TRAP    #15
    BSR     ENDL            
    RTS  
*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    
INPUT:
    BSR     POTIONS         BRANCH TO POTION INPUT SUBROUTINE
    BSR     WEAPONS         BRANCH TO WEAPONSS INPUT SUBROUTINE
    RTS

*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    BSR     UPDATE          BRANCH TO UPDATE GAME SUBROUTINE 
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN         
    BSR     DRAW            BRANCH TO DRAW SCREEN SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     GAMEPLAY        BRANCH TO GAMEPLAY SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     HUD             BRANCH TO DISPLAY HUD SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    BSR     REPLAY          BRANCH TO REPLAY GAME SUBROUTINE
    BSR     CLEAR_SCREEN    CLEARS THE SCREEN
    RTS                     RETURN FROM GAMELOOP: SUBROUTINE

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 
UPDATE:
    BSR     ENDL            PRINT A CR AND LF
    BSR     DECORATE        DECORATE WITH DOTS USING A LOOP
    LEA     UPDATE_MSG,A1   
    MOVE.B  #14,D0
    TRAP    #15
    BSR     DECORATE
    RTS
*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 
DRAW:
    BSR     ENDL
    BSR     DECORATE
    LEA     DRAW_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*--------------------POTIONS INVENTORY---------------------
* NUMBER OF POTIONS TO BE USED IN A QUEST 
*------------------------------------------------------- 
POTIONS:
    BSR     ENDL
    BSR     DECORATE
    LEA     POTIONS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    BSR     DECORATE
    LEA     CONTINUE_MSG, A1
    MOVE.B  #14,D0          
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    RTS
POTIONCHECKER:
    MOVE.B #0,D1
    MOVE.B $9000,D1
    CMP #60,D1
    BLE POTIONUSED1
    BGE POTIONDENY
POTIONDENY:
    LEA POTIONSNO,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4 ,D0
    TRAP #15
    BRA COMBAT
POTIONDENY1:
    LEA POTIONSNO1,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4 ,D0
    TRAP #15
    BRA COMBAT
POTIONUSED1:
    MOVE.B #0,D5
    SUB #1,D5
    MOVE.B D5,$9100
    BRA COMBAT
POTIONUSED:
    LEA POTIONDRANK,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    ADD.B #40,$9000
    BRA COMBAT
*-------------------------------------------------------
*--------------------Conbat---------------------
*------------------------------------------------------- 
COMBAT:
    LEA COMBAT_MSG,A1
    MOVE.B #0,D1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    CMP  #0,D1
    BEQ  CHECKER
    CMP  #1,D1
    BEQ  AMOUNTOFPOTIONS
    CMP  #2,D1
    BEQ  WEAPONS
    CMP  #3,D1
    ;BEQ  BLOCK
    ;BNE PICKACHOICE4

*-------------------------------------------------------
*-------------------------WEAPONS-----------------------
* NUMBER OF WEAPONS
*-------------------------------------------------------   
WEAPONS:
    BSR     ENDL
    BSR     DECORATE
    LEA     WEAPONS_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    LEA     CONTINUE_MSG, A1
    MOVE.B  #14,D0          
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*---GAME PLAY (QUEST PROGRESS)--------------------------
*------------------------------------------------------- 
GAMEPLAY:
    BSR     ENDL
    BSR     DECORATE
    
    RTS
    
    
SCENE1:
    BSR  CLEAR_SCREEN
    LEA  Scene1_MSG, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    LEA     SCENECHOICE1, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1, D1
    BEQ     SN1CHOICE1
    CMP     #2 , D1
    BEQ     SN1CHOICE2
    BNE     SELECT1
SELECT1:
    LEA SELECT,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BRA SCENE1
    
    
SN1CHOICE1:    
    BSR  CLEAR_SCREEN
    LEA  SCE1CHOICE1, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     COMBAT
    

SN1CHOICE2:
    BSR     CLEAR_SCREEN
    LEA     SCE1CHOICE2, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE2

SCENE2:
    BSR     CLEAR_SCREEN
    LEA     Scene2_MSG, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    ;BRA     COMBAT  
    
       
SCENE3:
    BSR  CLEAR_SCREEN
    LEA  Scene3_MSG, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    LEA     SCENE3CHOICE1, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1, D1
    BEQ     SN3CHOICE1
    CMP     #2 , D1
    BEQ     SN3CHOICE2
    BNE     SELECT3
    
    
SN3CHOICE1:    
    BSR     CLEAR_SCREEN
    LEA     SCE3CHOICE1, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE4
SN3CHOICE2:    
    BSR     CLEAR_SCREEN
    LEA     SCE3CHOICE2, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE4
    
SELECT3:
    LEA SELECT,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BRA SCENE3    
    
SCENE4:
    BSR  CLEAR_SCREEN
    LEA  Scene4_MSG, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    LEA     SCENE4CHOICE, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1, D1
    BEQ     SN4CHOICE1
    CMP     #2 , D1
    BEQ     SN4CHOICE2
    BNE     SELECT4
SN4CHOICE1:
    BSR     CLEAR_SCREEN
    LEA     SCE4ATTACK, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     COMBAT
    BRA     SCENE4PART1
   

SN4CHOICE2:
    BSR     CLEAR_SCREEN
    LEA     SCE4RUNAWAY, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE4PART2
   
SCENE4PART1:
    BSR     CLEAR_SCREEN
    LEA     SCENE4AFTERFIGHT, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE5
    
SCENE4PART2:
    BSR     CLEAR_SCREEN
    LEA     SCENE4RUNAWAY, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE5

SELECT4:
    LEA SELECT,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BRA SCENE4
SCENE5:
    BSR  CLEAR_SCREEN
    LEA  Scene5_MSG, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    LEA     SCENE5CHOICE1, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1, D1
    BEQ     SN5CHOICE1
    CMP     #2 , D1
    BEQ     SN5CHOICE2
    BNE     SELECT5
SN5CHOICE1:
    BSR     CLEAR_SCREEN
    LEA     SCE5ACC, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE6




SN5CHOICE2:
    BSR     CLEAR_SCREEN
    LEA     SCE5REJECT, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     SCENE6

SELECT5:
    LEA SELECT,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BRA SCENE5
    
SCENE6:
    BSR  CLEAR_SCREEN
    LEA  Scene6_MSG, A1   
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    LEA     SCE6CHOICE, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4,D0
    TRAP    #15
    CMP     #1, D1
    BEQ     SN6CHOICE1
    CMP     #2 , D1
    BEQ     SN6CHOICE2
    BNE     SELECT6
SN6CHOICE1: 
    BSR     CLEAR_SCREEN
    LEA     SCE6ATTACK, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     COMBAT
SN6CHOICE2:
    BSR     CLEAR_SCREEN
    LEA     SCE6SNEAK, A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  #4, D0
    TRAP    #15
    BRA     COMBAT

SELECT6:
    LEA SELECT,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BRA SCENE6    




    


    
*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (SCORE)--------------
* RETRIEVES THE SCORE FROM MEMORY LOCATION
*-------------------------------------------------------   
HUD:

    BSR     ENDL
    BSR     DECORATE
    LEA     HUD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  (A3),D1     RETRIEVE THE VALUE A3 POINT TO AND MOVE TO D1
    MOVE.B  #3,D0       MOVE LITERAL 3 TO D0
    TRAP    #15         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    BSR     DECORATE
    RTS

*-------------------------------------------------------
*-----------------------BEING ATTACKED------------------
* THIS COULD BE USED FOR COLLISION DETECTION
*-------------------------------------------------------
COLLISION:
    MOVE.B  #MINE_LOC,D1
    CMP     #100,D1 IS( X == 100)?
	BNE     COLLISION_MISS IF X IS EQUAL TO 100, THEN HIT
COLLISION_HIT:
    *HIT
    LEA     HIT_MSG,A1
    MOVE    #14,D0
    TRAP    #15
    RTS
    
COLLISION_MISS:
    *MISS
    LEA     MISS_MSG,A1
    MOVE    #14,D0
    TRAP    #15
    RTS


*-------------------------------------------------------
*--------------------------LOOP-------------------------
*-------------------------------------------------------
LOOP:
    MOVE.B  #5, D3 LOOP COUNTER D3=5
NEXT:
    LEA     LOOP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
	SUB     #1,D3   DECREMENT LOOP COUNTER
    BNE     NEXT    REPEAT UNTIL D0=0

*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
DECORATE:
    MOVE.B  #60, D3
    BSR     ENDL
OUT:
    LEA     LOOP_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
	SUB     #1,D3   DECREMENT LOOP COUNTER
    BNE     OUT	    REPEAT UNTIL D0=0
    BSR     ENDL
    RTS
    
CLEAR_SCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS
*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------
REPLAY:
    BSR     ENDL
    LEA     REPLAY_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    MOVE.B  #4,D0
    TRAP    #15

    CMP     #EXIT,D1
    BEQ     END         IF SR Z REGISTER CONTAINS 1 BEQ => BRANCH EQUALS
    BSR     GAMELOOP

ENDL:
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS
    
*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------

CRLF:           DC.B    $0D,$0A,0
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    'Desert Frostblade: Echoes of Chill'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
POTION_MSG:     DC.B    'POTION ....'
                DC.B    $0D,$0A
                DC.B    'ENTER POTION : ',0
POTIONS_MSG:    DC.B    'NUMBER OF POTIONS : ',0
WEAPONS_MSG:    DC.B    'EACH QUEST NEED AT LEAST 2 WEAPONS'
                DC.B    $0D,$0A
                DC.B    'MINIMUM REQUIREMENT IS 2 I.E. SWORD X 1 AND SPEER X 1.'
                DC.B    $0D,$0A
                DC.B    'ENTER # OF WEAPONS : ',0
GAMEPLAY_MSG:   DC.B    'ADD GAMEPLAY !',0
UPDATE_MSG:     DC.B    'UPDATE GAMEPLAY !',0
DRAW_MSG:       DC.B    'DRAW SCREEN !',0
HIT_MSG:        DC.B    'STRIKE!',0
MISS_MSG:       DC.B    'MISS!',0
LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT ANY OTHER NUMBER TO REPLAY : ',0
HUD_MSG:        DC.B    'SCORE : ',0 
SELECTCHOICE:   DC.B    'Pick a Choice', 0
CONTINUE_MSG:    DC.B    'Press Enter to continue', 0
INTRODUCTION_MSG:   DC.B    'Amidst the vast expanse of the Middle Eastern deserts, where the relentless sun'
                DC.B    $0D,$0A
                DC.B    'casts its unyielding gaze upon the golden dunes, a lone wanderer known as '
                DC.B    $0D,$0A
                DC.B    'Raheel emerges as an enigmatic figure. Driven by an insatiable desire to master '
                DC.B    $0D,$0A
                DC.B    'the forgotten arts of cold weapons in a land dominated by searing heat, Raheel'
                DC.B    $0D,$0A
                DC.B    'embarks on a solitary quest, carving his own destiny amidst the shifting sands.'
                DC.B    $0D,$0A
                DC.B    'Press Enter to continue', 0

            
INTRODUCTION2_MSG:   DC.B    'Born and raised in the ancient city of Aqaba, Raheel''s initial discovery of '
                DC.B    $0D,$0A
                DC.B    'the old tome within the city''s archives opened the floodgates of his destiny.'
                DC.B    $0D,$0A
                DC.B    'Dusty pages unfolded tales of legendary cold weapons scattered across the'
                DC.B    $0D,$0A
                DC.B    'desert, each possessing a unique power waiting to be harnessed by a master.'
                DC.B    $0D,$0A
                DC.B    'Guided by a mysterious vision, Raheel sets out to uncover these ancient '
                DC.B    $0D,$0A
                DC.B    'relics, driven not only by personal ambition but also by the silent '
                DC.B    $0D,$0A
                DC.B    'whispers of the desert wind, urging him to restore a balance that '
                DC.B    $0D,$0A
                DC.B    'has long been lost beneath the relentless sun.'
                DC.B    $0D,$0A
                DC.B    'Press Enter to continue', 0

                
Scene1_MSG:     DC.B    '-------------------------------------------------------' 
                DC.B    $0D,$0A
                DC.B    'You enter the Cave of Eternal Frost, where the elusive '
                DC.B    $0D,$0A
                DC.B    'Frost Djinn guardS the Crystal Khopesh, an ancient blade ' 
                DC.B    $0D,$0A
                DC.B    'infused with the essence of winter.'
                DC.B    $0D,$0A
                DC.B    '-------------------------------------------------------' , 0
STARTEDWEAPON   DC.B    'You brought a small dagger with you'
SCENECHOICE1    DC.B    '[1] You fight the guard or [2] You wait  and sneak up to Grab the sword',0
SCE1CHOICE1     DC.B    'You are brave, and try to fight the guards with your Daggers', 0
SCE1CHOICE2     DC.B    'You made the right choice and decided to wait until night time'
                DC.B    $0D,$0A
                DC.B    ', you sneak up succesfully and grab the Sword.'
                DC.B    $0D,$0A
                DC.B    ', you feel a strange power filling your body....', 0
Scene2_MSG:     DC.B    'The Frost Dijinn notice your presence and a getting ready to attack you!'
                DC.B    $0D,$0A
                DC.B    'Equip your swoard!', 0
Scene3_MSG:             DC.B    'You manage to defeated the Dijin Guard'
                DC.B    $0D,$0A
                DC.B    'You are amaze at your own power....'
                DC.B    $0D,$0A
                DC.B    'You gaze at the sword for a couple of seconds before looking around the cave'
                DC.B    $0D,$0A
                DC.B    'You find a treasure chest with 5 poitions and a bunch of golden coins in it',0
                DC.B    $0D,$0A
SCENE3CHOICE1   DC.B    '[1] You grab the chest or [2]Leave the cave' , 0
SCE3CHOICE1     DC.B    'You grab the potions and leave the cave', 0
SCE3CHOICE2     DC.B    'You leave the cave', 0
Scene4_MSG      DC.B    'You succesfully Obtain the Crystal Khopesh, achiving one of the 3 sacred weapons '
                DC.B    $0D,$0A
                DC.B    'You see the ancient city of Agaba at the distance and you decided to head there'
                DC.B    $0D,$0A
                DC.B    'A soon as you enter the city the people notice your swoard and change'
                DC.B    $0D,$0A
                DC.B    'They scared to aproach you but a young brave kid you know aproach you to ask you'
                DC.B    $0D,$0A
                DC.B    'About the sword at your back, you tell him about your exploits'
                DC.B    $0D,$0A
                DC.B    'The kid amaze runs to spread the story to the whole city'
                DC.B    $0D,$0A
                DC.B    'As you are planing your next move a suspicious individual aproach you'
                DC.B    $0D,$0A
                DC.B    '"Hey...arent you the talk of the town?...That sword is the Khospesh aint it?"'
                DC.B    $0D,$0A
                DC.B    '"How about you run me that!"', 0
                DC.B    $0D,$0A
SCENE4CHOICE    DC.B    '[1] Attack him or [2] Run away', 0
SCE4ATTACK      DC.B    '"Im going to crush you, you folder characther!"', 0
SCE4RUNAWAY     DC.B     '"It is not too late for a gentleman for vengence!" you leave the man behind' , 0
SCENE4AFTERFIGHT    DC.B    '"After the fight people look at you in awe and your reputacion increases', 0
SCENE4RUNAWAY   DC.B 'You leave the scene will people look at you dumbfunded your reputacion decreases', 0
Scene5_MSG          DC.B    'You are aproached by the guild: Whispering Shadows a famous guild know for'
                DC.B    $0D,$0A
                DC.B    ' its mastery over the art of the Frigid Daggers and harsh training.'
                DC.B    $0D,$0A
                DC.B    '"Would you be interested in joining our guild Whispering Shadows?"'
                DC.B    $0D,$0A
SCENE5CHOICE1   DC.B    '[1]Join them or [2] Reject', 0
SCE5ACC         DC.B    '"Sure, Im quiet intriege by your guild'
                DC.B    $0D,$0A
                DC.B    'A couple of weeks pass by and you master the art of The frigids weapons.'
                DC.B    $0D,$0A
                DC.B    'YOU GAIN 20 EXTRA HP AND A NEW SET OF DAGGERS!', 0 
SCE5REJECT      DC.B    '"Nah id Reject"'
                DC.B    $0D,$0A
                DC.B    '"The member is confused and look at you leave"'
                DC.B    $0D,$0A
                DC.B    'You wander aimlessly trought the city for a few weeks having fun'
                DC.B    $0D,$0A
                DC.B    'YOU LOOSE 20 HP AND ALL YOUR GOLDEN COINS'
                DC.B    $0D,$0A
Scene6_MSG         DC.B    'You leave the town to look for the next Weapon: The Arctic Bow.'
                DC.B    $0D,$0A
                DC.B    'Located in the Sphinx of the Frozen Oasis'
                DC.B    $0D,$0A
                DC.B    'When you get to the desert you walk for a while and see the Guardian'
                DC.B    $0D,$0A
                DC.B    'And at the back of the guardian you see the Arctic Bow', 0
                DC.B    $0D,$0A

SCE6CHOICE      DC.B    '[1] Face it head on [2] Sneak attack it', 0
SCE6ATTACK      DC.B    'YOU FACE IT HEAD ON!'
SCE6SNEAK       DC.B    'You manage to sneak attack it, successfully avoiding the damage', 0
Scene7_MSG      DC.B    'At last you manage to defeated the Guardian, and succesfully obtain the Artic Bow '
                DC.B    $0D,$0A
                DC.B    'After Holding the bow another changes occurs to Raheel, His body transform, '
                DC.B    $0D,$0A
                DC.B    'Furthering developing his body, each trials make Raheel stronger.'
                DC.B    $0D,$0A
                DC.B    'As he gaze at the dunes of the desert Raheel gets ready for its adventure', 0
                DC.B    $0D,$0A


SELECT          DC.B    'What you waiting for?', 0
ENDSCENE        DC.B    'To be continue...', 0
Lose            DC.B    'Skill issue', 0
Win             DC.B    'YOU WIN W'     ,0                     
COMBAT_MSG:         DC.B    'Do you want to attack[1] Use potion [2] change weapon [3] ',0
ATTACKSCHOICE1   DC.B    'YOU RECEIVE 100 DAMAGE! ',0
ATTACKSCHOICE2   DC.B    'YOU RECEIVE 20 DAMAGE!'  ,0             
ATTACKSCHOICES  DC.B    'YOU RECIVE 25  DAMAGE:', 0
ATTACKSCHOICES  DC.B    'YOU RECIVE 30  DAMAGE:', 0
DAGGER          DC.B    10
SWORD           DC.B    50             

SWITCHWEAPONS   DC.B    'YOU SWITCH WEAPONS', 0
POTIONNUM       DC.B    5      
HEALTH:         DS.W    1   PLAYERS HEALTH
SCORE:          DS.W    1   RESERVE SPACE FOR SCORE

    END START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
