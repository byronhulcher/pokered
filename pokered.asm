INCLUDE "constants.asm"

; the rst vectors are unused
SECTION "rst00",HOME[0]
	db $FF
SECTION "rst08",HOME[8]
	db $FF
SECTION "rst10",HOME[$10]
	db $FF
SECTION "rst18",HOME[$18]
	db $FF
SECTION "rst20",HOME[$20]
	db $FF
SECTION "rst28",HOME[$28]
	db $FF
SECTION "rst30",HOME[$30]
	db $FF
SECTION "rst38",HOME[$38]
	db $FF

; interrupts
SECTION "vblank",HOME[$40]
	jp $2024
SECTION "lcdc",HOME[$48]
	db $FF
SECTION "timer",HOME[$50]
	jp $2306
SECTION "serial",HOME[$58]
	jp $2125
SECTION "joypad",HOME[$60]
	reti

SECTION "bank0",HOME[$61]
DisableLCD:
;$0061
	xor a
	ld [$ff0f],a
	ld a,[$ffff]
	ld b,a
	res 0,a
	ld [$ffff],a
.jr0\@
	ld a,[$ff44]
	cp a,$91
	jr nz,.jr0\@
	ld a,[$ff40]
	and a,$7f	; res 7,a
	ld [$ff40],a
	ld a,b
	ld [$ffff],a
	ret

EnableLCD:
;$007b
	ld a,[$ff40]
	set 7,a
	ld [$ff40],a
	ret

CleanLCD_OAM:
;$0082
	xor a
	ld hl,$c300
	ld b,$a0
.jr0\@
	ld [hli],a
	dec b
	jr nz,.jr0\@
	ret

ResetLCD_OAM:
;$008d
	ld a,$a0
	ld hl,$c300
	ld de,$0004
	ld b,$28
.jr0\@
	ld [hl],a
	add hl,de
	dec b
	jr nz,.jr0\@
	ret

FarCopyData: ; 009D
; copy bc bytes of data from a:hl to de
	ld [$CEE9],a ; save future bank # for later
	ld a,[$FFB8] ; get current bank #
	push af
	ld a,[$CEE9] ; get future bank #, switch
	ld [$FFB8],a
	ld [$2000],a
	call CopyData
	pop af       ; okay, done, time to switch back
	ld [$FFB8],a
	ld [$2000],a
	ret
CopyData: ; 00B5
; copy bc bytes of data from hl to de
	ld a,[hli]
	ld [de],a
	inc de
	dec bc
	ld a,c
	or b
	jr nz,CopyData
	ret

SECTION "romheader",HOME[$100]
nop
jp Start

Section "start",HOME[$150]
Start:
INCBIN "baserom.gbc",$150,$1AE - $150
; see also MapHeaderBanks
MapHeaderPointers: ; $01AE
	dw PalletTown_h ; PALLET_TOWN
	dw ViridianCity_h ; VIRIDIAN_CITY
	dw PewterCity_h ; PEWTER_CITY
	dw CeruleanCity_h ; CERULEAN_CITY
	dw LavenderTown_h ; LAVENDER_TOWN
	dw VermilionCity_h ; VERMILION_CITY
	dw CeladonCity_h ; CELADON_CITY
	dw FuchsiaCity_h ; FUCHSIA_CITY
	dw CinnabarIsland_h ; CINNABAR_ISLAND
	dw IndigoPlateau_h ; INDIGO_PLATEAU
	dw SaffronCity_h ; SAFFRON_CITY
	dw SaffronCity_h ; unused
	dw Route1_h ; ROUTE_1
	dw $4000 ; ROUTE_2
	dw Route3_h ; ROUTE_3
	dw Route4_h ; ROUTE_4
	dw Route5_h ; ROUTE_5
	dw Route6_h ; ROUTE_6
	dw Route7_h ; ROUTE_7
	dw Route8_h ; ROUTE_8
	dw Route9_h ; ROUTE_9
	dw Route10_h ; ROUTE_10
	dw Route11_h ; ROUTE_11
	dw Route12_h ; ROUTE_12
	dw Route13_h ; ROUTE_13
	dw Route14_h ; ROUTE_14
	dw Route15_h ; ROUTE_15
	dw Route16_h ; ROUTE_16
	dw Route17_h ; ROUTE_17
	dw Route18_h ; ROUTE_18
	dw Route19_h ; ROUTE_19
	dw Route20_h ; ROUTE_20
	dw Route21_h ; ROUTE_21
	dw Route22_h ; ROUTE_22
	dw Route23_h ; ROUTE_23
	dw Route24_h ; ROUTE_24
	dw Route25_h ; ROUTE_25
	dw RedsHouse1F_h
	dw RedsHouse2F_h
	dw BluesHouse_h
	dw OaksLab_h
	dw ViridianPokecenter_h
	dw ViridianMart_h
	dw School_h
	dw ViridianHouse_h
	dw ViridianGym_h
	dw DiglettsCaveRoute2_h
	dw ViridianForestexit_h
	dw Route2House_h
	dw Route2Gate_h
	dw ViridianForestEntrance_h
	dw ViridianForest_h
	dw MuseumF1_h
	dw MuseumF2_h
	dw PewterGym_h
	dw PewterHouse1_h
	dw PewterMart_h
	dw PewterHouse2_h
	dw PewterPokecenter_h
	dw MtMoon1_h
	dw MtMoon2_h
	dw MtMoon3_h
	dw CeruleanHouseTrashed_h
	dw CeruleanHouse2_h
	dw CeruleanPokecenter_h
	dw CeruleanGym_h
	dw BikeShop_h
	dw CeruleanMart_h
	dw MtMoonPokecenter_h
	dw CeruleanHouseTrashed_h ; copy of map 62
	dw Route5Gate_h
	dw UndergroundTunnelEntranceRoute5_h
	dw DayCareM_h
	dw Route6Gate_h
	dw UndergroundTunnelEntranceRoute6_h
	dw $56e3 ; id=75
	dw Route7Gate_h
	dw UndergroundPathEntranceRoute7_h
	dw $575d
	dw Route8Gate_h
	dw UndergroundPathEntranceRoute8_h
	dw RockTunnelPokecenter_h
	dw RockTunnel1_h
	dw PowerPlant_h
	dw Route11Gate_h
	dw DiglettsCaveEntranceRoute11_h
	dw Route11GateUpstairs_h
	dw Route12Gate_h
	dw BillsHouse_h
	dw VermilionPokecenter_h
	dw FanClub_h
	dw VermilionMart_h
	dw VermilionGym_h
	dw VermilionHouse1_h
	dw VermilionDock_h
	dw SSAnne1_h
	dw SSAnne2_h
	dw SSAnne3_h
	dw SSAnne4_h
	dw SSAnne5_h
	dw SSAnne6_h
	dw SSAnne7_h
	dw SSAnne8_h
	dw SSAnne9_h
	dw SSAnne10_h ; id=104
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw VictoryRoad1_h ; id=108
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw Lance_h ; unused
	dw $6492
	dw UndergroundPathNS_h
	dw $5f11
	dw UndergroundPathWE_h
	dw CeladonMart1_h
	dw CeladonMart2_h
	dw CeladonMart3_h
	dw CeladonMart4_h
	dw CeladonMartRoof_h
	dw CeladonMartElevator_h
	dw CeladonMansion1_h
	dw CeladonMansion2_h
	dw CeladonMansion3_h
	dw CeladonMansion4_h
	dw CeladonMansion5_h
	dw CeladonPokecenter_h
	dw CeladonGym_h
	dw CeladonGameCorner_h
	dw CeladonMart5_h
	dw CeladonPrizeRoom_h
	dw CeladonDiner_h
	dw CeladonHouse2_h
	dw CeladonHotel_h
	dw LavenderPokecenter_h
	dw PokemonTower1_h
	dw PokemonTower2_h
	dw PokemonTower3_h
	dw PokemonTower4_h
	dw PokemonTower5_h
	dw PokemonTower6_h
	dw PokemonTower7_h
	dw LavenderHouse1_h
	dw LavenderMart_h
	dw LavenderHouse2_h
	dw FuchsiaMart_h
	dw FuchsiaHouse1_h
	dw FuchsiaPokecenter_h
	dw FuchsiaHouse2_h
	dw SafariZoneEntrance_h
	dw FuchsiaGym_h
	dw FuchsiaMeetingRoom_h
	dw SeafoamIslands2_h
	dw SeafoamIslands3_h
	dw SeafoamIslands4_h
	dw SeafoamIslands5_h
	dw VermilionHouse2_h
	dw FuchsiaHouse3_h
	dw Mansion1_h
	dw CinnabarGym_h
	dw Lab1_h
	dw Lab2_h
	dw Lab3_h
	dw Lab4_h
	dw CinnabarPokecenter_h
	dw CinnabarMart_h
	dw $5e72
	dw IndigoPlateauLobby_h
	dw CopycatsHouseF1_h
	dw CopycatsHouseF2_h
	dw FightingDojo_h
	dw SaffronGym_h
	dw SaffronHouse1_h
	dw SaffronMart_h
	dw SilphCo1_h
	dw SaffronPokecenter_h
	dw SaffronHouse2_h
	dw Route15Gate_h
	dw $563e
	dw Route16GateMap_h
	dw Route16GateUpstairs_h
	dw Route16House_h
	dw Route12House_h
	dw Route18Gate_h
	dw Route18GateHeader_h
	dw SeafoamIslands1_h
	dw Route22Gate_h
	dw VictoryRoad2_h
	dw Route12GateUpstairs_h
	dw VermilionHouse3_h
	dw DiglettsCave_h
	dw VictoryRoad3_h
	dw RocketHideout1_h
	dw RocketHideout2_h
	dw RocketHideout3_h
	dw RocketHideout4_h
	dw RocketHideoutElevator_h
	dw $5704
	dw $5704
	dw $5704
	dw SilphCo2_h
	dw SilphCo3_h ; id=208
	dw SilphCo4_h
	dw SilphCo5_h
	dw SilphCo6_h
	dw SilphCo7_h
	dw SilphCo8_h
	dw Mansion2_h
	dw Mansion3_h
	dw Mansion4_h
	dw SafariZoneEast_h
	dw SafariZoneNorth_h
	dw SafariZoneWest_h
	dw SafariZoneCenter_h
	dw SafariZoneRestHouse1_h
	dw SafariZoneSecretHouse_h
	dw SafariZoneRestHouse2_h
	dw SafariZoneRestHouse3_h
	dw SafariZoneRestHouse4_h
	dw UnknownDungeon2_h
	dw UnknownDungeon3_h
	dw UnknownDungeon1_h
	dw NameRater_h
	dw CeruleanHouse3_h
	dw $56b2
	dw RockTunnel2_h
	dw SilphCo9_h
	dw SilphCo10_h
	dw SilphCo11_h
	dw SilphCoElevator_h
	dw $5ce5
	dw $5ce5
	dw BattleCenterM_h
	dw TradeCenterM_h
	dw $5CE5
	dw $5CE5
	dw $5CE5
	dw $5CE5
	dw Loreli_h
	dw Bruno_h
	dw Agatha_h

INCBIN "baserom.gbc",$39E,$1627 - $39E

;XXX what does this do
;XXX what points to this
; offset 1627
	ld bc,$D0B8
	add hl,bc
	ld a,[hli]
	ld [$D0AB],a
	ld a,[hl]
	ld [$D0AC],a

; offset 1633
; define (by index number) the bank that a pokemon's image is in
; index = Mew, bank 1
; index = Kabutops fossil, bank $B
;	index < $1F, bank 9
; $1F ≤ index < $4A, bank $A
; $4A ≤ index < $74, bank $B
; $74 ≤ index < $99, bank $C
; $99 ≤ index,       bank $D
	ld a,[$CF91] ; XXX name for this ram location
	ld b,a
	cp $15
	ld a,$01
	jr z,.GotBank\@
	ld a,b
	cp $B6
	ld a,$0B
	jr z,.GotBank\@
	ld a,b
	cp $1F
	ld a,$09
	jr c,.GotBank\@
	ld a,b
	cp $4A
	ld a,$0A
	jr c,.GotBank\@
	ld a,b
	cp $74
	ld a,$0B
	jr c,.GotBank\@
	ld a,b
	cp $99
	ld a,$0C
	jr c,.GotBank\@
	ld a,$0D
.GotBank\@
	jp $24FD

INCBIN "baserom.gbc",$1665,$172F - $1665

Tset0B_Coll:
	INCBIN "baserom.gbc",$172F,$1735-$172F
Tset00_Coll:
	INCBIN "baserom.gbc",$1735,$1749-$1735
Tset01_Coll:
	INCBIN "baserom.gbc",$1749,$1753-$1749
Tset02_Coll:
	INCBIN "baserom.gbc",$1753,$1759-$1753
Tset05_Coll:
	INCBIN "baserom.gbc",$1759,$1765-$1759
Tset03_Coll:
	INCBIN "baserom.gbc",$1765,$1775-$1765
Tset08_Coll:
	INCBIN "baserom.gbc",$1775,$177F-$1775
Tset09_Coll:
	INCBIN "baserom.gbc",$177F,$178A-$177F
Tset0D_Coll:
	INCBIN "baserom.gbc",$178A,$1795-$178A
Tset0E_Coll:
	INCBIN "baserom.gbc",$1795,$179A-$1795
Tset0F_Coll:
	INCBIN "baserom.gbc",$179A,$17A2-$179A
Tset10_Coll:
	INCBIN "baserom.gbc",$17A2,$17AC-$17A2
Tset11_Coll:
	INCBIN "baserom.gbc",$17AC,$17B8-$17AC
Tset12_Coll:
	INCBIN "baserom.gbc",$17B8,$17C0-$17B8
Tset13_Coll:
	INCBIN "baserom.gbc",$17C0,$17CA-$17C0
Tset14_Coll:
	INCBIN "baserom.gbc",$17CA,$17D1-$17CA
Tset15_Coll:
	INCBIN "baserom.gbc",$17D1,$17DD-$17D1
Tset16_Coll:
	INCBIN "baserom.gbc",$17DD,$17F0-$17DD
Tset17_Coll:
	INCBIN "baserom.gbc",$17F0,$190F-$17F0

ClearScreen: ; 190F
; clears all tiles in the tilemap,
; then wait three frames
	ld bc,$0168 ; tilemap size
	inc b
	ld hl,$C3A0 ; TILEMAP_START
	ld a,$7F    ; $7F is blank tile
.loop\@
	ld [hli],a
	dec c
	jr nz,.loop\@
	dec b
	jr nz,.loop\@
	jp Delay3

TextBoxBorder: ; 1922
; draw a text box
; upper-left corner at coordinates hl
; height b
; width c

	; first row
	push hl
	ld a,"┌"
	ld [hli],a
	inc a    ; horizontal border ─
	call NPlaceChar
	inc a    ; upper-right border ┐
	ld [hl],a

	; middle rows
	pop hl
	ld de,20
	add hl,de ; skip the top row

.PlaceRow\@
	push hl
	ld a,"│"
	ld [hli],a
	ld a," "
	call NPlaceChar
	ld [hl],"│"

	pop hl
	ld de,20
	add hl,de ; move to next row
	dec b
	jr nz,.PlaceRow\@

	; bottom row
	ld a,"└"
	ld [hli],a
	ld a,"─"
	call NPlaceChar
	ld [hl],"┘"
	ret
;
NPlaceChar:
; place a row of width c of identical characters
	ld d,c
.loop\@
	ld [hli],a
	dec d
	jr nz,.loop\@
	ret

PlaceString: ; 1955
	push hl
PlaceNextChar: ; 1956
	ld a,[de]

	cp "@"
	jr nz,.PlaceText\@
	ld b,h
	ld c,l
	pop hl
	ret

.PlaceText\@
	cp $4E
	jr nz,.next\@
	ld bc,$0028
	ld a,[$FFF6]
	bit 2,a
	jr z,.next2\@
	ld bc,$14
.next2\@
	pop hl
	add hl,bc
	push hl
	jp Next19E8

.next\@
	cp $4F
	jr nz,.next3\@
	pop hl
	ld hl,$C4E1
	push hl
	jp Next19E8

.next3\@ ; Check against a dictionary
	and a
	jp z,Char00
	cp $4C
	jp z,$1B0A
	cp $4B
	jp z,Char4B
	cp $51
	jp z,Char51
	cp $49
	jp z,Char49
	cp $52
	jp z,Char52
	cp $53
	jp z,Char53
	cp $54
	jp z,Char54
	cp $5B
	jp z,Char5B
	cp $5E
	jp z,Char5E
	cp $5C
	jp z,Char5C
	cp $5D
	jp z,Char5D
	cp $55
	jp z,$1A7C
	cp $56
	jp z,Char56
	cp $57
	jp z,$1AAD
	cp $58
	jp z,Char58
	cp $4A
	jp z,Char4A
	cp $5F
	jp z,Char5F
	cp $59
	jp z,Char59
	cp $5A
	jp z,Char5A
	ld [hli],a
	call $38D3
Next19E8:
	inc de
	jp PlaceNextChar

Char00:
	ld b,h
	ld c,l
	pop hl
	ld de,Char00Text
	dec de
	ret

Char00Text: ; “%d ERROR.”
	TX_FAR _Char00Text
	db "@"

Char52: ; player’s name
	push de
	ld de,W_PLAYERNAME
	jr FinishDTE

Char53: ; rival’s name
	push de
	ld de,W_RIVALNAME
	jr FinishDTE

Char5D: ; TRAINER
	push de
	ld de,Char5DText
	jr FinishDTE

Char5C: ; TM
	push de
	ld de,Char5CText
	jr FinishDTE

Char5B: ; PC
	push de
	ld de,Char5BText
	jr FinishDTE

Char5E: ; ROCKET
	push de
	ld de,Char5EText
	jr FinishDTE

Char54: ; POKé
	push de
	ld de,Char54Text
	jr FinishDTE

Char56: ; ……
	push de
	ld de,Char56Text
	jr FinishDTE

Char4A: ; PKMN
	push de
	ld de,Char4AText
	jr FinishDTE

Char59:
; depending on whose turn it is, print
; enemy active monster’s name, prefixed with “Enemy ”
; or
; player active monster’s name
; (like Char5A but flipped)
	ld a,[H_WHOSETURN]
	xor 1
	jr MonsterNameCharsCommon

Char5A:
; depending on whose turn it is, print
; player active monster’s name
; or
; enemy active monster’s name, prefixed with “Enemy ”
	ld a,[H_WHOSETURN]
MonsterNameCharsCommon:
	push de
	and a
	jr nz,.Enemy\@
	ld de,$D009 ; player active monster name
	jr FinishDTE

.Enemy\@ ; 1A40
	; print “Enemy ”
	ld de,Char5AText
	call PlaceString

	ld h,b
	ld l,c
	ld de,$CFDA ; enemy active monster name

FinishDTE:
	call PlaceString
	ld h,b
	ld l,c
	pop de
	inc de
	jp PlaceNextChar

Char5CText:
	db "TM@"
Char5DText:
	db "TRAINER@"
Char5BText:
	db "PC@"
Char5EText:
	db "ROCKET@"
Char54Text:
	db "POKé@"
Char56Text:
	db "……@"
Char5AText:
	db "Enemy @"
Char4AText:
	db $E1,$E2,"@" ; PKMN

Char55:
	push de
	ld b,h
	ld c,l
	ld hl,Char55Text
	call $1B40
	ld h,b
	ld l,c
	pop de
	inc de
	jp PlaceNextChar

Char55Text:
; equivalent to Char4B
	TX_FAR _Char55Text
	db "@"

Char5F:
; ends a Pokédex entry
	ld [hl],"."
	pop hl
	ret

Char58:
	ld a,[$D12B]
	cp 4
	jp z,Next1AA2
	ld a,$EE
	ld [$C4F2],a
Next1AA2:
	call ProtectedDelay3
	call $3898
	ld a,$7F
	ld [$C4F2],a
	pop hl
	ld de,Char58Text
	dec de
	ret

Char58Text:
	db "@"

Char51:
	push de
	ld a,$EE
	ld [$C4F2],a
	call ProtectedDelay3
	call $3898
	ld hl,$C4A5
	ld bc,$0412
	call $18C4
	ld c,$14
	call DelayFrames
	pop de
	ld hl,$C4B9
	jp Next19E8

Char49:
	push de
	ld a,$EE
	ld [$C4F2],a
	call ProtectedDelay3
	call $3898
	ld hl,$C469
	ld bc,$0712
	call $18C4
	ld c,$14
	call DelayFrames
	pop de
	pop hl
	ld hl,$C47D
	push hl
	jp Next19E8

Char4B:
	ld a,$EE
	ld [$C4F2],a
	call ProtectedDelay3
	push de
	call $3898
	pop de
	ld a,$7F
	ld [$C4F2],a
	push de
	call Next1B18
	call Next1B18
	ld hl,$C4E1
	pop de
	jp Next19E8

Next1B18:
	ld hl,$C4B8
	ld de,$C4A4
	ld b,$3C
.next\@
	ld a,[hli]
	ld [de],a
	inc de
	dec b
	jr nz,.next\@
	ld hl,$C4E1
	ld a,$7F
	ld b,$12
.next2\@
	ld [hli],a
	dec b
	jr nz,.next2\@

	; wait five frames
	ld b,5
.WaitFrame\@
	call DelayFrame
	dec b
	jr nz,.WaitFrame\@

	ret

ProtectedDelay3:
	push bc
	call Delay3
	pop bc
	ret

INCBIN "baserom.gbc",$1B40,$20AF - $1B40

DelayFrame: ; 20AF
; delay for one frame
	ld a,1
	ld [$FFD6],a

; wait for the next Vblank, halting to conserve battery
.halt\@
	db $76 ; XXX this is a hack--rgbasm adds a nop after this instr
	       ; even when ints are enabled
	ld a,[$FFD6]
	and a
	jr nz,.halt\@

	ret

; These routines manage gradual fading
; (e.g., entering a doorway)
LoadGBPal: ; 20BA
	ld a,[$d35d]		;tells if cur.map is dark
	ld b,a			;(requires HM5_FLASH?)
	ld hl,GBPalTable_00	;16
	ld a,l
	sub b
	ld l,a
	jr nc,.jr0\@
	dec h
.jr0\@
	ld a,[hli]
	ld [rBGP],a
	ld a,[hli]
	ld [rOBP0],a
	ld a,[hli]
	ld [rOBP1],a
	ret

GBFadeOut1: ; 20D1
	ld hl,IncGradGBPalTable_01	;0d
	ld b,$04
	jr GBFadeOutCommon

GBFadeOut2: ; 20D8
	ld hl,IncGradGBPalTable_02	;1c
	ld b,$03

GBFadeOutCommon:
	ld a,[hli]
	ld [rBGP],a
	ld a,[hli]
	ld [rOBP0],a
	ld a,[hli]
	ld [rOBP1],a
	ld c,8
	call DelayFrames
	dec b
	jr nz,GBFadeOutCommon
	ret

GBFadeIn1: ; 20EF
	ld hl,DecGradGBPalTable_01	;18
	ld b,$04
	jr GBFadeInCommon

GBFadeIn2: ; 20F6
	ld hl,DecGradGBPalTable_02	;21
	ld b,$03

GBFadeInCommon:
	ld a,[hld]
	ld [rOBP1],a
	ld a,[hld]
	ld [rOBP0],a
	ld a,[hld]
	ld [rBGP],a
	ld c,8
	call DelayFrames
	dec b
	jr nz,GBFadeInCommon
	ret

IncGradGBPalTable_01: ; 210D
	db %11111111	;BG Pal
	db %11111111	;OBJ Pal 1
	db %11111111	;OBJ Pal 2
			;and so on...
	db %11111110
	db %11111110
	db %11111000

	db %11111001
	db %11100100
	db %11100100
GBPalTable_00:		;16
	db %11100100
	db %11010000
DecGradGBPalTable_01:	;18
	db %11100000
	;19
	db %11100100
	db %11010000
	db %11100000
IncGradGBPalTable_02:	;1c
	db %10010000
	db %10000000
	db %10010000

	db %01000000
	db %01000000
DecGradGBPalTable_02:	;21
	db %01000000

	db %00000000
	db %00000000
	db %00000000

INCBIN "baserom.gbc",$2125,$2442 - $2125

; XXX where is the pointer to this data?
MartInventories: ; 2442
	; first byte $FE, next byte # of items, last byte $FF
; Viridian
	db $FE,4,POKE_BALL,ANTIDOTE,PARLYZ_HEAL,BURN_HEAL,$FF
; Pewter
	db $FE,7,POKE_BALL,POTION,ESCAPE_ROPE,ANTIDOTE,BURN_HEAL,AWAKENING
	db PARLYZ_HEAL,$FF
; Cerulean
	db $FE,7,POKE_BALL,POTION,REPEL,ANTIDOTE,BURN_HEAL,AWAKENING
	db PARLYZ_HEAL,$FF
; Bike shop
	db $FE,1,BICYCLE,$FF
; Vermilion
	db $FE,6,POKE_BALL,SUPER_POTION,ICE_HEAL,AWAKENING,PARLYZ_HEAL
	db REPEL,$FF
; Lavender
	db $FE,9,GREAT_BALL,SUPER_POTION,REVIVE,ESCAPE_ROPE,SUPER_REPEL
	db ANTIDOTE,BURN_HEAL,ICE_HEAL,PARLYZ_HEAL,$FF
; Celadon Dept. Store 2F (1)
	db $FE,9,GREAT_BALL,SUPER_POTION,REVIVE,SUPER_REPEL,ANTIDOTE
	db BURN_HEAL,ICE_HEAL,AWAKENING,PARLYZ_HEAL,$FF
; Celadon Dept. Store 2F (2)
	db $FE,9,TM_32,TM_33,TM_02,TM_07,TM_37,TM_01,TM_05,TM_09,TM_17,$FF
; Celadon Dept. Store 4F
	db $FE,5,POKE_DOLL,FIRE_STONE,THUNDER_STONE,WATER_STONE,LEAF_STONE,$FF
; Celadon Dept. Store 5F (1)
	db $FE,7,X_ACCURACY,GUARD_SPEC_,DIRE_HIT,X_ATTACK,X_DEFEND,X_SPEED
	db X_SPECIAL,$FF
; Celadon Dept. Store 5F (2)
	db $FE,5,HP_UP,PROTEIN,IRON,CARBOS,CALCIUM,$FF
; Fuchsia
	db $FE,6,ULTRA_BALL,GREAT_BALL,SUPER_POTION,REVIVE,FULL_HEAL
	db SUPER_REPEL,$FF
; unused?
	db $FE,5,GREAT_BALL,HYPER_POTION,SUPER_POTION,FULL_HEAL,REVIVE,$FF
; Cinnabar
	db $FE,7,ULTRA_BALL,GREAT_BALL,HYPER_POTION,MAX_REPEL,ESCAPE_ROPE
	db FULL_HEAL,REVIVE,$FF
; Saffron
	db $FE,6,GREAT_BALL,HYPER_POTION,MAX_REPEL,ESCAPE_ROPE,FULL_HEAL
	db REVIVE,$FF
; Indigo
	db $FE,7,ULTRA_BALL,GREAT_BALL,FULL_RESTORE,MAX_POTION,FULL_HEAL
	db REVIVE,MAX_REPEL,$FF

INCBIN "baserom.gbc",$24d6,$24e5 - $24d6

VictoryRoad3Text10:
VictoryRoad3Text9:
VictoryRoad3Text8:
VictoryRoad3Text7:
VictoryRoad2Text13:
VictoryRoad2Text12:
VictoryRoad2Text11:
SeafoamIslands1Text2:
SeafoamIslands1Text1:
SeafoamIslands5Text2:
SeafoamIslands5Text1:
SeafoamIslands4Text6:
SeafoamIslands4Text5:
SeafoamIslands4Text4:
SeafoamIslands4Text3:
SeafoamIslands4Text2:
SeafoamIslands4Text1:
SeafoamIslands3Text2:
SeafoamIslands3Text1:
SeafoamIslands2Text2:
SeafoamIslands2Text1:
FuchsiaHouse2Text3:
VictoryRoad1Text7:
VictoryRoad1Text6: ; _VictoryRoad1Text6
VictoryRoad1Text5: ; 0x24e5
    TX_FAR _VictoryRoad1Text5
    db $50

SaffronCityText19:
CinnabarIslandText4:
FuchsiaCityText14:
VermilionCityText9:
LavenderTownText6:
CeruleanCityText14:
PewterCityText8:
ViridianCityText11: ; 0x24ea
    TX_FAR _ViridianCityText11
    db $50

PewterCityText9:
CeruleanCityText15:
LavenderTownText7:
VermilionCityText10:
CeladonCityText12:
FuchsiaCityText15:
CinnabarIslandText5:
SaffronCityText23:
Route4Text4:
Route10Text8:
ViridianCityText12: ; 0x24ef
    TX_FAR _ViridianCityText12
    db $50

Route2Text1:
Route4Text3:
Route9Text10:
Route12Text9:
Route12Text10:
Route15Text11:
Route24Text8:
Route25Text10:
ViridianGymText11:
ViridianForestText5:
ViridianForestText6:
ViridianForestText7:
MtMoon1Text8:
MtMoon1Text9:
MtMoon1Text10:
MtMoon1Text11:
MtMoon1Text12:
MtMoon1Text13:
MtMoon3Text8:
MtMoon3Text9:
PowerPlantText10:
PowerPlantText11:
PowerPlantText12:
PowerPlantText13:
PowerPlantText14:
SSAnne8Text10:
SSAnne9Text6:
SSAnne9Text9:
SSAnne10Text9:
SSAnne10Text10:
SSAnne10Text11:
VictoryRoad1Text3:
VictoryRoad1Text4:
PokemonTower3Text4:
PokemonTower4Text4:
PokemonTower4Text5:
PokemonTower4Text6:
PokemonTower5Text6:
PokemonTower6Text4:
PokemonTower6Text5:
FuchsiaHouse2Text2:
VictoryRoad2Text7:
VictoryRoad2Text8:
VictoryRoad2Text9:
VictoryRoad2Text10:
VictoryRoad3Text5:
VictoryRoad3Text6:
RocketHideout1Text6:
RocketHideout1Text7:
RocketHideout2Text2:
RocketHideout2Text3:
RocketHideout2Text4:
RocketHideout2Text5:
RocketHideout3Text3:
RocketHideout3Text4:
RocketHideout4Text5:
RocketHideout4Text6:
RocketHideout4Text7:
RocketHideout4Text8:
RocketHideout4Text9:
SilphCo3Text4:
SilphCo4Text5:
SilphCo4Text6:
SilphCo4Text7:
SilphCo5Text6:
SilphCo5Text7:
SilphCo5Text8:
SilphCo6Text9:
SilphCo6Text10:
SilphCo7Text10:
SilphCo7Text11:
Mansion3Text3:
Mansion3Text4:
Mansion4Text3:
Mansion4Text4:
Mansion4Text5:
Mansion4Text6:
Mansion4Text8:
SafariZoneEastText1:
SafariZoneEastText2:
SafariZoneEastText3:
SafariZoneEastText4:
SafariZoneNorthText1:
SafariZoneNorthText2:
SafariZoneWestText1:
SafariZoneWestText2:
SafariZoneWestText3:
SafariZoneWestText4:
SafariZoneCenterText1:
UnknownDungeon2Text1:
UnknownDungeon2Text2:
UnknownDungeon2Text3:
UnknownDungeon3Text2:
UnknownDungeon3Text3:
UnknownDungeon1Text1:
UnknownDungeon1Text2:
UnknownDungeon1Text3:
SilphCo10Text4:
SilphCo10Text5:
SilphCo10Text6:
Route2Text2: ; 0x24f4
    db $08 ; asm
    ld a, $5c
    call Predef
    jp $24d7

INCBIN "baserom.gbc",$24fd,$2f9e - $24fd

GetMonName: ; 2F9E
	push hl
	ld a,[$ffb8]
	push af
	ld a,BANK(MonsterNames) ; 07
	ld [$ffb8],a
	ld [$2000],a
	ld a,[$d11e]
	dec a
	ld hl,MonsterNames ; 421E
	ld c,10
	ld b,0
	call AddNTimes
	ld de,$cd6d
	push de
	ld bc,10
	call CopyData
	ld hl,$cd77
	ld [hl],$50
	pop de
	pop af
	ld [$ffb8],a
	ld [$2000],a
	pop hl
	ret

GetItemName: ; 2FCF
; given an item ID at [$D11E], store the name of the item into a string
;     starting at $CD6D
	push hl
	push bc
	ld a,[$D11E]
	cp HM_01 ; is this a TM/HM?
	jr nc,.Machine\@

	ld [$D0B5],a
	ld a,ITEM_NAME
	ld [$D0B6],a
	ld a,BANK(ItemNames)
	ld [$D0B7],a
	call GetName
	jr .Finish\@

.Machine\@
	call GetMachineName
.Finish\@
	ld de,$CD6D ; pointer to where item name is stored in RAM
	pop bc
	pop hl
	ret

GetMachineName:
; copies the name of the TM/HM in [$D11E] to $CD6D
	push hl
	push de
	push bc
	ld a,[$D11E]
	push af
	cp TM_01 ; is this a TM? [not HM]
	jr nc,.WriteTM\@
; if HM, then write "HM" and add 5 to the item ID, so we can reuse the
; TM printing code
	add 5
	ld [$D11E],a
	ld hl,HiddenPrefix ; points to "HM"
	ld bc,2
	jr .WriteMachinePrefix\@
.WriteTM\@
	ld hl,TechnicalPrefix ; points to "TM"
	ld bc,2
.WriteMachinePrefix\@
	ld de,$CD6D
	call CopyData

; now get the machine number and convert it to text
	ld a,[$D11E]
	sub TM_01 - 1
	ld b,$F6 ; "0"
.FirstDigit\@
	sub 10
	jr c,.SecondDigit\@
	inc b
	jr .FirstDigit\@
.SecondDigit\@
	add 10
	push af
	ld a,b
	ld [de],a
	inc de
	pop af
	ld b,$F6 ; "0"
	add b
	ld [de],a
	inc de
	ld a,"@"
	ld [de],a

	pop af
	ld [$D11E],a
	pop bc
	pop de
	pop hl
	ret

TechnicalPrefix:
	db "TM"
HiddenPrefix:
	db "HM"

INCBIN "baserom.gbc",$3040,$31cc - $3040

LoadTrainerHeader: ; 0x31cc
    call $3157
    xor a
    call $3193
    ld a, $2
    call $3193
    ld a, [$cc55]
    ld c, a
    ld b, $2
    call $31c7
    ld a, c
    and a
    jr z, .asm_c2964 ; 0x31e3 $8
    ld a, $6
    call $3193
    jp $3c49
.asm_c2964 ; 0x31ed
    ld a, $4
    call $3193
    call PrintText
    ld a, $a
    call $3193
    push de
    ld a, $8
    call $3193
    pop de
    call $3354
    ld hl, $d733
    set 4, [hl]
    ld hl, $cd60
    bit 0, [hl]
    ret nz
    call $336a
    ld hl, $da39
    inc [hl]
    jp $325d
    call $3306
    ld a, [$cf13]
    cp $ff
    jr nz, .asm_76c22 ; 0x3221 $8
    xor a
    ld [$cf13], a
    ld [$cc55], a
    ret
.asm_76c22 ; 0x322b
    ld hl, $d733
    set 3, [hl]
    ld [$cd4f], a
    xor a
    ld [$cd50], a
    ld a, $4c
    call Predef
    ld a, $f0
    ld [$cd6b], a
    xor a
    ldh [$b4], a
    call $32cf
    ld hl, $da39
    inc [hl]
    ret

INCBIN "baserom.gbc",$324c,$3474 - $324c

FuncTX_F7: ; 3474
; XXX find a better name for this function
; special_F7
        ld b,BANK(CeladonPrizeMenu)
        ld hl,CeladonPrizeMenu
        call Bankswitch
        jp $29DF        ; continue to main text-engine function

INCBIN "baserom.gbc",$347F,$3493 - $347F

IsItemInBag: ; 3493
; given an item_id in b
; set zero flag if item isn't in player's bag
; else reset zero flag
; related to Pokémon Tower and ghosts
	ld a,$1C
	call Predef
	ld a,b
	and a
	ret

INCBIN "baserom.gbc",$349B,$3541 - $349B

Function3541: ; 3541
; XXX what do these three functions do
	push hl
	call Function354E
	ld [hl],$FF
	call Function3558
	ld [hl],$FF
	pop hl
	ret

Function354E: ; 354E
	ld h,$C2
	ld a,[$FF8C] ; the sprite to move
	swap a
	add a,6
	ld l,a
	ret

Function3558: ; 3558
	push de
	ld hl,$D4E4
	ld a,[$FF8C] ; the sprite to move
	dec a
	add a
	ld d,0
	ld e,a
	add hl,de
	pop de
	ret

INCBIN "baserom.gbc",$3566,$35BC - $3566

BankswitchHome: ; 35BC
; switches to bank # in a
; Only use this when in the home bank!
	ld [$CF09],a
	ld a,[$FFB8]
	ld [$CF08],a
	ld a,[$CF09]
	ld [$FFB8],a
	ld [$2000],a
	ret

BankswitchBack: ; 35CD
; returns from BankswitchHome
	ld a,[$CF08]
	ld [$FFB8],a
	ld [$2000],a
	ret

Bankswitch: ; 35D6
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ld a,[$FFB8]
	push af
	ld a,b
	ld [$FFB8],a
	ld [$2000],a
	ld bc,.Return\@
	push bc
	jp [hl]
.Return\@
	pop bc
	ld a,b
	ld [$FFB8],a
	ld [$2000],a
	ret

INCBIN "baserom.gbc",$35EC,$363A - $35EC

MoveSprite: ; 363A
; move the sprite [$FF8C] with the movement pointed to by de
; actually only copies the movement data to $CC5B for later
	call Function3541
	push hl
	push bc
	call Function354E
	xor a
	ld [hl],a
	ld hl,$CC5B
	ld c,0

.loop\@
	ld a,[de]
	ldi [hl],a
	inc de
	inc c
	cp a,$FF ; have we reached the end of the movement data?
	jr nz,.loop\@

	ld a,c
	ld [$CF0F],a ; number of steps taken

	pop bc
	ld hl,$D730
	set 0,[hl]
	pop hl
	xor a
	ld [$CD3B],a
	ld [$CCD3],a
	dec a
	ld [$CD6B],a
	ld [$CD3A],a
	ret

INCBIN "baserom.gbc",$366B,$3739 - $366B

DelayFrames: ; 3739
; wait n frames, where n is the value in c
	call DelayFrame
	dec c
	jr nz,DelayFrames
	ret

INCBIN "baserom.gbc",$3740,$375D - $3740

NamePointers: ; 375D
	dw MonsterNames
	dw MoveNames
	dw UnusedNames
	dw ItemNames
	dw $D273 ; player's OT names list
	dw $D9AC ; enemy's OT names list
	dw TrainerNames

GetName: ; 376B
; arguments:
; [$D0B5] = which name
; [$D0B6] = which list
; [$D0B7] = bank of list
;
; returns pointer to name in de
	ld a,[$d0b5]
	ld [$d11e],a
	cp a,$C4        ;it's TM/HM
	jp nc,GetMachineName
	ld a,[$ffb8]
	push af
	push hl
	push bc
	push de
	ld a,[$d0b6]    ;List3759_entrySelector
	dec a
	jr nz,.otherEntries\@
	;1 = MON_NAMES
	call GetMonName
	ld hl,11
	add hl,de
	ld e,l
	ld d,h
	jr .gotPtr\@
.otherEntries\@ ;$378d
	;2-7 = OTHER ENTRIES
	ld a,[$d0b7]
	ld [$ffb8],a
	ld [$2000],a
	ld a,[$d0b6]    ;VariousNames' entryID
	dec a
	add a
	ld d,0
	ld e,a
	jr nc,.skip\@
	inc d
.skip\@ ;$37a0
	ld hl,NamePointers
	add hl,de
	ld a,[hli]
	ld [$ff96],a
	ld a,[hl]
	ld [$ff95],a
	ld a,[$ff95]
	ld h,a
	ld a,[$ff96]
	ld l,a
	ld a,[$d0b5]
	ld b,a
	ld c,0
.nextName\@
	ld d,h
	ld e,l
.nextChar\@
	ld a,[hli]
	cp a,$50
	jr nz,.nextChar\@
	inc c           ;entry counter
	ld a,b          ;wanted entry
	cp c
	jr nz,.nextName\@
	ld h,d
	ld l,e
	ld de,$cd6d
	ld bc,$0014
	call CopyData
.gotPtr\@       ;$37cd
	ld a,e
	ld [$cf8d],a
	ld a,d
	ld [$cf8e],a
	pop de
	pop bc
	pop hl
	pop af
	ld [$ffb8],a
	ld [$2000],a
	ret

INCBIN "baserom.gbc",$37df,$3927 - $37df

AddPokemonToParty: ; 0x3927
    push hl
    push de
    push bc
    ld b, $3 ; BANK(MyFunction)
    ld hl, $72e5 ; MyFunction
    call Bankswitch
    pop bc
    pop de
    pop hl
    ret

INCBIN "baserom.gbc",$3936,$3A87 - $3936

AddNTimes: ; 3A87
; add bc to hl a times
	and a
	ret z
.loop\@
	add hl,bc
	dec a
	jr nz,.loop\@
	ret

INCBIN "baserom.gbc",$3A8E,$3C49 - $3A8E

PrintText: ; 3C49
; given a pointer in hl, print the text there
	push hl
	ld a,1
	ld [$D125],a
	call $30E8
	call $2429
	call Delay3
	pop hl
	ld bc,$C4B9
	jp $1B40

Func3C5F: ; 3C5F
	push bc
	xor a
	ld [$FF95],a
	ld [$FF96],a
	ld [$FF97],a
	ld a,b
	and $F
	cp 1
	jr z,.next\@
	cp 2
	jr z,.next2\@
	ld a,[de]
	ld [$FF96],a
	inc de
	ld a,[de]
	ld [$FF97],a
	inc de
	ld a,[de]
	ld [$FF98],a
	jr .next3\@

.next2\@
	ld a,[de]
	ld [$FF97],a
	inc de
	ld a,[de]
	ld [$FF98],a
	jr .next3\@

.next\@
	ld a,[de]
	ld [$FF98],a

.next3\@
	push de
	ld d,b
	ld a,c
	ld b,a
	xor a
	ld c,a
	ld a,b
	cp 2
	jr z,.next4\@
	cp 3
	jr z,.next5\@
	cp 4
	jr z,.next6\@
	cp 5
	jr z,.next7\@
	cp 6
	jr z,.next8\@
	ld a,$F
	ld [$FF99],a
	ld a,$42
	ld [$FF9A],a
	ld a,$40
	ld [$FF9B],a
	call $3D25
	call $3D89
.next8\@
	ld a,1
	ld [$FF99],a
	ld a,$86
	ld [$FF9A],a
	ld a,$A0
	ld [$FF9B],a
	call $3D25
	call $3D89
.next7\@
	xor a
	ld [$FF99],a
	ld a,$27
	ld [$FF9A],a
	ld a,$10
	ld [$FF9B],a
	call $3D25
	call $3D89
.next6\@
	xor a
	ld [$FF99],a
	ld a,3
	ld [$FF9A],a
	ld a,$E8
	ld [$FF9B],a
	call $3D25
	call $3D89
.next5\@
	xor a
	ld [$FF99],a
	xor a
	ld [$FF9A],a
	ld a,$64
	ld [$FF9B],a
	call $3D25
	call $3D89
.next4\@
	ld c,0
	ld a,[$FF98]
.next10\@
	cp $A
	jr c,.next9\@
	sub $A
	inc c
	jr .next10\@
.next9\@
	ld b,a
	ld a,[$FF95]
	or c
	ld [$FF95],a
	jr nz,.next11\@
	call $3D83
	jr .next12\@
.next11\@
	ld a,$F6
	add a,c
	ld [hl],a
.next12\@
	call $3D89
	ld a,$F6
	add a,b
	ld [hli],a
	pop de
	dec de
	pop bc
	ret

INCBIN "baserom.gbc",$3D25,$3DAB - $3D25

IsInArray: ; 3DAB
; searches an array at hl for the value in a.
; skips (de − 1) bytes between reads, so to check every byte, de should be 1.
; if found, returns count in b and sets carry.
	ld b,0
	ld c,a
.loop\@
	ld a,[hl]
	cp a,$FF
	jr z,.NotInArray\@
	cp c
	jr z,.InArray\@
	inc b
	add hl,de
	jr .loop\@
.NotInArray\@
	and a
	ret
.InArray\@
	scf
	ret

INCBIN "baserom.gbc",$3DBE,$3DD7 - $3DBE

Delay3: ; 3DD7
; call Delay with a parameter of 3
	ld c,3
	jp DelayFrames

INCBIN "baserom.gbc",$3DDC,$3DED - $3DDC
GoPAL_SET_CF1C:	; 3ded
	ld b,$ff
GoPAL_SET: 	; 3def
	ld a,[$cf1b]
	and a
	ret z
	ld a,$45
	jp Predef

INCBIN "baserom.gbc",$3df9,$3e2e - $3df9

GiveItem: ; 0x3e2e
    ld a, b
    ld [$d11e], a
    ld [$cf91], a
    ld a, c
    ld [$cf96], a
    ld hl, $d31d
    call $2bcf
    ret nc
    call $2fcf
    call $3826
    scf
    ret

GivePokemon: ; 0x3e48
    ld a, b
    ld [$cf91], a
    ld a, c
    ld [$d127], a
    xor a
    ld [$cc49], a
    ld b, $13
    ld hl, $7da5
    jp Bankswitch

GenRandom: ; 3E5C
; store a random 8-bit value in a
	push hl
	push de
	push bc
	ld b,BANK(GenRandom_)
	ld hl,GenRandom_
	call Bankswitch
	ld a,[H_RAND1]
	pop bc
	pop de
	pop hl
	ret

Predef: ; 3E6D
; runs a predefined ASM command, where the command ID is read from $D0B7
; $3E6D grabs the ath pointer from PredefPointers and executes it

	ld [$CC4E],a ; save the predef routine's ID for later

	ld a,[$FFB8]
	ld [$CF12],a

	; save bank and call 13:7E49
	push af
	ld a,BANK(GetPredefPointer)
	ld [$FFB8],a
	ld [$2000],a
	call GetPredefPointer

	; call the predef function
	; ($D0B7 has the bank of the predef routine)
	ld a,[$D0B7]
	ld [$FFB8],a
	ld [$2000],a
	ld de,.Return\@
	push de
	jp [hl]
	; after the predefined function finishes it returns here
.Return\@
	pop af
	ld [$FFB8],a
	ld [$2000],a
	ret

INCBIN "baserom.gbc",$3E94,$4000 - $3E94

SECTION "bank1",DATA,BANK[$1]

INCBIN "baserom.gbc",$4000,$112

MewPicFront:
	INCBIN "pic/bmon/mew.pic"
MewPicBack:
	INCBIN "pic/monback/mewb.pic"

INCBIN "baserom.gbc",$425B,$4588-$425B

TitleMons: ; 4588
; mons on the title screen are randomly chosen from here
IF RED
	db CHARMANDER
	db SQUIRTLE
	db BULBASAUR
	db WEEDLE
	db NIDORAN_M
	db SCYTHER
	db PIKACHU
	db CLEFAIRY
	db RHYDON
	db ABRA
	db GASTLY
	db DITTO
	db PIDGEOTTO
	db ONIX
	db PONYTA
	db MAGIKARP
ENDC
IF GREEN
	db BULBASAUR
	db CHARMANDER
	db SQUIRTLE
	db CATERPIE
	db NIDORAN_F
	db PINSIR
	db PIKACHU
	db CLEFAIRY
	db RHYDON
	db ABRA
	db GASTLY
	db DITTO
	db PIDGEOTTO
	db ONIX
	db PONYTA
	db MAGIKARP
ENDC
IF BLUE
	db SQUIRTLE
	db CHARMANDER
	db BULBASAUR
	db MANKEY
	db HITMONLEE
	db VULPIX
	db CHANSEY
	db AERODACTYL
	db JOLTEON
	db SNORLAX
	db GLOOM
	db POLIWAG
	db DODUO
	db PORYGON
	db GENGAR
	db RAICHU
ENDC

INCBIN "baserom.gbc",$4598,$472B-$4598

ItemNames: ; 472B
	db "MASTER BALL@"
	db "ULTRA BALL@"
	db "GREAT BALL@"
	db "POKé BALL@"
	db "TOWN MAP@"
	db "BICYCLE@"
	db "?????@"
	db "SAFARI BALL@"
	db "POKéDEX@"
	db "MOON STONE@"
	db "ANTIDOTE@"
	db "BURN HEAL@"
	db "ICE HEAL@"
	db "AWAKENING@"
	db "PARLYZ HEAL@"
	db "FULL RESTORE@"
	db "MAX POTION@"
	db "HYPER POTION@"
	db "SUPER POTION@"
	db "POTION@"
	db "BOULDERBADGE@"
	db "CASCADEBADGE@"
	db "THUNDERBADGE@"
	db "RAINBOWBADGE@"
	db "SOULBADGE@"
	db "MARSHBADGE@"
	db "VOLCANOBADGE@"
	db "EARTHBADGE@"
	db "ESCAPE ROPE@"
	db "REPEL@"
	db "OLD AMBER@"
	db "FIRE STONE@"
	db "THUNDERSTONE@"
	db "WATER STONE@"
	db "HP UP@"
	db "PROTEIN@"
	db "IRON@"
	db "CARBOS@"
	db "CALCIUM@"
	db "RARE CANDY@"
	db "DOME FOSSIL@"
	db "HELIX FOSSIL@"
	db "SECRET KEY@"
	db "?????@"
	db "BIKE VOUCHER@"
	db "X ACCURACY@"
	db "LEAF STONE@"
	db "CARD KEY@"
	db "NUGGET@"
	db "PP UP@"
	db "POKé DOLL@"
	db "FULL HEAL@"
	db "REVIVE@"
	db "MAX REVIVE@"
	db "GUARD SPEC.@"
	db "SUPER REPEL@"
	db "MAX REPEL@"
	db "DIRE HIT@"
	db "COIN@"
	db "FRESH WATER@"
	db "SODA POP@"
	db "LEMONADE@"
	db "S.S.TICKET@"
	db "GOLD TEETH@"
	db "X ATTACK@"
	db "X DEFEND@"
	db "X SPEED@"
	db "X SPECIAL@"
	db "COIN CASE@"
	db "OAK's PARCEL@"
	db "ITEMFINDER@"
	db "SILPH SCOPE@"
	db "POKé FLUTE@"
	db "LIFT KEY@"
	db "EXP.ALL@"
	db "OLD ROD@"
	db "GOOD ROD@"
	db "SUPER ROD@"
	db "PP UP@"
	db "ETHER@"
	db "MAX ETHER@"
	db "ELIXER@"
	db "MAX ELIXER@"
	db "B2F@"
	db "B1F@"
	db "1F@"
	db "2F@"
	db "3F@"
	db "4F@"
	db "5F@"
	db "6F@"
	db "7F@"
	db "8F@"
	db "9F@"
	db "10F@"
	db "11F@"
	db "B4F@"

UnusedNames: ; 4A92
	db "かみなりバッヂ@"
	db "かいがらバッヂ@"
	db "おじぞうバッヂ@"
	db "はやぶさバッヂ@"
	db "ひんやりバッヂ@"
	db "なかよしバッヂ@"
	db "バラバッヂ@"
	db "ひのたまバッヂ@"
	db "ゴールドバッヂ@"
	db "たまご@"
	db "ひよこ@"
	db "ブロンズ@"
	db "シルバー@"
	db "ゴールド@"
	db "プチキャプテン@"
	db "キャプテン@"
	db "プチマスター@"
	db "マスター@"

INCBIN "baserom.gbc",$4B09,$5AF2-$4B09

MainMenu:
; Check save file
	call Func_5bff
	xor a
	ld [$D08A],a
	inc a
	ld [$D088],a
	call $609E
	jr nc,.next0\@

	; Predef 52 loads the save from SRAM to RAM
	ld a,$52
	call Predef

.next0\@
	ld c,20
	call DelayFrames
	xor a
	ld [$D12B],a
	ld hl,$CC2B
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hl],a
	ld [$D07C],a
	ld hl,$D72E
	res 6,[hl]
	call ClearScreen
	call $3DED
	call $36A0 ; load some graphics in VRAM
	call $3680 ; load fonts in VRAM
	ld hl,$D730
	set 6,[hl]
	ld a,[$D088]
	cp a,1
	jr z,.next1\@
	FuncCoord 0,0
	ld hl,Coord
	ld b,6
	ld c,13
	call TextBoxBorder
	FuncCoord 2,2
	ld hl,Coord
	ld de,$5D7E
	call PlaceString
	jr .next2\@
.next1\@
	FuncCoord 0,0
	ld hl,Coord
	ld b,4
	ld c,13
	call TextBoxBorder
	FuncCoord 2,2
	ld hl,Coord
	ld de,$5D87
	call PlaceString
.next2\@
	ld hl,$D730
	res 6,[hl]
	call $2429 ; OAM?
	xor a
	ld [$CC26],a
	ld [$CC2A],a
	ld [$CC34],a
	inc a
	ld [$CC25],a
	inc a
	ld [$CC24],a
	ld a,$B
	ld [$CC29],a
	ld a,[$D088]
	ld [$CC28],a
	call $3ABE
	bit 1,a
	jp nz,$42DD ; load title screen (gfx and arrangement)
	ld c,20
	call DelayFrames
	ld a,[$CC26]
	ld b,a
	ld a,[$D088]
	cp a,2
	jp z,.next3\@
	inc b ; adjust MenuArrow_Counter
.next3\@
	ld a,b
	and a
	jr z,.next4\@ ; if press_A on Continue
	cp a,1
	jp z,$5D52 ; if press_A on NewGame
	call $5E8A ; if press_a on Options
	ld a,1
	ld [$D08A],a
	jp .next0\@
.next4\@
	call $5DB5
	ld hl,$D126
	set 5,[hl]
.next6\@
	xor a
	ld [$FFB3],a
	ld [$FFB2],a
	ld [$FFB4],a
	call $19A
	ld a,[$FFB4]
	bit 0,a
	jr nz,.next5\@
	bit 1,a
	jp nz,.next0\@
	jr .next6\@
.next5\@
	call $3DD4
	call ClearScreen
	ld a,4
	ld [$D52A],a
	ld c,10
	call DelayFrames
	ld a,[$D5A2]
	and a
	jp z,$5D5F
	ld a,[W_CURMAP] ; map ID
	cp a,$76 ; Hall of Fame
	jp nz,$5D5F
	xor a
	ld [$D71A],a
	ld hl,$D732
	set 2,[hl]
	call $62CE
	jp $5D5F
Func_5bff:
	ld a,1
	ld [$D358],a
	ld a,3
	ld [$D355],a
	ret

INCBIN "baserom.gbc",$5C0A,$6115 - $5C0A

OakSpeech: ; 6115
	ld a,$FF
	call $23B1 ; stop music
	ld a,2     ; bank of song
	ld c,a
	ld a,$EF    ; song #
	call $23A1  ; plays music
	call ClearScreen
	call $36A0
	call $60CA
	ld a,$18
	call Predef
	ld hl,$D53A
	ld a,$14
	ld [$CF91],a
	ld a,1
	ld [$CF96],a
	call $2BCF
	ld a,[$D07C]
	ld [$D71A],a
	call Function62CE
	xor a
	ld [$FFD7],a
	ld a,[$D732]
	bit 1,a ; XXX when is bit 1 set?
	jp nz,Function61BC ; easter egg: skip the intro
	ld de,$615F
	ld bc,$1300
	call IntroPredef3B   ; displays Oak pic?
	call FadeInIntroPic
	ld hl,OakSpeechText1
	call PrintText      ; prints text box
	call GBFadeOut2
	call ClearScreen
	ld a,NIDORINO
	ld [$D0B5],a    ; pic displayed is stored at this location
	ld [$CF91],a
	call $1537      ; this is also related to the pic
	ld hl,$C3F6     ; position on tilemap the pic is displayed
	call $1384      ; displays pic?
	call MovePicLeft
	ld hl,OakSpeechText2
	call PrintText      ; Prints text box
	call GBFadeOut2
	call ClearScreen
	ld de,$6EDE
	ld bc,$0400     ; affects the position of the player pic
	call IntroPredef3B      ; displays player pic?
	call MovePicLeft
	ld hl,IntroducePlayerText
	call PrintText
	call $695D ; brings up NewName/Red/etc menu
	call GBFadeOut2
	call ClearScreen
	ld de,$6049
	ld bc,$1300
	call IntroPredef3B ; displays rival pic
	call FadeInIntroPic
	ld hl,IntroduceRivalText
	call PrintText
	call $69A4
Function61BC:
	call GBFadeOut2
	call ClearScreen
	ld de,$6EDE
	ld bc,$0400
	call IntroPredef3B
	call GBFadeIn2
	ld a,[$D72D]
	and a
	jr nz,.next\@
	ld hl,OakSpeechText3
	call PrintText
.next\@	ld a,[$FFB8]
	push af
	ld a,$9C
	call $23B1
	pop af
	ld [$FFB8],a
	ld [$2000],a
	ld c,4
	call DelayFrames
	ld de,$4180
	ld hl,$8000
	ld bc,$050C
	call $1848
	ld de,$6FE8
	ld bc,$0400
	call IntroPredef3B
	ld c,4
	call DelayFrames
	ld de,$7042
	ld bc,$0400
	call IntroPredef3B
	call $28A6
	ld a,[$FFB8]
	push af
	ld a,2
	ld [$C0EF],a
	ld [$C0F0],a
	ld a,$A
	ld [$CFC7],a
	ld a,$FF
	ld [$C0EE],a
	call $23B1 ; stop music
	pop af
	ld [$FFB8],a
	ld [$2000],a
	ld c,$14
	call DelayFrames
	ld hl,$C40A
	ld b,7
	ld c,7
	call $18C4
	call $36A0
	ld a,1
	ld [$CFCB],a
	ld c,$32
	call DelayFrames
	call GBFadeOut2
	jp ClearScreen
OakSpeechText1:
	TX_FAR _OakSpeechText1
	db "@"
OakSpeechText2:
	TX_FAR _OakSpeechText2A
	db $14
	TX_FAR _OakSpeechText2B
	db "@"
IntroducePlayerText:
	TX_FAR _IntroducePlayerText
	db "@"
IntroduceRivalText:
	TX_FAR _IntroduceRivalText
	db "@"
OakSpeechText3:
	TX_FAR _OakSpeechText3
	db "@"

FadeInIntroPic:
	ld hl,IntroFadePalettes
	ld b,6
.next\@
	ld a,[hli]
	ld [rBGP],a
	ld c,10
	call DelayFrames
	dec b
	jr nz,.next\@
	ret

IntroFadePalettes:
	db %01010100
	db %10101000
	db %11111100
	db %11111000
	db %11110100
	db %11100100

MovePicLeft:
	ld a,119
	ld [$FF4B],a
	call DelayFrame

	ld a,$E4
	ld [rBGP],a
.next\@
	call DelayFrame
	ld a,[$FF4B]
	sub 8
	cp $FF
	ret z
	ld [$FF4B],a
	jr .next\@

Predef3B: ; 62A1
	call $3E94
IntroPredef3B: ; 62A4
	push bc
	ld a,b
	call $36EB
	ld hl,$A188
	ld de,$A000
	ld bc,$0310
	call CopyData
	ld de,$9000
	call $16EA
	pop bc
	ld a,c
	and a
	ld hl,$C3C3
	jr nz,.next\@
	ld hl,$C3F6
.next\@
	xor a
	ld [$FFE1],a
	ld a,1
	jp $3E6D

Function62CE: ; 62CE, XXX called by 4B2 948 989 5BF9 5D15
	call $62FF
	ld a,$19
	call $3E6D
	ld hl,$D732
	bit 2,[hl]
	res 2,[hl]
	jr z,.next\@
	ld a,[$D71A]
	jr .next2\@
.next\@
	bit 1,[hl]
	jr z,.next3\@
	call $64EA
.next3\@
	ld a,0
.next2\@
	ld b,a
	ld a,[$D72D]
	and a
	jr nz,.next4\@
	ld a,b
.next4\@
	ld hl,$D732
	bit 4,[hl]
	ret nz
	ld [$D365],a
	ret

INCBIN "baserom.gbc",$62FF,$6420-$62FF

FirstMapSpec:
	db $26 ; RedHouse1F
; Original Format:
;   [Event Displacement][Y-block][X-block][Y-sub_block][X-sub_block]
; Macro Format:
;   FLYWARP_DATA [Map Width][Y-pos][X-pos]
	FLYWARP_DATA 4,6,3
	db $04		;Tileset_id

INCBIN "baserom.gbc",$6428,$6448-$6428
FlyWarpDataPtr:
	db $00,0
        dw Map00FlyWarp
	db $01,0
        dw Map01FlyWarp
	db $02,0
        dw Map02FlyWarp
	db $03,0
        dw Map03FlyWarp
	db $04,0
        dw Map04FlyWarp
	db $05,0
        dw Map05FlyWarp
	db $06,0
        dw Map06FlyWarp
	db $07,0
        dw Map07FlyWarp
	db $08,0
        dw Map08FlyWarp
	db $09,0
        dw Map09FlyWarp
	db $0A,0
        dw Map0aFlyWarp
	db $0F,0
        dw Map0fFlyWarp
	db $15,0
        dw Map15FlyWarp	

; Original Format:
;   [Event Displacement][Y-block][X-block][Y-sub_block][X-sub_block]
; Macro Format:
;   FLYWARP_DATA [Map Width][Y-pos][X-pos]
Map00FlyWarp:
	FLYWARP_DATA 10,6,5
Map01FlyWarp:
	FLYWARP_DATA 20,26,23
Map02FlyWarp:
	FLYWARP_DATA 20,26,13
Map03FlyWarp:
	FLYWARP_DATA 20,18,19
Map04FlyWarp:
	FLYWARP_DATA 10,6,3
Map05FlyWarp:
	FLYWARP_DATA 20,4,11
Map06FlyWarp:
	FLYWARP_DATA 25,10,41
Map07FlyWarp:
	FLYWARP_DATA 20,28,19
Map08FlyWarp:
	FLYWARP_DATA 10,12,11
Map09FlyWarp:
	FLYWARP_DATA 10,6,9
Map0aFlyWarp:
	FLYWARP_DATA 20,30,9
Map0fFlyWarp:
	FLYWARP_DATA 45,6,11
Map15FlyWarp:
	FLYWARP_DATA 10,20,11

INCBIN "baserom.gbc",$64CA,$778D - $64CA

FieldMoveNames: ; 778D
	db "CUT@"
	db "FLY@"
	db "@"
	db "SURF@"
	db "STRENGTH@"
	db "FLASH@"
	db "DIG@"
	db "TELEPORT@"
	db "SOFTBOILED@"

PokemonMenuEntries: ; 77C2
	db "STATS",$4E
	db "SWITCH",$4E
	db "CANCEL@"

INCBIN "baserom.gbc",$77D6,$7AF5 - $77D6

PlayersPCMenuEntries: ; 7AF5
	db "WITHDRAW ITEM",$4E
	db "DEPOSIT ITEM",$4E
	db "TOSS ITEM",$4E
	db "LOG OFF@"

INCBIN "baserom.gbc",$7B22,$7C49 - $7B22

SECTION "bank2",DATA,BANK[$2]
INCBIN "baserom.gbc",$8000,$4000

SECTION "bank3",DATA,BANK[$3]
INCBIN "baserom.gbc",$C000,$C23D - $C000

; see also MapHeaderPointers
MapHeaderBanks: ; 423D
	db BANK(PalletTown_h)
	db BANK(ViridianCity_h) ; VIRIDIAN_CITY
	db BANK(PewterCity_h) ; PEWTER_CITY
	db BANK(CeruleanCity_h) ; CERULEAN_CITY
	db BANK(LavenderTown_h) ; LAVENDER_TOWN
	db BANK(VermilionCity_h) ; VERMILION_CITY
	db BANK(CeladonCity_h) ; CELADON_CITY
	db BANK(FuchsiaCity_h) ; FUCHSIA_CITY
	db BANK(CinnabarIsland_h) ; CINNABAR_ISLAND
	db BANK(IndigoPlateau_h) ; INDIGO_PLATEAU
	db BANK(SaffronCity_h) ; SAFFRON_CITY
	db $01 ; unused
	db BANK(Route1_h) ; ROUTE_1
	db $15 ; ROUTE_2
	db BANK(Route3_h) ; ROUTE_3
	db BANK(Route4_h) ; ROUTE_4
	db BANK(Route5_h) ; ROUTE_5
	db BANK(Route6_h) ; ROUTE_6
	db BANK(Route7_h) ; ROUTE_7
    db BANK(Route8_h) ; ROUTE_8
    db BANK(Route9_h) ; ROUTE_9
    db BANK(Route10_h) ; ROUTE_10
    db BANK(Route11_h) ; ROUTE_11
    db BANK(Route12_h) ; ROUTE_12
    db BANK(Route13_h) ; ROUTE_13
    db BANK(Route14_h) ; ROUTE_14
    db BANK(Route15_h) ; ROUTE_15
    db BANK(Route16_h) ; ROUTE_16
    db BANK(Route17_h) ; ROUTE_17
    db BANK(Route18_h) ; ROUTE_18
    db BANK(Route19_h) ; ROUTE_19
    db BANK(Route20_h) ; ROUTE_20
    db BANK(Route21_h) ; ROUTE_21
    db BANK(Route22_h) ; ROUTE_22
    db BANK(Route23_h) ; ROUTE_23
    db BANK(Route24_h) ; ROUTE_24
    db BANK(Route25_h) ; ROUTE_25
	db BANK(RedsHouse1F_h)
	db BANK(RedsHouse2F_h)
	db BANK(BluesHouse_h)
	db BANK(OaksLab_h)
	db BANK(ViridianPokecenter_h)
	db BANK(ViridianMart_h)
	db BANK(School_h)
	db BANK(ViridianHouse_h)
	db BANK(ViridianGym_h)
	db BANK(DiglettsCaveRoute2_h)
	db BANK(ViridianForestexit_h)
	db BANK(Route2House_h)
	db BANK(Route2Gate_h)
	db BANK(ViridianForestEntrance_h)
	db BANK(ViridianForest_h)
	db BANK(MuseumF1_h)
	db BANK(MuseumF2_h)
	db BANK(PewterGym_h)
	db BANK(PewterHouse1_h)
	db BANK(PewterMart_h)
	db BANK(PewterHouse2_h)
	db BANK(PewterPokecenter_h)
	db BANK(MtMoon1_h)
	db BANK(MtMoon2_h)
	db BANK(MtMoon3_h)
	db BANK(CeruleanHouseTrashed_h)
	db BANK(CeruleanHouse2_h)
	db BANK(CeruleanPokecenter_h)
	db BANK(CeruleanGym_h)
	db BANK(BikeShop_h)
	db BANK(CeruleanMart_h)
	db BANK(MtMoonPokecenter_h)
	db BANK(CeruleanHouseTrashed_h)
	db BANK(Route5Gate_h)
	db BANK(UndergroundTunnelEntranceRoute5_h)
	db BANK(DayCareM_h)
	db BANK(Route6Gate_h)
	db BANK(UndergroundTunnelEntranceRoute6_h)
	db $17
	db BANK(Route7Gate_h)
	db BANK(UndergroundPathEntranceRoute7_h)
	db $17
	db BANK(Route8Gate_h)
	db BANK(UndergroundPathEntranceRoute8_h)
	db BANK(RockTunnelPokecenter_h)
	db BANK(RockTunnel1_h)
	db BANK(PowerPlant_h)
	db BANK(Route11Gate_h)
	db BANK(DiglettsCaveEntranceRoute11_h)
	db BANK(Route11GateUpstairs_h)
	db BANK(Route12Gate_h)
	db BANK(BillsHouse_h)
	db BANK(VermilionPokecenter_h)
	db BANK(FanClub_h)
	db BANK(VermilionMart_h)
	db BANK(VermilionGym_h)
	db BANK(VermilionHouse1_h)
	db BANK(VermilionDock_h)
	db BANK(SSAnne1_h)
	db BANK(SSAnne2_h)
	db BANK(SSAnne3_h)
	db BANK(SSAnne4_h)
	db BANK(SSAnne5_h)
	db BANK(SSAnne6_h)
	db BANK(SSAnne7_h)
	db BANK(SSAnne8_h)
	db BANK(SSAnne9_h)
	db BANK(SSAnne10_h)
	db $1D
	db $1D
	db $1D
	db BANK(VictoryRoad1_h)
	db $1D
	db $1D
	db $1D
	db $1D
	db BANK(Lance_h)
	db $1D
	db $1D
	db $1D
	db $1D
	db $16
	db BANK(UndergroundPathNS_h)
	db $1D
	db BANK(UndergroundPathWE_h)
	db BANK(CeladonMart1_h)
	db BANK(CeladonMart2_h)
	db BANK(CeladonMart3_h)
	db BANK(CeladonMart4_h)
	db BANK(CeladonMartRoof_h)
	db BANK(CeladonMartElevator_h)
	db BANK(CeladonMansion1_h)
	db BANK(CeladonMansion2_h)
	db BANK(CeladonMansion3_h)
	db BANK(CeladonMansion4_h)
	db BANK(CeladonMansion5_h)
	db BANK(CeladonPokecenter_h)
	db BANK(CeladonGym_h)
	db BANK(CeladonGameCorner_h)
	db BANK(CeladonMart5_h)
	db BANK(CeladonPrizeRoom_h)
	db BANK(CeladonDiner_h)
	db BANK(CeladonHouse2_h)
	db BANK(CeladonHotel_h)
	db BANK(LavenderPokecenter_h)
	db BANK(PokemonTower1_h)
	db BANK(PokemonTower2_h)
	db BANK(PokemonTower3_h)
	db BANK(PokemonTower4_h)
	db BANK(PokemonTower5_h)
	db BANK(PokemonTower6_h)
	db BANK(PokemonTower7_h)
	db BANK(LavenderHouse1_h)
	db BANK(LavenderMart_h)
	db BANK(LavenderHouse2_h)
	db BANK(FuchsiaMart_h)
	db BANK(FuchsiaHouse1_h)
	db BANK(FuchsiaPokecenter_h)
	db BANK(FuchsiaHouse2_h)
	db BANK(SafariZoneEntrance_h)
	db BANK(FuchsiaGym_h)
	db BANK(FuchsiaMeetingRoom_h)
	db BANK(SeafoamIslands2_h)
	db BANK(SeafoamIslands3_h)
	db BANK(SeafoamIslands4_h)
	db BANK(SeafoamIslands5_h)
	db BANK(VermilionHouse2_h)
	db BANK(FuchsiaHouse3_h)
	db BANK(Mansion1_h)
	db BANK(CinnabarGym_h)
	db BANK(Lab1_h)
	db BANK(Lab2_h)
	db BANK(Lab3_h)
	db BANK(Lab4_h)
	db BANK(CinnabarPokecenter_h)
	db BANK(CinnabarMart_h)
	db $1D
	db BANK(IndigoPlateauLobby_h)
	db BANK(CopycatsHouseF1_h)
	db BANK(CopycatsHouseF2_h)
	db BANK(FightingDojo_h)
	db BANK(SaffronGym_h)
	db BANK(SaffronHouse1_h)
	db BANK(SaffronMart_h)
	db BANK(SilphCo1_h)
	db BANK(SaffronPokecenter_h)
	db BANK(SaffronHouse2_h)
	db BANK(Route15Gate_h)
	db $12
	db BANK(Route16GateMap_h)
	db BANK(Route16GateUpstairs_h)
	db BANK(Route16House_h)
	db BANK(Route12House_h)
	db BANK(Route18Gate_h)
	db BANK(Route18GateHeader_h)
	db BANK(SeafoamIslands1_h)
	db BANK(Route22Gate_h)
	db BANK(VictoryRoad2_h)
	db BANK(Route12GateUpstairs_h)
	db BANK(VermilionHouse3_h)
	db BANK(DiglettsCave_h)
	db BANK(VictoryRoad3_h)
	db BANK(RocketHideout1_h)
	db BANK(RocketHideout2_h)
	db BANK(RocketHideout3_h)
	db BANK(RocketHideout4_h)
	db BANK(RocketHideoutElevator_h)
	db $01
	db $01
	db $01
	db BANK(SilphCo2_h)
	db BANK(SilphCo3_h)
	db BANK(SilphCo4_h)
	db BANK(SilphCo5_h)
	db BANK(SilphCo6_h)
	db BANK(SilphCo7_h)
	db BANK(SilphCo8_h)
	db BANK(Mansion2_h)
	db BANK(Mansion3_h)
	db BANK(Mansion4_h)
	db BANK(SafariZoneEast_h)
	db BANK(SafariZoneNorth_h)
	db BANK(SafariZoneWest_h)
	db BANK(SafariZoneCenter_h)
	db BANK(SafariZoneRestHouse1_h)
	db BANK(SafariZoneSecretHouse_h)
	db BANK(SafariZoneRestHouse2_h)
	db BANK(SafariZoneRestHouse3_h)
	db BANK(SafariZoneRestHouse4_h)
	db BANK(UnknownDungeon2_h)
	db BANK(UnknownDungeon3_h)
	db BANK(UnknownDungeon1_h)
	db BANK(NameRater_h)
	db BANK(CeruleanHouse3_h)
	db $01
	db BANK(RockTunnel2_h)
	db BANK(SilphCo9_h)
	db BANK(SilphCo10_h)
	db BANK(SilphCo11_h)
	db BANK(SilphCoElevator_h)
	db $11
	db $11
	db BANK(BattleCenterM_h)
	db BANK(TradeCenterM_h)
	db $11
	db $11
	db $11
	db $11
	db BANK(Loreli_h)
	db BANK(Bruno_h)
	db BANK(Agatha_h)

INCBIN "baserom.gbc",$C335,$C766-$C335
	ld hl,TilesetsHeadPtr
INCBIN "baserom.gbc",$C769,$C7BE-$C769
TilesetsHeadPtr:
	TSETHEAD Tset00_Block,Tset00_GFX,Tset00_Coll,$FF,$FF,$FF,$52,2
	TSETHEAD Tset01_Block,Tset01_GFX,Tset01_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset02_Block,Tset02_GFX,Tset02_Coll,$18,$19,$1E,$FF,0
	TSETHEAD Tset03_Block,Tset03_GFX,Tset03_Coll,$FF,$FF,$FF,$20,1
	TSETHEAD Tset01_Block,Tset01_GFX,Tset01_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset05_Block,Tset05_GFX,Tset05_Coll,$3A,$FF,$FF,$FF,2
	TSETHEAD Tset02_Block,Tset02_GFX,Tset02_Coll,$18,$19,$1E,$FF,0
	TSETHEAD Tset05_Block,Tset05_GFX,Tset05_Coll,$3A,$FF,$FF,$FF,2
	TSETHEAD Tset08_Block,Tset08_GFX,Tset08_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset09_Block,Tset09_GFX,Tset09_Coll,$17,$32,$FF,$FF,0
	TSETHEAD Tset09_Block,Tset09_GFX,Tset09_Coll,$17,$32,$FF,$FF,0
	TSETHEAD Tset0B_Block,Tset0B_GFX,Tset0B_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset09_Block,Tset09_GFX,Tset09_Coll,$17,$32,$FF,$FF,0
	TSETHEAD Tset0D_Block,Tset0D_GFX,Tset0D_Coll,$FF,$FF,$FF,$FF,1
	TSETHEAD Tset0E_Block,Tset0E_GFX,Tset0E_Coll,$FF,$FF,$FF,$FF,1
	TSETHEAD Tset0F_Block,Tset0F_GFX,Tset0F_Coll,$12,$FF,$FF,$FF,0
	TSETHEAD Tset10_Block,Tset10_GFX,Tset10_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset11_Block,Tset11_GFX,Tset11_Coll,$FF,$FF,$FF,$FF,1
	TSETHEAD Tset12_Block,Tset12_GFX,Tset12_Coll,$15,$36,$FF,$FF,0
	TSETHEAD Tset13_Block,Tset13_GFX,Tset13_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset14_Block,Tset14_GFX,Tset14_Coll,$FF,$FF,$FF,$FF,0
	TSETHEAD Tset15_Block,Tset15_GFX,Tset15_Coll,$07,$17,$FF,$FF,0
	TSETHEAD Tset16_Block,Tset16_GFX,Tset16_Coll,$12,$FF,$FF,$FF,1
	TSETHEAD Tset17_Block,Tset17_GFX,Tset17_Coll,$FF,$FF,$FF,$45,1

INCBIN "baserom.gbc",$C8DE,$C8F5-$C8DE

; data for default hidden/shown
; objects for each map ($00-$F8)

; Table of 2-Byte pointers, one pointer per map,
; goes up to Map_F7, ends with $FFFF.
MapHSPointers: ; 48F5
	dw MapHS00
	dw MapHS01
	dw MapHS02
	dw MapHS03
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS0A
	dw MapHSXX
	dw MapHSXX
	dw MapHS0D
	dw MapHSXX
	dw MapHS0F
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS14
	dw MapHSXX
	dw MapHSXX
	dw MapHS17
	dw MapHSXX
	dw MapHSXX
	dw MapHS1A
	dw MapHS1B
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS21
	dw MapHSXX
	dw MapHS23
	dw MapHS24
	dw MapHSXX
	dw MapHSXX
	dw MapHS27
	dw MapHS28
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS2D
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS33
	dw MapHS34
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS3B
	dw MapHSXX
	dw MapHS3D
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS53
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS58
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS60
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS66
	dw MapHS67
	dw MapHS68
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS6C
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS78
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS84
	dw MapHSXX
	dw MapHSXX
	dw MapHS87
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS8F
	dw MapHS90
	dw MapHS91
	dw MapHS92
	dw MapHS93
	dw MapHS94
	dw MapHS95
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS9B
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHS9F
	dw MapHSA0
	dw MapHSA1
	dw MapHSA2
	dw MapHSXX
	dw MapHSXX
	dw MapHSA5
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSB1
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSB5
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSC0
	dw MapHSXX
	dw MapHSC2
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSC6
	dw MapHSC7
	dw MapHSC8
	dw MapHSC9
	dw MapHSCA
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSCF
	dw MapHSD0
	dw MapHSD1
	dw MapHSD2
	dw MapHSD3
	dw MapHSD4
	dw MapHSD5
	dw MapHSD6
	dw MapHSD7
	dw MapHSD8
	dw MapHSD9
	dw MapHSDA
	dw MapHSDB
	dw MapHSDC
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSE2
	dw MapHSE3
	dw MapHSE4
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSE9
	dw MapHSEA
	dw MapHSEB
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw MapHSF4
	dw MapHSXX
	dw MapHSXX
	dw MapHSXX
	dw $FFFF

; Structure:
; 3 bytes per object
; [Map_ID][Object_ID][H/S]
;
; Program stops reading when either:
; a) Map_ID = $FF
; b) Map_ID ≠ currentMapID
;
; This Data is loaded into RAM at $D5CE-$D5F?.

; These constants come from the bytes for Predef functions:
Hide	equ $11
Show	equ $15

MapHSXX:
	db $FF,$FF,$FF
MapHS00:
	db $00,$01,Hide
MapHS01:
	db $01,$05,Show
	db $01,$07,Hide
MapHS02:
	db $02,$03,Show
	db $02,$05,Show
MapHS03:
	db $03,$01,Hide
	db $03,$02,Show
	db $03,$06,Hide
	db $03,$0A,Show
	db $03,$0B,Show
MapHS0A:
	db $0A,$01,Show
	db $0A,$02,Show
	db $0A,$03,Show
	db $0A,$04,Show
	db $0A,$05,Show
	db $0A,$06,Show
	db $0A,$07,Show
	db $0A,$08,Hide
	db $0A,$09,Hide
	db $0A,$0A,Hide
	db $0A,$0B,Hide
	db $0A,$0C,Hide
	db $0A,$0D,Hide
	db $0A,$0E,Show
	db $0A,$0F,Hide
MapHS0D:
	db $0D,$01,Show
	db $0D,$02,Show
MapHS0F:
	db $0F,$03,Show
MapHS14:
	db $14,$0A,Show
MapHS17:
	db $17,$01,Show
	db $17,$09,Show
	db $17,$0A,Show
MapHS1A:
	db $1A,$0B,Show
MapHS1B:
	db $1B,$07,Show
MapHS21:
	db $21,$01,Hide
	db $21,$02,Hide
MapHS23:
	db $23,$01,Show
	db $23,$08,Show
MapHS24:
	db $24,$0A,Show
MapHS27:
	db $27,$01,Show
	db $27,$02,Hide
	db $27,$03,Show
MapHS28:
	db $28,$01,Show
	db $28,$02,Show
	db $28,$03,Show
	db $28,$04,Show
	db $28,$05,Hide
	db $28,$06,Show
	db $28,$07,Show
	db $28,$08,Hide
MapHS2D:
	db $2D,$01,Show
	db $2D,$0B,Show
MapHS34:
	db $34,$05,Show
MapHSE4:
	db $E4,$01,Show
	db $E4,$02,Show
	db $E4,$03,Show
MapHS8F:
	db $8F,$01,Show
MapHS90:
	db $90,$04,Show
MapHS91:
	db $91,$04,Show
	db $91,$05,Show
	db $91,$06,Show
MapHS92:
	db $92,$06,Show
MapHS93:
	db $93,$04,Show
	db $93,$05,Show
MapHS94:
	db $94,$01,Show
	db $94,$02,Show
	db $94,$03,Show
	db $94,$04,Show
MapHS95:
	db $95,$05,Hide
MapHS84:
	db $84,$02,Show
MapHS87:
	db $87,$0B,Show
MapHS9B:
	db $9B,$02,Show
MapHSA5:
	db $A5,$02,Show
	db $A5,$03,Show
MapHSB1:
	db $B1,$06,Show
	db $B1,$07,Show
MapHSB5:
	db $B5,$01,Hide
MapHS53:
	db $53,$01,Show
	db $53,$02,Show
	db $53,$03,Show
	db $53,$04,Show
	db $53,$05,Show
	db $53,$06,Show
	db $53,$07,Show
	db $53,$08,Show
	db $53,$09,Show
	db $53,$0A,Show
	db $53,$0B,Show
	db $53,$0C,Show
	db $53,$0D,Show
	db $53,$0E,Show
MapHSC2:
	db $C2,$06,Show
	db $C2,$07,Show
	db $C2,$08,Show
	db $C2,$09,Show
	db $C2,$0A,Show
	db $C2,$0D,Show
MapHS58:
	db $58,$01,Show
	db $58,$02,Hide
	db $58,$03,Hide
MapHS33:
	db $33,$05,Show
	db $33,$06,Show
	db $33,$07,Show
MapHS3B:
	db $3B,$08,Show
	db $3B,$09,Show
	db $3B,$0A,Show
	db $3B,$0B,Show
	db $3B,$0C,Show
	db $3B,$0D,Show
MapHS3D:
	db $3D,$06,Show
	db $3D,$07,Show
	db $3D,$08,Show
	db $3D,$09,Show
MapHS60:
	db $60,$02,Hide
MapHS66:
	db $66,$0A,Show
MapHS67:
	db $67,$06,Show
	db $67,$09,Show
MapHS68:
	db $68,$09,Show
	db $68,$0A,Show
	db $68,$0B,Show
MapHSC6:
	db $C6,$05,Show
	db $C6,$06,Show
	db $C6,$0A,Show
MapHSC7:
	db $C7,$06,Show
	db $C7,$07,Show
MapHSC8:
	db $C8,$02,Show
	db $C8,$03,Show
	db $C8,$04,Show
	db $C8,$05,Show
MapHSC9:
	db $C9,$03,Show
	db $C9,$04,Show
MapHSCA:
	db $CA,$01,Show
	db $CA,$05,Show
	db $CA,$06,Show
	db $CA,$07,Show
	db $CA,$08,Hide
	db $CA,$09,Hide
MapHSCF:
	db $CF,$01,Show
	db $CF,$02,Show
	db $CF,$03,Show
	db $CF,$04,Show
	db $CF,$05,Show
MapHSD0:
	db $D0,$02,Show
	db $D0,$03,Show
	db $D0,$04,Show
MapHSD1:
	db $D1,$02,Show
	db $D1,$03,Show
	db $D1,$04,Show
	db $D1,$05,Show
	db $D1,$06,Show
	db $D1,$07,Show
MapHSD2:
	db $D2,$02,Show
	db $D2,$03,Show
	db $D2,$04,Show
	db $D2,$05,Show
	db $D2,$06,Show
	db $D2,$07,Show
	db $D2,$08,Show
MapHSD3:
	db $D3,$06,Show
	db $D3,$07,Show
	db $D3,$08,Show
	db $D3,$09,Show
	db $D3,$0A,Show
MapHSD4:
	db $D4,$05,Show
	db $D4,$06,Show
	db $D4,$07,Show
	db $D4,$08,Show
	db $D4,$09,Show
	db $D4,$0A,Show
	db $D4,$0B,Show
	db $D4,$0C,Show
MapHSD5:
	db $D5,$02,Show
	db $D5,$03,Show
	db $D5,$04,Show
MapHSE9:
	db $E9,$02,Show
	db $E9,$03,Show
	db $E9,$04,Show
MapHSEA:
	db $EA,$01,Show
	db $EA,$02,Show
	db $EA,$03,Show
	db $EA,$04,Show
	db $EA,$05,Show
	db $EA,$06,Show
MapHSEB:
	db $EB,$03,Show
	db $EB,$04,Show
	db $EB,$05,Show
MapHSF4:
	db $F4,$02,Show
MapHSD6:
	db $D6,$02,Show
MapHSD7:
	db $D7,$03,Show
	db $D7,$04,Show
MapHSD8:
	db $D8,$03,Show
	db $D8,$04,Show
	db $D8,$05,Show
	db $D8,$06,Show
	db $D8,$08,Show
MapHSD9:
	db $D9,$01,Show
	db $D9,$02,Show
	db $D9,$03,Show
	db $D9,$04,Show
MapHSDA:
	db $DA,$01,Show
	db $DA,$02,Show
MapHSDB:
	db $DB,$01,Show
	db $DB,$02,Show
	db $DB,$03,Show
	db $DB,$04,Show
MapHSDC:
	db $DC,$01,Show
MapHSE2:
	db $E2,$01,Show
	db $E2,$02,Show
	db $E2,$03,Show
MapHSE3:
	db $E3,$01,Show
	db $E3,$02,Show
	db $E3,$03,Show
MapHS6C:
	db $6C,$03,Show
	db $6C,$04,Show
MapHS78:
	db $78,$02,Hide
MapHSC0:
	db $C0,$01,Show
	db $C0,$02,Show
MapHS9F:
	db $9F,$01,Hide
	db $9F,$02,Hide
MapHSA0:
	db $A0,$01,Hide
	db $A0,$02,Hide
MapHSA1:
	db $A1,$02,Show
	db $A1,$03,Show
	db $A1,$05,Hide
	db $A1,$06,Hide
MapHSA2:
	db $A2,$01,Hide
	db $A2,$02,Hide
	db $A2,$03,Show

	db $FF

INCBIN "baserom.gbc",$CD97,$CEB8-$CD97

; wild pokemon data: from 4EB8 to 55C7

LoadWildData: ; 4EB8
	ld hl,WildDataPointers
	ld a,[W_CURMAP]

	; get wild data for current map
	ld c,a
	ld b,0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a       ; hl now points to wild data for current map
	ld a,[hli]
	ld [W_GRASSRATE],a
	and a
	jr z,.NoGrassData\@ ; if no grass data, skip to surfing data
	push hl
	ld de,W_GRASSMONS ; otherwise, load grass data
	ld bc,$0014
	call CopyData
	pop hl
	ld bc,$0014
	add hl,bc
.NoGrassData\@
	ld a,[hli]
	ld [W_WATERRATE],a
	and a
	ret z        ; if no water data, we're done
	ld de,W_WATERMONS  ; otherwise, load surfing data
	ld bc,$0014
	jp CopyData

WildDataPointers: ; 4EEB
	dw NoMons      ; PALLET_TOWN
	dw NoMons      ; VIRIDIAN_CITY
	dw NoMons      ; PEWTER_CITY
	dw NoMons      ; CERULEAN_CITY
	dw NoMons      ; LAVENDER_TOWN
	dw NoMons      ; VERMILION_CITY
	dw NoMons      ; CELADON_CITY
	dw NoMons      ; FUCHSIA_CITY
	dw NoMons      ; CINNABAR_ISLAND
	dw NoMons      ; INDIGO_PLATEAU
	dw NoMons      ; SAFFRON_CITY
	dw NoMons      ; unused
	dw Route1Mons  ; ROUTE_1
	dw Route2Mons  ; ROUTE_2
	dw Route3Mons  ; ROUTE_3
	dw Route4Mons  ; ROUTE_4
	dw Route5Mons  ; ROUTE_5
	dw Route6Mons  ; ROUTE_6
	dw Route7Mons  ; ROUTE_7
	dw Route8Mons  ; ROUTE_8
	dw Route9Mons  ; ROUTE_9
	dw Route10Mons ; ROUTE_10
	dw Route11Mons ; ROUTE_11
	dw Route12Mons ; ROUTE_12
	dw Route13Mons ; ROUTE_13
	dw Route14Mons ; ROUTE_14
	dw Route15Mons ; ROUTE_15
	dw Route16Mons ; ROUTE_16
	dw Route17Mons ; ROUTE_17
	dw Route18Mons ; ROUTE_18
	dw WaterMons   ; ROUTE_19
	dw WaterMons   ; ROUTE_20
	dw Route21Mons ; ROUTE_21
	dw Route22Mons ; ROUTE_22
	dw Route23Mons ; ROUTE_23
	dw Route24Mons ; ROUTE_24
	dw Route25Mons ; ROUTE_25
	dw NoMons      ; REDS_HOUSE_1F
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw ForestMons ; ViridianForest
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw MoonMons1
	dw MoonMonsB1
	dw MoonMonsB2
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw TunnelMonsB1
	dw PowerPlantMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw PlateauMons1
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw TowerMons1
	dw TowerMons2
	dw TowerMons3
	dw TowerMons4
	dw TowerMons5
	dw TowerMons6
	dw TowerMons7
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw IslandMonsB1
	dw IslandMonsB2
	dw IslandMonsB3
	dw IslandMonsB4
	dw NoMons
	dw NoMons
	dw MansionMons1
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw IslandMons1
	dw NoMons
	dw PlateauMons2
	dw NoMons
	dw NoMons
	dw CaveMons
	dw PlateauMons3
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw MansionMons2
	dw MansionMons3
	dw MansionMonsB1
	dw ZoneMons1
	dw ZoneMons2
	dw ZoneMons3
	dw ZoneMonsCenter
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw DungeonMons2
	dw DungeonMonsB1
	dw DungeonMons1
	dw NoMons
	dw NoMons
	dw NoMons
	dw TunnelMonsB2
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw NoMons
	dw $FFFF

; wild pokemon data is divided into two parts.
; first part:  pokemon found in grass
; second part: pokemon found while surfing
; each part goes as follows:
	; if first byte == 00, then
		; no wild pokemon on this map
	; if first byte != 00, then
		; first byte is encounter rate
		; followed by 20 bytes:
		; level, species (ten times)

NoMons: ; no wild pokemon
	db 0
	db 0

Route1Mons:
	db $19
	db 3,PIDGEY
	db 3,RATTATA
	db 3,RATTATA
	db 2,RATTATA
	db 2,PIDGEY
	db 3,PIDGEY
	db 3,PIDGEY
	db 4,RATTATA
	db 4,PIDGEY
	db 5,PIDGEY

	db 0

Route2Mons:
	db $19
	db 3,RATTATA
	db 3,PIDGEY
	db 4,PIDGEY
	db 4,RATTATA
	db 5,PIDGEY
	db 3,WEEDLE
	db 2,RATTATA
	db 5,RATTATA
	db 4,WEEDLE
	db 5,WEEDLE

	db 0

Route22Mons:
	db $19
	db 3,RATTATA
	db 3,NIDORAN_M
	db 4,RATTATA
	db 4,NIDORAN_M
	db 2,RATTATA
	db 2,NIDORAN_M
	db 3,SPEAROW
	db 5,SPEAROW
	db 3,NIDORAN_F
	db 4,NIDORAN_F

	db 0

ForestMons:
	db $08
	db 4,WEEDLE
	db 5,KAKUNA
	db 3,WEEDLE
	db 5,WEEDLE
	db 4,KAKUNA
	db 6,KAKUNA
	db 4,METAPOD
	db 3,CATERPIE
	db 3,PIKACHU
	db 5,PIKACHU

	db 0

Route3Mons:
	db $14
	db 6,PIDGEY
	db 5,SPEAROW
	db 7,PIDGEY
	db 6,SPEAROW
	db 7,SPEAROW
	db 8,PIDGEY
	db 8,SPEAROW
	db 3,JIGGLYPUFF
	db 5,JIGGLYPUFF
	db 7,JIGGLYPUFF

	db 0

MoonMons1:
	db $0A
	db 8,ZUBAT
	db 7,ZUBAT
	db 9,ZUBAT
	db 8,GEODUDE
	db 6,ZUBAT
	db 10,ZUBAT
	db 10,GEODUDE
	db 8,PARAS
	db 11,ZUBAT
	db 8,CLEFAIRY

	db 0

MoonMonsB1:
	db $0A
	db 8,ZUBAT
	db 7,ZUBAT
	db 7,GEODUDE
	db 8,GEODUDE
	db 9,ZUBAT
	db 10,PARAS
	db 10,ZUBAT
	db 11,ZUBAT
	db 9,CLEFAIRY
	db 9,GEODUDE

	db 0

MoonMonsB2:
	db $0A
	db 9,ZUBAT
	db 9,GEODUDE
	db 10,ZUBAT
	db 10,GEODUDE
	db 11,ZUBAT
	db 10,PARAS
	db 12,PARAS
	db 10,CLEFAIRY
	db 12,ZUBAT
	db 12,CLEFAIRY

	db 0

Route4Mons:
	db $14
	db 10,RATTATA
	db 10,SPEAROW
	db 8,RATTATA
	db 6,EKANS
	db 8,SPEAROW
	db 10,EKANS
	db 12,RATTATA
	db 12,SPEAROW
	db 8,EKANS
	db 12,EKANS

	db 0

Route24Mons:
	db $19
	db 7,WEEDLE
	db 8,KAKUNA
	db 12,PIDGEY
	db 12,ODDISH
	db 13,ODDISH
	db 10,ABRA
	db 14,ODDISH
	db 13,PIDGEY
	db 8,ABRA
	db 12,ABRA

	db 0

Route25Mons:
	db 15
	db 8,WEEDLE
	db 9,KAKUNA
	db 13,PIDGEY
	db 12,ODDISH
	db 13,ODDISH
	db 12,ABRA
	db 14,ODDISH
	db 10,ABRA
	db 7,METAPOD
	db 8,CATERPIE

	db 0

Route9Mons:
	db 15
	db 16,RATTATA
	db 16,SPEAROW
	db 14,RATTATA
	db 11,EKANS
	db 13,SPEAROW
	db 15,EKANS
	db 17,RATTATA
	db 17,SPEAROW
	db 13,EKANS
	db 17,EKANS

	db 0

Route5Mons:
	db 15
	db 13,ODDISH
	db 13,PIDGEY
	db 15,PIDGEY
	db 10,MANKEY
	db 12,MANKEY
	db 15,ODDISH
	db 16,ODDISH
	db 16,PIDGEY
	db 14,MANKEY
	db 16,MANKEY

	db 0

Route6Mons:
	db 15
	db 13,ODDISH
	db 13,PIDGEY
	db 15,PIDGEY
	db 10,MANKEY
	db 12,MANKEY
	db 15,ODDISH
	db 16,ODDISH
	db 16,PIDGEY
	db 14,MANKEY
	db 16,MANKEY

	db 0

Route11Mons:
	db 15
	db 14,EKANS
	db 15,SPEAROW
	db 12,EKANS
	db 9,DROWZEE
	db 13,SPEAROW
	db 13,DROWZEE
	db 15,EKANS
	db 17,SPEAROW
	db 11,DROWZEE
	db 15,DROWZEE

	db 0

TunnelMonsB1:
	db 15
	db 16,ZUBAT
	db 17,ZUBAT
	db 17,GEODUDE
	db 15,MACHOP
	db 16,GEODUDE
	db 18,ZUBAT
	db 15,ZUBAT
	db 17,MACHOP
	db 13,ONIX
	db 15,ONIX

	db 0

TunnelMonsB2:
	db 15
	db 16,ZUBAT
	db 17,ZUBAT
	db 17,GEODUDE
	db 15,MACHOP
	db 16,GEODUDE
	db 18,ZUBAT
	db 17,MACHOP
	db 17,ONIX
	db 13,ONIX
	db 18,GEODUDE

	db 0

Route10Mons:
	db 15
	db 16,VOLTORB
	db 16,SPEAROW
	db 14,VOLTORB
	db 11,EKANS
	db 13,SPEAROW
	db 15,EKANS
	db 17,VOLTORB
	db 17,SPEAROW
	db 13,EKANS
	db 17,EKANS

	db 0

Route12Mons:
	db 15
	db 24,ODDISH
	db 25,PIDGEY
	db 23,PIDGEY
	db 24,VENONAT
	db 22,ODDISH
	db 26,VENONAT
	db 26,ODDISH
	db 27,PIDGEY
	db 28,GLOOM
	db 30,GLOOM

	db 0

Route8Mons:
	db 15
	db 18,PIDGEY
	db 18,MANKEY
	db 17,EKANS
	db 16,GROWLITHE
	db 20,PIDGEY
	db 20,MANKEY
	db 19,EKANS
	db 17,GROWLITHE
	db 15,GROWLITHE
	db 18,GROWLITHE

	db 0

Route7Mons:
	db 15
	db 19,PIDGEY
	db 19,ODDISH
	db 17,MANKEY
	db 22,ODDISH
	db 22,PIDGEY
	db 18,MANKEY
	db 18,GROWLITHE
	db 20,GROWLITHE
	db 19,MANKEY
	db 20,MANKEY

	db 0

TowerMons1:
	db 0
	db 0

TowerMons2:
	db 0
	db 0

TowerMons3:
	db $0A
	db 20,GASTLY
	db 21,GASTLY
	db 22,GASTLY
	db 23,GASTLY
	db 19,GASTLY
	db 18,GASTLY
	db 24,GASTLY
	db 20,CUBONE
	db 22,CUBONE
	db 25,HAUNTER

	db 0

TowerMons4:
	db $0A
	db 20,GASTLY
	db 21,GASTLY
	db 22,GASTLY
	db 23,GASTLY
	db 19,GASTLY
	db 18,GASTLY
	db 25,HAUNTER
	db 20,CUBONE
	db 22,CUBONE
	db 24,GASTLY

	db 0

TowerMons5:
	db $0A
	db 20,GASTLY
	db 21,GASTLY
	db 22,GASTLY
	db 23,GASTLY
	db 19,GASTLY
	db 18,GASTLY
	db 25,HAUNTER
	db 20,CUBONE
	db 22,CUBONE
	db 24,GASTLY

	db 0

TowerMons6:
	db 15
	db 21,GASTLY
	db 22,GASTLY
	db 23,GASTLY
	db 24,GASTLY
	db 20,GASTLY
	db 19,GASTLY
	db 26,HAUNTER
	db 22,CUBONE
	db 24,CUBONE
	db 28,HAUNTER

	db 0

TowerMons7:
	db 15
	db 21,GASTLY
	db 22,GASTLY
	db 23,GASTLY
	db 24,GASTLY
	db 20,GASTLY
	db 28,HAUNTER
	db 22,CUBONE
	db 24,CUBONE
	db 28,HAUNTER
	db 30,HAUNTER

	db 0

Route13Mons:
	db $14
	db 24,ODDISH
	db 25,PIDGEY
	db 27,PIDGEY
	db 24,VENONAT
	db 22,ODDISH
	db 26,VENONAT
	db 26,ODDISH
	db 25,DITTO
	db 28,GLOOM
	db 30,GLOOM

	db 0

Route14Mons:
	db 15
	db 24,ODDISH
	db 26,PIDGEY
	db 23,DITTO
	db 24,VENONAT
	db 22,ODDISH
	db 26,VENONAT
	db 26,ODDISH
	db 30,GLOOM
	db 28,PIDGEOTTO
	db 30,PIDGEOTTO

	db 0

Route15Mons:
	db 15
	db 24,ODDISH
	db 26,DITTO
	db 23,PIDGEY
	db 26,VENONAT
	db 22,ODDISH
	db 28,VENONAT
	db 26,ODDISH
	db 30,GLOOM
	db 28,PIDGEOTTO
	db 30,PIDGEOTTO

	db 0

Route16Mons:
	db $19
	db 20,SPEAROW
	db 22,SPEAROW
	db 18,RATTATA
	db 20,DODUO
	db 20,RATTATA
	db 18,DODUO
	db 22,DODUO
	db 22,RATTATA
	db 23,RATICATE
	db 25,RATICATE

	db 0

Route17Mons:
	db $19
	db 20,SPEAROW
	db 22,SPEAROW
	db 25,RATICATE
	db 24,DODUO
	db 27,RATICATE
	db 26,DODUO
	db 28,DODUO
	db 29,RATICATE
	db 25,FEAROW
	db 27,FEAROW

	db 0

Route18Mons:
	db $19
	db 20,SPEAROW
	db 22,SPEAROW
	db 25,RATICATE
	db 24,DODUO
	db 25,FEAROW
	db 26,DODUO
	db 28,DODUO
	db 29,RATICATE
	db 27,FEAROW
	db 29,FEAROW

	db 0

ZoneMonsCenter:
	db $1E
	db 22,NIDORAN_M
	db 25,RHYHORN
	db 22,VENONAT
	db 24,EXEGGCUTE
	db 31,NIDORINO
	db 25,EXEGGCUTE
	db 31,NIDORINA
	db 30,PARASECT
	db 23,SCYTHER
	db 23,CHANSEY

	db 0

ZoneMons1:
	db $1E
	db 24,NIDORAN_M
	db 26,DODUO
	db 22,PARAS
	db 25,EXEGGCUTE
	db 33,NIDORINO
	db 23,EXEGGCUTE
	db 24,NIDORAN_F
	db 25,PARASECT
	db 25,KANGASKHAN
	db 28,SCYTHER

	db 0

ZoneMons2:
	db $1E
	db 22,NIDORAN_M
	db 26,RHYHORN
	db 23,PARAS
	db 25,EXEGGCUTE
	db 30,NIDORINO
	db 27,EXEGGCUTE
	db 30,NIDORINA
	db 32,VENOMOTH
	db 26,CHANSEY
	db 28,TAUROS

	db 0

ZoneMons3:
	db $1E
	db 25,NIDORAN_M
	db 26,DODUO
	db 23,VENONAT
	db 24,EXEGGCUTE
	db 33,NIDORINO
	db 26,EXEGGCUTE
	db 25,NIDORAN_F
	db 31,VENOMOTH
	db 26,TAUROS
	db 28,KANGASKHAN

	db 0

WaterMons:
	db 0

	db 5
	db 5,   TENTACOOL
	db 10,  TENTACOOL
	db 15,  TENTACOOL
	db 5,   TENTACOOL
	db 10,  TENTACOOL
	db 15,  TENTACOOL
	db 20,  TENTACOOL
	db 30,  TENTACOOL
	db 35,  TENTACOOL
	db 40,  TENTACOOL

IslandMons1:
	db 15
	db 30,SEEL
	db 30,SLOWPOKE
	db 30,SHELLDER
	db 30,HORSEA
	db 28,HORSEA
	db 21,ZUBAT
	db 29,GOLBAT
	db 28,PSYDUCK
	db 28,SHELLDER
	db 38,GOLDUCK

	db 0

IslandMonsB1:
	db $0A
	db 30,STARYU
	db 30,HORSEA
	db 32,SHELLDER
	db 32,HORSEA
	db 28,SLOWPOKE
	db 30,SEEL
	db 30,SLOWPOKE
	db 28,SEEL
	db 38,DEWGONG
	db 37,SEADRA

	db 0

IslandMonsB2:
	db $0A
	db 30,SEEL
	db 30,SLOWPOKE
	db 32,SEEL
	db 32,SLOWPOKE
	db 28,HORSEA
	db 30,STARYU
	db 30,HORSEA
	db 28,SHELLDER
	db 30,GOLBAT
	db 37,SLOWBRO

	db 0

IslandMonsB3:
	db $0A
	db 31,SLOWPOKE
	db 31,SEEL
	db 33,SLOWPOKE
	db 33,SEEL
	db 29,HORSEA
	db 31,SHELLDER
	db 31,HORSEA
	db 29,SHELLDER
	db 39,SEADRA
	db 37,DEWGONG

	db 0

IslandMonsB4:
	db $0A
	db 31,HORSEA
	db 31,SHELLDER
	db 33,HORSEA
	db 33,SHELLDER
	db 29,SLOWPOKE
	db 31,SEEL
	db 31,SLOWPOKE
	db 29,SEEL
	db 39,SLOWBRO
	db 32,GOLBAT

	db 0

MansionMons1:
	db $0A
	db 32,KOFFING
	db 30,KOFFING
	db 34,PONYTA
	db 30,PONYTA
	db 34,GROWLITHE
	db 32,PONYTA
	db 30,GRIMER
	db 28,PONYTA
	db 37,WEEZING
	db 39,MUK

	db 0

MansionMons2:
	db $0A
	db 32,GROWLITHE
	db 34,KOFFING
	db 34,KOFFING
	db 30,PONYTA
	db 30,KOFFING
	db 32,PONYTA
	db 30,GRIMER
	db 28,PONYTA
	db 39,WEEZING
	db 37,MUK

	db 0

MansionMons3:
	db $0A
	db 31,KOFFING
	db 33,GROWLITHE
	db 35,KOFFING
	db 32,PONYTA
	db 34,PONYTA
	db 40,WEEZING
	db 34,GRIMER
	db 38,WEEZING
	db 36,PONYTA
	db 42,MUK

	db 0

MansionMonsB1:
	db $0A
	db 33,KOFFING
	db 31,KOFFING
	db 35,GROWLITHE
	db 32,PONYTA
	db 31,KOFFING
	db 40,WEEZING
	db 34,PONYTA
	db 35,GRIMER
	db 42,WEEZING
	db 42,MUK

	db 0

Route21Mons:
	db $19
	db 21,RATTATA
	db 23,PIDGEY
	db 30,RATICATE
	db 23,RATTATA
	db 21,PIDGEY
	db 30,PIDGEOTTO
	db 32,PIDGEOTTO
	db 28,TANGELA
	db 30,TANGELA
	db 32,TANGELA

	db 5
	db 5,TENTACOOL
	db 10,TENTACOOL
	db 15,TENTACOOL
	db 5,TENTACOOL
	db 10,TENTACOOL
	db 15,TENTACOOL
	db 20,TENTACOOL
	db 30,TENTACOOL
	db 35,TENTACOOL
	db 40,TENTACOOL

DungeonMons1:
	db $0A
	db 46,GOLBAT
	db 46,HYPNO
	db 46,MAGNETON
	db 49,DODRIO
	db 49,VENOMOTH
	db 52,ARBOK
	db 49,KADABRA
	db 52,PARASECT
	db 53,RAICHU
	db 53,DITTO

	db 0

DungeonMons2:
	db 15
	db 51,DODRIO
	db 51,VENOMOTH
	db 51,KADABRA
	db 52,RHYDON
	db 52,MAROWAK
	db 52,ELECTRODE
	db 56,CHANSEY
	db 54,WIGGLYTUFF
	db 55,DITTO
	db 60,DITTO

	db 0

DungeonMonsB1:
	db $19
	db 55,RHYDON
	db 55,MAROWAK
	db 55,ELECTRODE
	db 64,CHANSEY
	db 64,PARASECT
	db 64,RAICHU
	db 57,ARBOK
	db 65,DITTO
	db 63,DITTO
	db 67,DITTO

	db 0

PowerPlantMons:
	db $0A
	db 21,VOLTORB
	db 21,MAGNEMITE
	db 20,PIKACHU
	db 24,PIKACHU
	db 23,MAGNEMITE
	db 23,VOLTORB
	db 32,MAGNETON
	db 35,MAGNETON
	db 33,ELECTABUZZ
	db 36,ELECTABUZZ

	db 0

Route23Mons:
	db $0A
	db 26,EKANS
	db 33,DITTO
	db 26,SPEAROW
	db 38,FEAROW
	db 38,DITTO
	db 38,FEAROW
	db 41,ARBOK
	db 43,DITTO
	db 41,FEAROW
	db 43,FEAROW

	db 0

PlateauMons2:
	db $0A
	db 22,MACHOP
	db 24,GEODUDE
	db 26,ZUBAT
	db 36,ONIX
	db 39,ONIX
	db 42,ONIX
	db 41,MACHOKE
	db 40,GOLBAT
	db 40,MAROWAK
	db 43,GRAVELER

	db 0

PlateauMons3:
	db 15
	db 24,MACHOP
	db 26,GEODUDE
	db 22,ZUBAT
	db 42,ONIX
	db 40,VENOMOTH
	db 45,ONIX
	db 43,GRAVELER
	db 41,GOLBAT
	db 42,MACHOKE
	db 45,MACHOKE

	db 0

PlateauMons1:
	db 15
	db 24,MACHOP
	db 26,GEODUDE
	db 22,ZUBAT
	db 36,ONIX
	db 39,ONIX
	db 42,ONIX
	db 41,GRAVELER
	db 41,GOLBAT
	db 42,MACHOKE
	db 43,MAROWAK

	db 0

CaveMons:
	db $14
	db 18,DIGLETT
	db 19,DIGLETT
	db 17,DIGLETT
	db 20,DIGLETT
	db 16,DIGLETT
	db 15,DIGLETT
	db 21,DIGLETT
	db 22,DIGLETT
	db 29,DUGTRIO
	db 31,DUGTRIO

	db 0

GetItemUse:		;$D5C7
	ld a,1
	ld [$cd6a],a
	ld a,[$cf91]	;contains item_ID
	cp a,HM_01
	jp nc,ItemUseTMHM
	ld hl,ItemUsePtrTable
	dec a
	add a
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

ItemUsePtrTable:	;$D5E1
	dw ItemUseBall		;$5687 masterball
	dw ItemUseBall		;$5687 ultraball
	dw ItemUseBall		;$5687 greatball
	dw ItemUseBall		;$5687 pokeball
	dw ItemUseTownMap	;$5968 TownMap
	dw $5977                ;ItemUseBicycle
	dw $59B4                ;ItemUseSurfBoard (UNUSED, glitchy!)
	dw ItemUseBall		;$5687 Safariball
	dw $5A56
	dw $5A5B
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $5F52
	dw $5F67
	dw $6476
	dw $6476
	dw $6476
	dw $6476
	dw $6476
	dw $6476
	dw $5FAF
	dw $6003
	dw $6476
	dw $5A5B
	dw $5A5B
	dw $5A5B
	dw $5AB4
	dw $5AB4
	dw $5AB4
	dw $5AB4
	dw $5AB4
	dw $5AB4
	dw $6476
	dw $6476
	dw $6476
	dw $6476
	dw $6476
	dw $6013
	dw $5A5B
	dw $6022
	dw $6476
	dw $6476
	dw $60CD
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $60DC
	dw $60EB
	dw $60F0
	dw $60F5
	dw $6476
	dw $5ABB
	dw $5ABB
	dw $5ABB
	dw $6476
	dw $6476
	dw $6104
	dw $6104
	dw $6104
	dw $6104
	dw $623A
	dw $62DE
	dw $62E1
	dw $6476
	dw $6140
	dw $6476
	dw $6476
	dw $624C
	dw GoodRodCode ;$6259
	dw $6283
	dw $6317
	dw $631E
	dw $631E
	dw $631E
	dw $631E

ItemUseBall:	;03:5687
	ld a,[W_ISINBATTLE]
	and a
	jp z,ItemUseNotTime ; not in battle
	dec a
	jp nz,$658b ; in trainer battle
	ld a,[W_BATTLETYPE]
	dec a
	jr z,.UseBall\@
	ld a,[W_NUMINPARTY]	;is Party full?
	cp a,6
	jr nz,.UseBall\@
	ld a,[W_NUMINBOX]	;is Box full?
	cp a,20
	jp z,$65b1
.UseBall\@	;$56a7
;ok, you can use a ball
	xor a
	ld [$d11c],a
	ld a,[W_BATTLETYPE]
	cp a,2		;SafariBattle
	jr nz,.next2\@
	; remove a Safari Ball from inventory
	ld hl,W_NUMSAFARIBALLS
	dec [hl]
.next2\@	;$56b6
	call GoPAL_SET_CF1C
	ld a,$43
	ld [$d11e],a
	call $3725	;restore screenBuffer from Backup
	ld hl,ItemUseText00
	call PrintText
	ld hl,$583a
	ld b,$0f
	call Bankswitch
	ld b,$10
	jp z,$5801
	ld a,[W_BATTLETYPE]
	dec a
	jr nz,.next3\@
	ld hl,W_GRASSRATE	;backups wildMon data
	ld de,W_PLAYERNAME
	ld bc,11
	call CopyData
	jp .BallSuccess\@	;$578b
.next3\@	;$56e9
	ld a,[W_CURMAP]
	cp a,$93	;MonTower 6F
	jr nz,.next4\@
	ld a,[$cfd8]
	cp a,MAROWAK
	ld b,$10
	jp z,$5801
.next4\@	;$56fa
	call $3e5c	;GetRandom
	ld b,a
	ld hl,$cf91
	ld a,[hl]
	cp a,MASTER_BALL;1
	jp z,.BallSuccess\@	;$578b
	cp a,POKE_BALL	;4
	jr z,.next5\@
	ld a,200
        cp b
	jr c,.next4\@	;get only numbers < 200
	ld a,[hl]
	cp a,GREAT_BALL	;3
	jr z,.next5\@
	ld a,150	;get only numbers < 150
	cp b
	jr c,.next4\@
.next5\@	;$571a
	ld a,[$cfe9]	;status ailments
	and a
	jr z,.next6\@
	and a,(FRZ + SLP)	;is frozen and/or asleep?
	ld c,12
	jr z,.noAilments\@
	ld c,25
.noAilments\@	;$5728
	ld a,b
	sub c
	jp c,.BallSuccess\@	;$578b
	ld b,a
.next6\@	;$572e
	push bc		;save RANDOM number
	xor a
	ld [$ff96],a
	ld hl,$cff4	;enemy: Max HP
	ld a,[hli]
	ld [$ff97],a
	ld a,[hl]
	ld [$ff98],a
	ld a,255
	ld [$ff99],a
	call $38ac	;Multiply: MaxHP * 255
	ld a,[$cf91]
	cp a,GREAT_BALL
	ld a,12		;any other BallFactor
	jr nz,.next7\@
	ld a,8
.next7\@	;$574d
	ld [$ff99],a
	ld b,4		;GreatBall's BallFactor
	call $38b9	;Divide
	ld hl,$cfe6	;currentHP
	ld a,[hli]
	ld b,a
	ld a,[hl]
	srl b		;explanation:
	rr a		;we have a 16 bit value
	srl b		;equal to [b << 8 | a].
	rr a		;This number is divided
	and a		;by 4. The result is
	jr nz,.next8\@	;8 bit (reg. a). Always
	inc a		;bigger than zero.
.next8\@	;$5766
	ld [$ff99],a
	ld b,4
	call $38b9	;Divide
	ld a,[$ff97]
	and a
	jr z,.next9\@
	ld a,255
	ld [$ff98],a
.next9\@	;$5776
	pop bc
	ld a,[$d007]	;enemy: Catch Rate
	cp b
	jr c,.next10\@
        ld a,[$ff97]
        and a
        jr nz,.BallSuccess\@
	call $3e5c	;get random number
	ld b,a
	ld a,[$ff98]
	cp b
	jr c,.next10\@
.BallSuccess\@	;$578b
	jr .BallSuccess2\@
.next10\@	;$578d
	ld a,[$ff98]
	ld [$d11e],a
	xor a
	ld [$ff96],a
	ld [$ff97],a
	ld a,[$d007]	;enemy: Catch Rate
	ld [$ff98],a
	ld a,100
	ld [$ff99],a
	call $38ac	;Multiply: CatchRate * 100
	ld a,[$cf91]
	ld b,255
	cp a,POKE_BALL
	jr z,.next11\@
	ld b,200
	cp a,GREAT_BALL
	jr z,.next11\@
	ld b,150
	cp a,ULTRA_BALL
	jr z,.next11\@
.next11\@	;$57b8
	ld a,b
	ld [$ff99],a
	ld b,4
	call $38b9	;Divide
	ld a,[$ff97]
	and a
	ld b,$63
	jr nz,.next12\@
	ld a,[$d11e]
	ld [$ff99],a
	call $38ac
	ld a,255
	ld [$ff99],a
	ld b,4
	call $38b9
	ld a,[$cfe9]	;status ailments
	and a
	jr z,.next13\@
	and a,(FRZ + SLP)
	ld b,5
	jr z,.next14\@
	ld b,10
.next14\@	;$57e6
	ld a,[$ff98]
	add b
	ld [$ff98],a
.next13\@	;$57eb
	ld a,[$ff98]
	cp a,10
	ld b,$20
	jr c,.next12\@
	cp a,30
	ld b,$61
	jr c,.next12\@
	cp a,70
	ld b,$62
	jr c,.next12\@
	ld b,$63
.next12\@	;$5801
	ld a,b
	ld [$d11e],a
.BallSuccess2\@	;$5805
	ld c,20
	call DelayFrames
	ld a,$c1
	ld [$d07c],a
	xor a
	ld [$fff3],a
	ld [$cc5b],a
	ld [$d05b],a
	ld a,[$cf92]
	push af
	ld a,[$cf91]
	push af
	ld a,$08	;probably animations
	call Predef
	pop af
	ld [$cf91],a
	pop af
	ld [$cf92],a
	ld a,[$d11e]
	cp a,$10
	ld hl,ItemUseBallText00
	jp z,.printText0\@
	cp a,$20
	ld hl,ItemUseBallText01
	jp z,.printText0\@
	cp a,$61
	ld hl,ItemUseBallText02
	jp z,.printText0\@
	cp a,$62
	ld hl,ItemUseBallText03
	jp z,.printText0\@
	cp a,$63
	ld hl,ItemUseBallText04
	jp z,.printText0\@
	ld hl,$cfe6	;current HP
	ld a,[hli]
	push af
	ld a,[hli]
	push af		;backup currentHP...
	inc hl
	ld a,[hl]
	push af		;...and status ailments
	push hl
	ld hl,$d069
	bit 3,[hl]
	jr z,.next15\@
	ld a,$4c
	ld [$cfd8],a
	jr .next16\@
.next15\@	;$5871
	set 3,[hl]
	ld hl,$cceb
	ld a,[$cff1]
	ld [hli],a
	ld a,[$cff2]
	ld [hl],a
.next16\@	;$587e
	ld a,[$cf91]
	push af
	ld a,[$cfd8]
	ld [$cf91],a
	ld a,[$cff3]
	ld [$d127],a
	ld hl,$6b01
	ld b,$0f
	call Bankswitch
	pop af
	ld [$cf91],a
	pop hl
	pop af
	ld [hld],a
	dec hl
	pop af
	ld [hld],a
	pop af
	ld [hl],a
	ld a,[$cfe5]	;enemy
	ld [$d11c],a
	ld [$cf91],a
	ld [$d11e],a
	ld a,[W_BATTLETYPE]
	dec a
	jr z,.printText1\@
	ld hl,ItemUseBallText05
	call PrintText
	ld a,$3a	;convert order: Internal->Dex
	call Predef
	ld a,[$d11e]
	dec a
	ld c,a
	ld b,2
	ld hl,$d2f7	;Dex_own_flags (pokemon)
	ld a,$10
	call Predef	;check Dex flag (own already or not)
	ld a,c
	push af
	ld a,[$d11e]
	dec a
	ld c,a
	ld b,1
	ld a,$10	;set Dex_own_flag?
	call Predef
	pop af
	and a
	jr nz,.checkParty\@
	ld hl,ItemUseBallText06
	call PrintText
	call CleanLCD_OAM
	ld a,[$cfe5]	;caught mon_ID
	ld [$d11e],a
	ld a,$3d
	call Predef
.checkParty\@	;$58f4
	ld a,[W_NUMINPARTY]
	cp a,6		;is party full?
	jr z,.sendToBox\@
	xor a
	ld [$cc49],a
	call CleanLCD_OAM
	call AddPokemonToParty	;add mon to Party
	jr .End\@
.sendToBox\@	;$5907
	call CleanLCD_OAM
	call $67a4
	ld hl,ItemUseBallText07
	ld a,[$d7f1]
	bit 0,a		;already met Bill?
	jr nz,.sendToBox2\@
	ld hl,ItemUseBallText08
.sendToBox2\@	;$591a
	call PrintText
	jr .End\@
.printText1\@	;$591f
	ld hl,ItemUseBallText05
.printText0\@	;$5922
	call PrintText
	call CleanLCD_OAM
.End\@	;$5928
	ld a,[W_BATTLETYPE]
	and a
	ret nz
	ld hl,$d31d
	inc a
	ld [$cf96],a
	jp $2bbb	;remove ITEM (XXX)
ItemUseBallText00:
;"It dodged the thrown ball!"
;"This pokemon can't be caught"
	TX_FAR _ItemUseBallText00
	db "@"
ItemUseBallText01:
;"You missed the pokemon!"
	TX_FAR _ItemUseBallText01
	db "@"
ItemUseBallText02:
;"Darn! The pokemon broke free!"
	TX_FAR _ItemUseBallText02
	db "@"
ItemUseBallText03:
;"Aww! It appeared to be caught!"
	TX_FAR _ItemUseBallText03
	db "@"
ItemUseBallText04:
;"Shoot! It was so close too!"
	TX_FAR _ItemUseBallText04
	db "@"
ItemUseBallText05:
;"All right! {MonName} was caught!"
;play sound
	TX_FAR _ItemUseBallText05
	db $12,$06
	db "@"
ItemUseBallText07:
;"X was transferred to Bill's PC"
	TX_FAR _ItemUseBallText07
	db "@"
ItemUseBallText08:
;"X was transferred to someone's PC"
	TX_FAR _ItemUseBallText08
	db "@"

ItemUseBallText06:
;"New DEX data will be added..."
;play sound
	TX_FAR _ItemUseBallText06
	db $13,$06
	db "@"

ItemUseTownMap:	;03:5968
	ld a,[W_ISINBATTLE]	;in-battle or outside
	and a
	jp nz,ItemUseNotTime	;OAK: "this isn't the time..."

INCBIN "baserom.gbc",$D96F,$E259 - $D96F

GoodRodCode: ; 6259
	call $62B4
	jp c,ItemUseNotTime
Next625F:
	call GenRandom
	srl a
	jr c,Next6278
	and 3
	cp 2
	jr nc,Next625F
	; choose which monster appears
	ld hl,GoodRodMons
	add a,a
	ld c,a
	ld b,0
	add hl,bc
	ld b,[hl]
	inc hl
	ld c,[hl]
	and a
Next6278:
	ld a,0
	rla
	xor 1
	jr Next628E

GoodRodMons:
	db 10,GOLDEEN
	db 10,POLIWAG

Next6283:
	call $62B4
	jp c,ItemUseNotTime
Next6289:
	call $68EA
	ld a,e
Next628E:
	ld [$CD3D],a
	dec a
	jr nz,.next\@
	ld a,1
	ld [$D05F],a
	ld a,b
	ld [$D127],a
	ld a,c
	ld [$D059],a
.next\@
	ld hl,$D700
	ld a,[hl]
	push af
	push hl
	ld [hl],0
	ld b,$1C
	ld hl,$47B6
	call Bankswitch
	pop hl
	pop af
	ld [hl],a
	ret

INCBIN "baserom.gbc",$E2B4,$E479 - $E2B4

ItemUseTMHM:	;03:6479
    	INCBIN "baserom.gbc",$E479,$E581 - $E479
ItemUseNotTime:	;03:6581
    	INCBIN "baserom.gbc",$E581,$E5E8 - $E581
;ItemUseTexts:	;03:65e8
ItemUseText00:	;03:65e8
	TX_FAR _ItemUseText001
        db $05
	TX_FAR _ItemUseText002
	db "@"
INCBIN "baserom.gbc",$E5F2,$E919 - $E5F2

; super rod data
; map, pointer to fishing group
SuperRodData: ; 6919
	dbw $00,FishingGroup1
	dbw $01,FishingGroup1
	dbw $03,FishingGroup3
	dbw $05,FishingGroup4
	dbw $06,FishingGroup5
	dbw $07,FishingGroup10
	dbw $08,FishingGroup8
	dbw $0F,FishingGroup3
	dbw $11,FishingGroup4
	dbw $15,FishingGroup5
	dbw $16,FishingGroup4
	dbw $17,FishingGroup7
	dbw $18,FishingGroup7
	dbw $1C,FishingGroup7
	dbw $1D,FishingGroup7
	dbw $1E,FishingGroup8
	dbw $1F,FishingGroup8
	dbw $20,FishingGroup8
	dbw $21,FishingGroup2
	dbw $22,FishingGroup9
	dbw $23,FishingGroup3
	dbw $24,FishingGroup3
	dbw $41,FishingGroup3
	dbw $5E,FishingGroup4
	dbw $A1,FishingGroup8
	dbw $A2,FishingGroup8
	dbw $D9,FishingGroup6
	dbw $DA,FishingGroup6
	dbw $DB,FishingGroup6
	dbw $DC,FishingGroup6
	dbw $E2,FishingGroup9
	dbw $E3,FishingGroup9
	dbw $E4,FishingGroup9
	db $FF

; fishing groups
; number of monsters, followed by level/monster pairs
FishingGroup1:
	db 2
	db 15,TENTACOOL
	db 15,POLIWAG

FishingGroup2:
	db 2
	db 15,GOLDEEN
	db 15,POLIWAG

FishingGroup3:
	db 3
	db 15,PSYDUCK
	db 15,GOLDEEN
	db 15,KRABBY

FishingGroup4:
	db 2
	db 15,KRABBY
	db 15,SHELLDER

FishingGroup5:
	db 2
	db 23,POLIWHIRL
	db 15,SLOWPOKE

FishingGroup6:
	db 4
	db 15,DRATINI
	db 15,KRABBY
	db 15,PSYDUCK
	db 15,SLOWPOKE

FishingGroup7:
	db 4
	db 5,TENTACOOL
	db 15,KRABBY
	db 15,GOLDEEN
	db 15,MAGIKARP

FishingGroup8:
	db 4
	db 15,STARYU
	db 15,HORSEA
	db 15,SHELLDER
	db 15,GOLDEEN

FishingGroup9:
	db 4
	db 23,SLOWBRO
	db 23,SEAKING
	db 23,KINGLER
	db 23,SEADRA

FishingGroup10:
	db 4
	db 23,SEAKING
	db 15,KRABBY
	db 15,GOLDEEN
	db 15,MAGIKARP

INCBIN "baserom.gbc",$E9C5,$10000 - $E9C5

SECTION "bank4",DATA,BANK[$4]
INCBIN "baserom.gbc",$10000,$2EDE

RedPicFront:
	INCBIN "pic/trainer/red.pic"
ShrinkPic1:
	INCBIN "pic/trainer/shrink1.pic"
ShrinkPic2:
	INCBIN "pic/trainer/shrink2.pic"

INCBIN "baserom.gbc",$13074,$13A8F-$13074

GenRandom_: ; 7A8F
; generate a random 16-bit integer and store it at $FFD3,$FFD4
	ld a,[rDIV]
	ld b,a
	ld a,[H_RAND1]
	adc b
	ld [H_RAND1],a
	ld a,[rDIV]
	ld b,a
	ld a,[H_RAND2]
	sbc b
	ld [H_RAND2],a
	ret

SECTION "bank5",DATA,BANK[$5]
INCBIN "baserom.gbc",$14000,$4000

SECTION "bank6",DATA,BANK[$6]

CeladonCity_h: ; 0x18000
    db $00 ; tileset
    db $12,$19 ; dimensions
    dw CeladonCityBlocks, $5966, $5956 ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connection data

	db ROUTE_16
    dw $4B95, $C7C1 ; pointers (connected, current) (strip)
    db $09, $14 ; bigness, width
    db $F8, $27 ; alignments (y, x)
    dw $C716 ; window

	db ROUTE_7
    dw $4051, $C7DD ; pointers (connected, current) (strip)
    db $09, $0A ; bigness, width
    db $F8, $00 ; alignments (y, x)
    dw $C6F9 ; window

    ; end connection data

    dw $4022 ; objects

CeladonCityObject: ; 0x18022 (size=189)
    db $f ; border tile

    db $d ; warps
    db $d, $8, $0, CELADON_MART_1
    db $d, $a, $2, CELADON_MART_1
    db $9, $18, $0, CELADON_MANSION_1
    db $3, $18, $2, CELADON_MANSION_1
    db $3, $19, $2, CELADON_MANSION_1
    db $9, $29, $0, CELADON_POKECENTER
    db $1b, $c, $0, CELADON_GYM
    db $13, $1c, $0, GAME_CORNER
    db $13, $27, $0, CELADON_MART_5
    db $13, $21, $0, CELADONPRIZE_ROOM
    db $1b, $1f, $0, CELADON_DINER
    db $1b, $23, $0, CELADON_HOUSE
    db $1b, $2b, $0, CELADON_HOTEL

    db $9 ; signs
    db $f, $1b, $a ; CeladonCityText10
    db $f, $13, $b ; CeladonCityText11
    db $9, $2a, $c ; CeladonCityText12
    db $1d, $d, $d ; CeladonCityText13
    db $9, $15, $e ; CeladonCityText14
    db $d, $c, $f ; CeladonCityText15
    db $15, $27, $10 ; CeladonCityText16
    db $15, $21, $11 ; CeladonCityText17
    db $15, $1b, $12 ; CeladonCityText18

    db $9 ; people
    db SPRITE_LITTLE_GIRL, $11 + 4, $8 + 4, $fe, $0, $1 ; person
    db SPRITE_OLD_PERSON, $1c + 4, $b + 4, $ff, $d1, $2 ; person
    db SPRITE_GIRL, $13 + 4, $e + 4, $fe, $1, $3 ; person
    db SPRITE_OLD_PERSON, $16 + 4, $19 + 4, $ff, $d0, $4 ; person
    db SPRITE_OLD_PERSON, $10 + 4, $16 + 4, $ff, $d0, $5 ; person
    db SPRITE_FISHER2, $c + 4, $20 + 4, $ff, $d2, $6 ; person
    db SPRITE_SLOWBRO, $c + 4, $1e + 4, $ff, $d3, $7 ; person
    db SPRITE_ROCKET, $1d + 4, $20 + 4, $fe, $2, $8 ; person
    db SPRITE_ROCKET, $e + 4, $2a + 4, $fe, $2, $9 ; person

    ; warp-to
    EVENT_DISP $19, $d, $8 ; CELADON_MART_1
    EVENT_DISP $19, $d, $a ; CELADON_MART_1
    EVENT_DISP $19, $9, $18 ; CELADON_MANSION_1
    EVENT_DISP $19, $3, $18 ; CELADON_MANSION_1
    EVENT_DISP $19, $3, $19 ; CELADON_MANSION_1
    EVENT_DISP $19, $9, $29 ; CELADON_POKECENTER
    EVENT_DISP $19, $1b, $c ; CELADON_GYM
    EVENT_DISP $19, $13, $1c ; GAME_CORNER
    EVENT_DISP $19, $13, $27 ; CELADON_MART_5
    EVENT_DISP $19, $13, $21 ; CELADONPRIZE_ROOM
    EVENT_DISP $19, $1b, $1f ; CELADON_DINER
    EVENT_DISP $19, $1b, $23 ; CELADON_HOUSE
    EVENT_DISP $19, $1b, $2b ; CELADON_HOTEL

CeladonCityBlocks: ; 450
    INCBIN "maps/celadoncity.blk"

PalletTown_h:
	db $00 ; tileset
	db $09,$0A ; dimensions
	dw PalletTownBlocks,PalletTownTexts,PalletTownScript
	db NORTH | SOUTH ; connections

	db $0C ; Route 1
	dw $4192,$C6EB ; pointers
	db $0A,$0A ; bigness, width
	db $23,$00 ; alignments
	dw $C809 ; window

	db $20 ; Route 21
	dw $506D,$C7AB ; pointers
	db $0A,$0A ; bigness, width
	db $00,$00 ; alignments
	dw $C6F9 ; window

	dw PalletTownObject

PalletTownObject: ; 0x182c3 (size=58)
    db $b ; border tile

    db $3 ; warps
    db $5, $5, $0, REDS_HOUSE_1F
    db $5, $d, $0, BLUES_HOUSE
    db $b, $c, $1, OAKS_LAB

    db $4 ; signs
    db $d, $d, $4 ; PalletTownText4
    db $9, $7, $5 ; PalletTownText5
    db $5, $3, $6 ; PalletTownText6
    db $5, $b, $7 ; PalletTownText7

    db $3 ; people
    db SPRITE_OAK, $5 + 4, $8 + 4, $ff, $ff, $1 ; person
    db SPRITE_GIRL, $8 + 4, $3 + 4, $fe, $0, $2 ; person
    db SPRITE_FISHER2, $e + 4, $b + 4, $fe, $0, $3 ; person

    ; warp-to
    EVENT_DISP $a, $5, $5 ; REDS_HOUSE_1F
    EVENT_DISP $a, $5, $d ; BLUES_HOUSE
    EVENT_DISP $a, $b, $c ; OAKS_LAB

PalletTownBlocks: ; 0x182fd
	INCBIN "maps/pallettown.blk"

ViridianCity_h: ; 0x18357 to 0x18384 (45 bytes) (bank=6) (id=1)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw ViridianCityBlocks, $50e4, $4ff1 ; blocks, texts, scripts
    db NORTH | SOUTH | WEST ; connections

    ; connections data

	db ROUTE_2
    dw $41C8, $C6F0 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $47, $f6 ; alignments (y, x)
    dw $c929 ; window

	db ROUTE_1
    dw $40fc, $c912 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $f6 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_22
    dw $404e, $c79e ; pointers (connected, current) (strip)
    db $09, $14 ; bigness, width
    db $f8, $27 ; alignments (y, x)
    dw $c716 ; window

    ; end connection data

    dw $4384 ; objects

ViridianCityObject: ; 0x18384 (size=104)
    db $f ; border tile

    db $5 ; warps
    db $19, $17, $0, VIRIDIAN_POKECENTER
    db $13, $1d, $0, VIRIDIAN_MART
    db $f, $15, $0, VIRIDIAN_SCHOOL
    db $9, $15, $0, VIRIDIAN_HOUSE
    db $7, $20, $0, VIRIDIAN_GYM

    db $6 ; signs
    db $11, $11, $8 ; ViridianCityText8
    db $1, $13, $9 ; ViridianCityText9
    db $1d, $15, $a ; ViridianCityText10
    db $13, $1e, $b ; ViridianCityText11
    db $19, $18, $c ; ViridianCityText12
    db $7, $1b, $d ; ViridianCityText13

    db $7 ; people
    db SPRITE_BUG_CATCHER, $14 + 4, $d + 4, $fe, $0, $1 ; person
    db SPRITE_GAMBLER, $8 + 4, $1e + 4, $ff, $ff, $2 ; person
    db SPRITE_BUG_CATCHER, $19 + 4, $1e + 4, $fe, $0, $3 ; person
    db SPRITE_GIRL, $9 + 4, $11 + 4, $ff, $d3, $4 ; person
    db SPRITE_LYING_OLD_MAN, $9 + 4, $12 + 4, $ff, $ff, $5 ; person
    db SPRITE_FISHER2, $17 + 4, $6 + 4, $ff, $d0, $6 ; person
    db SPRITE_GAMBLER, $5 + 4, $11 + 4, $fe, $2, $7 ; person

    ; warp-to
    EVENT_DISP $14, $19, $17 ; VIRIDIAN_POKECENTER
    EVENT_DISP $14, $13, $1d ; VIRIDIAN_MART
    EVENT_DISP $14, $f, $15 ; VIRIDIAN_SCHOOL
    EVENT_DISP $14, $9, $15 ; VIRIDIAN_HOUSE
    EVENT_DISP $14, $7, $20 ; VIRIDIAN_GYM

ViridianCityBlocks: ; 360
    INCBIN "maps/viridiancity.blk"

PewterCity_h: ; 0x18554 to 0x18576 (34 bytes) (bank=6) (id=2)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw PewterCityBlocks, $538b, $5237 ; blocks, texts, scripts
    db SOUTH | EAST ; connections

    ; connections data

	db ROUTE_2
    dw $407e, $c912 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $f6 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_3
    dw $4255, $c7b5 ; pointers (connected, current) (strip)
    db $09, $23 ; bigness, width
    db $f8, $00 ; alignments (y, x)
    dw $c712 ; window

    ; end connection data

    dw $4577 ; objects

INCBIN "baserom.gbc",$18576,$18577 - $18576
PewterCityObject: ; 0x18577 (size=111)
    db $a ; border tile

    db $7 ; warps
    db $7, $e, $0, MUSEUM_1F
    db $5, $13, $2, MUSEUM_1F
    db $11, $10, $0, PEWTER_GYM
    db $d, $1d, $0, PEWTER_HOUSE_1
    db $11, $17, $0, PEWTER_MART
    db $1d, $7, $0, PEWTER_HOUSE_2
    db $19, $d, $0, PEWTER_POKECENTER

    db $7 ; signs
    db $1d, $13, $6 ; PewterCityText6
    db $13, $21, $7 ; PewterCityText7
    db $11, $18, $8 ; PewterCityText8
    db $19, $e, $9 ; PewterCityText9
    db $9, $f, $a ; PewterCityText10
    db $11, $b, $b ; PewterCityText11
    db $17, $19, $c ; PewterCityText12

    db $5 ; people
    db SPRITE_LASS, $f + 4, $8 + 4, $ff, $ff, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $19 + 4, $11 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $11 + 4, $1b + 4, $ff, $ff, $3 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $19 + 4, $1a + 4, $fe, $2, $4 ; person
    db SPRITE_BUG_CATCHER, $10 + 4, $23 + 4, $ff, $d0, $5 ; person

    ; warp-to
    EVENT_DISP $14, $7, $e ; MUSEUM_1F
    EVENT_DISP $14, $5, $13 ; MUSEUM_1F
    EVENT_DISP $14, $11, $10 ; PEWTER_GYM
    EVENT_DISP $14, $d, $1d ; PEWTER_HOUSE_1
    EVENT_DISP $14, $11, $17 ; PEWTER_MART
    EVENT_DISP $14, $1d, $7 ; PEWTER_HOUSE_2
    EVENT_DISP $14, $19, $d ; PEWTER_POKECENTER

PewterCityBlocks: ; 360
    INCBIN "maps/pewtercity.blk"

CeruleanCity_h: ; 0x1874e to 0x18786 (56 bytes) (bank=6) (id=3)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw CeruleanCityBlocks, $562d, $5480 ; blocks, texts, scripts
    db NORTH | SOUTH | WEST | EAST ; connections

    ; connections data

	db ROUTE_24
    dw $477d, $c6f0 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $23, $f6 ; alignments (y, x)
    dw $c809 ; window

	db ROUTE_5
    dw $45d2, $c912 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $f6 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_4
    dw $4416, $c79e ; pointers (connected, current) (strip)
    db $09, $2d ; bigness, width
    db $f8, $59 ; alignments (y, x)
    dw $c748 ; window

	db ROUTE_9
    dw $46fe, $c7b5 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $f8, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $4786 ; objects

CeruleanCityObject: ; 0x18786 (size=170)
    db $f ; border tile

    db $a ; warps
    db $b, $1b, $0, TRASHED_HOUSE
    db $f, $d, $0, CERULEAN_HOUSE
    db $11, $13, $0, CERULEAN_POKECENTER
    db $13, $1e, $0, CERULEAN_GYM
    db $19, $d, $0, BIKE_SHOP
    db $19, $19, $0, CERULEAN_MART
    db $b, $4, $0, UNKNOWN_DUNGEON_1
    db $9, $1b, $2, TRASHED_HOUSE
    db $b, $9, $1, CERULEAN_HOUSE_3
    db $9, $9, $0, CERULEAN_HOUSE_3

    db $6 ; signs
    db $13, $17, $c ; CeruleanCityText12
    db $1d, $11, $d ; CeruleanCityText13
    db $19, $1a, $e ; CeruleanCityText14
    db $11, $14, $f ; CeruleanCityText15
    db $19, $b, $10 ; CeruleanCityText16
    db $15, $1b, $11 ; CeruleanCityText17

    db $b ; people
    db SPRITE_BLUE, $2 + 4, $14 + 4, $ff, $d0, $1 ; person
    db SPRITE_ROCKET, $8 + 4, $1e + 4, $ff, $ff, $42, ROCKET + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $14 + 4, $1f + 4, $ff, $d0, $3 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $12 + 4, $f + 4, $fe, $1, $4 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $15 + 4, $9 + 4, $fe, $2, $5 ; person
    db SPRITE_GUARD, $c + 4, $1c + 4, $ff, $d0, $6 ; person
    db SPRITE_LASS, $1a + 4, $1d + 4, $ff, $d2, $7 ; person
    db SPRITE_SLOWBRO, $1a + 4, $1c + 4, $ff, $d0, $8 ; person
    db SPRITE_LASS, $1b + 4, $9 + 4, $fe, $2, $9 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $c + 4, $4 + 4, $ff, $d0, $a ; person
    db SPRITE_GUARD, $c + 4, $1b + 4, $ff, $d0, $b ; person

    ; warp-to
    EVENT_DISP $14, $b, $1b ; TRASHED_HOUSE
    EVENT_DISP $14, $f, $d ; CERULEAN_HOUSE
    EVENT_DISP $14, $11, $13 ; CERULEAN_POKECENTER
    EVENT_DISP $14, $13, $1e ; CERULEAN_GYM
    EVENT_DISP $14, $19, $d ; BIKE_SHOP
    EVENT_DISP $14, $19, $19 ; CERULEAN_MART
    EVENT_DISP $14, $b, $4 ; UNKNOWN_DUNGEON_1
    EVENT_DISP $14, $9, $1b ; TRASHED_HOUSE
    EVENT_DISP $14, $b, $9 ; CERULEAN_HOUSE_3
    EVENT_DISP $14, $9, $9 ; CERULEAN_HOUSE_3

CeruleanCityBlocks: ; 360
    INCBIN "maps/ceruleancity.blk"

VermilionCity_h: ; 0x18998 to 0x189ba (34 bytes) (bank=6) (id=5)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw VermilionCityBlocks, $586f, $57a1 ; blocks, texts, scripts
    db NORTH | EAST ; connections

    ; connections data

	db ROUTE_6
    dw $410f, $c6f0 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $23, $f6 ; alignments (y, x)
    dw $c809 ; window

	db ROUTE_11
    dw $455f, $c7b5 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $f8, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $49ba ; objects

VermilionCityObject: ; 0x189ba (size=133)
    db $43 ; border tile

    db $9 ; warps
    db $3, $b, $0, VERMILION_POKECENTER
    db $d, $9, $0, POKEMON_FAN_CLUB
    db $d, $17, $0, VERMILION_MART
    db $13, $c, $0, VERMILION_GYM
    db $13, $17, $0, VERMILION_HOUSE_1
    db $1f, $12, $0, VERMILION_DOCK
    db $1f, $13, $0, VERMILION_DOCK
    db $d, $f, $0, VERMILION_HOUSE_3
    db $3, $7, $0, VERMILION_HOUSE_2

    db $7 ; signs
    db $3, $1b, $7 ; VermilionCityText7
    db $d, $25, $8 ; VermilionCityText8
    db $d, $18, $9 ; VermilionCityText9
    db $3, $c, $a ; VermilionCityText10
    db $d, $7, $b ; VermilionCityText11
    db $13, $7, $c ; VermilionCityText12
    db $f, $1d, $d ; VermilionCityText13

    db $6 ; people
    db SPRITE_FOULARD_WOMAN, $7 + 4, $13 + 4, $fe, $2, $1 ; person
    db SPRITE_GAMBLER, $6 + 4, $e + 4, $ff, $ff, $2 ; person
    db SPRITE_SAILOR, $1e + 4, $13 + 4, $ff, $d1, $3 ; person
    db SPRITE_GAMBLER, $7 + 4, $1e + 4, $ff, $ff, $4 ; person
    db SPRITE_SLOWBRO, $9 + 4, $1d + 4, $fe, $1, $5 ; person
    db SPRITE_SAILOR, $1b + 4, $19 + 4, $fe, $2, $6 ; person

    ; warp-to
    EVENT_DISP $14, $3, $b ; VERMILION_POKECENTER
    EVENT_DISP $14, $d, $9 ; POKEMON_FAN_CLUB
    EVENT_DISP $14, $d, $17 ; VERMILION_MART
    EVENT_DISP $14, $13, $c ; VERMILION_GYM
    EVENT_DISP $14, $13, $17 ; VERMILION_HOUSE_1
    EVENT_DISP $14, $1f, $12 ; VERMILION_DOCK
    EVENT_DISP $14, $1f, $13 ; VERMILION_DOCK
    EVENT_DISP $14, $d, $f ; VERMILION_HOUSE_3
    EVENT_DISP $14, $3, $7 ; VERMILION_HOUSE_2

VermilionCityBlocks: ; 360
    INCBIN "maps/vermilioncity.blk"

FuchsiaCity_h: ; 0x18ba7 to 0x18bd4 (45 bytes) (bank=6) (id=7)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw FuchsiaCityBlocks, $5a2e, $5a2b ; blocks, texts, scripts
    db SOUTH | WEST | EAST ; connections

    ; connections data

	db ROUTE_19
    dw $4ef1, $c912 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $f6 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_18
    dw $4cb2, $c79e ; pointers (connected, current) (strip)
    db $09, $19 ; bigness, width
    db $f8, $31 ; alignments (y, x)
    dw $c720 ; window

	db ROUTE_15
    dw $49cc, $c7b5 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $f8, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $4bd4 ; objects

FuchsiaCityObject: ; 0x18bd4 (size=178)
    db $f ; border tile

    db $9 ; warps
    db $d, $5, $0, FUCHSIA_MART
    db $1b, $b, $0, FUCHSIA_HOUSE_1
    db $1b, $13, $0, FUCHSIA_POKECENTER
    db $1b, $1b, $0, FUCHSIA_HOUSE_2
    db $3, $12, $0, SAFARIZONEENTRANCE
    db $1b, $5, $0, FUCHSIA_GYM
    db $d, $16, $0, FUCHSIAMEETINGROOM
    db $1b, $1f, $1, FUCHSIA_HOUSE_3
    db $18, $1f, $0, FUCHSIA_HOUSE_3

    db $e ; signs
    db $17, $f, $b ; FuchsiaCityText11
    db $f, $19, $c ; FuchsiaCityText12
    db $5, $11, $d ; FuchsiaCityText13
    db $d, $6, $e ; FuchsiaCityText14
    db $1b, $14, $f ; FuchsiaCityText15
    db $1d, $1b, $10 ; FuchsiaCityText16
    db $f, $15, $11 ; FuchsiaCityText17
    db $1d, $5, $12 ; FuchsiaCityText18
    db $7, $21, $13 ; FuchsiaCityText19
    db $7, $1b, $14 ; FuchsiaCityText20
    db $7, $d, $15 ; FuchsiaCityText21
    db $d, $1f, $16 ; FuchsiaCityText22
    db $f, $d, $17 ; FuchsiaCityText23
    db $7, $7, $18 ; FuchsiaCityText24

    db $a ; people
    db SPRITE_BUG_CATCHER, $c + 4, $a + 4, $fe, $2, $1 ; person
    db SPRITE_GAMBLER, $11 + 4, $1c + 4, $fe, $2, $2 ; person
    db SPRITE_FISHER2, $e + 4, $1e + 4, $ff, $d0, $3 ; person
    db SPRITE_BUG_CATCHER, $8 + 4, $18 + 4, $ff, $d1, $4 ; person
    db SPRITE_CLEFAIRY, $5 + 4, $1f + 4, $fe, $0, $5 ; person
    db SPRITE_BALL, $6 + 4, $19 + 4, $ff, $ff, $6 ; person
    db SPRITE_SLOWBRO, $6 + 4, $c + 4, $fe, $2, $7 ; person
    db SPRITE_SLOWBRO, $c + 4, $1e + 4, $fe, $2, $8 ; person
    db SPRITE_SEEL, $11 + 4, $8 + 4, $fe, $0, $9 ; person
    db SPRITE_OMANYTE, $5 + 4, $6 + 4, $ff, $ff, $a ; person

    ; warp-to
    EVENT_DISP $14, $d, $5 ; FUCHSIA_MART
    EVENT_DISP $14, $1b, $b ; FUCHSIA_HOUSE_1
    EVENT_DISP $14, $1b, $13 ; FUCHSIA_POKECENTER
    EVENT_DISP $14, $1b, $1b ; FUCHSIA_HOUSE_2
    EVENT_DISP $14, $3, $12 ; SAFARIZONEENTRANCE
    EVENT_DISP $14, $1b, $5 ; FUCHSIA_GYM
    EVENT_DISP $14, $d, $16 ; FUCHSIAMEETINGROOM
    EVENT_DISP $14, $1b, $1f ; FUCHSIA_HOUSE_3
    EVENT_DISP $14, $18, $1f ; FUCHSIA_HOUSE_3

FuchsiaCityBlocks: ; 360
    INCBIN "maps/fuchsiacity.blk"

INCBIN "baserom.gbc",$18dee,$6d

PalletTownScript:
	ld a,[$D74B]
	bit 4,a
	jr z,.next\@
	ld hl,$D747
	set 6,[hl]
.next\@
	call $3C3C
	ld hl,PalletTownScriptPointers
	ld a,[$D5F1]
	jp $3D97

PalletTownScriptPointers:
	dw PalletTownScript1,PalletTownScript2,PalletTownScript3,PalletTownScript4,PalletTownScript5,PalletTownScript6,PalletTownScript7

PalletTownScript1:
	ld a,[$D747]
	bit 0,a
	ret nz
	ld a,[W_YCOORD]
	cp 1 ; is player near north exit?
	ret nz
	xor a
	ld [$FFB4],a
	ld a,4
	ld [$D528],a
	ld a,$FF
	call $23B1 ; stop music
	ld a,2
	ld c,a ; song bank
	ld a,$DB ; “oak appears” music
	call $23A1 ; plays music
	ld a,$FC
	ld [$CD6B],a
	ld hl,$D74B
	set 7,[hl]

	; trigger the next script
	ld a,1
	ld [$D5F1],a
	ret

PalletTownScript2:
	xor a
	ld [$CF0D],a
	ld a,1
	ld [$FF8C],a
	call $2920
	ld a,$FF
	ld [$CD6B],a
	ld a,0
	ld [$CC4D],a
	ld a,$15
	call Predef

	; trigger the next script
	ld a,2
	ld [$D5F1],a
	ret

PalletTownScript3:
	ld a,1
	ld [$FF8C],a
	ld a,4
	ld [$FF8D],a
	call $34A6
	call Delay3
	ld a,1
	ld [W_YCOORD],a
	ld a,1
	ld [$FF9B],a
	ld a,1
	swap a
	ld [$FF95],a
	ld a,$22
	call Predef
	ld hl,$FF95
	dec [hl]
	ld a,$20
	call Predef ; load Oak’s movement into $CC97
	ld de,$CC97
	ld a,1 ; oak
	ld [$FF8C],a
	call MoveSprite
	ld a,$FF
	ld [$CD6B],a

	; trigger the next script
	ld a,3
	ld [$D5F1],a
	ret

PalletTownScript4:
	ld a,[$D730]
	bit 0,a
	ret nz
	xor a
	ld [$C109],a
	ld a,1
	ld [$CF0D],a
	ld a,$FC
	ld [$CD6B],a
	ld a,1
	ld [$FF8C],a
	call $2920
	ld a,$FF
	ld [$CD6B],a
	ld a,1
	ld [$CF13],a
	xor a
	ld [$CF10],a
	ld a,1
	ld [$CC57],a
	ld a,[$FFB8]
	ld [$CC58],a

	; trigger the next script
	ld a,4
	ld [$D5F1],a
	ret

PalletTownScript5:
	ld a,[$CC57]
	and a
	ret nz

	; trigger the next script
	ld a,5
	ld [$D5F1],a
	ret

PalletTownScript6:
	ld a,[$D74A]
	bit 2,a
	jr nz,.next\@
	and 3
	cp 3
	jr nz,.next\@
	ld hl,$D74A
	set 2,[hl]
	ld a,$27
	ld [$CC4D],a
	ld a,$11
	call Predef
	ld a,$28
	ld [$CC4D],a
	ld a,$15
	jp Predef
.next\@
	ld a,[$D74B]
	bit 4,a
	ret z
	ld hl,$D74B
	set 6,[hl]
PalletTownScript7:
	ret

PalletTownTexts: ; 0x18f88
	dw PalletTownText1,PalletTownText2,PalletTownText3,PalletTownText4,PalletTownText5,PalletTownText6,PalletTownText7

PalletTownText1: ; 4F96 0x18f96
	db 8
	ld a,[$CF0D]
	and a
	jr nz,.next\@
	ld a,1
	ld [$CC3C],a
	ld hl,OakAppearsText
	jr .done\@
.next\@
	ld hl,OakWalksUpText
.done\@
	call PrintText
	jp $24D7

OakAppearsText:
	TX_FAR _OakAppearsText
	db 8
	ld c,10
	call DelayFrames
	xor a
	ld [$CD4F],a
	ld [$CD50],a
	ld a,$4C
	call Predef ; display ! over head
	ld a,4
	ld [$D528],a
	jp $24D7

OakWalksUpText:
	TX_FAR _OakWalksUpText
	db "@"

PalletTownText2: ; girl 0x18fd3
	TX_FAR _PalletTownText2 ; dc 42 29 pointing to 0xa42dc
	db "@"

PalletTownText3: ; fat man
	TX_FAR _PalletTownText3
	db "@"

PalletTownText4: ; sign by lab
	TX_FAR _PalletTownText4
	db "@"

PalletTownText5: ; sign by fence
	TX_FAR _PalletTownText5
	db "@"

PalletTownText6: ; sign by Red’s house
	TX_FAR _PalletTownText6
	db "@"

PalletTownText7: ; sign by Blue’s house
	TX_FAR _PalletTownText7
	db "@"

INCBIN "baserom.gbc",$18ff1,$19102 - $18ff1

ViridianCityText1: ; 0x19102
    TX_FAR _ViridianCityText1
    db $50

ViridianCityText2: ; 0x19107
    db $08 ; asm
    ld a, [$d356]
    cp $7f
    ld hl, $5127
    jr z, .asm_ae9fe ; 0x19110
    ld a, [$d751]
    bit 1, a
    jr nz, .asm_ae9fe ; 0x19117
    ld hl, $5122
.asm_ae9fe ; 0x1911c
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$19122,$1912c - $19122
ViridianCityText3: ; 0x1912c
    db $08 ; asm
    ld hl, $514d
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_6dfea ; 0x1913a
    ld hl, $5157
    call PrintText
    jr .asm_d611f ; 0x19142
.asm_6dfea ; 0x19144
    ld hl, $5152
    call PrintText
.asm_d611f ; 0x1914a
    jp $24d7

INCBIN "baserom.gbc",$1914d,$1915c - $1914d
ViridianCityText4: ; 0x1915c
    db $08 ; asm
    ld a, [$d74b]
    bit 5, a
    jr nz, .asm_83894 ; 0x19162
    ld hl, $5175
    call PrintText
    jr .asm_700a6 ; 0x1916a
.asm_83894 ; 0x1916c
    ld hl, $517a
    call PrintText
.asm_700a6 ; 0x19172
    jp $24d7

INCBIN "baserom.gbc",$19175,$1917f - $19175
ViridianCityText5: ; 0x1917f
    db $08 ; asm
    ld hl, $5191
    call PrintText
    call $50cf
    ld a, $3
    ld [$d5f4], a
    jp $24d7

INCBIN "baserom.gbc",$19191,$19196 - $19191
ViridianCityText6: ; 0x19196
    db $08 ; asm
    ld a, [$d74c]
    bit 1, a
    jr nz, .asm_4e5a0 ; 0x1919c
    ld hl, $51ca
    call PrintText
    ld bc,(TM_42 << 8) | 1
    call $3e2e
    jr nc, .asm_b655e ; 0x191aa
    ld hl, $51cf
    call PrintText
    ld hl, $d74c
    set 1, [hl]
    jr .asm_3c73c ; 0x191b7
.asm_b655e ; 0x191b9
    ld hl, $51da
    call PrintText
    jr .asm_3c73c ; 0x191bf
.asm_4e5a0 ; 0x191c1
    ld hl, $51d5
    call PrintText
.asm_3c73c ; 0x191c7
    jp $24d7

INCBIN "baserom.gbc",$191ca,$191df - $191ca
ViridianCityText7: ; 0x191df
    db $08 ; asm
    ld hl, $520a
    call PrintText
    ld c, $2
    call $3739
    call $35ec
    ld a, [$cc26]
    and a
    jr z, .asm_42f68 ; 0x191f2
    ld hl, $520f
    call PrintText
    ld a, $1
    ld [$d5f4], a
    jr .asm_2413a ; 0x191ff
.asm_42f68 ; 0x19201
    ld hl, $5214
    call PrintText
.asm_2413a ; 0x19207
    jp $24d7

INCBIN "baserom.gbc",$1920a,$14

ViridianCityText8: ; 0x1921e
    TX_FAR _ViridianCityText8
    db $50

ViridianCityText9: ; 0x19223
    TX_FAR _ViridianCityText9
    db $50

ViridianCityText10: ; 0x19228
    TX_FAR _ViridianCityText10
    db $50

ViridianCityText13: ; 0x1922d
    TX_FAR _ViridianCityText13
    db $50

INCBIN "baserom.gbc",$19232,$193a7 - $19232

PewterCityText1: ; 0x193a7
    TX_FAR _PewterCityText1
    db $50

PewterCityText2: ; 0x193ac
    TX_FAR _PewterCityText2
    db $50

PewterCityText3: ; 0x193b1
    db $08 ; asm
    ld hl, $53f1
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_f46a9 ; 0x193bf
    ld hl, $53f6
    call PrintText
    jr .asm_ac429 ; 0x193c7
.asm_f46a9 ; 0x193c9
    ld hl, $53fb
    call PrintText
    xor a
    ldh [$b3], a
    ldh [$b4], a
    ld [$cf10], a
    ld a, $2
    ld [$cc57], a
    ldh a, [$b8]
    ld [$cc58], a
    ld a, $3
    ld [$cf13], a
    call $32f4
    ld a, $1
    ld [$d5f7], a
.asm_ac429 ; 0x193ee
    jp $24d7

INCBIN "baserom.gbc",$193f1,$19405 - $193f1

PewterCityText4: ; 0x19405
    db $8
    ld hl, $5427
    call PrintText
    call $35ec
    ld a, [$cc26]
    cp $0
    jr nz, .asm_e4603
    ld hl, $542c
    call PrintText
    jr .asm_e4604 ; 0x1941c $6
.asm_e4603
    ld hl, $5431
    call PrintText
.asm_e4604 ; 0x19424
    jp $24d7
; 0x19427

INCBIN "baserom.gbc",$19427,$f
PewterCityText5: ; 0x19436
    db $08 ; asm
    ld hl, $545d
    call PrintText
    xor a
    ldh [$b4], a
    ld [$cf10], a
    ld a, $3
    ld [$cc57], a
    ldh a, [$b8]
    ld [$cc58], a
    ld a, $5
    ld [$cf13], a
    call $32f4
    ld a, $4
    ld [$d5f7], a
    jp $24d7

INCBIN "baserom.gbc",$1945d,$a

PewterCityText6: ; 0x19467
    TX_FAR _PewterCityText6
    db $50

PewterCityText7: ; 0x1946c
    TX_FAR _PewterCityText7
    db $50

PewterCityText10: ; 0x19471
    TX_FAR _PewterCityText10
    db $50

PewterCityText11: ; 0x19476
    TX_FAR _PewterCityText11
    db $50

PewterCityText12: ; 0x1947b
    TX_FAR _PewterCityText12
    db $50

INCBIN "baserom.gbc",$19480,$1964f - $19480
CeruleanCityText1: ; 0x1964f
    db $08 ; asm
    ld a, [$d75a]
    bit 0, a
    jr z, .asm_a89f9 ; 0x19655
    ld hl, $5677
    call PrintText
    jr .asm_815c6 ; 0x1965d
.asm_a89f9 ; 0x1965f
    ld hl, $5668
    call PrintText
.asm_815c6 ; 0x19665
    jp $24d7

INCBIN "baserom.gbc",$19668,$1967c - $19668
CeruleanCityText2: ; 0x1967c
    db $8
    ld a, [$d75b]
    bit 7, a
    jr nz, .asm_4ca20 ; 0x19682 $29
    ld hl, $56d9
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $56ee
    ld de, $56ee
    call $3354
    ld a, [$ff00+$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $4
    ld [$d60f], a
    jp $24d7
.asm_4ca20 ; 0x196ad
    ld hl, $56f3
    call PrintText
    ld bc, $e401
    call GiveItem
    jr c, .asm_8bbbd ; 0x196b9 $8
    ld hl, $56e9
    call PrintText
    jr .asm_e4e6f ; 0x196c1 $13
.asm_8bbbd ; 0x196c3
    ld a, $1
    ld [$cc3c], a
    ld hl, $56de
    call PrintText
    ld b, $1d
    ld hl, $4872
    call Bankswitch
.asm_e4e6f ; 0x196d6
    jp $24d7
; 0x196d9
INCBIN "baserom.gbc",$196d9,$1f

CeruleanCityText3: ; 0x196f8
    TX_FAR _CeruleanCityText3
    db $50

CeruleanCityText4: ; 0x196fd
    TX_FAR _CeruleanCityText4
    db $50

CeruleanCityText5: ; 0x19702
    TX_FAR _CeruleanCityText5
    db $50

CeruleanCityText6: ; 0x19707
    TX_FAR _CeruleanCityText6
    db $50

CeruleanCityText7: ; 0x1970c
    db $08 ; asm
    ldh a, [$d3]
    cp $b4
    jr c, .asm_e9fc9 ; 0x19711
    ld hl, $5730
    call PrintText
    jr .asm_d486e ; 0x19719
.asm_e9fc9 ; 0x1971b
    cp $64
    jr c, .asm_df99b ; 0x1971d
    ld hl, $5735
    call PrintText
    jr .asm_d486e ; 0x19725
.asm_df99b ; 0x19727
    ld hl, $573a
    call PrintText
.asm_d486e ; 0x1972d
    jp $24d7

INCBIN "baserom.gbc",$19730,$1973f - $19730
CeruleanCityText8: ; 0x1973f
    db $08 ; asm
    ldh a, [$d3]
    cp $b4
    jr c, .asm_e28da ; 0x19744
    ld hl, $576f
    call PrintText
    jr .asm_f2f38 ; 0x1974c
.asm_e28da ; 0x1974e
    cp $78
    jr c, .asm_15d08 ; 0x19750
    ld hl, $5774
    call PrintText
    jr .asm_f2f38 ; 0x19758
.asm_15d08 ; 0x1975a
    cp $3c
    jr c, .asm_d7fea ; 0x1975c
    ld hl, $5779
    call PrintText
    jr .asm_f2f38 ; 0x19764
.asm_d7fea ; 0x19766
    ld hl, $577e
    call PrintText
.asm_f2f38 ; 0x1976c
    jp $24d7

INCBIN "baserom.gbc",$1976f,$14

CeruleanCityText9: ; 0x19783
    TX_FAR _CeruleanCityText9
    db $50

CeruleanCityText10: ; 0x19788
    TX_FAR _CeruleanCityText10
    db $50

CeruleanCityText12: ; 0x1978d
    TX_FAR _CeruleanCityText12
    db $50

CeruleanCityText13: ; 0x19792
    TX_FAR _CeruleanCityText13
    db $50

CeruleanCityText16: ; 0x19797
    TX_FAR _CeruleanCityText16
    db $50

CeruleanCityText17: ; 0x1979c
    TX_FAR _CeruleanCityText17
    db $50

INCBIN "baserom.gbc",$197a1,$19889 - $197a1

VermilionCityText1: ; 0x19889
    TX_FAR _VermilionCityText1
    db $50

VermilionCityText2: ; 0x1988e
    db $08 ; asm
    ld a, [$d803]
    bit 2, a
    jr nz, .asm_359bd ; 0x19894
    ld hl, $58a7
    call PrintText
    jr .asm_735d9 ; 0x1989c
.asm_359bd ; 0x1989e
    ld hl, $58ac
    call PrintText
.asm_735d9 ; 0x198a4
    jp $24d7

INCBIN "baserom.gbc",$198a7,$198b1 - $198a7
VermilionCityText3: ; 0x198b1
    db $08 ; asm
    ld a, [$d803]
    bit 2, a
    jr nz, .asm_3e0e9 ; 0x198b7
    ld a, [$c109]
    cp $c
    jr z, .asm_07af3 ; 0x198be
    ld hl, $58ff
    call $34bf
    jr nc, .asm_57b73 ; 0x198c6
.asm_07af3 ; 0x198c8
    ld hl, $5904
    call PrintText
    jr .asm_79bd1 ; 0x198ce
.asm_57b73 ; 0x198d0
    ld hl, $5909
    call PrintText
    ld b, $3f
    ld a, $1c
    call Predef
    ld a, b
    and a
    jr nz, .asm_0419b ; 0x198df
    ld hl, $5913
    call PrintText
    jr .asm_79bd1 ; 0x198e7
.asm_0419b ; 0x198e9
    ld hl, $590e
    call PrintText
    ld a, $4
    ld [$d62a], a
    jr .asm_79bd1 ; 0x198f4
.asm_3e0e9 ; 0x198f6
    ld hl, $5918
    call PrintText
.asm_79bd1 ; 0x198fc
    jp $24d7

INCBIN "baserom.gbc",$198ff,$1e

VermilionCityText4: ; 0x1991d
    TX_FAR _VermilionCityText4
    db $50

VermilionCityText5: ; 0x19922
    TX_FAR _VermilionCityText5
    db $08 ; asm
    ld a, $6a
    call $13d0
    call $3748
    ld hl, $5933
    ret

;db $17, $6b, $58, $29, $50
INCBIN "baserom.gbc",$19933,$5

VermilionCityText6: ; 0x19938
    TX_FAR _VermilionCityText6
    db $50

VermilionCityText7: ; 0x1993d
    TX_FAR _VermilionCityText7
    db $50

VermilionCityText8: ; 0x19942
    TX_FAR _VermilionCityText8
    db $50

VermilionCityText11: ; 0x19947
    TX_FAR _VermilionCityText11
    db $50

VermilionCityText12: ; 0x1994c
    TX_FAR _VermilionCityText12
    db $50

VermilionCityText13: ; 0x19951
    TX_FAR _VermilionCityText13
    db $50

INCBIN "baserom.gbc",$19956,$1998a - $19956

CeladonCityText1: ; 0x1998a
    TX_FAR _CeladonCityText1
    db $50

CeladonCityText2: ; 0x1998f
    TX_FAR _CeladonCityText2
    db $50

CeladonCityText3: ; 0x19994
    TX_FAR _CeladonCityText3
    db $50

CeladonCityText4: ; 0x19999
    TX_FAR _CeladonCityText4
    db $50

CeladonCityText5: ; 0x1999e
    db $08 ; asm
    ld a, [$d777]
    bit 0, a
    jr nz, .asm_7053f ; 0x199a4
    ld hl, $59d2
    call PrintText
    ld bc,(TM_41 << 8) | 1
    call $3e2e
    jr c, .asm_890ec ; 0x199b2
    ld hl, $59e2
    call PrintText
    jr .asm_c765a ; 0x199ba
.asm_890ec ; 0x199bc
    ld hl, $59d7
    call PrintText
    ld hl, $d777
    set 0, [hl]
    jr .asm_c765a ; 0x199c7
.asm_7053f ; 0x199c9
    ld hl, $59dd
    call PrintText
.asm_c765a ; 0x199cf
    jp $24d7

INCBIN "baserom.gbc",$199d2,$15

CeladonCityText6: ; 0x199e7
    TX_FAR _CeladonCityText6
    db $50

CeladonCityText7: ; 0x199ec
    TX_FAR _CeladonCityText7
    db $08 ; asm
    ld a, $6f
    call $13d0
    jp $24d7

CeladonCityText8: ; 0x199f9
    TX_FAR _CeladonCityText8
    db $50

CeladonCityText9: ; 0x199fe
    TX_FAR _CeladonCityText9
    db $50

CeladonCityText10: ; 0x19a03
    TX_FAR _CeladonCityText10
    db $50

CeladonCityText11: ; 0x19a08
    TX_FAR _CeladonCityText11
    db $50

CeladonCityText13: ; 0x19a0d
    TX_FAR _CeladonCityText13
    db $50

CeladonCityText14: ; 0x19a12
    TX_FAR _CeladonCityText14
    db $50

CeladonCityText15: ; 0x19a17
    TX_FAR _CeladonCityText15
    db $50

CeladonCityText16: ; 0x19a1c
    TX_FAR _CeladonCityText16
    db $50

CeladonCityText17: ; 0x19a21
    TX_FAR _CeladonCityText17
    db $50

CeladonCityText18: ; 0x19a26
    TX_FAR _CeladonCityText18
    db $50

INCBIN "baserom.gbc",$19a2b,$19a5e - $19a2b

FuchsiaCityText1: ; 0x19a5e
    TX_FAR _FuchsiaCityText1
    db $50

FuchsiaCityText2: ; 0x19a63
    TX_FAR _FuchsiaCityText2
    db $50

FuchsiaCityText3: ; 0x19a68
    TX_FAR _FuchsiaCityText3
    db $50

FuchsiaCityText4: ; 0x19a6d
    TX_FAR _FuchsiaCityText4
    db $50


FuchsiaCityText5: ; 0x19a72
FuchsiaCityText6:
FuchsiaCityText7:
FuchsiaCityText8:
FuchsiaCityText9:
FuchsiaCityText10: ; 0x19a72
    TX_FAR _FuchsiaCityText5
    db $50

FuchsiaCityText11: ; 0x19a77
    TX_FAR _FuchsiaCityText11
    db $50

FuchsiaCityText13: ; 0x19a7c
    TX_FAR _FuchsiaCityText13
    db $50

FuchsiaCityText16: ; 0x19a81
    TX_FAR _FuchsiaCityText16
    db $50

FuchsiaCityText17: ; 0x19a86
    TX_FAR _FuchsiaCityText17
    db $50

FuchsiaCityText18: ; 0x19a8b
    TX_FAR _FuchsiaCityText18
    db $50

FuchsiaCityText19: ; 0x19a90
    db $08 ; asm
    ld hl, $5a9f
    call PrintText
    ld a, $28
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$19a9f,$19aa4 - $19a9f
FuchsiaCityText20: ; 0x19aa4
    db $08 ; asm
    ld hl, $5ab3
    call PrintText
    ld a, $6
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$19ab3,$19ab8 - $19ab3
FuchsiaCityText21: ; 0x19ab8
    db $08 ; asm
    ld hl, $5ac7
    call PrintText
    ld a, $2
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$19ac7,$19acc - $19ac7
FuchsiaCityText22: ; 0x19acc
    db $08 ; asm
    ld hl, $5adb
    call PrintText
    ld a, $25
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$19adb,$19ae0 - $19adb
FuchsiaCityText23: ; 0x19ae0
    db $08 ; asm
    ld hl, $5aef
    call PrintText
    ld a, $13
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$19aef,$19af4 - $19aef
FuchsiaCityText24: ; 0x19af4
    db $08 ; asm
    ld a, [$d7f6]
    bit 6, a
    jr nz, .asm_3b4e8 ; 0x19afa
    bit 7, a
    jr nz, .asm_667d5 ; 0x19afe
    ld hl, $5b2a
    call PrintText
    jr .asm_4343f ; 0x19b06
.asm_3b4e8 ; 0x19b08
    ld hl, $5b20
    call PrintText
    ld a, $62
    jr .asm_81556 ; 0x19b10
.asm_667d5 ; 0x19b12
    ld hl, $5b25
    call PrintText
    ld a, $5a
.asm_81556 ; 0x19b1a
    call $349b
.asm_4343f ; 0x19b1d
    jp $24d7

INCBIN "baserom.gbc",$19b20,$f

BluesHouse_h: ; 0x19b2f
	db $08 ; tileset
	db $04,$04 ; dimensions
	dw BluesHouseBlocks,BluesHouseTexts,BluesHouseScript
	db 0
	dw BluesHouseObject

BluesHouseScript:
	call $3C3C
	ld hl,BluesHouseScriptPointers
	ld a,[$D5F3]
	jp $3D97

BluesHouseScriptPointers:
	dw BluesHouseScript1,BluesHouseScript2

BluesHouseScript1:
	ld hl,$D74A
	set 1,[hl]

	; trigger the next script
	ld a,1
	ld [$D5F3],a
	ret

BluesHouseScript2:
	ret

BluesHouseTexts: ; 0x19B57
	dw BluesHouseText1,BluesHouseText2,BluesHouseText3

BluesHouseText1: ; 5B5D 0x19B5D
	db 8
	ld a,[$D74A]
	bit 0,a
	jr nz,.GotMap\@
	ld a,[$D74B]
	bit 5,a
	jr nz,.GiveMap\@
	ld hl,DaisyInitialText
	call PrintText
	jr .done\@
.GiveMap\@
	ld hl,DaisyOfferMapText
	call PrintText
	ld bc,(TOWN_MAP << 8) | 1
	call $3E2E
	jr nc,.BagFull\@
	ld a,$29
	ld [$CC4D],a
	ld a,$11
	call Predef ; hide table map object
	ld hl,GotMapText
	call PrintText
	ld hl,$D74A
	set 0,[hl]
	jr .done\@
.GotMap\@
	ld hl,DaisyUseMapText
	call PrintText
	jr .done\@
.BagFull\@
	ld hl,DaisyBagFullText
	call PrintText
.done\@
	jp $24D7

DaisyInitialText:
	TX_FAR _DaisyInitialText
	db "@"
DaisyOfferMapText:
	TX_FAR _DaisyOfferMapText
	db "@"
GotMapText:
	TX_FAR _GotMapText
	db $11,"@"
DaisyBagFullText:
	TX_FAR _DaisyBagFullText
	db "@"
DaisyUseMapText:
	TX_FAR _DaisyUseMapText
	db "@"
BluesHouseText2: ; Daisy, walking around
	TX_FAR _BluesHouseText2
	db "@"
BluesHouseText3: ; map on table
	TX_FAR _BluesHouseText3
	db "@"

BluesHouseObject:
	db $0A ; border tile

	db 2 ; warps
	db 7,2,1,$FF
	db 7,3,1,$FF

	db 0 ; signs

	db 3 ; people
	db $11,4+3,4+2,$FF,$D3,1 ; Daisy, sitting by map
	db $11,4+4,4+6,$FE,1,ITEM|2,0 ; map on table
	db $41,4+3,4+3,$FF,$FF,ITEM|3,0 ; Daisy, walking around

	; warp-to
	dw $C712
	db 7,2

	dw $C712
	db 7,3

BluesHouseBlocks:
	INCBIN "maps/blueshouse.blk"

VermilionHouse3_h: ; 0x19c06 to 0x19c12 (12 bytes) (bank=6) (id=196)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw VermilionHouse3Blocks, $5c15, $5c12 ; blocks, texts, scripts
    db $00 ; connections

    dw $5c25 ; objects

INCBIN "baserom.gbc",$19c12,$19c17 - $19c12
VermilionHouse3Text1: ; 0x19c17
    db $08 ; asm
    ld a, $4
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

VermilionHouse3Object: ; 0x19c25 (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $7, $ff
    db $7, $3, $7, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_LITTLE_GIRL, $5 + 4, $3 + 4, $ff, $d1, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

VermilionHouse3Blocks: ; 16
    INCBIN "maps/vermilionhouse3.blk"

IndigoPlateauLobby_h: ; 0x19c4f to 0x19c5b (12 bytes) (bank=6) (id=174)
    db $02 ; tileset
    db $06, $08 ; dimensions (y, x)
    dw IndigoPlateauLobbyBlocks, $5c7f, $5c5b ; blocks, texts, scripts
    db $00 ; connections

    dw $5c95 ; objects

INCBIN "baserom.gbc",$19c5b,$19c8a - $19c5b

IndigoPlateauLobbyText1: ; 0x19c8a
    TX_FAR _IndigoPlateauLobbyText1

INCBIN "baserom.gbc",$19c8a+4,$19c95 - ($19c8a+4)

IndigoPlateauLobbyObject: ; 0x19c95 (size=58)
    db $0 ; border tile

    db $3 ; warps
    db $b, $7, $0, $ff
    db $b, $8, $1, $ff
    db $0, $8, $0, LORELEIS_ROOM

    db $0 ; signs

    db $5 ; people
    db SPRITE_NURSE, $5 + 4, $7 + 4, $ff, $d0, $1 ; person
    db SPRITE_GYM_HELPER, $9 + 4, $4 + 4, $ff, $d3, $2 ; person
    db SPRITE_LASS, $1 + 4, $5 + 4, $ff, $d0, $3 ; person
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $4 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $6 + 4, $d + 4, $ff, $d0, $5 ; person

    ; warp-to
    EVENT_DISP $8, $b, $7
    EVENT_DISP $8, $b, $8
    EVENT_DISP $8, $0, $8 ; LORELEIS_ROOM

IndigoPlateauLobbyBlocks: ; 48
    INCBIN "maps/indigoplateaulobby.blk"

SilphCo4_h: ; 0x19cff to 0x19d0b (12 bytes) (bank=6) (id=209)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SilphCo4Blocks, $5da0, $5d0b ; blocks, texts, scripts
    db $00 ; connections

    dw $5e35 ; objects

INCBIN "baserom.gbc",$19d0b,$19dd3 - $19d0b
SilphCo4Text1: ; 0x19dd3
    db $08 ; asm
    ld hl, $5de0
    ld de, $5de5
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$19de0,$19dea - $19de0
SilphCo4Text2: ; 0x19dea
    db $08 ; asm
    ld hl, $5dae
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$19df4,$19e03 - $19df4
SilphCo4Text3: ; 0x19e03
    db $08 ; asm
    ld hl, $5dba
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$19e0d,$19e1c - $19e0d
SilphCo4Text4: ; 0x19e1c
    db $08 ; asm
    ld hl, $5dc6
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$19e26,$f
SilphCo4Object: ; 0x19e35 (size=111)
    db $2e ; border tile

    db $7 ; warps
    db $0, $18, $1, SILPH_CO_3F
    db $0, $1a, $1, SILPH_CO_5F
    db $0, $14, $0, SILPH_CO_ELEVATOR
    db $7, $b, $3, SILPH_CO_10F
    db $3, $11, $3, SILPH_CO_6F
    db $f, $3, $4, SILPH_CO_10F
    db $b, $11, $5, SILPH_CO_10F

    db $0 ; signs

    db $7 ; people
    db SPRITE_LAPRAS_GIVER, $2 + 4, $6 + 4, $ff, $ff, $1 ; person
    db SPRITE_ROCKET, $e + 4, $9 + 4, $ff, $d3, $42, ROCKET + $C8, $1a ; trainer
    db SPRITE_OAK_AIDE, $6 + 4, $e + 4, $ff, $d2, $43, SCIENTIST + $C8, $5 ; trainer
    db SPRITE_ROCKET, $a + 4, $1a + 4, $ff, $d1, $44, ROCKET + $C8, $1b ; trainer
	db SPRITE_BALL, $9 + 4, $3 + 4, $ff, $ff, $85, FULL_HEAL ; item
	db SPRITE_BALL, $7 + 4, $4 + 4, $ff, $ff, $86, MAX_REVIVE ; item
	db SPRITE_BALL, $8 + 4, $5 + 4, $ff, $ff, $87, ESCAPE_ROPE ; item

    ; warp-to
    EVENT_DISP $f, $0, $18 ; SILPH_CO_3F
    EVENT_DISP $f, $0, $1a ; SILPH_CO_5F
    EVENT_DISP $f, $0, $14 ; SILPH_CO_ELEVATOR
    EVENT_DISP $f, $7, $b ; SILPH_CO_10F
    EVENT_DISP $f, $3, $11 ; SILPH_CO_6F
    EVENT_DISP $f, $f, $3 ; SILPH_CO_10F
    EVENT_DISP $f, $b, $11 ; SILPH_CO_10F

SilphCo4Blocks: ; 135
    INCBIN "maps/silphco4.blk"

SilphCo5_h: ; 0x19f2b to 0x19f37 (12 bytes) (bank=6) (id=210)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SilphCo5Blocks, $5fbc, $5f37 ; blocks, texts, scripts
    db $00 ; connections

    dw $608d ; objects

INCBIN "baserom.gbc",$19f37,$1a003 - $19f37
SilphCo5Text1: ; 0x1a003
    db $08 ; asm
    ld hl, $6010
    ld de, $6015
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a010,$1a01a - $1a010
SilphCo5Text2: ; 0x1a01a
    db $08 ; asm
    ld hl, $5fd2
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a024,$1a033 - $1a024
SilphCo5Text3: ; 0x1a033
    db $08 ; asm
    ld hl, $5fde
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a03d,$1a04c - $1a03d
SilphCo5Text4: ; 0x1a04c
    db $08 ; asm
    ld hl, $5fea
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a056,$1a065 - $1a056
SilphCo5Text5: ; 0x1a065
    db $08 ; asm
    ld hl, $5ff6
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a06f,$f

SilphCo5Text9: ; 0x1a07e
    TX_FAR _SilphCo5Text9
    db $50

SilphCo5Text10: ; 0x1a083
    TX_FAR _SilphCo5Text10
    db $50

SilphCo5Text11: ; 0x1a088
    TX_FAR _SilphCo5Text11
    db $50

SilphCo5Object: ; 0x1a08d (size=137)
    db $2e ; border tile

    db $7 ; warps
    db $0, $18, $1, SILPH_CO_6F
    db $0, $1a, $1, SILPH_CO_4F
    db $0, $14, $0, SILPH_CO_ELEVATOR
    db $3, $1b, $5, SILPH_CO_7F
    db $f, $9, $4, SILPH_CO_9F
    db $5, $b, $4, SILPH_CO_3F
    db $f, $3, $5, SILPH_CO_3F

    db $0 ; signs

    db $b ; people
    db SPRITE_LAPRAS_GIVER, $9 + 4, $d + 4, $ff, $ff, $1 ; person
    db SPRITE_ROCKET, $10 + 4, $8 + 4, $ff, $d3, $42, ROCKET + $C8, $1c ; trainer
    db SPRITE_OAK_AIDE, $3 + 4, $8 + 4, $ff, $d3, $43, SCIENTIST + $C8, $6 ; trainer
    db SPRITE_ROCKER, $a + 4, $12 + 4, $ff, $d1, $44, JUGGLER + $C8, $1 ; trainer
    db SPRITE_ROCKET, $4 + 4, $1c + 4, $ff, $d1, $45, ROCKET + $C8, $1d ; trainer
	db SPRITE_BALL, $d + 4, $2 + 4, $ff, $ff, $86, TM_09 ; item
	db SPRITE_BALL, $6 + 4, $4 + 4, $ff, $ff, $87, PROTEIN ; item
	db SPRITE_BALL, $10 + 4, $15 + 4, $ff, $ff, $88, CARD_KEY ; item
    db SPRITE_CLIPBOARD, $c + 4, $16 + 4, $ff, $ff, $9 ; person
    db SPRITE_CLIPBOARD, $a + 4, $19 + 4, $ff, $ff, $a ; person
    db SPRITE_CLIPBOARD, $6 + 4, $18 + 4, $ff, $ff, $b ; person

    ; warp-to
    EVENT_DISP $f, $0, $18 ; SILPH_CO_6F
    EVENT_DISP $f, $0, $1a ; SILPH_CO_4F
    EVENT_DISP $f, $0, $14 ; SILPH_CO_ELEVATOR
    EVENT_DISP $f, $3, $1b ; SILPH_CO_7F
    EVENT_DISP $f, $f, $9 ; SILPH_CO_9F
    EVENT_DISP $f, $5, $b ; SILPH_CO_3F
    EVENT_DISP $f, $f, $3 ; SILPH_CO_3F

SilphCo5Blocks: ; 135
    INCBIN "maps/silphco5.blk"

SilphCo6_h: ; 0x1a19d to 0x1a1a9 (12 bytes) (bank=6) (id=211)
    db $16 ; tileset
    db $09, $0d ; dimensions (y, x)
    dw SilphCo6Blocks, $61f6, $61a9 ; blocks, texts, scripts
    db $00 ; connections

    dw $62fb ; objects

INCBIN "baserom.gbc",$1a1a9,$1a23d - $1a1a9
SilphCo6Text1: ; 0x1a23d
    db $08 ; asm
    ld hl, $624a
    ld de, $624f
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a24a,$1a254 - $1a24a
SilphCo6Text2: ; 0x1a254
    db $08 ; asm
    ld hl, $6261
    ld de, $6266
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a261,$1a26b - $1a261
SilphCo6Text3: ; 0x1a26b
    db $08 ; asm
    ld hl, $6278
    ld de, $627d
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a278,$1a282 - $1a278
SilphCo6Text4: ; 0x1a282
    db $08 ; asm
    ld hl, $628f
    ld de, $6294
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a28f,$1a299 - $1a28f
SilphCo6Text5: ; 0x1a299
    db $08 ; asm
    ld hl, $62a6
    ld de, $62ab
    call $622f
    jp $24d7

INCBIN "baserom.gbc",$1a2a6,$1a2b0 - $1a2a6
SilphCo6Text6: ; 0x1a2b0
    db $08 ; asm
    ld hl, $620a
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a2ba,$1a2c9 - $1a2ba
SilphCo6Text7: ; 0x1a2c9
    db $08 ; asm
    ld hl, $6216
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a2d3,$1a2e2 - $1a2d3
SilphCo6Text8: ; 0x1a2e2
    db $08 ; asm
    ld hl, $6222
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$1a2ec,$f
SilphCo6Object: ; 0x1a2fb (size=112)
    db $2e ; border tile

    db $5 ; warps
    db $0, $10, $1, SILPH_CO_7F
    db $0, $e, $0, SILPH_CO_5F
    db $0, $12, $0, SILPH_CO_ELEVATOR
    db $3, $3, $4, SILPH_CO_4F
    db $3, $17, $6, SILPH_CO_2F

    db $0 ; signs

    db $a ; people
    db SPRITE_LAPRAS_GIVER, $6 + 4, $a + 4, $ff, $ff, $1 ; person
    db SPRITE_LAPRAS_GIVER, $6 + 4, $14 + 4, $ff, $ff, $2 ; person
    db SPRITE_ERIKA, $6 + 4, $15 + 4, $ff, $d0, $3 ; person
    db SPRITE_ERIKA, $a + 4, $b + 4, $ff, $d3, $4 ; person
    db SPRITE_LAPRAS_GIVER, $d + 4, $12 + 4, $ff, $d1, $5 ; person
    db SPRITE_ROCKET, $3 + 4, $11 + 4, $ff, $d3, $46, ROCKET + $C8, $1e ; trainer
    db SPRITE_OAK_AIDE, $8 + 4, $7 + 4, $ff, $d0, $47, SCIENTIST + $C8, $7 ; trainer
    db SPRITE_ROCKET, $f + 4, $e + 4, $ff, $d2, $48, ROCKET + $C8, $1f ; trainer
	db SPRITE_BALL, $c + 4, $3 + 4, $ff, $ff, $89, HP_UP ; item
	db SPRITE_BALL, $f + 4, $2 + 4, $ff, $ff, $8a, X_ACCURACY ; item

    ; warp-to
    EVENT_DISP $d, $0, $10 ; SILPH_CO_7F
    EVENT_DISP $d, $0, $e ; SILPH_CO_5F
    EVENT_DISP $d, $0, $12 ; SILPH_CO_ELEVATOR
    EVENT_DISP $d, $3, $3 ; SILPH_CO_4F
    EVENT_DISP $d, $3, $17 ; SILPH_CO_2F

SilphCo6Blocks: ; 117
    INCBIN "maps/silphco6.blk"

INCBIN "baserom.gbc",$1a3e0,$1c20

SECTION "bank7",DATA,BANK[$7]

CinnabarIsland_h: ; 0x1c000 to 0x1c022 (34 bytes) (bank=7) (id=8)
    db $00 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw CinnabarIslandBlocks, $4a81, $4a19 ; blocks, texts, scripts
    db NORTH | EAST ; connections

    ; connections data

	db ROUTE_21
    dw $5211, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $59, $00 ; alignments (y, x)
    dw $c9b9 ; window

	db ROUTE_20
    dw $417d, $c725 ; pointers (connected, current) (strip)
    db $09, $32 ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c721 ; window

    ; end connection data

    dw $4022 ; objects

CinnabarIslandObject: ; 0x1c022 (size=71)
    db $43 ; border tile

    db $5 ; warps
    db $3, $6, $1, MANSION_1
    db $3, $12, $0, CINNABAR_GYM
    db $9, $6, $0, CINNABAR_LAB_1
    db $b, $b, $0, CINNABAR_POKECENTER
    db $b, $f, $0, CINNABAR_MART

    db $5 ; signs
    db $5, $9, $3 ; CinnabarIslandText3
    db $b, $10, $4 ; CinnabarIslandText4
    db $b, $c, $5 ; CinnabarIslandText5
    db $b, $9, $6 ; CinnabarIslandText6
    db $3, $d, $7 ; CinnabarIslandText7

    db $2 ; people
    db SPRITE_GIRL, $5 + 4, $c + 4, $fe, $2, $1 ; person
    db SPRITE_GAMBLER, $6 + 4, $e + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $a, $3, $6 ; MANSION_1
    EVENT_DISP $a, $3, $12 ; CINNABAR_GYM
    EVENT_DISP $a, $9, $6 ; CINNABAR_LAB_1
    EVENT_DISP $a, $b, $b ; CINNABAR_POKECENTER
    EVENT_DISP $a, $b, $f ; CINNABAR_MART

CinnabarIslandBlocks: ; 90
    INCBIN "maps/cinnabarisland.blk"

Route1_h: ; 0x1c0c3 to 0x1c0e5 (34 bytes) (bank=7) (id=12)
    db $00 ; tileset
    db $12, $0a ; dimensions (y, x)
    dw Route1Blocks, $4ab2, $4aaf ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db VIRIDIAN_CITY
    dw $451a, $c6e8 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $23, $0a ; alignments (y, x)
    dw $c8bd ; window

	db PALLET_TOWN
    dw $42fd, $c83b ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $40e5 ; objects

Route1Object: ; 0x1c0e5 (size=19)
    db $b ; border tile

    db $0 ; warps

    db $1 ; signs
    db $1b, $9, $3 ; Route1Text3

    db $2 ; people
    db SPRITE_BUG_CATCHER, $18 + 4, $5 + 4, $fe, $1, $1 ; person
    db SPRITE_BUG_CATCHER, $d + 4, $f + 4, $fe, $2, $2 ; person

INCBIN "baserom.gbc",$1c0f8,$4

Route1Blocks: ; 180
    INCBIN "maps/route1.blk"

UndergroundPathEntranceRoute8Blocks: ; 16
    INCBIN "maps/undergroundpathentranceroute8.blk"

OaksLabBlocks: ; 30
    INCBIN "maps/oakslab.blk"

ViridianHouseBlocks: ; 16
    INCBIN "maps/viridianhouse.blk"

SchoolBlocks: ; 16
    INCBIN "maps/school.blk"

CeruleanHouseTrashedBlocks: ; 16
    INCBIN "maps/ceruleanhousetrashed.blk"

DiglettsCaveRoute2Blocks: ; 16
    INCBIN "maps/diglettscaveroute2.blk"

MonsterNames: ; 421E
	db "RHYDON@@@@"
	db "KANGASKHAN"
	db "NIDORAN♂@@"
	db "CLEFAIRY@@"
	db "SPEAROW@@@"
	db "VOLTORB@@@"
	db "NIDOKING@@"
	db "SLOWBRO@@@"
	db "IVYSAUR@@@"
	db "EXEGGUTOR@"
	db "LICKITUNG@"
	db "EXEGGCUTE@"
	db "GRIMER@@@@"
	db "GENGAR@@@@"
	db "NIDORAN♀@@"
	db "NIDOQUEEN@"
	db "CUBONE@@@@"
	db "RHYHORN@@@"
	db "LAPRAS@@@@"
	db "ARCANINE@@"
	db "MEW@@@@@@@"
	db "GYARADOS@@"
	db "SHELLDER@@"
	db "TENTACOOL@"
	db "GASTLY@@@@"
	db "SCYTHER@@@"
	db "STARYU@@@@"
	db "BLASTOISE@"
	db "PINSIR@@@@"
	db "TANGELA@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "GROWLITHE@"
	db "ONIX@@@@@@"
	db "FEAROW@@@@"
	db "PIDGEY@@@@"
	db "SLOWPOKE@@"
	db "KADABRA@@@"
	db "GRAVELER@@"
	db "CHANSEY@@@"
	db "MACHOKE@@@"
	db "MR.MIME@@@"
	db "HITMONLEE@"
	db "HITMONCHAN"
	db "ARBOK@@@@@"
	db "PARASECT@@"
	db "PSYDUCK@@@"
	db "DROWZEE@@@"
	db "GOLEM@@@@@"
	db "MISSINGNO."
	db "MAGMAR@@@@"
	db "MISSINGNO."
	db "ELECTABUZZ"
	db "MAGNETON@@"
	db "KOFFING@@@"
	db "MISSINGNO."
	db "MANKEY@@@@"
	db "SEEL@@@@@@"
	db "DIGLETT@@@"
	db "TAUROS@@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "FARFETCH'D"
	db "VENONAT@@@"
	db "DRAGONITE@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "DODUO@@@@@"
	db "POLIWAG@@@"
	db "JYNX@@@@@@"
	db "MOLTRES@@@"
	db "ARTICUNO@@"
	db "ZAPDOS@@@@"
	db "DITTO@@@@@"
	db "MEOWTH@@@@"
	db "KRABBY@@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "VULPIX@@@@"
	db "NINETALES@"
	db "PIKACHU@@@"
	db "RAICHU@@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "DRATINI@@@"
	db "DRAGONAIR@"
	db "KABUTO@@@@"
	db "KABUTOPS@@"
	db "HORSEA@@@@"
	db "SEADRA@@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "SANDSHREW@"
	db "SANDSLASH@"
	db "OMANYTE@@@"
	db "OMASTAR@@@"
	db "JIGGLYPUFF"
	db "WIGGLYTUFF"
	db "EEVEE@@@@@"
	db "FLAREON@@@"
	db "JOLTEON@@@"
	db "VAPOREON@@"
	db "MACHOP@@@@"
	db "ZUBAT@@@@@"
	db "EKANS@@@@@"
	db "PARAS@@@@@"
	db "POLIWHIRL@"
	db "POLIWRATH@"
	db "WEEDLE@@@@"
	db "KAKUNA@@@@"
	db "BEEDRILL@@"
	db "MISSINGNO."
	db "DODRIO@@@@"
	db "PRIMEAPE@@"
	db "DUGTRIO@@@"
	db "VENOMOTH@@"
	db "DEWGONG@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "CATERPIE@@"
	db "METAPOD@@@"
	db "BUTTERFREE"
	db "MACHAMP@@@"
	db "MISSINGNO."
	db "GOLDUCK@@@"
	db "HYPNO@@@@@"
	db "GOLBAT@@@@"
	db "MEWTWO@@@@"
	db "SNORLAX@@@"
	db "MAGIKARP@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MUK@@@@@@@"
	db "MISSINGNO."
	db "KINGLER@@@"
	db "CLOYSTER@@"
	db "MISSINGNO."
	db "ELECTRODE@"
	db "CLEFABLE@@"
	db "WEEZING@@@"
	db "PERSIAN@@@"
	db "MAROWAK@@@"
	db "MISSINGNO."
	db "HAUNTER@@@"
	db "ABRA@@@@@@"
	db "ALAKAZAM@@"
	db "PIDGEOTTO@"
	db "PIDGEOT@@@"
	db "STARMIE@@@"
	db "BULBASAUR@"
	db "VENUSAUR@@"
	db "TENTACRUEL"
	db "MISSINGNO."
	db "GOLDEEN@@@"
	db "SEAKING@@@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "PONYTA@@@@"
	db "RAPIDASH@@"
	db "RATTATA@@@"
	db "RATICATE@@"
	db "NIDORINO@@"
	db "NIDORINA@@"
	db "GEODUDE@@@"
	db "PORYGON@@@"
	db "AERODACTYL"
	db "MISSINGNO."
	db "MAGNEMITE@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "CHARMANDER"
	db "SQUIRTLE@@"
	db "CHARMELEON"
	db "WARTORTLE@"
	db "CHARIZARD@"
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "MISSINGNO."
	db "ODDISH@@@@"
	db "GLOOM@@@@@"
	db "VILEPLUME@"
	db "BELLSPROUT"
	db "WEEPINBELL"
	db "VICTREEBEL"

INCBIN "baserom.gbc",$1c98a,$1ca96 - $1c98a

CinnabarIslandText1: ; 0x1ca96
    TX_FAR _CinnabarIslandText1
    db $50

CinnabarIslandText2: ; 0x1ca9b
    TX_FAR _CinnabarIslandText2
    db $50

CinnabarIslandText3: ; 0x1caa0
    TX_FAR _CinnabarIslandText3
    db $50

CinnabarIslandText6: ; 0x1caa5
    TX_FAR _CinnabarIslandText6
    db $50

CinnabarIslandText7: ; 0x1caaa
    TX_FAR _CinnabarIslandText7
    db $50

INCBIN "baserom.gbc",$1caaf,$1cab8 - $1caaf
Route1Text1: ; 0x1cab8
    db $08 ; asm
    ld hl, $d7bf
    bit 0, [hl]
    set 0, [hl]
    jr nz, .asm_02840 ; 0x1cac0
    ld hl, $4ae3
    call PrintText
    ld bc, (POTION << 8) | 1
    call $3e2e
    jr nc, .asm_a630e ; 0x1cace
    ld hl, $4ae8
    jr .asm_46d43 ; 0x1cad3
.asm_a630e ; 0x1cad5
    ld hl, $4af3
    jr .asm_46d43 ; 0x1cad8
.asm_02840 ; 0x1cada
    ld hl, $4aee
.asm_46d43 ; 0x1cadd
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1cae3,$15

Route1Text2: ; 0x1caf8
    TX_FAR _Route1Text2
    db $50

Route1Text3: ; 0x1cafd
    TX_FAR _Route1Text3
    db $50

OaksLab_h: ; 0x1cb02 to 0x1cb0e (12 bytes) (bank=7) (id=40)
    db $05 ; tileset
    db $06, $05 ; dimensions (y, x)
    dw OaksLabBlocks, $5082, $4b0e ; blocks, texts, scripts
    db $00 ; connections

    dw $540a ; objects

INCBIN "baserom.gbc",$1cb0e,$1d0ce - $1cb0e
OaksLabText1: ; 0x1d0ce
    db $08 ; asm
    ld a, [$d74b]
    bit 0, a
    jr nz, .asm_6a7a2 ; 0x1d0d4
    ld hl, $50f3
    call PrintText
    jr .asm_ff2ed ; 0x1d0dc
.asm_6a7a2 ; 0x1d0de
    bit 2, a
    jr nz, .asm_56780 ; 0x1d0e0
    ld hl, $50f8
    call PrintText
    jr .asm_ff2ed ; 0x1d0e8
.asm_56780 ; 0x1d0ea
    ld hl, $50fd
    call PrintText
.asm_ff2ed ; 0x1d0f0
    jp $24d7

INCBIN "baserom.gbc",$1d0f3,$1d248 - $1d0f3
OaksLabText5: ; 0x1d248
    db $08 ; asm
    ld a, [$d747]
    bit 6, a
    jr nz, .asm_50e81 ; 0x1d24e
    ld hl, $d2f7
    ld b, $13
    call $2b7f
    ld a, [$d11e]
    cp $2
    jr c, .asm_b28b0 ; 0x1d25d
    ld a, [$d74b]
    bit 5, a
    jr z, .asm_b28b0 ; 0x1d264
.asm_50e81 ; 0x1d266
    ld hl, $531d
    call PrintText
    ld a, $1
    ld [$cc3c], a
    ld a, $56
    call Predef
    jp $52ed
.asm_b28b0 ; 0x1d279
	ld b,POKE_BALL
    call $3493
    jr nz, .asm_17c30 ; 0x1d27e
    ld a, [$d7eb]
    bit 5, a
    jr nz, .asm_f1adc ; 0x1d285
    ld a, [$d74b]
    bit 5, a
    jr nz, .asm_333a2 ; 0x1d28c
    bit 3, a
    jr nz, .asm_76269 ; 0x1d290
    ld a, [$d72e]
    bit 3, a
    jr nz, .asm_4a5e0 ; 0x1d297
    ld hl, $52f0
    call PrintText
    jr .asm_0f042 ; 0x1d29f
.asm_4a5e0 ; 0x1d2a1
    ld hl, $52f5
    call PrintText
    jr .asm_0f042 ; 0x1d2a7
.asm_76269 ; 0x1d2a9
	ld b,OAKS_PARCEL
    call $3493
    jr nz, .asm_a8fcf ; 0x1d2ae
    ld hl, $52fa
    call PrintText
    jr .asm_0f042 ; 0x1d2b6
.asm_a8fcf ; 0x1d2b8
    ld hl, $52ff
    call PrintText
    call $500a
    ld a, $f
    ld [$d5f0], a
    jr .asm_0f042 ; 0x1d2c6
.asm_333a2 ; 0x1d2c8
    ld hl, $5309
    call PrintText
    jr .asm_0f042 ; 0x1d2ce
.asm_f1adc ; 0x1d2d0
    ld hl, $d74b
    bit 4, [hl]
    set 4, [hl]
    jr nz, .asm_17c30 ; 0x1d2d7
    ld bc, (POKE_BALL << 8) | 5
    call $3e2e
    ld hl, $530e
    call PrintText
    jr .asm_0f042 ; 0x1d2e5
.asm_17c30 ; 0x1d2e7
    ld hl, $5318
    call PrintText
.asm_0f042 ; 0x1d2ed
    jp $24d7

INCBIN "baserom.gbc",$1d2f0,$1d322 - $1d2f0
OaksLabText6: ; 0x1d322
    db $08 ; asm
    ld hl, $532c
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1d32c,$5

OaksLabText8: ; 0x1d331
    TX_FAR _OaksLabText8
    db $50

OaksLabText9: ; 0x1d336
    db $08 ; asm
    ld hl, $5340
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1d340,$1d3fb - $1d340
OaksLabText10: ; 0x1d3fb
    db $08 ; asm
    ld hl, $5405
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1d405,$5
OaksLabObject: ; 0x1d40a (size=88)
    db $3 ; border tile

    db $2 ; warps
    db $b, $4, $2, $ff
    db $b, $5, $2, $ff

    db $0 ; signs

    db $b ; people
    db SPRITE_BLUE, $3 + 4, $4 + 4, $ff, $ff, $41, SONY1 + $C8, $1 ; trainer
    db SPRITE_BALL, $3 + 4, $6 + 4, $ff, $ff, $2 ; person
    db SPRITE_BALL, $3 + 4, $7 + 4, $ff, $ff, $3 ; person
    db SPRITE_BALL, $3 + 4, $8 + 4, $ff, $ff, $4 ; person
    db SPRITE_OAK, $2 + 4, $5 + 4, $ff, $d0, $5 ; person
    db SPRITE_BOOK_MAP_DEX, $1 + 4, $2 + 4, $ff, $ff, $6 ; person
    db SPRITE_BOOK_MAP_DEX, $1 + 4, $3 + 4, $ff, $ff, $7 ; person
    db SPRITE_OAK, $a + 4, $5 + 4, $ff, $d1, $8 ; person
    db SPRITE_GIRL, $9 + 4, $1 + 4, $fe, $1, $9 ; person
    db SPRITE_OAK_AIDE, $a + 4, $2 + 4, $ff, $ff, $a ; person
    db SPRITE_OAK_AIDE, $a + 4, $8 + 4, $ff, $ff, $b ; person

    ; warp-to
    EVENT_DISP $5, $b, $4
    EVENT_DISP $5, $b, $5

ViridianMart_h: ; 0x1d462 to 0x1d46e (12 bytes) (bank=7) (id=42)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw ViridianMartBlocks, $54e0, $546e ; blocks, texts, scripts
    db $00 ; connections

    dw $550a ; objects

INCBIN "baserom.gbc",$1d46e,$1d4e0 - $1d46e
ViridianMartTexts: ; 0x1d4e0
    dw ViridianMartText1, ViridianMartText2, ViridianMartText3
INCBIN "baserom.gbc",$1d4e6,$a

ViridianMartText1: ; 0x1d4f0
    TX_FAR _ViridianMartText1
    db $50

INCBIN "baserom.gbc",$1d4f5,$1d500 - $1d4f5

ViridianMartText2: ; 0x1d500
    TX_FAR _ViridianMartText2
    db $50

ViridianMartText3: ; 0x1d505
    TX_FAR _ViridianMartText3
    db $50

ViridianMartObject: ; 0x1d50a (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $1, $ff
    db $7, $4, $1, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BUG_CATCHER, $5 + 4, $5 + 4, $fe, $1, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $3 + 4, $3 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

ViridianMartBlocks: ; 16
    INCBIN "maps/viridianmart.blk"

School_h: ; 0x1d540 to 0x1d54c (12 bytes) (bank=7) (id=43)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw SchoolBlocks, $554f, $554c ; blocks, texts, scripts
    db $00 ; connections

    dw $555d ; objects

INCBIN "baserom.gbc",$1d54c,$1d54f - $1d54c
SchoolTexts: ; 0x1d54f
    dw SchoolText1, SchoolText2

SchoolText1: ; 0x1d553
    TX_FAR _SchoolText1
    db $50

SchoolText2: ; 0x1d558
    TX_FAR _SchoolText2
    db $50

SchoolObject: ; 0x1d55d (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $2, $ff
    db $7, $3, $2, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_BRUNETTE_GIRL, $5 + 4, $3 + 4, $ff, $d1, $1 ; person
    db SPRITE_LASS, $1 + 4, $4 + 4, $ff, $d0, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

ViridianHouse_h: ; 0x1d57d to 0x1d589 (12 bytes) (bank=7) (id=44)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw ViridianHouseBlocks, $558d, $558a ; blocks, texts, scripts
    db $00 ; connections

    dw $55bb ; objects

INCBIN "baserom.gbc",$1d589,$1d595 - $1d589

ViridianHouseText1: ; 0x1d595
    TX_FAR _ViridianHouseText1
    db $50

ViridianHouseText2: ; 0x1d59a
    TX_FAR _ViridianHouseText2
    db $50

ViridianHouseText3: ; 0x1d59f
    db $08 ; asm
    ld hl, $55b1
    call PrintText
	ld a,SPEAROW
    call $13d0
    call $3748
    jp $24d7

INCBIN "baserom.gbc",$1d5b1,$5

ViridianHouseText4: ; 0x1d5b6
    TX_FAR _ViridianHouseText4
    db $50

ViridianHouseObject: ; 0x1d5bb (size=44)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $3, $ff
    db $7, $3, $3, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_BALDING_GUY, $3 + 4, $5 + 4, $ff, $ff, $1 ; person
    db SPRITE_LITTLE_GIRL, $4 + 4, $1 + 4, $fe, $1, $2 ; person
    db SPRITE_BIRD, $5 + 4, $5 + 4, $fe, $2, $3 ; person
    db SPRITE_CLIPBOARD, $0 + 4, $4 + 4, $ff, $ff, $4 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

PewterHouse1_h: ; 0x1d5e7 to 0x1d5f3 (12 bytes) (bank=7) (id=55)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $55f6, $55f3 ; blocks, texts, scripts
    db $00 ; connections

    dw $5616 ; objects

INCBIN "baserom.gbc",$1d5f3,$1d5f6 - $1d5f3
PewterHouse1Texts: ; 0x1d5f6
    dw PewterHouse1Text1, PewterHouse1Text2, PewterHouse1Text3

PewterHouse1Text1: ; 0x1d5fc
    TX_FAR _PewterHouse1Text1
    db $08 ; asm
    ld a, $3
    call $13d0
    call $3748
    jp $24d7

PewterHouse1Text2: ; 0x1d60c
    TX_FAR _PewterHouse1Text2
    db $50

PewterHouse1Text3: ; 0x1d611
    TX_FAR _PewterHouse1Text3
    db $50

PewterHouse1Object: ; 0x1d616 (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $3, $ff
    db $7, $3, $3, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_SLOWBRO, $5 + 4, $4 + 4, $ff, $d2, $1 ; person
    db SPRITE_YOUNG_BOY, $5 + 4, $3 + 4, $ff, $d3, $2 ; person
    db SPRITE_FAT_BALD_GUY, $2 + 4, $1 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

PewterHouse2_h: ; 0x1d63c to 0x1d648 (12 bytes) (bank=7) (id=57)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $564b, $5648 ; blocks, texts, scripts
    db $00 ; connections

    dw $5659 ; objects

INCBIN "baserom.gbc",$1d648,$1d64b - $1d648
PewterHouse2Texts: ; 0x1d64b
    dw PewterHouse2Text1, PewterHouse2Text2

PewterHouse2Text1: ; 0x1d64f
    TX_FAR _PewterHouse2Text1
    db $50

PewterHouse2Text2: ; 0x1d654
    TX_FAR _PewterHouse2Text2
    db $50

PewterHouse2Object: ; 0x1d659 (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $5, $ff
    db $7, $3, $5, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_GAMBLER, $3 + 4, $2 + 4, $ff, $d3, $1 ; person
    db SPRITE_BUG_CATCHER, $5 + 4, $4 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

CeruleanHouseTrashed_h: ; 0x1d679 to 0x1d685 (12 bytes) (bank=7) (id=62)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw CeruleanHouseTrashedBlocks, $5689, $5685 ; blocks, texts, scripts
    db $00 ; connections

    dw $56bf ; objects

INCBIN "baserom.gbc",$1d685,$1d68f - $1d685
CeruleanHouseTrashedText1: ; 0x1d68f
    db $08 ; asm
    ld b, $e4
    ld a, $1c
    call Predef
    and b
    jr z, .asm_f8734 ; 0x1d698
    ld hl, $56b0
    call PrintText
    jr .asm_8dfe9 ; 0x1d6a0
.asm_f8734 ; 0x1d6a2
    ld hl, $56ab
    call PrintText
.asm_8dfe9 ; 0x1d6a8
    jp $24d7

INCBIN "baserom.gbc",$1d6ab,$a

CeruleanHouseTrashedText2: ; 0x1d6b5
    TX_FAR _CeruleanHouseTrashedText2
    db $50

CeruleanHouseTrashedText3: ; 0x1d6ba
    TX_FAR _CeruleanHouseTrashedText3
    db $50

CeruleanHouseTrashedObject: ; 0x1d6bf (size=43)
    db $a ; border tile

    db $3 ; warps
    db $7, $2, $0, $ff
    db $7, $3, $0, $ff
    db $0, $3, $7, $ff

    db $1 ; signs
    db $0, $3, $3 ; CeruleanHouseTrashedText3

    db $2 ; people
    db SPRITE_FISHER, $1 + 4, $2 + 4, $ff, $d0, $1 ; person
    db SPRITE_GIRL, $6 + 4, $5 + 4, $fe, $2, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $0, $3

CeruleanHouse2_h: ; 0x1d6ea to 0x1d6f6 (12 bytes) (bank=7) (id=63)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $56f9, $56f6 ; blocks, texts, scripts
    db $00 ; connections

    dw $5710 ; objects

INCBIN "baserom.gbc",$1d6f6,$1d6fd - $1d6f6

CeruleanHouse2Text1: ; 0x1d6fd
    TX_FAR _CeruleanHouse2Text1
    db $50

CeruleanHouse2Text2: ; 0x1d702
    db $08 ; asm
    ld a, $6
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

CeruleanHouse2Object: ; 0x1d710 (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $1, $ff
    db $7, $3, $1, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_OLD_MEDIUM_WOMAN, $4 + 4, $5 + 4, $ff, $d2, $1 ; person
    db SPRITE_GAMBLER, $2 + 4, $1 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

BikeShop_h: ; 0x1d730 to 0x1d73c (12 bytes) (bank=7) (id=66)
    db $15 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw BikeShopBlocks, $573f, $573c ; blocks, texts, scripts
    db $00 ; connections

    dw $5866 ; objects

INCBIN "baserom.gbc",$1d73c,$1d745 - $1d73c
BikeShopText1: ; 0x1d745
    db $08 ; asm
    ld a, [$d75f]
    bit 0, a
    jr z, .asm_260d4 ; 0x1d74b
    ld hl, $582f
    call PrintText
    jp $57f5
.asm_260d4 ; 0x1d756
	ld b,BIKE_VOUCHER
    call $3493
    jr z, .asm_41190 ; 0x1d75b
    ld hl, $581f
    call PrintText
    ld bc,(BICYCLE << 8) | 1
    call $3e2e
    jr nc, .asm_d0d90 ; 0x1d769
    ld a, $2d
    ldh [$db], a
    ld b, $5 ; BANK(MyFunction)
    ld hl, $7f37 ; MyFunction
    call Bankswitch
    ld hl, $d75f
    set 0, [hl]
    ld hl, $5824
    call PrintText
    jr .asm_99ef2 ; 0x1d782
.asm_d0d90 ; 0x1d784
    ld hl, $5834
    call PrintText
    jr .asm_99ef2 ; 0x1d78a
.asm_41190 ; 0x1d78c
    ld hl, $5810
    call PrintText
    xor a
    ld [$cc26], a
    ld [$cc2a], a
    ld a, $3
    ld [$cc29], a
    ld a, $1
    ld [$cc28], a
    ld a, $2
    ld [$cc24], a
    ld a, $1
    ld [$cc25], a
    ld hl, $d730
    set 6, [hl]
    ld hl, $c3a0
    ld b, $4
    ld c, $f
    call $1922
    call $2429
    ld hl, $c3ca
    ld de, $57f8
    call $1955
    ld hl, $c3e4
    ld de, $5807
    call $1955
    ld hl, $5815
    call PrintText
    call $3abe
    bit 1, a
    jr nz, .asm_b7579 ; 0x1d7dc
    ld hl, $d730
    res 6, [hl]
    ld a, [$cc26]
    and a
    jr nz, .asm_b7579 ; 0x1d7e7
    ld hl, $581a
    call PrintText
.asm_b7579 ; 0x1d7ef
    ld hl, $582a
    call PrintText
.asm_99ef2 ; 0x1d7f5
    jp $24d7

INCBIN "baserom.gbc",$1d7f8,$1d839 - $1d7f8
BikeShopText2: ; 0x1d839
    db $08 ; asm
    ld hl, $5843
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1d843,$1d848 - $1d843
BikeShopText3: ; 0x1d848
    db $08 ; asm
    ld a, [$d75f]
    bit 0, a
    ld hl, $5861
    jr nz, .asm_34d2d ; 0x1d851
    ld hl, $585c
.asm_34d2d ; 0x1d856
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1d85c,$a
BikeShopObject: ; 0x1d866 (size=38)
    db $e ; border tile

    db $2 ; warps
    db $7, $2, $4, $ff
    db $7, $3, $4, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_BIKE_SHOP_GUY, $2 + 4, $6 + 4, $ff, $ff, $1 ; person
    db SPRITE_MOM_GEISHA, $6 + 4, $5 + 4, $fe, $1, $2 ; person
    db SPRITE_BUG_CATCHER, $3 + 4, $1 + 4, $ff, $d1, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

BikeShopBlocks: ; 16
    INCBIN "maps/bikeshop.blk"

LavenderHouse1_h: ; 0x1d89c to 0x1d8a8 (12 bytes) (bank=7) (id=149)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $58ac, $58a8 ; blocks, texts, scripts
    db $00 ; connections

    dw $596a ; objects

INCBIN "baserom.gbc",$1d8a8,$1d8b8 - $1d8a8
LavenderHouse1Text1: ; 0x1d8b8
    db $08 ; asm
    ld a, [$d7e0]
    bit 7, a
    jr nz, .asm_72e5d ; 0x1d8be
    ld hl, $58d1
    call PrintText
    jr .asm_6957f ; 0x1d8c6
.asm_72e5d ; 0x1d8c8
    ld hl, $58d6
    call PrintText
.asm_6957f ; 0x1d8ce
    jp $24d7

INCBIN "baserom.gbc",$1d8d1,$1d8db - $1d8d1
LavenderHouse1Text2: ; 0x1d8db
    db $08 ; asm
    ld a, [$d7e0]
    bit 7, a
    jr nz, .asm_06470 ; 0x1d8e1
    ld hl, $58f4
    call PrintText
    jr .asm_3d208 ; 0x1d8e9
.asm_06470 ; 0x1d8eb
    ld hl, $58f9
    call PrintText
.asm_3d208 ; 0x1d8f1
    jp $24d7

INCBIN "baserom.gbc",$1d8f4,$a

LavenderHouse1Text3: ; 0x1d8fe
    TX_FAR _LavenderHouse1Text3
    db $8
    ld a, $2f
    call $13d0
    jp $24d7

LavenderHouse1Text4: ; 0x1d90b
    TX_FAR _LavenderHouse1Text4
    db $8
    ld a, $a7
    call $13d0
    jp $24d7
; 0x1d918

LavenderHouse1Text5: ; 0x1d918
    db $08 ; asm
    ld a, [$d76c]
    bit 0, a
    jr nz, .asm_15ac2 ; 0x1d91e
    ld hl, $594c
    call PrintText
    ld bc, (POKE_FLUTE << 8) | 1
    call $3e2e
    jr nc, .asm_5ce36 ; 0x1d92c
    ld hl, $5951
    call PrintText
    ld hl, $d76c
    set 0, [hl]
    jr .asm_da749 ; 0x1d939
.asm_5ce36 ; 0x1d93b
    ld hl, $595b
    call PrintText
    jr .asm_da749 ; 0x1d941
.asm_15ac2 ; 0x1d943
    ld hl, $5960
    call PrintText
.asm_da749 ; 0x1d949
    jp $24d7

INCBIN "baserom.gbc",$1d94c,$19

LavenderHouse1Text6: ; 0x1d965
    TX_FAR _LavenderHouse1Text6
    db $50

LavenderHouse1Object: ; 0x1d96a (size=56)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $2, $ff
    db $7, $3, $2, $ff

    db $0 ; signs

    db $6 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $3 + 4, $ff, $ff, $1 ; person
    db SPRITE_LITTLE_GIRL, $3 + 4, $6 + 4, $ff, $d0, $2 ; person
    db SPRITE_SLOWBRO, $4 + 4, $6 + 4, $ff, $d1, $3 ; person
    db SPRITE_SLOWBRO, $3 + 4, $1 + 4, $ff, $ff, $4 ; person
    db SPRITE_MR_FUJI, $1 + 4, $3 + 4, $ff, $ff, $5 ; person
    db SPRITE_BOOK_MAP_DEX, $3 + 4, $3 + 4, $ff, $ff, $6 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

LavenderHouse2_h: ; 0x1d9a2 to 0x1d9ae (12 bytes) (bank=7) (id=151)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $59b2, $59ae ; blocks, texts, scripts
    db $00 ; connections

    dw $59e6 ; objects

INCBIN "baserom.gbc",$1d9ae,$1d9b6 - $1d9ae

LavenderHouse2Text1: ; 0x1d9b6
    TX_FAR _LavenderHouse2Text1
    db $8
    ld a, $11
    call $13d0
    jp $24d7
; 0x1d9c3

LavenderHouse2Text2: ; 0x1d9c3
    db $08 ; asm
    ld a, [$d7e0]
    bit 7, a
    jr nz, .asm_65711 ; 0x1d9c9
    ld hl, $59dc
    call PrintText
    jr .asm_64be1 ; 0x1d9d1
.asm_65711 ; 0x1d9d3
    ld hl, $59e1
    call PrintText
.asm_64be1 ; 0x1d9d9
    jp $24d7

INCBIN "baserom.gbc",$1d9dc,$a
LavenderHouse2Object: ; 0x1d9e6 (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $4, $ff
    db $7, $3, $4, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_SLOWBRO, $5 + 4, $3 + 4, $ff, $d1, $1 ; person
    db SPRITE_BRUNETTE_GIRL, $4 + 4, $2 + 4, $ff, $d3, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

NameRater_h: ; 0x1da06 to 0x1da12 (12 bytes) (bank=7) (id=229)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $5a54, $5a12 ; blocks, texts, scripts
    db $00 ; connections

    dw $5ad6 ; objects

INCBIN "baserom.gbc",$1da12,$1dad6 - $1da12
NameRaterObject: ; 0x1dad6 (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $5, $ff
    db $7, $3, $5, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_MR_MASTERBALL, $3 + 4, $5 + 4, $ff, $d2, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

VermilionHouse1_h: ; 0x1daf0 to 0x1dafc (12 bytes) (bank=7) (id=93)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $5b00, $5afc ; blocks, texts, scripts
    db $00 ; connections

    dw $5b20 ; objects

INCBIN "baserom.gbc",$1dafc,$1db06 - $1dafc

VermilionHouse1Text1: ; 0x1db06
    TX_FAR _VermilionHouse1Text1
    db $50

VermilionHouse1Text2: ; 0x1db0b
    TX_FAR _VermilionHouse1Text2
    db $08 ; asm
    ld a, $24
    call $13d0
    call $3748
    jp $24d7

VermilionHouse1Text3: ; 0x1db1b
    TX_FAR _VermilionHouse1Text3
    db $50

INCBIN "baserom.gbc", $1db1b + 5, $1db20 - ($1db1b + 5)

VermilionHouse1Object: ; 0x1db20 (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $4, $ff
    db $7, $3, $4, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_BUG_CATCHER, $3 + 4, $5 + 4, $ff, $d2, $1 ; person
    db SPRITE_BIRD, $5 + 4, $3 + 4, $fe, $2, $2 ; person
    db SPRITE_PAPER_SHEET, $3 + 4, $4 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

VermilionDock_h: ; 0x1db46 to 0x1db52 (12 bytes) (bank=7) (id=94)
    db $0e ; tileset
    db $06, $0e ; dimensions (y, x)
    dw VermilionDockBlocks, $5cbf, $5b52 ; blocks, texts, scripts
    db $00 ; connections

    dw $5cc6 ; objects

INCBIN "baserom.gbc",$1db52,$1dcc6 - $1db52
VermilionDockObject: ; 0x1dcc6 (size=20)
    db $f ; border tile

    db $2 ; warps
    db $0, $e, $5, $ff
    db $2, $e, $1, SS_ANNE_1

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $e, $0, $e
    EVENT_DISP $e, $2, $e ; SS_ANNE_1

VermilionDockBlocks: ; 84
    INCBIN "maps/vermiliondock.blk"

CeladonMansion5_h: ; 0x1dd2e to 0x1dd3a (12 bytes) (bank=7) (id=132)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41ee, $5d3d, $5d3a ; blocks, texts, scripts
    db $00 ; connections

    dw $5d5c ; objects

INCBIN "baserom.gbc",$1dd3a,$1dd41 - $1dd3a

CeladonMansion5Text1: ; 0x1dd41
    TX_FAR _CeladonMansion5Text1
    db $50

CeladonMansion5Text2: ; 0x1dd46
    db $08 ; asm
	ld bc,(EEVEE << 8) | 25
    call GivePokemon
    jr nc, .asm_24365 ; 0x1dd4d
    ld a, $45
    ld [$cc4d], a
    ld a, $11
    call Predef
.asm_24365 ; 0x1dd59
    jp $24d7

CeladonMansion5Object: ; 0x1dd5c (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $2, CELADON_MANSION_4
    db $7, $3, $2, CELADON_MANSION_4

    db $0 ; signs

    db $2 ; people
    db SPRITE_HIKER, $2 + 4, $2 + 4, $ff, $d0, $1 ; person
    db SPRITE_BALL, $3 + 4, $4 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; CELADON_MANSION_4
    EVENT_DISP $4, $7, $3 ; CELADON_MANSION_4

FuchsiaMart_h: ; 0x1dd7c to 0x1dd88 (12 bytes) (bank=7) (id=152)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw FuchsiaMartBlocks, $5d8b, $5d88 ; blocks, texts, scripts
    db $00 ; connections

    dw $5d9b ; objects

INCBIN "baserom.gbc",$1dd88,$1dd91 - $1dd88

FuchsiaMartText2: ; 0x1dd91
    TX_FAR _FuchsiaMartText2
    db $50

FuchsiaMartText3: ; 0x1dd96
    TX_FAR _FuchsiaMartText3
    db $50

FuchsiaMartObject: ; 0x1dd9b (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_FAT_BALD_GUY, $2 + 4, $4 + 4, $ff, $ff, $2 ; person
    db SPRITE_LASS, $5 + 4, $6 + 4, $fe, $1, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

FuchsiaMartBlocks: ; 16
    INCBIN "maps/fuchsiamart.blk"

SaffronHouse1_h: ; 0x1ddd1 to 0x1dddd (12 bytes) (bank=7) (id=179)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $5de0, $5ddd ; blocks, texts, scripts
    db $00 ; connections

    dw $5e04 ; objects

INCBIN "baserom.gbc",$1dddd,$1dde0 - $1dddd
SaffronHouse1Texts: ; 0x1dde0
    dw SaffronHouse1Text1, SaffronHouse1Text2, SaffronHouse1Text3, SaffronHouse1Text4

SaffronHouse1Text1: ; 0x1dde8
    TX_FAR _SaffronHouse1Text1
    db $50

SaffronHouse1Text2: ; 0x1dded
    TX_FAR _SaffronHouse1Text2
    db $8
    ld a, $24
    call $13d0
    jp $24d7
; 0x1ddfa

SaffronHouse1Text3: ; 0x1ddfa
    TX_FAR _SaffronHouse1Text3
    db $50

SaffronHouse1Text4: ; 0x1ddff
    TX_FAR _SaffronHouse1Text4
    db $50

SaffronHouse1Object: ; 0x1de04 (size=44)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $3, $ff
    db $7, $3, $3, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_BRUNETTE_GIRL, $3 + 4, $2 + 4, $ff, $d3, $1 ; person
    db SPRITE_BIRD, $4 + 4, $0 + 4, $fe, $1, $2 ; person
    db SPRITE_BUG_CATCHER, $1 + 4, $4 + 4, $ff, $d0, $3 ; person
    db SPRITE_PAPER_SHEET, $3 + 4, $3 + 4, $ff, $ff, $4 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

SaffronHouse2_h: ; 0x1de30 to 0x1de3c (12 bytes) (bank=7) (id=183)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $5e3f, $5e3c ; blocks, texts, scripts
    db $00 ; connections

    dw $5e8a ; objects

INCBIN "baserom.gbc",$1de3c,$1de41 - $1de3c
SaffronHouse2Text1: ; 0x1de41
    db $08 ; asm
    ld a, [$d7bd]
    bit 0, a
    jr nz, .asm_9e72b ; 0x1de47
    ld hl, $5e75
    call PrintText
    ld bc,(TM_29 << 8) | 1
    call $3e2e
    jr nc, .asm_4b1da ; 0x1de55
    ld hl, $5e7a
    call PrintText
    ld hl, $d7bd
    set 0, [hl]
    jr .asm_fe4e1 ; 0x1de62
.asm_4b1da ; 0x1de64
    ld hl, $5e85
    call PrintText
    jr .asm_fe4e1 ; 0x1de6a
.asm_9e72b ; 0x1de6c
    ld hl, $5e80
    call PrintText
.asm_fe4e1 ; 0x1de72
    jp $24d7

INCBIN "baserom.gbc",$1de75,$15
SaffronHouse2Object: ; 0x1de8a (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $7, $ff
    db $7, $3, $7, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $3 + 4, $5 + 4, $ff, $d2, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

DiglettsCaveRoute2_h: ; 0x1dea4 to 0x1deb0 (12 bytes) (bank=7) (id=46)
    db $11 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw DiglettsCaveRoute2Blocks, $5eb8, $5eb0 ; blocks, texts, scripts
    db $00 ; connections

    dw $5ebf ; objects

INCBIN "baserom.gbc",$1deb0,$1deb8 - $1deb0
DiglettsCaveRoute2Texts: ; 0x1deb8
    dw DiglettsCaveRoute2Text1

DiglettsCaveRoute2Text1: ; 0x1deba
    TX_FAR _DiglettsCaveRoute2Text1
    db $50

DiglettsCaveRoute2Object: ; 0x1debf (size=34)
    db $7d ; border tile

    db $3 ; warps
    db $7, $2, $0, $ff
    db $7, $3, $0, $ff
    db $4, $4, $0, DIGLETTS_CAVE

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $3 + 4, $3 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $4, $4 ; DIGLETTS_CAVE

Route2House_h: ; 0x1dee1 to 0x1deed (12 bytes) (bank=7) (id=48)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $5ef0, $5eed ; blocks, texts, scripts
    db $00 ; connections

    dw $5f07 ; objects

INCBIN "baserom.gbc",$1deed,$1def4 - $1deed

Route2HouseText1: ; 0x1def4
    TX_FAR _Route2HouseText1
    db $50

Route2HouseText2: ; 0x1def9
    db $08 ; asm
    ld a, $1
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

Route2HouseObject: ; 0x1df07 (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $2, $ff
    db $7, $3, $2, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_OAK_AIDE, $4 + 4, $2 + 4, $ff, $d3, $1 ; person
    db SPRITE_GAMEBOY_KID_COPY, $1 + 4, $4 + 4, $ff, $d0, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

Route5Gate_h: ; 0x1df27 to 0x1df33 (12 bytes) (bank=7) (id=70)
    db $0c ; tileset
    db $03, $04 ; dimensions (y, x)
    dw Route5GateBlocks, $5fa4, $5f33 ; blocks, texts, scripts
    db $00 ; connections

    dw $5ffb ; objects

INCBIN "baserom.gbc",$1df33,$1dffb - $1df33
Route5GateObject: ; 0x1dffb (size=42)
    db $a ; border tile

    db $4 ; warps
    db $5, $3, $2, $ff
    db $5, $4, $2, $ff
    db $0, $3, $1, $ff
    db $0, $4, $0, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $3 + 4, $1 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $5, $3
    EVENT_DISP $4, $5, $4
    EVENT_DISP $4, $0, $3
    EVENT_DISP $4, $0, $4

Route5GateBlocks: ; 12
    INCBIN "maps/route5gate.blk"

Route6Gate_h: ; 0x1e031 to 0x1e03d (12 bytes) (bank=7) (id=73)
    db $0c ; tileset
    db $03, $04 ; dimensions (y, x)
    dw Route6GateBlocks, $60b8, $603d ; blocks, texts, scripts
    db $00 ; connections

    dw $60be ; objects

INCBIN "baserom.gbc",$1e03d,$1e0be - $1e03d
Route6GateObject: ; 0x1e0be (size=42)
    db $a ; border tile

    db $4 ; warps
    db $5, $3, $2, $ff
    db $5, $4, $2, $ff
    db $0, $3, $1, $ff
    db $0, $4, $1, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $2 + 4, $6 + 4, $ff, $d2, $1 ; person

    ; warp-to
    EVENT_DISP $4, $5, $3
    EVENT_DISP $4, $5, $4
    EVENT_DISP $4, $0, $3
    EVENT_DISP $4, $0, $4

Route6GateBlocks: ; 12
    INCBIN "maps/route6gate.blk"

Route7Gate_h: ; 0x1e0f4 to 0x1e100 (12 bytes) (bank=7) (id=76)
    db $0c ; tileset
    db $04, $03 ; dimensions (y, x)
    dw Route7GateBlocks, $617f, $6100 ; blocks, texts, scripts
    db $00 ; connections

    dw $6185 ; objects

INCBIN "baserom.gbc",$1e100,$1e185 - $1e100
Route7GateObject: ; 0x1e185 (size=42)
    db $a ; border tile

    db $4 ; warps
    db $3, $0, $3, $ff
    db $4, $0, $3, $ff
    db $3, $5, $0, $ff
    db $4, $5, $1, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $1 + 4, $3 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $3, $3, $0
    EVENT_DISP $3, $4, $0
    EVENT_DISP $3, $3, $5
    EVENT_DISP $3, $4, $5

Route7GateBlocks: ; 12
    INCBIN "maps/route7gate.blk"

Route8Gate_h: ; 0x1e1bb to 0x1e1c7 (12 bytes) (bank=7) (id=79)
    db $0c ; tileset
    db $04, $03 ; dimensions (y, x)
    dw Route8GateBlocks, $6241, $61c7 ; blocks, texts, scripts
    db $00 ; connections

    dw $6247 ; objects

INCBIN "baserom.gbc",$1e1c7,$1e247 - $1e1c7
Route8GateObject: ; 0x1e247 (size=42)
    db $a ; border tile

    db $4 ; warps
    db $3, $0, $0, $ff
    db $4, $0, $1, $ff
    db $3, $5, $2, $ff
    db $4, $5, $3, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $1 + 4, $2 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $3, $3, $0
    EVENT_DISP $3, $4, $0
    EVENT_DISP $3, $3, $5
    EVENT_DISP $3, $4, $5

Route8GateBlocks: ; 12
    INCBIN "maps/route8gate.blk"

UndergroundPathEntranceRoute8_h: ; 0x1e27d to 0x1e289 (12 bytes) (bank=7) (id=80)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw UndergroundPathEntranceRoute8Blocks, $6291, $6289 ; blocks, texts, scripts
    db $00 ; connections

    dw $6298 ; objects

INCBIN "baserom.gbc",$1e289,$1e291 - $1e289
UndergroundPathEntranceRoute8Texts: ; 0x1e291
    dw UndergroundPathEntranceRoute8Text1

;XXX wtf? syntax error
UndergroundPathEntranceRoute8Text1: ; 0x1e293
    db $17, $8d, $42, $23
    ;TX_FAR _UndergroundPathEntranceRoute8Text1
    db $50

UndergroundPathEntranceRoute8Object: ; 0x1e298 (size=34)
    db $a ; border tile

    db $3 ; warps
    db $7, $3, $4, $ff
    db $7, $4, $4, $ff
    db $4, $4, $1, UNDERGROUND_PATH_WE

    db $0 ; signs

    db $1 ; people
    db SPRITE_GIRL, $4 + 4, $3 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4
    EVENT_DISP $4, $4, $4 ; UNDERGROUND_PATH_WE

PowerPlant_h: ; 0x1e2ba to 0x1e2c6 (12 bytes) (bank=7) (id=83)
    db $16 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw PowerPlantBlocks, $62df, $62c6 ; blocks, texts, scripts
    db $00 ; connections

    dw $63bf ; objects

INCBIN "baserom.gbc",$1e2c6,$1e3bf - $1e2c6
PowerPlantObject: ; 0x1e3bf (size=135)
    db $2e ; border tile

    db $3 ; warps
    db $23, $4, $3, $ff
    db $23, $5, $3, $ff
    db $b, $0, $3, $ff

    db $0 ; signs

    db $e ; people
    db SPRITE_BALL, $14 + 4, $9 + 4, $ff, $ff, $41, VOLTORB, $28 ; trainer
    db SPRITE_BALL, $12 + 4, $20 + 4, $ff, $ff, $42, VOLTORB, $28 ; trainer
    db SPRITE_BALL, $19 + 4, $15 + 4, $ff, $ff, $43, VOLTORB, $28 ; trainer
    db SPRITE_BALL, $12 + 4, $19 + 4, $ff, $ff, $44, ELECTRODE, $2b ; trainer
    db SPRITE_BALL, $22 + 4, $17 + 4, $ff, $ff, $45, VOLTORB, $28 ; trainer
    db SPRITE_BALL, $1c + 4, $1a + 4, $ff, $ff, $46, VOLTORB, $28 ; trainer
    db SPRITE_BALL, $e + 4, $15 + 4, $ff, $ff, $47, ELECTRODE, $2b ; trainer
    db SPRITE_BALL, $20 + 4, $25 + 4, $ff, $ff, $48, VOLTORB, $28 ; trainer
    db SPRITE_BIRD, $9 + 4, $4 + 4, $ff, $d1, $49, ZAPDOS, $32 ; trainer
	db SPRITE_BALL, $19 + 4, $7 + 4, $ff, $ff, $8a, CARBOS ; item
	db SPRITE_BALL, $3 + 4, $1c + 4, $ff, $ff, $8b, HP_UP ; item
	db SPRITE_BALL, $3 + 4, $22 + 4, $ff, $ff, $8c, RARE_CANDY ; item
	db SPRITE_BALL, $20 + 4, $1a + 4, $ff, $ff, $8d, TM_25 ; item
	db SPRITE_BALL, $20 + 4, $14 + 4, $ff, $ff, $8e, TM_33 ; item

    ; warp-to
    EVENT_DISP $14, $23, $4
    EVENT_DISP $14, $23, $5
    EVENT_DISP $14, $b, $0

PowerPlantBlocks: ; 360
    INCBIN "maps/powerplant.blk"

DiglettsCaveEntranceRoute11_h: ; 0x1e5ae to 0x1e5ba (12 bytes) (bank=7) (id=85)
    db $11 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $420e, $65c3, $65ba ; blocks, texts, scripts
    db $00 ; connections

    dw $65ca ; objects

INCBIN "baserom.gbc",$1e5ba,$1e5c3 - $1e5ba
DiglettsCaveEntranceRoute11Texts: ; 0x1e5c3
    dw DiglettsCaveEntranceRoute11Text1

; XXX wtf? syntax error
DiglettsCaveEntranceRoute11Text1: ; 0x1e5c5
    db $17, $f9, $47, $23
    ;TX_FAR _DiglettsCaveEntranceRoute11Text1
    db $50

DiglettsCaveEntranceRoute11Object: ; 0x1e5ca (size=34)
    db $7d ; border tile

    db $3 ; warps
    db $7, $2, $4, $ff
    db $7, $3, $4, $ff
    db $4, $4, $1, DIGLETTS_CAVE

    db $0 ; signs

    db $1 ; people
    db SPRITE_GAMBLER, $3 + 4, $2 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $4, $4 ; DIGLETTS_CAVE

Route16House_h: ; 0x1e5ec to 0x1e5f8 (12 bytes) (bank=7) (id=188)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $41de, $65fb, $65f8 ; blocks, texts, scripts
    db $00 ; connections

    dw $6657 ; objects

INCBIN "baserom.gbc",$1e5f8,$1e5ff - $1e5f8
Route16HouseText1: ; 0x1e5ff
    db $08 ; asm
    ld a, [$d7e0]
    bit 6, a
    ld hl, $6636
    jr nz, .asm_13616 ; 0x1e608
    ld hl, $662b
    call PrintText
    ld bc,(HM_02 << 8) | 1
    call $3e2e
    jr nc, .asm_d3ee3 ; 0x1e616
    ld hl, $d7e0
    set 6, [hl]
    ld hl, $6630
    jr .asm_13616 ; 0x1e620
.asm_d3ee3 ; 0x1e622
    ld hl, $663b
.asm_13616 ; 0x1e625
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1e62b,$1e640 - $1e62b
Route16HouseText2: ; 0x1e640
    db $08 ; asm
    ld hl, $6652
    call PrintText
	ld a,FEAROW
    call $13d0
    call $3748
    jp $24d7

INCBIN "baserom.gbc",$1e652,$5
Route16HouseObject: ; 0x1e657 (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $8, $ff
    db $7, $3, $8, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_BRUNETTE_GIRL, $3 + 4, $2 + 4, $ff, $d3, $1 ; person
    db SPRITE_BIRD, $4 + 4, $6 + 4, $fe, $0, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

Route22Gate_h: ; 0x1e677 to 0x1e683 (12 bytes) (bank=7) (id=193)
    db $0c ; tileset
    db $04, $05 ; dimensions (y, x)
    dw Route22GateBlocks, $66df, $6683 ; blocks, texts, scripts
    db $00 ; connections

    dw $6720 ; objects

INCBIN "baserom.gbc",$1e683,$1e720 - $1e683
Route22GateObject: ; 0x1e720 (size=42)
    db $a ; border tile

    db $4 ; warps
    db $7, $4, $0, $ff
    db $7, $5, $0, $ff
    db $0, $4, $0, $ff
    db $0, $5, $1, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $2 + 4, $6 + 4, $ff, $d2, $1 ; person

    ; warp-to
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5
    EVENT_DISP $5, $0, $4
    EVENT_DISP $5, $0, $5

Route22GateBlocks: ; 20
    INCBIN "maps/route22gate.blk"

BillsHouse_h: ; 0x1e75e to 0x1e76a (12 bytes) (bank=7) (id=88)
    db $10 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $6905, $6834, $676a ; blocks, texts, scripts
    db $00 ; connections

    dw $68df ; objects

INCBIN "baserom.gbc",$1e76a,$1e874 - $1e76a
BillsHouseText2: ; 0x1e874
    db $08 ; asm
    ld a, [$d7f2]
    bit 4, a
    jr nz, .asm_5491f ; 0x1e87a
    ld hl, $68ba
    call PrintText
    ld bc,(S_S__TICKET << 8) | 1
    call $3e2e
    jr nc, .asm_18a67 ; 0x1e888
    ld hl, $68bf
    call PrintText
    ld hl, $d7f2
    set 4, [hl]
    ld a, $7
    ld [$cc4d], a
    ld a, $15
    call Predef
    ld a, $9
    ld [$cc4d], a
    ld a, $11
    call Predef
.asm_5491f ; 0x1e8a9
    ld hl, $68cb
    call PrintText
    jr .asm_bd408 ; 0x1e8af
.asm_18a67 ; 0x1e8b1
    ld hl, $68c6
    call PrintText
.asm_bd408 ; 0x1e8b7
    jp $24d7

INCBIN "baserom.gbc",$1e8ba,$1e8d0 - $1e8ba
BillsHouseText3: ; 0x1e8d0
    db $08 ; asm
    ld hl, $68da
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$1e8da,$5
BillsHouseObject: ; 0x1e8df (size=38)
    db $d ; border tile

    db $2 ; warps
    db $7, $2, $0, $ff
    db $7, $3, $0, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_SLOWBRO, $5 + 4, $6 + 4, $ff, $ff, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $4 + 4, $4 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $6 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

INCBIN "baserom.gbc",$1e905,$16fb

SECTION "bank8",DATA,BANK[$8]
INCBIN "baserom.gbc",$20000,$4000

SECTION "bank9",DATA,BANK[$9]
RhydonPicFront:
	INCBIN "pic/bmon/rhydon.pic"
RhydonPicBack:
	INCBIN "pic/monback/rhydonb.pic"
KangaskhanPicFront:
	INCBIN "pic/bmon/kangaskhan.pic"
KangaskhanPicBack:
	INCBIN "pic/monback/kangaskhanb.pic"
NidoranMPicFront:
	INCBIN "pic/bmon/nidoranm.pic"
NidoranMPicBack:
	INCBIN "pic/monback/nidoranmb.pic"
ClefairyPicFront:
	INCBIN "pic/bmon/clefairy.pic"
ClefairyPicBack:
	INCBIN "pic/monback/clefairyb.pic"
SpearowPicFront:
	INCBIN "pic/bmon/spearow.pic"
SpearowPicBack:
	INCBIN "pic/monback/spearowb.pic"
VoltorbPicFront:
	INCBIN "pic/bmon/voltorb.pic"
VoltorbPicBack:
	INCBIN "pic/monback/voltorbb.pic"
NidokingPicFront:
	INCBIN "pic/bmon/nidoking.pic"
NidokingPicBack:
	INCBIN "pic/monback/nidokingb.pic"
SlowbroPicFront:
	INCBIN "pic/bmon/slowbro.pic"
SlowbroPicBack:
	INCBIN "pic/monback/slowbrob.pic"
IvysaurPicFront:
	INCBIN "pic/bmon/ivysaur.pic"
IvysaurPicBack:
	INCBIN "pic/monback/ivysaurb.pic"
ExeggutorPicFront:
	INCBIN "pic/bmon/exeggutor.pic"
ExeggutorPicBack:
	INCBIN "pic/monback/exeggutorb.pic"
LickitungPicFront:
	INCBIN "pic/bmon/lickitung.pic"
LickitungPicBack:
	INCBIN "pic/monback/lickitungb.pic"
ExeggcutePicFront:
	INCBIN "pic/bmon/exeggcute.pic"
ExeggcutePicBack:
	INCBIN "pic/monback/exeggcuteb.pic"
GrimerPicFront:
	INCBIN "pic/bmon/grimer.pic"
GrimerPicBack:
	INCBIN "pic/monback/grimerb.pic"
GengarPicFront:
	INCBIN "pic/bmon/gengar.pic"
GengarPicBack:
	INCBIN "pic/monback/gengarb.pic"
NidoranFPicFront:
	INCBIN "pic/bmon/nidoranf.pic"
NidoranFPicBack:
	INCBIN "pic/monback/nidoranfb.pic"
NidoqueenPicFront:
	INCBIN "pic/bmon/nidoqueen.pic"
NidoqueenPicBack:
	INCBIN "pic/monback/nidoqueenb.pic"
CubonePicFront:
	INCBIN "pic/bmon/cubone.pic"
CubonePicBack:
	INCBIN "pic/monback/cuboneb.pic"
RhyhornPicFront:
	INCBIN "pic/bmon/rhyhorn.pic"
RhyhornPicBack:
	INCBIN "pic/monback/rhyhornb.pic"
LaprasPicFront:
	INCBIN "pic/bmon/lapras.pic"
LaprasPicBack:
	INCBIN "pic/monback/laprasb.pic"
ArcaninePicFront:
	INCBIN "pic/bmon/arcanine.pic"
ArcaninePicBack:
	INCBIN "pic/monback/arcanineb.pic"
GyaradosPicFront:
	INCBIN "pic/bmon/gyarados.pic"
GyaradosPicBack:
	INCBIN "pic/monback/gyaradosb.pic"
ShellderPicFront:
	INCBIN "pic/bmon/shellder.pic"
ShellderPicBack:
	INCBIN "pic/monback/shellderb.pic"
TentacoolPicFront:
	INCBIN "pic/bmon/tentacool.pic"
TentacoolPicBack:
	INCBIN "pic/monback/tentacoolb.pic"
GastlyPicFront:
	INCBIN "pic/bmon/gastly.pic"
GastlyPicBack:
	INCBIN "pic/monback/gastlyb.pic"
ScytherPicFront:
	INCBIN "pic/bmon/scyther.pic"
ScytherPicBack:
	INCBIN "pic/monback/scytherb.pic"
StaryuPicFront:
	INCBIN "pic/bmon/staryu.pic"
StaryuPicBack:
	INCBIN "pic/monback/staryub.pic"
BlastoisePicFront:
	INCBIN "pic/bmon/blastoise.pic"
BlastoisePicBack:
	INCBIN "pic/monback/blastoiseb.pic"
PinsirPicFront:
	INCBIN "pic/bmon/pinsir.pic"
PinsirPicBack:
	INCBIN "pic/monback/pinsirb.pic"
TangelaPicFront:
	INCBIN "pic/bmon/tangela.pic"
TangelaPicBack:
	INCBIN "pic/monback/tangelab.pic"

INCBIN "baserom.gbc",$27d6b,$27DAE - $27d6b

TypeNamePointers: ; 7DAE
	dw Type00Name
	dw Type01Name
	dw Type02Name
	dw Type03Name
	dw Type04Name
	dw Type05Name
	dw Type06Name
	dw Type07Name
	dw Type08Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type00Name
	dw Type14Name
	dw Type15Name
	dw Type16Name
	dw Type17Name
	dw Type18Name
	dw Type19Name
	dw Type1AName

Type00Name:
	db "NORMAL@"
Type01Name:
	db "FIGHTING@"
Type02Name:
	db "FLYING@"
Type03Name:
	db "POISON@"
Type14Name:
	db "FIRE@"
Type15Name:
	db "WATER@"
Type16Name:
	db "GRASS@"
Type17Name:
	db "ELECTRIC@"
Type18Name:
	db "PSYCHIC@"
Type19Name:
	db "ICE@"
Type04Name:
	db "GROUND@"
Type05Name:
	db "ROCK@"
Type06Name:
	db "BIRD@"
Type07Name:
	db "BUG@"
Type08Name:
	db "GHOST@"
Type1AName:
	db "DRAGON@"

SaveTrainerName: ; 7E4A
	ld hl,TrainerNamePointers
	ld a,[W_TRAINERCLASS]
	dec a
	ld c,a
	ld b,0
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld de,$CD6D
.CopyCharacter\@
	ld a,[hli]
	ld [de],a
	inc de
	cp "@"
	jr nz,.CopyCharacter\@
	ret

TrainerNamePointers:
; what is the point of these?
	dw YoungsterName
	dw BugCatcherName
	dw LassName
	dw $D04A
	dw JrTrainerMName
	dw JrTrainerFName
	dw PokemaniacName
	dw SuperNerdName
	dw $D04A
	dw $D04A
	dw BurglarName
	dw EngineerName
	dw JugglerXName
	dw $D04A
	dw SwimmerName
	dw $D04A
	dw $D04A
	dw BeautyName
	dw $D04A
	dw RockerName
	dw JugglerName
	dw $D04A
	dw $D04A
	dw BlackbeltName
	dw $D04A
	dw ProfOakName
	dw ChiefName
	dw ScientistName
	dw $D04A
	dw RocketName
	dw CooltrainerMName
	dw CooltrainerFName
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A
	dw $D04A

YoungsterName:
	db "YOUNGSTER@"
BugCatcherName:
	db "BUG CATCHER@"
LassName:
	db "LASS@"
JrTrainerMName:
	db "JR.TRAINER♂@"
JrTrainerFName:
	db "JR.TRAINER♀@"
PokemaniacName:
	db "POKéMANIAC@"
SuperNerdName:
	db "SUPER NERD@"
BurglarName:
	db "BURGLAR@"
EngineerName:
	db "ENGINEER@"
JugglerXName:
	db "JUGGLER@"
SwimmerName:
	db "SWIMMER@"
BeautyName:
	db "BEAUTY@"
RockerName:
	db "ROCKER@"
JugglerName:
	db "JUGGLER@"
BlackbeltName:
	db "BLACKBELT@"
ProfOakName:
	db "PROF.OAK@"
ChiefName:
	db "CHIEF@"
ScientistName:
	db "SCIENTIST@"
RocketName:
	db "ROCKET@"
CooltrainerMName:
	db "COOLTRAINER♂@"
CooltrainerFName:
	db "COOLTRAINER♀@"

INCBIN "baserom.gbc",$27f86,$27fb8-$27f86

SECTION "bankA",DATA,BANK[$A]
GrowlithePicFront:
	INCBIN "pic/bmon/growlithe.pic"
GrowlithePicBack:
	INCBIN "pic/monback/growlitheb.pic"
OnixPicFront:
	INCBIN "pic/bmon/onix.pic"
OnixPicBack:
	INCBIN "pic/monback/onixb.pic"
FearowPicFront:
	INCBIN "pic/bmon/fearow.pic"
FearowPicBack:
	INCBIN "pic/monback/fearowb.pic"
PidgeyPicFront:
	INCBIN "pic/bmon/pidgey.pic"
PidgeyPicBack:
	INCBIN "pic/monback/pidgeyb.pic"
SlowpokePicFront:
	INCBIN "pic/bmon/slowpoke.pic"
SlowpokePicBack:
	INCBIN "pic/monback/slowpokeb.pic"
KadabraPicFront:
	INCBIN "pic/bmon/kadabra.pic"
KadabraPicBack:
	INCBIN "pic/monback/kadabrab.pic"
GravelerPicFront:
	INCBIN "pic/bmon/graveler.pic"
GravelerPicBack:
	INCBIN "pic/monback/gravelerb.pic"
ChanseyPicFront:
	INCBIN "pic/bmon/chansey.pic"
ChanseyPicBack:
	INCBIN "pic/monback/chanseyb.pic"
MachokePicFront:
	INCBIN "pic/bmon/machoke.pic"
MachokePicBack:
	INCBIN "pic/monback/machokeb.pic"
MrMimePicFront:
	INCBIN "pic/bmon/mr.mime.pic"
MrMimePicBack:
	INCBIN "pic/monback/mr.mimeb.pic"
HitmonleePicFront:
	INCBIN "pic/bmon/hitmonlee.pic"
HitmonleePicBack:
	INCBIN "pic/monback/hitmonleeb.pic"
HitmonchanPicFront:
	INCBIN "pic/bmon/hitmonchan.pic"
HitmonchanPicBack:
	INCBIN "pic/monback/hitmonchanb.pic"
ArbokPicFront:
	INCBIN "pic/bmon/arbok.pic"
ArbokPicBack:
	INCBIN "pic/monback/arbokb.pic"
ParasectPicFront:
	INCBIN "pic/bmon/parasect.pic"
ParasectPicBack:
	INCBIN "pic/monback/parasectb.pic"
PsyduckPicFront:
	INCBIN "pic/bmon/psyduck.pic"
PsyduckPicBack:
	INCBIN "pic/monback/psyduckb.pic"
DrowzeePicFront:
	INCBIN "pic/bmon/drowzee.pic"
DrowzeePicBack:
	INCBIN "pic/monback/drowzeeb.pic"
GolemPicFront:
	INCBIN "pic/bmon/golem.pic"
GolemPicBack:
	INCBIN "pic/monback/golemb.pic"
MagmarPicFront:
	INCBIN "pic/bmon/magmar.pic"
MagmarPicBack:
	INCBIN "pic/monback/magmarb.pic"
ElectabuzzPicFront:
	INCBIN "pic/bmon/electabuzz.pic"
ElectabuzzPicBack:
	INCBIN "pic/monback/electabuzzb.pic"
MagnetonPicFront:
	INCBIN "pic/bmon/magneton.pic"
MagnetonPicBack:
	INCBIN "pic/monback/magnetonb.pic"
KoffingPicFront:
	INCBIN "pic/bmon/koffing.pic"
KoffingPicBack:
	INCBIN "pic/monback/koffingb.pic"
MankeyPicFront:
	INCBIN "pic/bmon/mankey.pic"
MankeyPicBack:
	INCBIN "pic/monback/mankeyb.pic"
SeelPicFront:
	INCBIN "pic/bmon/seel.pic"
SeelPicBack:
	INCBIN "pic/monback/seelb.pic"
DiglettPicFront:
	INCBIN "pic/bmon/diglett.pic"
DiglettPicBack:
	INCBIN "pic/monback/diglettb.pic"
TaurosPicFront:
	INCBIN "pic/bmon/tauros.pic"
TaurosPicBack:
	INCBIN "pic/monback/taurosb.pic"
FarfetchdPicFront:
	INCBIN "pic/bmon/farfetchd.pic"
FarfetchdPicBack:
	INCBIN "pic/monback/farfetchdb.pic"
VenonatPicFront:
	INCBIN "pic/bmon/venonat.pic"
VenonatPicBack:
	INCBIN "pic/monback/venonatb.pic"
DragonitePicFront:
	INCBIN "pic/bmon/dragonite.pic"
DragonitePicBack:
	INCBIN "pic/monback/dragoniteb.pic"
DoduoPicFront:
	INCBIN "pic/bmon/doduo.pic"
DoduoPicBack:
	INCBIN "pic/monback/doduob.pic"
PoliwagPicFront:
	INCBIN "pic/bmon/poliwag.pic"
PoliwagPicBack:
	INCBIN "pic/monback/poliwagb.pic"
JynxPicFront:
	INCBIN "pic/bmon/jynx.pic"
JynxPicBack:
	INCBIN "pic/monback/jynxb.pic"
MoltresPicFront:
	INCBIN "pic/bmon/moltres.pic"
MoltresPicBack:
	INCBIN "pic/monback/moltresb.pic"

INCBIN "baserom.gbc",$2bea9,$3efc-$3ea9

SECTION "bankB",DATA,BANK[$B]
ArticunoPicFront:
	INCBIN "pic/bmon/articuno.pic"
ArticunoPicBack:
	INCBIN "pic/monback/articunob.pic"
ZapdosPicFront:
	INCBIN "pic/bmon/zapdos.pic"
ZapdosPicBack:
	INCBIN "pic/monback/zapdosb.pic"
DittoPicFront:
	INCBIN "pic/bmon/ditto.pic"
DittoPicBack:
	INCBIN "pic/monback/dittob.pic"
MeowthPicFront:
	INCBIN "pic/bmon/meowth.pic"
MeowthPicBack:
	INCBIN "pic/monback/meowthb.pic"
KrabbyPicFront:
	INCBIN "pic/bmon/krabby.pic"
KrabbyPicBack:
	INCBIN "pic/monback/krabbyb.pic"
VulpixPicFront:
	INCBIN "pic/bmon/vulpix.pic"
VulpixPicBack:
	INCBIN "pic/monback/vulpixb.pic"
NinetalesPicFront:
	INCBIN "pic/bmon/ninetales.pic"
NinetalesPicBack:
	INCBIN "pic/monback/ninetalesb.pic"
PikachuPicFront:
	INCBIN "pic/bmon/pikachu.pic"
PikachuPicBack:
	INCBIN "pic/monback/pikachub.pic"
RaichuPicFront:
	INCBIN "pic/bmon/raichu.pic"
RaichuPicBack:
	INCBIN "pic/monback/raichub.pic"
DratiniPicFront:
	INCBIN "pic/bmon/dratini.pic"
DratiniPicBack:
	INCBIN "pic/monback/dratinib.pic"
DragonairPicFront:
	INCBIN "pic/bmon/dragonair.pic"
DragonairPicBack:
	INCBIN "pic/monback/dragonairb.pic"
KabutoPicFront:
	INCBIN "pic/bmon/kabuto.pic"
KabutoPicBack:
	INCBIN "pic/monback/kabutob.pic"
KabutopsPicFront:
	INCBIN "pic/bmon/kabutops.pic"
KabutopsPicBack:
	INCBIN "pic/monback/kabutopsb.pic"
HorseaPicFront:
	INCBIN "pic/bmon/horsea.pic"
HorseaPicBack:
	INCBIN "pic/monback/horseab.pic"
SeadraPicFront:
	INCBIN "pic/bmon/seadra.pic"
SeadraPicBack:
	INCBIN "pic/monback/seadrab.pic"
SandshrewPicFront:
	INCBIN "pic/bmon/sandshrew.pic"
SandshrewPicBack:
	INCBIN "pic/monback/sandshrewb.pic"
SandslashPicFront:
	INCBIN "pic/bmon/sandslash.pic"
SandslashPicBack:
	INCBIN "pic/monback/sandslashb.pic"
OmanytePicFront:
	INCBIN "pic/bmon/omanyte.pic"
OmanytePicBack:
	INCBIN "pic/monback/omanyteb.pic"
OmastarPicFront:
	INCBIN "pic/bmon/omastar.pic"
OmastarPicBack:
	INCBIN "pic/monback/omastarb.pic"
JigglypuffPicFront:
	INCBIN "pic/bmon/jigglypuff.pic"
JigglypuffPicBack:
	INCBIN "pic/monback/jigglypuffb.pic"
WigglytuffPicFront:
	INCBIN "pic/bmon/wigglytuff.pic"
WigglytuffPicBack:
	INCBIN "pic/monback/wigglytuffb.pic"
EeveePicFront:
	INCBIN "pic/bmon/eevee.pic"
EeveePicBack:
	INCBIN "pic/monback/eeveeb.pic"
FlareonPicFront:
	INCBIN "pic/bmon/flareon.pic"
FlareonPicBack:
	INCBIN "pic/monback/flareonb.pic"
JolteonPicFront:
	INCBIN "pic/bmon/jolteon.pic"
JolteonPicBack:
	INCBIN "pic/monback/jolteonb.pic"
VaporeonPicFront:
	INCBIN "pic/bmon/vaporeon.pic"
VaporeonPicBack:
	INCBIN "pic/monback/vaporeonb.pic"
MachopPicFront:
	INCBIN "pic/bmon/machop.pic"
MachopPicBack:
	INCBIN "pic/monback/machopb.pic"
ZubatPicFront:
	INCBIN "pic/bmon/zubat.pic"
ZubatPicBack:
	INCBIN "pic/monback/zubatb.pic"
EkansPicFront:
	INCBIN "pic/bmon/ekans.pic"
EkansPicBack:
	INCBIN "pic/monback/ekansb.pic"
ParasPicFront:
	INCBIN "pic/bmon/paras.pic"
ParasPicBack:
	INCBIN "pic/monback/parasb.pic"
PoliwhirlPicFront:
	INCBIN "pic/bmon/poliwhirl.pic"
PoliwhirlPicBack:
	INCBIN "pic/monback/poliwhirlb.pic"
PoliwrathPicFront:
	INCBIN "pic/bmon/poliwrath.pic"
PoliwrathPicBack:
	INCBIN "pic/monback/poliwrathb.pic"
WeedlePicFront:
	INCBIN "pic/bmon/weedle.pic"
WeedlePicBack:
	INCBIN "pic/monback/weedleb.pic"
KakunaPicFront:
	INCBIN "pic/bmon/kakuna.pic"
KakunaPicBack:
	INCBIN "pic/monback/kakunab.pic"
BeedrillPicFront:
	INCBIN "pic/bmon/beedrill.pic"
BeedrillPicBack:
	INCBIN "pic/monback/beedrillb.pic"
FossilKabutopsPic:
	INCBIN "pic/bmon/fossilkabutops.pic"

INCBIN "baserom.gbc",$2fb7b,$2ff3c-$2fb7b

SECTION "bankC",DATA,BANK[$C]
DodrioPicFront:
	INCBIN "pic/bmon/dodrio.pic"
DodrioPicBack:
	INCBIN "pic/monback/dodriob.pic"
PrimeapePicFront:
	INCBIN "pic/bmon/primeape.pic"
PrimeapePicBack:
	INCBIN "pic/monback/primeapeb.pic"
DugtrioPicFront:
	INCBIN "pic/bmon/dugtrio.pic"
DugtrioPicBack:
	INCBIN "pic/monback/dugtriob.pic"
VenomothPicFront:
	INCBIN "pic/bmon/venomoth.pic"
VenomothPicBack:
	INCBIN "pic/monback/venomothb.pic"
DewgongPicFront:
	INCBIN "pic/bmon/dewgong.pic"
DewgongPicBack:
	INCBIN "pic/monback/dewgongb.pic"
CaterpiePicFront:
	INCBIN "pic/bmon/caterpie.pic"
CaterpiePicBack:
	INCBIN "pic/monback/caterpieb.pic"
MetapodPicFront:
	INCBIN "pic/bmon/metapod.pic"
MetapodPicBack:
	INCBIN "pic/monback/metapodb.pic"
ButterfreePicFront:
	INCBIN "pic/bmon/butterfree.pic"
ButterfreePicBack:
	INCBIN "pic/monback/butterfreeb.pic"
MachampPicFront:
	INCBIN "pic/bmon/machamp.pic"
MachampPicBack:
	INCBIN "pic/monback/machampb.pic"
GolduckPicFront:
	INCBIN "pic/bmon/golduck.pic"
GolduckPicBack:
	INCBIN "pic/monback/golduckb.pic"
HypnoPicFront:
	INCBIN "pic/bmon/hypno.pic"
HypnoPicBack:
	INCBIN "pic/monback/hypnob.pic"
GolbatPicFront:
	INCBIN "pic/bmon/golbat.pic"
GolbatPicBack:
	INCBIN "pic/monback/golbatb.pic"
MewtwoPicFront:
	INCBIN "pic/bmon/mewtwo.pic"
MewtwoPicBack:
	INCBIN "pic/monback/mewtwob.pic"
SnorlaxPicFront:
	INCBIN "pic/bmon/snorlax.pic"
SnorlaxPicBack:
	INCBIN "pic/monback/snorlaxb.pic"
MagikarpPicFront:
	INCBIN "pic/bmon/magikarp.pic"
MagikarpPicBack:
	INCBIN "pic/monback/magikarpb.pic"
MukPicFront:
	INCBIN "pic/bmon/muk.pic"
MukPicBack:
	INCBIN "pic/monback/mukb.pic"
KinglerPicFront:
	INCBIN "pic/bmon/kingler.pic"
KinglerPicBack:
	INCBIN "pic/monback/kinglerb.pic"
CloysterPicFront:
	INCBIN "pic/bmon/cloyster.pic"
CloysterPicBack:
	INCBIN "pic/monback/cloysterb.pic"
ElectrodePicFront:
	INCBIN "pic/bmon/electrode.pic"
ElectrodePicBack:
	INCBIN "pic/monback/electrodeb.pic"
ClefablePicFront:
	INCBIN "pic/bmon/clefable.pic"
ClefablePicBack:
	INCBIN "pic/monback/clefableb.pic"
WeezingPicFront:
	INCBIN "pic/bmon/weezing.pic"
WeezingPicBack:
	INCBIN "pic/monback/weezingb.pic"
PersianPicFront:
	INCBIN "pic/bmon/persian.pic"
PersianPicBack:
	INCBIN "pic/monback/persianb.pic"
MarowakPicFront:
	INCBIN "pic/bmon/marowak.pic"
MarowakPicBack:
	INCBIN "pic/monback/marowakb.pic"
HaunterPicFront:
	INCBIN "pic/bmon/haunter.pic"
HaunterPicBack:
	INCBIN "pic/monback/haunterb.pic"
AbraPicFront:
	INCBIN "pic/bmon/abra.pic"
AbraPicBack:
	INCBIN "pic/monback/abrab.pic"
AlakazamPicFront:
	INCBIN "pic/bmon/alakazam.pic"
AlakazamPicBack:
	INCBIN "pic/monback/alakazamb.pic"
PidgeottoPicFront:
	INCBIN "pic/bmon/pidgeotto.pic"
PidgeottoPicBack:
	INCBIN "pic/monback/pidgeottob.pic"
PidgeotPicFront:
	INCBIN "pic/bmon/pidgeot.pic"
PidgeotPicBack:
	INCBIN "pic/monback/pidgeotb.pic"
StarmiePicFront:
	INCBIN "pic/bmon/starmie.pic"
StarmiePicBack:
	INCBIN "pic/monback/starmieb.pic"
RedPicBack:
	INCBIN "pic/trainer/redb.pic"
OldManPic:
	INCBIN "pic/trainer/oldman.pic"

INCBIN "baserom.gbc",$33f2b,$3f90-$3f2b

SECTION "bankD",DATA,BANK[$D]
BulbasaurPicFront:
	INCBIN "pic/bmon/bulbasaur.pic"
BulbasaurPicBack:
	INCBIN "pic/monback/bulbasaurb.pic"
VenusaurPicFront:
	INCBIN "pic/bmon/venusaur.pic"
VenusaurPicBack:
	INCBIN "pic/monback/venusaurb.pic"
TentacruelPicFront:
	INCBIN "pic/bmon/tentacruel.pic"
TentacruelPicBack:
	INCBIN "pic/monback/tentacruelb.pic"
GoldeenPicFront:
	INCBIN "pic/bmon/goldeen.pic"
GoldeenPicBack:
	INCBIN "pic/monback/goldeenb.pic"
SeakingPicFront:
	INCBIN "pic/bmon/seaking.pic"
SeakingPicBack:
	INCBIN "pic/monback/seakingb.pic"
PonytaPicFront:
	INCBIN "pic/bmon/ponyta.pic"
RapidashPicFront:
	INCBIN "pic/bmon/rapidash.pic"
PonytaPicBack:
	INCBIN "pic/monback/ponytab.pic"
RapidashPicBack:
	INCBIN "pic/monback/rapidashb.pic"
RattataPicFront:
	INCBIN "pic/bmon/rattata.pic"
RattataPicBack:
	INCBIN "pic/monback/rattatab.pic"
RaticatePicFront:
	INCBIN "pic/bmon/raticate.pic"
RaticatePicBack:
	INCBIN "pic/monback/raticateb.pic"
NidorinoPicFront:
	INCBIN "pic/bmon/nidorino.pic"
NidorinoPicBack:
	INCBIN "pic/monback/nidorinob.pic"
NidorinaPicFront:
	INCBIN "pic/bmon/nidorina.pic"
NidorinaPicBack:
	INCBIN "pic/monback/nidorinab.pic"
GeodudePicFront:
	INCBIN "pic/bmon/geodude.pic"
GeodudePicBack:
	INCBIN "pic/monback/geodudeb.pic"
PorygonPicFront:
	INCBIN "pic/bmon/porygon.pic"
PorygonPicBack:
	INCBIN "pic/monback/porygonb.pic"
AerodactylPicFront:
	INCBIN "pic/bmon/aerodactyl.pic"
AerodactylPicBack:
	INCBIN "pic/monback/aerodactylb.pic"
MagnemitePicFront:
	INCBIN "pic/bmon/magnemite.pic"
MagnemitePicBack:
	INCBIN "pic/monback/magnemiteb.pic"
CharmanderPicFront:
	INCBIN "pic/bmon/charmander.pic"
CharmanderPicBack:
	INCBIN "pic/monback/charmanderb.pic"
SquirtlePicFront:
	INCBIN "pic/bmon/squirtle.pic"
SquirtlePicBack:
	INCBIN "pic/monback/squirtleb.pic"
CharmeleonPicFront:
	INCBIN "pic/bmon/charmeleon.pic"
CharmeleonPicBack:
	INCBIN "pic/monback/charmeleonb.pic"
WartortlePicFront:
	INCBIN "pic/bmon/wartortle.pic"
WartortlePicBack:
	INCBIN "pic/monback/wartortleb.pic"
CharizardPicFront:
	INCBIN "pic/bmon/charizard.pic"
CharizardPicBack:
	INCBIN "pic/monback/charizardb.pic"
FossilAerodactylPic:
	INCBIN "pic/bmon/fossilaerodactyl.pic"
GhostPic:
	INCBIN "pic/other/ghost.pic"
OddishPicFront:
	INCBIN "pic/bmon/oddish.pic"
OddishPicBack:
	INCBIN "pic/monback/oddishb.pic"
GloomPicFront:
	INCBIN "pic/bmon/gloom.pic"
GloomPicBack:
	INCBIN "pic/monback/gloomb.pic"
VileplumePicFront:
	INCBIN "pic/bmon/vileplume.pic"
VileplumePicBack:
	INCBIN "pic/monback/vileplumeb.pic"
BellsproutPicFront:
	INCBIN "pic/bmon/bellsprout.pic"
BellsproutPicBack:
	INCBIN "pic/monback/bellsproutb.pic"
WeepinbellPicFront:
	INCBIN "pic/bmon/weepinbell.pic"
WeepinbellPicBack:
	INCBIN "pic/monback/weepinbellb.pic"
VictreebelPicFront:
	INCBIN "pic/bmon/victreebel.pic"
VictreebelPicBack:
	INCBIN "pic/monback/victreebelb.pic"

INCBIN "baserom.gbc",$37244,$3e88-$3244

SECTION "bankE",DATA,BANK[$E]

Attacks: ; 4000
; characteristics of each attack
; animation, effect, power, type, accuracy, PP
db POUND       ,$00,$28,NORMAL,$FF,35
db KARATE_CHOP ,$00,$32,NORMAL,$FF,25
db DOUBLESLAP  ,$1D,$0F,NORMAL,$D8,10
db COMET_PUNCH ,$1D,$12,NORMAL,$D8,15
db MEGA_PUNCH  ,$00,$50,NORMAL,$D8,20
db PAY_DAY     ,$10,$28,NORMAL,$FF,20
db FIRE_PUNCH  ,$04,$4B,FIRE,$FF,15
db ICE_PUNCH   ,$05,$4B,ICE,$FF,15
db THUNDERPUNCH,$06,$4B,ELECTRIC,$FF,15
db SCRATCH     ,$00,$28,NORMAL,$FF,35
db VICEGRIP    ,$00,$37,NORMAL,$FF,30
db GUILLOTINE  ,$26,$01,NORMAL,$4C,5
db RAZOR_WIND  ,$27,$50,NORMAL,$BF,10
db SWORDS_DANCE,$32,$00,NORMAL,$FF,30
db CUT         ,$00,$32,NORMAL,$F2,30
db GUST        ,$00,$28,NORMAL,$FF,35
db WING_ATTACK ,$00,$23,FLYING,$FF,35
db WHIRLWIND   ,$1C,$00,NORMAL,$D8,20
db FLY         ,$2B,$46,FLYING,$F2,15
db BIND        ,$2A,$0F,NORMAL,$BF,20
db SLAM        ,$00,$50,NORMAL,$BF,20
db VINE_WHIP   ,$00,$23,GRASS,$FF,10
db STOMP       ,$25,$41,NORMAL,$FF,20
db DOUBLE_KICK ,$2C,$1E,FIGHTING,$FF,30
db MEGA_KICK   ,$00,$78,NORMAL,$BF,5
db JUMP_KICK   ,$2D,$46,FIGHTING,$F2,25
db ROLLING_KICK,$25,$3C,FIGHTING,$D8,15
db SAND_ATTACK ,$16,$00,NORMAL,$FF,15
db HEADBUTT    ,$25,$46,NORMAL,$FF,15
db HORN_ATTACK ,$00,$41,NORMAL,$FF,25
db FURY_ATTACK ,$1D,$0F,NORMAL,$D8,20
db HORN_DRILL  ,$26,$01,NORMAL,$4C,5
db TACKLE      ,$00,$23,NORMAL,$F2,35
db BODY_SLAM   ,$24,$55,NORMAL,$FF,15
db WRAP        ,$2A,$0F,NORMAL,$D8,20
db TAKE_DOWN   ,$30,$5A,NORMAL,$D8,20
db THRASH      ,$1B,$5A,NORMAL,$FF,20
db DOUBLE_EDGE ,$30,$64,NORMAL,$FF,15
db TAIL_WHIP   ,$13,$00,NORMAL,$FF,30
db POISON_STING,$02,$0F,POISON,$FF,35
db TWINEEDLE   ,$4D,$19,BUG,$FF,20
db PIN_MISSILE ,$1D,$0E,BUG,$D8,20
db LEER        ,$13,$00,NORMAL,$FF,30
db BITE        ,$1F,$3C,NORMAL,$FF,25
db GROWL       ,$12,$00,NORMAL,$FF,40
db ROAR        ,$1C,$00,NORMAL,$FF,20
db SING        ,$20,$00,NORMAL,$8C,15
db SUPERSONIC  ,$31,$00,NORMAL,$8C,20
db SONICBOOM   ,$29,$01,NORMAL,$E5,20
db DISABLE     ,$56,$00,NORMAL,$8C,20
db ACID        ,$45,$28,POISON,$FF,30
db EMBER       ,$04,$28,FIRE,$FF,25
db FLAMETHROWER,$04,$5F,FIRE,$FF,15
db MIST        ,$2E,$00,ICE,$FF,30
db WATER_GUN   ,$00,$28,WATER,$FF,25
db HYDRO_PUMP  ,$00,$78,WATER,$CC,5
db SURF        ,$00,$5F,WATER,$FF,15
db ICE_BEAM    ,$05,$5F,ICE,$FF,10
db BLIZZARD    ,$05,$78,ICE,$E5,5
db PSYBEAM     ,$4C,$41,PSYCHIC,$FF,20
db BUBBLEBEAM  ,$46,$41,WATER,$FF,20
db AURORA_BEAM ,$44,$41,ICE,$FF,20
db HYPER_BEAM  ,$50,$96,NORMAL,$E5,5
db PECK        ,$00,$23,FLYING,$FF,35
db DRILL_PECK  ,$00,$50,FLYING,$FF,20
db SUBMISSION  ,$30,$50,FIGHTING,$CC,25
db LOW_KICK    ,$25,$32,FIGHTING,$E5,20
db COUNTER     ,$00,$01,FIGHTING,$FF,20
db SEISMIC_TOSS,$29,$01,FIGHTING,$FF,20
db STRENGTH    ,$00,$50,NORMAL,$FF,15
db ABSORB      ,$03,$14,GRASS,$FF,20
db MEGA_DRAIN  ,$03,$28,GRASS,$FF,10
db LEECH_SEED  ,$54,$00,GRASS,$E5,10
db GROWTH      ,$0D,$00,NORMAL,$FF,40
db RAZOR_LEAF  ,$00,$37,GRASS,$F2,25
db SOLARBEAM   ,$27,$78,GRASS,$FF,10
db POISONPOWDER,$42,$00,POISON,$BF,35
db STUN_SPORE  ,$43,$00,GRASS,$BF,30
db SLEEP_POWDER,$20,$00,GRASS,$BF,15
db PETAL_DANCE ,$1B,$46,GRASS,$FF,20
db STRING_SHOT ,$14,$00,BUG,$F2,40
db DRAGON_RAGE ,$29,$01,DRAGON,$FF,10
db FIRE_SPIN   ,$2A,$0F,FIRE,$B2,15
db THUNDERSHOCK,$06,$28,ELECTRIC,$FF,30
db THUNDERBOLT ,$06,$5F,ELECTRIC,$FF,15
db THUNDER_WAVE,$43,$00,ELECTRIC,$FF,20
db THUNDER     ,$06,$78,ELECTRIC,$B2,10
db ROCK_THROW  ,$00,$32,ROCK,$A5,15
db EARTHQUAKE  ,$00,$64,GROUND,$FF,10
db FISSURE     ,$26,$01,GROUND,$4C,5
db DIG         ,$27,$64,GROUND,$FF,10
db TOXIC       ,$42,$00,POISON,$D8,10
db CONFUSION   ,$4C,$32,PSYCHIC,$FF,25
db PSYCHIC_M   ,$47,$5A,PSYCHIC,$FF,10
db HYPNOSIS    ,$20,$00,PSYCHIC,$99,20
db MEDITATE    ,$0A,$00,PSYCHIC,$FF,40
db AGILITY     ,$34,$00,PSYCHIC,$FF,30
db QUICK_ATTACK,$00,$28,NORMAL,$FF,30
db RAGE        ,$51,$14,NORMAL,$FF,20
db TELEPORT    ,$1C,$00,PSYCHIC,$FF,20
db NIGHT_SHADE ,$29,$00,GHOST,$FF,15
db MIMIC       ,$52,$00,NORMAL,$FF,10
db SCREECH     ,$3B,$00,NORMAL,$D8,40
db DOUBLE_TEAM ,$0F,$00,NORMAL,$FF,15
db RECOVER     ,$38,$00,NORMAL,$FF,20
db HARDEN      ,$0B,$00,NORMAL,$FF,30
db MINIMIZE    ,$0F,$00,NORMAL,$FF,20
db SMOKESCREEN ,$16,$00,NORMAL,$FF,20
db CONFUSE_RAY ,$31,$00,GHOST,$FF,10
db WITHDRAW    ,$0B,$00,WATER,$FF,40
db DEFENSE_CURL,$0B,$00,NORMAL,$FF,40
db BARRIER     ,$33,$00,PSYCHIC,$FF,30
db LIGHT_SCREEN,$40,$00,PSYCHIC,$FF,30
db HAZE        ,$19,$00,ICE,$FF,30
db REFLECT     ,$41,$00,PSYCHIC,$FF,20
db FOCUS_ENERGY,$2F,$00,NORMAL,$FF,30
db BIDE        ,$1A,$00,NORMAL,$FF,10
db METRONOME   ,$53,$00,NORMAL,$FF,10
db MIRROR_MOVE ,$09,$00,FLYING,$FF,20
db SELFDESTRUCT,$07,$82,NORMAL,$FF,5
db EGG_BOMB    ,$00,$64,NORMAL,$BF,10
db LICK        ,$24,$14,GHOST,$FF,30
db SMOG        ,$21,$14,POISON,$B2,20
db SLUDGE      ,$21,$41,POISON,$FF,20
db BONE_CLUB   ,$1F,$41,GROUND,$D8,20
db FIRE_BLAST  ,$22,$78,FIRE,$D8,5
db WATERFALL   ,$00,$50,WATER,$FF,15
db CLAMP       ,$2A,$23,WATER,$BF,10
db SWIFT       ,$11,$3C,NORMAL,$FF,20
db SKULL_BASH  ,$27,$64,NORMAL,$FF,15
db SPIKE_CANNON,$1D,$14,NORMAL,$FF,15
db CONSTRICT   ,$46,$0A,NORMAL,$FF,35
db AMNESIA     ,$35,$00,PSYCHIC,$FF,20
db KINESIS     ,$16,$00,PSYCHIC,$CC,15
db SOFTBOILED  ,$38,$00,NORMAL,$FF,10
db HI_JUMP_KICK,$2D,$55,FIGHTING,$E5,20
db GLARE       ,$43,$00,NORMAL,$BF,30
db DREAM_EATER ,$08,$64,PSYCHIC,$FF,15
db POISON_GAS  ,$42,$00,POISON,$8C,40
db BARRAGE     ,$1D,$0F,NORMAL,$D8,20
db LEECH_LIFE  ,$03,$14,BUG,$FF,15
db LOVELY_KISS ,$20,$00,NORMAL,$BF,10
db SKY_ATTACK  ,$27,$8C,FLYING,$E5,5
db TRANSFORM   ,$39,$00,NORMAL,$FF,10
db BUBBLE      ,$46,$14,WATER,$FF,30
db DIZZY_PUNCH ,$00,$46,NORMAL,$FF,10
db SPORE       ,$20,$00,GRASS,$FF,15
db FLASH       ,$16,$00,NORMAL,$B2,20
db PSYWAVE     ,$29,$01,PSYCHIC,$CC,15
db SPLASH      ,$55,$00,NORMAL,$FF,40
db ACID_ARMOR  ,$33,$00,POISON,$FF,40
db CRABHAMMER  ,$00,$5A,WATER,$D8,10
db EXPLOSION   ,$07,$AA,NORMAL,$FF,5
db FURY_SWIPES ,$1D,$12,NORMAL,$CC,15
db BONEMERANG  ,$2C,$32,GROUND,$E5,10
db REST        ,$38,$00,PSYCHIC,$FF,10
db ROCK_SLIDE  ,$00,$4B,ROCK,$E5,10
db HYPER_FANG  ,$1F,$50,NORMAL,$E5,15
db SHARPEN     ,$0A,$00,NORMAL,$FF,30
db CONVERSION  ,$18,$00,NORMAL,$FF,30
db TRI_ATTACK  ,$00,$50,NORMAL,$FF,10
db SUPER_FANG  ,$28,$01,NORMAL,$E5,10
db SLASH       ,$00,$46,NORMAL,$FF,20
db SUBSTITUTE  ,$4F,$00,NORMAL,$FF,10
db STRUGGLE    ,$30,$32,NORMAL,$FF,10

INCBIN "baserom.gbc",$383DE,$39884 - $383DE

ReadAttack: ; 5884
	push hl
	push de
	push bc
	dec a
	ld hl,Attacks
	ld bc,6
	call AddNTimes
	ld de,$CFCC
	call CopyData
	pop bc
	pop de
	pop hl
	ret

; trainer data: from 5C53 to 652E
INCBIN "baserom.gbc",$3989B,$39914 - $3989B

; trainer pic pointers and base money.
dw YoungsterPic
db 0,$15,0

dw BugCatcherPic
db 0,$10,0

dw LassPic
db 0,$15,0

dw SailorPic
db 0,$30,0

dw JrTrainerMPic
db 0,$20,0

dw JrTrainerFPic
db 0,$20,0

dw PokemaniacPic
db 0,$50,0

dw SuperNerdPic
db 0,$25,0

dw HikerPic
db 0,$35,0

dw BikerPic
db 0,$20,0

dw BurglarPic
db 0,$90,0

dw EngineerPic
db 0,$50,0

dw JugglerPic
db 0,$35,0

dw FisherPic
db 0,$35,0

dw SwimmerPic
db 0,$05,0

dw CueBallPic
db 0,$25,0

dw GamblerPic
db 0,$70,0

dw BeautyPic
db 0,$70,0

dw PsychicPic
db 0,$10,0

dw RockerPic
db 0,$25,0

dw JugglerPic
db 0,$35,0

dw TamerPic
db 0,$40,0

dw BirdKeeperPic
db 0,$25,0

dw BlackbeltPic
db 0,$25,0

dw Rival1Pic
db 0,$35,0

dw ProfOakPic
db 0,$99,0

dw ChiefPic
db 0,$30,0

dw ScientistPic
db 0,$50,0

dw GiovanniPic
db 0,$99,0

dw RocketPic
db 0,$30,0

dw CooltrainerMPic
db 0,$35,0

dw CooltrainerFPic
db 0,$35,0

dw BrunoPic
db 0,$99,0

dw BrockPic
db 0,$99,0

dw MistyPic
db 0,$99,0

dw LtSurgePic
db 0,$99,0

dw ErikaPic
db 0,$99,0

dw KogaPic
db 0,$99,0

dw BlainePic
db 0,$99,0

dw SabrinaPic
db 0,$99,0

dw GentlemanPic
db 0,$70,0

dw Rival2Pic
db 0,$65,0

dw Rival3Pic
db 0,$99,0

dw LoreleiPic
db 0,$99,0

dw ChannelerPic
db 0,$30,0

dw AgathaPic
db 0,$99,0

dw LancePic
db 0,$99,0

TrainerNames: ; 59FF
	db "YOUNGSTER@"
	db "BUG CATCHER@"
	db "LASS@"
	db "SAILOR@"
	db "JR.TRAINER♂@"
	db "JR.TRAINER♀@"
	db "POKéMANIAC@"
	db "SUPER NERD@"
	db "HIKER@"
	db "BIKER@"
	db "BURGLAR@"
	db "ENGINEER@"
	db "JUGGLER@"
	db "FISHERMAN@"
	db "SWIMMER@"
	db "CUE BALL@"
	db "GAMBLER@"
	db "BEAUTY@"
	db "PSYCHIC@"
	db "ROCKER@"
	db "JUGGLER@"
	db "TAMER@"
	db "BIRD KEEPER@"
	db "BLACKBELT@"
	db "RIVAL1@"
	db "PROF.OAK@"
	db "CHIEF@"
	db "SCIENTIST@"
	db "GIOVANNI@"
	db "ROCKET@"
	db "COOLTRAINER♂@"
	db "COOLTRAINER♀@"
	db "BRUNO@"
	db "BROCK@"
	db "MISTY@"
	db "LT.SURGE@"
	db "ERIKA@"
	db "KOGA@"
	db "BLAINE@"
	db "SABRINA@"
	db "GENTLEMAN@"
	db "RIVAL2@"
	db "RIVAL3@"
	db "LORELEI@"
	db "CHANNELER@"
	db "AGATHA@"
	db "LANCE@"

INCBIN "baserom.gbc",$39B87,$39C53 - $39B87
ReadTrainer: ; 5C53

; don't change any moves in a link battle
	ld a,[W_ISLINKBATTLE]
	and a
	ret nz

; set [W_ENEMYMONCOUNT] to 0, [$D89D] to FF
; XXX first is total enemy pokemon?
; XXX second is species of first pokemon?
	ld hl,W_ENEMYMONCOUNT
	xor a
	ld [hli],a
	dec a
	ld [hl],a

; get the pointer to trainer data for this class
	ld a,[W_CUROPPONENT]
	sub $C9 ; convert value from pokemon to trainer
	add a,a
	ld hl,TrainerDataPointers
	ld c,a
	ld b,0
	add hl,bc ; hl points to trainer class
	ld a,[hli]
	ld h,[hl]
	ld l,a
	ld a,[W_TRAINERNO]
	ld b,a
; At this point b contains the trainer number,
; and hl points to the trainer class.
; Our next task is to iterate through the trainers,
; decrementing b each time, until we get to the right one.
.outer\@
	dec b
	jr z,.IterateTrainer
.inner\@
	ld a,[hli]
	and a
	jr nz,.inner\@
	jr .outer\@

; if the first byte of trainer data is FF,
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [W_LONEATTACKNO] != 0, one pokemon on the team has a special move
; else the first byte is the level of every pokemon on the team
.IterateTrainer
	ld a,[hli]
	cp $FF ; is the trainer special?
	jr z,.SpecialTrainer\@ ; if so, check for special attacks
	ld [W_CURENEMYLVL],a
.LoopTrainerData\@
	ld a,[hli]
	and a ; have we reached the end of the trainer data?
	jr z,.FinishUp\@
	ld [$CF91],a ; write species somewhere (XXX why?)
	ld a,1
	ld [$CC49],a
	push hl
	call AddPokemonToParty
	pop hl
	jr .LoopTrainerData\@
.SpecialTrainer\@
; if this code is being run:
; - each pokemon has a specific level
;      (as opposed to the whole team being of the same level)
; - if [W_LONEATTACKNO] != 0, one pokemon on the team has a special move
	ld a,[hli]
	and a ; have we reached the end of the trainer data?
	jr z,.AddLoneAttack\@
	ld [W_CURENEMYLVL],a
	ld a,[hli]
	ld [$CF91],a
	ld a,1
	ld [$CC49],a
	push hl
	call AddPokemonToParty
	pop hl
	jr .SpecialTrainer\@
.AddLoneAttack\@
; does the trainer have a single monster with a different move
	ld a,[W_LONEATTACKNO] ; Brock is 01, Misty is 02, Erika is 04, etc
	and a
	jr z,.AddTeamAttack\@
	dec a
	add a,a
	ld c,a
	ld b,0
	ld hl,LoneAttacks
	add hl,bc
	ld a,[hli]
	ld d,[hl]
	ld hl,W_ENEMYMON1MOVE3
	ld bc,W_ENEMYMON2MOVE3 - W_ENEMYMON1MOVE3
	call AddNTimes
	ld [hl],d
	jr .FinishUp\@
.AddTeamAttack\@
; check if our trainer's team has special moves

; get trainer class number
	ld a,[$D059]
	sub $C8
	ld b,a
	ld hl,TeamAttacks

; iterate through entries in TeamAttacks, checking each for our trainer class
.IterateTeamAttacks\@
	ld a,[hli]
	cp b
	jr z,.GiveTeamAttacks\@ ; is there a match?
	inc hl ; if not, go to the next entry
	inc a
	jr nz,.IterateTeamAttacks\@

	; no matches found. is this trainer champion rival?
	ld a,b
	cp SONY3
	jr z,.ChampionRival\@
	jr .FinishUp\@ ; nope
.GiveTeamAttacks\@
	ld a,[hl]
	ld [$D95E],a
	jr .FinishUp\@
.ChampionRival\@ ; give attacks to his team

; pidgeot
	ld a,SKY_ATTACK
	ld [W_ENEMYMON1MOVE3],a

; starter
	ld a,[W_RIVALSTARTER]
	cp BULBASAUR
	ld b,MEGA_DRAIN
	jr z,.GiveStarterMove\@
	cp CHARMANDER
	ld b,FIRE_BLAST
	jr z,.GiveStarterMove\@
	ld b,BLIZZARD ; must be squirtle
.GiveStarterMove\@
	ld a,b
	ld [W_ENEMYMON6MOVE3],a
.FinishUp\@ ; XXX this needs documenting
	xor a       ; clear D079-D07B
	ld de,$D079
	ld [de],a
	inc de
	ld [de],a
	inc de
	ld [de],a
	ld a,[W_CURENEMYLVL]
	ld b,a
.LastLoop\@
	ld hl,$D047
	ld c,2
	push bc
	ld a,$B
	call Predef
	pop bc
	inc de
	inc de
	dec b
	jr nz,.LastLoop\@
	ret

LoneAttacks: ; 5D22
; these are used for gym leaders.
; this is not automatic! you have to write the number you want to W_LONEATTACKNO
; first. e.g., erika's script writes 4 to W_LONEATTACKNO to get mega drain,
; the fourth entry in the list.

; first byte:  pokemon in the trainer's party that gets the move
; second byte: move
; unterminated
	db 1,BIDE
	db 1,BUBBLEBEAM
	db 2,THUNDERBOLT
	db 2,MEGA_DRAIN
	db 3,TOXIC
	db 3,PSYWAVE
	db 3,FIRE_BLAST
	db 4,FISSURE

TeamAttacks: ; 5D32
; these are used for elite four.
; this is automatic, based on trainer class.
; don't be confused by LoneAttacks above, the two data structures are
	; _completely_ unrelated.

; first byte: trainer (all trainers in this class have this move)
; second byte: move
; ff-terminated
	db LORELEI,BLIZZARD
	db BRUNO,FISSURE
	db AGATHA,TOXIC
	db LANCE,BARRIER
	db $FF

TrainerDataPointers: ; 5D3B
	dw YoungsterData,BugCatcherData,LassData,SailorData,JrTrainerMData
	dw JrTrainerFData,PokemaniacData,SuperNerdData,HikerData,BikerData
	dw BurglarData,EngineerData,Juggler1Data,FisherData,SwimmerData
	dw CueBallData,GamblerData,BeautyData,PsychicData,RockerData
	dw JugglerData,TamerData,BirdKeeperData,BlackbeltData,Green1Data
	dw ProfOakData,ChiefData,ScientistData,GiovanniData,RocketData
	dw CooltrainerMData,CooltrainerFData,BrunoData,BrockData,MistyData
	dw LtSurgeData,ErikaData,KogaData,BlaineData,SabrinaData
	dw GentlemanData,Green2Data,Green3Data,LoreleiData,ChannelerData
	dw AgathaData,LanceData

; if first byte != FF, then
	; first byte is level (of all pokemon on this team)
	; all the next bytes are pokemon species
	; null-terminated
; if first byte == FF, then
	; first byte is FF (obviously)
	; every next two bytes are a level and species
	; null-terminated

YoungsterData:
	db 11,RATTATA,EKANS,0
	db 14,SPEAROW,0
	db 10,RATTATA,RATTATA,ZUBAT,0
	db 14,RATTATA,EKANS,ZUBAT,0
	db 15,RATTATA,SPEAROW,0
	db 17,SLOWPOKE,0
	db 14,EKANS,SANDSHREW,0
	db 21,NIDORAN_M,0
	db 21,EKANS,0
	db 19,SANDSHREW,ZUBAT,0
	db 17,RATTATA,RATTATA,RATICATE,0
	db 18,NIDORAN_M,NIDORINO,0
	db 17,SPEAROW,RATTATA,RATTATA,SPEAROW,0
BugCatcherData:
	db 6,WEEDLE,CATERPIE,0
	db 7,WEEDLE,KAKUNA,WEEDLE,0
	db 9,WEEDLE,0
	db 10,CATERPIE,WEEDLE,CATERPIE,0
	db 9,WEEDLE,KAKUNA,CATERPIE,METAPOD,0
	db 11,CATERPIE,METAPOD,0
	db 11,WEEDLE,KAKUNA,0
	db 10,CATERPIE,METAPOD,CATERPIE,0
	db 14,CATERPIE,WEEDLE,0
	db 16,WEEDLE,CATERPIE,WEEDLE,0
	db 20,BUTTERFREE,0
	db 18,METAPOD,CATERPIE,VENONAT,0
	db 19,BEEDRILL,BEEDRILL,0
	db 20,CATERPIE,WEEDLE,VENONAT,0
LassData:
	db 9,PIDGEY,PIDGEY,0
	db 10,RATTATA,NIDORAN_M,0
	db 14,JIGGLYPUFF,0
	db 31,PARAS,PARAS,PARASECT,0
	db 11,ODDISH,BELLSPROUT,0
	db 14,CLEFAIRY,0
	db 16,PIDGEY,NIDORAN_F,0
	db 14,PIDGEY,NIDORAN_F,0
	db 15,NIDORAN_M,NIDORAN_F,0
	db 13,ODDISH,PIDGEY,ODDISH,0
	db 18,PIDGEY,NIDORAN_F,0
	db 18,RATTATA,PIKACHU,0
	db 23,NIDORAN_F,NIDORINA,0
	db 24,MEOWTH,MEOWTH,MEOWTH,0
	db 19,PIDGEY,RATTATA,NIDORAN_M,MEOWTH,PIKACHU,0
	db 22,CLEFAIRY,CLEFAIRY,0
	db 23,BELLSPROUT,WEEPINBELL,0
	db 23,ODDISH,GLOOM,0
SailorData:
	db 18,MACHOP,SHELLDER,0
	db 17,MACHOP,TENTACOOL,0
	db 21,SHELLDER,0
	db 17,HORSEA,SHELLDER,TENTACOOL,0
	db 18,TENTACOOL,STARYU,0
	db 17,HORSEA,HORSEA,HORSEA,0
	db 20,MACHOP,0
	db 21,PIKACHU,PIKACHU,0
JrTrainerMData:
	db 11,DIGLETT,SANDSHREW,0
	db 14,RATTATA,EKANS,0
	db 18,MANKEY,0
	db 20,SQUIRTLE,0
	db 16,SPEAROW,RATICATE,0
	db 18,DIGLETT,DIGLETT,SANDSHREW,0
	db 21,GROWLITHE,CHARMANDER,0
	db 19,RATTATA,DIGLETT,EKANS,SANDSHREW,0
	db 29,NIDORAN_M,NIDORINO,0
JrTrainerFData:
	db 19,GOLDEEN,0
	db 16,RATTATA,PIKACHU,0
	db 16,PIDGEY,PIDGEY,PIDGEY,0
	db 22,BULBASAUR,0
	db 18,ODDISH,BELLSPROUT,ODDISH,BELLSPROUT,0
	db 23,MEOWTH,0
	db 20,PIKACHU,CLEFAIRY,0
	db 21,PIDGEY,PIDGEOTTO,0
	db 21,JIGGLYPUFF,PIDGEY,MEOWTH,0
	db 22,ODDISH,BULBASAUR,0
	db 24,BULBASAUR,IVYSAUR,0
	db 24,PIDGEY,MEOWTH,RATTATA,PIKACHU,MEOWTH,0
	db 30,POLIWAG,POLIWAG,0
	db 27,PIDGEY,MEOWTH,PIDGEY,PIDGEOTTO,0
	db 28,GOLDEEN,POLIWAG,HORSEA,0
	db 31,GOLDEEN,SEAKING,0
	db 22,BELLSPROUT,CLEFAIRY,0
	db 20,MEOWTH,ODDISH,PIDGEY,0
	db 19,PIDGEY,RATTATA,RATTATA,BELLSPROUT,0
	db 28,GLOOM,ODDISH,ODDISH,0
	db 29,PIKACHU,RAICHU,0
	db 33,CLEFAIRY,0
	db 29,BELLSPROUT,ODDISH,TANGELA,0
	db 30,TENTACOOL,HORSEA,SEEL,0
PokemaniacData:
	db 30,RHYHORN,LICKITUNG,0
	db 20,CUBONE,SLOWPOKE,0
	db 20,SLOWPOKE,SLOWPOKE,SLOWPOKE,0
	db 22,CHARMANDER,CUBONE,0
	db 25,SLOWPOKE,0
	db 40,CHARMELEON,LAPRAS,LICKITUNG,0
	db 23,CUBONE,SLOWPOKE,0
SuperNerdData:
	db 11,MAGNEMITE,VOLTORB,0
	db 12,GRIMER,VOLTORB,KOFFING,0
	db 20,VOLTORB,KOFFING,VOLTORB,MAGNEMITE,0
	db 22,GRIMER,MUK,GRIMER,0
	db 26,KOFFING,0
	db 22,KOFFING,MAGNEMITE,WEEZING,0
	db 20,MAGNEMITE,MAGNEMITE,KOFFING,MAGNEMITE,0
	db 24,MAGNEMITE,VOLTORB,0
	db 36,VULPIX,VULPIX,NINETALES,0
	db 34,PONYTA,CHARMANDER,VULPIX,GROWLITHE,0
	db 41,RAPIDASH,0
	db 37,GROWLITHE,VULPIX,0
HikerData:
	db 10,GEODUDE,GEODUDE,ONIX,0
	db 15,MACHOP,GEODUDE,0
	db 13,GEODUDE,GEODUDE,MACHOP,GEODUDE,0
	db 17,ONIX,0
	db 21,GEODUDE,ONIX,0
	db 20,GEODUDE,MACHOP,GEODUDE,0
	db 21,GEODUDE,ONIX,0
	db 19,ONIX,GRAVELER,0
	db 21,GEODUDE,GEODUDE,GRAVELER,0
	db 25,GEODUDE,0
	db 20,MACHOP,ONIX,0
	db 19,GEODUDE,MACHOP,GEODUDE,GEODUDE,0
	db 20,ONIX,ONIX,GEODUDE,0
	db 21,GEODUDE,GRAVELER,0
BikerData:
	db 28,KOFFING,KOFFING,KOFFING,0
	db 29,KOFFING,GRIMER,0
	db 25,KOFFING,KOFFING,WEEZING,KOFFING,GRIMER,0
	db 28,KOFFING,GRIMER,WEEZING,0
	db 29,GRIMER,KOFFING,0
	db 33,WEEZING,0
	db 26,GRIMER,GRIMER,GRIMER,GRIMER,0
	db 28,WEEZING,KOFFING,WEEZING,0
	db 33,MUK,0
	db 29,VOLTORB,VOLTORB,0
	db 29,WEEZING,MUK,0
	db 25,KOFFING,WEEZING,KOFFING,KOFFING,WEEZING,0
	db 26,KOFFING,KOFFING,GRIMER,KOFFING,0
	db 28,GRIMER,GRIMER,KOFFING,0
	db 29,KOFFING,MUK,0
BurglarData:
	db 29,GROWLITHE,VULPIX,0
	db 33,GROWLITHE,0
	db 28,VULPIX,CHARMANDER,PONYTA,0
	db 36,GROWLITHE,VULPIX,NINETALES,0
	db 41,PONYTA,0
	db 37,VULPIX,GROWLITHE,0
	db 34,CHARMANDER,CHARMELEON,0
	db 38,NINETALES,0
	db 34,GROWLITHE,PONYTA,0
EngineerData:
	db 21,VOLTORB,MAGNEMITE,0
	db 21,MAGNEMITE,0
	db 18,MAGNEMITE,MAGNEMITE,MAGNETON,0
Juggler1Data:
; none
FisherData:
	db 17,GOLDEEN,TENTACOOL,GOLDEEN,0
	db 17,TENTACOOL,STARYU,SHELLDER,0
	db 22,GOLDEEN,POLIWAG,GOLDEEN,0
	db 24,TENTACOOL,GOLDEEN,0
	db 27,GOLDEEN,0
	db 21,POLIWAG,SHELLDER,GOLDEEN,HORSEA,0
	db 28,SEAKING,GOLDEEN,SEAKING,SEAKING,0
	db 31,SHELLDER,CLOYSTER,0
	db 27,MAGIKARP,MAGIKARP,MAGIKARP,MAGIKARP,MAGIKARP,MAGIKARP,0
	db 33,SEAKING,GOLDEEN,0
	db 24,MAGIKARP,MAGIKARP,0
SwimmerData:
	db 16,HORSEA,SHELLDER,0
	db 30,TENTACOOL,SHELLDER,0
	db 29,GOLDEEN,HORSEA,STARYU,0
	db 30,POLIWAG,POLIWHIRL,0
	db 27,HORSEA,TENTACOOL,TENTACOOL,GOLDEEN,0
	db 29,GOLDEEN,SHELLDER,SEAKING,0
	db 30,HORSEA,HORSEA,0
	db 27,TENTACOOL,TENTACOOL,STARYU,HORSEA,TENTACRUEL,0
	db 31,SHELLDER,CLOYSTER,0
	db 35,STARYU,0
	db 28,HORSEA,HORSEA,SEADRA,HORSEA,0
	db 33,SEADRA,TENTACRUEL,0
	db 37,STARMIE,0
	db 33,STARYU,WARTORTLE,0
	db 32,POLIWHIRL,TENTACOOL,SEADRA,0
CueBallData:
	db 28,MACHOP,MANKEY,MACHOP,0
	db 29,MANKEY,MACHOP,0
	db 33,MACHOP,0
	db 29,MANKEY,PRIMEAPE,0
	db 29,MACHOP,MACHOKE,0
	db 33,MACHOKE,0
	db 26,MANKEY,MANKEY,MACHOKE,MACHOP,0
	db 29,PRIMEAPE,MACHOKE,0
	db 31,TENTACOOL,TENTACOOL,TENTACRUEL,0
GamblerData:
	db 18,POLIWAG,HORSEA,0
	db 18,BELLSPROUT,ODDISH,0
	db 18,VOLTORB,MAGNEMITE,0
	db 18,GROWLITHE,VULPIX,0
	db 22,POLIWAG,POLIWAG,POLIWHIRL,0
	db 22,ONIX,GEODUDE,GRAVELER,0
	db 24,GROWLITHE,VULPIX,0
BeautyData:
	db 21,ODDISH,BELLSPROUT,ODDISH,BELLSPROUT,0
	db 24,BELLSPROUT,BELLSPROUT,0
	db 26,EXEGGCUTE,0
	db 27,RATTATA,PIKACHU,RATTATA,0
	db 29,CLEFAIRY,MEOWTH,0
	db 35,SEAKING,0
	db 30,SHELLDER,SHELLDER,CLOYSTER,0
	db 31,POLIWAG,SEAKING,0
	db 29,PIDGEOTTO,WIGGLYTUFF,0
	db 29,BULBASAUR,IVYSAUR,0
	db 33,WEEPINBELL,BELLSPROUT,WEEPINBELL,0
	db 27,POLIWAG,GOLDEEN,SEAKING,GOLDEEN,POLIWAG,0
	db 30,GOLDEEN,SEAKING,0
	db 29,STARYU,STARYU,STARYU,0
	db 30,SEADRA,HORSEA,SEADRA,0
PsychicData:
	db 31,KADABRA,SLOWPOKE,MR_MIME,KADABRA,0
	db 34,MR_MIME,KADABRA,0
	db 33,SLOWPOKE,SLOWPOKE,SLOWBRO,0
	db 38,SLOWBRO,0
RockerData:
	db 20,VOLTORB,MAGNEMITE,VOLTORB,0
	db 29,VOLTORB,ELECTRODE,0
JugglerData:
	db 29,KADABRA,MR_MIME,0
	db 41,DROWZEE,HYPNO,KADABRA,KADABRA,0
	db 31,DROWZEE,DROWZEE,KADABRA,DROWZEE,0
	db 34,DROWZEE,HYPNO,0
	db 48,MR_MIME,0
	db 33,HYPNO,0
	db 38,HYPNO,0
	db 34,DROWZEE,KADABRA,0
TamerData:
	db 34,SANDSLASH,ARBOK,0
	db 33,ARBOK,SANDSLASH,ARBOK,0
	db 43,RHYHORN,0
	db 39,ARBOK,TAUROS,0
	db 44,PERSIAN,GOLDUCK,0
	db 42,RHYHORN,PRIMEAPE,ARBOK,TAUROS,0
BirdKeeperData:
	db 29,PIDGEY,PIDGEOTTO,0
	db 25,SPEAROW,PIDGEY,PIDGEY,SPEAROW,SPEAROW,0
	db 26,PIDGEY,PIDGEOTTO,SPEAROW,FEAROW,0
	db 33,FARFETCH_D,0
	db 29,SPEAROW,FEAROW,0
	db 26,PIDGEOTTO,FARFETCH_D,DODUO,PIDGEY,0
	db 28,DODRIO,DODUO,DODUO,0
	db 29,SPEAROW,FEAROW,0
	db 34,DODRIO,0
	db 26,SPEAROW,SPEAROW,FEAROW,SPEAROW,0
	db 30,FEAROW,FEAROW,PIDGEOTTO,0
	db 39,PIDGEOTTO,PIDGEOTTO,PIDGEY,PIDGEOTTO,0
	db 42,FARFETCH_D,FEAROW,0
	db 28,PIDGEY,DODUO,PIDGEOTTO,0
	db 26,PIDGEY,SPEAROW,PIDGEY,FEAROW,0
	db 29,PIDGEOTTO,FEAROW,0
	db 28,SPEAROW,DODUO,FEAROW,0
BlackbeltData:
	db 37,HITMONLEE,HITMONCHAN,0
	db 31,MANKEY,MANKEY,PRIMEAPE,0
	db 32,MACHOP,MACHOKE,0
	db 36,PRIMEAPE,0
	db 31,MACHOP,MANKEY,PRIMEAPE,0
	db 40,MACHOP,MACHOKE,0
	db 43,MACHOKE,0
	db 38,MACHOKE,MACHOP,MACHOKE,0
	db 43,MACHOKE,MACHOP,MACHOKE,0
Green1Data:
	db 5,SQUIRTLE,0
	db 5,BULBASAUR,0
	db 5,CHARMANDER,0
	db $FF,9,PIDGEY,8,SQUIRTLE,0
	db $FF,9,PIDGEY,8,BULBASAUR,0
	db $FF,9,PIDGEY,8,CHARMANDER,0
	db $FF,18,PIDGEOTTO,15,ABRA,15,RATTATA,17,SQUIRTLE,0
	db $FF,18,PIDGEOTTO,15,ABRA,15,RATTATA,17,BULBASAUR,0
	db $FF,18,PIDGEOTTO,15,ABRA,15,RATTATA,17,CHARMANDER,0
ProfOakData:
	db $FF,66,TAUROS,67,EXEGGUTOR,68,ARCANINE,69,BLASTOISE,70,GYARADOS,0
	db $FF,66,TAUROS,67,EXEGGUTOR,68,ARCANINE,69,VENUSAUR,70,GYARADOS,0
	db $FF,66,TAUROS,67,EXEGGUTOR,68,ARCANINE,69,CHARIZARD,70,GYARADOS,0
ChiefData:
; none
ScientistData:
	db 34,KOFFING,VOLTORB,0
	db 26,GRIMER,WEEZING,KOFFING,WEEZING,0
	db 28,MAGNEMITE,VOLTORB,MAGNETON,0
	db 29,ELECTRODE,WEEZING,0
	db 33,ELECTRODE,0
	db 26,MAGNETON,KOFFING,WEEZING,MAGNEMITE,0
	db 25,VOLTORB,KOFFING,MAGNETON,MAGNEMITE,KOFFING,0
	db 29,ELECTRODE,MUK,0
	db 29,GRIMER,ELECTRODE,0
	db 28,VOLTORB,KOFFING,MAGNETON,0
	db 29,MAGNEMITE,KOFFING,0
	db 33,MAGNEMITE,MAGNETON,VOLTORB,0
	db 34,MAGNEMITE,ELECTRODE,0
GiovanniData:
	db $FF,25,ONIX,24,RHYHORN,29,KANGASKHAN,0
	db $FF,37,NIDORINO,35,KANGASKHAN,37,RHYHORN,41,NIDOQUEEN,0
	db $FF,45,RHYHORN,42,DUGTRIO,44,NIDOQUEEN,45,NIDOKING,50,RHYDON,0
RocketData:
	db 13,RATTATA,ZUBAT,0
	db 11,SANDSHREW,RATTATA,ZUBAT,0
	db 12,ZUBAT,EKANS,0
	db 16,RATICATE,0
	db 17,MACHOP,DROWZEE,0
	db 15,EKANS,ZUBAT,0
	db 20,RATICATE,ZUBAT,0
	db 21,DROWZEE,MACHOP,0
	db 21,RATICATE,RATICATE,0
	db 20,GRIMER,KOFFING,KOFFING,0
	db 19,RATTATA,RATICATE,RATICATE,RATTATA,0
	db 22,GRIMER,KOFFING,0
	db 17,ZUBAT,KOFFING,GRIMER,ZUBAT,RATICATE,0
	db 20,RATTATA,RATICATE,DROWZEE,0
	db 21,MACHOP,MACHOP,0
	db 23,SANDSHREW,EKANS,SANDSLASH,0
	db 23,EKANS,SANDSHREW,ARBOK,0
	db 21,KOFFING,ZUBAT,0
	db 25,ZUBAT,ZUBAT,GOLBAT,0
	db 26,KOFFING,DROWZEE,0
	db 23,ZUBAT,RATTATA,RATICATE,ZUBAT,0
	db 26,DROWZEE,KOFFING,0
	db 29,CUBONE,ZUBAT,0
	db 25,GOLBAT,ZUBAT,ZUBAT,RATICATE,ZUBAT,0
	db 28,RATICATE,HYPNO,RATICATE,0
	db 29,MACHOP,DROWZEE,0
	db 28,EKANS,ZUBAT,CUBONE,0
	db 33,ARBOK,0
	db 33,HYPNO,0
	db 29,MACHOP,MACHOKE,0
	db 28,ZUBAT,ZUBAT,GOLBAT,0
	db 26,RATICATE,ARBOK,KOFFING,GOLBAT,0
	db 29,CUBONE,CUBONE,0
	db 29,SANDSHREW,SANDSLASH,0
	db 26,RATICATE,ZUBAT,GOLBAT,RATTATA,0
	db 28,WEEZING,GOLBAT,KOFFING,0
	db 28,DROWZEE,GRIMER,MACHOP,0
	db 28,GOLBAT,DROWZEE,HYPNO,0
	db 33,MACHOKE,0
	db 25,RATTATA,RATTATA,ZUBAT,RATTATA,EKANS,0
	db 32,CUBONE,DROWZEE,MAROWAK,0
CooltrainerMData:
	db 39,NIDORINO,NIDOKING,0
	db 43,EXEGGUTOR,CLOYSTER,ARCANINE,0
	db 43,KINGLER,TENTACRUEL,BLASTOISE,0
	db 45,KINGLER,STARMIE,0
	db 42,IVYSAUR,WARTORTLE,CHARMELEON,CHARIZARD,0
	db 44,IVYSAUR,WARTORTLE,CHARMELEON,0
	db 49,NIDOKING,0
	db 44,KINGLER,CLOYSTER,0
	db 39,SANDSLASH,DUGTRIO,0
	db 43,RHYHORN,0
CooltrainerFData:
	db 24,WEEPINBELL,GLOOM,IVYSAUR,0
	db 43,BELLSPROUT,WEEPINBELL,VICTREEBEL,0
	db 43,PARASECT,DEWGONG,CHANSEY,0
	db 46,VILEPLUME,BUTTERFREE,0
	db 44,PERSIAN,NINETALES,0
	db 45,IVYSAUR,VENUSAUR,0
	db 45,NIDORINA,NIDOQUEEN,0
	db 43,PERSIAN,NINETALES,RAICHU,0
BrunoData:
	db $FF,53,ONIX,55,HITMONCHAN,55,HITMONLEE,56,ONIX,58,MACHAMP,0
BrockData:
	db $FF,12,GEODUDE,14,ONIX,0
MistyData:
	db $FF,18,STARYU,21,STARMIE,0
LtSurgeData:
	db $FF,21,VOLTORB,18,PIKACHU,24,RAICHU,0
ErikaData:
	db $FF,29,VICTREEBEL,24,TANGELA,29,VILEPLUME,0
KogaData:
	db $FF,37,KOFFING,39,MUK,37,KOFFING,43,WEEZING,0
BlaineData:
	db $FF,42,GROWLITHE,40,PONYTA,42,RAPIDASH,47,ARCANINE,0
SabrinaData:
	db $FF,38,KADABRA,37,MR_MIME,38,VENOMOTH,43,ALAKAZAM,0
GentlemanData:
	db 18,GROWLITHE,GROWLITHE,0
	db 19,NIDORAN_M,NIDORAN_F,0
	db 23,PIKACHU,0
	db 48,PRIMEAPE,0
	db 17,GROWLITHE,PONYTA,0
Green2Data:
	db $FF,19,PIDGEOTTO,16,RATICATE,18,KADABRA,20,WARTORTLE,0
	db $FF,19,PIDGEOTTO,16,RATICATE,18,KADABRA,20,IVYSAUR,0
	db $FF,19,PIDGEOTTO,16,RATICATE,18,KADABRA,20,CHARMELEON,0
	db $FF,25,PIDGEOTTO,23,GROWLITHE,22,EXEGGCUTE,20,KADABRA,25,WARTORTLE,0
	db $FF,25,PIDGEOTTO,23,GYARADOS,22,GROWLITHE,20,KADABRA,25,IVYSAUR,0
	db $FF,25,PIDGEOTTO,23,EXEGGCUTE,22,GYARADOS,20,KADABRA,25,CHARMELEON,0
	db $FF,37,PIDGEOT,38,GROWLITHE,35,EXEGGCUTE,35,ALAKAZAM,40,BLASTOISE,0
	db $FF,37,PIDGEOT,38,GYARADOS,35,GROWLITHE,35,ALAKAZAM,40,VENUSAUR,0
	db $FF,37,PIDGEOT,38,EXEGGCUTE,35,GYARADOS,35,ALAKAZAM,40,CHARIZARD,0
	db $FF,47,PIDGEOT,45,RHYHORN,45,GROWLITHE,47,EXEGGCUTE,50,ALAKAZAM ;\
		db 53,BLASTOISE,0
	db $FF,47,PIDGEOT,45,RHYHORN,45,GYARADOS,47,GROWLITHE,50,ALAKAZAM ;\
		db 53,VENUSAUR,0
	db $FF,47,PIDGEOT,45,RHYHORN,45,EXEGGCUTE,47,GYARADOS,50,ALAKAZAM ;\
		db 53,CHARIZARD,0
Green3Data:
	db $FF,61,PIDGEOT,59,ALAKAZAM,61,RHYDON,61,ARCANINE,63,EXEGGUTOR ;\
		db 65,BLASTOISE,0
	db $FF,61,PIDGEOT,59,ALAKAZAM,61,RHYDON,61,GYARADOS,63,ARCANINE ;\
		db 65,VENUSAUR,0
	db $FF,61,PIDGEOT,59,ALAKAZAM,61,RHYDON,61,EXEGGUTOR,63,GYARADOS ;\
		db 65,CHARIZARD,0
LoreleiData:
	db $FF,54,DEWGONG,53,CLOYSTER,54,SLOWBRO,56,JYNX,56,LAPRAS,0
ChannelerData:
	db 22,GASTLY,0
	db 24,GASTLY,0
	db 23,GASTLY,GASTLY,0
	db 24,GASTLY,0
	db 23,GASTLY,0
	db 24,GASTLY,0
	db 24,HAUNTER,0
	db 22,GASTLY,0
	db 24,GASTLY,0
	db 23,GASTLY,GASTLY,0
	db 24,GASTLY,0
	db 22,GASTLY,0
	db 24,GASTLY,0
	db 23,HAUNTER,0
	db 24,GASTLY,0
	db 22,GASTLY,0
	db 24,GASTLY,0
	db 22,HAUNTER,0
	db 22,GASTLY,GASTLY,GASTLY,0
	db 24,GASTLY,0
	db 24,GASTLY,0
	db 34,GASTLY,HAUNTER,0
	db 38,HAUNTER,0
	db 33,GASTLY,GASTLY,HAUNTER,0
AgathaData:
	db $FF,56,GENGAR,56,GOLBAT,55,HAUNTER,58,ARBOK,60,GENGAR,0
LanceData:
	db $FF,58,GYARADOS,56,DRAGONAIR,56,DRAGONAIR,60,AERODACTYL ;\
		db 62,DRAGONITE,0

TrainerAI: ; 652E
;XXX called at 34964, 3c342, 3c398
	and a
	ld a,[W_ISINBATTLE]
	dec a
	ret z ; if not a trainer, we're done here
	ld a,[W_ISLINKBATTLE]
	cp 4
	ret z
	ld a,[W_TRAINERCLASS] ; what trainer class is this?
	dec a
	ld c,a
	ld b,0
	ld hl,TrainerAIPointers
	add hl,bc
	add hl,bc
	add hl,bc
	ld a,[W_AICOUNT]
	and a
	ret z ; if no AI uses left, we're done here
	inc hl
	inc a
	jr nz,.getpointer\@
	dec hl
	ld a,[hli]
	ld [W_AICOUNT],a
.getpointer\@
	ld a,[hli]
	ld h,[hl]
	ld l,a
	call GenRandom
	jp [hl]

TrainerAIPointers: ; 655C
; one entry per trainer class
; first byte, number of times (per Pokémon) it can occur
; next two bytes, pointer to AI subroutine for trainer class
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,JugglerAI ; juggler_x
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 3,JugglerAI ; juggler
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 2,BlackbeltAI ; blackbelt
	dbw 3,GenericAI
	dbw 3,GenericAI
	dbw 1,GenericAI ; chief
	dbw 3,GenericAI
	dbw 1,GiovanniAI ; giovanni
	dbw 3,GenericAI
	dbw 2,CooltrainerMAI ; cooltrainerm
	dbw 1,CooltrainerFAI ; cooltrainerf
	dbw 2,BrunoAI ; bruno
	dbw 5,BrockAI ; brock
	dbw 1,MistyAI ; misty
	dbw 1,LtSurgeAI ; surge
	dbw 1,ErikaAI ; erika
	dbw 2,KogaAI ; koga
	dbw 2,BlaineAI ; blaine
	dbw 1,SabrinaAI ; sabrina
	dbw 3,GenericAI
	dbw 1,Sony2AI ; sony2
	dbw 1,Sony3AI ; sony3
	dbw 2,LoreleiAI ; lorelei
	dbw 3,GenericAI
	dbw 2,AgathaAI ; agatha
	dbw 1,LanceAI ; lance

JugglerAI:
	cp $40
	ret nc
	jp $672A

BlackbeltAI:
	cp $20
	ret nc
	jp AIUseXAttack

GiovanniAI:
	cp $40
	ret nc
	jp AIUseGuardSpec

CooltrainerMAI:
	cp $40
	ret nc
	jp AIUseXAttack

CooltrainerFAI:
	cp $40
	ld a,$A
	call $67CF
	jp c,AIUseHyperPotion
	ld a,5
	call $67CF
	ret nc
	jp $672A

BrockAI:
; if his active monster has a status condition, use a full heal
	ld a,[W_OPPONENTSTATUS]
	and a
	ret z
	jp AIUseFullHeal

MistyAI:
	cp $40
	ret nc
	jp AIUseXDefend

LtSurgeAI:
	cp $40
	ret nc
	jp AIUseXSpeed

ErikaAI:
	cp $80
	ret nc
	ld a,$A
	call $67CF
	ret nc
	jp AIUseSuperPotion

KogaAI:
	cp $40
	ret nc
	jp AIUseXAttack

BlaineAI:
	cp $40
	ret nc
	jp AIUseSuperPotion

SabrinaAI:
	cp $40
	ret nc
	ld a,$A
	call $67CF
	ret nc
	jp AIUseHyperPotion

Sony2AI:
	cp $20
	ret nc
	ld a,5
	call $67CF
	ret nc
	jp AIUsePotion

Sony3AI:
	cp $20
	ret nc
	ld a,5
	call $67CF
	ret nc
	jp AIUseFullRestore

LoreleiAI:
	cp $80
	ret nc
	ld a,5
	call $67CF
	ret nc
	jp AIUseSuperPotion

BrunoAI:
	cp $40
	ret nc
	jp AIUseXDefend

AgathaAI:
	cp $14
	jp c,$672A
	cp $80
	ret nc
	ld a,4
	call $67CF
	ret nc
	jp AIUseSuperPotion

LanceAI:
	cp $80
	ret nc
	ld a,5
	call $67CF
	ret nc
	jp AIUseHyperPotion

GenericAI:
	and a ; clear carry
	ret

; end of individual trainer AI routines

DecrementAICount: ; 6695
	ld hl,W_AICOUNT
	dec [hl]
	scf
	ret

Function669B: ; 669B
; XXX what does this do
	ld a,$8E
	jp $3740

AIUseFullRestore:
	call AICureStatus
	ld a,FULL_RESTORE
	ld [$CF05],a
	ld de,$CEEB
	ld hl,$CFE7
	ld a,[hld]
	ld [de],a
	inc de
	ld a,[hl]
	ld [de],a
	inc de
	ld hl,$CFF5
	ld a,[hld]
	ld [de],a
	inc de
	ld [$CEE9],a
	ld [$CFE7],a
	ld a,[hl]
	ld [de],a
	ld [$CEEA],a
	ld [W_OPPONENTHP],a
	jr Function6718

AIUsePotion:
; enemy trainer heals his monster with a potion
	ld a,POTION
	ld b,20
	jr AIRecoverHP

AIUseSuperPotion:
; enemy trainer heals his monster with a super potion
	ld a,SUPER_POTION
	ld b,50
	jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a,HYPER_POTION
	ld b,200
	; fallthrough

AIRecoverHP: ; 66DA
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [$CF05],a
	ld hl,$CFE7
	ld a,[hl]
	ld [$CEEB],a
	add b
	ld [hld],a
	ld [$CEED],a
	ld a,[hl]
	ld [$CEEC],a
	ld [$CEEE],a
	jr nc,.next\@
	inc a
	ld [hl],a
	ld [$CEEE],a
.next\@
	inc hl
	ld a,[hld]
	ld b,a
	ld de,$CFF5
	ld a,[de]
	dec de
	ld [$CEE9],a
	sub b
	ld a,[hli]
	ld b,a
	ld a,[de]
	ld [$CEEA],a
	sbc b
	jr nc,Function6718
	inc de
	ld a,[de]
	dec de
	ld [hld],a
	ld [$CEED],a
	ld a,[de]
	ld [hl],a
	ld [$CEEE],a
	; fallthrough

Function6718: ; 6718
	call AIPrintItemUse_
	ld hl,$C3CA
	xor a
	ld [$CF94],a
	ld a,$48
	call Predef
	jp DecrementAICount

Function672A: ; 672A
	ld a,[W_ENEMYMONCOUNT]
	ld c,a
	ld hl,W_ENEMYMON1HP

	ld d,0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop\@
	ld a,[hli]
	ld b,a
	ld a,[hld]
	or b
	jr z,.Fainted\@ ; has monster fainted?
	inc d
.Fainted\@
	push bc
	ld bc,$2C
	add hl,bc
	pop bc
	dec c
	jr nz,.loop\@

	ld a,d ; how many available monsters are there?
	cp 2 ; don't bother if only 1 or 2
	jp nc,Function674B ; XXX check, does this jump when a = 2?
	and a
	ret

Function674B: ; 674B

; prepare to withdraw the active monster: copy hp, number, and status to roster

	ld a,[W_OPPONENTNUMBER]
	ld hl,W_ENEMYMON1HP
	ld bc,$2C
	call AddNTimes
	ld d,h
	ld e,l
	ld hl,W_OPPONENTHP
	ld bc,4
	call CopyData

	ld hl,AIBattleWithdrawText
	call PrintText

	ld a,1
	ld [$D11D],a
	ld hl,EnemySendOut
	ld b,BANK(EnemySendOut)
	call Bankswitch
	xor a
	ld [$D11D],a

	ld a,[W_ISLINKBATTLE]
	cp 4
	ret z
	scf
	ret

AIBattleWithdrawText:
	TX_FAR _AIBattleWithdrawText
	db "@"

AIUseFullHeal:
	call $669B
	call AICureStatus
	ld a,FULL_HEAL
	jp AIPrintItemUse

AICureStatus:
; cures the status of enemy's active pokemon
	ld a,[W_OPPONENTNUMBER]
	ld hl,$D8A8
	ld bc,$2C
	call AddNTimes
	xor a
	ld [hl],a ; clear status in enemy team roster
	ld [W_OPPONENTSTATUS],a ; clear status of active enemy
	ld hl,$D069
	res 0,[hl]
	ret

AIUseXAccuracy: ; unused
	call $669B
	ld hl,$D068
	set 0,[hl]
	ld a,X_ACCURACY
	jp AIPrintItemUse

AIUseGuardSpec:
	call $669B
	ld hl,$D068
	set 1,[hl]
	ld a,GUARD_SPEC_
	jp AIPrintItemUse

AIUseDireHit: ; unused
	call $669B
	ld hl,$D068
	set 2,[hl]
	ld a,DIRE_HIT
	jp AIPrintItemUse

Function67CF: ; 67CF
	ld [$FF99],a
	ld hl,$CFF4
	ld a,[hli]
	ld [$FF95],a
	ld a,[hl]
	ld [$FF96],a
	ld b,2
	call $38B9
	ld a,[$FF98]
	ld c,a
	ld a,[$FF97]
	ld b,a
	ld hl,$CFE7
	ld a,[hld]
	ld e,a
	ld a,[hl]
	ld d,a
	ld a,d
	sub b
	ret nz
	ld a,e
	sub c
	ret

AIUseXAttack:
	ld b,$A
	ld a,X_ATTACK
	jr AIIncreaseStat

AIUseXDefend:
	ld b,$B
	ld a,X_DEFEND
	jr AIIncreaseStat

AIUseXSpeed:
	ld b,$C
	ld a,X_SPEED
	jr AIIncreaseStat

AIUseXSpecial:
	ld b,$D
	ld a,X_SPECIAL
	; fallthrough

AIIncreaseStat:
	ld [$CF05],a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl,$CFCD
	ld a,[hld]
	push af
	ld a,[hl]
	push af
	push hl
	ld a,$AF
	ld [hli],a
	ld [hl],b
	ld hl,$7428
	ld b,$F
	call Bankswitch
	pop hl
	pop af
	ld [hli],a
	pop af
	ld [hl],a
	jp DecrementAICount

AIPrintItemUse:
	ld [$CF05],a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [$CF05] on z!"
	ld a,[$CF05]
	ld [$D11E],a
	call GetItemName
	ld hl,AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	TX_FAR _AIBattleUseItemText
	db "@"

INCBIN "baserom.gbc",$3A849,$3B05C - $3A849

EvosAttacksPointerTable: ; 705C
	dw Mon112_EvosAttacks
	dw Mon115_EvosAttacks
	dw Mon032_EvosAttacks
	dw Mon035_EvosAttacks
	dw Mon021_EvosAttacks
	dw Mon100_EvosAttacks
	dw Mon034_EvosAttacks
	dw Mon080_EvosAttacks
	dw Mon002_EvosAttacks
	dw Mon103_EvosAttacks
	dw Mon108_EvosAttacks
	dw Mon102_EvosAttacks
	dw Mon088_EvosAttacks
	dw Mon094_EvosAttacks
	dw Mon029_EvosAttacks
	dw Mon031_EvosAttacks
	dw Mon104_EvosAttacks
	dw Mon111_EvosAttacks
	dw Mon131_EvosAttacks
	dw Mon059_EvosAttacks
	dw Mon151_EvosAttacks
	dw Mon130_EvosAttacks
	dw Mon090_EvosAttacks
	dw Mon072_EvosAttacks
	dw Mon092_EvosAttacks
	dw Mon123_EvosAttacks
	dw Mon120_EvosAttacks
	dw Mon009_EvosAttacks
	dw Mon127_EvosAttacks
	dw Mon114_EvosAttacks
	dw Mon152_EvosAttacks	;MissingNo
	dw Mon153_EvosAttacks	;MissingNo
	dw Mon058_EvosAttacks
	dw Mon095_EvosAttacks
	dw Mon022_EvosAttacks
	dw Mon016_EvosAttacks
	dw Mon079_EvosAttacks
	dw Mon064_EvosAttacks
	dw Mon075_EvosAttacks
	dw Mon113_EvosAttacks
	dw Mon067_EvosAttacks
	dw Mon122_EvosAttacks
	dw Mon106_EvosAttacks
	dw Mon107_EvosAttacks
	dw Mon024_EvosAttacks
	dw Mon047_EvosAttacks
	dw Mon054_EvosAttacks
	dw Mon096_EvosAttacks
	dw Mon076_EvosAttacks
	dw Mon154_EvosAttacks	;MissingNo
	dw Mon126_EvosAttacks
	dw Mon155_EvosAttacks	;MissingNo
	dw Mon125_EvosAttacks
	dw Mon082_EvosAttacks
	dw Mon109_EvosAttacks
	dw Mon156_EvosAttacks	;MissingNo
	dw Mon056_EvosAttacks
	dw Mon086_EvosAttacks
	dw Mon050_EvosAttacks
	dw Mon128_EvosAttacks
	dw Mon157_EvosAttacks	;MissingNo
	dw Mon158_EvosAttacks	;MissingNo
	dw Mon159_EvosAttacks	;MissingNo
	dw Mon083_EvosAttacks
	dw Mon048_EvosAttacks
	dw Mon149_EvosAttacks
	dw Mon160_EvosAttacks	;MissingNo
	dw Mon161_EvosAttacks	;MissingNo
	dw Mon162_EvosAttacks	;MissingNo
	dw Mon084_EvosAttacks
	dw Mon060_EvosAttacks
	dw Mon124_EvosAttacks
	dw Mon146_EvosAttacks
	dw Mon144_EvosAttacks
	dw Mon145_EvosAttacks
	dw Mon132_EvosAttacks
	dw Mon052_EvosAttacks
	dw Mon098_EvosAttacks
	dw Mon163_EvosAttacks	;MissingNo
	dw Mon164_EvosAttacks	;MissingNo
	dw Mon165_EvosAttacks	;MissingNo
	dw Mon037_EvosAttacks
	dw Mon038_EvosAttacks
	dw Mon025_EvosAttacks
	dw Mon026_EvosAttacks
	dw Mon166_EvosAttacks	;MissingNo
	dw Mon167_EvosAttacks	;MissingNo
	dw Mon147_EvosAttacks
	dw Mon148_EvosAttacks
	dw Mon140_EvosAttacks
	dw Mon141_EvosAttacks
	dw Mon116_EvosAttacks
	dw Mon117_EvosAttacks
	dw Mon168_EvosAttacks	;MissingNo
	dw Mon169_EvosAttacks	;MissingNo
	dw Mon027_EvosAttacks
	dw Mon028_EvosAttacks
	dw Mon138_EvosAttacks
	dw Mon139_EvosAttacks
	dw Mon039_EvosAttacks
	dw Mon040_EvosAttacks
	dw Mon133_EvosAttacks
	dw Mon136_EvosAttacks
	dw Mon135_EvosAttacks
	dw Mon134_EvosAttacks
	dw Mon066_EvosAttacks
	dw Mon041_EvosAttacks
	dw Mon023_EvosAttacks
	dw Mon046_EvosAttacks
	dw Mon061_EvosAttacks
	dw Mon062_EvosAttacks
	dw Mon013_EvosAttacks
	dw Mon014_EvosAttacks
	dw Mon015_EvosAttacks
	dw Mon170_EvosAttacks	;MissingNo
	dw Mon085_EvosAttacks
	dw Mon057_EvosAttacks
	dw Mon051_EvosAttacks
	dw Mon049_EvosAttacks
	dw Mon087_EvosAttacks
	dw Mon171_EvosAttacks	;MissingNo
	dw Mon172_EvosAttacks	;MissingNo
	dw Mon010_EvosAttacks
	dw Mon011_EvosAttacks
	dw Mon012_EvosAttacks
	dw Mon068_EvosAttacks
	dw Mon173_EvosAttacks	;MissingNo
	dw Mon055_EvosAttacks
	dw Mon097_EvosAttacks
	dw Mon042_EvosAttacks
	dw Mon150_EvosAttacks
	dw Mon143_EvosAttacks
	dw Mon129_EvosAttacks
	dw Mon174_EvosAttacks	;MissingNo
	dw Mon175_EvosAttacks	;MissingNo
	dw Mon089_EvosAttacks
	dw Mon176_EvosAttacks	;MissingNo
	dw Mon099_EvosAttacks
	dw Mon091_EvosAttacks
	dw Mon177_EvosAttacks	;MissingNo
	dw Mon101_EvosAttacks
	dw Mon036_EvosAttacks
	dw Mon110_EvosAttacks
	dw Mon053_EvosAttacks
	dw Mon105_EvosAttacks
	dw Mon178_EvosAttacks	;MissingNo
	dw Mon093_EvosAttacks
	dw Mon063_EvosAttacks
	dw Mon065_EvosAttacks
	dw Mon017_EvosAttacks
	dw Mon018_EvosAttacks
	dw Mon121_EvosAttacks
	dw Mon001_EvosAttacks
	dw Mon003_EvosAttacks
	dw Mon073_EvosAttacks
	dw Mon179_EvosAttacks	;MissingNo
	dw Mon118_EvosAttacks
	dw Mon119_EvosAttacks
	dw Mon180_EvosAttacks	;MissingNo
	dw Mon181_EvosAttacks	;MissingNo
	dw Mon182_EvosAttacks	;MissingNo
	dw Mon183_EvosAttacks	;MissingNo
	dw Mon077_EvosAttacks
	dw Mon078_EvosAttacks
	dw Mon019_EvosAttacks
	dw Mon020_EvosAttacks
	dw Mon033_EvosAttacks
	dw Mon030_EvosAttacks
	dw Mon074_EvosAttacks
	dw Mon137_EvosAttacks
	dw Mon142_EvosAttacks
	dw Mon184_EvosAttacks	;MissingNo
	dw Mon081_EvosAttacks
	dw Mon185_EvosAttacks	;MissingNo
	dw Mon186_EvosAttacks	;MissingNo
	dw Mon004_EvosAttacks
	dw Mon007_EvosAttacks
	dw Mon005_EvosAttacks
	dw Mon008_EvosAttacks
	dw Mon006_EvosAttacks
	dw Mon187_EvosAttacks	;MissingNo
	dw Mon188_EvosAttacks	;MissingNo
	dw Mon189_EvosAttacks	;MissingNo
	dw Mon190_EvosAttacks	;MissingNo
	dw Mon043_EvosAttacks
	dw Mon044_EvosAttacks
	dw Mon045_EvosAttacks
	dw Mon069_EvosAttacks
	dw Mon070_EvosAttacks
	dw Mon071_EvosAttacks

Mon112_EvosAttacks:
;RHYDON
;Evolutions
	db 0
;Learnset
	db 30,STOMP
	db 35,TAIL_WHIP
	db 40,FURY_ATTACK
	db 48,HORN_DRILL
	db 55,LEER
	db 64,TAKE_DOWN
	db 0
Mon115_EvosAttacks:
;KANGASKHAN
;Evolutions
	db 0
;Learnset
	db 26,BITE
	db 31,TAIL_WHIP
	db 36,MEGA_PUNCH
	db 41,LEER
	db 46,DIZZY_PUNCH
	db 0
Mon032_EvosAttacks:
;NIDORAN_M
;Evolutions
	db EV_LEVEL,16,NIDORINO
	db 0
;Learnset
	db 8,HORN_ATTACK
	db 14,POISON_STING
	db 21,FOCUS_ENERGY
	db 29,FURY_ATTACK
	db 36,HORN_DRILL
	db 43,DOUBLE_KICK
	db 0
Mon035_EvosAttacks:
;CLEFAIRY
;Evolutions
	db EV_ITEM,MOON_STONE,1,CLEFABLE
	db 0
;Learnset
	db 13,SING
	db 18,DOUBLESLAP
	db 24,MINIMIZE
	db 31,METRONOME
	db 39,DEFENSE_CURL
	db 48,LIGHT_SCREEN
	db 0
Mon021_EvosAttacks:
;SPEAROW
;Evolutions
	db EV_LEVEL,20,FEAROW
	db 0
;Learnset
	db 9,LEER
	db 15,FURY_ATTACK
	db 22,MIRROR_MOVE
	db 29,DRILL_PECK
	db 36,AGILITY
	db 0
Mon100_EvosAttacks:
;VOLTORB
;Evolutions
	db EV_LEVEL,30,ELECTRODE
	db 0
;Learnset
	db 17,SONICBOOM
	db 22,SELFDESTRUCT
	db 29,LIGHT_SCREEN
	db 36,SWIFT
	db 43,EXPLOSION
	db 0
Mon034_EvosAttacks:
;NIDOKING
;Evolutions
	db 0
;Learnset
	db 8,HORN_ATTACK
	db 14,POISON_STING
	db 23,THRASH
	db 0
Mon080_EvosAttacks:
;SLOWBRO
;Evolutions
	db 0
;Learnset
	db 18,DISABLE
	db 22,HEADBUTT
	db 27,GROWL
	db 33,WATER_GUN
	db 37,WITHDRAW
	db 44,AMNESIA
	db 55,PSYCHIC_M
	db 0
Mon002_EvosAttacks:
;IVYSAUR
;Evolutions
	db EV_LEVEL,32,VENUSAUR
	db 0
;Learnset
	db 7,LEECH_SEED
	db 13,VINE_WHIP
	db 22,POISONPOWDER
	db 30,RAZOR_LEAF
	db 38,GROWTH
	db 46,SLEEP_POWDER
	db 54,SOLARBEAM
	db 0
Mon103_EvosAttacks:
;EXEGGUTOR
;Evolutions
	db 0
;Learnset
	db 28,STOMP
	db 0
Mon108_EvosAttacks:
;LICKITUNG
;Evolutions
	db 0
;Learnset
	db 7,STOMP
	db 15,DISABLE
	db 23,DEFENSE_CURL
	db 31,SLAM
	db 39,SCREECH
	db 0
Mon102_EvosAttacks:
;EXEGGCUTE
;Evolutions
	db EV_ITEM,LEAF_STONE ,1,EXEGGUTOR
	db 0
;Learnset
	db 25,REFLECT
	db 28,LEECH_SEED
	db 32,STUN_SPORE
	db 37,POISONPOWDER
	db 42,SOLARBEAM
	db 48,SLEEP_POWDER
	db 0
Mon088_EvosAttacks:
;GRIMER
;Evolutions
	db EV_LEVEL,38,MUK
	db 0
;Learnset
	db 30,POISON_GAS
	db 33,MINIMIZE
	db 37,SLUDGE
	db 42,HARDEN
	db 48,SCREECH
	db 55,ACID_ARMOR
	db 0
Mon094_EvosAttacks:
;GENGAR
;Evolutions
	db 0
;Learnset
	db 29,HYPNOSIS
	db 38,DREAM_EATER
	db 0
Mon029_EvosAttacks:
;NIDORAN_F
;Evolutions
	db EV_LEVEL,16,NIDORINA
	db 0
;Learnset
	db 8,SCRATCH
	db 14,POISON_STING
	db 21,TAIL_WHIP
	db 29,BITE
	db 36,FURY_SWIPES
	db 43,DOUBLE_KICK
	db 0
Mon031_EvosAttacks:
;NIDOQUEEN
;Evolutions
	db 0
;Learnset
	db 8,SCRATCH
	db 14,POISON_STING
	db 23,BODY_SLAM
	db 0
Mon104_EvosAttacks:
;CUBONE
;Evolutions
	db EV_LEVEL,28,MAROWAK
	db 0
;Learnset
	db 25,LEER
	db 31,FOCUS_ENERGY
	db 38,THRASH
	db 43,BONEMERANG
	db 46,RAGE
	db 0
Mon111_EvosAttacks:
;RHYHORN
;Evolutions
	db EV_LEVEL,42,RHYDON
	db 0
;Learnset
	db 30,STOMP
	db 35,TAIL_WHIP
	db 40,FURY_ATTACK
	db 45,HORN_DRILL
	db 50,LEER
	db 55,TAKE_DOWN
	db 0
Mon131_EvosAttacks:
;LAPRAS
;Evolutions
	db 0
;Learnset
	db 16,SING
	db 20,MIST
	db 25,BODY_SLAM
	db 31,CONFUSE_RAY
	db 38,ICE_BEAM
	db 46,HYDRO_PUMP
	db 0
Mon059_EvosAttacks:
;ARCANINE
;Evolutions
	db 0
;Learnset
	db 0
Mon151_EvosAttacks:
;MEW
;Evolutions
	db 0
;Learnset
	db 10,TRANSFORM
	db 20,MEGA_PUNCH
	db 30,METRONOME
	db 40,PSYCHIC_M
	db 0
Mon130_EvosAttacks:
;GYARADOS
;Evolutions
	db 0
;Learnset
	db 20,BITE
	db 25,DRAGON_RAGE
	db 32,LEER
	db 41,HYDRO_PUMP
	db 52,HYPER_BEAM
	db 0
Mon090_EvosAttacks:
;SHELLDER
;Evolutions
	db EV_ITEM,WATER_STONE ,1,CLOYSTER
	db 0
;Learnset
	db 18,SUPERSONIC
	db 23,CLAMP
	db 30,AURORA_BEAM
	db 39,LEER
	db 50,ICE_BEAM
	db 0
Mon072_EvosAttacks:
;TENTACOOL
;Evolutions
	db EV_LEVEL,30,TENTACRUEL
	db 0
;Learnset
	db 7,SUPERSONIC
	db 13,WRAP
	db 18,POISON_STING
	db 22,WATER_GUN
	db 27,CONSTRICT
	db 33,BARRIER
	db 40,SCREECH
	db 48,HYDRO_PUMP
	db 0
Mon092_EvosAttacks:
;GASTLY
;Evolutions
	db EV_LEVEL,25,HAUNTER
	db 0
;Learnset
	db 27,HYPNOSIS
	db 35,DREAM_EATER
	db 0
Mon123_EvosAttacks:
;SCYTHER
;Evolutions
	db 0
;Learnset
	db 17,LEER
	db 20,FOCUS_ENERGY
	db 24,DOUBLE_TEAM
	db 29,SLASH
	db 35,SWORDS_DANCE
	db 42,AGILITY
	db 0
Mon120_EvosAttacks:
;STARYU
;Evolutions
	db EV_ITEM,WATER_STONE ,1,STARMIE
	db 0
;Learnset
	db 17,WATER_GUN
	db 22,HARDEN
	db 27,RECOVER
	db 32,SWIFT
	db 37,MINIMIZE
	db 42,LIGHT_SCREEN
	db 47,HYDRO_PUMP
	db 0
Mon009_EvosAttacks:
;BLASTOISE
;Evolutions
	db 0
;Learnset
	db 8,BUBBLE
	db 15,WATER_GUN
	db 24,BITE
	db 31,WITHDRAW
	db 42,SKULL_BASH
	db 52,HYDRO_PUMP
	db 0
Mon127_EvosAttacks:
;PINSIR
;Evolutions
	db 0
;Learnset
	db 25,SEISMIC_TOSS
	db 30,GUILLOTINE
	db 36,FOCUS_ENERGY
	db 43,HARDEN
	db 49,SLASH
	db 54,SWORDS_DANCE
	db 0
Mon114_EvosAttacks:
;TANGELA
;Evolutions
	db 0
;Learnset
	db 29,ABSORB
	db 32,POISONPOWDER
	db 36,STUN_SPORE
	db 39,SLEEP_POWDER
	db 45,SLAM
	db 49,GROWTH
	db 0

Mon152_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon153_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon058_EvosAttacks:
;GROWLITHE
;Evolutions
	db EV_ITEM,FIRE_STONE,1,ARCANINE
	db 0
;Learnset
	db 18,EMBER
	db 23,LEER
	db 30,TAKE_DOWN
	db 39,AGILITY
	db 50,FLAMETHROWER
	db 0
Mon095_EvosAttacks:
;ONIX
;Evolutions
	db 0
;Learnset
	db 15,BIND
	db 19,ROCK_THROW
	db 25,RAGE
	db 33,SLAM
	db 43,HARDEN
	db 0
Mon022_EvosAttacks:
;FEAROW
;Evolutions
	db 0
;Learnset
	db 9,LEER
	db 15,FURY_ATTACK
	db 25,MIRROR_MOVE
	db 34,DRILL_PECK
	db 43,AGILITY
	db 0
Mon016_EvosAttacks:
;PIDGEY
;Evolutions
	db EV_LEVEL,18,PIDGEOTTO
	db 0
;Learnset
	db 5,SAND_ATTACK
	db 12,QUICK_ATTACK
	db 19,WHIRLWIND
	db 28,WING_ATTACK
	db 36,AGILITY
	db 44,MIRROR_MOVE
	db 0
Mon079_EvosAttacks:
;SLOWPOKE
;Evolutions
	db EV_LEVEL,37,SLOWBRO
	db 0
;Learnset
	db 18,DISABLE
	db 22,HEADBUTT
	db 27,GROWL
	db 33,WATER_GUN
	db 40,AMNESIA
	db 48,PSYCHIC_M
	db 0
Mon064_EvosAttacks:
;KADABRA
;Evolutions
	db EV_TRADE,1,ALAKAZAM
	db 0
;Learnset
	db 16,CONFUSION
	db 20,DISABLE
	db 27,PSYBEAM
	db 31,RECOVER
	db 38,PSYCHIC_M
	db 42,REFLECT
	db 0
Mon075_EvosAttacks:
;GRAVELER
;Evolutions
	db EV_TRADE,1,GOLEM
	db 0
;Learnset
	db 11,DEFENSE_CURL
	db 16,ROCK_THROW
	db 21,SELFDESTRUCT
	db 29,HARDEN
	db 36,EARTHQUAKE
	db 43,EXPLOSION
	db 0
Mon113_EvosAttacks:
;CHANSEY
;Evolutions
	db 0
;Learnset
	db 24,SING
	db 30,GROWL
	db 38,MINIMIZE
	db 44,DEFENSE_CURL
	db 48,LIGHT_SCREEN
	db 54,DOUBLE_EDGE
	db 0
Mon067_EvosAttacks:
;MACHOKE
;Evolutions
	db EV_TRADE,1,MACHAMP
	db 0
;Learnset
	db 20,LOW_KICK
	db 25,LEER
	db 36,FOCUS_ENERGY
	db 44,SEISMIC_TOSS
	db 52,SUBMISSION
	db 0
Mon122_EvosAttacks:
;MR_MIME
;Evolutions
	db 0
;Learnset
	db 15,CONFUSION
	db 23,LIGHT_SCREEN
	db 31,DOUBLESLAP
	db 39,MEDITATE
	db 47,SUBSTITUTE
	db 0
Mon106_EvosAttacks:
;HITMONLEE
;Evolutions
	db 0
;Learnset
	db 33,ROLLING_KICK
	db 38,JUMP_KICK
	db 43,FOCUS_ENERGY
	db 48,HI_JUMP_KICK
	db 53,MEGA_KICK
	db 0
Mon107_EvosAttacks:
;HITMONCHAN
;Evolutions
	db 0
;Learnset
	db 33,FIRE_PUNCH
	db 38,ICE_PUNCH
	db 43,THUNDERPUNCH
	db 48,MEGA_PUNCH
	db 53,COUNTER
	db 0
Mon024_EvosAttacks:
;ARBOK
;Evolutions
	db 0
;Learnset
	db 10,POISON_STING
	db 17,BITE
	db 27,GLARE
	db 36,SCREECH
	db 47,ACID
	db 0
Mon047_EvosAttacks:
;PARASECT
;Evolutions
	db 0
;Learnset
	db 13,STUN_SPORE
	db 20,LEECH_LIFE
	db 30,SPORE
	db 39,SLASH
	db 48,GROWTH
	db 0
Mon054_EvosAttacks:
;PSYDUCK
;Evolutions
	db EV_LEVEL,33,GOLDUCK
	db 0
;Learnset
	db 28,TAIL_WHIP
	db 31,DISABLE
	db 36,CONFUSION
	db 43,FURY_SWIPES
	db 52,HYDRO_PUMP
	db 0
Mon096_EvosAttacks:
;DROWZEE
;Evolutions
	db EV_LEVEL,26,HYPNO
	db 0
;Learnset
	db 12,DISABLE
	db 17,CONFUSION
	db 24,HEADBUTT
	db 29,POISON_GAS
	db 32,PSYCHIC_M
	db 37,MEDITATE
	db 0
Mon076_EvosAttacks:
;GOLEM
;Evolutions
	db 0
;Learnset
	db 11,DEFENSE_CURL
	db 16,ROCK_THROW
	db 21,SELFDESTRUCT
	db 29,HARDEN
	db 36,EARTHQUAKE
	db 43,EXPLOSION
	db 0

Mon154_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon126_EvosAttacks:
;MAGMAR
;Evolutions
	db 0
;Learnset
	db 36,LEER
	db 39,CONFUSE_RAY
	db 43,FIRE_PUNCH
	db 48,SMOKESCREEN
	db 52,SMOG
	db 55,FLAMETHROWER
	db 0

Mon155_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon125_EvosAttacks:
;ELECTABUZZ
;Evolutions
	db 0
;Learnset
	db 34,THUNDERSHOCK
	db 37,SCREECH
	db 42,THUNDERPUNCH
	db 49,LIGHT_SCREEN
	db 54,THUNDER
	db 0
Mon082_EvosAttacks:
;MAGNETON
;Evolutions
	db 0
;Learnset
	db 21,SONICBOOM
	db 25,THUNDERSHOCK
	db 29,SUPERSONIC
	db 38,THUNDER_WAVE
	db 46,SWIFT
	db 54,SCREECH
	db 0
Mon109_EvosAttacks:
;KOFFING
;Evolutions
	db EV_LEVEL,35,WEEZING
	db 0
;Learnset
	db 32,SLUDGE
	db 37,SMOKESCREEN
	db 40,SELFDESTRUCT
	db 45,HAZE
	db 48,EXPLOSION
	db 0

Mon156_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon056_EvosAttacks:
;MANKEY
;Evolutions
	db EV_LEVEL,28,PRIMEAPE
	db 0
;Learnset
	db 15,KARATE_CHOP
	db 21,FURY_SWIPES
	db 27,FOCUS_ENERGY
	db 33,SEISMIC_TOSS
	db 39,THRASH
	db 0
Mon086_EvosAttacks:
;SEEL
;Evolutions
	db EV_LEVEL,34,DEWGONG
	db 0
;Learnset
	db 30,GROWL
	db 35,AURORA_BEAM
	db 40,REST
	db 45,TAKE_DOWN
	db 50,ICE_BEAM
	db 0
Mon050_EvosAttacks:
;DIGLETT
;Evolutions
	db EV_LEVEL,26,DUGTRIO
	db 0
;Learnset
	db 15,GROWL
	db 19,DIG
	db 24,SAND_ATTACK
	db 31,SLASH
	db 40,EARTHQUAKE
	db 0
Mon128_EvosAttacks:
;TAUROS
;Evolutions
	db 0
;Learnset
	db 21,STOMP
	db 28,TAIL_WHIP
	db 35,LEER
	db 44,RAGE
	db 51,TAKE_DOWN
	db 0

Mon157_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon158_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon159_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon083_EvosAttacks:
;FARFETCH_D
;Evolutions
	db 0
;Learnset
	db 7,LEER
	db 15,FURY_ATTACK
	db 23,SWORDS_DANCE
	db 31,AGILITY
	db 39,SLASH
	db 0
Mon048_EvosAttacks:
;VENONAT
;Evolutions
	db EV_LEVEL,31,VENOMOTH
	db 0
;Learnset
	db 24,POISONPOWDER
	db 27,LEECH_LIFE
	db 30,STUN_SPORE
	db 35,PSYBEAM
	db 38,SLEEP_POWDER
	db 43,PSYCHIC_M
	db 0
Mon149_EvosAttacks:
;DRAGONITE
;Evolutions
	db 0
;Learnset
	db 10,THUNDER_WAVE
	db 20,AGILITY
	db 35,SLAM
	db 45,DRAGON_RAGE
	db 60,HYPER_BEAM
	db 0

Mon160_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon161_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon162_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon084_EvosAttacks:
;DODUO
;Evolutions
	db EV_LEVEL,31,DODRIO
	db 0
;Learnset
	db 20,GROWL
	db 24,FURY_ATTACK
	db 30,DRILL_PECK
	db 36,RAGE
	db 40,TRI_ATTACK
	db 44,AGILITY
	db 0
Mon060_EvosAttacks:
;POLIWAG
;Evolutions
	db EV_LEVEL,25,POLIWHIRL
	db 0
;Learnset
	db 16,HYPNOSIS
	db 19,WATER_GUN
	db 25,DOUBLESLAP
	db 31,BODY_SLAM
	db 38,AMNESIA
	db 45,HYDRO_PUMP
	db 0
Mon124_EvosAttacks:
;JYNX
;Evolutions
	db 0
;Learnset
	db 18,LICK
	db 23,DOUBLESLAP
	db 31,ICE_PUNCH
	db 39,BODY_SLAM
	db 47,THRASH
	db 58,BLIZZARD
	db 0
Mon146_EvosAttacks:
;MOLTRES
;Evolutions
	db 0
;Learnset
	db 51,LEER
	db 55,AGILITY
	db 60,SKY_ATTACK
	db 0
Mon144_EvosAttacks:
;ARTICUNO
;Evolutions
	db 0
;Learnset
	db 51,BLIZZARD
	db 55,AGILITY
	db 60,MIST
	db 0
Mon145_EvosAttacks:
;ZAPDOS
;Evolutions
	db 0
;Learnset
	db 51,THUNDER
	db 55,AGILITY
	db 60,LIGHT_SCREEN
	db 0
Mon132_EvosAttacks:
;DITTO
;Evolutions
	db 0
;Learnset
	db 0
Mon052_EvosAttacks:
;MEOWTH
;Evolutions
	db EV_LEVEL,28,PERSIAN
	db 0
;Learnset
	db 12,BITE
	db 17,PAY_DAY
	db 24,SCREECH
	db 33,FURY_SWIPES
	db 44,SLASH
	db 0
Mon098_EvosAttacks:
;KRABBY
;Evolutions
	db EV_LEVEL,28,KINGLER
	db 0
;Learnset
	db 20,VICEGRIP
	db 25,GUILLOTINE
	db 30,STOMP
	db 35,CRABHAMMER
	db 40,HARDEN
	db 0

Mon163_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon164_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon165_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon037_EvosAttacks:
;VULPIX
;Evolutions
	db EV_ITEM,FIRE_STONE,1,NINETALES
	db 0
;Learnset
	db 16,QUICK_ATTACK
	db 21,ROAR
	db 28,CONFUSE_RAY
	db 35,FLAMETHROWER
	db 42,FIRE_SPIN
	db 0
Mon038_EvosAttacks:
;NINETALES
;Evolutions
	db 0
;Learnset
	db 0
Mon025_EvosAttacks:
;PIKACHU
;Evolutions
	db EV_ITEM,THUNDER_STONE ,1,RAICHU
	db 0
;Learnset
	db 9,THUNDER_WAVE
	db 16,QUICK_ATTACK
	db 26,SWIFT
	db 33,AGILITY
	db 43,THUNDER
	db 0
Mon026_EvosAttacks:
;RAICHU
;Evolutions
	db 0
;Learnset
	db 0

Mon166_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon167_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon147_EvosAttacks:
;DRATINI
;Evolutions
	db EV_LEVEL,30,DRAGONAIR
	db 0
;Learnset
	db 10,THUNDER_WAVE
	db 20,AGILITY
	db 30,SLAM
	db 40,DRAGON_RAGE
	db 50,HYPER_BEAM
	db 0
Mon148_EvosAttacks:
;DRAGONAIR
;Evolutions
	db EV_LEVEL,55,DRAGONITE
	db 0
;Learnset
	db 10,THUNDER_WAVE
	db 20,AGILITY
	db 35,SLAM
	db 45,DRAGON_RAGE
	db 55,HYPER_BEAM
	db 0
Mon140_EvosAttacks:
;KABUTO
;Evolutions
	db EV_LEVEL,40,KABUTOPS
	db 0
;Learnset
	db 34,ABSORB
	db 39,SLASH
	db 44,LEER
	db 49,HYDRO_PUMP
	db 0
Mon141_EvosAttacks:
;KABUTOPS
;Evolutions
	db 0
;Learnset
	db 34,ABSORB
	db 39,SLASH
	db 46,LEER
	db 53,HYDRO_PUMP
	db 0
Mon116_EvosAttacks:
;HORSEA
;Evolutions
	db EV_LEVEL,32,SEADRA
	db 0
;Learnset
	db 19,SMOKESCREEN
	db 24,LEER
	db 30,WATER_GUN
	db 37,AGILITY
	db 45,HYDRO_PUMP
	db 0
Mon117_EvosAttacks:
;SEADRA
;Evolutions
	db 0
;Learnset
	db 19,SMOKESCREEN
	db 24,LEER
	db 30,WATER_GUN
	db 41,AGILITY
	db 52,HYDRO_PUMP
	db 0

Mon168_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon169_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon027_EvosAttacks:
;SANDSHREW
;Evolutions
	db EV_LEVEL,22,SANDSLASH
	db 0
;Learnset
	db 10,SAND_ATTACK
	db 17,SLASH
	db 24,POISON_STING
	db 31,SWIFT
	db 38,FURY_SWIPES
	db 0
Mon028_EvosAttacks:
;SANDSLASH
;Evolutions
	db 0
;Learnset
	db 10,SAND_ATTACK
	db 17,SLASH
	db 27,POISON_STING
	db 36,SWIFT
	db 47,FURY_SWIPES
	db 0
Mon138_EvosAttacks:
;OMANYTE
;Evolutions
	db EV_LEVEL,40,OMASTAR
	db 0
;Learnset
	db 34,HORN_ATTACK
	db 39,LEER
	db 46,SPIKE_CANNON
	db 53,HYDRO_PUMP
	db 0
Mon139_EvosAttacks:
;OMASTAR
;Evolutions
	db 0
;Learnset
	db 34,HORN_ATTACK
	db 39,LEER
	db 44,SPIKE_CANNON
	db 49,HYDRO_PUMP
	db 0
Mon039_EvosAttacks:
;JIGGLYPUFF
;Evolutions
	db EV_ITEM,MOON_STONE,1,WIGGLYTUFF
	db 0
;Learnset
	db 9,POUND
	db 14,DISABLE
	db 19,DEFENSE_CURL
	db 24,DOUBLESLAP
	db 29,REST
	db 34,BODY_SLAM
	db 39,DOUBLE_EDGE
	db 0
Mon040_EvosAttacks:
;WIGGLYTUFF
;Evolutions
	db 0
;Learnset
	db 0
Mon133_EvosAttacks:
;EEVEE
;Evolutions
	db EV_ITEM,FIRE_STONE,1,FLAREON
	db EV_ITEM,THUNDER_STONE ,1,JOLTEON
	db EV_ITEM,WATER_STONE ,1,VAPOREON
	db 0
;Learnset
	db 27,QUICK_ATTACK
	db 31,TAIL_WHIP
	db 37,BITE
	db 45,TAKE_DOWN
	db 0
Mon136_EvosAttacks:
;FLAREON
;Evolutions
	db 0
;Learnset
	db 27,QUICK_ATTACK
	db 31,EMBER
	db 37,TAIL_WHIP
	db 40,BITE
	db 42,LEER
	db 44,FIRE_SPIN
	db 48,RAGE
	db 54,FLAMETHROWER
	db 0
Mon135_EvosAttacks:
;JOLTEON
;Evolutions
	db 0
;Learnset
	db 27,QUICK_ATTACK
	db 31,THUNDERSHOCK
	db 37,TAIL_WHIP
	db 40,THUNDER_WAVE
	db 42,DOUBLE_KICK
	db 44,AGILITY
	db 48,PIN_MISSILE
	db 54,THUNDER
	db 0
Mon134_EvosAttacks:
;VAPOREON
;Evolutions
	db 0
;Learnset
	db 27,QUICK_ATTACK
	db 31,WATER_GUN
	db 37,TAIL_WHIP
	db 40,BITE
	db 42,ACID_ARMOR
	db 44,HAZE
	db 48,MIST
	db 54,HYDRO_PUMP
	db 0
Mon066_EvosAttacks:
;MACHOP
;Evolutions
	db EV_LEVEL,28,MACHOKE
	db 0
;Learnset
	db 20,LOW_KICK
	db 25,LEER
	db 32,FOCUS_ENERGY
	db 39,SEISMIC_TOSS
	db 46,SUBMISSION
	db 0
Mon041_EvosAttacks:
;ZUBAT
;Evolutions
	db EV_LEVEL,22,GOLBAT
	db 0
;Learnset
	db 10,SUPERSONIC
	db 15,BITE
	db 21,CONFUSE_RAY
	db 28,WING_ATTACK
	db 36,HAZE
	db 0
Mon023_EvosAttacks:
;EKANS
;Evolutions
	db EV_LEVEL,22,ARBOK
	db 0
;Learnset
	db 10,POISON_STING
	db 17,BITE
	db 24,GLARE
	db 31,SCREECH
	db 38,ACID
	db 0
Mon046_EvosAttacks:
;PARAS
;Evolutions
	db EV_LEVEL,24,PARASECT
	db 0
;Learnset
	db 13,STUN_SPORE
	db 20,LEECH_LIFE
	db 27,SPORE
	db 34,SLASH
	db 41,GROWTH
	db 0
Mon061_EvosAttacks:
;POLIWHIRL
;Evolutions
	db EV_ITEM,WATER_STONE ,1,POLIWRATH
	db 0
;Learnset
	db 16,HYPNOSIS
	db 19,WATER_GUN
	db 26,DOUBLESLAP
	db 33,BODY_SLAM
	db 41,AMNESIA
	db 49,HYDRO_PUMP
	db 0
Mon062_EvosAttacks:
;POLIWRATH
;Evolutions
	db 0
;Learnset
	db 16,HYPNOSIS
	db 19,WATER_GUN
	db 0
Mon013_EvosAttacks:
;WEEDLE
;Evolutions
	db EV_LEVEL,7,KAKUNA
	db 0
;Learnset
	db 0
Mon014_EvosAttacks:
;KAKUNA
;Evolutions
	db EV_LEVEL,10,BEEDRILL
	db 0
;Learnset
	db 0
Mon015_EvosAttacks:
;BEEDRILL
;Evolutions
	db 0
;Learnset
	db 12,FURY_ATTACK
	db 16,FOCUS_ENERGY
	db 20,TWINEEDLE
	db 25,RAGE
	db 30,PIN_MISSILE
	db 35,AGILITY
	db 0

Mon170_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon085_EvosAttacks:
;DODRIO
;Evolutions
	db 0
;Learnset
	db 20,GROWL
	db 24,FURY_ATTACK
	db 30,DRILL_PECK
	db 39,RAGE
	db 45,TRI_ATTACK
	db 51,AGILITY
	db 0
Mon057_EvosAttacks:
;PRIMEAPE
;Evolutions
	db 0
;Learnset
	db 15,KARATE_CHOP
	db 21,FURY_SWIPES
	db 27,FOCUS_ENERGY
	db 37,SEISMIC_TOSS
	db 46,THRASH
	db 0
Mon051_EvosAttacks:
;DUGTRIO
;Evolutions
	db 0
;Learnset
	db 15,GROWL
	db 19,DIG
	db 24,SAND_ATTACK
	db 35,SLASH
	db 47,EARTHQUAKE
	db 0
Mon049_EvosAttacks:
;VENOMOTH
;Evolutions
	db 0
;Learnset
	db 24,POISONPOWDER
	db 27,LEECH_LIFE
	db 30,STUN_SPORE
	db 38,PSYBEAM
	db 43,SLEEP_POWDER
	db 50,PSYCHIC_M
	db 0
Mon087_EvosAttacks:
;DEWGONG
;Evolutions
	db 0
;Learnset
	db 30,GROWL
	db 35,AURORA_BEAM
	db 44,REST
	db 50,TAKE_DOWN
	db 56,ICE_BEAM
	db 0

Mon171_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon172_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon010_EvosAttacks:
;CATERPIE
;Evolutions
	db EV_LEVEL,7,METAPOD
	db 0
;Learnset
	db 0
Mon011_EvosAttacks:
;METAPOD
;Evolutions
	db EV_LEVEL,10,BUTTERFREE
	db 0
;Learnset
	db 0
Mon012_EvosAttacks:
;BUTTERFREE
;Evolutions
	db 0
;Learnset
	db 12,CONFUSION
	db 15,POISONPOWDER
	db 16,STUN_SPORE
	db 17,SLEEP_POWDER
	db 21,SUPERSONIC
	db 26,WHIRLWIND
	db 32,PSYBEAM
	db 0
Mon068_EvosAttacks:
;MACHAMP
;Evolutions
	db 0
;Learnset
	db 20,LOW_KICK
	db 25,LEER
	db 36,FOCUS_ENERGY
	db 44,SEISMIC_TOSS
	db 52,SUBMISSION
	db 0

Mon173_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon055_EvosAttacks:
;GOLDUCK
;Evolutions
	db 0
;Learnset
	db 28,TAIL_WHIP
	db 31,DISABLE
	db 39,CONFUSION
	db 48,FURY_SWIPES
	db 59,HYDRO_PUMP
	db 0
Mon097_EvosAttacks:
;HYPNO
;Evolutions
	db 0
;Learnset
	db 12,DISABLE
	db 17,CONFUSION
	db 24,HEADBUTT
	db 33,POISON_GAS
	db 37,PSYCHIC_M
	db 43,MEDITATE
	db 0
Mon042_EvosAttacks:
;GOLBAT
;Evolutions
	db 0
;Learnset
	db 10,SUPERSONIC
	db 15,BITE
	db 21,CONFUSE_RAY
	db 32,WING_ATTACK
	db 43,HAZE
	db 0
Mon150_EvosAttacks:
;MEWTWO
;Evolutions
	db 0
;Learnset
	db 63,BARRIER
	db 66,PSYCHIC_M
	db 70,RECOVER
	db 75,MIST
	db 81,AMNESIA
	db 0
Mon143_EvosAttacks:
;SNORLAX
;Evolutions
	db 0
;Learnset
	db 35,BODY_SLAM
	db 41,HARDEN
	db 48,DOUBLE_EDGE
	db 56,HYPER_BEAM
	db 0
Mon129_EvosAttacks:
;MAGIKARP
;Evolutions
	db EV_LEVEL,20,GYARADOS
	db 0
;Learnset
	db 15,TACKLE
	db 0

Mon174_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon175_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon089_EvosAttacks:
;MUK
;Evolutions
	db 0
;Learnset
	db 30,POISON_GAS
	db 33,MINIMIZE
	db 37,SLUDGE
	db 45,HARDEN
	db 53,SCREECH
	db 60,ACID_ARMOR
	db 0

Mon176_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon099_EvosAttacks:
;KINGLER
;Evolutions
	db 0
;Learnset
	db 20,VICEGRIP
	db 25,GUILLOTINE
	db 34,STOMP
	db 42,CRABHAMMER
	db 49,HARDEN
	db 0
Mon091_EvosAttacks:
;CLOYSTER
;Evolutions
	db 0
;Learnset
	db 50,SPIKE_CANNON
	db 0

Mon177_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon101_EvosAttacks:
;ELECTRODE
;Evolutions
	db 0
;Learnset
	db 17,SONICBOOM
	db 22,SELFDESTRUCT
	db 29,LIGHT_SCREEN
	db 40,SWIFT
	db 50,EXPLOSION
	db 0
Mon036_EvosAttacks:
;CLEFABLE
;Evolutions
	db 0
;Learnset
	db 0
Mon110_EvosAttacks:
;WEEZING
;Evolutions
	db 0
;Learnset
	db 32,SLUDGE
	db 39,SMOKESCREEN
	db 43,SELFDESTRUCT
	db 49,HAZE
	db 53,EXPLOSION
	db 0
Mon053_EvosAttacks:
;PERSIAN
;Evolutions
	db 0
;Learnset
	db 12,BITE
	db 17,PAY_DAY
	db 24,SCREECH
	db 37,FURY_SWIPES
	db 51,SLASH
	db 0
Mon105_EvosAttacks:
;MAROWAK
;Evolutions
	db 0
;Learnset
	db 25,LEER
	db 33,FOCUS_ENERGY
	db 41,THRASH
	db 48,BONEMERANG
	db 55,RAGE
	db 0

Mon178_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon093_EvosAttacks:
;HAUNTER
;Evolutions
	db EV_TRADE,1,GENGAR
	db 0
;Learnset
	db 29,HYPNOSIS
	db 38,DREAM_EATER
	db 0
Mon063_EvosAttacks:
;ABRA
;Evolutions
	db EV_LEVEL,16,KADABRA
	db 0
;Learnset
	db 0
Mon065_EvosAttacks:
;ALAKAZAM
;Evolutions
	db 0
;Learnset
	db 16,CONFUSION
	db 20,DISABLE
	db 27,PSYBEAM
	db 31,RECOVER
	db 38,PSYCHIC_M
	db 42,REFLECT
	db 0
Mon017_EvosAttacks:
;PIDGEOTTO
;Evolutions
	db EV_LEVEL,36,PIDGEOT
	db 0
;Learnset
	db 5,SAND_ATTACK
	db 12,QUICK_ATTACK
	db 21,WHIRLWIND
	db 31,WING_ATTACK
	db 40,AGILITY
	db 49,MIRROR_MOVE
	db 0
Mon018_EvosAttacks:
;PIDGEOT
;Evolutions
	db 0
;Learnset
	db 5,SAND_ATTACK
	db 12,QUICK_ATTACK
	db 21,WHIRLWIND
	db 31,WING_ATTACK
	db 44,AGILITY
	db 54,MIRROR_MOVE
	db 0
Mon121_EvosAttacks:
;STARMIE
;Evolutions
	db 0
;Learnset
	db 0
Mon001_EvosAttacks:
;BULBASAUR
;Evolutions
	db EV_LEVEL,16,IVYSAUR
	db 0
;Learnset
	db 7,LEECH_SEED
	db 13,VINE_WHIP
	db 20,POISONPOWDER
	db 27,RAZOR_LEAF
	db 34,GROWTH
	db 41,SLEEP_POWDER
	db 48,SOLARBEAM
	db 0
Mon003_EvosAttacks:
;VENUSAUR
;Evolutions
	db 0
;Learnset
	db 7,LEECH_SEED
	db 13,VINE_WHIP
	db 22,POISONPOWDER
	db 30,RAZOR_LEAF
	db 43,GROWTH
	db 55,SLEEP_POWDER
	db 65,SOLARBEAM
	db 0
Mon073_EvosAttacks:
;TENTACRUEL
;Evolutions
	db 0
;Learnset
	db 7,SUPERSONIC
	db 13,WRAP
	db 18,POISON_STING
	db 22,WATER_GUN
	db 27,CONSTRICT
	db 35,BARRIER
	db 43,SCREECH
	db 50,HYDRO_PUMP
	db 0

Mon179_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon118_EvosAttacks:
;GOLDEEN
;Evolutions
	db EV_LEVEL,33,SEAKING
	db 0
;Learnset
	db 19,SUPERSONIC
	db 24,HORN_ATTACK
	db 30,FURY_ATTACK
	db 37,WATERFALL
	db 45,HORN_DRILL
	db 54,AGILITY
	db 0
Mon119_EvosAttacks:
;SEAKING
;Evolutions
	db 0
;Learnset
	db 19,SUPERSONIC
	db 24,HORN_ATTACK
	db 30,FURY_ATTACK
	db 39,WATERFALL
	db 48,HORN_DRILL
	db 54,AGILITY
	db 0

Mon180_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon181_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon182_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon183_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon077_EvosAttacks:
;PONYTA
;Evolutions
	db EV_LEVEL,40,RAPIDASH
	db 0
;Learnset
	db 30,TAIL_WHIP
	db 32,STOMP
	db 35,GROWL
	db 39,FIRE_SPIN
	db 43,TAKE_DOWN
	db 48,AGILITY
	db 0
Mon078_EvosAttacks:
;RAPIDASH
;Evolutions
	db 0
;Learnset
	db 30,TAIL_WHIP
	db 32,STOMP
	db 35,GROWL
	db 39,FIRE_SPIN
	db 47,TAKE_DOWN
	db 55,AGILITY
	db 0
Mon019_EvosAttacks:
;RATTATA
;Evolutions
	db EV_LEVEL,20,RATICATE
	db 0
;Learnset
	db 7,QUICK_ATTACK
	db 14,HYPER_FANG
	db 23,FOCUS_ENERGY
	db 34,SUPER_FANG
	db 0
Mon020_EvosAttacks:
;RATICATE
;Evolutions
	db 0
;Learnset
	db 7,QUICK_ATTACK
	db 14,HYPER_FANG
	db 27,FOCUS_ENERGY
	db 41,SUPER_FANG
	db 0
Mon033_EvosAttacks:
;NIDORINO
;Evolutions
	db EV_ITEM,MOON_STONE,1,NIDOKING
	db 0
;Learnset
	db 8,HORN_ATTACK
	db 14,POISON_STING
	db 23,FOCUS_ENERGY
	db 32,FURY_ATTACK
	db 41,HORN_DRILL
	db 50,DOUBLE_KICK
	db 0
Mon030_EvosAttacks:
;NIDORINA
;Evolutions
	db EV_ITEM,MOON_STONE,1,NIDOQUEEN
	db 0
;Learnset
	db 8,SCRATCH
	db 14,POISON_STING
	db 23,TAIL_WHIP
	db 32,BITE
	db 41,FURY_SWIPES
	db 50,DOUBLE_KICK
	db 0
Mon074_EvosAttacks:
;GEODUDE
;Evolutions
	db EV_LEVEL,25,GRAVELER
	db 0
;Learnset
	db 11,DEFENSE_CURL
	db 16,ROCK_THROW
	db 21,SELFDESTRUCT
	db 26,HARDEN
	db 31,EARTHQUAKE
	db 36,EXPLOSION
	db 0
Mon137_EvosAttacks:
;PORYGON
;Evolutions
	db 0
;Learnset
	db 23,PSYBEAM
	db 28,RECOVER
	db 35,AGILITY
	db 42,TRI_ATTACK
	db 0
Mon142_EvosAttacks:
;AERODACTYL
;Evolutions
	db 0
;Learnset
	db 33,SUPERSONIC
	db 38,BITE
	db 45,TAKE_DOWN
	db 54,HYPER_BEAM
	db 0

Mon184_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon081_EvosAttacks:
;MAGNEMITE
;Evolutions
	db EV_LEVEL,30,MAGNETON
	db 0
;Learnset
	db 21,SONICBOOM
	db 25,THUNDERSHOCK
	db 29,SUPERSONIC
	db 35,THUNDER_WAVE
	db 41,SWIFT
	db 47,SCREECH
	db 0

Mon185_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon186_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon004_EvosAttacks:
;CHARMANDER
;Evolutions
	db EV_LEVEL,16,CHARMELEON
	db 0
;Learnset
	db 9,EMBER
	db 15,LEER
	db 22,RAGE
	db 30,SLASH
	db 38,FLAMETHROWER
	db 46,FIRE_SPIN
	db 0
Mon007_EvosAttacks:
;SQUIRTLE
;Evolutions
	db EV_LEVEL,16,WARTORTLE
	db 0
;Learnset
	db 8,BUBBLE
	db 15,WATER_GUN
	db 22,BITE
	db 28,WITHDRAW
	db 35,SKULL_BASH
	db 42,HYDRO_PUMP
	db 0
Mon005_EvosAttacks:
;CHARMELEON
;Evolutions
	db EV_LEVEL,36,CHARIZARD
	db 0
;Learnset
	db 9,EMBER
	db 15,LEER
	db 24,RAGE
	db 33,SLASH
	db 42,FLAMETHROWER
	db 56,FIRE_SPIN
	db 0
Mon008_EvosAttacks:
;WARTORTLE
;Evolutions
	db EV_LEVEL,36,BLASTOISE
	db 0
;Learnset
	db 8,BUBBLE
	db 15,WATER_GUN
	db 24,BITE
	db 31,WITHDRAW
	db 39,SKULL_BASH
	db 47,HYDRO_PUMP
	db 0
Mon006_EvosAttacks:
;CHARIZARD
;Evolutions
	db 0
;Learnset
	db 9,EMBER
	db 15,LEER
	db 24,RAGE
	db 36,SLASH
	db 46,FLAMETHROWER
	db 55,FIRE_SPIN
	db 0

Mon187_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon188_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon189_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0

Mon190_EvosAttacks:
;MISSINGNO
;Evolutions
	db 0
;Learnset
	db 0
Mon043_EvosAttacks:
;ODDISH
;Evolutions
	db EV_LEVEL,21,GLOOM
	db 0
;Learnset
	db 15,POISONPOWDER
	db 17,STUN_SPORE
	db 19,SLEEP_POWDER
	db 24,ACID
	db 33,PETAL_DANCE
	db 46,SOLARBEAM
	db 0
Mon044_EvosAttacks:
;GLOOM
;Evolutions
	db EV_ITEM,LEAF_STONE ,1,VILEPLUME
	db 0
;Learnset
	db 15,POISONPOWDER
	db 17,STUN_SPORE
	db 19,SLEEP_POWDER
	db 28,ACID
	db 38,PETAL_DANCE
	db 52,SOLARBEAM
	db 0
Mon045_EvosAttacks:
;VILEPLUME
;Evolutions
	db 0
;Learnset
	db 15,POISONPOWDER
	db 17,STUN_SPORE
	db 19,SLEEP_POWDER
	db 0
Mon069_EvosAttacks:
;BELLSPROUT
;Evolutions
	db EV_LEVEL,21,WEEPINBELL
	db 0
;Learnset
	db 13,WRAP
	db 15,POISONPOWDER
	db 18,SLEEP_POWDER
	db 21,STUN_SPORE
	db 26,ACID
	db 33,RAZOR_LEAF
	db 42,SLAM
	db 0
Mon070_EvosAttacks:
;WEEPINBELL
;Evolutions
	db EV_ITEM,LEAF_STONE ,1,VICTREEBEL
	db 0
;Learnset
	db 13,WRAP
	db 15,POISONPOWDER
	db 18,SLEEP_POWDER
	db 23,STUN_SPORE
	db 29,ACID
	db 38,RAZOR_LEAF
	db 49,SLAM
	db 0
Mon071_EvosAttacks:
;VICTREEBEL
;Evolutions
	db 0
;Learnset
	db 13,WRAP
	db 15,POISONPOWDER
	db 18,SLEEP_POWDER
	db 0

INCBIN "baserom.gbc",$3B9EC, $3C000 - $3B9EC

SECTION "bankF",DATA,BANK[$F]

; These are move effects (second value from the Attacks table in bank $E).
EffectsArray1: ; 4000
	db $18,$19,$1C,$2E,$2F,$31,$38,$39,$40,$41,$42,$43,$4F,$52,$54,$55,$FF
EffectsArray2: ; 4011
; attacks that do damage but not through normal calculations
; e.g., Super Fang, Psywave
	db $28,$29,$FF
EffectsArray3: ; 4014
; non-damaging, stat‐affecting or status‐causing attacks?
; e.g., Meditate, Bide, Hypnosis
	db $01,$0A,$0B,$0C,$0D,$0E,$0F,$12,$13,$14,$15,$16,$17,$1A,$20,$32,$33,$34,$35,$36,$37,$3A,$3B,$3C,$3D,$3E,$3F,$FF
EffectsArray4: ; 4030
	db $03,$07,$08,$10,$1D,$1E,$2C,$30,$4D,$51,$FF
EffectsArray5: ; 403B
	db $03,$07,$08,$10,$11,$1D,$1E,$27,$28,$29,$2B,$2C,$2D,$30 ; fallthru
EffectsArray5B: ; 4049
; attacks that prevent the player from switching attacks?
	db $1B,$2A,$FF

INCBIN "baserom.gbc",$3C04C,$90E - $4C

; XXX this needs cleaning up. it's what runs when a juggler switches pokemon
EnemySendOut: ; 490E
	ld hl,$D058
	xor a
	ld [hl],a
	ld a,[$CC2F]
	ld c,a
	ld b,1
	push bc
	ld a,$10
	call Predef
	ld hl,$CCF5
	xor a
	ld [hl],a
	pop bc
	ld a,$10
	call Predef
	xor a
	ld hl,$D065
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hl],a
	ld [$D072],a
	ld [$CCEF],a
	ld [$CCF3],a
	ld hl,$CCF1
	ld [hli],a
	ld [hl],a
	dec a
	ld [W_AICOUNT],a
	ld hl,$D062
	res 5,[hl]
	ld hl,$C3B2
	ld a,8
	call $48DF
	call $6E94
	call $3719
	ld a,[$D12B]
	cp 4
	jr nz,.next\@
	ld a,[$CC3E]
	sub 4
	ld [$CF92],a
	jr .next3\@
.next\@
	ld b,$FF
.next2\@
	inc b
	ld a,[$CFE8]
	cp b
	jr z,.next2\@
	ld hl,$D8A4
	ld a,b
	ld [$CF92],a
	push bc
	ld bc,$2C
	call AddNTimes
	pop bc
	inc hl
	ld a,[hli]
	ld c,a
	ld a,[hl]
	or c
	jr z,.next2\@
.next3\@
	ld a,[$CF92]
	ld hl,$D8C5
	ld bc,$2C
	call AddNTimes
	ld a,[hl]
	ld [$D127],a
	ld a,[$CF92]
	inc a
	ld hl,$D89C
	ld c,a
	ld b,0
	add hl,bc
	ld a,[hl]
	ld [$CFD8],a
	ld [$CF91],a
	call $6B01
	ld hl,$CFE6
	ld a,[hli]
	ld [$CCE3],a
	ld a,[hl]
	ld [$CCE4],a
	ld a,1
	ld [$CC26],a
	ld a,[$D11D]
	dec a
	jr z,.next4\@
	ld a,[W_NUMINPARTY]
	dec a
	jr z,.next4\@
	ld a,[$D12B]
	cp 4
	jr z,.next4\@
	ld a,[$D355]
	bit 6,a
	jr nz,.next4\@
	ld hl,TrainerAboutToUseText
	call PrintText
	ld hl,$C42C
	ld bc,$0801
	ld a,$14
	ld [$D125],a
	call $30E8
	ld a,[$CC26]
	and a
	jr nz,.next4\@
	ld a,2
	ld [$D07D],a
	call $13FC
.next9\@
	ld a,1
	ld [$CC26],a
	jr c,.next7\@
	ld hl,$CC2F
	ld a,[$CF92]
	cp [hl]
	jr nz,.next6\@
	ld hl,$51F5
	call PrintText
.next8\@
	call $1411
	jr .next9\@
.next6\@
	call $4A97
	jr z,.next8\@
	xor a
	ld [$CC26],a
.next7\@
	call $3DE5
	call $6E5B
	call $3725
.next4\@
	call $0082
	ld hl,$C3A0
	ld bc,$040B
	call $18C4
	ld b,1
	call $3DEF
	call $3DDC
	ld hl,TrainerSentOutText
	call PrintText
	ld a,[$CFD8]
	ld [$CF91],a
	ld [$D0B5],a
	call $1537
	ld de,$9000
	call $1665
	ld a,$CF
	ld [$FFE1],a
	ld hl,$C427
	ld a,2
	call Predef
	ld a,[$CFD8]
	call $13D0
	call $4DEC
	ld a,[$CC26]
	and a
	ret nz
	xor a
	ld [$D058],a
	ld [$CCF5],a
	call $3719
	jp $51BA

TrainerAboutToUseText:
	TX_FAR _TrainerAboutToUseText
	db "@"

TrainerSentOutText:
	TX_FAR _TrainerSentOutText
	db "@"

INCBIN "baserom.gbc",$3CA83,$3D6A9 - $3CA83
; in-battle stuff
	ld hl,$D062
	res 4,[hl]
	res 6,[hl]
	call $5AF5
	ld hl,DecrementPP
	ld de,$CCDC ; pointer to the move just used
	ld b,BANK(DecrementPP)
	call Bankswitch
	ld a,[$CFD3] ; effect of the attack just used
	ld hl,EffectsArray1
	ld de,1
	call IsInArray
	jp c,$7132
	ld a,[$CFD3]
	ld hl,EffectsArray5B
	ld de,1
	call IsInArray
	call c,$7132
	ld a,[$CFD3]
	ld hl,EffectsArray2
	ld de,1
	call IsInArray
	jp c,$5702
	call $6023
	call $6093
	jr z,.next11\@
	call $5DCF
	call $5F65
	jp z,$574B
	call $63A5
	call $6687
	call $656B
.next11\@
	ld a,[$D05F]
	and a
	jr z,.next\@
	ld a,[$CFD3]
	sub a,7
	jr z,.next2\@
	jr .next3\@ ; 574B
.next\@
	ld a,[$CFD3]
	and a
	ld a,4
	jr z,.next2\@
	ld a,5
.next2\@
	push af
	ld a,[$D063]
	bit 4,a
	ld hl,$5747
	ld b,$1E
	call nz,Bankswitch
	pop af
	ld [$CC5B],a
	ld a,[$CFD2]
	call $6F07
	call $6ED3
	call $4D60
	ld a,[$D063]
	bit 4,a
	ld hl,$5771
	ld b,$1E
	call nz,Bankswitch
	jr .next4\@
.next3\@
	ld c,$1E
	call $3739
	ld a,[$CFD3]
	cp a,$2B
	jr z,.next5\@
	cp a,$27 ; XXX SLP | FRZ ?
	jr z,.next5\@
	jr .next4\@
.next5\@
	xor a
	ld [$CC5B],a
	ld a,$A7
	call $6F07
.next4\@
	ld a,[$CFD3]
	cp a,9
	jr nz,.next6\@ ; 577A
	call $62FD
	jp z,Function580A
	xor a
	ld [$CCED],a
	jp $569A
.next6\@
	cp a,$53
	jr nz,.next7\@ ; 5784
	call $6348
	jp $569A
.next7\@
	ld a,[$CFD3]
	ld hl,EffectsArray3
	ld de,1
	call IsInArray
	jp c,$7132
	ld a,[$D05F]
	and a
	jr z,.next8\@ ; 57A6
	call $5BE2
	ld a,[$CFD3]
	cp a,7
	jr z,.next9\@ ; 57B9
	jp Function580A
.next8\@
	call $60DF
	call $5C5C
	ld hl,$7B7B ; MyFunction
	ld b,$B ; BANK(MyFunction)
	call Bankswitch
	ld a,1
	ld [$CCF4],a
.next9\@
	ld a,[$CFD3]
	ld hl,EffectsArray4
	ld de,1
	call IsInArray
	call c,$7132
	ld hl,$CFE6
	ld a,[hli]
	ld b,[hl]
	or b
	ret z
	call $62B6

	ld hl,$D062
	bit 2,[hl]
	jr z,.next10\@ ; 57EF
	ld a,[$D06A]
	dec a
	ld [$D06A],a
	jp nz,$5714

	res 2,[hl]
	ld hl,MultiHitText
	call PrintText
	xor a
	ld [W_NUMHITS],a ; reset
.next10\@
	ld a,[$CFD3]
	and a
	jp z,Function580A
	ld hl,EffectsArray5
	ld de,1
	call IsInArray
	call nc,$7132
	jp Function580A

MultiHitText:
	TX_FAR _MultiHitText
	db "@"

Function580A: ; 580A
	xor a
	ld [$CD6A],a
	ld b,1
	ret

Function5811: ; 5811
; print the ghost battle messages
	call $583A
	ret nz
	ld a,[H_WHOSETURN]
	and a
	jr nz,.Ghost\@
	ld a,[W_CURMONSTATUS] ; player’s turn
	and a,SLP | FRZ
	ret nz
	ld hl,ScaredText
	call PrintText
	xor a
	ret
.Ghost\@ ; ghost’s turn
	ld hl,GetOutText
	call PrintText
	xor a
	ret

ScaredText:
	TX_FAR _ScaredText
	db "@"

GetOutText:
	TX_FAR _GetOutText
	db "@"

Function583A: ; 583A
	ld a,[W_ISINBATTLE]
	dec a
	ret nz
	ld a,[W_CURMAP]
	cp a,$8E ; Lavender Town
	jr c,.next\@
	cp a,$95 ; Pokémon Tower
	jr nc,.next\@
	ld b,SILPH_SCOPE
	call IsItemInBag ; $3493
	ret z
.next\@
	ld a,1
	and a
	ret

Function5854: ; 5854
	ld hl,W_CURMONSTATUS
	ld a,[hl]
	and a,SLP
	jr z,.FrozenCheck\@ ; to 5884

	dec a
	ld [W_CURMONSTATUS],a ; decrement sleep count
	and a
	jr z,.WakeUp\@ ; to 5874

	xor a
	ld [$CC5B],a
	ld a,SLP_ANIM - 1
	call $6F07
	ld hl,FastAsleepText
	call PrintText
	jr .sleepDone\@
.WakeUp\@
	ld hl,WokeUpText
	call PrintText
.sleepDone\@
	xor a
	ld [$CCF1],a
	ld hl,Function580A
	jp $5A37

.FrozenCheck\@
	bit 5,[hl] ; frozen?
	jr z,.HeldInPlaceCheck\@ ; to 5898
	ld hl,FrozenText
	call PrintText
	xor a
	ld [$CCF1],a
	ld hl,Function580A
	jp $5A37

.HeldInPlaceCheck\@
	ld a,[W_CURMONBATTSTATUS]
	bit 5,a
	jp z,FlinchedCheck
	ld hl,CantMoveText
	call PrintText
	ld hl,Function580A
	jp $5A37

FlinchedCheck: ; 58AC
	ld hl,$D062
	bit 3,[hl]
	jp z,HyperBeamCheck
	res 3,[hl]
	ld hl,FlinchedText
	call PrintText
	ld hl,Function580A
	jp $5A37

HyperBeamCheck: ; 58C2
	ld hl,$D063
	bit 5,[hl]
	jr z,.next\@ ; 58D7
	res 5,[hl]
	ld hl,MustRechargeText
	call PrintText
	ld hl,$580A
	jp $5A37
.next\@
	ld hl,$D06D
	ld a,[hl]
	and a
	jr z,.next2\@ ; 58EE
	dec a
	ld [hl],a
	and a,$F
	jr nz,.next2\@
	ld [hl],a
	ld [$CCEE],a
	ld hl,DisabledNoMoreText
	call PrintText
.next2\@
	ld a,[$D062]
	add a
	jr nc,.next3\@ ; 5929
	ld hl,$D06B
	dec [hl]
	jr nz,.next4\@ ; 5907
	ld hl,$D062
	res 7,[hl]
	ld hl,ConfusedNoMoreText
	call PrintText
	jr .next3\@
.next4\@
	ld hl,IsConfusedText
	call PrintText
	xor a
	ld [$CC5B],a
	ld a,CONF_ANIM - 1
	call $6F07
	call $6E9B
	cp a,$80
	jr c,.next3\@
	ld hl,$D062
	ld a,[hl]
	and a,$80
	ld [hl],a
	call $5AAD
	jr .next5\@ ; 5952
.next3\@
	ld a,[$CCEE]
	and a
	jr z,.ParalysisCheck\@ ; 593E
	ld hl,$CCDC
	cp [hl]
	jr nz,.ParalysisCheck\@
	call $5A88
	ld hl,$580A
	jp $5A37
.ParalysisCheck\@
	ld hl,W_CURMONSTATUS
	bit 6,[hl]
	jr z,.next7\@ ; 5975
	call $6E9B ; random number?
	cp a,$3F
	jr nc,.next7\@
	ld hl,FullyParalyzedText
	call PrintText
.next5\@
	ld hl,$D062
	ld a,[hl]
	and a,$CC
	ld [hl],a
	ld a,[$CFD3]
	cp a,$2B
	jr z,.next8\@ ; 5966
	cp a,$27
	jr z,.next8\@
	jr .next9\@ ; 596F
.next8\@
	xor a
	ld [$CC5B],a
	ld a,$A7
	call $6F07
.next9\@
	ld hl,$580A
	jp $5A37
.next7\@
	ld hl,$D062
	bit 0,[hl]
	jr z,.next10\@ ; 59D0
	xor a
	ld [$CFD2],a
	ld hl,$D0D7
	ld a,[hli]
	ld b,a
	ld c,[hl]
	ld hl,$D075
	ld a,[hl]
	add c
	ld [hld],a
	ld a,[hl]
	adc b
	ld [hl],a
	ld hl,$D06A
	dec [hl]
	jr z,.next11\@ ; 599B
	ld hl,$580A
	jp $5A37
.next11\@
	ld hl,$D062
	res 0,[hl]
	ld hl,UnleashedEnergyText
	call PrintText
	ld a,1
	ld [$CFD4],a
	ld hl,$D075
	ld a,[hld]
	add a
	ld b,a
	ld [$D0D8],a
	ld a,[hl]
	rl a
	ld [$D0D7],a
	or b
	jr nz,.next12\@ ; 59C2
	ld a,1
	ld [$D05F],a
.next12\@
	xor a
	ld [hli],a
	ld [hl],a
	ld a,$75
	ld [$CFD2],a
	ld hl,$5705
	jp $5A37
.next10\@
	bit 1,[hl]
	jr z,.next13\@ ; 59FF
	ld a,$25
	ld [$CFD2],a
	ld hl,ThrashingAboutText
	call PrintText
	ld hl,$D06A
	dec [hl]
	ld hl,$56DC
	jp nz,$5A37
	push hl
	ld hl,$D062
	res 1,[hl]
	set 7,[hl]
	call $6E9B ; random number?
	and a,3
	inc a
	inc a
	ld [$D06B],a
	pop hl
	jp $5A37
.next13\@
	bit 5,[hl]
	jp z,$5A1A
	ld hl,AttackContinuesText
	call PrintText
	ld a,[$D06A]
	dec a
	ld [$D06A],a
	ld hl,$5714
	jp nz,$5A37
	jp $5A37

INCBIN "baserom.gbc",$3DA1A,$3DA3D - $3DA1A

FastAsleepText:
	TX_FAR _FastAsleepText
	db "@"

WokeUpText:
	TX_FAR _WokeUpText
	db "@"

FrozenText:
	TX_FAR _FrozenText
	db "@"

FullyParalyzedText:
	TX_FAR _FullyParalyzedText
	db "@"

FlinchedText:
	TX_FAR _FlinchedText
	db "@"

MustRechargeText:
	TX_FAR _MustRechargeText
	db "@"

DisabledNoMoreText:
	TX_FAR _DisabledNoMoreText
	db "@"

IsConfusedText:
	TX_FAR _IsConfusedText
	db "@"

HurtItselfText:
	TX_FAR _HurtItselfText
	db "@"

ConfusedNoMoreText:
	TX_FAR _ConfusedNoMoreText
	db "@"

SavingEnergyText:
	TX_FAR _SavingEnergyText
	db "@"

UnleashedEnergyText:
	TX_FAR _UnleashedEnergyText
	db "@"

ThrashingAboutText:
	TX_FAR _ThrashingAboutText
	db "@"

AttackContinuesText:
	TX_FAR _AttackContinuesText
	db "@"

CantMoveText:
	TX_FAR _CantMoveText
	db "@"

INCBIN "baserom.gbc",$3DA88,$3E474 - $3DA88

TypeEffects: ; 6474
; format: attacking type, defending type, damage multiplier
; the multiplier is a (decimal) fixed-point number:
;     20 is ×2.0
;     05 is ×0.5
;     00 is ×0
	db WATER,FIRE,20
	db FIRE,GRASS,20
	db FIRE,ICE,20
	db GRASS,WATER,20
	db ELECTRIC,WATER,20
	db WATER,ROCK,20
	db GROUND,FLYING,00
	db WATER,WATER,05
	db FIRE,FIRE,05
	db ELECTRIC,ELECTRIC,05
	db ICE,ICE,05
	db GRASS,GRASS,05
	db PSYCHIC,PSYCHIC,05
	db FIRE,WATER,05
	db GRASS,FIRE,05
	db WATER,GRASS,05
	db ELECTRIC,GRASS,05
	db NORMAL,ROCK,05
	db NORMAL,GHOST,00
	db GHOST,GHOST,20
	db FIRE,BUG,20
	db FIRE,ROCK,05
	db WATER,GROUND,20
	db ELECTRIC,GROUND,00
	db ELECTRIC,FLYING,20
	db GRASS,GROUND,20
	db GRASS,BUG,05
	db GRASS,POISON,05
	db GRASS,ROCK,20
	db GRASS,FLYING,05
	db ICE,WATER,05
	db ICE,GRASS,20
	db ICE,GROUND,20
	db ICE,FLYING,20
	db FIGHTING,NORMAL,20
	db FIGHTING,POISON,05
	db FIGHTING,FLYING,05
	db FIGHTING,PSYCHIC,05
	db FIGHTING,BUG,05
	db FIGHTING,ROCK,20
	db FIGHTING,ICE,20
	db FIGHTING,GHOST,00
	db POISON,GRASS,20
	db POISON,POISON,05
	db POISON,GROUND,05
	db POISON,BUG,20
	db POISON,ROCK,05
	db POISON,GHOST,05
	db GROUND,FIRE,20
	db GROUND,ELECTRIC,20
	db GROUND,GRASS,05
	db GROUND,BUG,05
	db GROUND,ROCK,20
	db GROUND,POISON,20
	db FLYING,ELECTRIC,05
	db FLYING,FIGHTING,20
	db FLYING,BUG,20
	db FLYING,GRASS,20
	db FLYING,ROCK,05
	db PSYCHIC,FIGHTING,20
	db PSYCHIC,POISON,20
	db BUG,FIRE,05
	db BUG,GRASS,20
	db BUG,FIGHTING,05
	db BUG,FLYING,05
	db BUG,PSYCHIC,20
	db BUG,GHOST,05
	db BUG,POISON,20
	db ROCK,FIRE,20
	db ROCK,FIGHTING,05
	db ROCK,GROUND,05
	db ROCK,FLYING,20
	db ROCK,BUG,20
	db ROCK,ICE,20
	db GHOST,NORMAL,00
	db GHOST,PSYCHIC,00
	db FIRE,DRAGON,05
	db WATER,DRAGON,05
	db ELECTRIC,DRAGON,05
	db GRASS,DRAGON,05
	db ICE,DRAGON,20
	db DRAGON,DRAGON,20
	db $FF

INCBIN "baserom.gbc",$3E56B,$3EF07 - $3E56B

PlayAttackAnimation: ; 6F07
	ld [$D07C],a
	call Delay3
	ld a,8
	jp Predef

INCBIN "baserom.gbc",$3EF12,$40000 - $3EF12

SECTION "bank10",DATA,BANK[$10]
INCBIN "baserom.gbc",$40000,$47E

PokedexEntryPointers: ; 447E
	dw RhydonDexEntry
	dw KangaskhanDexEntry
	dw NidoranMDexEntry
	dw ClefairyDexEntry
	dw SpearowDexEntry
	dw VoltorbDexEntry
	dw NidokingDexEntry
	dw SlowbroDexEntry
	dw IvysaurDexEntry
	dw ExeggutorDexEntry
	dw LickitungDexEntry
	dw ExeggcuteDexEntry
	dw GrimerDexEntry
	dw GengarDexEntry
	dw NidoranFDexEntry
	dw NidoqueenDexEntry
	dw CuboneDexEntry
	dw RhyhornDexEntry
	dw LaprasDexEntry
	dw ArcanineDexEntry
	dw MewDexEntry
	dw GyaradosDexEntry
	dw ShellderDexEntry
	dw TentacoolDexEntry
	dw GastlyDexEntry
	dw ScytherDexEntry
	dw StaryuDexEntry
	dw BlastoiseDexEntry
	dw PinsirDexEntry
	dw TangelaDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw GrowlitheDexEntry
	dw OnixDexEntry
	dw FearowDexEntry
	dw PidgeyDexEntry
	dw SlowpokeDexEntry
	dw KadabraDexEntry
	dw GravelerDexEntry
	dw ChanseyDexEntry
	dw MachokeDexEntry
	dw MrMimeDexEntry
	dw HitmonleeDexEntry
	dw HitmonchanDexEntry
	dw ArbokDexEntry
	dw ParasectDexEntry
	dw PsyduckDexEntry
	dw DrowzeeDexEntry
	dw GolemDexEntry
	dw MissingNoDexEntry
	dw MagmarDexEntry
	dw MissingNoDexEntry
	dw ElectabuzzDexEntry
	dw MagnetonDexEntry
	dw KoffingDexEntry
	dw MissingNoDexEntry
	dw MankeyDexEntry
	dw SeelDexEntry
	dw DiglettDexEntry
	dw TaurosDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw FarfetchdDexEntry
	dw VenonatDexEntry
	dw DragoniteDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw DoduoDexEntry
	dw PoliwagDexEntry
	dw JynxDexEntry
	dw MoltresDexEntry
	dw ArticunoDexEntry
	dw ZapdosDexEntry
	dw DittoDexEntry
	dw MeowthDexEntry
	dw KrabbyDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw VulpixDexEntry
	dw NinetalesDexEntry
	dw PikachuDexEntry
	dw RaichuDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw DratiniDexEntry
	dw DragonairDexEntry
	dw KabutoDexEntry
	dw KabutopsDexEntry
	dw HorseaDexEntry
	dw SeadraDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw SandshrewDexEntry
	dw SandslashDexEntry
	dw OmanyteDexEntry
	dw OmastarDexEntry
	dw JigglypuffDexEntry
	dw WigglytuffDexEntry
	dw EeveeDexEntry
	dw FlareonDexEntry
	dw JolteonDexEntry
	dw VaporeonDexEntry
	dw MachopDexEntry
	dw ZubatDexEntry
	dw EkansDexEntry
	dw ParasDexEntry
	dw PoliwhirlDexEntry
	dw PoliwrathDexEntry
	dw WeedleDexEntry
	dw KakunaDexEntry
	dw BeedrillDexEntry
	dw MissingNoDexEntry
	dw DodrioDexEntry
	dw PrimeapeDexEntry
	dw DugtrioDexEntry
	dw VenomothDexEntry
	dw DewgongDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw CaterpieDexEntry
	dw MetapodDexEntry
	dw ButterfreeDexEntry
	dw MachampDexEntry
	dw MissingNoDexEntry
	dw GolduckDexEntry
	dw HypnoDexEntry
	dw GolbatDexEntry
	dw MewtwoDexEntry
	dw SnorlaxDexEntry
	dw MagikarpDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MukDexEntry
	dw MissingNoDexEntry
	dw KinglerDexEntry
	dw CloysterDexEntry
	dw MissingNoDexEntry
	dw ElectrodeDexEntry
	dw ClefableDexEntry
	dw WeezingDexEntry
	dw PersianDexEntry
	dw MarowakDexEntry
	dw MissingNoDexEntry
	dw HaunterDexEntry
	dw AbraDexEntry
	dw AlakazamDexEntry
	dw PidgeottoDexEntry
	dw PidgeotDexEntry
	dw StarmieDexEntry
	dw BulbasaurDexEntry
	dw VenusaurDexEntry
	dw TentacruelDexEntry
	dw MissingNoDexEntry
	dw GoldeenDexEntry
	dw SeakingDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw PonytaDexEntry
	dw RapidashDexEntry
	dw RattataDexEntry
	dw RaticateDexEntry
	dw NidorinoDexEntry
	dw NidorinaDexEntry
	dw GeodudeDexEntry
	dw PorygonDexEntry
	dw AerodactylDexEntry
	dw MissingNoDexEntry
	dw MagnemiteDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw CharmanderDexEntry
	dw SquirtleDexEntry
	dw CharmeleonDexEntry
	dw WartortleDexEntry
	dw CharizardDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw MissingNoDexEntry
	dw OddishDexEntry
	dw GloomDexEntry
	dw VileplumeDexEntry
	dw BellsproutDexEntry
	dw WeepinbellDexEntry
	dw VictreebelDexEntry

; string: species name
; height in feet, inches
; weight in pounds
; text entry

RhydonDexEntry:
	db "DRILL@"
	db 6,3
	dw 2650
	TX_FAR _RhydonDexEntry
	db "@"

KangaskhanDexEntry:
	db "PARENT@"
	db 7,3
	dw 1760
	TX_FAR _KangaskhanDexEntry
	db "@"

NidoranMDexEntry:
	db "POISON PIN@"
	db 1,8
	dw 200
	TX_FAR _NidoranMDexEntry
	db "@"

ClefairyDexEntry:
	db "FAIRY@"
	db 2,0
	dw 170
	TX_FAR _ClefairyDexEntry
	db "@"

SpearowDexEntry:
	db "TINY BIRD@"
	db 1,0
	dw 40
	TX_FAR _SpearowDexEntry
	db "@"

VoltorbDexEntry:
	db "BALL@"
	db 1,8
	dw 230
	TX_FAR _VoltorbDexEntry
	db "@"

NidokingDexEntry:
	db "DRILL@"
	db 4,7
	dw 1370
	TX_FAR _NidokingDexEntry
	db "@"

SlowbroDexEntry:
	db "HERMITCRAB@"
	db 5,3
	dw 1730
	TX_FAR _SlowbroDexEntry
	db "@"

IvysaurDexEntry:
	db "SEED@"
	db 3,3
	dw 290
	TX_FAR _IvysaurDexEntry
	db "@"

ExeggutorDexEntry:
	db "COCONUT@"
	db 6,7
	dw 2650
	TX_FAR _ExeggutorDexEntry
	db "@"

LickitungDexEntry:
	db "LICKING@"
	db 3,11
	dw 1440
	TX_FAR _LickitungDexEntry
	db "@"

ExeggcuteDexEntry:
	db "EGG@"
	db 1,4
	dw 60
	TX_FAR _ExeggcuteDexEntry
	db "@"

GrimerDexEntry:
	db "SLUDGE@"
	db 2,11
	dw 660
	TX_FAR _GrimerDexEntry
	db "@"

GengarDexEntry:
	db "SHADOW@"
	db 4,11
	dw 890
	TX_FAR _GengarDexEntry
	db "@"

NidoranFDexEntry:
	db "POISON PIN@"
	db 1,4
	dw 150
	TX_FAR _NidoranFDexEntry
	db "@"

NidoqueenDexEntry:
	db "DRILL@"
	db 4,3
	dw 1320
	TX_FAR _NidoqueenDexEntry
	db "@"

CuboneDexEntry:
	db "LONELY@"
	db 1,4
	dw 140
	TX_FAR _CuboneDexEntry
	db "@"

RhyhornDexEntry:
	db "SPIKES@"
	db 3,3
	dw 2540
	TX_FAR _RhyhornDexEntry
	db "@"

LaprasDexEntry:
	db "TRANSPORT@"
	db 8,2
	dw 4850
	TX_FAR _LaprasDexEntry
	db "@"

ArcanineDexEntry:
	db "LEGENDARY@"
	db 6,3
	dw 3420
	TX_FAR _ArcanineDexEntry
	db "@"

MewDexEntry:
	db "NEW SPECIE@"
	db 1,4
	dw 90
	TX_FAR _MewDexEntry
	db "@"

GyaradosDexEntry:
	db "ATROCIOUS@"
	db 21,4
	dw 5180
	TX_FAR _GyaradosDexEntry
	db "@"

ShellderDexEntry:
	db "BIVALVE@"
	db 1,0
	dw 90
	TX_FAR _ShellderDexEntry
	db "@"

TentacoolDexEntry:
	db "JELLYFISH@"
	db 2,11
	dw 1000
	TX_FAR _TentacoolDexEntry
	db "@"

GastlyDexEntry:
	db "GAS@"
	db 4,3
	dw 2
	TX_FAR _GastlyDexEntry
	db "@"

ScytherDexEntry:
	db "MANTIS@"
	db 4,11
	dw 1230
	TX_FAR _ScytherDexEntry
	db "@"

StaryuDexEntry:
	db "STARSHAPE@"
	db 2,7
	dw 760
	TX_FAR _StaryuDexEntry
	db "@"

BlastoiseDexEntry:
	db "SHELLFISH@"
	db 5,3
	dw 1890
	TX_FAR _BlastoiseDexEntry
	db "@"

PinsirDexEntry:
	db "STAGBEETLE@"
	db 4,11
	dw 1210
	TX_FAR _PinsirDexEntry
	db "@"

TangelaDexEntry:
	db "VINE@"
	db 3,3
	dw 770
	TX_FAR _TangelaDexEntry
	db "@"

GrowlitheDexEntry:
	db "PUPPY@"
	db 2,4
	dw 420
	TX_FAR _GrowlitheDexEntry
	db "@"

OnixDexEntry:
	db "ROCK SNAKE@"
	db 28,10
	dw 4630
	TX_FAR _OnixDexEntry
	db "@"

FearowDexEntry:
	db "BEAK@"
	db 3,11
	dw 840
	TX_FAR _FearowDexEntry
	db "@"

PidgeyDexEntry:
	db "TINY BIRD@"
	db 1,0
	dw 40
	TX_FAR _PidgeyDexEntry
	db "@"

SlowpokeDexEntry:
	db "DOPEY@"
	db 3,11
	dw 790
	TX_FAR _SlowpokeDexEntry
	db "@"

KadabraDexEntry:
	db "PSI@"
	db 4,3
	dw 1250
	TX_FAR _KadabraDexEntry
	db "@"

GravelerDexEntry:
	db "ROCK@"
	db 3,3
	dw 2320
	TX_FAR _GravelerDexEntry
	db "@"

ChanseyDexEntry:
	db "EGG@"
	db 3,7
	dw 760
	TX_FAR _ChanseyDexEntry
	db "@"

MachokeDexEntry:
	db "SUPERPOWER@"
	db 4,11
	dw 1550
	TX_FAR _MachokeDexEntry
	db "@"

MrMimeDexEntry:
	db "BARRIER@"
	db 4,3
	dw 1200
	TX_FAR _MrMimeDexEntry
	db "@"

HitmonleeDexEntry:
	db "KICKING@"
	db 4,11
	dw 1100
	TX_FAR _HitmonleeDexEntry
	db "@"

HitmonchanDexEntry:
	db "PUNCHING@"
	db 4,7
	dw 1110
	TX_FAR _HitmonchanDexEntry
	db "@"

ArbokDexEntry:
	db "COBRA@"
	db 11,6
	dw 1430
	TX_FAR _ArbokDexEntry
	db "@"

ParasectDexEntry:
	db "MUSHROOM@"
	db 3,3
	dw 650
	TX_FAR _ParasectDexEntry
	db "@"

PsyduckDexEntry:
	db "DUCK@"
	db 2,7
	dw 430
	TX_FAR _PsyduckDexEntry
	db "@"

DrowzeeDexEntry:
	db "HYPNOSIS@"
	db 3,3
	dw 710
	TX_FAR _DrowzeeDexEntry
	db "@"

GolemDexEntry:
	db "MEGATON@"
	db 4,7
	dw 6620
	TX_FAR _GolemDexEntry
	db "@"

MagmarDexEntry:
	db "SPITFIRE@"
	db 4,3
	dw 980
	TX_FAR _MagmarDexEntry
	db "@"

ElectabuzzDexEntry:
	db "ELECTRIC@"
	db 3,7
	dw 660
	TX_FAR _ElectabuzzDexEntry
	db "@"

MagnetonDexEntry:
	db "MAGNET@"
	db 3,3
	dw 1320
	TX_FAR _MagnetonDexEntry
	db "@"

KoffingDexEntry:
	db "POISON GAS@"
	db 2,0
	dw 20
	TX_FAR _KoffingDexEntry
	db "@"

MankeyDexEntry:
	db "PIG MONKEY@"
	db 1,8
	dw 620
	TX_FAR _MankeyDexEntry
	db "@"

SeelDexEntry:
	db "SEA LION@"
	db 3,7
	dw 1980
	TX_FAR _SeelDexEntry
	db "@"

DiglettDexEntry:
	db "MOLE@"
	db 0,8
	dw 20
	TX_FAR _DiglettDexEntry
	db "@"

TaurosDexEntry:
	db "WILD BULL@"
	db 4,7
	dw 1950
	TX_FAR _TaurosDexEntry
	db "@"

FarfetchdDexEntry:
	db "WILD DUCK@"
	db 2,7
	dw 330
	TX_FAR _FarfetchdDexEntry
	db "@"

VenonatDexEntry:
	db "INSECT@"
	db 3,3
	dw 660
	TX_FAR _VenonatDexEntry
	db "@"

DragoniteDexEntry:
	db "DRAGON@"
	db 7,3
	dw 4630
	TX_FAR _DragoniteDexEntry
	db "@"

DoduoDexEntry:
	db "TWIN BIRD@"
	db 4,7
	dw 860
	TX_FAR _DoduoDexEntry
	db "@"

PoliwagDexEntry:
	db "TADPOLE@"
	db 2,0
	dw 270
	TX_FAR _PoliwagDexEntry
	db "@"

JynxDexEntry:
	db "HUMANSHAPE@"
	db 4,7
	dw 900
	TX_FAR _JynxDexEntry
	db "@"

MoltresDexEntry:
	db "FLAME@"
	db 6,7
	dw 1320
	TX_FAR _MoltresDexEntry
	db "@"

ArticunoDexEntry:
	db "FREEZE@"
	db 5,7
	dw 1220
	TX_FAR _ArticunoDexEntry
	db "@"

ZapdosDexEntry:
	db "ELECTRIC@"
	db 5,3
	dw 1160
	TX_FAR _ZapdosDexEntry
	db "@"

DittoDexEntry:
	db "TRANSFORM@"
	db 1,0
	dw 90
	TX_FAR _DittoDexEntry
	db "@"

MeowthDexEntry:
	db "SCRATCHCAT@"
	db 1,4
	dw 90
	TX_FAR _MeowthDexEntry
	db "@"

KrabbyDexEntry:
	db "RIVER CRAB@"
	db 1,4
	dw 140
	TX_FAR _KrabbyDexEntry
	db "@"

VulpixDexEntry:
	db "FOX@"
	db 2,0
	dw 220
	TX_FAR _VulpixDexEntry
	db "@"

NinetalesDexEntry:
	db "FOX@"
	db 3,7
	dw 440
	TX_FAR _NinetalesDexEntry
	db "@"

PikachuDexEntry:
	db "MOUSE@"
	db 1,4
	dw 130
	TX_FAR _PikachuDexEntry
	db "@"

RaichuDexEntry:
	db "MOUSE@"
	db 2,7
	dw 660
	TX_FAR _RaichuDexEntry
	db "@"

DratiniDexEntry:
	db "DRAGON@"
	db 5,11
	dw 70
	TX_FAR _DratiniDexEntry
	db "@"

DragonairDexEntry:
	db "DRAGON@"
	db 13,1
	dw 360
	TX_FAR _DragonairDexEntry
	db "@"

KabutoDexEntry:
	db "SHELLFISH@"
	db 1,8
	dw 250
	TX_FAR _KabutoDexEntry
	db "@"

KabutopsDexEntry:
	db "SHELLFISH@"
	db 4,3
	dw 890
	TX_FAR _KabutopsDexEntry
	db "@"

HorseaDexEntry:
	db "DRAGON@"
	db 1,4
	dw 180
	TX_FAR _HorseaDexEntry
	db "@"

SeadraDexEntry:
	db "DRAGON@"
	db 3,11
	dw 550
	TX_FAR _SeadraDexEntry
	db "@"

SandshrewDexEntry:
	db "MOUSE@"
	db 2,0
	dw 260
	TX_FAR _SandshrewDexEntry
	db "@"

SandslashDexEntry:
	db "MOUSE@"
	db 3,3
	dw 650
	TX_FAR _SandslashDexEntry
	db "@"

OmanyteDexEntry:
	db "SPIRAL@"
	db 1,4
	dw 170
	TX_FAR _OmanyteDexEntry
	db "@"

OmastarDexEntry:
	db "SPIRAL@"
	db 3,3
	dw 770
	TX_FAR _OmastarDexEntry
	db "@"

JigglypuffDexEntry:
	db "BALLOON@"
	db 1,8
	dw 120
	TX_FAR _JigglypuffDexEntry
	db "@"

WigglytuffDexEntry:
	db "BALLOON@"
	db 3,3
	dw 260
	TX_FAR _WigglytuffDexEntry
	db "@"

EeveeDexEntry:
	db "EVOLUTION@"
	db 1,0
	dw 140
	TX_FAR _EeveeDexEntry
	db "@"

FlareonDexEntry:
	db "FLAME@"
	db 2,11
	dw 550
	TX_FAR _FlareonDexEntry
	db "@"

JolteonDexEntry:
	db "LIGHTNING@"
	db 2,7
	dw 540
	TX_FAR _JolteonDexEntry
	db "@"

VaporeonDexEntry:
	db "BUBBLE JET@"
	db 3,3
	dw 640
	TX_FAR _VaporeonDexEntry
	db "@"

MachopDexEntry:
	db "SUPERPOWER@"
	db 2,7
	dw 430
	TX_FAR _MachopDexEntry
	db "@"

ZubatDexEntry:
	db "BAT@"
	db 2,7
	dw 170
	TX_FAR _ZubatDexEntry
	db "@"

EkansDexEntry:
	db "SNAKE@"
	db 6,7
	dw 150
	TX_FAR _EkansDexEntry
	db "@"

ParasDexEntry:
	db "MUSHROOM@"
	db 1,0
	dw 120
	TX_FAR _ParasDexEntry
	db "@"

PoliwhirlDexEntry:
	db "TADPOLE@"
	db 3,3
	dw 440
	TX_FAR _PoliwhirlDexEntry
	db "@"

PoliwrathDexEntry:
	db "TADPOLE@"
	db 4,3
	dw 1190
	TX_FAR _PoliwrathDexEntry
	db "@"

WeedleDexEntry:
	db "HAIRY BUG@"
	db 1,0
	dw 70
	TX_FAR _WeedleDexEntry
	db "@"

KakunaDexEntry:
	db "COCOON@"
	db 2,0
	dw 220
	TX_FAR _KakunaDexEntry
	db "@"

BeedrillDexEntry:
	db "POISON BEE@"
	db 3,3
	dw 650
	TX_FAR _BeedrillDexEntry
	db "@"

DodrioDexEntry:
	db "TRIPLEBIRD@"
	db 5,11
	dw 1880
	TX_FAR _DodrioDexEntry
	db "@"

PrimeapeDexEntry:
	db "PIG MONKEY@"
	db 3,3
	dw 710
	TX_FAR _PrimeapeDexEntry
	db "@"

DugtrioDexEntry:
	db "MOLE@"
	db 2,4
	dw 730
	TX_FAR _DugtrioDexEntry
	db "@"

VenomothDexEntry:
	db "POISONMOTH@"
	db 4,11
	dw 280
	TX_FAR _VenomothDexEntry
	db "@"

DewgongDexEntry:
	db "SEA LION@"
	db 5,7
	dw 2650
	TX_FAR _DewgongDexEntry
	db "@"

CaterpieDexEntry:
	db "WORM@"
	db 1,0
	dw 60
	TX_FAR _CaterpieDexEntry
	db "@"

MetapodDexEntry:
	db "COCOON@"
	db 2,4
	dw 220
	TX_FAR _MetapodDexEntry
	db "@"

ButterfreeDexEntry:
	db "BUTTERFLY@"
	db 3,7
	dw 710
	TX_FAR _ButterfreeDexEntry
	db "@"

MachampDexEntry:
	db "SUPERPOWER@"
	db 5,3
	dw 2870
	TX_FAR _MachampDexEntry
	db "@"

GolduckDexEntry:
	db "DUCK@"
	db 5,7
	dw 1690
	TX_FAR _GolduckDexEntry
	db "@"

HypnoDexEntry:
	db "HYPNOSIS@"
	db 5,3
	dw 1670
	TX_FAR _HypnoDexEntry
	db "@"

GolbatDexEntry:
	db "BAT@"
	db 5,3
	dw 1210
	TX_FAR _GolbatDexEntry
	db "@"

MewtwoDexEntry:
	db "GENETIC@"
	db 6,7
	dw 2690
	TX_FAR _MewtwoDexEntry
	db "@"

SnorlaxDexEntry:
	db "SLEEPING@"
	db 6,11
	dw 10140
	TX_FAR _SnorlaxDexEntry
	db "@"

MagikarpDexEntry:
	db "FISH@"
	db 2,11
	dw 220
	TX_FAR _MagikarpDexEntry
	db "@"

MukDexEntry:
	db "SLUDGE@"
	db 3,11
	dw 660
	TX_FAR _MukDexEntry
	db "@"

KinglerDexEntry:
	db "PINCER@"
	db 4,3
	dw 1320
	TX_FAR _KinglerDexEntry
	db "@"

CloysterDexEntry:
	db "BIVALVE@"
	db 4,11
	dw 2920
	TX_FAR _CloysterDexEntry
	db "@"

ElectrodeDexEntry:
	db "BALL@"
	db 3,11
	dw 1470
	TX_FAR _ElectrodeDexEntry
	db "@"

ClefableDexEntry:
	db "FAIRY@"
	db 4,3
	dw 880
	TX_FAR _ClefableDexEntry
	db "@"

WeezingDexEntry:
	db "POISON GAS@"
	db 3,11
	dw 210
	TX_FAR _WeezingDexEntry
	db "@"

PersianDexEntry:
	db "CLASSY CAT@"
	db 3,3
	dw 710
	TX_FAR _PersianDexEntry
	db "@"

MarowakDexEntry:
	db "BONEKEEPER@"
	db 3,3
	dw 990
	TX_FAR _MarowakDexEntry
	db "@"

HaunterDexEntry:
	db "GAS@"
	db 5,3
	dw 2
	TX_FAR _HaunterDexEntry
	db "@"

AbraDexEntry:
	db "PSI@"
	db 2,11
	dw 430
	TX_FAR _AbraDexEntry
	db "@"

AlakazamDexEntry:
	db "PSI@"
	db 4,11
	dw 1060
	TX_FAR _AlakazamDexEntry
	db "@"

PidgeottoDexEntry:
	db "BIRD@"
	db 3,7
	dw 660
	TX_FAR _PidgeottoDexEntry
	db "@"

PidgeotDexEntry:
	db "BIRD@"
	db 4,11
	dw 870
	TX_FAR _PidgeotDexEntry
	db "@"

StarmieDexEntry:
	db "MYSTERIOUS@"
	db 3,7
	dw 1760
	TX_FAR _StarmieDexEntry
	db "@"

BulbasaurDexEntry:
	db "SEED@"
	db 2,4
	dw 150
	TX_FAR _BulbasaurDexEntry
	db "@"

VenusaurDexEntry:
	db "SEED@"
	db 6,7
	dw 2210
	TX_FAR _VenusaurDexEntry
	db "@"

TentacruelDexEntry:
	db "JELLYFISH@"
	db 5,3
	dw 1210
	TX_FAR _TentacruelDexEntry
	db "@"

GoldeenDexEntry:
	db "GOLDFISH@"
	db 2,0
	dw 330
	TX_FAR _GoldeenDexEntry
	db "@"

SeakingDexEntry:
	db "GOLDFISH@"
	db 4,3
	dw 860
	TX_FAR _SeakingDexEntry
	db "@"

PonytaDexEntry:
	db "FIRE HORSE@"
	db 3,3
	dw 660
	TX_FAR _PonytaDexEntry
	db "@"

RapidashDexEntry:
	db "FIRE HORSE@"
	db 5,7
	dw 2090
	TX_FAR _RapidashDexEntry
	db "@"

RattataDexEntry:
	db "RAT@"
	db 1,0
	dw 80
	TX_FAR _RattataDexEntry
	db "@"

RaticateDexEntry:
	db "RAT@"
	db 2,4
	dw 410
	TX_FAR _RaticateDexEntry
	db "@"

NidorinoDexEntry:
	db "POISON PIN@"
	db 2,11
	dw 430
	TX_FAR _NidorinoDexEntry
	db "@"

NidorinaDexEntry:
	db "POISON PIN@"
	db 2,7
	dw 440
	TX_FAR _NidorinaDexEntry
	db "@"

GeodudeDexEntry:
	db "ROCK@"
	db 1,4
	dw 440
	TX_FAR _GeodudeDexEntry
	db "@"

PorygonDexEntry:
	db "VIRTUAL@"
	db 2,7
	dw 800
	TX_FAR _PorygonDexEntry
	db "@"

AerodactylDexEntry:
	db "FOSSIL@"
	db 5,11
	dw 1300
	TX_FAR _AerodactylDexEntry
	db "@"

MagnemiteDexEntry:
	db "MAGNET@"
	db 1,0
	dw 130
	TX_FAR _MagnemiteDexEntry
	db "@"

CharmanderDexEntry:
	db "LIZARD@"
	db 2,0
	dw 190
	TX_FAR _CharmanderDexEntry
	db "@"

SquirtleDexEntry:
	db "TINYTURTLE@"
	db 1,8
	dw 200
	TX_FAR _SquirtleDexEntry
	db "@"

CharmeleonDexEntry:
	db "FLAME@"
	db 3,7
	dw 420
	TX_FAR _CharmeleonDexEntry
	db "@"

WartortleDexEntry:
	db "TURTLE@"
	db 3,3
	dw 500
	TX_FAR _WartortleDexEntry
	db "@"

CharizardDexEntry:
	db "FLAME@"
	db 5,7
	dw 2000
	TX_FAR _CharizardDexEntry
	db "@"

OddishDexEntry:
	db "WEED@"
	db 1,8
	dw 120
	TX_FAR _OddishDexEntry
	db "@"

GloomDexEntry:
	db "WEED@"
	db 2,7
	dw 190
	TX_FAR _GloomDexEntry
	db "@"

VileplumeDexEntry:
	db "FLOWER@"
	db 3,11
	dw 410
	TX_FAR _VileplumeDexEntry
	db "@"

BellsproutDexEntry:
	db "FLOWER@"
	db 2,4
	dw 90
	TX_FAR _BellsproutDexEntry
	db "@"

WeepinbellDexEntry:
	db "FLYCATCHER@"
	db 3,3
	dw 140
	TX_FAR _WeepinbellDexEntry
	db "@"

VictreebelDexEntry:
	db "FLYCATCHER@"
	db 5,7
	dw 340
	TX_FAR _VictreebelDexEntry
	db "@"

MissingNoDexEntry:
	db "???@"
	db 10 ; 1.0 m
	db 100 ; 10.0 kg
	db 0,"コメント さくせいちゅう@" ; コメント作成中 (Comment to be written)

PokedexToIndex:
	; converts the Pokédex number at $D11E to an index
	push bc
	push hl
	ld a,[$D11E]
	ld b,a
	ld c,0
	ld hl,PokedexOrder

.loop\@ ; go through the list until we find an entry with a matching dex number
	inc c
	ld a,[hli]
	cp b
	jr nz,.loop\@

	ld a,c
	ld [$D11E],a
	pop hl
	pop bc
	ret

IndexToPokedex:
	; converts the indexédex number at $D11E to a Pokédex number
	push bc
	push hl
	ld a,[$D11E]
	dec a
	ld hl,PokedexOrder
	ld b,0
	ld c,a
	add hl,bc
	ld a,[hl]
	ld [$D11E],a
	pop hl
	pop bc
	ret

PokedexOrder: ; 5024
	db DEX_RHYDON
	db DEX_KANGASKHAN
	db DEX_NIDORAN_M
	db DEX_CLEFAIRY
	db DEX_SPEAROW
	db DEX_VOLTORB
	db DEX_NIDOKING
	db DEX_SLOWBRO
	db DEX_IVYSAUR
	db DEX_EXEGGUTOR
	db DEX_LICKITUNG
	db DEX_EXEGGCUTE
	db DEX_GRIMER
	db DEX_GENGAR
	db DEX_NIDORAN_F
	db DEX_NIDOQUEEN
	db DEX_CUBONE
	db DEX_RHYHORN
	db DEX_LAPRAS
	db DEX_ARCANINE
	db DEX_MEW
	db DEX_GYARADOS
	db DEX_SHELLDER
	db DEX_TENTACOOL
	db DEX_GASTLY
	db DEX_SCYTHER
	db DEX_STARYU
	db DEX_BLASTOISE
	db DEX_PINSIR
	db DEX_TANGELA
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_GROWLITHE
	db DEX_ONIX
	db DEX_FEAROW
	db DEX_PIDGEY
	db DEX_SLOWPOKE
	db DEX_KADABRA
	db DEX_GRAVELER
	db DEX_CHANSEY
	db DEX_MACHOKE
	db DEX_MR_MIME
	db DEX_HITMONLEE
	db DEX_HITMONCHAN
	db DEX_ARBOK
	db DEX_PARASECT
	db DEX_PSYDUCK
	db DEX_DROWZEE
	db DEX_GOLEM
	db 0 ; MISSINGNO.
	db DEX_MAGMAR
	db 0 ; MISSINGNO.
	db DEX_ELECTABUZZ
	db DEX_MAGNETON
	db DEX_KOFFING
	db 0 ; MISSINGNO.
	db DEX_MANKEY
	db DEX_SEEL
	db DEX_DIGLETT
	db DEX_TAUROS
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_FARFETCH_D
	db DEX_VENONAT
	db DEX_DRAGONITE
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_DODUO
	db DEX_POLIWAG
	db DEX_JYNX
	db DEX_MOLTRES
	db DEX_ARTICUNO
	db DEX_ZAPDOS
	db DEX_DITTO
	db DEX_MEOWTH
	db DEX_KRABBY
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_VULPIX
	db DEX_NINETALES
	db DEX_PIKACHU
	db DEX_RAICHU
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_DRATINI
	db DEX_DRAGONAIR
	db DEX_KABUTO
	db DEX_KABUTOPS
	db DEX_HORSEA
	db DEX_SEADRA
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_SANDSHREW
	db DEX_SANDSLASH
	db DEX_OMANYTE
	db DEX_OMASTAR
	db DEX_JIGGLYPUFF
	db DEX_WIGGLYTUFF
	db DEX_EEVEE
	db DEX_FLAREON
	db DEX_JOLTEON
	db DEX_VAPOREON
	db DEX_MACHOP
	db DEX_ZUBAT
	db DEX_EKANS
	db DEX_PARAS
	db DEX_POLIWHIRL
	db DEX_POLIWRATH
	db DEX_WEEDLE
	db DEX_KAKUNA
	db DEX_BEEDRILL
	db 0 ; MISSINGNO.
	db DEX_DODRIO
	db DEX_PRIMEAPE
	db DEX_DUGTRIO
	db DEX_VENOMOTH
	db DEX_DEWGONG
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_CATERPIE
	db DEX_METAPOD
	db DEX_BUTTERFREE
	db DEX_MACHAMP
	db 0 ; MISSINGNO.
	db DEX_GOLDUCK
	db DEX_HYPNO
	db DEX_GOLBAT
	db DEX_MEWTWO
	db DEX_SNORLAX
	db DEX_MAGIKARP
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_MUK
	db 0 ; MISSINGNO.
	db DEX_KINGLER
	db DEX_CLOYSTER
	db 0 ; MISSINGNO.
	db DEX_ELECTRODE
	db DEX_CLEFABLE
	db DEX_WEEZING
	db DEX_PERSIAN
	db DEX_MAROWAK
	db 0 ; MISSINGNO.
	db DEX_HAUNTER
	db DEX_ABRA
	db DEX_ALAKAZAM
	db DEX_PIDGEOTTO
	db DEX_PIDGEOT
	db DEX_STARMIE
	db DEX_BULBASAUR
	db DEX_VENUSAUR
	db DEX_TENTACRUEL
	db 0 ; MISSINGNO.
	db DEX_GOLDEEN
	db DEX_SEAKING
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_PONYTA
	db DEX_RAPIDASH
	db DEX_RATTATA
	db DEX_RATICATE
	db DEX_NIDORINO
	db DEX_NIDORINA
	db DEX_GEODUDE
	db DEX_PORYGON
	db DEX_AERODACTYL
	db 0 ; MISSINGNO.
	db DEX_MAGNEMITE
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_CHARMANDER
	db DEX_SQUIRTLE
	db DEX_CHARMELEON
	db DEX_WARTORTLE
	db DEX_CHARIZARD
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db 0 ; MISSINGNO.
	db DEX_ODDISH
	db DEX_GLOOM
	db DEX_VILEPLUME
	db DEX_BELLSPROUT
	db DEX_WEEPINBELL
	db DEX_VICTREEBEL
INCBIN "baserom.gbc",$410E2,$2769 - $10E2

; XXX what do these do
	FuncCoord 5,0
	ld hl,Coord
	ld de,OTString67E5
	call PlaceString
	ld a,[$CD3D]
	ld [$D11E],a
	ld a,$3A
	call Predef
	ld hl,$C3A9
	ld de,$D11E
	ld bc,$8103
	call $3C5F
	FuncCoord 5,2
	ld hl,Coord
	ld de,$CF4B
	call PlaceString
	FuncCoord 8,4
	ld hl,Coord
	ld de,$CD41
	call PlaceString
	ld hl,$C420
	ld de,$CD4C
	ld bc,$8205
	jp $3C5F

	FuncCoord 5,10
	ld hl,Coord
	ld de,OTString67E5
	call PlaceString
	ld a,[$CD3E]
	ld [$D11E],a
	ld a,$3A
	call Predef
	ld hl,$C471
	ld de,$D11E
	ld bc,$8103
	call $3C5F
	FuncCoord 5,12
	ld hl,Coord
	ld de,$CD6D
	call PlaceString
	FuncCoord 8,14
	ld hl,Coord
	ld de,$CD4E
	call PlaceString
	ld hl,$C4E8
	ld de,$CD59
	ld bc,$8205
	jp $3C5F

OTString67E5: ; 67E5
	db "──",$74,$F2,$4E
	db $4E
	db "OT/",$4E
	db $73,"№",$F2,"@"

SECTION "bank11",DATA,BANK[$11]

LavenderTown_h: ; 0x44000 to 0x4402d (45 bytes) (bank=11) (id=4)
    db $00 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw LavenderTownBlocks, $410e, $410b ; blocks, texts, scripts
    db NORTH | SOUTH | WEST ; connections

    ; connections data

	db ROUTE_10
    dw $44a0, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $47, $00 ; alignments (y, x)
    dw $c929 ; window

	db ROUTE_12
    dw $4710, $c7ab ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_8
    dw $41e1, $c718 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $00, $3b ; alignments (y, x)
    dw $c72a ; window

    ; end connection data

    dw $402d ; objects

LavenderTownObject: ; 0x4402d (size=88)
    db $2c ; border tile

    db $6 ; warps
    db $5, $3, $0, LAVENDER_POKECENTER
    db $5, $e, $0, POKEMONTOWER_1
    db $9, $7, $0, LAVENDER_HOUSE_1
    db $d, $f, $0, LAVENDER_MART
    db $d, $3, $0, LAVENDER_HOUSE_2
    db $d, $7, $0, NAME_RATERS_HOUSE

    db $6 ; signs
    db $9, $b, $4 ; LavenderTownText4
    db $3, $9, $5 ; LavenderTownText5
    db $d, $10, $6 ; LavenderTownText6
    db $5, $4, $7 ; LavenderTownText7
    db $9, $5, $8 ; LavenderTownText8
    db $7, $11, $9 ; LavenderTownText9

    db $3 ; people
    db SPRITE_LITTLE_GIRL, $9 + 4, $f + 4, $fe, $0, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $a + 4, $9 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $7 + 4, $8 + 4, $fe, $2, $3 ; person

    ; warp-to
    EVENT_DISP $a, $5, $3 ; LAVENDER_POKECENTER
    EVENT_DISP $a, $5, $e ; POKEMONTOWER_1
    EVENT_DISP $a, $9, $7 ; LAVENDER_HOUSE_1
    EVENT_DISP $a, $d, $f ; LAVENDER_MART
    EVENT_DISP $a, $d, $3 ; LAVENDER_HOUSE_2
    EVENT_DISP $a, $d, $7 ; NAME_RATERS_HOUSE

LavenderTownBlocks: ; 90
    INCBIN "maps/lavendertown.blk"

ViridianPokeCenterBlocks: ; 28
    INCBIN "maps/viridianpokecenter.blk"

SafariZoneRestHouse1Blocks: ; 16
    INCBIN "maps/safarizoneresthouse1.blk"

INCBIN "baserom.gbc",$4410b,$44120 - $4410b
LavenderTownText1: ; 0x44120
    db $08 ; asm
    ld hl, $413c
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    ld hl, $4146
    jr nz, .asm_40831 ; 0x44131
    ld hl, $4141
.asm_40831 ; 0x44136
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$4413c,$f

LavenderTownText2: ; 0x4414b
    TX_FAR _LavenderTownText2
    db $50

LavenderTownText3: ; 0x44150
    TX_FAR _LavenderTownText3
    db $50

LavenderTownText4: ; 0x44155
    TX_FAR _LavenderTownText4
    db $50

LavenderTownText5: ; 0x4415a
    TX_FAR _LavenderTownText5
    db $50

LavenderTownText8: ; 0x4415f
    TX_FAR _LavenderTownText8
    db $50

LavenderTownText9: ; 0x44164
    TX_FAR _LavenderTownText9
    db $50

INCBIN "baserom.gbc",$44169,$e8

ViridianPokecenter_h: ; 0x44251 to 0x4425d (12 bytes) (bank=11) (id=41)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $40df, $4263, $425d ; blocks, texts, scripts
    db $00 ; connections

    dw $4277 ; objects

INCBIN "baserom.gbc",$4425d,$4426b - $4425d

ViridianPokeCenterText1: ; 0x4426b
    db $ff
    TX_FAR _ViridianPokeCenterText1

INCBIN "baserom.gbc",$44270,$44271 - $44270

ViridianPokeCenterText3: ; 0x44271
    TX_FAR _ViridianPokeCenterText3
    db $50

;XXX wtf?
db $f6

ViridianPokeCenterObject: ; 0x44277 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_GENTLEMAN, $5 + 4, $a + 4, $fe, $1, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $3 + 4, $4 + 4, $ff, $ff, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

Mansion1_h: ; 0x442a3 to 0x442af (12 bytes) (bank=11) (id=165)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw $43fe, $432c, $42af ; blocks, texts, scripts
    db $00 ; connections

    dw $43a4 ; objects

INCBIN "baserom.gbc",$442af,$44341 - $442af
Mansion1Text1: ; 0x44341
    db $08 ; asm
    ld hl, $4334
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$4434b,$59
Mansion1Object: ; 0x443a4 (size=90)
    db $2e ; border tile

    db $8 ; warps
    db $1b, $4, $0, $ff
    db $1b, $5, $0, $ff
    db $1b, $6, $0, $ff
    db $1b, $7, $0, $ff
    db $a, $5, $0, MANSION_2
    db $17, $15, $0, MANSION_4
    db $1b, $1a, $0, $ff
    db $1b, $1b, $0, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_OAK_AIDE, $11 + 4, $11 + 4, $ff, $d2, $41, SCIENTIST + $C8, $4 ; trainer
	db SPRITE_BALL, $3 + 4, $e + 4, $ff, $ff, $82, ESCAPE_ROPE ; item
	db SPRITE_BALL, $15 + 4, $12 + 4, $ff, $ff, $83, CARBOS ; item

    ; warp-to
    EVENT_DISP $f, $1b, $4
    EVENT_DISP $f, $1b, $5
    EVENT_DISP $f, $1b, $6
    EVENT_DISP $f, $1b, $7
    EVENT_DISP $f, $a, $5 ; MANSION_2
    EVENT_DISP $f, $17, $15 ; MANSION_4
    EVENT_DISP $f, $1b, $1a
    EVENT_DISP $f, $1b, $1b

INCBIN "baserom.gbc",$443fe,$d2

RockTunnel1_h: ; 0x444d0 to 0x444dc (12 bytes) (bank=11) (id=82)
    db $11 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw RockTunnel1Blocks, $44f5, $44dc ; blocks, texts, scripts
    db $00 ; connections

    dw $45f6 ; objects

INCBIN "baserom.gbc",$444dc,$4455a - $444dc

RockTunnel1Text1: ; 0x4455a
    db $8
    ld hl, $4505
    jr asm_0c916 ; 0x4455e $22

RockTunnel1Text2:
    db $8
    ld hl, $4511
    jr asm_0c916 ; 0x44564 $1c

RockTunnel1Text3:
    db $8
    ld hl, $451d
    jr asm_0c916 ; 0x4456a $16

RockTunnel1Text4:
    db $8
    ld hl, $4529
    jr asm_0c916 ; 0x44570 $10

RockTunnel1Text5:
    db $8
    ld hl, $4535
    jr asm_0c916 ; 0x44576 $a

RockTunnel1Text6:
    db $8
    ld hl, $4541
    jr asm_0c916 ; 0x4457c $4

RockTunnel1Text7:
    db $8
    ld hl, $454d
asm_0c916: ; 0x44582
    call $31cc
    jp $24d7

INCBIN "baserom.gbc",$44588,$69

RockTunnel1Text8: ; 0x445f1
    TX_FAR _RockTunnel1Text8
    db $50

RockTunnel1Object: ; 0x445f6 (size=127)
    db $3 ; border tile

    db $8 ; warps
    db $3, $f, $1, $ff
    db $0, $f, $1, $ff
    db $21, $f, $2, $ff
    db $23, $f, $2, $ff
    db $3, $25, $0, ROCK_TUNNEL_2
    db $3, $5, $1, ROCK_TUNNEL_2
    db $b, $11, $2, ROCK_TUNNEL_2
    db $11, $25, $3, ROCK_TUNNEL_2

    db $1 ; signs
    db $1d, $b, $8 ; RockTunnel1Text8

    db $7 ; people
    db SPRITE_HIKER, $5 + 4, $7 + 4, $ff, $d0, $41, HIKER + $C8, $c ; trainer
    db SPRITE_HIKER, $10 + 4, $5 + 4, $ff, $d0, $42, HIKER + $C8, $d ; trainer
    db SPRITE_HIKER, $f + 4, $11 + 4, $ff, $d2, $43, HIKER + $C8, $e ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $17 + 4, $ff, $d2, $44, POKEMANIAC + $C8, $7 ; trainer
    db SPRITE_LASS, $15 + 4, $25 + 4, $ff, $d2, $45, JR__TRAINER_F + $C8, $11 ; trainer
    db SPRITE_LASS, $18 + 4, $16 + 4, $ff, $d0, $46, JR__TRAINER_F + $C8, $12 ; trainer
    db SPRITE_LASS, $18 + 4, $20 + 4, $ff, $d3, $47, JR__TRAINER_F + $C8, $13 ; trainer

    ; warp-to
    EVENT_DISP $14, $3, $f
    EVENT_DISP $14, $0, $f
    EVENT_DISP $14, $21, $f
    EVENT_DISP $14, $23, $f
    EVENT_DISP $14, $3, $25 ; ROCK_TUNNEL_2
    EVENT_DISP $14, $3, $5 ; ROCK_TUNNEL_2
    EVENT_DISP $14, $b, $11 ; ROCK_TUNNEL_2
    EVENT_DISP $14, $11, $25 ; ROCK_TUNNEL_2

RockTunnel1Blocks: ; 360
    INCBIN "maps/rocktunnel1.blk"

SeafoamIslands1_h: ; 0x447dd to 0x447e9 (12 bytes) (bank=11) (id=192)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SeafoamIslands1Blocks, $484b, $47e9 ; blocks, texts, scripts
    db $00 ; connections

    dw $484f ; objects

INCBIN "baserom.gbc",$447e9,$4484b - $447e9
SeafoamIslands1Texts: ; 0x4484b
    dw SeafoamIslands1Text1, SeafoamIslands1Text2
SeafoamIslands1Object: ; 0x4484f (size=72)
    db $7d ; border tile

    db $7 ; warps
    db $11, $4, $0, $ff
    db $11, $5, $0, $ff
    db $11, $1a, $1, $ff
    db $11, $1b, $1, $ff
    db $5, $7, $1, SEAFOAM_ISLANDS_2
    db $3, $19, $6, SEAFOAM_ISLANDS_2
    db $f, $17, $4, SEAFOAM_ISLANDS_2

    db $0 ; signs

    db $2 ; people
    db SPRITE_BOULDER, $a + 4, $12 + 4, $ff, $10, $1 ; person
    db SPRITE_BOULDER, $7 + 4, $1a + 4, $ff, $10, $2 ; person

    ; warp-to
    EVENT_DISP $f, $11, $4
    EVENT_DISP $f, $11, $5
    EVENT_DISP $f, $11, $1a
    EVENT_DISP $f, $11, $1b
    EVENT_DISP $f, $5, $7 ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $3, $19 ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $f, $17 ; SEAFOAM_ISLANDS_2

INCBIN "baserom.gbc",$44897,$8

SeafoamIslands1Blocks: ; 135
    INCBIN "maps/seafoamislands1.blk"

SSAnne3_h: ; 0x44926 to 0x44932 (12 bytes) (bank=11) (id=97)
    db $0d ; tileset
    db $03, $0a ; dimensions (y, x)
    dw SSAnne3Blocks, $4935, $4932 ; blocks, texts, scripts
    db $00 ; connections

    dw $493c ; objects

INCBIN "baserom.gbc",$44932,$4493c - $44932
SSAnne3Object: ; 0x4493c (size=26)
    db $c ; border tile

    db $2 ; warps
    db $3, $0, $0, SS_ANNE_5
    db $3, $13, $7, SS_ANNE_2

    db $0 ; signs

    db $1 ; people
    db SPRITE_SAILOR, $3 + 4, $9 + 4, $fe, $2, $1 ; person

    ; warp-to
    EVENT_DISP $a, $3, $0 ; SS_ANNE_5
    EVENT_DISP $a, $3, $13 ; SS_ANNE_2

SSAnne3Blocks: ; 30
    INCBIN "maps/ssanne3.blk"

VictoryRoad3_h: ; 0x44974 to 0x44980 (12 bytes) (bank=11) (id=198)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw VictoryRoad3Blocks, $4a24, $4980 ; blocks, texts, scripts
    db $00 ; connections

    dw $4acd ; objects

INCBIN "baserom.gbc",$44980,$44a69 - $44980
VictoryRoad3Text1: ; 0x44a69
    db $08 ; asm
    ld hl, $4a38
    call LoadTrainerHeader
    jp $24d7

VictoryRoad3Text2: ; 0x44a73
    db $08 ; asm
    ld hl, $4a44
    call LoadTrainerHeader
    jp $24d7

VictoryRoad3Text3: ; 0x44a7d
    db $08 ; asm
    ld hl, $4a50
    call LoadTrainerHeader
    jp $24d7

VictoryRoad3Text4: ; 0x44a87
    db $08 ; asm
    ld hl, $4a5c
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$44a91,$3c
VictoryRoad3Object: ; 0x44acd (size=106)
    db $7d ; border tile

    db $4 ; warps
    db $7, $17, $3, VICTORY_ROAD_2
    db $8, $1a, $5, VICTORY_ROAD_2
    db $f, $1b, $4, VICTORY_ROAD_2
    db $0, $2, $6, VICTORY_ROAD_2

    db $0 ; signs

    db $a ; people
    db SPRITE_BLACK_HAIR_BOY_1, $5 + 4, $1c + 4, $ff, $d2, $41, COOLTRAINER_M + $C8, $2 ; trainer
    db SPRITE_LASS, $d + 4, $7 + 4, $ff, $d3, $42, COOLTRAINER_F + $C8, $2 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $e + 4, $6 + 4, $ff, $d2, $43, COOLTRAINER_M + $C8, $3 ; trainer
    db SPRITE_LASS, $3 + 4, $d + 4, $ff, $d3, $44, COOLTRAINER_F + $C8, $3 ; trainer
	db SPRITE_BALL, $5 + 4, $1a + 4, $ff, $ff, $85, MAX_REVIVE ; item
	db SPRITE_BALL, $7 + 4, $7 + 4, $ff, $ff, $86, TM_47 ; item
    db SPRITE_BOULDER, $3 + 4, $16 + 4, $ff, $10, $7 ; person
    db SPRITE_BOULDER, $c + 4, $d + 4, $ff, $10, $8 ; person
    db SPRITE_BOULDER, $a + 4, $18 + 4, $ff, $10, $9 ; person
    db SPRITE_BOULDER, $f + 4, $16 + 4, $ff, $10, $a ; person

    ; warp-to
    EVENT_DISP $f, $7, $17 ; VICTORY_ROAD_2
    EVENT_DISP $f, $8, $1a ; VICTORY_ROAD_2
    EVENT_DISP $f, $f, $1b ; VICTORY_ROAD_2
    EVENT_DISP $f, $0, $2 ; VICTORY_ROAD_2

VictoryRoad3Blocks: ; 135
    INCBIN "maps/victoryroad3.blk"

RocketHideout1_h: ; 0x44bbe to 0x44bca (12 bytes) (bank=11) (id=199)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw RocketHideout1Blocks, $4c14, $4bca ; blocks, texts, scripts
    db $00 ; connections

    dw $4ce7 ; objects

INCBIN "baserom.gbc",$44bca,$44c5f - $44bca
RocketHideout1Text1: ; 0x44c5f
    db $08 ; asm
    ld hl, $4c22
    call LoadTrainerHeader
    jp $24d7

RocketHideout1Text2: ; 0x44c69
    db $08 ; asm
    ld hl, $4c2e
    call LoadTrainerHeader
    jp $24d7

RocketHideout1Text3: ; 0x44c73
    db $08 ; asm
    ld hl, $4c3a
    call LoadTrainerHeader
    jp $24d7

RocketHideout1Text4: ; 0x44c7d
    db $08 ; asm
    ld hl, $4c46
    call LoadTrainerHeader
    jp $24d7

RocketHideout1Text5: ; 0x44c87
    db $08 ; asm
    ld hl, $4c52
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$44c91,$56
RocketHideout1Object: ; 0x44ce7 (size=98)
    db $2e ; border tile

    db $5 ; warps
    db $2, $17, $0, ROCKET_HIDEOUT_2
    db $2, $15, $2, GAME_CORNER
    db $13, $18, $0, ROCKET_HIDEOUT_ELEVATOR
    db $18, $15, $3, ROCKET_HIDEOUT_2
    db $13, $19, $1, ROCKET_HIDEOUT_ELEVATOR

    db $0 ; signs

    db $7 ; people
    db SPRITE_ROCKET, $8 + 4, $1a + 4, $ff, $d2, $41, ROCKET + $C8, $8 ; trainer
    db SPRITE_ROCKET, $6 + 4, $c + 4, $ff, $d3, $42, ROCKET + $C8, $9 ; trainer
    db SPRITE_ROCKET, $11 + 4, $12 + 4, $ff, $d0, $43, ROCKET + $C8, $a ; trainer
    db SPRITE_ROCKET, $19 + 4, $f + 4, $ff, $d3, $44, ROCKET + $C8, $b ; trainer
    db SPRITE_ROCKET, $12 + 4, $1c + 4, $ff, $d2, $45, ROCKET + $C8, $c ; trainer
	db SPRITE_BALL, $e + 4, $b + 4, $ff, $ff, $86, ESCAPE_ROPE ; item
	db SPRITE_BALL, $11 + 4, $9 + 4, $ff, $ff, $87, HYPER_POTION ; item

    ; warp-to
    EVENT_DISP $f, $2, $17 ; ROCKET_HIDEOUT_2
    EVENT_DISP $f, $2, $15 ; GAME_CORNER
    EVENT_DISP $f, $13, $18 ; ROCKET_HIDEOUT_ELEVATOR
    EVENT_DISP $f, $18, $15 ; ROCKET_HIDEOUT_2
    EVENT_DISP $f, $13, $19 ; ROCKET_HIDEOUT_ELEVATOR

RocketHideout1Blocks: ; 210
    INCBIN "maps/rockethideout1.blk"

RocketHideout2_h: ; 0x44e1b to 0x44e27 (12 bytes) (bank=11) (id=200)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw RocketHideout2Blocks, $50c7, $4e27 ; blocks, texts, scripts
    db $00 ; connections

    dw $50f7 ; objects

INCBIN "baserom.gbc",$44e27,$450de - $44e27
RocketHideout2Text1: ; 0x450de
    db $08 ; asm
    ld hl, $50d1
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$450e8,$f
RocketHideout2Object: ; 0x450f7 (size=80)
    db $2e ; border tile

    db $5 ; warps
    db $8, $1b, $0, ROCKET_HIDEOUT_1
    db $8, $15, $0, ROCKET_HIDEOUT_3
    db $13, $18, $0, ROCKET_HIDEOUT_ELEVATOR
    db $16, $15, $3, ROCKET_HIDEOUT_1
    db $13, $19, $1, ROCKET_HIDEOUT_ELEVATOR

    db $0 ; signs

    db $5 ; people
    db SPRITE_ROCKET, $c + 4, $14 + 4, $ff, $d0, $41, ROCKET + $C8, $d ; trainer
	db SPRITE_BALL, $b + 4, $1 + 4, $ff, $ff, $82, MOON_STONE ; item
	db SPRITE_BALL, $8 + 4, $10 + 4, $ff, $ff, $83, NUGGET ; item
	db SPRITE_BALL, $c + 4, $6 + 4, $ff, $ff, $84, TM_07 ; item
	db SPRITE_BALL, $15 + 4, $3 + 4, $ff, $ff, $85, SUPER_POTION ; item

    ; warp-to
    EVENT_DISP $f, $8, $1b ; ROCKET_HIDEOUT_1
    EVENT_DISP $f, $8, $15 ; ROCKET_HIDEOUT_3
    EVENT_DISP $f, $13, $18 ; ROCKET_HIDEOUT_ELEVATOR
    EVENT_DISP $f, $16, $15 ; ROCKET_HIDEOUT_1
    EVENT_DISP $f, $13, $19 ; ROCKET_HIDEOUT_ELEVATOR

RocketHideout2Blocks: ; 210
    INCBIN "maps/rockethideout2.blk"

RocketHideout3_h: ; 0x45219 to 0x45225 (12 bytes) (bank=11) (id=201)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw RocketHideout3Blocks, $52fa, $5225 ; blocks, texts, scripts
    db $00 ; connections

    dw $534d ; objects

INCBIN "baserom.gbc",$45225,$4531b - $45225
RocketHideout3Text1: ; 0x4531b
    db $08 ; asm
    ld hl, $5302
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$45325,$45334 - $45325
RocketHideout3Text2: ; 0x45334
    db $08 ; asm
    ld hl, $530e
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$4533e,$f
RocketHideout3Object: ; 0x4534d (size=50)
    db $2e ; border tile

    db $2 ; warps
    db $6, $19, $1, ROCKET_HIDEOUT_2
    db $12, $13, $0, ROCKET_HIDEOUT_4

    db $0 ; signs

    db $4 ; people
    db SPRITE_ROCKET, $16 + 4, $a + 4, $ff, $d3, $41, ROCKET + $C8, $e ; trainer
    db SPRITE_ROCKET, $c + 4, $1a + 4, $ff, $d1, $42, ROCKET + $C8, $f ; trainer
	db SPRITE_BALL, $11 + 4, $1a + 4, $ff, $ff, $83, TM_10 ; item
	db SPRITE_BALL, $e + 4, $14 + 4, $ff, $ff, $84, RARE_CANDY ; item

    ; warp-to
    EVENT_DISP $f, $6, $19 ; ROCKET_HIDEOUT_2
    EVENT_DISP $f, $12, $13 ; ROCKET_HIDEOUT_4

RocketHideout3Blocks: ; 210
    INCBIN "maps/rockethideout3.blk"

RocketHideout4_h: ; 0x45451 to 0x4545d (12 bytes) (bank=11) (id=202)
    db $16 ; tileset
    db $0c, $0f ; dimensions (y, x)
    dw RocketHideout4Blocks, $5501, $545d ; blocks, texts, scripts
    db $00 ; connections

    dw $55f1 ; objects

INCBIN "baserom.gbc",$4545d,$4553a - $4545d
RocketHideout4Text1: ; 0x4553a
    db $08 ; asm
    ld a, [$d81b]
    bit 7, a
    jp nz, $5571
    ld hl, $557a
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $557f
    ld de, $557f
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    xor a
    ldh [$b4], a
    ld a, $3
    ld [$d634], a
    ld [$da39], a
    jr .asm_209f0 ; 0x4556f
    ld hl, $5584
    call PrintText
.asm_209f0 ; 0x45577
    jp $24d7

INCBIN "baserom.gbc",$4557a,$45589 - $4557a
RocketHideout4Text2: ; 0x45589
    db $08 ; asm
    ld hl, $5515
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$45593,$455a2 - $45593
RocketHideout4Text3: ; 0x455a2
    db $08 ; asm
    ld hl, $5521
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$455ac,$455bb - $455ac
RocketHideout4Text4: ; 0x455bb
    db $08 ; asm
    ld hl, $552d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$455c5,$2c
RocketHideout4Object: ; 0x455f1 (size=95)
    db $2e ; border tile

    db $3 ; warps
    db $a, $13, $1, ROCKET_HIDEOUT_3
    db $f, $18, $0, ROCKET_HIDEOUT_ELEVATOR
    db $f, $19, $1, ROCKET_HIDEOUT_ELEVATOR

    db $0 ; signs

    db $9 ; people
    db SPRITE_GIOVANNI, $3 + 4, $19 + 4, $ff, $d0, $41, GIOVANNI + $C8, $1 ; trainer
    db SPRITE_ROCKET, $c + 4, $17 + 4, $ff, $d0, $42, ROCKET + $C8, $10 ; trainer
    db SPRITE_ROCKET, $c + 4, $1a + 4, $ff, $d0, $43, ROCKET + $C8, $11 ; trainer
    db SPRITE_ROCKET, $2 + 4, $b + 4, $ff, $d0, $44, ROCKET + $C8, $12 ; trainer
	db SPRITE_BALL, $c + 4, $a + 4, $ff, $ff, $85, HP_UP ; item
	db SPRITE_BALL, $4 + 4, $9 + 4, $ff, $ff, $86, TM_02 ; item
	db SPRITE_BALL, $14 + 4, $c + 4, $ff, $ff, $87, IRON ; item
	db SPRITE_BALL, $2 + 4, $19 + 4, $ff, $ff, $88, SILPH_SCOPE ; item
	db SPRITE_BALL, $2 + 4, $a + 4, $ff, $ff, $89, LIFT_KEY ; item

    ; warp-to
    EVENT_DISP $f, $a, $13 ; ROCKET_HIDEOUT_3
    EVENT_DISP $f, $f, $18 ; ROCKET_HIDEOUT_ELEVATOR
    EVENT_DISP $f, $f, $19 ; ROCKET_HIDEOUT_ELEVATOR

RocketHideout4Blocks: ; 180
    INCBIN "maps/rockethideout4.blk"

RocketHideoutElevator_h: ; 0x45704 to 0x45710 (12 bytes) (bank=11) (id=203)
    db $12 ; tileset
    db $04, $03 ; dimensions (y, x)
    dw RocketHideoutElevatorBlocks, $576b, $5710 ; blocks, texts, scripts
    db $00 ; connections

    dw $5791 ; objects

INCBIN "baserom.gbc",$45710,$4576d - $45710
RocketHideoutElevatorText1: ; 0x4576d
    db $08 ; asm
	ld b,LIFT_KEY
    call $3493
    jr z, .asm_8d8f0 ; 0x45773
    call $5741
    ld hl, $5759
    ld a, $61
    call Predef
    jr .asm_46c43 ; 0x45780
.asm_8d8f0 ; 0x45782
    ld hl, $578b
    call PrintText
.asm_46c43 ; 0x45788
    jp $24d7

INCBIN "baserom.gbc",$4578b,$6
RocketHideoutElevatorObject: ; 0x45791 (size=23)
    db $f ; border tile

    db $2 ; warps
    db $1, $2, $2, ROCKET_HIDEOUT_1
    db $1, $3, $4, ROCKET_HIDEOUT_1

    db $1 ; signs
    db $1, $1, $1 ; RocketHideoutElevatorText1

    db $0 ; people

    ; warp-to
    EVENT_DISP $3, $1, $2 ; ROCKET_HIDEOUT_1
    EVENT_DISP $3, $1, $3 ; ROCKET_HIDEOUT_1

RocketHideoutElevatorBlocks: ; 12
    INCBIN "maps/rockethideoutelevator.blk"

SilphCoElevator_h: ; 0x457b4 to 0x457c0 (12 bytes) (bank=11) (id=236)
    db $12 ; tileset
    db $02, $02 ; dimensions (y, x)
    dw SilphCoElevatorBlocks, $5833, $57c0 ; blocks, texts, scripts
    db $00 ; connections

    dw $5844 ; objects

INCBIN "baserom.gbc",$457c0,$45835 - $457c0
SilphCoElevatorText1: ; 0x45835
    db $08 ; asm
    call $57f1
    ld hl, $5811
    ld a, $61
    call Predef
    jp $24d7

SilphCoElevatorObject: ; 0x45844 (size=23)
    db $f ; border tile

    db $2 ; warps
    db $3, $1, $0, $ed
    db $3, $2, $0, $ed

    db $1 ; signs
    db $0, $3, $1 ; SilphCoElevatorText1

    db $0 ; people

    ; warp-to
    EVENT_DISP $2, $3, $1
    EVENT_DISP $2, $3, $2

SilphCoElevatorBlocks: ; 4
    INCBIN "maps/silphcoelevator.blk"

SafariZoneEast_h: ; 0x4585f to 0x4586b (12 bytes) (bank=11) (id=217)
    db $03 ; tileset
    db $0d, $0f ; dimensions (y, x)
    dw SafariZoneEastBlocks, $586e, $586b ; blocks, texts, scripts
    db $00 ; connections

    dw $588b ; objects

INCBIN "baserom.gbc",$4586b,$4587c - $4586b

SafariZoneEastText5: ; 0x4587c
    TX_FAR _SafariZoneEastText5
    db $50

SafariZoneEastText6: ; 0x45881
    TX_FAR _SafariZoneEastText6
    db $50

SafariZoneEastText7: ; 0x45886
    TX_FAR _SafariZoneEastText7
    db $50

SafariZoneEastObject: ; 0x4588b (size=81)
    db $0 ; border tile

    db $5 ; warps
    db $4, $0, $6, SAFARI_ZONE_NORTH
    db $5, $0, $7, SAFARI_ZONE_NORTH
    db $16, $0, $6, SAFARI_ZONE_CENTER
    db $17, $0, $6, SAFARI_ZONE_CENTER
    db $9, $19, $0, SAFARI_ZONE_REST_HOUSE_3

    db $3 ; signs
    db $a, $1a, $5 ; SafariZoneEastText5
    db $4, $6, $6 ; SafariZoneEastText6
    db $17, $5, $7 ; SafariZoneEastText7

    db $4 ; people
	db SPRITE_BALL, $a + 4, $15 + 4, $ff, $ff, $81, FULL_RESTORE ; item
	db SPRITE_BALL, $7 + 4, $3 + 4, $ff, $ff, $82, MAX_POTION ; item
	db SPRITE_BALL, $d + 4, $14 + 4, $ff, $ff, $83, CARBOS ; item
	db SPRITE_BALL, $c + 4, $f + 4, $ff, $ff, $84, TM_37 ; item

    ; warp-to
    EVENT_DISP $f, $4, $0 ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $5, $0 ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $16, $0 ; SAFARI_ZONE_CENTER
    EVENT_DISP $f, $17, $0 ; SAFARI_ZONE_CENTER
    EVENT_DISP $f, $9, $19 ; SAFARI_ZONE_REST_HOUSE_3

SafariZoneEastBlocks: ; 195
    INCBIN "maps/safarizoneeast.blk"

SafariZoneNorth_h: ; 0x4599f to 0x459ab (12 bytes) (bank=11) (id=218)
    db $03 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw SafariZoneNorthBlocks, $59ae, $59ab ; blocks, texts, scripts
    db $00 ; connections

    dw $59d5 ; objects

INCBIN "baserom.gbc",$459ab,$459bc - $459ab

SafariZoneNorthText3: ; 0x459bc
    TX_FAR _SafariZoneNorthText3
    db $50

SafariZoneNorthText4: ; 0x459c1
    TX_FAR _SafariZoneNorthText4
    db $50

SafariZoneNorthText5: ; 0x459c6
    TX_FAR _SafariZoneNorthText5
    db $50

SafariZoneNorthText6: ; 0x459cb
    TX_FAR _SafariZoneNorthText6
    db $50

SafariZoneNorthText7: ; 0x459d0
    TX_FAR _SafariZoneNorthText7
    db $50

SafariZoneNorthObject: ; 0x459d5 (size=105)
    db $0 ; border tile

    db $9 ; warps
    db $23, $2, $0, SAFARI_ZONE_WEST
    db $23, $3, $1, SAFARI_ZONE_WEST
    db $23, $8, $2, SAFARI_ZONE_WEST
    db $23, $9, $3, SAFARI_ZONE_WEST
    db $23, $14, $4, SAFARI_ZONE_CENTER
    db $23, $15, $5, SAFARI_ZONE_CENTER
    db $1e, $27, $0, SAFARI_ZONE_EAST
    db $1f, $27, $1, SAFARI_ZONE_EAST
    db $3, $23, $0, SAFARI_ZONE_REST_HOUSE_4

    db $5 ; signs
    db $4, $24, $3 ; SafariZoneNorthText3
    db $19, $4, $4 ; SafariZoneNorthText4
    db $1f, $d, $5 ; SafariZoneNorthText5
    db $21, $13, $6 ; SafariZoneNorthText6
    db $1c, $1a, $7 ; SafariZoneNorthText7

    db $2 ; people
	db SPRITE_BALL, $1 + 4, $19 + 4, $ff, $ff, $81, PROTEIN ; item
	db SPRITE_BALL, $7 + 4, $13 + 4, $ff, $ff, $82, TM_40 ; item

    ; warp-to
    EVENT_DISP $14, $23, $2 ; SAFARI_ZONE_WEST
    EVENT_DISP $14, $23, $3 ; SAFARI_ZONE_WEST
    EVENT_DISP $14, $23, $8 ; SAFARI_ZONE_WEST
    EVENT_DISP $14, $23, $9 ; SAFARI_ZONE_WEST
    EVENT_DISP $14, $23, $14 ; SAFARI_ZONE_CENTER
    EVENT_DISP $14, $23, $15 ; SAFARI_ZONE_CENTER
    EVENT_DISP $14, $1e, $27 ; SAFARI_ZONE_EAST
    EVENT_DISP $14, $1f, $27 ; SAFARI_ZONE_EAST
    EVENT_DISP $14, $3, $23 ; SAFARI_ZONE_REST_HOUSE_4

SafariZoneNorthBlocks: ; 360
    INCBIN "maps/safarizonenorth.blk"

SafariZoneCenter_h: ; 0x45ba6 to 0x45bb2 (12 bytes) (bank=11) (id=220)
    db $03 ; tileset
    db $0d, $0f ; dimensions (y, x)
    dw SafariZoneCenterBlocks, $5bb5, $5bb2 ; blocks, texts, scripts
    db $00 ; connections

    dw $5bc5 ; objects

INCBIN "baserom.gbc",$45bb2,$45bbb - $45bb2

SafariZoneCenterText2: ; 0x45bbb
    TX_FAR _SafariZoneCenterText2
    db $50

SafariZoneCenterText3: ; 0x45bc0
    TX_FAR _SafariZoneCenterText3
    db $50

SafariZoneCenterObject: ; 0x45bc5 (size=89)
    db $0 ; border tile

    db $9 ; warps
    db $19, $e, $2, SAFARIZONEENTRANCE
    db $19, $f, $3, SAFARIZONEENTRANCE
    db $a, $0, $4, SAFARI_ZONE_WEST
    db $b, $0, $5, SAFARI_ZONE_WEST
    db $0, $e, $4, SAFARI_ZONE_NORTH
    db $0, $f, $5, SAFARI_ZONE_NORTH
    db $a, $1d, $2, SAFARI_ZONE_EAST
    db $b, $1d, $3, SAFARI_ZONE_EAST
    db $13, $11, $0, SAFARI_ZONE_REST_HOUSE_1

    db $2 ; signs
    db $14, $12, $2 ; SafariZoneCenterText2
    db $16, $e, $3 ; SafariZoneCenterText3

    db $1 ; people
	db SPRITE_BALL, $a + 4, $e + 4, $ff, $ff, $81, NUGGET ; item

    ; warp-to
    EVENT_DISP $f, $19, $e ; SAFARIZONEENTRANCE
    EVENT_DISP $f, $19, $f ; SAFARIZONEENTRANCE
    EVENT_DISP $f, $a, $0 ; SAFARI_ZONE_WEST
    EVENT_DISP $f, $b, $0 ; SAFARI_ZONE_WEST
    EVENT_DISP $f, $0, $e ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $0, $f ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $a, $1d ; SAFARI_ZONE_EAST
    EVENT_DISP $f, $b, $1d ; SAFARI_ZONE_EAST
    EVENT_DISP $f, $13, $11 ; SAFARI_ZONE_REST_HOUSE_1

SafariZoneCenterBlocks: ; 195
    INCBIN "maps/safarizonecenter.blk"

SafariZoneRestHouse1_h: ; 0x45ce1 to 0x45ced (12 bytes) (bank=11) (id=221)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw SafariZoneRestHouse1Blocks, $5cf0, $5ced ; blocks, texts, scripts
    db $00 ; connections

    dw $5cfe ; objects

INCBIN "baserom.gbc",$45ced,$45cf0 - $45ced
SafariZoneRestHouse1Texts: ; 0x45cf0
    dw SafariZoneRestHouse1Text1, SafariZoneRestHouse1Text2

SafariZoneRestHouse1Text1: ; 0x45cf4
    TX_FAR _SafariZoneRestHouse1Text1
    db $50

SafariZoneRestHouse1Text2: ; 0x45cf9
    TX_FAR _SafariZoneRestHouse1Text2
    db $50

SafariZoneRestHouse1Object: ; 0x45cfe (size=32)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $8, SAFARI_ZONE_CENTER
    db $7, $3, $8, SAFARI_ZONE_CENTER

    db $0 ; signs

    db $2 ; people
    db SPRITE_GIRL, $2 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_OAK_AIDE, $4 + 4, $1 + 4, $fe, $1, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; SAFARI_ZONE_CENTER
    EVENT_DISP $4, $7, $3 ; SAFARI_ZONE_CENTER

SafariZoneRestHouse2_h: ; 0x45d1e to 0x45d2a (12 bytes) (bank=11) (id=223)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40fb, $5d2e, $5d2a ; blocks, texts, scripts
    db $00 ; connections

    dw $5d43 ; objects

INCBIN "baserom.gbc",$45d2a,$45d2e - $45d2a
SafariZoneRestHouse2Texts: ; 0x45d2e
    dw SafariZoneRestHouse2Text1, SafariZoneRestHouse2Text2, SafariZoneRestHouse2Text3

SafariZoneRestHouse2Text1: ; 0x45d34
    TX_FAR _SafariZoneRestHouse2Text1
    db $50

SafariZoneRestHouse2Text2: ; 0x45d39
    TX_FAR _SafariZoneRestHouse2Text2
    db $50

SafariZoneRestHouse2Text3: ; 0x45d3e
    TX_FAR _SafariZoneRestHouse2Text3
    db $50

SafariZoneRestHouse2Object: ; 0x45d43 (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $7, SAFARI_ZONE_WEST
    db $7, $3, $7, SAFARI_ZONE_WEST

    db $0 ; signs

    db $3 ; people
    db SPRITE_OAK_AIDE, $4 + 4, $4 + 4, $fe, $0, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $2 + 4, $0 + 4, $ff, $d3, $2 ; person
    db SPRITE_ERIKA, $2 + 4, $6 + 4, $ff, $d0, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; SAFARI_ZONE_WEST
    EVENT_DISP $4, $7, $3 ; SAFARI_ZONE_WEST

SafariZoneRestHouse3_h: ; 0x45d69 to 0x45d75 (12 bytes) (bank=11) (id=224)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40fb, $5d79, $5d75 ; blocks, texts, scripts
    db $00 ; connections

    dw $5d8e ; objects

INCBIN "baserom.gbc",$45d75,$45d79 - $45d75
SafariZoneRestHouse3Texts: ; 0x45d79
    dw SafariZoneRestHouse3Text1, SafariZoneRestHouse3Text2, SafariZoneRestHouse3Text3

SafariZoneRestHouse3Text1: ; 0x45d7f
    TX_FAR _SafariZoneRestHouse3Text1
    db $50

SafariZoneRestHouse3Text2: ; 0x45d84
    TX_FAR _SafariZoneRestHouse3Text2
    db $50

SafariZoneRestHouse3Text3: ; 0x45d89
    TX_FAR _SafariZoneRestHouse3Text3
    db $50

SafariZoneRestHouse3Object: ; 0x45d8e (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $4, SAFARI_ZONE_EAST
    db $7, $3, $4, SAFARI_ZONE_EAST

    db $0 ; signs

    db $3 ; people
    db SPRITE_OAK_AIDE, $3 + 4, $1 + 4, $fe, $1, $1 ; person
    db SPRITE_ROCKER, $2 + 4, $4 + 4, $ff, $ff, $2 ; person
    db SPRITE_LAPRAS_GIVER, $2 + 4, $5 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; SAFARI_ZONE_EAST
    EVENT_DISP $4, $7, $3 ; SAFARI_ZONE_EAST

SafariZoneRestHouse4_h: ; 0x45db4 to 0x45dc0 (12 bytes) (bank=11) (id=225)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40fb, $5dc4, $5dc0 ; blocks, texts, scripts
    db $00 ; connections

    dw $5dd9 ; objects

INCBIN "baserom.gbc",$45dc0,$45dc4 - $45dc0
SafariZoneRestHouse4Texts: ; 0x45dc4
    dw SafariZoneRestHouse4Text1, SafariZoneRestHouse4Text2, SafariZoneRestHouse4Text3

SafariZoneRestHouse4Text1: ; 0x45dca
    TX_FAR _SafariZoneRestHouse4Text1
    db $50

SafariZoneRestHouse4Text2: ; 0x45dcf
    TX_FAR _SafariZoneRestHouse4Text2
    db $50

SafariZoneRestHouse4Text3: ; 0x45dd4
    TX_FAR _SafariZoneRestHouse4Text3
    db $50

SafariZoneRestHouse4Object: ; 0x45dd9 (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $8, SAFARI_ZONE_NORTH
    db $7, $3, $8, SAFARI_ZONE_NORTH

    db $0 ; signs

    db $3 ; people
    db SPRITE_OAK_AIDE, $3 + 4, $6 + 4, $fe, $2, $1 ; person
    db SPRITE_WHITE_PLAYER, $4 + 4, $3 + 4, $ff, $ff, $2 ; person
    db SPRITE_GENTLEMAN, $5 + 4, $1 + 4, $fe, $1, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; SAFARI_ZONE_NORTH
    EVENT_DISP $4, $7, $3 ; SAFARI_ZONE_NORTH

UnknownDungeon2_h: ; 0x45dff to 0x45e0b (12 bytes) (bank=11) (id=226)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw UnknownDungeon2Blocks, $5e0e, $5e0b ; blocks, texts, scripts
    db $00 ; connections

    dw $5e14 ; objects

INCBIN "baserom.gbc",$45e0b,$45e14 - $45e0b
UnknownDungeon2Object: ; 0x45e14 (size=73)
    db $7d ; border tile

    db $6 ; warps
    db $1, $1d, $2, UNKNOWN_DUNGEON_1
    db $6, $16, $3, UNKNOWN_DUNGEON_1
    db $7, $13, $4, UNKNOWN_DUNGEON_1
    db $1, $9, $5, UNKNOWN_DUNGEON_1
    db $3, $1, $6, UNKNOWN_DUNGEON_1
    db $b, $3, $7, UNKNOWN_DUNGEON_1

    db $0 ; signs

    db $3 ; people
	db SPRITE_BALL, $9 + 4, $1d + 4, $ff, $ff, $81, PP_UP ; item
	db SPRITE_BALL, $f + 4, $4 + 4, $ff, $ff, $82, ULTRA_BALL ; item
	db SPRITE_BALL, $6 + 4, $d + 4, $ff, $ff, $83, FULL_RESTORE ; item

    ; warp-to
    EVENT_DISP $f, $1, $1d ; UNKNOWN_DUNGEON_1
    EVENT_DISP $f, $6, $16 ; UNKNOWN_DUNGEON_1
    EVENT_DISP $f, $7, $13 ; UNKNOWN_DUNGEON_1
    EVENT_DISP $f, $1, $9 ; UNKNOWN_DUNGEON_1
    EVENT_DISP $f, $3, $1 ; UNKNOWN_DUNGEON_1
    EVENT_DISP $f, $b, $3 ; UNKNOWN_DUNGEON_1

UnknownDungeon2Blocks: ; 135
    INCBIN "maps/unknowndungeon2.blk"

UnknownDungeon3_h: ; 0x45ee4 to 0x45ef0 (12 bytes) (bank=11) (id=227)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw UnknownDungeon3Blocks, $5f09, $5ef0 ; blocks, texts, scripts
    db $00 ; connections

    dw $5f36 ; objects

INCBIN "baserom.gbc",$45ef0,$45f1c - $45ef0
UnknownDungeon3Text1: ; 0x45f1c
    db $08 ; asm
    ld hl, $5f0f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$45f26,$10
UnknownDungeon3Object: ; 0x45f36 (size=34)
    db $7d ; border tile

    db $1 ; warps
    db $6, $3, $8, UNKNOWN_DUNGEON_1

    db $0 ; signs

    db $3 ; people
    db SPRITE_SLOWBRO, $d + 4, $1b + 4, $ff, $d0, $41, MEWTWO, $46 ; trainer
	db SPRITE_BALL, $9 + 4, $10 + 4, $ff, $ff, $82, ULTRA_BALL ; item
	db SPRITE_BALL, $1 + 4, $12 + 4, $ff, $ff, $83, MAX_REVIVE ; item

    ; warp-to
    EVENT_DISP $f, $6, $3 ; UNKNOWN_DUNGEON_1

UnknownDungeon3Blocks: ; 135
    INCBIN "maps/unknowndungeon3.blk"

RockTunnel2_h: ; 0x45fdf to 0x45feb (12 bytes) (bank=11) (id=232)
    db $11 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw RockTunnel2Blocks, $6004, $5feb ; blocks, texts, scripts
    db $00 ; connections

    dw $613d ; objects

INCBIN "baserom.gbc",$45feb,$46075 - $45feb
RockTunnel2Text1: ; 0x46075
    db $08 ; asm
    ld hl, $6014
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text2: ; 0x4607f
    db $08 ; asm
    ld hl, $6020
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text3: ; 0x46089
    db $08 ; asm
    ld hl, $602c
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text4: ; 0x46093
    db $08 ; asm
    ld hl, $6038
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text5: ; 0x4609d
    db $08 ; asm
    ld hl, $6044
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text6: ; 0x460a7
    db $08 ; asm
    ld hl, $6050
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text7: ; 0x460b1
    db $08 ; asm
    ld hl, $605c
    call LoadTrainerHeader
    jp $24d7

RockTunnel2Text8: ; 0x460bb
    db $08 ; asm
    ld hl, $6068
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$460c5,$78
RockTunnel2Object: ; 0x4613d (size=100)
    db $3 ; border tile

    db $4 ; warps
    db $19, $21, $4, ROCK_TUNNEL_1
    db $3, $1b, $5, ROCK_TUNNEL_1
    db $b, $17, $6, ROCK_TUNNEL_1
    db $3, $3, $7, ROCK_TUNNEL_1

    db $0 ; signs

    db $8 ; people
    db SPRITE_LASS, $d + 4, $b + 4, $ff, $d0, $41, JR__TRAINER_F + $C8, $9 ; trainer
    db SPRITE_HIKER, $a + 4, $6 + 4, $ff, $d0, $42, HIKER + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $3 + 4, $ff, $d0, $43, POKEMANIAC + $C8, $3 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $15 + 4, $14 + 4, $ff, $d3, $44, POKEMANIAC + $C8, $4 ; trainer
    db SPRITE_HIKER, $a + 4, $1e + 4, $ff, $d0, $45, HIKER + $C8, $a ; trainer
    db SPRITE_LASS, $1c + 4, $e + 4, $ff, $d3, $46, JR__TRAINER_F + $C8, $a ; trainer
    db SPRITE_HIKER, $5 + 4, $21 + 4, $ff, $d3, $47, HIKER + $C8, $b ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $1e + 4, $1a + 4, $ff, $d0, $48, POKEMANIAC + $C8, $5 ; trainer

    ; warp-to
    EVENT_DISP $14, $19, $21 ; ROCK_TUNNEL_1
    EVENT_DISP $14, $3, $1b ; ROCK_TUNNEL_1
    EVENT_DISP $14, $b, $17 ; ROCK_TUNNEL_1
    EVENT_DISP $14, $3, $3 ; ROCK_TUNNEL_1

RockTunnel2Blocks: ; 360
    INCBIN "maps/rocktunnel2.blk"

SeafoamIslands2_h: ; 0x46309 to 0x46315 (12 bytes) (bank=11) (id=159)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SeafoamIslands2Blocks, $6372, $6315 ; blocks, texts, scripts
    db $00 ; connections

    dw $6376 ; objects

INCBIN "baserom.gbc",$46315,$46372 - $46315
SeafoamIslands2Texts: ; 0x46372
    dw SeafoamIslands2Text1, SeafoamIslands2Text2
SeafoamIslands2Object: ; 0x46376 (size=72)
    db $7d ; border tile

    db $7 ; warps
    db $2, $4, $0, SEAFOAM_ISLANDS_3
    db $5, $7, $4, SEAFOAM_ISLANDS_1
    db $7, $d, $2, SEAFOAM_ISLANDS_3
    db $f, $13, $3, SEAFOAM_ISLANDS_3
    db $f, $17, $6, SEAFOAM_ISLANDS_1
    db $b, $19, $5, SEAFOAM_ISLANDS_3
    db $3, $19, $5, SEAFOAM_ISLANDS_1

    db $0 ; signs

    db $2 ; people
    db SPRITE_BOULDER, $6 + 4, $11 + 4, $ff, $10, $1 ; person
    db SPRITE_BOULDER, $6 + 4, $16 + 4, $ff, $10, $2 ; person

    ; warp-to
    EVENT_DISP $f, $2, $4 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $5, $7 ; SEAFOAM_ISLANDS_1
    EVENT_DISP $f, $7, $d ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $f, $13 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $f, $17 ; SEAFOAM_ISLANDS_1
    EVENT_DISP $f, $b, $19 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $3, $19 ; SEAFOAM_ISLANDS_1

SeafoamIslands2Blocks: ; 135
    INCBIN "maps/seafoamislands2.blk"

SeafoamIslands3_h: ; 0x46445 to 0x46451 (12 bytes) (bank=11) (id=160)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SeafoamIslands3Blocks, $64ae, $6451 ; blocks, texts, scripts
    db $00 ; connections

    dw $64b2 ; objects

INCBIN "baserom.gbc",$46451,$464ae - $46451
SeafoamIslands3Texts: ; 0x464ae
    dw SeafoamIslands3Text1, SeafoamIslands3Text2
SeafoamIslands3Object: ; 0x464b2 (size=72)
    db $7d ; border tile

    db $7 ; warps
    db $3, $5, $0, SEAFOAM_ISLANDS_2
    db $d, $5, $0, SEAFOAM_ISLANDS_4
    db $7, $d, $2, SEAFOAM_ISLANDS_2
    db $f, $13, $3, SEAFOAM_ISLANDS_2
    db $3, $19, $3, SEAFOAM_ISLANDS_4
    db $b, $19, $5, SEAFOAM_ISLANDS_2
    db $e, $19, $4, SEAFOAM_ISLANDS_4

    db $0 ; signs

    db $2 ; people
    db SPRITE_BOULDER, $6 + 4, $12 + 4, $ff, $10, $1 ; person
    db SPRITE_BOULDER, $6 + 4, $17 + 4, $ff, $10, $2 ; person

    ; warp-to
    EVENT_DISP $f, $3, $5 ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $d, $5 ; SEAFOAM_ISLANDS_4
    EVENT_DISP $f, $7, $d ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $f, $13 ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $3, $19 ; SEAFOAM_ISLANDS_4
    EVENT_DISP $f, $b, $19 ; SEAFOAM_ISLANDS_2
    EVENT_DISP $f, $e, $19 ; SEAFOAM_ISLANDS_4

SeafoamIslands3Blocks: ; 135
    INCBIN "maps/seafoamislands3.blk"

SeafoamIslands4_h: ; 0x46581 to 0x4658d (12 bytes) (bank=11) (id=161)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SeafoamIslands4Blocks, $669a, $658d ; blocks, texts, scripts
    db $00 ; connections

    dw $66a6 ; objects

INCBIN "baserom.gbc",$4658d,$4669a - $4658d
SeafoamIslands4Texts: ; 0x4669a
    dw SeafoamIslands4Text1, SeafoamIslands4Text2, SeafoamIslands4Text3, SeafoamIslands4Text4, SeafoamIslands4Text5, SeafoamIslands4Text6
SeafoamIslands4Object: ; 0x466a6 (size=96)
    db $7d ; border tile

    db $7 ; warps
    db $c, $5, $1, SEAFOAM_ISLANDS_3
    db $6, $8, $2, SEAFOAM_ISLANDS_5
    db $4, $19, $3, SEAFOAM_ISLANDS_5
    db $3, $19, $4, SEAFOAM_ISLANDS_3
    db $e, $19, $6, SEAFOAM_ISLANDS_3
    db $11, $14, $0, SEAFOAM_ISLANDS_5
    db $11, $15, $1, SEAFOAM_ISLANDS_5

    db $0 ; signs

    db $6 ; people
    db SPRITE_BOULDER, $e + 4, $5 + 4, $ff, $10, $1 ; person
    db SPRITE_BOULDER, $f + 4, $3 + 4, $ff, $10, $2 ; person
    db SPRITE_BOULDER, $e + 4, $8 + 4, $ff, $10, $3 ; person
    db SPRITE_BOULDER, $e + 4, $9 + 4, $ff, $10, $4 ; person
    db SPRITE_BOULDER, $6 + 4, $12 + 4, $ff, $ff, $5 ; person
    db SPRITE_BOULDER, $6 + 4, $13 + 4, $ff, $ff, $6 ; person

    ; warp-to
    EVENT_DISP $f, $c, $5 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $6, $8 ; SEAFOAM_ISLANDS_5
    EVENT_DISP $f, $4, $19 ; SEAFOAM_ISLANDS_5
    EVENT_DISP $f, $3, $19 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $e, $19 ; SEAFOAM_ISLANDS_3
    EVENT_DISP $f, $11, $14 ; SEAFOAM_ISLANDS_5
    EVENT_DISP $f, $11, $15 ; SEAFOAM_ISLANDS_5

SeafoamIslands4Blocks: ; 135
    INCBIN "maps/seafoamislands4.blk"

SeafoamIslands5_h: ; 0x4678d to 0x46799 (12 bytes) (bank=11) (id=162)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SeafoamIslands5Blocks, $687c, $6799 ; blocks, texts, scripts
    db $00 ; connections

    dw $68bc ; objects

INCBIN "baserom.gbc",$46799,$46893 - $46799
SeafoamIslands5Text3: ; 0x46893
    db $08 ; asm
    ld hl, $6886
    call LoadTrainerHeader
    ld a, $4
    ld [$d668], a
    jp $24d7

INCBIN "baserom.gbc",$468a2,$10

SeafoamIslands5Text4: ; 0x468b2
    TX_FAR _SeafoamIslands5Text4
    db $50

SeafoamIslands5Text5: ; 0x468b7
    TX_FAR _SeafoamIslands5Text5
    db $50

SeafoamIslands5Object: ; 0x468bc (size=62)
    db $7d ; border tile

    db $4 ; warps
    db $11, $14, $5, SEAFOAM_ISLANDS_4
    db $11, $15, $6, SEAFOAM_ISLANDS_4
    db $7, $b, $1, SEAFOAM_ISLANDS_4
    db $4, $19, $2, SEAFOAM_ISLANDS_4

    db $2 ; signs
    db $f, $9, $4 ; SeafoamIslands5Text4
    db $1, $17, $5 ; SeafoamIslands5Text5

    db $3 ; people
    db SPRITE_BOULDER, $f + 4, $4 + 4, $ff, $ff, $1 ; person
    db SPRITE_BOULDER, $f + 4, $5 + 4, $ff, $ff, $2 ; person
    db SPRITE_BIRD, $1 + 4, $6 + 4, $ff, $d0, $43, ARTICUNO, $32 ; trainer

    ; warp-to
    EVENT_DISP $f, $11, $14 ; SEAFOAM_ISLANDS_4
    EVENT_DISP $f, $11, $15 ; SEAFOAM_ISLANDS_4
    EVENT_DISP $f, $7, $b ; SEAFOAM_ISLANDS_4
    EVENT_DISP $f, $4, $19 ; SEAFOAM_ISLANDS_4

SeafoamIslands5Blocks: ; 135
    INCBIN "maps/seafoamislands5.blk"
INCBIN "baserom.gbc",$46981,$167f

SECTION "bank12",DATA,BANK[$12]

Route7_h: ; 0x48000 to 0x48022 (34 bytes) (bank=12) (id=18)
    db $00 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw Route7Blocks, $4155, $4152 ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db CELADON_CITY
    dw $410e, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $19 ; bigness, width
    db $08, $31 ; alignments (y, x)
    dw $c720 ; window

	db SAFFRON_CITY
    dw $4aac, $c6f5 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $00 ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $4022 ; objects

Route7Object: ; 0x48022 (size=47)
    db $f ; border tile

    db $5 ; warps
    db $9, $12, $2, ROUTE_7_GATE
    db $a, $12, $3, ROUTE_7_GATE
    db $9, $b, $0, ROUTE_7_GATE
    db $a, $b, $1, ROUTE_7_GATE
    db $d, $5, $0, PATH_ENTRANCE_ROUTE_7

    db $1 ; signs
    db $d, $3, $1 ; Route7Text1

    db $0 ; people

    ; warp-to
    EVENT_DISP $a, $9, $12 ; ROUTE_7_GATE
    EVENT_DISP $a, $a, $12 ; ROUTE_7_GATE
    EVENT_DISP $a, $9, $b ; ROUTE_7_GATE
    EVENT_DISP $a, $a, $b ; ROUTE_7_GATE
    EVENT_DISP $a, $d, $5 ; PATH_ENTRANCE_ROUTE_7

Route7Blocks: ; 90
    INCBIN "maps/route7.blk"

MtMoonPokecenterBlocks: ; 28
    INCBIN "maps/mtmoonpokecenter.blk"

Route11GateBlocks: ; 20
    INCBIN "maps/route11gate.blk"

Route11GateUpstairsBlocks: ; 16
    INCBIN "maps/route11gateupstairs.blk"

INCBIN "baserom.gbc",$480eb,$71

RedsHouse1F_h: ; 415C
	db $01 ; tileset
	db $04,$04 ; dimensions
	dw RedsHouse1FBlocks,RedsHouse1FTexts,RedsHouse1FScript
	db 0 ; no connections
	dw RedsHouse1FObject

RedsHouse1FScript: ; 4168
	jp $3C3C

RedsHouse1FTexts: ; 416B
	dw RedsHouse1FText1,RedsHouse1FText2

RedsHouse1FText1: ; Mom
	db 8
	ld a,[$D72E]
	bit 3,a
	jr nz,.heal\@ ; if player has received a Pokémon from Oak, heal team
	ld hl,MomWakeUpText
	call PrintText
	jr .done\@
.heal\@
	call MomHealPokemon
.done\@
	jp $24D7

MomWakeUpText:
	TX_FAR _MomWakeUpText
	db "@"

MomHealPokemon:
	ld hl,MomHealText1
	call PrintText
	call GBFadeOut2
	call $3071
	ld a,7
	call Predef
	ld a,$E8
	ld [$C0EE],a
	call $23B1 ; play sound?
.next\@
	ld a,[$C026]
	cp $E8
	jr z,.next\@
	ld a,[$D35B]
	ld [$C0EE],a
	call $23B1
	call GBFadeIn2
	ld hl,MomHealText2
	jp PrintText

MomHealText1:
	TX_FAR _MomHealText1
	db "@"
MomHealText2:
	TX_FAR _MomHealText2
	db "@"

RedsHouse1FText2: ; TV
	db 8
	ld a,[$C109]
	cp 4
	ld hl,TVWrongSideText
	jr nz,.done\@ ; if player is not facing up
	ld hl,StandByMeText
.done\@
	call PrintText
	jp $24D7

StandByMeText:
	TX_FAR _StandByMeText
	db "@"

TVWrongSideText:
	TX_FAR _TVWrongSideText
	db "@"

RedsHouse1FObject:
	db $0A ; border tile

	db 3 ; warps
	db 7,2,0,$FF ; exit1
	db 7,3,0,$FF ; exit2
	db 1,7,0,$26 ; staircase

	db 1 ; signs
	db 1,3,2 ; TV

	db 1 ; people
	db $33,4+4,5+4,$FF,$D2,1 ; Mom

	; warp-to

	dw $C6EF + 4 + (4 + 6) * (3) + 1
	db 7,2

	dw $C6EF + 4 + (4 + 6) * (3) + 1
	db 7,3

	dw $C6EF + 4 + (4 + 6) * (0) + 3
	db 1,7

RedsHouse1FBlocks:
	INCBIN "maps/redshouse1f.blk"

CeladonMart3_h: ; 0x48219 to 0x48225 (12 bytes) (bank=12) (id=124)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMart3Blocks, $4228, $4225 ; blocks, texts, scripts
    db $00 ; connections

    dw $42c4 ; objects

INCBIN "baserom.gbc",$48225,$4824a - $48225
CeladonMart3Text1: ; 0x4824a
    db $08 ; asm
    ld a, [$d778]
    bit 7, a
    jr nz, .asm_a5463 ; 0x48250
    ld hl, $4278
    call PrintText
    ld bc,(TM_18 << 8) | 1
    call $3e2e
    jr nc, .asm_95f37 ; 0x4825e
    ld hl, $d778
    set 7, [hl]
    ld hl, $427d
    jr .asm_81359 ; 0x48268
.asm_95f37 ; 0x4826a
    ld hl, $4288
    jr .asm_81359 ; 0x4826d
.asm_a5463 ; 0x4826f
    ld hl, $4283
.asm_81359 ; 0x48272
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48278,$15

CeladonMart3Text2: ; 0x4828d
    TX_FAR _CeladonMart3Text2
    db $50

CeladonMart3Text3: ; 0x48292
    TX_FAR _CeladonMart3Text3
    db $50

CeladonMart3Text4: ; 0x48297
    TX_FAR _CeladonMart3Text4
    db $50

CeladonMart3Text5: ; 0x4829c
    TX_FAR _CeladonMart3Text5
    db $50

CeladonMart3Text6: ; 0x482a1
    TX_FAR _CeladonMart3Text6
    db $50

CeladonMart3Text7: ; 0x482a6
    TX_FAR _CeladonMart3Text7
    db $50

CeladonMart3Text9: ; 0x482ab
    TX_FAR _CeladonMart3Text9
    db $50

CeladonMart3Text11: ; 0x482b0
    TX_FAR _CeladonMart3Text11
    db $50

CeladonMart3Text13: ; 0x482b5
    TX_FAR _CeladonMart3Text13
    db $50

CeladonMart3Text14: ; 0x482ba
    TX_FAR _CeladonMart3Text14
    db $50

CeladonMart3Text15: ; 0x482bf
    TX_FAR _CeladonMart3Text15
    db $50

CeladonMart3Object: ; 0x482c4 (size=94)
    db $f ; border tile

    db $3 ; warps
    db $1, $c, $0, CELADON_MART_4
    db $1, $10, $1, CELADON_MART_2
    db $1, $1, $0, CELADON_MART_ELEVATOR

    db $c ; signs
    db $4, $2, $6 ; CeladonMart3Text6
    db $4, $3, $7 ; CeladonMart3Text7
    db $4, $5, $8 ; CeladonMart3Text8
    db $4, $6, $9 ; CeladonMart3Text9
    db $6, $2, $a ; CeladonMart3Text10
    db $6, $3, $b ; CeladonMart3Text11
    db $6, $5, $c ; CeladonMart3Text12
    db $6, $6, $d ; CeladonMart3Text13
    db $1, $e, $e ; CeladonMart3Text14
    db $1, $4, $f ; CeladonMart3Text15
    db $1, $6, $10 ; CeladonMart3Text16
    db $1, $a, $11 ; CeladonMart3Text17

    db $5 ; people
    db SPRITE_MART_GUY, $5 + 4, $10 + 4, $ff, $ff, $1 ; person
    db SPRITE_GAMEBOY_KID_COPY, $6 + 4, $b + 4, $ff, $d3, $2 ; person
    db SPRITE_GAMEBOY_KID_COPY, $2 + 4, $7 + 4, $ff, $d0, $3 ; person
    db SPRITE_GAMEBOY_KID_COPY, $2 + 4, $8 + 4, $ff, $d0, $4 ; person
    db SPRITE_YOUNG_BOY, $5 + 4, $2 + 4, $ff, $d1, $5 ; person

    ; warp-to
    EVENT_DISP $a, $1, $c ; CELADON_MART_4
    EVENT_DISP $a, $1, $10 ; CELADON_MART_2
    EVENT_DISP $a, $1, $1 ; CELADON_MART_ELEVATOR

CeladonMart3Blocks: ; 40
    INCBIN "maps/celadonmart3.blk"

CeladonMart4_h: ; 0x4834a to 0x48356 (12 bytes) (bank=12) (id=125)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMart4Blocks, $4359, $4356 ; blocks, texts, scripts
    db $00 ; connections

    dw $4370 ; objects

INCBIN "baserom.gbc",$48356,$48361 - $48356

CeladonMart4Text2: ; 0x48361
    TX_FAR _CeladonMart4Text2
    db $50

CeladonMart4Text3: ; 0x48366
    TX_FAR _CeladonMart4Text3
    db $50

CeladonMart4Text4: ; 0x4836b
    TX_FAR _CeladonMart4Text4
    db $50

CeladonMart4Object: ; 0x48370 (size=49)
    db $f ; border tile

    db $3 ; warps
    db $1, $c, $0, CELADON_MART_3
    db $1, $10, $1, CELADON_MART_5
    db $1, $1, $0, CELADON_MART_ELEVATOR

    db $1 ; signs
    db $1, $e, $4 ; CeladonMart4Text4

    db $3 ; people
    db SPRITE_MART_GUY, $7 + 4, $5 + 4, $ff, $ff, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $f + 4, $fe, $2, $2 ; person
    db SPRITE_BUG_CATCHER, $2 + 4, $5 + 4, $fe, $2, $3 ; person

    ; warp-to
    EVENT_DISP $a, $1, $c ; CELADON_MART_3
    EVENT_DISP $a, $1, $10 ; CELADON_MART_5
    EVENT_DISP $a, $1, $1 ; CELADON_MART_ELEVATOR

CeladonMart4Blocks: ; 40
    INCBIN "maps/celadonmart4.blk"

CeladonMartRoof_h: ; 0x483c9 to 0x483d5 (12 bytes) (bank=12) (id=126)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMartRoofBlocks, $455b, $43d5 ; blocks, texts, scripts
    db $00 ; connections

    dw $45a8 ; objects

INCBIN "baserom.gbc",$483d5,$48567 - $483d5

CeladonMartRoofText1: ; 0x48567
    TX_FAR _CeladonMartRoofText1
    db $50

CeladonMartRoofText2: ; 0x4856c
    db $08 ; asm
    call $43d8
    ld a, [$cd37]
    and a
    jr z, .asm_914b9 ; 0x48574
    ld a, $1
    ld [$cc3c], a
    ld hl, $459d
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_05aa4 ; 0x48588
    call $440c
    jr .asm_05aa4 ; 0x4858d
.asm_914b9 ; 0x4858f
    ld hl, $4598
    call PrintText
.asm_05aa4 ; 0x48595
    jp $24d7

INCBIN "baserom.gbc",$48598,$b

CeladonMartRoofText6: ; 0x485a3
    TX_FAR _CeladonMartRoofText6
    db $50

CeladonMartRoofObject: ; 0x485a8 (size=36)
    db $42 ; border tile

    db $1 ; warps
    db $2, $f, $0, CELADON_MART_5

    db $4 ; signs
    db $1, $a, $3 ; CeladonMartRoofText3
    db $1, $b, $4 ; CeladonMartRoofText4
    db $2, $c, $5 ; CeladonMartRoofText5
    db $2, $d, $6 ; CeladonMartRoofText6

    db $2 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $4 + 4, $a + 4, $ff, $d2, $1 ; person
    db SPRITE_LITTLE_GIRL, $5 + 4, $5 + 4, $fe, $0, $2 ; person

    ; warp-to
    EVENT_DISP $a, $2, $f ; CELADON_MART_5

CeladonMartRoofBlocks: ; 40
    INCBIN "maps/celadonmart5.blk"

CeladonMartElevator_h: ; 0x485f4 to 0x48600 (12 bytes) (bank=12) (id=127)
    db $12 ; tileset
    db $02, $02 ; dimensions (y, x)
    dw CeladonMartElevatorBlocks, $465c, $4600 ; blocks, texts, scripts
    db $00 ; connections

    dw $466d ; objects

INCBIN "baserom.gbc",$48600,$4865e - $48600
CeladonMartElevatorText1: ; 0x4865e
    db $08 ; asm
    call $4631
    ld hl, $464a
    ld a, $61
    call Predef
    jp $24d7

CeladonMartElevatorObject: ; 0x4866d (size=23)
    db $f ; border tile

    db $2 ; warps
    db $3, $1, $5, CELADON_MART_1
    db $3, $2, $5, CELADON_MART_1

    db $1 ; signs
    db $0, $3, $1 ; CeladonMartElevatorText1

    db $0 ; people

    ; warp-to
    EVENT_DISP $2, $3, $1 ; CELADON_MART_1
    EVENT_DISP $2, $3, $2 ; CELADON_MART_1

CeladonMartElevatorBlocks: ; 4
    INCBIN "maps/celadonmart6.blk"

CeladonMansion1_h: ; 0x48688 to 0x48694 (12 bytes) (bank=12) (id=128)
    db $13 ; tileset
    db $06, $04 ; dimensions (y, x)
    dw CeladonMansion1Blocks, $4697, $4694 ; blocks, texts, scripts
    db $00 ; connections

    dw $46cf ; objects

INCBIN "baserom.gbc",$48694,$48697 - $48694
CeladonMansion1Texts: ; 0x48697
    dw CeladonMansion1Text1, CeladonMansion1Text2, CeladonMansion1Text3, CeladonMansion1Text4, CeladonMansion1Text5
INCBIN "baserom.gbc",$486a1,$6

CeladonMansion1Text1: ; 0x486a7
    TX_FAR _CeladonMansion1Text1
    db $08 ; asm
    ld a, $4d
    jp $46a1

CeladonMansion1Text2: ; 0x486b1
    TX_FAR _CeladonMansion1Text2
    db $50

CeladonMansion1Text3: ; 0x486b6
    TX_FAR _CeladonMansion1Text3
    db $8
    ld a, $4
    jp $46a1
; 0x486c0

CeladonMansion1Text4: ; 0x486c0
    TX_FAR _CeladonMansion1Text4
    db $8
    ld a, $f
    jp $46a1
; 0x486ca

CeladonMansion1Text5: ; 0x486ca
    TX_FAR _CeladonMansion1Text5
    db $50

CeladonMansion1Object: ; 0x486cf (size=71)
    db $f ; border tile

    db $5 ; warps
    db $b, $4, $2, $ff
    db $b, $5, $2, $ff
    db $0, $4, $4, $ff
    db $1, $7, $1, CELADON_MANSION_2
    db $1, $2, $2, CELADON_MANSION_2

    db $1 ; signs
    db $9, $4, $5 ; CeladonMansion1Text5

    db $4 ; people
    db SPRITE_SLOWBRO, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_OLD_MEDIUM_WOMAN, $5 + 4, $1 + 4, $ff, $d0, $2 ; person
    db SPRITE_CLEFAIRY, $8 + 4, $1 + 4, $fe, $2, $3 ; person
    db SPRITE_SLOWBRO, $4 + 4, $4 + 4, $fe, $1, $4 ; person

    ; warp-to
    EVENT_DISP $4, $b, $4
    EVENT_DISP $4, $b, $5
    EVENT_DISP $4, $0, $4
    EVENT_DISP $4, $1, $7 ; CELADON_MANSION_2
    EVENT_DISP $4, $1, $2 ; CELADON_MANSION_2

CeladonMansion1Blocks: ; 24
    INCBIN "maps/celadonmansion1.blk"

CeladonMansion2_h: ; 0x4872e to 0x4873a (12 bytes) (bank=12) (id=129)
    db $13 ; tileset
    db $06, $04 ; dimensions (y, x)
    dw CeladonMansion2Blocks, $473e, $473a ; blocks, texts, scripts
    db $00 ; connections

    dw $4745 ; objects

INCBIN "baserom.gbc",$4873a,$4873e - $4873a
CeladonMansion2Texts: ; 0x4873e
    dw CeladonMansion2Text1

CeladonMansion2Text1: ; 0x48740
    TX_FAR _CeladonMansion2Text1
    db $50

CeladonMansion2Object: ; 0x48745 (size=39)
    db $f ; border tile

    db $4 ; warps
    db $1, $6, $0, CELADON_MANSION_3
    db $1, $7, $3, CELADON_MANSION_1
    db $1, $2, $4, CELADON_MANSION_1
    db $1, $4, $3, CELADON_MANSION_3

    db $1 ; signs
    db $9, $4, $1 ; CeladonMansion2Text1

    db $0 ; people

    ; warp-to
    EVENT_DISP $4, $1, $6 ; CELADON_MANSION_3
    EVENT_DISP $4, $1, $7 ; CELADON_MANSION_1
    EVENT_DISP $4, $1, $2 ; CELADON_MANSION_1
    EVENT_DISP $4, $1, $4 ; CELADON_MANSION_3

CeladonMansion2Blocks: ; 24
    INCBIN "maps/celadonmansion2.blk"

CeladonMansion3_h: ; 0x48784 to 0x48790 (12 bytes) (bank=12) (id=130)
    db $13 ; tileset
    db $06, $04 ; dimensions (y, x)
    dw CeladonMansion3Blocks, $4793, $4790 ; blocks, texts, scripts
    db $00 ; connections

    dw $47ff ; objects

INCBIN "baserom.gbc",$48790,$487a3 - $48790

CeladonMansion3Text1: ; 0x487a3
    TX_FAR _CeladonMansion3Text1
    db $50

CeladonMansion3Text2: ; 0x487a8
    TX_FAR _CeladonMansion3Text2
    db $50

CeladonMansion3Text3: ; 0x487ad
    TX_FAR _CeladonMansion3Text3
    db $50

CeladonMansion3Text4: ; 0x487b2
    db $08 ; asm
    ld hl, $d2f7
    ld b, $13
    call $2b7f
    ld a, [$d11e]
    cp $96
    jr nc, .asm_f03d0 ; 0x487c0
    ld hl, $47d0
    jr .asm_c13f0 ; 0x487c5
.asm_f03d0 ; 0x487c7
    ld hl, $47d5
.asm_c13f0 ; 0x487ca
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$487d0,$1b

CeladonMansion3Text5: ; 0x487eb
    TX_FAR _CeladonMansion3Text5
    db $50

CeladonMansion3Text6: ; 0x487f0
    TX_FAR _CeladonMansion3Text6
    db $50

CeladonMansion3Text7: ; 0x487f5
    TX_FAR _CeladonMansion3Text7
    db $50

CeladonMansion3Text8: ; 0x487fa
    TX_FAR _CeladonMansion3Text8
    db $50

CeladonMansion3Object: ; 0x487ff (size=72)
    db $f ; border tile

    db $4 ; warps
    db $1, $6, $0, CELADON_MANSION_2
    db $1, $7, $0, CELADON_MANSION_4
    db $1, $2, $1, CELADON_MANSION_4
    db $1, $4, $3, CELADON_MANSION_2

    db $4 ; signs
    db $3, $1, $5 ; CeladonMansion3Text5
    db $3, $4, $6 ; CeladonMansion3Text6
    db $6, $1, $7 ; CeladonMansion3Text7
    db $9, $4, $8 ; CeladonMansion3Text8

    db $4 ; people
    db SPRITE_BIKE_SHOP_GUY, $4 + 4, $0 + 4, $ff, $d1, $1 ; person
    db SPRITE_MART_GUY, $4 + 4, $3 + 4, $ff, $d1, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $7 + 4, $0 + 4, $ff, $d1, $3 ; person
    db SPRITE_LAPRAS_GIVER, $3 + 4, $2 + 4, $ff, $ff, $4 ; person

    ; warp-to
    EVENT_DISP $4, $1, $6 ; CELADON_MANSION_2
    EVENT_DISP $4, $1, $7 ; CELADON_MANSION_4
    EVENT_DISP $4, $1, $2 ; CELADON_MANSION_4
    EVENT_DISP $4, $1, $4 ; CELADON_MANSION_2

CeladonMansion3Blocks: ; 24
    INCBIN "maps/celadonmansion3.blk"

CeladonMansion4_h: ; 0x4885f to 0x4886b (12 bytes) (bank=12) (id=131)
    db $13 ; tileset
    db $06, $04 ; dimensions (y, x)
    dw CeladonMansion4Blocks, $486e, $486b ; blocks, texts, scripts
    db $00 ; connections

    dw $4875 ; objects

INCBIN "baserom.gbc",$4886b,$4886e - $4886b
CeladonMansion4Texts: ; 0x4886e
    dw CeladonMansion4Text1

CeladonMansion4Text1: ; 0x48870
    TX_FAR _CeladonMansion4Text1
    db $50

CeladonMansion4Object: ; 0x48875 (size=31)
    db $9 ; border tile

    db $3 ; warps
    db $1, $6, $1, CELADON_MANSION_3
    db $1, $2, $2, CELADON_MANSION_3
    db $7, $2, $0, CELADON_MANSION_5

    db $1 ; signs
    db $7, $3, $1 ; CeladonMansion4Text1

    db $0 ; people

    ; warp-to
    EVENT_DISP $4, $1, $6 ; CELADON_MANSION_3
    EVENT_DISP $4, $1, $2 ; CELADON_MANSION_3
    EVENT_DISP $4, $7, $2 ; CELADON_MANSION_5

CeladonMansion4Blocks: ; 24
    INCBIN "maps/celadonmansion4.blk"

CeladonPokecenter_h: ; 0x488ac to 0x488b8 (12 bytes) (bank=12) (id=133)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $40ab, $48be, $48b8 ; blocks, texts, scripts
    db $00 ; connections

    dw $48d2 ; objects

INCBIN "baserom.gbc",$488b8,$488c8 - $488b8

CeladonPokecenterText2: ; _CeladonPokecenterText2
CeladonPokecenterText1: ; 0x488c8
    TX_FAR _CeladonPokecenterText1

INCBIN "baserom.gbc",$488c8 + 4,$488d2 - ($488c8+4)

CeladonPokecenterObject: ; 0x488d2 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $5, $ff
    db $7, $4, $5, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $7 + 4, $fe, $2, $2 ; person
    db SPRITE_FOULARD_WOMAN, $5 + 4, $a + 4, $fe, $0, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

CeladonGym_h: ; 0x488fe to 0x4890a (12 bytes) (bank=12) (id=134)
    db $07 ; tileset
    db $09, $05 ; dimensions (y, x)
    dw CeladonGymBlocks, $49a6, $490a ; blocks, texts, scripts
    db $00 ; connections

    dw $4b30 ; objects

INCBIN "baserom.gbc",$4890a,$48a11 - $4890a
CeladonGymText1: ; 0x48a11
    db $08 ; asm
    ld a, [$d77c]
    bit 1, a
    jr z, .asm_16064 ; 0x48a17
    bit 0, a
    jr nz, .asm_3b22c ; 0x48a1b
    call z, $4963
    call $30b6
    jr .asm_96252 ; 0x48a23
.asm_3b22c ; 0x48a25
    ld hl, $4a68
    call PrintText
    jr .asm_96252 ; 0x48a2b
.asm_16064 ; 0x48a2d
    ld hl, $4a5e
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4a63
    ld de, $4a63
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $4
    ld [$d05c], a
    ld a, $3
    ld [$d5ff], a
    ld [$da39], a
.asm_96252 ; 0x48a5b
    jp $24d7

INCBIN "baserom.gbc",$48a5e,$48a81 - $48a5e
CeladonGymText2: ; 0x48a81
    db $08 ; asm
    ld hl, $49bc
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48a8b,$48a9a - $48a8b
CeladonGymText3: ; 0x48a9a
    db $08 ; asm
    ld hl, $49c8
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48aa4,$48ab3 - $48aa4
CeladonGymText4: ; 0x48ab3
    db $08 ; asm
    ld hl, $49d4
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48abd,$48acc - $48abd
CeladonGymText5: ; 0x48acc
    db $08 ; asm
    ld hl, $49e0
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48ad6,$48ae5 - $48ad6
CeladonGymText6: ; 0x48ae5
    db $08 ; asm
    ld hl, $49ec
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48aef,$48afe - $48aef
CeladonGymText7: ; 0x48afe
    db $08 ; asm
    ld hl, $49f8
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48b08,$48b17 - $48b08
CeladonGymText8: ; 0x48b17
    db $08 ; asm
    ld hl, $4a04
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$48b21,$f
CeladonGymObject: ; 0x48b30 (size=84)
    db $3 ; border tile

    db $2 ; warps
    db $11, $4, $6, $ff
    db $11, $5, $6, $ff

    db $0 ; signs

    db $8 ; people
    db SPRITE_ERIKA, $3 + 4, $4 + 4, $ff, $d0, $41, ERIKA + $C8, $1 ; trainer
    db SPRITE_LASS, $b + 4, $2 + 4, $ff, $d3, $42, LASS + $C8, $11 ; trainer
    db SPRITE_FOULARD_WOMAN, $a + 4, $7 + 4, $ff, $d2, $43, BEAUTY + $C8, $1 ; trainer
    db SPRITE_LASS, $5 + 4, $9 + 4, $ff, $d0, $44, JR__TRAINER_F + $C8, $b ; trainer
    db SPRITE_FOULARD_WOMAN, $5 + 4, $1 + 4, $ff, $d0, $45, BEAUTY + $C8, $2 ; trainer
    db SPRITE_LASS, $3 + 4, $6 + 4, $ff, $d0, $46, LASS + $C8, $12 ; trainer
    db SPRITE_FOULARD_WOMAN, $3 + 4, $3 + 4, $ff, $d0, $47, BEAUTY + $C8, $3 ; trainer
    db SPRITE_LASS, $3 + 4, $5 + 4, $ff, $d0, $48, COOLTRAINER_F + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $5, $11, $4
    EVENT_DISP $5, $11, $5

CeladonGymBlocks: ; 45
    INCBIN "maps/celadongym.blk"

CeladonGameCorner_h: ; 0x48bb1 to 0x48bbd (12 bytes) (bank=12) (id=135)
    db $12 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw CeladonGameCornerBlocks, $4c8a, $4bbd ; blocks, texts, scripts
    db $00 ; connections

    dw $4fa0 ; objects

INCBIN "baserom.gbc",$48bbd,$48ca4 - $48bbd

CeladonGameCornerText1: ; 0x48ca4
    TX_FAR _CeladonGameCornerText1
    db $50

CeladonGameCornerText2: ; 0x48ca9
    db $08 ; asm
    call $4f1e
    ld hl, $4d22
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_c650b ; 0x48cba
	ld b,COIN_CASE
    call $3493
    jr z, .asm_ed086 ; 0x48cc1
    call $4f95
    jr nc, .asm_31338 ; 0x48cc6
    xor a
    ldh [$9f], a
    ldh [$a1], a
    ld a, $10
    ldh [$a0], a
    call $35a6
    jr nc, .asm_b6ef0 ; 0x48cd4
    ld hl, $4d31
    jr .asm_e2afd ; 0x48cd9
.asm_b6ef0 ; 0x48cdb
    xor a
    ldh [$9f], a
    ldh [$a1], a
    ld a, $10
    ldh [$a0], a
    ld hl, $ffa1
    ld de, $d349
    ld c, $3
    ld a, $c
    call Predef
    xor a
    ldh [$9f], a
    ldh [$a0], a
    ld a, $50
    ldh [$a1], a
    ld de, $d5a5
    ld hl, $ffa1
    ld c, $2
    ld a, $b
    call Predef
    call $4f1e
    ld hl, $4d27
    jr .asm_e2afd ; 0x48d0d
.asm_c650b ; 0x48d0f
    ld hl, $4d2c
    jr .asm_e2afd ; 0x48d12
.asm_31338 ; 0x48d14
    ld hl, $4d36
    jr .asm_e2afd ; 0x48d17
.asm_ed086 ; 0x48d19
    ld hl, $4d3b
.asm_e2afd ; 0x48d1c
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48d22,$1e

CeladonGameCornerText3: ; 0x48d40
    TX_FAR _CeladonGameCornerText3
    db $50

CeladonGameCornerText4: ; 0x48d45
    TX_FAR _CeladonGameCornerText4
    db $50

CeladonGameCornerText5: ; 0x48d4a
    db $08 ; asm
    ld a, [$d77e]
    bit 2, a
    jr nz, .asm_d0957 ; 0x48d50
    ld hl, $4d9c
    call PrintText
	ld b,COIN_CASE
    call $3493
    jr z, .asm_5aef9 ; 0x48d5d
    call $4f95
    jr nc, .asm_98546 ; 0x48d62
    xor a
    ldh [$9f], a
    ldh [$a0], a
    ld a, $10
    ldh [$a1], a
    ld de, $d5a5
    ld hl, $ffa1
    ld c, $2
    ld a, $b
    call Predef
    ld hl, $d77e
    set 2, [hl]
    ld a, $1
    ld [$cc3c], a
    ld hl, $4da1
    jr .asm_c7d1a ; 0x48d87
.asm_d0957 ; 0x48d89
    ld hl, $4dac
    jr .asm_c7d1a ; 0x48d8c
.asm_98546 ; 0x48d8e
    ld hl, $4da7
    jr .asm_c7d1a ; 0x48d91
.asm_5aef9 ; 0x48d93
    ld hl, $4f19
.asm_c7d1a ; 0x48d96
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48d9c,$15

CeladonGameCornerText6: ; 0x48db1
    TX_FAR _CeladonGameCornerText6
    db $50

CeladonGameCornerText7: ; 0x48db6
    db $08 ; asm
    ld a, [$d77c]
    bit 1, a
    ld hl, $4dca
    jr z, .asm_be3fd ; 0x48dbf
    ld hl, $4dcf
.asm_be3fd ; 0x48dc4
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48dca,$a

CeladonGameCornerText8: ; 0x48dd4
    TX_FAR _CeladonGameCornerText8
    db $50

CeladonGameCornerText9: ; 0x48dd9
    db $08 ; asm
    ld a, [$d77e]
    bit 4, a
    jr nz, .asm_ed8bc ; 0x48ddf
    ld hl, $4e26
    call PrintText
	ld b,COIN_CASE
    call $3493
    jr z, .asm_df794 ; 0x48dec
    call $4f95
    jr nc, .asm_f17c3 ; 0x48df1
    xor a
    ldh [$9f], a
    ldh [$a0], a
    ld a, $20
    ldh [$a1], a
    ld de, $d5a5
    ld hl, $ffa1
    ld c, $2
    ld a, $b
    call Predef
    ld hl, $d77e
    set 4, [hl]
    ld hl, $4e2b
    jr .asm_0ddc2 ; 0x48e11
.asm_ed8bc ; 0x48e13
    ld hl, $4e36
    jr .asm_0ddc2 ; 0x48e16
.asm_f17c3 ; 0x48e18
    ld hl, $4e31
    jr .asm_0ddc2 ; 0x48e1b
.asm_df794 ; 0x48e1d
    ld hl, $4f19
.asm_0ddc2 ; 0x48e20
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48e26,$48e3b - $48e26
CeladonGameCornerText10: ; 0x48e3b
    db $08 ; asm
    ld a, [$d77e]
    bit 3, a
    jr nz, .asm_ff080 ; 0x48e41
    ld hl, $4e88
    call PrintText
	ld b,COIN_CASE
    call $3493
    jr z, .asm_4fb0c ; 0x48e4e
    call $4f95
    jr z, .asm_9505a ; 0x48e53
    xor a
    ldh [$9f], a
    ldh [$a0], a
    ld a, $20
    ldh [$a1], a
    ld de, $d5a5
    ld hl, $ffa1
    ld c, $2
    ld a, $b
    call Predef
    ld hl, $d77e
    set 3, [hl]
    ld hl, $4e8d
    jr .asm_78d65 ; 0x48e73
.asm_ff080 ; 0x48e75
    ld hl, $4e98
    jr .asm_78d65 ; 0x48e78
.asm_9505a ; 0x48e7a
    ld hl, $4e93
    jr .asm_78d65 ; 0x48e7d
.asm_4fb0c ; 0x48e7f
    ld hl, $4f19
.asm_78d65 ; 0x48e82
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$48e88,$48e9d - $48e88
CeladonGameCornerText11: ; 0x48e9d
    db $08 ; asm
    ld hl, $4ece
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4ed3
    ld de, $4ed3
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    xor a
    ldh [$b4], a
    ldh [$b3], a
    ldh [$b2], a
    ld a, $1
    ld [$d65f], a
    jp $24d7

INCBIN "baserom.gbc",$48ece,$48edd - $48ece
CeladonGameCornerText12: ; 0x48edd
    db $08 ; asm
    ld a, $1
    ld [$cc3c], a
    ld hl, $4f09
    call PrintText
    call $3748
    ld a, $ad
    call $23b1
    call $3748
    ld hl, $d77e
    set 1, [hl]
    ld a, $43
    ld [$d09f], a
    ld bc, $0208
    ld a, $17
    call Predef
    jp $24d7

INCBIN "baserom.gbc",$48f09,$97
CeladonGameCornerObject: ; 0x48fa0 (size=99)
    db $f ; border tile

    db $3 ; warps
    db $11, $f, $7, $ff
    db $11, $10, $7, $ff
    db $4, $11, $1, ROCKET_HIDEOUT_1

    db $1 ; signs
    db $4, $9, $c ; CeladonGameCornerText12

    db $b ; people
    db SPRITE_FOULARD_WOMAN, $6 + 4, $2 + 4, $ff, $d0, $1 ; person
    db SPRITE_MART_GUY, $6 + 4, $5 + 4, $ff, $d0, $2 ; person
    db SPRITE_FAT_BALD_GUY, $a + 4, $2 + 4, $ff, $d2, $3 ; person
    db SPRITE_FOULARD_WOMAN, $d + 4, $2 + 4, $ff, $d2, $4 ; person
    db SPRITE_FISHER, $b + 4, $5 + 4, $ff, $d3, $5 ; person
    db SPRITE_MOM_GEISHA, $b + 4, $8 + 4, $ff, $d2, $6 ; person
    db SPRITE_GYM_HELPER, $e + 4, $8 + 4, $ff, $d2, $7 ; person
    db SPRITE_GAMBLER, $f + 4, $b + 4, $ff, $d3, $8 ; person
    db SPRITE_MART_GUY, $b + 4, $e + 4, $ff, $d2, $9 ; person
    db SPRITE_GENTLEMAN, $d + 4, $11 + 4, $ff, $d3, $a ; person
    db SPRITE_ROCKET, $5 + 4, $9 + 4, $ff, $d1, $4b, ROCKET + $C8, $7 ; trainer

    ; warp-to
    EVENT_DISP $a, $11, $f
    EVENT_DISP $a, $11, $10
    EVENT_DISP $a, $4, $11 ; ROCKET_HIDEOUT_1

CeladonGameCornerBlocks: ; 90
    INCBIN "maps/celadongamecorner.blk"

CeladonMart5_h: ; 0x4905d to 0x49069 (12 bytes) (bank=12) (id=136)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMart5Blocks, $506c, $5069 ; blocks, texts, scripts
    db $00 ; connections

    dw $5085 ; objects

INCBIN "baserom.gbc",$49069,$49076 - $49069

CeladonMart5Text1: ; 0x49076
    TX_FAR _CeladonMart5Text1
    db $50

CeladonMart5Text2: ; 0x4907b
    TX_FAR _CeladonMart5Text2
    db $50

CeladonMart5Text5: ; 0x49080
    TX_FAR _CeladonMart5Text5
    db $50

CeladonMart5Object: ; 0x49085 (size=55)
    db $f ; border tile

    db $3 ; warps
    db $1, $c, $0, CELADON_MART_ROOF
    db $1, $10, $1, CELADON_MART_4
    db $1, $1, $0, CELADON_MART_ELEVATOR

    db $1 ; signs
    db $1, $e, $5 ; CeladonMart5Text5

    db $4 ; people
    db SPRITE_GENTLEMAN, $5 + 4, $e + 4, $fe, $1, $1 ; person
    db SPRITE_SAILOR, $6 + 4, $2 + 4, $ff, $ff, $2 ; person
    db SPRITE_MART_GUY, $3 + 4, $5 + 4, $ff, $d0, $3 ; person
    db SPRITE_MART_GUY, $3 + 4, $6 + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $a, $1, $c ; CELADON_MART_ROOF
    EVENT_DISP $a, $1, $10 ; CELADON_MART_4
    EVENT_DISP $a, $1, $1 ; CELADON_MART_ELEVATOR

CeladonMart5Blocks: ; 40
    INCBIN "maps/celadonhouse.blk"

CeladonPrizeRoom_h: ; 0x490e4 to 0x490f0 (12 bytes) (bank=12) (id=137)
    db $12 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw CeladonPrizeRoomBlocks, $50f3, $50f0 ; blocks, texts, scripts
    db $00 ; connections

    dw $5108 ; objects

INCBIN "baserom.gbc",$490f0,$490fd - $490f0

CeladonPrizeRoomText1: ; 0x490fd
    TX_FAR _CeladonPrizeRoomText1
    db $50

CeladonPrizeRoomText2: ; 0x49102
    TX_FAR _CeladonPrizeRoomText2
    db $50

INCBIN "baserom.gbc",$49107,$1

CeladonPrizeRoomObject: ; 0x49108 (size=41)
    db $f ; border tile

    db $2 ; warps
    db $7, $4, $9, $ff
    db $7, $5, $9, $ff

    db $3 ; signs
    db $2, $2, $3 ; CeladonPrizeRoomText3
    db $2, $4, $4 ; CeladonPrizeRoomText4
    db $2, $6, $5 ; CeladonPrizeRoomText5

    db $2 ; people
    db SPRITE_BALDING_GUY, $4 + 4, $1 + 4, $ff, $ff, $1 ; person
    db SPRITE_GAMBLER, $3 + 4, $7 + 4, $fe, $2, $2 ; person

    ; warp-to
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5

CeladonPrizeRoomBlocks: ; 20
    INCBIN "maps/celadonprizeroom.blk"

CeladonDiner_h: ; 0x49145 to 0x49151 (12 bytes) (bank=12) (id=138)
    db $12 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw CeladonDinerBlocks, $5155, $5151 ; blocks, texts, scripts
    db $00 ; connections

    dw $51bc ; objects

INCBIN "baserom.gbc",$49151,$4915f - $49151

CeladonDinerText1: ; 0x4915f
    TX_FAR _CeladonDinerText1
    db $50

CeladonDinerText2: ; 0x49164
    TX_FAR _CeladonDinerText2
    db $50

CeladonDinerText3: ; 0x49169
    TX_FAR _CeladonDinerText3
    db $50

CeladonDinerText4: ; 0x4916e
    TX_FAR _CeladonDinerText4
    db $50

CeladonDinerText5: ; 0x49173
    db $08 ; asm
    ld a, [$d783]
    bit 0, a
    jr nz, .asm_eb14d ; 0x49179
    ld hl, $51a7
    call PrintText
    ld bc,(COIN_CASE << 8) | 1
    call $3e2e
    jr nc, .asm_78e93 ; 0x49187
    ld hl, $d783
    set 0, [hl]
    ld hl, $51ac
    call PrintText
    jr .asm_68b61 ; 0x49194
.asm_78e93 ; 0x49196
    ld hl, $51b2
    call PrintText
    jr .asm_68b61 ; 0x4919c
.asm_eb14d ; 0x4919e
    ld hl, $51b7
    call PrintText
.asm_68b61 ; 0x491a4
    jp $24d7

INCBIN "baserom.gbc",$491a7,$15

CeladonDinerObject: ; 0x491bc (size=50)
    db $f ; border tile

    db $2 ; warps
    db $7, $3, $a, $ff
    db $7, $4, $a, $ff

    db $0 ; signs

    db $5 ; people
    db SPRITE_COOK, $5 + 4, $8 + 4, $fe, $2, $1 ; person
    db SPRITE_MOM_GEISHA, $2 + 4, $7 + 4, $ff, $ff, $2 ; person
    db SPRITE_FAT_BALD_GUY, $4 + 4, $1 + 4, $ff, $d0, $3 ; person
    db SPRITE_FISHER2, $3 + 4, $5 + 4, $ff, $d3, $4 ; person
    db SPRITE_GYM_HELPER, $1 + 4, $0 + 4, $ff, $d0, $5 ; person

    ; warp-to
    EVENT_DISP $5, $7, $3
    EVENT_DISP $5, $7, $4

CeladonDinerBlocks: ; 20
    INCBIN "maps/celadondiner.blk"

CeladonHouse2_h: ; 0x49202 to 0x4920e (12 bytes) (bank=12) (id=139)
    db $13 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw CeladonHouse2Blocks, $5212, $520e ; blocks, texts, scripts
    db $00 ; connections

    dw $5227 ; objects

INCBIN "baserom.gbc",$4920e,$49212 - $4920e
CeladonHouse2Texts: ; 0x49212
    dw CeladonHouse2Text1, CeladonHouse2Text2, CeladonHouse2Text3

CeladonHouse2Text1: ; 0x49218
    TX_FAR _CeladonHouse2Text1
    db $50

CeladonHouse2Text2: ; 0x4921d
    TX_FAR _CeladonHouse2Text2
    db $50

CeladonHouse2Text3: ; 0x49222
    TX_FAR _CeladonHouse2Text3
    db $50

CeladonHouse2Object: ; 0x49227 (size=38)
    db $f ; border tile

    db $2 ; warps
    db $7, $2, $b, $ff
    db $7, $3, $b, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_OLD_PERSON, $2 + 4, $4 + 4, $ff, $d0, $1 ; person
    db SPRITE_ROCKET, $4 + 4, $1 + 4, $fe, $0, $2 ; person
    db SPRITE_SAILOR, $6 + 4, $5 + 4, $ff, $d2, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

CeladonHouse2Blocks: ; 16
    INCBIN "maps/celadonhouse2.blk"

CeladonHotel_h: ; 0x4925d to 0x49269 (12 bytes) (bank=12) (id=140)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw CeladonHotelBlocks, $526c, $5269 ; blocks, texts, scripts
    db $00 ; connections

    dw $5281 ; objects

INCBIN "baserom.gbc",$49269,$4926c - $49269
CeladonHotelTexts: ; 0x4926c
    dw CeladonHotelText1, CeladonHotelText2, CeladonHotelText3

CeladonHotelText1: ; 0x49272
    TX_FAR _CeladonHotelText1
    db $50

CeladonHotelText2: ; 0x49277
    TX_FAR _CeladonHotelText2
    db $50

CeladonHotelText3: ; 0x4927c
    TX_FAR _CeladonHotelText3
    db $50

CeladonHotelObject: ; 0x49281 (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $c, $ff
    db $7, $4, $c, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_OLD_MEDIUM_WOMAN, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_FOULARD_WOMAN, $4 + 4, $2 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $4 + 4, $8 + 4, $fe, $2, $3 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

CeladonHotelBlocks: ; 28
    INCBIN "maps/celadonhotel.blk"

MtMoonPokecenter_h: ; 0x492c3 to 0x492cf (12 bytes) (bank=12) (id=68)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw MtMoonPokecenterBlocks, $52d5, $52cf ; blocks, texts, scripts
    db $00 ; connections

    dw $5376 ; objects

INCBIN "baserom.gbc",$492cf,$492e1 - $492cf

db $ff
MtMoonPokecenterText1: ; 0x492e1
    TX_FAR _MtMoonPokecenterText1
    db $50

MtMoonPokecenterText3: ; 0x492e7
    TX_FAR _MtMoonPokecenterText3
    db $50

MtMoonPokecenterText4: ; 0x492ec
    db $08 ; asm
    ld a, [$d7c6]
    add a
    jp c, $5353
    ld hl, $535c
    call PrintText
    ld a, $13
    ld [$d125], a
    call $30e8
    call $35ec
    ld a, [$cc26]
    and a
    jp nz, $534e
    ldh [$9f], a
    ldh [$a1], a
    ld a, $5
    ldh [$a0], a
    call $35a6
    jr nc, .asm_faa09 ; 0x49317
    ld hl, $5366
    jr .asm_ae354 ; 0x4931c
.asm_faa09 ; 0x4931e
	ld bc,(MAGIKARP << 8) | 5
    call GivePokemon
    jr nc, .asm_38361 ; 0x49324
    xor a
    ld [W_WHICHTRADE], a
    ld [$cd3f], a
    ld a, $5
    ld [$cd3e], a
    ld hl, $cd3f
    ld de, $d349
    ld c, $3
    ld a, $c
    call Predef
    ld a, $13
    ld [$d125], a
    call $30e8
    ld hl, $d7c6
    set 7, [hl]
    jr .asm_38361 ; 0x4934c
    ld hl, $5361
    jr .asm_ae354 ; 0x49351
    ld hl, $536b
.asm_ae354 ; 0x49356
    call PrintText
.asm_38361 ; 0x49359
    jp $24d7

INCBIN "baserom.gbc",$4935c,$14

MtMoonPokecenterText5: ; 0x49370
    TX_FAR _MtMoonPokecenterText5
    db $50

;XXX wtf?
db $f6

MtMoonPokecenterObject: ; 0x49376 (size=56)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $6 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_BUG_CATCHER, $3 + 4, $4 + 4, $ff, $d1, $2 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $7 + 4, $ff, $d1, $3 ; person
    db SPRITE_FAT_BALD_GUY, $6 + 4, $a + 4, $fe, $2, $4 ; person
    db SPRITE_CLIPBOARD, $2 + 4, $7 + 4, $ff, $ff, $5 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $6 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

RockTunnelPokecenter_h: ; 0x493ae to 0x493ba (12 bytes) (id=81)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $40ab, $53c0, $53ba ; blocks, texts, scripts
    db $00 ; connections

    dw $53d4 ; objects

INCBIN "baserom.gbc",$493ba,$493c8 - $493ba

db $ff
RockTunnelPokecenterText1: ; 0x493c8
    TX_FAR _RockTunnelPokecenterText1

INCBIN "baserom.gbc",$493cd,$493ce - $493cd

RockTunnelPokecenterText3: ; 0x493ce
    TX_FAR _RockTunnelPokecenterText3
    db $50

; RockTunnelPokecenterText4: ; 0x493d3

INCBIN "baserom.gbc",$493ce+5,$493d4-($493ce+5)

RockTunnelPokecenterObject: ; 0x493d4 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $7 + 4, $fe, $2, $2 ; person
    db SPRITE_FISHER2, $5 + 4, $2 + 4, $ff, $ff, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

Route11Gate_h: ; 0x49400 to 0x4940c (12 bytes) (id=84)
    db $0c ; tileset
    db $05, $04 ; dimensions (y, x)
    dw Route11GateBlocks, $540f, $540c ; blocks, texts, scripts
    db $00 ; connections

    dw $5416 ; objects

INCBIN "baserom.gbc",$4940c,$4940f - $4940c
Route11GateTexts: ; 0x4940f
    dw Route11GateText1

Route11GateText1: ; 0x49411
    TX_FAR _Route11GateText1
    db $50

Route11GateObject: ; 0x49416 (size=50)
    db $a ; border tile

    db $5 ; warps
    db $4, $0, $0, $ff
    db $5, $0, $1, $ff
    db $4, $7, $2, $ff
    db $5, $7, $3, $ff
    db $8, $6, $0, ROUTE_11_GATE_2F

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $1 + 4, $4 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $4, $0
    EVENT_DISP $4, $5, $0
    EVENT_DISP $4, $4, $7
    EVENT_DISP $4, $5, $7
    EVENT_DISP $4, $8, $6 ; ROUTE_11_GATE_2F

Route11GateUpstairs_h: ; 0x49448 to 0x49454 (12 bytes) (id=86)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw Route11GateUpstairsBlocks, $5457, $5454 ; blocks, texts, scripts
    db $00 ; connections

    dw $54da ; objects

INCBIN "baserom.gbc",$49454,$4945f - $49454
Route11GateUpstairsText1: ; 0x4945f
    db $08 ; asm
    xor a
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

INCBIN "baserom.gbc",$4946c,$494a8 - $4946c
Route11GateUpstairsText3: ; 0x494a8
    db $08 ; asm
    ld a, [$c109]
    cp $4
    jp nz, $55c9
    ld a, [$d7d8]
    bit 7, a
    ld hl, $54c4
    jr z, .asm_5ac80 ; 0x494b9
    ld hl, $54c9
.asm_5ac80 ; 0x494be
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$494c4,$16

Route11GateUpstairsObject: ; 0x494da (size=30)
    db $a ; border tile

    db $1 ; warps
    db $7, $7, $4, ROUTE_11_GATE_1F

    db $2 ; signs
    db $2, $1, $3 ; Route11GateUpstairsText3
    db $2, $6, $4 ; Route11GateUpstairsText4

    db $2 ; people
    db SPRITE_BUG_CATCHER, $2 + 4, $4 + 4, $fe, $2, $1 ; person
    db SPRITE_OAK_AIDE, $6 + 4, $2 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $7 ; ROUTE_11_GATE_1F

Route12Gate_h: ; 0x494f8 to 0x49504 (12 bytes) (id=87)
    db $0c ; tileset
    db $04, $05 ; dimensions (y, x)
    dw Route12GateBlocks, $5507, $5504 ; blocks, texts, scripts
    db $00 ; connections

    dw $550e ; objects

INCBIN "baserom.gbc",$49504,$49507 - $49504
Route12GateTexts: ; 0x49507
    dw Route12GateText1

Route12GateText1: ; 0x49509
    TX_FAR _Route12GateText1
    db $50

Route12GateObject: ; 0x4950e (size=50)
    db $a ; border tile

    db $5 ; warps
    db $0, $4, $0, $ff
    db $0, $5, $1, $ff
    db $7, $4, $2, $ff
    db $7, $5, $2, $ff
    db $6, $8, $0, ROUTE_12_GATE_2F

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $3 + 4, $1 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $5, $0, $4
    EVENT_DISP $5, $0, $5
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5
    EVENT_DISP $5, $6, $8 ; ROUTE_12_GATE_2F

Route12GateBlocks: ; 20
    INCBIN "maps/route12gate.blk"

Route12GateUpstairs_h: ; 0x49554 to 0x49560 (12 bytes) (id=195)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40db, $5563, $5560 ; blocks, texts, scripts
    db $00 ; connections

    dw $55de ; objects

INCBIN "baserom.gbc",$49560,$49569 - $49560
Route12GateUpstairsText1: ; 0x49569
    db $08 ; asm
    ld a, [$d7d7]
    rrca
    jr c, .asm_0ad3c ; 0x4956e
    ld hl, $559c
    call PrintText
    ld bc,(TM_39 << 8) | 1
    call $3e2e
    jr nc, .asm_4c2be ; 0x4957c
    ld hl, $55a1
    call PrintText
    ld hl, $d7d7
    set 0, [hl]
    jr .asm_4ba56 ; 0x49589
.asm_4c2be ; 0x4958b
    ld hl, $55ac
    call PrintText
    jr .asm_4ba56 ; 0x49591
.asm_0ad3c ; 0x49593
    ld hl, $55a7
    call PrintText
.asm_4ba56 ; 0x49599
    jp $24d7

INCBIN "baserom.gbc",$4959c,$495b1 - $4959c
Route12GateUpstairsText2: ; 0x495b1
    db $08 ; asm
    ld hl, $55b8
    jp $55c9
    rla
    ld e, d
    ld c, c
    inc hl
    ld d, b
    ld [$c421], sp
    ld d, l
    jp $55c9
    rla
    add [hl]
    ld c, c
    inc hl
    ld d, b
    ld a, [$c109]
    cp $4
    jr z, .asm_2fb7f ; 0x495ce
    ld a, $1
    jr .asm_b02ad ; 0x495d2
.asm_2fb7f ; 0x495d4
    call PrintText
    xor a
.asm_b02ad ; 0x495d8
    ld [$cc3c], a
    jp $24d7

Route12GateUpstairsObject: ; 0x495de (size=24)
    db $a ; border tile

    db $1 ; warps
    db $7, $7, $4, ROUTE_12_GATE

    db $2 ; signs
    db $2, $1, $2 ; Route12GateUpstairsText2
    db $2, $6, $3 ; Route12GateUpstairsText3

    db $1 ; people
    db SPRITE_BRUNETTE_GIRL, $4 + 4, $3 + 4, $fe, $1, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $7 ; ROUTE_12_GATE

Route15Gate_h: ; 0x495f6 to 0x49602 (12 bytes) (id=184)
    db $0c ; tileset
    db $05, $04 ; dimensions (y, x)
    dw $40c7, $5605, $5602 ; blocks, texts, scripts
    db $00 ; connections

    dw $560c ; objects

INCBIN "baserom.gbc",$49602,$49605 - $49602
Route15GateTexts: ; 0x49605
    dw Route15GateText1

Route15GateText1: ; 0x49607
    TX_FAR _Route15GateText1
    db $50

Route15GateObject: ; 0x4960c (size=50)
    db $a ; border tile

    db $5 ; warps
    db $4, $0, $0, $ff
    db $5, $0, $1, $ff
    db $4, $7, $2, $ff
    db $5, $7, $3, $ff
    db $8, $6, $0, $b9

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $1 + 4, $4 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $4, $0
    EVENT_DISP $4, $5, $0
    EVENT_DISP $4, $4, $7
    EVENT_DISP $4, $5, $7
    EVENT_DISP $4, $8, $6

INCBIN "baserom.gbc",$4963e,$74

Route16GateMap_h: ; 0x496b2 to 0x496be (12 bytes) (id=186)
    db $0c ; tileset
    db $07, $04 ; dimensions (y, x)
    dw Route16GateMapBlocks, $575a, $56be ; blocks, texts, scripts
    db $00 ; connections

    dw $578b ; objects

INCBIN "baserom.gbc",$496be,$49760 - $496be
Route16GateMapText1: ; 0x49760
    db $08 ; asm
    call $5755
    jr z, .asm_0bdf3 ; 0x49764
    ld hl, $577c
    call PrintText
    jr .asm_56c9d ; 0x4976c
.asm_0bdf3 ; 0x4976e
    ld hl, $5777
    call PrintText
.asm_56c9d ; 0x49774
    jp $24d7

INCBIN "baserom.gbc",$49777,$f

Route16GateMapText2: ; 0x49786
    TX_FAR _Route16GateMapText2
    db $50

Route16GateMapObject: ; 0x4978b (size=88)
    db $a ; border tile

    db $9 ; warps
    db $8, $0, $0, $ff
    db $9, $0, $1, $ff
    db $8, $7, $2, $ff
    db $9, $7, $2, $ff
    db $2, $0, $4, $ff
    db $3, $0, $5, $ff
    db $2, $7, $6, $ff
    db $3, $7, $7, $ff
    db $c, $6, $0, ROUTE_16_GATE_2F

    db $0 ; signs

    db $2 ; people
    db SPRITE_GUARD, $5 + 4, $4 + 4, $ff, $d0, $1 ; person
    db SPRITE_GAMBLER, $3 + 4, $4 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $4, $8, $0
    EVENT_DISP $4, $9, $0
    EVENT_DISP $4, $8, $7
    EVENT_DISP $4, $9, $7
    EVENT_DISP $4, $2, $0
    EVENT_DISP $4, $3, $0
    EVENT_DISP $4, $2, $7
    EVENT_DISP $4, $3, $7
    EVENT_DISP $4, $c, $6 ; ROUTE_16_GATE_2F

Route16GateMapBlocks: ; 28
    INCBIN "maps/route16gatemap.blk"

Route16GateUpstairs_h: ; 0x497ff to 0x4980b (12 bytes) (id=187)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40db, $580e, $580b ; blocks, texts, scripts
    db $00 ; connections

    dw $584c ; objects

INCBIN "baserom.gbc",$4980b,$49816 - $4980b
Route16GateUpstairsText1: ; 0x49816
    db $08 ; asm
    ld hl, $5820
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$49820,$49825 - $49820
Route16GateUpstairsText2: ; 0x49825
    db $08 ; asm
    ld hl, $582f
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$4982f,$1d

Route16GateUpstairsObject: ; 0x4984c (size=30)
    db $a ; border tile

    db $1 ; warps
    db $7, $7, $8, ROUTE_16_GATE_1F

    db $2 ; signs
    db $2, $1, $3 ; Route16GateUpstairsText3
    db $2, $6, $4 ; Route16GateUpstairsText4

    db $2 ; people
    db SPRITE_YOUNG_BOY, $2 + 4, $4 + 4, $ff, $ff, $1 ; person
    db SPRITE_LITTLE_GIRL, $5 + 4, $2 + 4, $fe, $2, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $7 ; ROUTE_16_GATE_1F

Route18Gate_h: ; 0x4986a to 0x49876 (12 bytes) (id=190)
    db $0c ; tileset
    db $05, $04 ; dimensions (y, x)
    dw $40c7, $590d, $5876 ; blocks, texts, scripts
    db $00 ; connections

    dw $5937 ; objects

INCBIN "baserom.gbc",$49876,$49911 - $49876
Route18GateText1: ; 0x49911
    db $08 ; asm
    call $5755
    jr z, .asm_3c84d ; 0x49915
    ld hl, $592d
    call PrintText
    jr .asm_a8410 ; 0x4991d
.asm_3c84d ; 0x4991f
    ld hl, $5928
    call PrintText
.asm_a8410 ; 0x49925
    jp $24d7

INCBIN "baserom.gbc",$49928,$f

Route18GateObject: ; 0x49937 (size=50)
    db $a ; border tile

    db $5 ; warps
    db $4, $0, $0, $ff
    db $5, $0, $1, $ff
    db $4, $7, $2, $ff
    db $5, $7, $3, $ff
    db $8, $6, $0, ROUTE_18_GATE_2F

    db $0 ; signs

    db $1 ; people
    db SPRITE_GUARD, $1 + 4, $4 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $4, $4, $0
    EVENT_DISP $4, $5, $0
    EVENT_DISP $4, $4, $7
    EVENT_DISP $4, $5, $7
    EVENT_DISP $4, $8, $6 ; ROUTE_18_GATE_2F

Route18GateHeader_h: ; 0x49969 to 0x49975 (12 bytes) (id=191)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $40db, $5978, $5975 ; blocks, texts, scripts
    db $00 ; connections

    dw $59a4 ; objects

INCBIN "baserom.gbc",$49975,$4997e - $49975
Route18GateHeaderText1: ; 0x4997e
    db $08 ; asm
    ld a, $5
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

INCBIN "baserom.gbc",$4998c,$18

Route18GateHeaderObject: ; 0x499a4 (size=24)
    db $a ; border tile

    db $1 ; warps
    db $7, $7, $4, ROUTE_18_GATE_1F

    db $2 ; signs
    db $2, $1, $2 ; Route18GateHeaderText2
    db $2, $6, $3 ; Route18GateHeaderText3

    db $1 ; people
    db SPRITE_BUG_CATCHER, $2 + 4, $4 + 4, $fe, $2, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $7 ; ROUTE_18_GATE_1F

MtMoon1_h: ; 0x499bc to 0x499c8 (12 bytes) (id=59)
    db $11 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw MtMoon1Blocks, $59e1, $59c8 ; blocks, texts, scripts
    db $00 ; connections

    dw $5b06 ; objects

INCBIN "baserom.gbc",$499c8,$49a52 - $499c8
MtMoon1Text1: ; 0x49a52
    db $08 ; asm
    ld hl, $59fd
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text2: ; 0x49a5c
    db $08 ; asm
    ld hl, $5a09
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text3: ; 0x49a66
    db $08 ; asm
    ld hl, $5a15
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text4: ; 0x49a70
    db $08 ; asm
    ld hl, $5a21
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text5: ; 0x49a7a
    db $08 ; asm
    ld hl, $5a2d
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text6: ; 0x49a84
    db $08 ; asm
    ld hl, $5a39
    call LoadTrainerHeader
    jp $24d7

MtMoon1Text7: ; 0x49a8e
    db $08 ; asm
    ld hl, $5a45
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$49a98,$69

MtMoon1Text14: ; 0x49b01
    TX_FAR _MtMoon1Text14
    db $50

MtMoon1Object: ; 0x49b06 (size=145)
    db $3 ; border tile

    db $5 ; warps
    db $23, $e, $1, $ff
    db $23, $f, $1, $ff
    db $5, $5, $0, MT_MOON_2
    db $b, $11, $2, MT_MOON_2
    db $f, $19, $3, MT_MOON_2

    db $1 ; signs
    db $17, $f, $e ; MtMoon1Text14

    db $d ; people
    db SPRITE_HIKER, $6 + 4, $5 + 4, $ff, $d0, $41, HIKER + $C8, $1 ; trainer
    db SPRITE_BUG_CATCHER, $10 + 4, $c + 4, $ff, $d3, $42, YOUNGSTER + $C8, $3 ; trainer
    db SPRITE_LASS, $4 + 4, $1e + 4, $ff, $d0, $43, LASS + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $1f + 4, $18 + 4, $ff, $d1, $44, SUPER_NERD + $C8, $1 ; trainer
    db SPRITE_LASS, $17 + 4, $10 + 4, $ff, $d0, $45, LASS + $C8, $6 ; trainer
    db SPRITE_BUG_CATCHER, $16 + 4, $7 + 4, $ff, $d0, $46, BUG_CATCHER + $C8, $7 ; trainer
    db SPRITE_BUG_CATCHER, $1b + 4, $1e + 4, $ff, $d3, $47, BUG_CATCHER + $C8, $8 ; trainer
	db SPRITE_BALL, $14 + 4, $2 + 4, $ff, $ff, $88, POTION ; item
	db SPRITE_BALL, $2 + 4, $2 + 4, $ff, $ff, $89, MOON_STONE ; item
	db SPRITE_BALL, $1f + 4, $23 + 4, $ff, $ff, $8a, RARE_CANDY ; item
	db SPRITE_BALL, $17 + 4, $24 + 4, $ff, $ff, $8b, ESCAPE_ROPE ; item
	db SPRITE_BALL, $21 + 4, $14 + 4, $ff, $ff, $8c, POTION ; item
	db SPRITE_BALL, $20 + 4, $5 + 4, $ff, $ff, $8d, TM_12 ; item

    ; warp-to
    EVENT_DISP $14, $23, $e
    EVENT_DISP $14, $23, $f
    EVENT_DISP $14, $5, $5 ; MT_MOON_2
    EVENT_DISP $14, $b, $11 ; MT_MOON_2
    EVENT_DISP $14, $f, $19 ; MT_MOON_2

MtMoon1Blocks: ; 360
    INCBIN "maps/mtmoon1.blk"

MtMoon3_h: ; 0x49cff to 0x49d0b (12 bytes) (id=61)
    db $11 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw MtMoon3Blocks, $5e34, $5d0b ; blocks, texts, scripts
    db $00 ; connections

    dw $5fdb ; objects

INCBIN "baserom.gbc",$49d0b,$49e79 - $49d0b
MtMoon3Text1: ; 0x49e79
    db $08 ; asm
    ld a, [$d7f6]
    bit 1, a
    jr z, .asm_be1e0 ; 0x49e7f
    and $c0
    jr nz, .asm_f8cd4 ; 0x49e83
    ld hl, $5f8f
    call PrintText
    jr .asm_f1fba ; 0x49e8b
.asm_be1e0 ; 0x49e8d
    ld hl, $5f85
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $5f8a
    ld de, $5f8a
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $3
    ld [$d607], a
    ld [$da39], a
    jr .asm_f1fba ; 0x49eb6
.asm_f8cd4 ; 0x49eb8
    ld hl, $5f94
    call PrintText
.asm_f1fba ; 0x49ebe
    jp $24d7

MtMoon3Text2: ; 0x49ec1
    db $08 ; asm
    ld hl, $5e48
    call LoadTrainerHeader
    jp $24d7

MtMoon3Text3: ; 0x49ecb
    db $08 ; asm
    ld hl, $5e54
    call LoadTrainerHeader
    jp $24d7

MtMoon3Text4: ; 0x49ed5
    db $08 ; asm
    ld hl, $5e60
    call LoadTrainerHeader
    jp $24d7

MtMoon3Text5: ; 0x49edf
    db $08 ; asm
    ld hl, $5e6c
    call LoadTrainerHeader
    jp $24d7

MtMoon3Text6: ; 0x49ee9
    db $08 ; asm
    ld a, $1
    ld [$cc3c], a
    ld hl, $5f24
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_1fa5e ; 0x49efc
    ld bc,(DOME_FOSSIL << 8) | 1
    call $3e2e
    jp nc, $5f76
    call $5f69
    ld a, $6d
    ld [$cc4d], a
    ld a, $11
    call Predef
    ld hl, $d7f6
    set 6, [hl]
    ld a, $4
    ld [$d607], a
    ld [$da39], a
.asm_1fa5e ; 0x49f21
    jp $24d7

INCBIN "baserom.gbc",$49f24,$49f29 - $49f24
MtMoon3Text7: ; 0x49f29
    db $08 ; asm
    ld a, $1
    ld [$cc3c], a
    ld hl, $5f64
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_8e988 ; 0x49f3c
    ld bc,(HELIX_FOSSIL << 8) | 1
    call $3e2e
    jp nc, $5f76
    call $5f69
    ld a, $6e
    ld [$cc4d], a
    ld a, $11
    call Predef
    ld hl, $d7f6
    set 7, [hl]
    ld a, $4
    ld [$d607], a
    ld [$da39], a
.asm_8e988 ; 0x49f61
    jp $24d7

INCBIN "baserom.gbc",$49f64,$77

MtMoon3Object: ; 0x49fdb (size=102)
    db $3 ; border tile

    db $4 ; warps
    db $9, $19, $1, MT_MOON_2
    db $11, $15, $4, MT_MOON_2
    db $1b, $f, $5, MT_MOON_2
    db $7, $5, $6, MT_MOON_2

    db $0 ; signs

    db $9 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $c + 4, $ff, $d3, $41, SUPER_NERD + $C8, $2 ; trainer
    db SPRITE_ROCKET, $10 + 4, $b + 4, $ff, $d0, $42, ROCKET + $C8, $1 ; trainer
    db SPRITE_ROCKET, $16 + 4, $f + 4, $ff, $d0, $43, ROCKET + $C8, $2 ; trainer
    db SPRITE_ROCKET, $b + 4, $1d + 4, $ff, $d1, $44, ROCKET + $C8, $3 ; trainer
    db SPRITE_ROCKET, $11 + 4, $1d + 4, $ff, $d2, $45, ROCKET + $C8, $4 ; trainer
    db SPRITE_OMANYTE, $6 + 4, $c + 4, $ff, $ff, $6 ; person
    db SPRITE_OMANYTE, $6 + 4, $d + 4, $ff, $ff, $7 ; person
	db SPRITE_BALL, $15 + 4, $19 + 4, $ff, $ff, $88, HP_UP ; item
	db SPRITE_BALL, $5 + 4, $1d + 4, $ff, $ff, $89, TM_01 ; item

    ; warp-to
    EVENT_DISP $14, $9, $19 ; MT_MOON_2
    EVENT_DISP $14, $11, $15 ; MT_MOON_2
    EVENT_DISP $14, $1b, $f ; MT_MOON_2
    EVENT_DISP $14, $7, $5 ; MT_MOON_2

MtMoon3Blocks: ; 360
    INCBIN "maps/mtmoon3.blk"

SafariZoneWest_h: ; 0x4a1a9 to 0x4a1b5 (12 bytes) (id=219)
    db $03 ; tileset
    db $0d, $0f ; dimensions (y, x)
    dw SafariZoneWestBlocks, $61b8, $61b5 ; blocks, texts, scripts
    db $00 ; connections

    dw $61dc ; objects

INCBIN "baserom.gbc",$4a1b5,$4a1c8 - $4a1b5

SafariZoneWestText5: ; 0x4a1c8
    TX_FAR _SafariZoneWestText5
    db $50

SafariZoneWestText6: ; 0x4a1cd
    TX_FAR _SafariZoneWestText6
    db $50

SafariZoneWestText7: ; 0x4a1d2
    TX_FAR _SafariZoneWestText7
    db $50

SafariZoneWestText8: ; 0x4a1d7
    TX_FAR _SafariZoneWestText8
    db $50

SafariZoneWestObject: ; 0x4a1dc (size=108)
    db $0 ; border tile

    db $8 ; warps
    db $0, $14, $0, SAFARI_ZONE_NORTH
    db $0, $15, $1, SAFARI_ZONE_NORTH
    db $0, $1a, $2, SAFARI_ZONE_NORTH
    db $0, $1b, $3, SAFARI_ZONE_NORTH
    db $16, $1d, $2, SAFARI_ZONE_CENTER
    db $17, $1d, $3, SAFARI_ZONE_CENTER
    db $3, $3, $0, SAFARI_ZONE_SECRET_HOUSE
    db $b, $b, $0, SAFARI_ZONE_REST_HOUSE_2

    db $4 ; signs
    db $c, $c, $5 ; SafariZoneWestText5
    db $3, $11, $6 ; SafariZoneWestText6
    db $4, $1a, $7 ; SafariZoneWestText7
    db $16, $18, $8 ; SafariZoneWestText8

    db $4 ; people
	db SPRITE_BALL, $14 + 4, $8 + 4, $ff, $ff, $81, MAX_POTION ; item
	db SPRITE_BALL, $7 + 4, $9 + 4, $ff, $ff, $82, TM_32 ; item
	db SPRITE_BALL, $12 + 4, $12 + 4, $ff, $ff, $83, MAX_REVIVE ; item
	db SPRITE_BALL, $7 + 4, $13 + 4, $ff, $ff, $84, GOLD_TEETH ; item

    ; warp-to
    EVENT_DISP $f, $0, $14 ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $0, $15 ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $0, $1a ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $0, $1b ; SAFARI_ZONE_NORTH
    EVENT_DISP $f, $16, $1d ; SAFARI_ZONE_CENTER
    EVENT_DISP $f, $17, $1d ; SAFARI_ZONE_CENTER
    EVENT_DISP $f, $3, $3 ; SAFARI_ZONE_SECRET_HOUSE
    EVENT_DISP $f, $b, $b ; SAFARI_ZONE_REST_HOUSE_2

SafariZoneWestBlocks: ; 195
    INCBIN "maps/safarizonewest.blk"

SafariZoneSecretHouse_h: ; 0x4a30b to 0x4a317 (12 bytes) (id=222)
    db $14 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw SafariZoneSecretHouseBlocks, $631a, $6317 ; blocks, texts, scripts
    db $00 ; connections

    dw $6365 ; objects

INCBIN "baserom.gbc",$4a317,$4a31c - $4a317
SafariZoneSecretHouseText1: ; 0x4a31c
    db $08 ; asm
    ld a, [$d857]
    bit 0, a
    jr nz, .asm_20a9b ; 0x4a322
    ld hl, $6350
    call PrintText
    ld bc,(HM_03 << 8) | 1
    call $3e2e
    jr nc, .asm_a21d2 ; 0x4a330
    ld hl, $6355
    call PrintText
    ld hl, $d857
    set 0, [hl]
    jr .asm_8f1fc ; 0x4a33d
.asm_a21d2 ; 0x4a33f
    ld hl, $6360
    call PrintText
    jr .asm_8f1fc ; 0x4a345
.asm_20a9b ; 0x4a347
    ld hl, $635b
    call PrintText
.asm_8f1fc ; 0x4a34d
    jp $24d7

INCBIN "baserom.gbc",$4a350,$15
SafariZoneSecretHouseObject: ; 0x4a365 (size=26)
    db $17 ; border tile

    db $2 ; warps
    db $7, $2, $6, SAFARI_ZONE_WEST
    db $7, $3, $6, SAFARI_ZONE_WEST

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $3 + 4, $3 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; SAFARI_ZONE_WEST
    EVENT_DISP $4, $7, $3 ; SAFARI_ZONE_WEST

SafariZoneSecretHouseBlocks: ; 16
    INCBIN "maps/safarizonesecrethouse.blk"

INCBIN "baserom.gbc",$4a38f,$1c71

SECTION "bank13",DATA,BANK[$13]

YoungsterPic:
	INCBIN "pic/trainer/youngster.pic"
BugCatcherPic:
	INCBIN "pic/trainer/bugcatcher.pic"
LassPic:
	INCBIN "pic/trainer/lass.pic"
SailorPic:
	INCBIN "pic/trainer/sailor.pic"
JrTrainerMPic:
	INCBIN "pic/trainer/jr.trainerm.pic"
JrTrainerFPic:
	INCBIN "pic/trainer/jr.trainerf.pic"
PokemaniacPic:
	INCBIN "pic/trainer/pokemaniac.pic"
SuperNerdPic:
	INCBIN "pic/trainer/supernerd.pic"
HikerPic:
	INCBIN "pic/trainer/hiker.pic"
BikerPic:
	INCBIN "pic/trainer/biker.pic"
BurglarPic:
	INCBIN "pic/trainer/burglar.pic"
EngineerPic:
	INCBIN "pic/trainer/engineer.pic"
FisherPic:
	INCBIN "pic/trainer/fisher.pic"
SwimmerPic:
	INCBIN "pic/trainer/swimmer.pic"
CueBallPic:
	INCBIN "pic/trainer/cueball.pic"
GamblerPic:
	INCBIN "pic/trainer/gambler.pic"
BeautyPic:
	INCBIN "pic/trainer/beauty.pic"
PsychicPic:
	INCBIN "pic/trainer/psychic.pic"
RockerPic:
	INCBIN "pic/trainer/rocker.pic"
JugglerPic:
	INCBIN "pic/trainer/juggler.pic"
TamerPic:
	INCBIN "pic/trainer/tamer.pic"
BirdKeeperPic:
	INCBIN "pic/trainer/birdkeeper.pic"
BlackbeltPic:
	INCBIN "pic/trainer/blackbelt.pic"
Rival1Pic:
	INCBIN "pic/trainer/rival1.pic"
ProfOakPic:
	INCBIN "pic/trainer/prof.oak.pic"
ChiefPic:
ScientistPic:
	INCBIN "pic/trainer/scientist.pic"
GiovanniPic:
	INCBIN "pic/trainer/giovanni.pic"
RocketPic:
	INCBIN "pic/trainer/rocket.pic"
CooltrainerMPic:
	INCBIN "pic/trainer/cooltrainerm.pic"
CooltrainerFPic:
	INCBIN "pic/trainer/cooltrainerf.pic"
BrunoPic:
	INCBIN "pic/trainer/bruno.pic"
BrockPic:
	INCBIN "pic/trainer/brock.pic"
MistyPic:
	INCBIN "pic/trainer/misty.pic"
LtSurgePic:
	INCBIN "pic/trainer/lt.surge.pic"
ErikaPic:
	INCBIN "pic/trainer/erika.pic"
KogaPic:
	INCBIN "pic/trainer/koga.pic"
BlainePic:
	INCBIN "pic/trainer/blaine.pic"
SabrinaPic:
	INCBIN "pic/trainer/sabrina.pic"
GentlemanPic:
	INCBIN "pic/trainer/gentleman.pic"
Rival2Pic:
	INCBIN "pic/trainer/rival2.pic"
Rival3Pic:
	INCBIN "pic/trainer/rival3.pic"
LoreleiPic:
	INCBIN "pic/trainer/lorelei.pic"
ChannelerPic:
	INCBIN "pic/trainer/channeler.pic"
AgathaPic:
	INCBIN "pic/trainer/agatha.pic"
LancePic:
	INCBIN "pic/trainer/lance.pic"

BattleCenterM_h: ; 0x4fd04 to 0x4fd10 (12 bytes) (id=239)
    db $15 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw BattleCenterMBlocks, $7d4c, $7d10 ; blocks, texts, scripts
    db $00 ; connections

    dw $7d53 ; objects

INCBIN "baserom.gbc",$4fd10,$4fd4c - $4fd10
BattleCenterMTexts: ; 0x4fd4c
    dw BattleCenterMText1

BattleCenterMText1: ; 0x4fd4e
    TX_FAR _BattleCenterMText1
    db $50

BattleCenterMObject: ; 0x4fd53 (size=10)
    db $e ; border tile

    db $0 ; warps

    db $0 ; signs

    db $1 ; people
    db SPRITE_RED, $2 + 4, $2 + 4, $ff, $0, $1 ; person

BattleCenterMBlocks: ; 20
    INCBIN "maps/battlecenterm.blk"

TradeCenterM_h: ; 0x4fd71 to 0x4fd7d (12 bytes) (id=240)
    db $15 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw TradeCenterMBlocks, $7d80, $7d7d ; blocks, texts, scripts
    db $00 ; connections

    dw $7d87 ; objects

INCBIN "baserom.gbc",$4fd7d,$4fd80 - $4fd7d
TradeCenterMTexts: ; 0x4fd80
    dw TradeCenterMText1

TradeCenterMText1: ; 0x4fd82
    TX_FAR _TradeCenterMText1
    db $50

TradeCenterMObject: ; 0x4fd87 (size=10)
    db $e ; border tile

    db $0 ; warps

    db $0 ; signs

    db $1 ; people
    db SPRITE_RED, $2 + 4, $2 + 4, $ff, $0, $1 ; person

TradeCenterMBlocks: ; 20
    INCBIN "maps/tradecenterm.blk"

INCBIN "baserom.gbc",$4fda5,$a4

GetPredefPointer: ; 7E49
; stores hl in $CC4F,$CC50
; stores de in $CC51,$CC52
; stores bc in $CC53,$CC54
; grabs a byte "n" from $CC4E,
;    and gets the nth (3-byte) pointer in PredefPointers
; stores the bank of said pointer in [$D0B7]
; stores the pointer in hl and returns
        ; ld $CC4F,hl
        ld a,h
        ld [$CC4F],a
        ld a,l
        ld [$CC50],a

        ; ld $CC51,de
        ld hl,$CC51
        ld a,d
        ld [hli],a
        ld a,e
        ld [hli],a

        ; ld $CC53,bc
        ld a,b
        ld [hli],a
        ld [hl],c

        ld hl,PredefPointers
        ld de,0

        ; de = 3 * [$CC4E]
        ld a,[$CC4E]
        ld e,a
        add a,a
        add a,e
        ld e,a
        jr nc,.next\@
        inc d

.next\@
        add hl,de
        ld d,h
        ld e,l

	; get bank of predef routine
        ld a,[de]
        ld [$D0B7],a

	; get pointer
        inc de
        ld a,[de]
        ld l,a
        inc de
        ld a,[de]
        ld h,a

        ret

PredefPointers: ; 7E79
; these are pointers to ASM routines.
; they appear to be used in overworld map scripts.
        dbw $0F,$4D60
        dbw $0F,$70C6
        dbw $0F,$7073
        dbw $0B,$7E40
        dbw $0F,$7103
        dbw $1E,$5ABA
        dbw $03,$7132
        dbw $03,$76A5
        dbw BANK(AttackAnimation),AttackAnimation; 08 play attack animation
        dbw $03,$771E
        dbw $03,$771E
        dbw $03,$781D
        dbw $03,$7836
        dbw $03,$771E
        dbw $03,$771E
        dbw $03,$7850
        dbw $03,$7666
        dbw $03,$71D7
        dbw $03,$71A6
        dbw $03,$469C
        dbw $0F,$4A83
        dbw $03,$71C8
        dbw $03,$71C8
        dbw $03,$6E9E
        dbw $03,$7850
        dbw $03,$4754
        dbw $0E,$6F5B
        dbw $01,$6E43
        dbw $03,$78A5; 1C, used in Pokémon Tower
        dbw $03,$3EB5
        dbw $03,$3E2E
        dbw $12,$40EB
        dbw $03,$78BA
        dbw $12,$40FF
        dbw $03,$7929
        dbw $03,$79A0
        dbw $12,$4125
        dbw $03,$7A1D
        dbw $03,$79DC
        dbw $01,$5AB0
        dbw $0F,$6D02
        dbw $10,$4000
        dbw $0E,$6D1C
        dbw $1C,$778C
        dbw $0F,$6F18
        dbw $01,$5A5F
        dbw $03,$6A03
        dbw $10,$50F3
        dbw $1C,$496D
        dbw $1E,$5DDA
        dbw $10,$5682
        dbw $1E,$5869
        dbw $1C,$4B5D
        dbw $03,$4586
        dbw $04,$6953
        dbw $04,$6B57
        dbw $10,$50E2
        dbw $15,$690F
        dbw $10,$5010
        dbw BANK(Predef3B),Predef3B; 3B display pic?
        dbw $03,$6F54
        dbw $10,$42D1
        dbw $0E,$6FB8
        dbw $1C,$770A
        dbw $1C,$602B
        dbw $03,$7113
	dbw $17,$5B5E
        dbw $04,$773E
        dbw $04,$7763
        dbw $1C,$5DDF
        dbw $17,$40DC; 46 load dex screen
        dbw $03,$72E5
        dbw $03,$7A1D
        dbw $0F,$4DEC
        dbw $1C,$4F60
        dbw $09,$7D6B
        dbw $05,$7C47; 4C player exclamation
        dbw $01,$5AAF
        dbw $01,$64EB
        dbw $0D,$7CA1
        dbw $1C,$780F
        dbw $1C,$76BD
        dbw $1C,$75E8
        dbw $1C,$77E2
        dbw BANK(Predef54),Predef54 ; 54 initiate trade
        dbw $1D,$405C
        dbw $11,$4169
        dbw $1E,$45BA
        dbw $1E,$4510
        dbw $03,$45BE
        dbw $03,$460B
        dbw $03,$4D99
        dbw $01,$4DE1
        dbw $09,$7D98
        dbw $03,$7473
        dbw $04,$68EF
        dbw $04,$68F6
        dbw $07,$49C6
        dbw $16,$5035

SECTION "bank14",DATA,BANK[$14]
Route22_h: ; 0x50000 to 0x50022 (34 bytes) (id=33)
    db $00 ; tileset
    db $09, $14 ; dimensions (y, x)
    dw Route22Blocks, $5175, $4eb2 ; blocks, texts, scripts
    db NORTH | EAST ; connections

    ; connections data

	db ROUTE_23
    dw $4664, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $8f, $00 ; alignments (y, x)
    dw $cb69 ; window

	db VIRIDIAN_CITY
    dw $4400, $c6ff ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $00 ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $4022 ; objects

Route22Object: ; 0x50022 (size=27)
    db $2c ; border tile

    db $1 ; warps
    db $5, $8, $0, ROUTE_22_GATE

    db $1 ; signs
    db $b, $7, $3 ; Route22Text3

    db $2 ; people
    db SPRITE_BLUE, $5 + 4, $19 + 4, $ff, $ff, $1 ; person
    db SPRITE_BLUE, $5 + 4, $19 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $14, $5, $8 ; ROUTE_22_GATE

Route22Blocks: ; 180
    INCBIN "maps/route22.blk"

Route20_h: ; 0x500f1 to 0x50113 (34 bytes) (id=31)
    db $00 ; tileset
    db $09, $32 ; dimensions (y, x)
    dw Route20Blocks, $4d22, $4ca9 ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db CINNABAR_ISLAND
    dw $4070, $c790 ; pointers (connected, current) (strip)
    db $09, $0a ; bigness, width
    db $00, $13 ; alignments (y, x)
    dw $c702 ; window

	db ROUTE_19
    dw $4f87, $c71d ; pointers (connected, current) (strip)
    db $0c, $0a ; bigness, width
    db $24, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $4113 ; objects

Route20Object: ; 0x50113 (size=106)
    db $43 ; border tile

    db $2 ; warps
    db $5, $30, $0, SEAFOAM_ISLANDS_1
    db $9, $3a, $2, SEAFOAM_ISLANDS_1

    db $2 ; signs
    db $7, $33, $b ; Route20Text11
    db $b, $39, $c ; Route20Text12

    db $a ; people
    db SPRITE_SWIMMER, $8 + 4, $57 + 4, $ff, $d1, $41, SWIMMER + $C8, $9 ; trainer
    db SPRITE_SWIMMER, $b + 4, $44 + 4, $ff, $d1, $42, BEAUTY + $C8, $f ; trainer
    db SPRITE_SWIMMER, $a + 4, $2d + 4, $ff, $d0, $43, BEAUTY + $C8, $6 ; trainer
    db SPRITE_SWIMMER, $e + 4, $37 + 4, $ff, $d3, $44, JR__TRAINER_F + $C8, $18 ; trainer
    db SPRITE_SWIMMER, $d + 4, $26 + 4, $ff, $d0, $45, SWIMMER + $C8, $a ; trainer
    db SPRITE_SWIMMER, $d + 4, $57 + 4, $ff, $d1, $46, SWIMMER + $C8, $b ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $9 + 4, $22 + 4, $ff, $d1, $47, BIRD_KEEPER + $C8, $b ; trainer
    db SPRITE_SWIMMER, $7 + 4, $19 + 4, $ff, $d1, $48, BEAUTY + $C8, $7 ; trainer
    db SPRITE_SWIMMER, $c + 4, $18 + 4, $ff, $d0, $49, JR__TRAINER_F + $C8, $10 ; trainer
    db SPRITE_SWIMMER, $8 + 4, $f + 4, $ff, $d1, $4a, BEAUTY + $C8, $8 ; trainer

    ; warp-to
    EVENT_DISP $32, $5, $30 ; SEAFOAM_ISLANDS_1
    EVENT_DISP $32, $9, $3a ; SEAFOAM_ISLANDS_1

Route20Blocks: ; 450
    INCBIN "maps/route20.blk"

Route23_h: ; 0x5033f to 0x50361 (34 bytes) (id=34)
    db $17 ; tileset
    db $48, $0a ; dimensions (y, x)
    dw Route23Blocks, $52f7, $51da ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db INDIGO_PLATEAU
    dw $4986, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $11, $00 ; alignments (y, x)
    dw $c779 ; window

	db ROUTE_22
    dw $403d, $cb9b ; pointers (connected, current) (strip)
    db $0d, $14 ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $4361 ; objects

Route23Object: ; 0x50361 (size=81)
    db $f ; border tile

    db $4 ; warps
    db $8b, $7, $2, ROUTE_22_GATE
    db $8b, $8, $3, ROUTE_22_GATE
    db $1f, $4, $0, VICTORY_ROAD_1
    db $1f, $e, $1, VICTORY_ROAD_2

    db $1 ; signs
    db $21, $3, $8 ; Route23Text8

    db $7 ; people
    db SPRITE_GUARD, $23 + 4, $4 + 4, $ff, $d0, $1 ; person
    db SPRITE_GUARD, $38 + 4, $a + 4, $ff, $d0, $2 ; person
    db SPRITE_SWIMMER, $55 + 4, $8 + 4, $ff, $d0, $3 ; person
    db SPRITE_SWIMMER, $60 + 4, $b + 4, $ff, $d0, $4 ; person
    db SPRITE_GUARD, $69 + 4, $c + 4, $ff, $d0, $5 ; person
    db SPRITE_GUARD, $77 + 4, $8 + 4, $ff, $d0, $6 ; person
    db SPRITE_GUARD, $88 + 4, $8 + 4, $ff, $d0, $7 ; person

    ; warp-to
    EVENT_DISP $a, $8b, $7 ; ROUTE_22_GATE
    EVENT_DISP $a, $8b, $8 ; ROUTE_22_GATE
    EVENT_DISP $a, $1f, $4 ; VICTORY_ROAD_1
    EVENT_DISP $a, $1f, $e ; VICTORY_ROAD_2

Route23Blocks: ; 720
    INCBIN "maps/route23.blk"

Route24_h: ; 0x50682 to 0x506a4 (34 bytes) (id=35)
    db $00 ; tileset
    db $12, $0a ; dimensions (y, x)
    dw Route24Blocks, $544b, $53ad ; blocks, texts, scripts
    db SOUTH | EAST ; connections

    ; connections data

	db CERULEAN_CITY
    dw $4832, $c838 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $00, $0a ; alignments (y, x)
    dw $c703 ; window

	db ROUTE_25
    dw $4810, $c725 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $46a4 ; objects

Route24Object: ; 0x506a4 (size=67)
    db $2c ; border tile

    db $0 ; warps

    db $0 ; signs

    db $8 ; people
    db SPRITE_BLACK_HAIR_BOY_1, $f + 4, $b + 4, $ff, $d2, $41, ROCKET + $C8, $6 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $14 + 4, $5 + 4, $ff, $d1, $42, JR__TRAINER_M + $C8, $2 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $13 + 4, $b + 4, $ff, $d2, $43, JR__TRAINER_M + $C8, $3 ; trainer
    db SPRITE_LASS, $16 + 4, $a + 4, $ff, $d3, $44, LASS + $C8, $7 ; trainer
    db SPRITE_BUG_CATCHER, $19 + 4, $b + 4, $ff, $d2, $45, YOUNGSTER + $C8, $4 ; trainer
    db SPRITE_LASS, $1c + 4, $a + 4, $ff, $d3, $46, LASS + $C8, $8 ; trainer
    db SPRITE_BUG_CATCHER, $1f + 4, $b + 4, $ff, $d2, $47, BUG_CATCHER + $C8, $9 ; trainer
	db SPRITE_BALL, $5 + 4, $a + 4, $ff, $ff, $88, TM_45 ; item

Route24Blocks: ; 180
    INCBIN "maps/route24.blk"

Route25_h: ; 0x5079b to 0x507b2 (23 bytes) (id=36)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route25Blocks, $5628, $55cb ; blocks, texts, scripts
    db WEST ; connections

    ; connections data

	db ROUTE_24
    dw $46ee, $c754 ; pointers (connected, current) (strip)
    db $0c, $0a ; bigness, width
    db $00, $13 ; alignments (y, x)
    dw $c702 ; window

    ; end connection data

    dw $47b2 ; objects

Route25Object: ; 0x507b2 (size=94)
    db $2c ; border tile

    db $1 ; warps
    db $3, $2d, $0, BILLS_HOUSE

    db $1 ; signs
    db $3, $2b, $b ; Route25Text11

    db $a ; people
    db SPRITE_BUG_CATCHER, $2 + 4, $e + 4, $ff, $d0, $41, YOUNGSTER + $C8, $5 ; trainer
    db SPRITE_BUG_CATCHER, $5 + 4, $12 + 4, $ff, $d1, $42, YOUNGSTER + $C8, $6 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $4 + 4, $18 + 4, $ff, $d0, $43, JR__TRAINER_M + $C8, $2 ; trainer
    db SPRITE_LASS, $8 + 4, $12 + 4, $ff, $d3, $44, LASS + $C8, $9 ; trainer
    db SPRITE_BUG_CATCHER, $3 + 4, $20 + 4, $ff, $d2, $45, YOUNGSTER + $C8, $7 ; trainer
    db SPRITE_LASS, $4 + 4, $25 + 4, $ff, $d0, $46, LASS + $C8, $a ; trainer
    db SPRITE_HIKER, $4 + 4, $8 + 4, $ff, $d3, $47, HIKER + $C8, $2 ; trainer
    db SPRITE_HIKER, $9 + 4, $17 + 4, $ff, $d1, $48, HIKER + $C8, $3 ; trainer
    db SPRITE_HIKER, $7 + 4, $d + 4, $ff, $d3, $49, HIKER + $C8, $4 ; trainer
	db SPRITE_BALL, $2 + 4, $16 + 4, $ff, $ff, $8a, TM_19 ; item

    ; warp-to
    EVENT_DISP $1e, $3, $2d ; BILLS_HOUSE

Route25Blocks: ; 270
    INCBIN "maps/route25.blk"

IndigoPlateau_h: ; 0x5091e to 0x50935 (23 bytes) (id=9)
    db $17 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw IndigoPlateauBlocks, $4936, $4935 ; blocks, texts, scripts
    db SOUTH ; connections

    ; connections data

	db ROUTE_23
    dw $43b2, $c7ab ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $4936 ; objects

INCBIN "baserom.gbc",$50935,$50936 - $50935
IndigoPlateauObject: ; 0x50936 (size=20)
    db $e ; border tile

    db $2 ; warps
    db $5, $9, $0, INDIGO_PLATEAU_LOBBY
    db $5, $a, $0, INDIGO_PLATEAU_LOBBY

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $a, $5, $9 ; INDIGO_PLATEAU_LOBBY
    EVENT_DISP $a, $5, $a ; INDIGO_PLATEAU_LOBBY

IndigoPlateauBlocks: ; 90
    INCBIN "maps/indigoplateau.blk"

SaffronCity_h: ; 0x509a4 to 0x509dc (56 bytes) (id=10)
    db $00 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw SaffronCityBlocks, $4c03, $4c00 ; blocks, texts, scripts
    db NORTH | SOUTH | WEST | EAST ; connections

    ; connections data

	db ROUTE_5
    dw $4668, $c6f0 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $23, $f6 ; alignments (y, x)
    dw $c809 ; window

	db ROUTE_6
    dw $4079, $c912 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $f6 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_7
    dw $4058, $c79e ; pointers (connected, current) (strip)
    db $09, $0a ; bigness, width
    db $f8, $13 ; alignments (y, x)
    dw $c702 ; window

	db ROUTE_8
    dw $41c6, $c7b5 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $f8, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $49dc ; objects

SaffronCityObject: ; 0x509dc (size=188)
    db $f ; border tile

    db $8 ; warps
    db $5, $7, $0, COPYCATS_HOUSE_1F
    db $3, $1a, $0, FIGHTINGDOJO
    db $3, $22, $0, SAFFRON_GYM
    db $b, $d, $0, SAFFRON_HOUSE_1
    db $b, $19, $0, SAFFRON_MART
    db $15, $12, $0, SILPH_CO_1F
    db $1d, $9, $0, SAFFRON_POKECENTER
    db $1d, $1d, $0, SAFFRON_HOUSE_2

    db $a ; signs
    db $5, $11, $10 ; SaffronCityText16
    db $5, $1b, $11 ; SaffronCityText17
    db $5, $23, $12 ; SaffronCityText18
    db $b, $1a, $13 ; SaffronCityText19
    db $13, $27, $14 ; SaffronCityText20
    db $15, $5, $15 ; SaffronCityText21
    db $15, $f, $16 ; SaffronCityText22
    db $1d, $a, $17 ; SaffronCityText23
    db $1d, $1b, $18 ; SaffronCityText24
    db $13, $1, $19 ; SaffronCityText25

    db $f ; people
    db SPRITE_ROCKET, $6 + 4, $7 + 4, $ff, $ff, $1 ; person
    db SPRITE_ROCKET, $8 + 4, $14 + 4, $fe, $2, $2 ; person
    db SPRITE_ROCKET, $4 + 4, $22 + 4, $ff, $ff, $3 ; person
    db SPRITE_ROCKET, $c + 4, $d + 4, $ff, $ff, $4 ; person
    db SPRITE_ROCKET, $19 + 4, $b + 4, $fe, $2, $5 ; person
    db SPRITE_ROCKET, $d + 4, $20 + 4, $fe, $2, $6 ; person
    db SPRITE_ROCKET, $1e + 4, $12 + 4, $fe, $2, $7 ; person
    db SPRITE_OAK_AIDE, $e + 4, $8 + 4, $fe, $0, $8 ; person
    db SPRITE_LAPRAS_GIVER, $17 + 4, $17 + 4, $ff, $ff, $9 ; person
    db SPRITE_ERIKA, $1e + 4, $11 + 4, $fe, $2, $a ; person
    db SPRITE_GENTLEMAN, $c + 4, $1e + 4, $ff, $d0, $b ; person
    db SPRITE_BIRD, $c + 4, $1f + 4, $ff, $d0, $c ; person
    db SPRITE_ROCKER, $8 + 4, $12 + 4, $ff, $d1, $d ; person
    db SPRITE_ROCKET, $16 + 4, $12 + 4, $ff, $d0, $e ; person
    db SPRITE_ROCKET, $16 + 4, $13 + 4, $ff, $d0, $f ; person

    ; warp-to
    EVENT_DISP $14, $5, $7 ; COPYCATS_HOUSE_1F
    EVENT_DISP $14, $3, $1a ; FIGHTINGDOJO
    EVENT_DISP $14, $3, $22 ; SAFFRON_GYM
    EVENT_DISP $14, $b, $d ; SAFFRON_HOUSE_1
    EVENT_DISP $14, $b, $19 ; SAFFRON_MART
    EVENT_DISP $14, $15, $12 ; SILPH_CO_1F
    EVENT_DISP $14, $1d, $9 ; SAFFRON_POKECENTER
    EVENT_DISP $14, $1d, $1d ; SAFFRON_HOUSE_2

SaffronCityBlocks: ; 360
    INCBIN "maps/saffroncity.blk"

INCBIN "baserom.gbc",$50c00,$50c35 - $50c00

SaffronCityText1: ; 0x50c35
    TX_FAR _SaffronCityText1
    db $50

SaffronCityText2: ; 0x50c3a
    TX_FAR _SaffronCityText2
    db $50

SaffronCityText3: ; 0x50c3f
    TX_FAR _SaffronCityText3
    db $50

SaffronCityText4: ; 0x50c44
    TX_FAR _SaffronCityText4
    db $50

SaffronCityText5: ; 0x50c49
    TX_FAR _SaffronCityText5
    db $50

SaffronCityText6: ; 0x50c4e
    TX_FAR _SaffronCityText6
    db $50

SaffronCityText7: ; 0x50c53
    TX_FAR _SaffronCityText7
    db $50

SaffronCityText8: ; 0x50c58
    TX_FAR _SaffronCityText8
    db $50

SaffronCityText9: ; 0x50c5d
    TX_FAR _SaffronCityText9
    db $50

SaffronCityText10: ; 0x50c62
    TX_FAR _SaffronCityText10
    db $50

SaffronCityText11: ; 0x50c67
    TX_FAR _SaffronCityText11
    db $50

SaffronCityText12: ; 0x50c6c
    TX_FAR _SaffronCityText12

INCBIN "baserom.gbc",$50c70,$50c72 - $50c70

SaffronCityText13: ; 0x50c72
    TX_FAR _SaffronCityText13
    db $50

SaffronCityText14: ; 0x50c77
    TX_FAR _SaffronCityText14
    db $50

SaffronCityText15: ; 0x50c7c
    TX_FAR _SaffronCityText15
    db $50

SaffronCityText16: ; 0x50c81
    TX_FAR _SaffronCityText16
    db $50

SaffronCityText17: ; 0x50c86
    TX_FAR _SaffronCityText17
    db $50

SaffronCityText18: ; 0x50c8b
    TX_FAR _SaffronCityText18
    db $50

SaffronCityText20: ; 0x50c90
    TX_FAR _SaffronCityText20
    db $50

SaffronCityText21: ; 0x50c95
    TX_FAR _SaffronCityText21
    db $50

SaffronCityText22: ; 0x50c9a
    TX_FAR _SaffronCityText22
    db $50

SaffronCityText24: ; 0x50c9f
    TX_FAR _SaffronCityText24
    db $50

SaffronCityText25: ; 0x50ca4
    TX_FAR _SaffronCityText25
    db $50

INCBIN "baserom.gbc",$50ca9,$50db3 - $50ca9
Route20Text1: ; 0x50db3
    db $08 ; asm
    ld hl, $4d3a
    call LoadTrainerHeader
    jp $24d7

Route20Text2: ; 0x50dbd
    db $08 ; asm
    ld hl, $4d46
    call LoadTrainerHeader
    jp $24d7

Route20Text3: ; 0x50dc7
    db $08 ; asm
    ld hl, $4d52
    call LoadTrainerHeader
    jp $24d7

Route20Text4: ; 0x50dd1
    db $08 ; asm
    ld hl, $4d5e
    call LoadTrainerHeader
    jp $24d7

Route20Text5: ; 0x50ddb
    db $08 ; asm
    ld hl, $4d6a
    call LoadTrainerHeader
    jp $24d7

Route20Text6: ; 0x50de5
    db $08 ; asm
    ld hl, $4d76
    call LoadTrainerHeader
    jp $24d7

Route20Text7: ; 0x50def
    db $08 ; asm
    ld hl, $4d82
    call LoadTrainerHeader
    jp $24d7

Route20Text8: ; 0x50df9
    db $08 ; asm
    ld hl, $4d8e
    call LoadTrainerHeader
    jp $24d7

Route20Text9: ; 0x50e03
    db $08 ; asm
    ld hl, $4d9a
    call LoadTrainerHeader
    jp $24d7

Route20Text10: ; 0x50e0d
    db $08 ; asm
    ld hl, $4da6
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$50e17,$96

Route20Text12:
Route20Text11: ; 0x50ead
    TX_FAR _Route20Text11
    db $50

INCBIN "baserom.gbc",$50eb2,$5117b - $50eb2
Route22Text1: ; 0x5117b
    db $08 ; asm
    ld a, [$d7eb]
    bit 5, a
    jr z, .asm_a88cf ; 0x51181
    ld hl, $51b2
    call PrintText
    jr .asm_48088 ; 0x51189
.asm_a88cf ; 0x5118b
    ld hl, $51ad
    call PrintText
.asm_48088 ; 0x51191
    jp $24d7

Route22Text2: ; 0x51194
    db $08 ; asm
    ld a, [$d7eb]
    bit 6, a
    jr z, .asm_58c0a ; 0x5119a
    ld hl, $51c6
    call PrintText
    jr .asm_673ee ; 0x511a2
.asm_58c0a ; 0x511a4
    ld hl, $51c1
    call PrintText
.asm_673ee ; 0x511aa
    jp $24d7

INCBIN "baserom.gbc",$511ad,$28

Route22Text3: ; 0x511d5
    TX_FAR _Route22Text3
    db $50

INCBIN "baserom.gbc",$511da,$51307 - $511da
Route23Text1: ; 0x51307
    db $08 ; asm
    ld a, $6
    call $5346
    jp $24d7

Route23Text2: ; 0x51310
    db $08 ; asm
    ld a, $5
    call $5346
    jp $24d7

Route23Text3: ; 0x51319
    db $08 ; asm
    ld a, $4
    call $5346
    jp $24d7

Route23Text4: ; 0x51322
    db $08 ; asm
    ld a, $3
    call $5346
    jp $24d7

Route23Text5: ; 0x5132b
    db $08 ; asm
    ld a, $2
    call $5346
    jp $24d7

Route23Text6: ; 0x51334
    db $08 ; asm
    ld a, $1
    call $5346
    jp $24d7

Route23Text7: ; 0x5133d
    db $8
    ld a, $0
    call $5346
    jp $24d7
; 0x51346

INCBIN "baserom.gbc",$51346,$62

Route23Text8: ; 0x513a8
    TX_FAR _Route23Text8
    db $50

INCBIN "baserom.gbc",$513ad,$514a4 - $513ad

Route24Text1: ; 0x514a4
    db $8
    ld hl, $d7f0
    res 1, [hl]
    ld a, [$d7ef]
    bit 0, a
    jr nz, .asm_a03f5 ; 0x514af $48
    ld hl, $5510
    call PrintText
    ld bc, $3101
    call GiveItem
    jr nc, .asm_3a23d ; 0x514bd $43
    ld hl, $d7ef
    set 0, [hl]
    ld hl, $551a
    call PrintText
    ld hl, $5526
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $552b
    ld de, $552b
    call $3354
    ld a, [$ff00+$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    xor a
    ld [$ff00+$b4], a
    ld a, $3
    ld [$d602], a
    ld [$da39], a
    jp $24d7
.asm_a03f5 ; 0x514f9
    ld hl, $5530
    call PrintText
    jp $24d7
.asm_3a23d ; 0x51502
    ld hl, $5521
    call PrintText
    ld hl, $d7f0
    set 1, [hl]
    jp $24d7
; 0x51510

INCBIN "baserom.gbc",$51510,$25

Route24Text2: ; 0x51535
    db $08 ; asm
    ld hl, $545b
    call LoadTrainerHeader
    jp $24d7

Route24Text3: ; 0x5153f
    db $08 ; asm
    ld hl, $5467
    call LoadTrainerHeader
    jp $24d7

Route24Text4: ; 0x51549
    db $08 ; asm
    ld hl, $5473
    call LoadTrainerHeader
    jp $24d7

Route24Text5: ; 0x51553
    db $08 ; asm
    ld hl, $547f
    call LoadTrainerHeader
    jp $24d7

Route24Text6: ; 0x5155d
    db $08 ; asm
    ld hl, $548b
    call LoadTrainerHeader
    jp $24d7

Route24Text7: ; 0x51567
    db $08 ; asm
    ld hl, $5497
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51571,$516ab - $51571
Route25Text1: ; 0x516ab
    db $08 ; asm
    ld hl, $563e
    call LoadTrainerHeader
    jp $24d7

Route25Text2: ; 0x516b5
    db $08 ; asm
    ld hl, $564a
    call LoadTrainerHeader
    jp $24d7

Route25Text3: ; 0x516bf
    db $08 ; asm
    ld hl, $5656
    call LoadTrainerHeader
    jp $24d7

Route25Text4: ; 0x516c9
    db $08 ; asm
    ld hl, $5662
    call LoadTrainerHeader
    jp $24d7

Route25Text5: ; 0x516d3
    db $08 ; asm
    ld hl, $566e
    call LoadTrainerHeader
    jp $24d7

Route25Text6: ; 0x516dd
    db $08 ; asm
    ld hl, $567a
    call LoadTrainerHeader
    jp $24d7

Route25Text7: ; 0x516e7
    db $08 ; asm
    ld hl, $5686
    call LoadTrainerHeader
    jp $24d7

Route25Text8: ; 0x516f1
    db $08 ; asm
    ld hl, $5692
    call LoadTrainerHeader
    jp $24d7

Route25Text9: ; 0x516fb
    db $08 ; asm
    ld hl, $569e
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51705,$87

Route25Text11: ; 0x5178c
    TX_FAR _Route25Text11
    db $50

VictoryRoad2_h: ; 0x51791 to 0x5179d (12 bytes) (id=194)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw VictoryRoad2Blocks, $581b, $579d ; blocks, texts, scripts
    db $00 ; connections

    dw $5915 ; objects

INCBIN "baserom.gbc",$5179d,$5187e - $5179d
VictoryRoad2Text1: ; 0x5187e
    db $08 ; asm
    ld hl, $5835
    call LoadTrainerHeader
    jp $24d7

VictoryRoad2Text2: ; 0x51888
    db $08 ; asm
    ld hl, $5841
    call LoadTrainerHeader
    jp $24d7

VictoryRoad2Text3: ; 0x51892
    db $08 ; asm
    ld hl, $584d
    call LoadTrainerHeader
    jp $24d7

VictoryRoad2Text4: ; 0x5189c
    db $08 ; asm
    ld hl, $5859
    call LoadTrainerHeader
    jp $24d7

VictoryRoad2Text5: ; 0x518a6
    db $08 ; asm
    ld hl, $5865
    call LoadTrainerHeader
    jp $24d7

VictoryRoad2Text6: ; 0x518b0
    db $08 ; asm
    ld hl, $5871
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$518ba,$5b
VictoryRoad2Object: ; 0x51915 (size=154)
    db $7d ; border tile

    db $7 ; warps
    db $8, $0, $2, VICTORY_ROAD_1
    db $7, $1d, $3, $ff
    db $8, $1d, $3, $ff
    db $7, $17, $0, VICTORY_ROAD_3
    db $e, $19, $2, VICTORY_ROAD_3
    db $7, $1b, $1, VICTORY_ROAD_3
    db $1, $1, $3, VICTORY_ROAD_3

    db $0 ; signs

    db $d ; people
    db SPRITE_HIKER, $9 + 4, $c + 4, $ff, $d2, $41, BLACKBELT + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $d + 4, $15 + 4, $ff, $d2, $42, JUGGLER + $C8, $2 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $8 + 4, $13 + 4, $ff, $d0, $43, TAMER + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $4 + 4, $ff, $d0, $44, POKEMANIAC + $C8, $6 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $3 + 4, $1a + 4, $ff, $d2, $45, JUGGLER + $C8, $5 ; trainer
    db SPRITE_BIRD, $5 + 4, $b + 4, $ff, $d1, $46, MOLTRES, $32 ; trainer
	db SPRITE_BALL, $5 + 4, $1b + 4, $ff, $ff, $87, TM_17 ; item
	db SPRITE_BALL, $9 + 4, $12 + 4, $ff, $ff, $88, FULL_HEAL ; item
	db SPRITE_BALL, $b + 4, $9 + 4, $ff, $ff, $89, TM_05 ; item
	db SPRITE_BALL, $0 + 4, $b + 4, $ff, $ff, $8a, GUARD_SPEC_ ; item
    db SPRITE_BOULDER, $e + 4, $4 + 4, $ff, $10, $b ; person
    db SPRITE_BOULDER, $5 + 4, $5 + 4, $ff, $10, $c ; person
    db SPRITE_BOULDER, $10 + 4, $17 + 4, $ff, $10, $d ; person

    ; warp-to
    EVENT_DISP $f, $8, $0 ; VICTORY_ROAD_1
    EVENT_DISP $f, $7, $1d
    EVENT_DISP $f, $8, $1d
    EVENT_DISP $f, $7, $17 ; VICTORY_ROAD_3
    EVENT_DISP $f, $e, $19 ; VICTORY_ROAD_3
    EVENT_DISP $f, $7, $1b ; VICTORY_ROAD_3
    EVENT_DISP $f, $1, $1 ; VICTORY_ROAD_3

VictoryRoad2Blocks: ; 135
    INCBIN "maps/victoryroad2.blk"

MtMoon2_h: ; 0x51a36 to 0x51a42 (12 bytes) (id=60)
    db $11 ; tileset
    db $0e, $0e ; dimensions (y, x)
    dw MtMoon2Blocks, $5a46, $5a42 ; blocks, texts, scripts
    db $00 ; connections

    dw $5a4d ; objects

INCBIN "baserom.gbc",$51a42,$51a4d - $51a42
MtMoon2Object: ; 0x51a4d (size=68)
    db $3 ; border tile

    db $8 ; warps
    db $5, $5, $2, MT_MOON_1
    db $b, $11, $0, MT_MOON_3
    db $9, $19, $3, MT_MOON_1
    db $f, $19, $4, MT_MOON_1
    db $11, $15, $1, MT_MOON_3
    db $1b, $d, $2, MT_MOON_3
    db $3, $17, $3, MT_MOON_3
    db $3, $1b, $2, $ff

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $e, $5, $5 ; MT_MOON_1
    EVENT_DISP $e, $b, $11 ; MT_MOON_3
    EVENT_DISP $e, $9, $19 ; MT_MOON_1
    EVENT_DISP $e, $f, $19 ; MT_MOON_1
    EVENT_DISP $e, $11, $15 ; MT_MOON_3
    EVENT_DISP $e, $1b, $d ; MT_MOON_3
    EVENT_DISP $e, $3, $17 ; MT_MOON_3
    EVENT_DISP $e, $3, $1b

MtMoon2Blocks: ; 196
    INCBIN "maps/mtmoon2.blk"

SilphCo7_h: ; 0x51b55 to 0x51b61 (12 bytes) (id=212)
    db $16 ; tileset
    db $09, $0d ; dimensions (y, x)
    dw SilphCo7Blocks, $5d3f, $5b61 ; blocks, texts, scripts
    db $00 ; connections

    dw $5ed7 ; objects

INCBIN "baserom.gbc",$51b61,$51d8e - $51b61
SilphCo7Text1: ; 0x51d8e
    db $08 ; asm
    ld a, [$d72e]
    bit 0, a
    jr z, .asm_d7e17 ; 0x51d94
    ld a, [$d838]
    bit 7, a
    jr nz, .asm_688b4 ; 0x51d9b
    ld hl, $5ddd
    call PrintText
    jr .asm_b3069 ; 0x51da3
.asm_d7e17 ; 0x51da5
    ld hl, $5dd3
    call PrintText
	ld bc,(LAPRAS << 8) | 15
    call GivePokemon
    jr nc, .asm_b3069 ; 0x51db1
    ld a, [$ccd3]
    and a
    call z, $3865
    call $3c3c
    ld hl, $5dd8
    call PrintText
    ld hl, $d72e
    set 0, [hl]
    jr .asm_b3069 ; 0x51dc8
.asm_688b4 ; 0x51dca
    ld hl, $5de2
    call PrintText
.asm_b3069 ; 0x51dd0
    jp $24d7

INCBIN "baserom.gbc",$51dd3,$51e0a - $51dd3
SilphCo7Text3: ; 0x51e0a
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    jr nz, .asm_254aa ; 0x51e10
    ld hl, $5e23
    call PrintText
    jr .asm_6472b ; 0x51e18
.asm_254aa ; 0x51e1a
    ld hl, $5e28
    call PrintText
.asm_6472b ; 0x51e20
    jp $24d7

INCBIN "baserom.gbc",$51e23,$51e2d - $51e23
SilphCo7Text4: ; 0x51e2d
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    jr nz, .asm_0f7ee ; 0x51e33
    ld hl, $5e46
    call PrintText
    jr .asm_27a32 ; 0x51e3b
.asm_0f7ee ; 0x51e3d
    ld hl, $5e4b
    call PrintText
.asm_27a32 ; 0x51e43
    jp $24d7

INCBIN "baserom.gbc",$51e46,$51e50 - $51e46
SilphCo7Text5: ; 0x51e50
    db $08 ; asm
    ld hl, $5d5d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51e5a,$51e69 - $51e5a
SilphCo7Text6: ; 0x51e69
    db $08 ; asm
    ld hl, $5d69
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51e73,$51e82 - $51e73
SilphCo7Text7: ; 0x51e82
    db $08 ; asm
    ld hl, $5d75
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51e8c,$51e9b - $51e8c
SilphCo7Text8: ; 0x51e9b
    db $08 ; asm
    ld hl, $5d81
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$51ea5,$51eb4 - $51ea5
SilphCo7Text9: ; 0x51eb4
    db $08 ; asm
    ld hl, $5ebe
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$51ebe,$19
SilphCo7Object: ; 0x51ed7 (size=128)
    db $2e ; border tile

    db $6 ; warps
    db $0, $10, $1, SILPH_CO_8F
    db $0, $16, $0, SILPH_CO_6F
    db $0, $12, $0, SILPH_CO_ELEVATOR
    db $7, $5, $3, SILPH_CO_11F
    db $3, $5, $8, SILPH_CO_3F
    db $f, $15, $3, SILPH_CO_5F

    db $0 ; signs

    db $b ; people
    db SPRITE_LAPRAS_GIVER, $5 + 4, $1 + 4, $ff, $ff, $1 ; person
    db SPRITE_LAPRAS_GIVER, $d + 4, $d + 4, $ff, $d1, $2 ; person
    db SPRITE_LAPRAS_GIVER, $a + 4, $7 + 4, $ff, $ff, $3 ; person
    db SPRITE_ERIKA, $8 + 4, $a + 4, $ff, $ff, $4 ; person
    db SPRITE_ROCKET, $1 + 4, $d + 4, $ff, $d0, $45, ROCKET + $C8, $20 ; trainer
    db SPRITE_OAK_AIDE, $d + 4, $2 + 4, $ff, $d0, $46, SCIENTIST + $C8, $8 ; trainer
    db SPRITE_ROCKET, $2 + 4, $14 + 4, $ff, $d2, $47, ROCKET + $C8, $21 ; trainer
    db SPRITE_ROCKET, $e + 4, $13 + 4, $ff, $d3, $48, ROCKET + $C8, $22 ; trainer
    db SPRITE_BLUE, $7 + 4, $3 + 4, $ff, $d1, $9 ; person
	db SPRITE_BALL, $9 + 4, $1 + 4, $ff, $ff, $8a, CALCIUM ; item
	db SPRITE_BALL, $b + 4, $18 + 4, $ff, $ff, $8b, TM_03 ; item

    ; warp-to
    EVENT_DISP $d, $0, $10 ; SILPH_CO_8F
    EVENT_DISP $d, $0, $16 ; SILPH_CO_6F
    EVENT_DISP $d, $0, $12 ; SILPH_CO_ELEVATOR
    EVENT_DISP $d, $7, $5 ; SILPH_CO_11F
    EVENT_DISP $d, $3, $5 ; SILPH_CO_3F
    EVENT_DISP $d, $f, $15 ; SILPH_CO_5F

SilphCo7Blocks: ; 117
    INCBIN "maps/silphco7.blk"

Mansion2_h: ; 0x51fcc to 0x51fd8 (12 bytes) (id=214)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw $6110, $604d, $5fd8 ; blocks, texts, scripts
    db $00 ; connections

    dw $60d1 ; objects

INCBIN "baserom.gbc",$51fd8,$52064 - $51fd8
Mansion2Text1: ; 0x52064
    db $08 ; asm
    ld hl, $6057
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5206e,$f

Mansion2Text3: ; 0x5207d
    TX_FAR _Mansion2Text3
    db $50

Mansion2Text4: ; 0x52082
    TX_FAR _Mansion2Text4
    db $50

INCBIN "baserom.gbc",$52087,$4a
Mansion2Object: ; 0x520d1 (size=63)
    db $1 ; border tile

    db $4 ; warps
    db $a, $5, $4, MANSION_1
    db $a, $7, $0, MANSION_3
    db $e, $19, $2, MANSION_3
    db $1, $6, $1, MANSION_3

    db $0 ; signs

    db $4 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $11 + 4, $3 + 4, $fe, $2, $41, BURGLAR + $C8, $7 ; trainer
	db SPRITE_BALL, $7 + 4, $1c + 4, $ff, $ff, $82, CALCIUM ; item
    db SPRITE_BOOK_MAP_DEX, $2 + 4, $12 + 4, $ff, $ff, $3 ; person
    db SPRITE_BOOK_MAP_DEX, $16 + 4, $3 + 4, $ff, $ff, $4 ; person

    ; warp-to
    EVENT_DISP $f, $a, $5 ; MANSION_1
    EVENT_DISP $f, $a, $7 ; MANSION_3
    EVENT_DISP $f, $e, $19 ; MANSION_3
    EVENT_DISP $f, $1, $6 ; MANSION_3

INCBIN "baserom.gbc",$52110,$d2

Mansion3_h: ; 0x521e2 to 0x521ee (12 bytes) (id=215)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw $6326, $628a, $61ee ; blocks, texts, scripts
    db $00 ; connections

    dw $62e6 ; objects

INCBIN "baserom.gbc",$521ee,$522af - $521ee
Mansion3Text1: ; 0x522af
    db $08 ; asm
    ld hl, $6296
    call LoadTrainerHeader
    jp $24d7

Mansion3Text2: ; 0x522b9
    db $08 ; asm
    ld hl, $62a2
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$522c3,$23
Mansion3Object: ; 0x522e6 (size=64)
    db $1 ; border tile

    db $3 ; warps
    db $a, $7, $1, MANSION_2
    db $1, $6, $3, MANSION_2
    db $e, $19, $2, MANSION_2

    db $0 ; signs

    db $5 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $b + 4, $5 + 4, $fe, $2, $41, BURGLAR + $C8, $8 ; trainer
    db SPRITE_OAK_AIDE, $b + 4, $14 + 4, $ff, $d2, $42, SCIENTIST + $C8, $c ; trainer
	db SPRITE_BALL, $10 + 4, $1 + 4, $ff, $ff, $83, MAX_POTION ; item
	db SPRITE_BALL, $5 + 4, $19 + 4, $ff, $ff, $84, IRON ; item
    db SPRITE_BOOK_MAP_DEX, $c + 4, $6 + 4, $ff, $ff, $5 ; person

    ; warp-to
    EVENT_DISP $f, $a, $7 ; MANSION_2
    EVENT_DISP $f, $1, $6 ; MANSION_2
    EVENT_DISP $f, $e, $19 ; MANSION_2

INCBIN "baserom.gbc",$52326,$87

Mansion4_h: ; 0x523ad to 0x523b9 (12 bytes) (id=216)
    db $16 ; tileset
    db $0e, $0f ; dimensions (y, x)
    dw $64dd, $6436, $63b9 ; blocks, texts, scripts
    db $00 ; connections

    dw $6498 ; objects

INCBIN "baserom.gbc",$523b9,$52461 - $523b9
Mansion4Text1: ; 0x52461
    db $08 ; asm
    ld hl, $6448
    call LoadTrainerHeader
    jp $24d7

Mansion4Text2: ; 0x5246b
    db $08 ; asm
    ld hl, $6454
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$52475,$1e

Mansion4Text7: ; 0x52493
    TX_FAR _Mansion4Text7
    db $50

Mansion4Object: ; 0x52498 (size=69)
    db $1 ; border tile

    db $1 ; warps
    db $16, $17, $5, MANSION_1

    db $0 ; signs

    db $8 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $17 + 4, $10 + 4, $ff, $ff, $41, BURGLAR + $C8, $9 ; trainer
    db SPRITE_OAK_AIDE, $b + 4, $1b + 4, $ff, $d0, $42, SCIENTIST + $C8, $d ; trainer
	db SPRITE_BALL, $2 + 4, $a + 4, $ff, $ff, $83, RARE_CANDY ; item
	db SPRITE_BALL, $16 + 4, $1 + 4, $ff, $ff, $84, FULL_RESTORE ; item
	db SPRITE_BALL, $19 + 4, $13 + 4, $ff, $ff, $85, TM_14 ; item
	db SPRITE_BALL, $4 + 4, $5 + 4, $ff, $ff, $86, TM_22 ; item
    db SPRITE_BOOK_MAP_DEX, $14 + 4, $10 + 4, $ff, $ff, $7 ; person
	db SPRITE_BALL, $d + 4, $5 + 4, $ff, $ff, $88, SECRET_KEY ; item

    ; warp-to
    EVENT_DISP $f, $16, $17 ; MANSION_1

INCBIN "baserom.gbc",$524DD,$5271B - $524DD

CeladonPrizeMenu: ; 14:671B
        ld b,COIN_CASE
        call IsItemInBag
        jr nz,.havingCoinCase\@
        ld hl,RequireCoinCaseTextPtr
        jp PrintText
.havingCoinCase\@
        ld hl,$D730
        set 6,[hl]
        ld hl,ExchangeCoinsForPrizesTextPtr
        call PrintText
; the following are the menu settings
        xor a
        ld [$CC26],a
        ld [$CC2A],a
        ld a,$03
        ld [$CC29],a
        ld a,$03
        ld [$CC28],a
        ld a,$04
        ld [$CC24],a
        ld a,$01
        ld [$CC25],a
        call PrintPrizePrice ; 687A
        FuncCoord 0,2
        ld hl,Coord
        ld b,$08
        ld c,$10
        call TextBoxBorder
        call GetPrizeMenuId ;678E
        call $2429
        ld hl,WhichPrizeTextPtr
        call PrintText
        call $3ABE ; menu choice handler
        bit 1,a ; keypress = B (Cancel)
        jr nz,.NoChoice\@
        ld a,[$CC26]
        cp a,$03 ; "NO,THANKS" choice
        jr z,.NoChoice\@
        call HandlePrizeChoice ; 14:68C6
.NoChoice\@
        ld hl,$D730
        res 6,[hl]
        ret

RequireCoinCaseTextPtr: ; 14:677E
        TX_FAR _RequireCoinCaseText ; 22:628E
        db $0D
        db "@"

ExchangeCoinsForPrizesTextPtr: ; 14:6784
        TX_FAR _ExchangeCoinsForPrizesText ; 22:62A9
        db "@"

WhichPrizeTextPtr: ; 14:6789
        TX_FAR _WhichPrizeText ; 22:62CD
        db "@"

GetPrizeMenuId: ; 14:678E
; determine which one among the three
; prize-texts has been selected
; using the text ID (stored in [$FF8C])
; load the three prizes at $D13D-$D13F
; load the three prices ar $D141-$D146
; display the three prizes' names
; (distinguishing between Pokemon names
; and Items (specifically TMs) names)
        ld a,[$FF8C]
        sub a,$03       ; prize-texts' id are 3, 4 and 5
        ld [$D12F],a    ; prize-texts' id (relative, i.e. 0, 1 or 2)
        add a
        add a
        ld d,$00
        ld e,a
        ld hl,PrizeDifferentMenuPtrs
        add hl,de
        ld a,[hli]
        ld d,[hl]
        ld e,a
        inc hl
        push hl
        ld hl,W_PRIZE1
        call $3829      ; XXX what does this do
        pop hl
        ld a,[hli]
        ld h,[hl]
        ld l,a
        ld de,$D141
        ld bc,$0006
        call CopyData
        ld a,[$D12F]
        cp a,$02        ;is TM_menu?
        jr nz,.putMonName\@
        ld a,[W_PRIZE1]
        ld [$D11E],a
        call GetItemName
        FuncCoord 2,4
        ld hl,Coord
        call PlaceString
        ld a,[W_PRIZE2]
        ld [$D11E],a
        call GetItemName
        FuncCoord 2,6
        ld hl,Coord
        call PlaceString
        ld a,[W_PRIZE3]
        ld [$D11E],a
        call GetItemName
        FuncCoord 2,8
        ld hl,Coord
        call PlaceString
        jr .putNoThanksText\@
.putMonName\@ ; 14:67EC
        ld a,[W_PRIZE1]
        ld [$D11E],a
        call GetMonName
        FuncCoord 2,4
        ld hl,Coord
        call PlaceString
        ld a,[W_PRIZE2]
        ld [$D11E],a
        call GetMonName
        FuncCoord 2,6
        ld hl,Coord
        call PlaceString
        ld a,[W_PRIZE3]
        ld [$D11E],a
        call GetMonName
        FuncCoord 2,8
        ld hl,Coord
        call PlaceString
.putNoThanksText\@ ; 14:6819
        FuncCoord 2,10
        ld hl,Coord
        ld de,NoThanksText
        call PlaceString
; put prices on the right side of the textbox
        ld de,$D141
        FuncCoord 13,5
        ld hl,Coord
; reg. c:
; [low nybble] number of bytes
; [bit 765 = %100] space-padding (not zero-padding)
        ld c,(1 << 7 | 2)
; Function $15CD displays BCD value (same routine
; used by text-command $02)
        call $15CD ; Print_BCD
        ld de,$D143
        FuncCoord 13,7
        ld hl,Coord
        ld c,(%1 << 7 | 2)
        call $15CD
        ld de,$D145
        FuncCoord 13,9
        ld hl,Coord
        ld c,(1 << 7 | 2)
        jp $15CD

PrizeDifferentMenuPtrs: ; 14:6843
        dw PrizeMenuMon1Entries
        dw PrizeMenuMon1Cost

        dw PrizeMenuMon2Entries
        dw PrizeMenuMon2Cost
        
        dw PrizeMenuTMsEntries
        dw PrizeMenuTMsCost

NoThanksText: ; 14:684F
        db "NO THANKS@"

PrizeMenuMon1Entries: ; 14:6859
        db ABRA
        db CLEFAIRY
        db NIDORINA
        db "@"
PrizeMenuMon1Cost: ; 14:685D
        db $01,$80
        db $05,$00
        db $12,$00
        db "@"

PrizeMenuMon2Entries: ; 14:6864
        db DRATINI
        db SCYTHER
        db PORYGON
        db "@"
PrizeMenuMon2Cost: ; 14:6868
        db $28,$00 ; 2800 Coins
        db $55,$00 ; 5500 Coins
        db $99,$99 ; 9999 Coins
        db "@"

PrizeMenuTMsEntries: ; 14:686F
        db TM_23
        db TM_15
        db TM_50
        db "@"
PrizeMenuTMsCost: ; 14:6873
        db $33,$00 ; 3300 Coins
        db $55,$00 ; 5500 Coins
        db $77,$00 ; 7700 Coins
        db "@"

PrintPrizePrice: ; 14:687A
        FuncCoord 11,0
        ld hl,Coord
        ld b,$01
        ld c,$07
        call TextBoxBorder
        call $2429      ; XXX save OAM?
        FuncCoord 12,0
        ld hl,Coord
        ld de,.CoinText\@
        call PlaceString
        FuncCoord 13,1
        ld hl,Coord
        ld de,.SixSpacesText\@
        call PlaceString
        FuncCoord 13,1
        ld hl,Coord
        ld de,W_PLAYERCOINS1
        ld c,%10000010
        call $15CD
        ret

.CoinText\@ ; 14:68A5
        db "COIN@"

.SixSpacesText\@ ; 14:68AA
        db "      @"

LoadCoinsToSubtract: ; 14:68B1
        ld a,[$D139] ; backup of selected menu_entry
        add a
        ld d,$00
        ld e,a
        ld hl,$D141 ; first prize's price
        add hl,de ; get selected prize's price
        xor a
        ld [$FF9F],a
        ld a,[hli]
        ld [$FFA0],a
        ld a,[hl]
        ld [$FFA1],a
        ret

HandlePrizeChoice: ; 14:68C6
        ld a,[$CC26] ; selected menu_entry
        ld [$D139],a
        ld d,$00
        ld e,a
        ld hl,W_PRIZE1
        add hl,de
        ld a,[hl]
        ld [$D11E],a
        ld a,[$D12F]
        cp a,$02 ; is prize a TM?
        jr nz,.GetMonName\@
        call GetItemName
        jr .GivePrize\@
.GetMonName\@ ; 14:68E3
        call GetMonName
.GivePrize\@ ; 14:68E6
        ld hl,SoYouWantPrizeTextPtr
        call PrintText
        call $35EC ; yes/no textbox
        ld a,[$CC26] ; yes/no answer (Y=0, N=1)
        and a
        jr nz,.PrintOhFineThen\@
        call LoadCoinsToSubtract
        call $35B1 ; subtract COINs from COIN_CASE
        jr c,.NotEnoughCoins\@
        ld a,[$D12F]
        cp a,$02
        jr nz,.GiveMon\@
        ld a,[$D11E]
        ld b,a
        ld a,$01
        ld c,a
        call $3E2E ; GiveItem
        jr nc,.BagIsFull\@
        jr .SubtractCoins\@
.GiveMon\@ ; 14:6912
        ld a,[$D11E]
        ld [$CF91],a
        push af
        call GetPrizeMonLevel ; 14:6977
        ld c,a
        pop af
        ld b,a
        call $3E48 ; GivePokemon
        push af
        ld a,[$CCD3] ; XXX is there room?
        and a
        call z,$3865
        pop af
        ret nc
.SubtractCoins\@ ; 14:692C
        call LoadCoinsToSubtract
        ld hl,$FFA1
        ld de,W_PLAYERCOINS2
        ld c,$02 ; how many bytes
        ld a,$0C
        call Predef ; subtract coins (BCD daa operations)
        jp PrintPrizePrice
.BagIsFull\@ ; 14:693F
        ld hl,PrizeRoomBagIsFullTextPtr
        jp PrintText
.NotEnoughCoins\@ ; 14:6945
        ld hl,SorryNeedMoreCoinsTextPtr
        jp PrintText
.PrintOhFineThen\@ ; 14:694B
        ld hl,OhFineThenTextPtr
        jp PrintText

UnknownData52951: ; 14:6951
; XXX what's this?
        db $00,$01,$00,$01,$00,$01,$00,$00,$01

HereYouGoTextPtr:
        TX_FAR _HereYouGoText ; 22:62E7
        db $0D
        db "@"

SoYouWantPrizeTextPtr: ; 14:6960
        TX_FAR _SoYouWantPrizeText ; 22:62F6
        db "@"

SorryNeedMoreCoinsTextPtr: ; 14:6965
        TX_FAR _SorryNeedMoreCoins ; 22:630B
        db $0D
        db "@"

PrizeRoomBagIsFullTextPtr: ; 14:696B
        TX_FAR _OopsYouDontHaveEnoughRoomText ; 22:6329
        db $0D
        db "@"

OhFineThenTextPtr: ; 14:6971
        TX_FAR _OhFineThenText; 22:634C
        db $0D ; wait keypress (A/B) without blink
        db "@"

GetPrizeMonLevel: ; 14:6977
        ld a,[$CF91]
        ld b,a
        ld hl,PrizeMonLevelDictionary
.loop\@ ; 14:697E
        ld a,[hli]
        cp b
        jr z,.matchFound\@
        inc hl
        jr .loop\@
.matchFound\@ ; 14:6985
        ld a,[hl]
        ld [$D127],a
        ret

PrizeMonLevelDictionary: ; 14:698A
        db ABRA,9
        db CLEFAIRY,8
        db NIDORINA,17

        db DRATINI,18
        db SCYTHER,25
        db PORYGON,26

INCBIN "baserom.gbc",$52996,$54000 - $52996

SECTION "bank15",DATA,BANK[$15]

INCBIN "baserom.gbc",$54000,$54022 - $54000
Route2Object: ; 0x54022 (size=72)
    db $f ; border tile

    db $6 ; warps
    db $9, $c, $0, DIGLETTS_CAVE_EXIT
    db $b, $3, $1, VIRIDIAN_FOREST_EXIT
    db $13, $f, $0, ROUTE_2_HOUSE
    db $23, $10, $1, ROUTE_2_GATE
    db $27, $f, $2, ROUTE_2_GATE
    db $2b, $3, $2, VIRIDIAN_FOREST_ENTRANCE

    db $2 ; signs
    db $41, $5, $3 ; Route2Text3
    db $b, $b, $4 ; Route2Text4

    db $2 ; people
	db SPRITE_BALL, $36 + 4, $d + 4, $ff, $ff, $81, MOON_STONE ; item
	db SPRITE_BALL, $2d + 4, $d + 4, $ff, $ff, $82, HP_UP ; item

    ; warp-to
    EVENT_DISP $a, $9, $c ; DIGLETTS_CAVE_EXIT
    EVENT_DISP $a, $b, $3 ; VIRIDIAN_FOREST_EXIT
    EVENT_DISP $a, $13, $f ; ROUTE_2_HOUSE
    EVENT_DISP $a, $23, $10 ; ROUTE_2_GATE
    EVENT_DISP $a, $27, $f ; ROUTE_2_GATE
    EVENT_DISP $a, $2b, $3 ; VIRIDIAN_FOREST_ENTRANCE

INCBIN "baserom.gbc",$5406a,$14

Route2Blocks: ; 360
    INCBIN "maps/route2.blk"

Route3_h: ; 0x541e6 to 0x54208 (34 bytes) (id=14)
    db $00 ; tileset
    db $09, $23 ; dimensions (y, x)
    dw Route3Blocks, $5511, $54f8 ; blocks, texts, scripts
    db NORTH | WEST ; connections

    ; connections data

	db ROUTE_4
    dw $44fa, $c704 ; pointers (connected, current) (strip)
    db $0d, $2d ; bigness, width
    db $11, $ce ; alignments (y, x)
    dw $c8b4 ; window

	db PEWTER_CITY
    dw $460b, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $27 ; alignments (y, x)
    dw $c716 ; window

    ; end connection data

    dw $4208 ; objects

Route3Object: ; 0x54208 (size=77)
    db $2c ; border tile

    db $0 ; warps

    db $1 ; signs
    db $9, $3b, $a ; Route3Text10

    db $9 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $b + 4, $39 + 4, $ff, $ff, $1 ; person
    db SPRITE_BUG_CATCHER, $6 + 4, $a + 4, $ff, $d3, $42, BUG_CATCHER + $C8, $4 ; trainer
    db SPRITE_BUG_CATCHER, $4 + 4, $e + 4, $ff, $d0, $43, YOUNGSTER + $C8, $1 ; trainer
    db SPRITE_LASS, $9 + 4, $10 + 4, $ff, $d2, $44, LASS + $C8, $1 ; trainer
    db SPRITE_BUG_CATCHER, $5 + 4, $13 + 4, $ff, $d0, $45, BUG_CATCHER + $C8, $5 ; trainer
    db SPRITE_LASS, $4 + 4, $17 + 4, $ff, $d2, $46, LASS + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $9 + 4, $16 + 4, $ff, $d2, $47, YOUNGSTER + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $6 + 4, $18 + 4, $ff, $d3, $48, BUG_CATCHER + $C8, $6 ; trainer
    db SPRITE_LASS, $a + 4, $21 + 4, $ff, $d1, $49, LASS + $C8, $3 ; trainer

Route3Blocks: ; 315
    INCBIN "maps/route3.blk"

Route4_h: ; 0x54390 to 0x543b2 (34 bytes) (id=15)
    db $00 ; tileset
    db $09, $2d ; dimensions (y, x)
    dw Route4Blocks, $5671, $5658 ; blocks, texts, scripts
    db SOUTH | EAST ; connections

    ; connections data

	db ROUTE_3
    dw $426b, $c94c ; pointers (connected, current) (strip)
    db $0d, $23 ; bigness, width
    db $00, $32 ; alignments (y, x)
    dw $c712 ; window

	db CERULEAN_CITY
    dw $4844, $c718 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $00 ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $43b2 ; objects

Route4Object: ; 0x543b2 (size=58)
    db $2c ; border tile

    db $3 ; warps
    db $5, $b, $0, MT_MOON_POKECENTER
    db $5, $12, $0, MT_MOON_1
    db $5, $18, $7, MT_MOON_2

    db $3 ; signs
    db $5, $c, $4 ; Route4Text4
    db $7, $11, $5 ; Route4Text5
    db $7, $1b, $6 ; Route4Text6

    db $3 ; people
    db SPRITE_LASS, $8 + 4, $9 + 4, $fe, $0, $1 ; person
    db SPRITE_LASS, $3 + 4, $3f + 4, $ff, $d3, $42, LASS + $C8, $4 ; trainer
	db SPRITE_BALL, $3 + 4, $39 + 4, $ff, $ff, $83, TM_04 ; item

    ; warp-to
    EVENT_DISP $2d, $5, $b ; MT_MOON_POKECENTER
    EVENT_DISP $2d, $5, $12 ; MT_MOON_1
    EVENT_DISP $2d, $5, $18 ; MT_MOON_2

Route4Blocks: ; 405
    INCBIN "maps/route4.blk"

Route5_h: ; 0x54581 to 0x545a3 (34 bytes) (id=16)
    db $00 ; tileset
    db $12, $0a ; dimensions (y, x)
    dw Route5Blocks, $56b5, $56b2 ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db CERULEAN_CITY
    dw $495e, $c6e8 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $23, $0a ; alignments (y, x)
    dw $c8bd ; window

	db SAFFRON_CITY
    dw $4a9a, $c838 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $00, $0a ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $45a3 ; objects

Route5Object: ; 0x545a3 (size=47)
    db $a ; border tile

    db $5 ; warps
    db $1d, $a, $3, ROUTE_5_GATE
    db $1d, $9, $2, ROUTE_5_GATE
    db $21, $a, $0, ROUTE_5_GATE
    db $1b, $11, $0, PATH_ENTRANCE_ROUTE_5
    db $15, $a, $0, DAYCAREM

    db $1 ; signs
    db $1d, $11, $1 ; Route5Text1

    db $0 ; people

    ; warp-to
    EVENT_DISP $a, $1d, $a ; ROUTE_5_GATE
    EVENT_DISP $a, $1d, $9 ; ROUTE_5_GATE
    EVENT_DISP $a, $21, $a ; ROUTE_5_GATE
    EVENT_DISP $a, $1b, $11 ; PATH_ENTRANCE_ROUTE_5
    EVENT_DISP $a, $15, $a ; DAYCAREM

Route5Blocks: ; 180
    INCBIN "maps/route5.blk"

Route9_h: ; 0x54686 to 0x546a8 (34 bytes) (id=20)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route9Blocks, $56d5, $56bc ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db CERULEAN_CITY
    dw $4855, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $27 ; alignments (y, x)
    dw $c716 ; window

	db ROUTE_10
    dw $4356, $c775 ; pointers (connected, current) (strip)
    db $0c, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $46a8 ; objects

Route9Object: ; 0x546a8 (size=86)
    db $2c ; border tile

    db $0 ; warps

    db $1 ; signs
    db $7, $19, $b ; Route9Text11

    db $a ; people
    db SPRITE_LASS, $a + 4, $d + 4, $ff, $d2, $41, JR__TRAINER_F + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $7 + 4, $18 + 4, $ff, $d2, $42, JR__TRAINER_M + $C8, $7 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $7 + 4, $1f + 4, $ff, $d3, $43, JR__TRAINER_M + $C8, $8 ; trainer
    db SPRITE_LASS, $8 + 4, $30 + 4, $ff, $d3, $44, JR__TRAINER_F + $C8, $6 ; trainer
    db SPRITE_HIKER, $f + 4, $10 + 4, $ff, $d2, $45, HIKER + $C8, $b ; trainer
    db SPRITE_HIKER, $3 + 4, $2b + 4, $ff, $d2, $46, HIKER + $C8, $6 ; trainer
    db SPRITE_BUG_CATCHER, $2 + 4, $16 + 4, $ff, $d0, $47, BUG_CATCHER + $C8, $d ; trainer
    db SPRITE_HIKER, $f + 4, $2d + 4, $ff, $d3, $48, HIKER + $C8, $5 ; trainer
    db SPRITE_BUG_CATCHER, $8 + 4, $28 + 4, $ff, $d3, $49, BUG_CATCHER + $C8, $e ; trainer
	db SPRITE_BALL, $f + 4, $a + 4, $ff, $ff, $8a, TM_30 ; item

Route9Blocks: ; 270
    INCBIN "maps/route9.blk"

Route13_h: ; 0x5480c to 0x5482e (34 bytes) (id=24)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route13Blocks, $5837, $581e ; blocks, texts, scripts
    db NORTH | WEST ; connections

    ; connections data

	db ROUTE_12
    dw $490e, $c6ff ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $6b, $d8 ; alignments (y, x)
    dw $ca49 ; window

	db ROUTE_14
    dw $4a19, $c754 ; pointers (connected, current) (strip)
    db $0c, $0a ; bigness, width
    db $00, $13 ; alignments (y, x)
    dw $c702 ; window

    ; end connection data

    dw $482e ; objects

Route13Object: ; 0x5482e (size=93)
    db $43 ; border tile

    db $0 ; warps

    db $3 ; signs
    db $d, $f, $b ; Route13Text11
    db $5, $21, $c ; Route13Text12
    db $b, $1f, $d ; Route13Text13

    db $a ; people
    db SPRITE_BLACK_HAIR_BOY_1, $a + 4, $31 + 4, $ff, $d3, $41, BIRD_KEEPER + $C8, $1 ; trainer
    db SPRITE_LASS, $a + 4, $30 + 4, $ff, $d0, $42, JR__TRAINER_F + $C8, $c ; trainer
    db SPRITE_LASS, $9 + 4, $1b + 4, $ff, $d0, $43, JR__TRAINER_F + $C8, $d ; trainer
    db SPRITE_LASS, $a + 4, $17 + 4, $ff, $d2, $44, JR__TRAINER_F + $C8, $e ; trainer
    db SPRITE_LASS, $5 + 4, $32 + 4, $ff, $d0, $45, JR__TRAINER_F + $C8, $f ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $4 + 4, $c + 4, $ff, $d3, $46, BIRD_KEEPER + $C8, $2 ; trainer
    db SPRITE_FOULARD_WOMAN, $6 + 4, $21 + 4, $ff, $d0, $47, BEAUTY + $C8, $4 ; trainer
    db SPRITE_FOULARD_WOMAN, $6 + 4, $20 + 4, $ff, $d0, $48, BEAUTY + $C8, $5 ; trainer
    db SPRITE_BIKER, $7 + 4, $a + 4, $ff, $d1, $49, BIKER + $C8, $1 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $d + 4, $7 + 4, $ff, $d1, $4a, BIRD_KEEPER + $C8, $3 ; trainer

Route13Blocks: ; 270
    INCBIN "maps/route13.blk"

Route14_h: ; 0x54999 to 0x549bb (34 bytes) (id=25)
    db $00 ; tileset
    db $1b, $0a ; dimensions (y, x)
    dw Route14Blocks, $59ec, $59d3 ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db ROUTE_15
    dw $49e7, $c838 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $dc, $3b ; alignments (y, x)
    dw $c72a ; window

	db ROUTE_13
    dw $488b, $c725 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c70d ; window

    ; end connection data

    dw $49bb ; objects

Route14Object: ; 0x549bb (size=87)
    db $43 ; border tile

    db $0 ; warps

    db $1 ; signs
    db $d, $11, $b ; Route14Text11

    db $a ; people
    db SPRITE_BLACK_HAIR_BOY_1, $4 + 4, $4 + 4, $ff, $d0, $41, BIRD_KEEPER + $C8, $e ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $6 + 4, $f + 4, $ff, $d0, $42, BIRD_KEEPER + $C8, $f ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $b + 4, $c + 4, $ff, $d0, $43, BIRD_KEEPER + $C8, $10 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $f + 4, $e + 4, $ff, $d1, $44, BIRD_KEEPER + $C8, $11 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $1f + 4, $f + 4, $ff, $d2, $45, BIRD_KEEPER + $C8, $4 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $31 + 4, $6 + 4, $ff, $d1, $46, BIRD_KEEPER + $C8, $5 ; trainer
    db SPRITE_BIKER, $27 + 4, $5 + 4, $ff, $d0, $47, BIKER + $C8, $d ; trainer
    db SPRITE_BIKER, $1e + 4, $4 + 4, $ff, $d3, $48, BIKER + $C8, $e ; trainer
    db SPRITE_BIKER, $1e + 4, $f + 4, $ff, $d2, $49, BIKER + $C8, $f ; trainer
    db SPRITE_BIKER, $1f + 4, $4 + 4, $ff, $d3, $4a, BIKER + $C8, $2 ; trainer

Route14Blocks: ; 270
    INCBIN "maps/route14.blk"

Route17_h: ; 0x54b20 to 0x54b42 (34 bytes) (id=28)
    db $00 ; tileset
    db $48, $0a ; dimensions (y, x)
    dw Route17Blocks, $5b93, $5b7a ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db ROUTE_16
    dw $4bfc, $c6eb ; pointers (connected, current) (strip)
    db $0d, $14 ; bigness, width
    db $11, $00 ; alignments (y, x)
    dw $c7d3 ; window

	db ROUTE_18
    dw $4c9c, $cb9b ; pointers (connected, current) (strip)
    db $0d, $19 ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c708 ; window

    ; end connection data

    dw $4b42 ; objects

Route17Object: ; 0x54b42 (size=102)
    db $43 ; border tile

    db $0 ; warps

    db $6 ; signs
    db $33, $9, $b ; Route17Text11
    db $3f, $9, $c ; Route17Text12
    db $4b, $9, $d ; Route17Text13
    db $57, $9, $e ; Route17Text14
    db $6f, $9, $f ; Route17Text15
    db $8d, $9, $10 ; Route17Text16

    db $a ; people
    db SPRITE_BIKER, $13 + 4, $c + 4, $ff, $d2, $41, CUE_BALL + $C8, $4 ; trainer
    db SPRITE_BIKER, $10 + 4, $b + 4, $ff, $d3, $42, CUE_BALL + $C8, $5 ; trainer
    db SPRITE_BIKER, $12 + 4, $4 + 4, $ff, $d1, $43, BIKER + $C8, $8 ; trainer
    db SPRITE_BIKER, $20 + 4, $7 + 4, $ff, $d2, $44, BIKER + $C8, $9 ; trainer
    db SPRITE_BIKER, $22 + 4, $e + 4, $ff, $d3, $45, BIKER + $C8, $a ; trainer
    db SPRITE_BIKER, $3a + 4, $11 + 4, $ff, $d2, $46, CUE_BALL + $C8, $6 ; trainer
    db SPRITE_BIKER, $44 + 4, $2 + 4, $ff, $d3, $47, CUE_BALL + $C8, $7 ; trainer
    db SPRITE_BIKER, $62 + 4, $e + 4, $ff, $d3, $48, CUE_BALL + $C8, $8 ; trainer
    db SPRITE_BIKER, $62 + 4, $5 + 4, $ff, $d2, $49, BIKER + $C8, $b ; trainer
    db SPRITE_BIKER, $76 + 4, $a + 4, $ff, $d0, $4a, BIKER + $C8, $c ; trainer

Route17Blocks: ; 720
    INCBIN "maps/route17.blk"

Route19_h: ; 0x54e78 to 0x54e9a (34 bytes) (id=30)
    db $00 ; tileset
    db $1b, $0a ; dimensions (y, x)
    dw Route19Blocks, $5d5d, $5d44 ; blocks, texts, scripts
    db NORTH | WEST ; connections

    ; connections data

	db FUCHSIA_CITY
    dw $4db4, $c6e8 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $23, $0a ; alignments (y, x)
    dw $c8bd ; window

	db ROUTE_20
    dw $41ac, $c838 ; pointers (connected, current) (strip)
    db $09, $32 ; bigness, width
    db $dc, $63 ; alignments (y, x)
    dw $c752 ; window

    ; end connection data

    dw $4e9a ; objects

Route19Object: ; 0x54e9a (size=87)
    db $43 ; border tile

    db $0 ; warps

    db $1 ; signs
    db $9, $b, $b ; Route19Text11

    db $a ; people
    db SPRITE_BLACK_HAIR_BOY_1, $7 + 4, $8 + 4, $ff, $d2, $41, SWIMMER + $C8, $2 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $7 + 4, $d + 4, $ff, $d2, $42, SWIMMER + $C8, $3 ; trainer
    db SPRITE_SWIMMER, $19 + 4, $d + 4, $ff, $d2, $43, SWIMMER + $C8, $4 ; trainer
    db SPRITE_SWIMMER, $1b + 4, $4 + 4, $ff, $d3, $44, SWIMMER + $C8, $5 ; trainer
    db SPRITE_SWIMMER, $1f + 4, $10 + 4, $ff, $d1, $45, SWIMMER + $C8, $6 ; trainer
    db SPRITE_SWIMMER, $b + 4, $9 + 4, $ff, $d0, $46, SWIMMER + $C8, $7 ; trainer
    db SPRITE_SWIMMER, $2b + 4, $8 + 4, $ff, $d2, $47, BEAUTY + $C8, $c ; trainer
    db SPRITE_SWIMMER, $2b + 4, $b + 4, $ff, $d3, $48, BEAUTY + $C8, $d ; trainer
    db SPRITE_SWIMMER, $2a + 4, $9 + 4, $ff, $d1, $49, SWIMMER + $C8, $8 ; trainer
    db SPRITE_SWIMMER, $2c + 4, $a + 4, $ff, $d0, $4a, BEAUTY + $C8, $e ; trainer

Route19Blocks: ; 270
    INCBIN "maps/route19.blk"

Route21_h: ; 0x54fff to 0x55021 (34 bytes) (id=32)
    db $00 ; tileset
    db $2d, $0a ; dimensions (y, x)
    dw Route21Blocks, $5f04, $5eeb ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db PALLET_TOWN
    dw $4339, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $11, $00 ; alignments (y, x)
    dw $c779 ; window

	db CINNABAR_ISLAND
    dw $4069, $c9eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $5021 ; objects

Route21Object: ; 0x55021 (size=76)
    db $43 ; border tile

    db $0 ; warps

    db $0 ; signs

    db $9 ; people
    db SPRITE_FISHER2, $18 + 4, $4 + 4, $ff, $d2, $41, FISHER + $C8, $7 ; trainer
    db SPRITE_FISHER2, $19 + 4, $6 + 4, $ff, $d0, $42, FISHER + $C8, $9 ; trainer
    db SPRITE_SWIMMER, $1f + 4, $a + 4, $ff, $d1, $43, SWIMMER + $C8, $c ; trainer
    db SPRITE_SWIMMER, $1e + 4, $c + 4, $ff, $d3, $44, CUE_BALL + $C8, $9 ; trainer
    db SPRITE_SWIMMER, $3f + 4, $10 + 4, $ff, $d0, $45, SWIMMER + $C8, $d ; trainer
    db SPRITE_SWIMMER, $47 + 4, $5 + 4, $ff, $d3, $46, SWIMMER + $C8, $e ; trainer
    db SPRITE_SWIMMER, $47 + 4, $f + 4, $ff, $d2, $47, SWIMMER + $C8, $f ; trainer
    db SPRITE_FISHER2, $38 + 4, $e + 4, $ff, $d2, $48, FISHER + $C8, $8 ; trainer
    db SPRITE_FISHER2, $39 + 4, $11 + 4, $ff, $d3, $49, FISHER + $C8, $a ; trainer

Route21Blocks: ; 450
    INCBIN "maps/route21.blk"

DayCareMBlocks: ; 16
    INCBIN "maps/daycarem.blk"

FuchsiaHouse3Blocks: ; 16
    INCBIN "maps/fuchsiahouse3.blk"

INCBIN "baserom.gbc",$5524f,$554ee - $5524f

Route2Text3: ; 0x554ee
    TX_FAR _Route2Text3
    db $50

Route2Text4: ; 0x554f3
    TX_FAR _Route2Text4
    db $50

INCBIN "baserom.gbc",$554f8,$55586 - $554f8

Route3Text1: ; 0x55586
    TX_FAR _Route3Text1
    db $50

Route3Text2: ; 0x5558b
    db $08 ; asm
    ld hl, $5525
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55595,$555a4 - $55595
Route3Text3: ; 0x555a4
    db $08 ; asm
    ld hl, $5531
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$555ae,$555bd - $555ae
Route3Text4: ; 0x555bd
    db $08 ; asm
    ld hl, $553d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$555c7,$555d6 - $555c7
Route3Text5: ; 0x555d6
    db $08 ; asm
    ld hl, $5549
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$555e0,$555ef - $555e0
Route3Text6: ; 0x555ef
    db $08 ; asm
    ld hl, $5555
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$555f9,$55608 - $555f9
Route3Text7: ; 0x55608
    db $08 ; asm
    ld hl, $5561
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55612,$55621 - $55612
Route3Text8: ; 0x55621
    db $08 ; asm
    ld hl, $556d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5562b,$5563a - $5562b
Route3Text9: ; 0x5563a
    db $08 ; asm
    ld hl, $5579
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55644,$f

Route3Text10: ; 0x55653
    TX_FAR _Route3Text10
    db $50

INCBIN "baserom.gbc",$55658,$5568a - $55658

Route4Text1: ; 0x5568a
    TX_FAR _Route4Text1
    db $50

Route4Text2: ; 0x5568f
    db $08 ; asm
    ld hl, $567d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55699,$f

Route4Text5: ; 0x556a8
    TX_FAR _Route4Text5
    db $50

Route4Text6: ; 0x556ad
    TX_FAR _Route4Text6
    db $50

INCBIN "baserom.gbc",$556b2,$556b5 - $556b2
Route5Texts: ; 0x556b5
    dw Route5Text1

Route5Text1: ; 0x556b7
    TX_FAR _Route5Text1
    db $50

INCBIN "baserom.gbc",$556bc,$55758 - $556bc
Route9Text1: ; 0x55758
    db $8 ; asm
    ld hl, $56eb
    jr asm_8be3d ; 0x5575c $2e

Route9Text2:
    db $8 ; asm
    ld hl, $56f7
    jr asm_8be3d ; 0x55762 $28

Route9Text3:
    db $8 ; asm
    ld hl, $5703
    jr asm_8be3d ; 0x55768 $22

Route9Text4:
    db $8 ; asm
    ld hl, $570f
    jr asm_8be3d ; 0x5576e $1c

Route9Text5:
    db $8 ; asm
    ld hl, $571b
    jr asm_8be3d ; 0x55774 $16

Route9Text6:
    db $8 ; asm
    ld hl, $5727
    jr asm_8be3d ; 0x5577a $10

Route9Text7:
    db $8 ; asm
    ld hl, $5733
    jr asm_8be3d ; 0x55780 $a

Route9Text8:
    db $8 ; asm
    ld hl, $573f
    jr asm_8be3d ; 0x55786 $4

Route9Text9:
    db $8 ; asm
    ld hl, $574b
asm_8be3d: ; 0x5578c
    call $31cc
    jp $24d7
; 0x55792

INCBIN "baserom.gbc",$55792,$87

Route9Text11: ; 0x55819
    TX_FAR _Route9Text11
    db $50

INCBIN "baserom.gbc",$5581e,$558ca - $5581e
Route13Text1: ; 0x558ca
    db $08 ; asm
    ld hl, $5851
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$558d4,$558e3 - $558d4
Route13Text2: ; 0x558e3
    db $08 ; asm
    ld hl, $585d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$558ed,$558fc - $558ed
Route13Text3: ; 0x558fc
    db $08 ; asm
    ld hl, $5869
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55906,$55915 - $55906
Route13Text4: ; 0x55915
    db $08 ; asm
    ld hl, $5875
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5591f,$5592e - $5591f
Route13Text5: ; 0x5592e
    db $08 ; asm
    ld hl, $5881
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55938,$55947 - $55938
Route13Text6: ; 0x55947
    db $08 ; asm
    ld hl, $588d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55951,$55960 - $55951
Route13Text7: ; 0x55960
    db $08 ; asm
    ld hl, $5899
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5596a,$55979 - $5596a
Route13Text8: ; 0x55979
    db $08 ; asm
    ld hl, $58a5
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55983,$55992 - $55983
Route13Text9: ; 0x55992
    db $08 ; asm
    ld hl, $58b1
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5599c,$559ab - $5599c
Route13Text10: ; 0x559ab
    db $08 ; asm
    ld hl, $58bd
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$559b5,$f

Route13Text11: ; 0x559c4
    TX_FAR _Route13Text11
    db $50

Route13Text12: ; 0x559c9
    TX_FAR _Route13Text12
    db $50

Route13Text13: ; 0x559ce
    TX_FAR _Route13Text13
    db $50

INCBIN "baserom.gbc",$559d3,$55a7b - $559d3
Route14Text1: ; 0x55a7b
    db $08 ; asm
    ld hl, $5a02
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55a85,$55a94 - $55a85
Route14Text2: ; 0x55a94
    db $08 ; asm
    ld hl, $5a0e
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55a9e,$55aad - $55a9e
Route14Text3: ; 0x55aad
    db $08 ; asm
    ld hl, $5a1a
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55ab7,$55ac6 - $55ab7
Route14Text4: ; 0x55ac6
    db $08 ; asm
    ld hl, $5a26
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55ad0,$55adf - $55ad0
Route14Text5: ; 0x55adf
    db $08 ; asm
    ld hl, $5a32
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55ae9,$55af8 - $55ae9
Route14Text6: ; 0x55af8
    db $08 ; asm
    ld hl, $5a3e
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55b02,$55b11 - $55b02
Route14Text7: ; 0x55b11
    db $08 ; asm
    ld hl, $5a4a
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55b1b,$55b2a - $55b1b
Route14Text8: ; 0x55b2a
    db $08 ; asm
    ld hl, $5a56
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55b34,$55b43 - $55b34
Route14Text9: ; 0x55b43
    db $08 ; asm
    ld hl, $5a62
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55b4d,$55b5c - $55b4d
Route14Text10: ; 0x55b5c
    db $08 ; asm
    ld hl, $5a6e
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55b66,$f

Route14Text11: ; 0x55b75
    TX_FAR _Route14Text11
    db $50

INCBIN "baserom.gbc",$55b7a,$55c2c - $55b7a
Route17Text1: ; 0x55c2c
    db $08 ; asm
    ld hl, $5bb3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55c36,$55c45 - $55c36
Route17Text2: ; 0x55c45
    db $08 ; asm
    ld hl, $5bbf
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55c4f,$55c5e - $55c4f
Route17Text3: ; 0x55c5e
    db $08 ; asm
    ld hl, $5bcb
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55c68,$55c77 - $55c68
Route17Text4: ; 0x55c77
    db $08 ; asm
    ld hl, $5bd7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55c81,$55c90 - $55c81
Route17Text5: ; 0x55c90
    db $08 ; asm
    ld hl, $5be3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55c9a,$55ca9 - $55c9a
Route17Text6: ; 0x55ca9
    db $08 ; asm
    ld hl, $5bef
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55cb3,$55cc2 - $55cb3
Route17Text7: ; 0x55cc2
    db $08 ; asm
    ld hl, $5bfb
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55ccc,$55cdb - $55ccc
Route17Text8: ; 0x55cdb
    db $08 ; asm
    ld hl, $5c07
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55ce5,$55cf4 - $55ce5
Route17Text9: ; 0x55cf4
    db $08 ; asm
    ld hl, $5c13
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55cfe,$55d0d - $55cfe
Route17Text10: ; 0x55d0d
    db $08 ; asm
    ld hl, $5c1f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55d17,$f

Route17Text11: ; 0x55d26
    TX_FAR _Route17Text11
    db $50

Route17Text12: ; 0x55d2b
    TX_FAR _Route17Text12
    db $50

Route17Text13: ; 0x55d30
    TX_FAR _Route17Text13
    db $50

Route17Text14: ; 0x55d35
    TX_FAR _Route17Text14
    db $50

Route17Text15: ; 0x55d3a
    TX_FAR _Route17Text15
    db $50

Route17Text16: ; 0x55d3f
    TX_FAR _Route17Text16
    db $50

INCBIN "baserom.gbc",$55d44,$55dec - $55d44
Route19Text1: ; 0x55dec
    db $08 ; asm
    ld hl, $5d73
    call LoadTrainerHeader
    jp $24d7

Route19Text2: ; 0x55df6
    db $08 ; asm
    ld hl, $5d7f
    call LoadTrainerHeader
    jp $24d7

Route19Text3: ; 0x55e00
    db $08 ; asm
    ld hl, $5d8b
    call LoadTrainerHeader
    jp $24d7

Route19Text4: ; 0x55e0a
    db $08 ; asm
    ld hl, $5d97
    call LoadTrainerHeader
    jp $24d7

Route19Text5: ; 0x55e14
    db $08 ; asm
    ld hl, $5da3
    call LoadTrainerHeader
    jp $24d7

Route19Text6: ; 0x55e1e
    db $08 ; asm
    ld hl, $5daf
    call LoadTrainerHeader
    jp $24d7

Route19Text7: ; 0x55e28
    db $08 ; asm
    ld hl, $5dbb
    call LoadTrainerHeader
    jp $24d7

Route19Text8: ; 0x55e32
    db $08 ; asm
    ld hl, $5dc7
    call LoadTrainerHeader
    jp $24d7

Route19Text9: ; 0x55e3c
    db $08 ; asm
    ld hl, $5dd3
    call LoadTrainerHeader
    jp $24d7

Route19Text10: ; 0x55e46
    db $08 ; asm
    ld hl, $5ddf
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55e50,$96

Route19Text11: ; 0x55ee6
    TX_FAR _Route19Text11
    db $50

INCBIN "baserom.gbc",$55eeb,$55f83 - $55eeb
Route21Text1: ; 0x55f83
    db $08 ; asm
    ld hl, $5f16
    call LoadTrainerHeader
    jp $24d7

Route21Text2: ; 0x55f8d
    db $08 ; asm
    ld hl, $5f22
    call LoadTrainerHeader
    jp $24d7

Route21Text3: ; 0x55f97
    db $08 ; asm
    ld hl, $5f2e
    call LoadTrainerHeader
    jp $24d7

Route21Text4: ; 0x55fa1
    db $08 ; asm
    ld hl, $5f3a
    call LoadTrainerHeader
    jp $24d7

Route21Text5: ; 0x55fab
    db $08 ; asm
    ld hl, $5f46
    call LoadTrainerHeader
    jp $24d7

Route21Text6: ; 0x55fb5
    db $08 ; asm
    ld hl, $5f52
    call LoadTrainerHeader
    jp $24d7

Route21Text7: ; 0x55fbf
    db $08 ; asm
    ld hl, $5f5e
    call LoadTrainerHeader
    jp $24d7

Route21Text8: ; 0x55fc9
    db $08 ; asm
    ld hl, $5f6a
    call LoadTrainerHeader
    jp $24d7

Route21Text9: ; 0x55fd3
    db $08 ; asm
    ld hl, $5f76
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$55fdd,$87

VermilionHouse2_h: ; 0x56064 to 0x56070 (12 bytes) (id=163)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $522f, $6073, $6070 ; blocks, texts, scripts
    db $00 ; connections

    dw $60cf ; objects

INCBIN "baserom.gbc",$56070,$56075 - $56070
VermilionHouse2Text1: ; 0x56075
    db $08 ; asm
    ld a, [$d728]
    bit 3, a
    jr nz, .asm_03ef5 ; 0x5607b
    ld hl, $60b1
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_eb1b7 ; 0x5608a
    ld bc,(OLD_ROD << 8) | 1
    call $3e2e
    jr nc, .asm_fd67b ; 0x56092
    ld hl, $d728
    set 3, [hl]
    ld hl, $60b6
    jr .asm_5dd95 ; 0x5609c
.asm_fd67b ; 0x5609e
    ld hl, $60ca
    jr .asm_5dd95 ; 0x560a1
.asm_eb1b7 ; 0x560a3
    ld hl, $60c0
    jr .asm_5dd95 ; 0x560a6
.asm_03ef5 ; 0x560a8
    ld hl, $60c5
.asm_5dd95 ; 0x560ab
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$560b1,$1e
VermilionHouse2Object: ; 0x560cf (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $8, $ff
    db $7, $3, $8, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $4 + 4, $2 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

CeladonMart2_h: ; 0x560e9 to 0x560f5 (12 bytes) (id=123)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMart2Blocks, $60f8, $60f5 ; blocks, texts, scripts
    db $00 ; connections

    dw $6111 ; objects

INCBIN "baserom.gbc",$560f5,$56102 - $560f5

CeladonMart2Text3: ; 0x56102
    TX_FAR _CeladonMart2Text3
    db $50

CeladonMart2Text4: ; 0x56107
    TX_FAR _CeladonMart2Text4
    db $50

CeladonMart2Text5: ; 0x5610c
    TX_FAR _CeladonMart2Text5
    db $50

CeladonMart2Object: ; 0x56111 (size=55)
    db $f ; border tile

    db $3 ; warps
    db $1, $c, $4, CELADON_MART_1
    db $1, $10, $1, CELADON_MART_3
    db $1, $1, $0, CELADON_MART_ELEVATOR

    db $1 ; signs
    db $1, $e, $5 ; CeladonMart2Text5

    db $4 ; people
    db SPRITE_MART_GUY, $3 + 4, $5 + 4, $ff, $d0, $1 ; person
    db SPRITE_MART_GUY, $3 + 4, $6 + 4, $ff, $d0, $2 ; person
    db SPRITE_FAT_BALD_GUY, $5 + 4, $13 + 4, $ff, $ff, $3 ; person
    db SPRITE_GIRL, $4 + 4, $e + 4, $fe, $1, $4 ; person

    ; warp-to
    EVENT_DISP $a, $1, $c ; CELADON_MART_1
    EVENT_DISP $a, $1, $10 ; CELADON_MART_3
    EVENT_DISP $a, $1, $1 ; CELADON_MART_ELEVATOR

CeladonMart2Blocks: ; 40
    INCBIN "maps/celadonmart2.blk"

FuchsiaHouse3_h: ; 0x56170 to 0x5617c (12 bytes) (id=164)
    db $0d ; tileset
    db $04, $04 ; dimensions (y, x)
    dw FuchsiaHouse3Blocks, $617f, $617c ; blocks, texts, scripts
    db $00 ; connections

    dw $6221 ; objects

INCBIN "baserom.gbc",$5617c,$56181 - $5617c
FuchsiaHouse3Text1: ; 0x56181
    db $08 ; asm
    ld a, [$d728]
    bit 4, a
    jr nz, .asm_6084e ; 0x56187
    ld hl, $61bd
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_3ace4 ; 0x56196
    ld bc,(GOOD_ROD << 8) | 1
    call $3e2e
    jr nc, .asm_628ee ; 0x5619e
    ld hl, $d728
    set 4, [hl]
    ld hl, $61c2
    jr .asm_1b09c ; 0x561a8
.asm_628ee ; 0x561aa
    ld hl, $621c
    jr .asm_1b09c ; 0x561ad
.asm_3ace4 ; 0x561af
    ld hl, $6212
    jr .asm_1b09c ; 0x561b2
.asm_6084e ; 0x561b4
    ld hl, $6217
.asm_1b09c ; 0x561b7
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$561bd,$64
FuchsiaHouse3Object: ; 0x56221 (size=34)
    db $c ; border tile

    db $3 ; warps
    db $0, $2, $8, $ff
    db $7, $2, $7, $ff
    db $7, $3, $7, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $3 + 4, $5 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $0, $2
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

DayCareM_h: ; 0x56243 to 0x5624f (12 bytes) (id=72)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw DayCareMBlocks, $6252, $624f ; blocks, texts, scripts
    db $00 ; connections

    dw $6459 ; objects

INCBIN "baserom.gbc",$5624f,$56459 - $5624f
DayCareMObject: ; 0x56459 (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $4, $ff
    db $7, $3, $4, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_GENTLEMAN, $3 + 4, $2 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

Route12House_h: ; 0x56473 to 0x5647f (12 bytes) (id=189)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $522f, $6482, $647f ; blocks, texts, scripts
    db $00 ; connections

    dw $64de ; objects

INCBIN "baserom.gbc",$5647f,$56484 - $5647f
Route12HouseText1: ; 0x56484
    db $08 ; asm
    ld a, [$d728]
    bit 5, a
    jr nz, .asm_b4cad ; 0x5648a
    ld hl, $64c0
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_a2d76 ; 0x56499
    ld bc,(SUPER_ROD << 8) | 1
    call $3e2e
    jr nc, .asm_e3b89 ; 0x564a1
    ld hl, $d728
    set 5, [hl]
    ld hl, $64c5
    jr .asm_df984 ; 0x564ab
.asm_e3b89 ; 0x564ad
    ld hl, $64d9
    jr .asm_df984 ; 0x564b0
.asm_a2d76 ; 0x564b2
    ld hl, $64cf
    jr .asm_df984 ; 0x564b5
.asm_b4cad ; 0x564b7
    ld hl, $64d4
.asm_df984 ; 0x564ba
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$564c0,$1e
Route12HouseObject: ; 0x564de (size=26)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $3, $ff
    db $7, $3, $3, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_FISHER, $4 + 4, $2 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

SilphCo8_h: ; 0x564f8 to 0x56504 (12 bytes) (id=213)
    db $16 ; tileset
    db $09, $0d ; dimensions (y, x)
    dw SilphCo8Blocks, $657d, $6504 ; blocks, texts, scripts
    db $00 ; connections

    dw $6613 ; objects

INCBIN "baserom.gbc",$56504,$565aa - $56504
SilphCo8Text1: ; 0x565aa
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    ld hl, $65c3
    jr nz, .asm_a468f ; 0x565b3
    ld hl, $65be
.asm_a468f ; 0x565b8
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$565be,$565c8 - $565be
SilphCo8Text2: ; 0x565c8
    db $08 ; asm
    ld hl, $6585
    call LoadTrainerHeader
    jp $24d7

SilphCo8Text3: ; 0x565d2
    db $08 ; asm
    ld hl, $6591
    call LoadTrainerHeader
    jp $24d7

SilphCo8Text4: ; 0x565dc
    db $08 ; asm
    ld hl, $659d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$565e6,$2d
SilphCo8Object: ; 0x56613 (size=90)
    db $2e ; border tile

    db $7 ; warps
    db $0, $10, $1, SILPH_CO_9F
    db $0, $e, $0, SILPH_CO_7F
    db $0, $12, $0, SILPH_CO_ELEVATOR
    db $b, $3, $6, SILPH_CO_8F
    db $f, $3, $4, SILPH_CO_2F
    db $5, $b, $5, SILPH_CO_2F
    db $9, $b, $3, SILPH_CO_8F

    db $0 ; signs

    db $4 ; people
    db SPRITE_LAPRAS_GIVER, $2 + 4, $4 + 4, $ff, $ff, $1 ; person
    db SPRITE_ROCKET, $2 + 4, $13 + 4, $ff, $d2, $42, ROCKET + $C8, $23 ; trainer
    db SPRITE_OAK_AIDE, $2 + 4, $a + 4, $ff, $d0, $43, SCIENTIST + $C8, $9 ; trainer
    db SPRITE_ROCKET, $f + 4, $c + 4, $ff, $d3, $44, ROCKET + $C8, $24 ; trainer

    ; warp-to
    EVENT_DISP $d, $0, $10 ; SILPH_CO_9F
    EVENT_DISP $d, $0, $e ; SILPH_CO_7F
    EVENT_DISP $d, $0, $12 ; SILPH_CO_ELEVATOR
    EVENT_DISP $d, $b, $3 ; SILPH_CO_8F
    EVENT_DISP $d, $f, $3 ; SILPH_CO_2F
    EVENT_DISP $d, $5, $b ; SILPH_CO_2F
    EVENT_DISP $d, $9, $b ; SILPH_CO_8F

SilphCo8Blocks: ; 117
    INCBIN "maps/silphco8.blk"

INCBIN "baserom.gbc",$566e2,$191e

SECTION "bank16",DATA,BANK[$16]
Route6_h: ; 0x58000 to 0x58022 (34 bytes) (id=17)
    db $00 ; tileset
    db $12, $0a ; dimensions (y, x)
    dw Route6Blocks, $50c9, $50b0 ; blocks, texts, scripts
    db NORTH | SOUTH ; connections

    ; connections data

	db SAFFRON_CITY
    dw $4bc6, $c6e8 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $23, $0a ; alignments (y, x)
    dw $c8bd ; window

	db VERMILION_CITY
    dw $4a41, $c838 ; pointers (connected, current) (strip)
    db $10, $14 ; bigness, width
    db $00, $0a ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $4022 ; objects

Route6Object: ; 0x58022 (size=87)
    db $f ; border tile

    db $4 ; warps
    db $1, $9, $2, ROUTE_6_GATE
    db $1, $a, $2, ROUTE_6_GATE
    db $7, $a, $0, ROUTE_6_GATE
    db $d, $11, $0, PATH_ENTRANCE_ROUTE_6

    db $1 ; signs
    db $f, $13, $7 ; Route6Text7

    db $6 ; people
    db SPRITE_BLACK_HAIR_BOY_1, $15 + 4, $a + 4, $ff, $d3, $41, JR__TRAINER_M + $C8, $4 ; trainer
    db SPRITE_LASS, $15 + 4, $b + 4, $ff, $d2, $42, JR__TRAINER_F + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $f + 4, $0 + 4, $ff, $d3, $43, BUG_CATCHER + $C8, $a ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $1f + 4, $b + 4, $ff, $d2, $44, JR__TRAINER_M + $C8, $5 ; trainer
    db SPRITE_LASS, $1e + 4, $b + 4, $ff, $d2, $45, JR__TRAINER_F + $C8, $3 ; trainer
    db SPRITE_BUG_CATCHER, $1a + 4, $13 + 4, $ff, $d2, $46, BUG_CATCHER + $C8, $b ; trainer

    ; warp-to
    EVENT_DISP $a, $1, $9 ; ROUTE_6_GATE
    EVENT_DISP $a, $1, $a ; ROUTE_6_GATE
    EVENT_DISP $a, $7, $a ; ROUTE_6_GATE
    EVENT_DISP $a, $d, $11 ; PATH_ENTRANCE_ROUTE_6

Route6Blocks: ; 180
    INCBIN "maps/route6.blk"

Route8_h: ; 0x5812d to 0x5814f (34 bytes) (id=19)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route8Blocks, $51cf, $51b6 ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db SAFFRON_CITY
    dw $4abd, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $27 ; alignments (y, x)
    dw $c716 ; window

	db LAVENDER_TOWN
    dw $4085, $c775 ; pointers (connected, current) (strip)
    db $09, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $414f ; objects

Route8Object: ; 0x5814f (size=119)
    db $2c ; border tile

    db $5 ; warps
    db $9, $1, $0, ROUTE_8_GATE
    db $a, $1, $1, ROUTE_8_GATE
    db $9, $8, $2, ROUTE_8_GATE
    db $a, $8, $3, ROUTE_8_GATE
    db $3, $d, $0, PATH_ENTRANCE_ROUTE_8

    db $1 ; signs
    db $3, $11, $a ; Route8Text10

    db $9 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $8 + 4, $ff, $d3, $41, SUPER_NERD + $C8, $3 ; trainer
    db SPRITE_GAMBLER, $9 + 4, $d + 4, $ff, $d1, $42, GAMBLER + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $6 + 4, $2a + 4, $ff, $d1, $43, SUPER_NERD + $C8, $4 ; trainer
    db SPRITE_LASS, $3 + 4, $1a + 4, $ff, $d2, $44, LASS + $C8, $d ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $4 + 4, $1a + 4, $ff, $d3, $45, SUPER_NERD + $C8, $5 ; trainer
    db SPRITE_LASS, $5 + 4, $1a + 4, $ff, $d2, $46, LASS + $C8, $e ; trainer
    db SPRITE_LASS, $6 + 4, $1a + 4, $ff, $d3, $47, LASS + $C8, $f ; trainer
    db SPRITE_GAMBLER, $d + 4, $2e + 4, $ff, $d0, $48, GAMBLER + $C8, $7 ; trainer
    db SPRITE_LASS, $c + 4, $33 + 4, $ff, $d2, $49, LASS + $C8, $10 ; trainer

    ; warp-to
    EVENT_DISP $1e, $9, $1 ; ROUTE_8_GATE
    EVENT_DISP $1e, $a, $1 ; ROUTE_8_GATE
    EVENT_DISP $1e, $9, $8 ; ROUTE_8_GATE
    EVENT_DISP $1e, $a, $8 ; ROUTE_8_GATE
    EVENT_DISP $1e, $3, $d ; PATH_ENTRANCE_ROUTE_8

Route8Blocks: ; 270
    INCBIN "maps/route8.blk"

Route10_h: ; 0x582d4 to 0x582f6 (34 bytes) (id=21)
    db $00 ; tileset
    db $24, $0a ; dimensions (y, x)
    dw Route10Blocks, $534f, $5336 ; blocks, texts, scripts
    db SOUTH | WEST ; connections

    ; connections data

	db LAVENDER_TOWN
    dw $4085, $c95b ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

	db ROUTE_9
    dw $4719, $c718 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $00, $3b ; alignments (y, x)
    dw $c72a ; window

    ; end connection data

    dw $42f6 ; objects

Route10Object: ; 0x582f6 (size=96)
    db $2c ; border tile

    db $4 ; warps
    db $13, $b, $0, ROCK_TUNNEL_POKECENTER
    db $11, $8, $0, ROCK_TUNNEL_1
    db $35, $8, $2, ROCK_TUNNEL_1
    db $27, $6, $0, POWER_PLANT

    db $4 ; signs
    db $13, $7, $7 ; Route10Text7
    db $13, $c, $8 ; Route10Text8
    db $37, $9, $9 ; Route10Text9
    db $29, $5, $a ; Route10Text10

    db $6 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $2c + 4, $a + 4, $ff, $d2, $41, POKEMANIAC + $C8, $1 ; trainer
    db SPRITE_HIKER, $39 + 4, $3 + 4, $ff, $d1, $42, HIKER + $C8, $7 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $40 + 4, $e + 4, $ff, $d2, $43, POKEMANIAC + $C8, $2 ; trainer
    db SPRITE_LASS, $19 + 4, $7 + 4, $ff, $d2, $44, JR__TRAINER_F + $C8, $7 ; trainer
    db SPRITE_HIKER, $3d + 4, $3 + 4, $ff, $d0, $45, HIKER + $C8, $8 ; trainer
    db SPRITE_LASS, $36 + 4, $7 + 4, $ff, $d0, $46, JR__TRAINER_F + $C8, $8 ; trainer

    ; warp-to
    EVENT_DISP $a, $13, $b ; ROCK_TUNNEL_POKECENTER
    EVENT_DISP $a, $11, $8 ; ROCK_TUNNEL_1
    EVENT_DISP $a, $35, $8 ; ROCK_TUNNEL_1
    EVENT_DISP $a, $27, $6 ; POWER_PLANT

Route10Blocks: ; 360
    INCBIN "maps/route10.blk"

Route11_h: ; 0x584be to 0x584e0 (34 bytes) (id=22)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route11Blocks, $5465, $544c ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db VERMILION_CITY
    dw $4a64, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $27 ; alignments (y, x)
    dw $c716 ; window

	db ROUTE_12
    dw $4800, $c709 ; pointers (connected, current) (strip)
    db $0f, $0a ; bigness, width
    db $36, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $44e0 ; objects

Route11Object: ; 0x584e0 (size=127)
    db $f ; border tile

    db $5 ; warps
    db $8, $31, $0, ROUTE_11_GATE_1F
    db $9, $31, $1, ROUTE_11_GATE_1F
    db $8, $3a, $2, ROUTE_11_GATE_1F
    db $9, $3a, $3, ROUTE_11_GATE_1F
    db $5, $4, $0, DIGLETTS_CAVE_ENTRANCE

    db $1 ; signs
    db $5, $1, $b ; Route11Text11

    db $a ; people
    db SPRITE_GAMBLER, $e + 4, $a + 4, $ff, $d0, $41, GAMBLER + $C8, $1 ; trainer
    db SPRITE_GAMBLER, $9 + 4, $1a + 4, $ff, $d0, $42, GAMBLER + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $5 + 4, $d + 4, $ff, $d2, $43, YOUNGSTER + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $b + 4, $24 + 4, $ff, $d0, $44, ENGINEER + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $4 + 4, $16 + 4, $ff, $d1, $45, YOUNGSTER + $C8, $a ; trainer
    db SPRITE_GAMBLER, $7 + 4, $2d + 4, $ff, $d0, $46, GAMBLER + $C8, $3 ; trainer
    db SPRITE_GAMBLER, $3 + 4, $21 + 4, $ff, $d1, $47, GAMBLER + $C8, $4 ; trainer
    db SPRITE_BUG_CATCHER, $5 + 4, $2b + 4, $ff, $d3, $48, YOUNGSTER + $C8, $b ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $10 + 4, $2d + 4, $ff, $d2, $49, ENGINEER + $C8, $3 ; trainer
    db SPRITE_BUG_CATCHER, $c + 4, $16 + 4, $ff, $d1, $4a, YOUNGSTER + $C8, $c ; trainer

    ; warp-to
    EVENT_DISP $1e, $8, $31 ; ROUTE_11_GATE_1F
    EVENT_DISP $1e, $9, $31 ; ROUTE_11_GATE_1F
    EVENT_DISP $1e, $8, $3a ; ROUTE_11_GATE_1F
    EVENT_DISP $1e, $9, $3a ; ROUTE_11_GATE_1F
    EVENT_DISP $1e, $5, $4 ; DIGLETTS_CAVE_ENTRANCE

Route11Blocks: ; 270
    INCBIN "maps/route11.blk"

Route12_h: ; 0x5866d to 0x5869a (45 bytes) (id=23)
    db $00 ; tileset
    db $36, $0a ; dimensions (y, x)
    dw Route12Blocks, $5675, $55f3 ; blocks, texts, scripts
    db NORTH | SOUTH | WEST ; connections

    ; connections data

	db LAVENDER_TOWN
    dw $40c1, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $11, $00 ; alignments (y, x)
    dw $c779 ; window

	db ROUTE_13
    dw $489c, $ca78 ; pointers (connected, current) (strip)
    db $0d, $1e ; bigness, width
    db $00, $28 ; alignments (y, x)
    dw $c70d ; window

	db ROUTE_11
    dw $457a, $c8c8 ; pointers (connected, current) (strip)
    db $09, $1e ; bigness, width
    db $ca, $3b ; alignments (y, x)
    dw $c72a ; window

    ; end connection data

    dw $469a ; objects

Route12Object: ; 0x5869a (size=118)
    db $43 ; border tile

    db $4 ; warps
    db $f, $a, $0, ROUTE_12_GATE
    db $f, $b, $1, ROUTE_12_GATE
    db $15, $a, $2, ROUTE_12_GATE
    db $4d, $b, $0, ROUTE_12_HOUSE

    db $2 ; signs
    db $d, $d, $b ; Route12Text11
    db $3f, $b, $c ; Route12Text12

    db $a ; people
    db SPRITE_SNORLAX, $3e + 4, $a + 4, $ff, $d0, $1 ; person
    db SPRITE_FISHER2, $1f + 4, $e + 4, $ff, $d2, $42, FISHER + $C8, $3 ; trainer
    db SPRITE_FISHER2, $27 + 4, $5 + 4, $ff, $d1, $43, FISHER + $C8, $4 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $5c + 4, $b + 4, $ff, $d2, $44, JR__TRAINER_M + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $4c + 4, $e + 4, $ff, $d1, $45, ROCKER + $C8, $2 ; trainer
    db SPRITE_FISHER2, $28 + 4, $c + 4, $ff, $d2, $46, FISHER + $C8, $5 ; trainer
    db SPRITE_FISHER2, $34 + 4, $9 + 4, $ff, $d3, $47, FISHER + $C8, $6 ; trainer
    db SPRITE_FISHER2, $57 + 4, $6 + 4, $ff, $d0, $48, FISHER + $C8, $b ; trainer
	db SPRITE_BALL, $23 + 4, $e + 4, $ff, $ff, $89, TM_16 ; item
	db SPRITE_BALL, $59 + 4, $5 + 4, $ff, $ff, $8a, IRON ; item

    ; warp-to
    EVENT_DISP $a, $f, $a ; ROUTE_12_GATE
    EVENT_DISP $a, $f, $b ; ROUTE_12_GATE
    EVENT_DISP $a, $15, $a ; ROUTE_12_GATE
    EVENT_DISP $a, $4d, $b ; ROUTE_12_HOUSE

Route12Blocks: ; 540
    INCBIN "maps/route12.blk"

Route15_h: ; 0x5892c to 0x5894e (34 bytes) (id=26)
    db $00 ; tileset
    db $09, $1e ; dimensions (y, x)
    dw Route15Blocks, $57c7, $57ae ; blocks, texts, scripts
    db WEST | EAST ; connections

    ; connections data

	db FUCHSIA_CITY
    dw $4cab, $c6e8 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $27 ; alignments (y, x)
    dw $c716 ; window

	db ROUTE_14
    dw $4aa8, $c709 ; pointers (connected, current) (strip)
    db $0c, $0a ; bigness, width
    db $24, $00 ; alignments (y, x)
    dw $c6f9 ; window

    ; end connection data

    dw $494e ; objects

Route15Object: ; 0x5894e (size=126)
    db $43 ; border tile

    db $4 ; warps
    db $8, $7, $0, ROUTE_15_GATE
    db $9, $7, $1, ROUTE_15_GATE
    db $8, $e, $2, ROUTE_15_GATE
    db $9, $e, $3, ROUTE_15_GATE

    db $1 ; signs
    db $9, $27, $c ; Route15Text12

    db $b ; people
    db SPRITE_LASS, $b + 4, $29 + 4, $ff, $d0, $41, JR__TRAINER_F + $C8, $14 ; trainer
    db SPRITE_LASS, $a + 4, $35 + 4, $ff, $d2, $42, JR__TRAINER_F + $C8, $15 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $d + 4, $1f + 4, $ff, $d1, $43, BIRD_KEEPER + $C8, $6 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $d + 4, $23 + 4, $ff, $d1, $44, BIRD_KEEPER + $C8, $7 ; trainer
    db SPRITE_FOULARD_WOMAN, $b + 4, $35 + 4, $ff, $d0, $45, BEAUTY + $C8, $9 ; trainer
    db SPRITE_FOULARD_WOMAN, $a + 4, $29 + 4, $ff, $d3, $46, BEAUTY + $C8, $a ; trainer
    db SPRITE_BIKER, $a + 4, $30 + 4, $ff, $d0, $47, BIKER + $C8, $3 ; trainer
    db SPRITE_BIKER, $a + 4, $2e + 4, $ff, $d0, $48, BIKER + $C8, $4 ; trainer
    db SPRITE_LASS, $5 + 4, $25 + 4, $ff, $d3, $49, JR__TRAINER_F + $C8, $16 ; trainer
    db SPRITE_LASS, $d + 4, $12 + 4, $ff, $d1, $4a, JR__TRAINER_F + $C8, $17 ; trainer
	db SPRITE_BALL, $5 + 4, $12 + 4, $ff, $ff, $8b, TM_20 ; item

    ; warp-to
    EVENT_DISP $1e, $8, $7 ; ROUTE_15_GATE
    EVENT_DISP $1e, $9, $7 ; ROUTE_15_GATE
    EVENT_DISP $1e, $8, $e ; ROUTE_15_GATE
    EVENT_DISP $1e, $9, $e ; ROUTE_15_GATE

Route15Blocks: ; 270
    INCBIN "maps/route15.blk"

Route16_h: ; 0x58ada to 0x58afc (34 bytes) (id=27)
    db $00 ; tileset
    db $09, $14 ; dimensions (y, x)
    dw Route16Blocks, $59b9, $5933 ; blocks, texts, scripts
    db SOUTH | EAST ; connections

    ; connections data

	db ROUTE_17
    dw $4ba8, $c823 ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $00, $00 ; alignments (y, x)
    dw $c6f9 ; window

	db CELADON_CITY
    dw $40f8, $c6ff ; pointers (connected, current) (strip)
    db $0f, $19 ; bigness, width
    db $08, $00 ; alignments (y, x)
    dw $c708 ; window

    ; end connection data

    dw $4afc ; objects

Route16Object: ; 0x58afc (size=136)
    db $f ; border tile

    db $9 ; warps
    db $a, $11, $0, ROUTE_16_GATE_1F
    db $b, $11, $1, ROUTE_16_GATE_1F
    db $a, $18, $2, ROUTE_16_GATE_1F
    db $b, $18, $3, ROUTE_16_GATE_1F
    db $4, $11, $4, ROUTE_16_GATE_1F
    db $5, $11, $5, ROUTE_16_GATE_1F
    db $4, $18, $6, ROUTE_16_GATE_1F
    db $5, $18, $7, ROUTE_16_GATE_1F
    db $5, $7, $0, ROUTE_16_HOUSE

    db $2 ; signs
    db $b, $1b, $8 ; Route16Text8
    db $11, $5, $9 ; Route16Text9

    db $7 ; people
    db SPRITE_BIKER, $c + 4, $11 + 4, $ff, $d2, $41, BIKER + $C8, $5 ; trainer
    db SPRITE_BIKER, $d + 4, $e + 4, $ff, $d3, $42, CUE_BALL + $C8, $1 ; trainer
    db SPRITE_BIKER, $c + 4, $b + 4, $ff, $d1, $43, CUE_BALL + $C8, $2 ; trainer
    db SPRITE_BIKER, $b + 4, $9 + 4, $ff, $d2, $44, BIKER + $C8, $6 ; trainer
    db SPRITE_BIKER, $a + 4, $6 + 4, $ff, $d3, $45, CUE_BALL + $C8, $3 ; trainer
    db SPRITE_BIKER, $c + 4, $3 + 4, $ff, $d3, $46, BIKER + $C8, $7 ; trainer
    db SPRITE_SNORLAX, $a + 4, $1a + 4, $ff, $d0, $7 ; person

    ; warp-to
    EVENT_DISP $14, $a, $11 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $b, $11 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $a, $18 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $b, $18 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $4, $11 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $5, $11 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $4, $18 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $5, $18 ; ROUTE_16_GATE_1F
    EVENT_DISP $14, $5, $7 ; ROUTE_16_HOUSE

Route16Blocks: ; 180
    INCBIN "maps/route16.blk"

Route18_h: ; 0x58c38 to 0x58c5a (34 bytes) (id=29)
    db $00 ; tileset
    db $09, $19 ; dimensions (y, x)
    dw Route18Blocks, $5ae0, $5ac7 ; blocks, texts, scripts
    db NORTH | EAST ; connections

    ; connections data

	db ROUTE_17
    dw $4e5a, $c6eb ; pointers (connected, current) (strip)
    db $0a, $0a ; bigness, width
    db $8f, $00 ; alignments (y, x)
    dw $cb69 ; window

	db FUCHSIA_CITY
    dw $4c9a, $c704 ; pointers (connected, current) (strip)
    db $0f, $14 ; bigness, width
    db $08, $00 ; alignments (y, x)
    dw $c703 ; window

    ; end connection data

    dw $4c5a ; objects

Route18Object: ; 0x58c5a (size=66)
    db $43 ; border tile

    db $4 ; warps
    db $8, $21, $0, ROUTE_18_GATE_1F
    db $9, $21, $1, ROUTE_18_GATE_1F
    db $8, $28, $2, ROUTE_18_GATE_1F
    db $9, $28, $3, ROUTE_18_GATE_1F

    db $2 ; signs
    db $7, $2b, $4 ; Route18Text4
    db $5, $21, $5 ; Route18Text5

    db $3 ; people
    db SPRITE_BLACK_HAIR_BOY_1, $b + 4, $24 + 4, $ff, $d3, $41, BIRD_KEEPER + $C8, $8 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $f + 4, $28 + 4, $ff, $d2, $42, BIRD_KEEPER + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $d + 4, $2a + 4, $ff, $d2, $43, BIRD_KEEPER + $C8, $a ; trainer

    ; warp-to
    EVENT_DISP $19, $8, $21 ; ROUTE_18_GATE_1F
    EVENT_DISP $19, $9, $21 ; ROUTE_18_GATE_1F
    EVENT_DISP $19, $8, $28 ; ROUTE_18_GATE_1F
    EVENT_DISP $19, $9, $28 ; ROUTE_18_GATE_1F

Route18Blocks: ; 225
    INCBIN "maps/route18.blk"

INCBIN "baserom.gbc",$58d7d,$59120 - $58d7d
Route6Text1: ; 0x59120
    db $8
    ld hl, $50d7
    call $31cc
    jp $24d7
; 0x5912a
INCBIN "baserom.gbc",$5912a,$f
Route6Text2: ; 0x59139
    db $08 ; asm
    ld hl, $50e3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59143,$5914d - $59143
Route6Text3: ; 0x5914d
    db $08 ; asm
    ld hl, $50ef
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59157,$59166 - $59157
Route6Text4: ; 0x59166
    db $08 ; asm
    ld hl, $50fb
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59170,$5917f - $59170
Route6Text5: ; 0x5917f
    db $08 ; asm
    ld hl, $5107
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59189,$59198 - $59189
Route6Text6: ; 0x59198
    db $08 ; asm
    ld hl, $5113
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$591a2,$f

Route6Text7: ; 0x591b1
    TX_FAR _Route6Text7
    db $50

INCBIN "baserom.gbc",$591b6,$59269 - $591b6
Route8Text2: ; 0x59269
    db $08 ; asm
    ld hl, $51ef
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59273,$59282 - $59273
Route8Text3: ; 0x59282
    db $08 ; asm
    ld hl, $51fb
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5928c,$5929b - $5928c
Route8Text4: ; 0x5929b
    db $08 ; asm
    ld hl, $5207
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$592a5,$592b4 - $592a5
Route8Text5: ; 0x592b4
    db $08 ; asm
    ld hl, $5213
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$592be,$592cd - $592be
Route8Text6: ; 0x592cd
    db $08 ; asm
    ld hl, $521f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$592d7,$592e6 - $592d7
Route8Text7: ; 0x592e6
    db $08 ; asm
    ld hl, $522b
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$592f0,$592ff - $592f0
Route8Text8: ; 0x592ff
    db $08 ; asm
    ld hl, $5237
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59309,$59318 - $59309
Route8Text9: ; 0x59318
    db $08 ; asm
    ld hl, $5243
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59322,$f

Route8Text10: ; 0x59331
    TX_FAR _Route8Text10
    db $50

INCBIN "baserom.gbc",$59336,$593ac - $59336
Route10Text1: ; 0x593ac
    db $08 ; asm
    ld hl, $5363
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$593b6,$593c5 - $593b6
Route10Text2: ; 0x593c5
    db $08 ; asm
    ld hl, $536f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$593cf,$593de - $593cf
Route10Text3: ; 0x593de
    db $08 ; asm
    ld hl, $537b
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$593e8,$593f7 - $593e8
Route10Text4: ; 0x593f7
    db $08 ; asm
    ld hl, $5387
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59401,$59410 - $59401
Route10Text5: ; 0x59410
    db $08 ; asm
    ld hl, $5393
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5941a,$59429 - $5941a
Route10Text6: ; 0x59429
    db $08 ; asm
    ld hl, $539f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59433,$f

Route10Text9: ; 0x59442
Route10Text7: ; 0x59442
    TX_FAR _Route10Text7 ; _Route10Text9
    db $50

Route10Text10: ; 0x59447
    TX_FAR _Route10Text10
    db $50

INCBIN "baserom.gbc",$5944c,$5950d - $5944c
Route11Text2: ; 0x5950d
    db $08 ; asm
    ld hl, $5487
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59517,$59526 - $59517
Route11Text3: ; 0x59526
    db $08 ; asm
    ld hl, $5493
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59530,$5953f - $59530
Route11Text4: ; 0x5953f
    db $08 ; asm
    ld hl, $549f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59549,$59558 - $59549
Route11Text5: ; 0x59558
    db $08 ; asm
    ld hl, $54ab
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59562,$59571 - $59562
Route11Text6: ; 0x59571
    db $08 ; asm
    ld hl, $54b7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5957b,$5958a - $5957b
Route11Text7: ; 0x5958a
    db $08 ; asm
    ld hl, $54c3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59594,$595a3 - $59594
Route11Text8: ; 0x595a3
    db $08 ; asm
    ld hl, $54cf
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$595ad,$595bc - $595ad
Route11Text9: ; 0x595bc
    db $08 ; asm
    ld hl, $54db
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$595c6,$595d5 - $595c6
Route11Text10: ; 0x595d5
    db $08 ; asm
    ld hl, $54e7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$595df,$f

Route11Text11: ; 0x595ee
    TX_FAR _Route11Text11
    db $50

INCBIN "baserom.gbc",$595f3,$596e6 - $595f3

Route12Text1: ; 0x596e6
    TX_FAR _Route12Text1
    db $50

INCBIN "baserom.gbc",$596eb,$596f5 - $596eb
Route12Text2: ; 0x596f5
    db $08 ; asm
    ld hl, $5691
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$596ff,$5970e - $596ff
Route12Text3: ; 0x5970e
    db $08 ; asm
    ld hl, $569d
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59718,$59727 - $59718
Route12Text4: ; 0x59727
    db $08 ; asm
    ld hl, $56a9
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59731,$59740 - $59731
Route12Text5: ; 0x59740
    db $08 ; asm
    ld hl, $56b5
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5974a,$59759 - $5974a
Route12Text6: ; 0x59759
    db $08 ; asm
    ld hl, $56c1
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59763,$59772 - $59763
Route12Text7: ; 0x59772
    db $08 ; asm
    ld hl, $56cd
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5977c,$5978b - $5977c
Route12Text8: ; 0x5978b
    db $08 ; asm
    ld hl, $56d9
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59795,$f

Route12Text11: ; 0x597a4
    TX_FAR _Route12Text11
    db $50

Route12Text12: ; 0x597a9
    TX_FAR _Route12Text12
    db $50

INCBIN "baserom.gbc",$597ae,$59858 - $597ae

Route15Text1: ; 0x59858
    db $8 ; asm
    ld hl, $57df
    jr asm_33cb7 ; 0x5985c $34

Route15Text2:
    db $8 ; asm
    ld hl, $57eb
    jr asm_33cb7 ; 0x59862 $2e

Route15Text3:
    db $8 ; asm
    ld hl, $57f7
    jr asm_33cb7 ; 0x59868 $28

Route15Text4:
    db $8 ; asm
    ld hl, $5803
    jr asm_33cb7 ; 0x5986e $22

Route15Text5:
    db $8 ; asm
    ld hl, $580f
    jr asm_33cb7 ; 0x59874 $1c

Route15Text6:
    db $8 ; asm
    ld hl, $581b
    jr asm_33cb7 ; 0x5987a $16

Route15Text7:
    db $8 ; asm
    ld hl, $5827
    jr asm_33cb7 ; 0x59880 $10

Route15Text8:
    db $8 ; asm
    ld hl, $5833
    jr asm_33cb7 ; 0x59886 $a

Route15Text9:
    db $8 ; asm
    ld hl, $583f
    jr asm_33cb7 ; 0x5988c $4

Route15Text10:
    db $8 ; asm
    ld hl, $584b
asm_33cb7: ; 0x59892
    call $31cc
    jp $24d7
; 0x59898

INCBIN "baserom.gbc",$59898,$96

Route15Text12: ; 0x5992e
    TX_FAR _Route15Text12
    db $50

INCBIN "baserom.gbc",$59933,$59a18 - $59933
Route16Text1: ; 0x59a18
    db $08 ; asm
    ld hl, $59cf
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a22,$59a31 - $59a22
Route16Text2: ; 0x59a31
    db $08 ; asm
    ld hl, $59db
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a3b,$59a4a - $59a3b
Route16Text3: ; 0x59a4a
    db $08 ; asm
    ld hl, $59e7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a54,$59a63 - $59a54
Route16Text4: ; 0x59a63
    db $08 ; asm
    ld hl, $59f3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a6d,$59a7c - $59a6d
Route16Text5: ; 0x59a7c
    db $08 ; asm
    ld hl, $59ff
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a86,$59a95 - $59a86
Route16Text6: ; 0x59a95
    db $08 ; asm
    ld hl, $5a0b
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59a9f,$f

Route16Text7: ; 0x59aae
    TX_FAR _Route16Text7
    db $50

INCBIN "baserom.gbc",$59ab3,$59abd - $59ab3

Route16Text8: ; 0x59abd
    TX_FAR _Route16Text8
    db $50

Route16Text9: ; 0x59ac2
    TX_FAR _Route16Text9
    db $50

INCBIN "baserom.gbc",$59ac7,$59b0f - $59ac7
Route18Text1: ; 0x59b0f
    db $08 ; asm
    ld hl, $5aea
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59b19,$59b28 - $59b19
Route18Text2: ; 0x59b28
    db $08 ; asm
    ld hl, $5af6
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59b32,$59b41 - $59b32
Route18Text3: ; 0x59b41
    db $08 ; asm
    ld hl, $5b02
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59b4b,$f

Route18Text4: ; 0x59b5a
    TX_FAR _Route18Text4
    db $50

Route18Text5: ; 0x59b5f
    TX_FAR _Route18Text5
    db $50

FanClub_h: ; 0x59b64 to 0x59b70 (12 bytes) (id=90)
    db $10 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw FanClubBlocks, $5b84, $5b70 ; blocks, texts, scripts
    db $00 ; connections

    dw $5c97 ; objects

INCBIN "baserom.gbc",$59b70,$59b94 - $59b70
FanClubText1: ; 0x59b94
    db $08 ; asm
    ld a, [$d771]
    bit 7, a
    jr nz, .asm_67b22 ; 0x59b9a
    ld hl, $5bb7
    call PrintText
    ld hl, $d771
    set 6, [hl]
    jr .asm_64f01 ; 0x59ba7
.asm_67b22 ; 0x59ba9
    ld hl, $5bbc
    call PrintText
    ld hl, $d771
    res 7, [hl]
.asm_64f01 ; 0x59bb4
    jp $24d7

INCBIN "baserom.gbc",$59bb7,$59bc1 - $59bb7
FanClubText2: ; 0x59bc1
    db $08 ; asm
    ld a, [$d771]
    bit 6, a
    jr nz, .asm_5cd59 ; 0x59bc7
    ld hl, $5be4
    call PrintText
    ld hl, $d771
    set 7, [hl]
    jr .asm_59625 ; 0x59bd4
.asm_5cd59 ; 0x59bd6
    ld hl, $5be9
    call PrintText
    ld hl, $d771
    res 6, [hl]
.asm_59625 ; 0x59be1
    jp $24d7

INCBIN "baserom.gbc",$59be4,$59c05 - $59be4
FanClubText4: ; 0x59c05
    db $08 ; asm
    ld hl, $5c17
    call PrintText
	ld a,SEEL
    call $13d0
    call $3748
    jp $24d7

INCBIN "baserom.gbc",$59c17,$59c1c - $59c17
FanClubText5: ; 0x59c1c
    db $08 ; asm
    call $5b73
    jr nz, .asm_38bb3 ; 0x59c20
    ld hl, $5c65
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_2c8d7 ; 0x59c2f
    ld hl, $5c6a
    call PrintText
    ld bc,(BIKE_VOUCHER << 8) | 1
    call $3e2e
    jr nc, .asm_867d4 ; 0x59c3d
    ld hl, $5c6f
    call PrintText
    ld hl, $d771
    set 1, [hl]
    jr .asm_d3c26 ; 0x59c4a
.asm_867d4 ; 0x59c4c
    ld hl, $5c83
    call PrintText
    jr .asm_d3c26 ; 0x59c52
.asm_2c8d7 ; 0x59c54
    ld hl, $5c79
    call PrintText
    jr .asm_d3c26 ; 0x59c5a
.asm_38bb3 ; 0x59c5c
    ld hl, $5c7e
    call PrintText
.asm_d3c26 ; 0x59c62
    jp $24d7

INCBIN "baserom.gbc",$59c65,$32
FanClubObject: ; 0x59c97 (size=62)
    db $d ; border tile

    db $2 ; warps
    db $7, $2, $1, $ff
    db $7, $3, $1, $ff

    db $2 ; signs
    db $0, $1, $7 ; FanClubText7
    db $0, $6, $8 ; FanClubText8

    db $6 ; people
    db SPRITE_FISHER2, $3 + 4, $6 + 4, $ff, $d2, $1 ; person
    db SPRITE_GIRL, $3 + 4, $1 + 4, $ff, $d3, $2 ; person
    db SPRITE_CLEFAIRY, $4 + 4, $6 + 4, $ff, $d2, $3 ; person
    db SPRITE_SEEL, $4 + 4, $1 + 4, $ff, $d3, $4 ; person
    db SPRITE_GENTLEMAN, $1 + 4, $3 + 4, $ff, $d0, $5 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $1 + 4, $5 + 4, $ff, $d0, $6 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

FanClubBlocks: ; 16
    INCBIN "maps/fanclub.blk"

SilphCo2_h: ; 0x59ce5 to 0x59cf1 (12 bytes) (id=207)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SilphCo2Blocks, $5d86, $5cf1 ; blocks, texts, scripts
    db $00 ; connections

    dw $5e66 ; objects

INCBIN "baserom.gbc",$59cf1,$59dc1 - $59cf1
SilphCo2Text1: ; 0x59dc1
    db $08 ; asm
    ld a, [$d826]
    bit 7, a
    jr nz, .asm_b8a0d ; 0x59dc7
    ld hl, $5ded
    call PrintText
    ld bc,(TM_36 << 8) | 1
    call $3e2e
    ld hl, $5dfd
    jr nc, .asm_2c1e0 ; 0x59dd8
    ld hl, $d826
    set 7, [hl]
    ld hl, $5df2
    jr .asm_2c1e0 ; 0x59de2
.asm_b8a0d ; 0x59de4
    ld hl, $5df8
.asm_2c1e0 ; 0x59de7
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$59ded,$59e02 - $59ded
SilphCo2Text2: ; 0x59e02
    db $08 ; asm
    ld hl, $5d90
    call LoadTrainerHeader
    jp $24d7

SilphCo2Text3: ; 0x59e0c
    db $08 ; asm
    ld hl, $5d9c
    call LoadTrainerHeader
    jp $24d7

SilphCo2Text4: ; 0x59e16
    db $08 ; asm
    ld hl, $5da8
    call LoadTrainerHeader
    jp $24d7

SilphCo2Text5: ; 0x59e20
    db $08 ; asm
    ld hl, $5db4
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$59e2a,$3c
SilphCo2Object: ; 0x59e66 (size=98)
    db $2e ; border tile

    db $7 ; warps
    db $0, $18, $2, SILPH_CO_1F
    db $0, $1a, $0, SILPH_CO_3F
    db $0, $14, $0, SILPH_CO_ELEVATOR
    db $3, $3, $6, SILPH_CO_3F
    db $3, $d, $4, SILPH_CO_8F
    db $f, $1b, $5, SILPH_CO_8F
    db $f, $9, $4, SILPH_CO_6F

    db $0 ; signs

    db $5 ; people
    db SPRITE_ERIKA, $1 + 4, $a + 4, $ff, $d1, $1 ; person
    db SPRITE_OAK_AIDE, $c + 4, $5 + 4, $ff, $d0, $42, SCIENTIST + $C8, $2 ; trainer
    db SPRITE_OAK_AIDE, $d + 4, $18 + 4, $ff, $d2, $43, SCIENTIST + $C8, $3 ; trainer
    db SPRITE_ROCKET, $b + 4, $10 + 4, $ff, $d1, $44, ROCKET + $C8, $17 ; trainer
    db SPRITE_ROCKET, $7 + 4, $18 + 4, $ff, $d1, $45, ROCKET + $C8, $18 ; trainer

    ; warp-to
    EVENT_DISP $f, $0, $18 ; SILPH_CO_1F
    EVENT_DISP $f, $0, $1a ; SILPH_CO_3F
    EVENT_DISP $f, $0, $14 ; SILPH_CO_ELEVATOR
    EVENT_DISP $f, $3, $3 ; SILPH_CO_3F
    EVENT_DISP $f, $3, $d ; SILPH_CO_8F
    EVENT_DISP $f, $f, $1b ; SILPH_CO_8F
    EVENT_DISP $f, $f, $9 ; SILPH_CO_6F

SilphCo2Blocks: ; 135
    INCBIN "maps/silphco2.blk"

SilphCo3_h: ; 0x59f4f to 0x59f5b (12 bytes) (id=208)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SilphCo3Blocks, $5fc4, $5f5b ; blocks, texts, scripts
    db $00 ; connections

    dw $6035 ; objects

INCBIN "baserom.gbc",$59f5b,$59fe5 - $59f5b
SilphCo3Text1: ; 0x59fe5
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    ld hl, $5ffe
    jr nz, .asm_8c56f ; 0x59fee
    ld hl, $5ff9
.asm_8c56f ; 0x59ff3
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$59ff9,$5a003 - $59ff9
SilphCo3Text2: ; 0x5a003
    db $08 ; asm
    ld hl, $5fcc
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5a00d,$5a01c - $5a00d
SilphCo3Text3: ; 0x5a01c
    db $08 ; asm
    ld hl, $5fd8
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5a026,$f
SilphCo3Object: ; 0x5a035 (size=113)
    db $2e ; border tile

    db $a ; warps
    db $0, $1a, $1, SILPH_CO_2F
    db $0, $18, $0, SILPH_CO_4F
    db $0, $14, $0, SILPH_CO_ELEVATOR
    db $b, $17, $9, SILPH_CO_3F
    db $3, $3, $5, SILPH_CO_5F
    db $f, $3, $6, SILPH_CO_5F
    db $3, $1b, $3, SILPH_CO_2F
    db $b, $3, $3, SILPH_CO_9F
    db $b, $b, $4, SILPH_CO_7F
    db $f, $1b, $3, SILPH_CO_3F

    db $0 ; signs

    db $4 ; people
    db SPRITE_LAPRAS_GIVER, $8 + 4, $18 + 4, $ff, $ff, $1 ; person
    db SPRITE_ROCKET, $7 + 4, $14 + 4, $ff, $d2, $42, ROCKET + $C8, $19 ; trainer
    db SPRITE_OAK_AIDE, $9 + 4, $7 + 4, $ff, $d0, $43, SCIENTIST + $C8, $4 ; trainer
	db SPRITE_BALL, $5 + 4, $8 + 4, $ff, $ff, $84, HYPER_POTION ; item

    ; warp-to
    EVENT_DISP $f, $0, $1a ; SILPH_CO_2F
    EVENT_DISP $f, $0, $18 ; SILPH_CO_4F
    EVENT_DISP $f, $0, $14 ; SILPH_CO_ELEVATOR
    EVENT_DISP $f, $b, $17 ; SILPH_CO_3F
    EVENT_DISP $f, $3, $3 ; SILPH_CO_5F
    EVENT_DISP $f, $f, $3 ; SILPH_CO_5F
    EVENT_DISP $f, $3, $1b ; SILPH_CO_2F
    EVENT_DISP $f, $b, $3 ; SILPH_CO_9F
    EVENT_DISP $f, $b, $b ; SILPH_CO_7F
    EVENT_DISP $f, $f, $1b ; SILPH_CO_3F

SilphCo3Blocks: ; 135
    INCBIN "maps/silphco3.blk"

SilphCo10_h: ; 0x5a12d to 0x5a139 (12 bytes) (id=234)
    db $16 ; tileset
    db $09, $08 ; dimensions (y, x)
    dw SilphCo10Blocks, $6186, $6139 ; blocks, texts, scripts
    db $00 ; connections

    dw $61fb ; objects

INCBIN "baserom.gbc",$5a139,$5a1ab - $5a139
SilphCo10Text1: ; 0x5a1ab
    db $08 ; asm
    ld hl, $6192
    call LoadTrainerHeader
    jp $24d7

SilphCo10Text2: ; 0x5a1b5
    db $08 ; asm
    ld hl, $619e
    call LoadTrainerHeader
    jp $24d7

SilphCo10Text3: ; 0x5a1bf
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    ld hl, $61d8
    jr nz, .asm_cf85f ; 0x5a1c8
    ld hl, $61d3
.asm_cf85f ; 0x5a1cd
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5a1d3,$28
SilphCo10Object: ; 0x5a1fb (size=95)
    db $2e ; border tile

    db $6 ; warps
    db $0, $8, $0, SILPH_CO_9F
    db $0, $a, $0, SILPH_CO_11F
    db $0, $c, $0, SILPH_CO_ELEVATOR
    db $b, $9, $3, SILPH_CO_4F
    db $f, $d, $5, SILPH_CO_4F
    db $7, $d, $6, SILPH_CO_4F

    db $0 ; signs

    db $6 ; people
    db SPRITE_ROCKET, $9 + 4, $1 + 4, $ff, $d3, $41, ROCKET + $C8, $27 ; trainer
    db SPRITE_OAK_AIDE, $2 + 4, $a + 4, $ff, $d2, $42, SCIENTIST + $C8, $b ; trainer
    db SPRITE_ERIKA, $f + 4, $9 + 4, $fe, $0, $3 ; person
	db SPRITE_BALL, $c + 4, $2 + 4, $ff, $ff, $84, TM_26 ; item
	db SPRITE_BALL, $e + 4, $4 + 4, $ff, $ff, $85, RARE_CANDY ; item
	db SPRITE_BALL, $b + 4, $5 + 4, $ff, $ff, $86, CARBOS ; item

    ; warp-to
    EVENT_DISP $8, $0, $8 ; SILPH_CO_9F
    EVENT_DISP $8, $0, $a ; SILPH_CO_11F
    EVENT_DISP $8, $0, $c ; SILPH_CO_ELEVATOR
    EVENT_DISP $8, $b, $9 ; SILPH_CO_4F
    EVENT_DISP $8, $f, $d ; SILPH_CO_4F
    EVENT_DISP $8, $7, $d ; SILPH_CO_4F

SilphCo10Blocks: ; 72
    INCBIN "maps/silphco10.blk"

Lance_h: ; 0x5a2a2 to 0x5a2ae (12 bytes) (id=113)
    db $05 ; tileset
    db $0d, $0d ; dimensions (y, x)
    dw LanceBlocks, $6395, $62ae ; blocks, texts, scripts
    db $00 ; connections

    dw $63c5 ; objects

INCBIN "baserom.gbc",$5a2ae,$5a3a4 - $5a2ae
LanceText1: ; 0x5a3a4
    db $08 ; asm
    ld hl, $6397
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5a3ae,$17
LanceObject: ; 0x5a3c5 (size=36)
    db $3 ; border tile

    db $3 ; warps
    db $10, $18, $2, AGATHAS_ROOM
    db $0, $5, $0, CHAMPIONS_ROOM
    db $0, $6, $0, CHAMPIONS_ROOM

    db $0 ; signs

    db $1 ; people
    db SPRITE_LANCE, $1 + 4, $6 + 4, $ff, $d0, $41, LANCE + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $d, $10, $18 ; AGATHAS_ROOM
    EVENT_DISP $d, $0, $5 ; CHAMPIONS_ROOM
    EVENT_DISP $d, $0, $6 ; CHAMPIONS_ROOM

LanceBlocks: ; 169
    INCBIN "maps/lance.blk"

HallofFameRoom_h: ; 0x5a492 to 0x5a49e (12 bytes) (id=118)
    db $07 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw HallofFameRoomBlocks, $656a, $649e ; blocks, texts, scripts
    db $00 ; connections

    dw $6571 ; objects

INCBIN "baserom.gbc",$5a49e,$5a56a - $5a49e
HallofFameRoomTexts: ; 0x5a56a
    dw HallofFameRoomText1

HallofFameRoomText1: ; 0x5a56c
    TX_FAR _HallofFameRoomText1
    db $50

HallofFameRoomObject: ; 0x5a571 (size=26)
    db $3 ; border tile

    db $2 ; warps
    db $7, $4, $2, CHAMPIONS_ROOM
    db $7, $5, $3, CHAMPIONS_ROOM

    db $0 ; signs

    db $1 ; people
    db SPRITE_OAK, $2 + 4, $5 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $5, $7, $4 ; CHAMPIONS_ROOM
    EVENT_DISP $5, $7, $5 ; CHAMPIONS_ROOM

HallofFameRoomBlocks: ; 20
    INCBIN "maps/halloffameroom.blk"

INCBIN "baserom.gbc",$5a59f,$1a61

SECTION "bank17",DATA,BANK[$17]

VermilionMartBlocks: ; 16
    INCBIN "maps/vermilionmart.blk"

RedsHouse2FBlocks:
	INCBIN "maps/redshouse2f.blk"

MuseumF1Blocks: ; 40
    INCBIN "maps/museumf1.blk"

MuseumF2Blocks: ; 28
    INCBIN "maps/museumf2.blk"

PewterPokecenterBlocks: ; 28
    INCBIN "maps/pewterpokecenter.blk"

UndergroundTunnelEntranceRoute5Blocks: ; 16
    INCBIN "maps/undergroundtunnelentranceroute5.blk"

ViridianForestexitBlocks: ; 20
    INCBIN "maps/viridianforestexit.blk"

RedsHouse2F_h:
	db $04 ; tileset
	db $04,$04 ; dimensions
	dw RedsHouse2FBlocks,RedsHouse2FTexts,RedsHouse2FScript
	db 0 ; no connections
	dw RedsHouse2FObject

RedsHouse2FScript:
	call $3C3C
	ld hl,RedsHouse2FScriptPointers
	ld a,[$D60C]
	jp $3D97

RedsHouse2FScriptPointers:
	dw RedsHouse2FScript1,RedsHouse2FScript2

RedsHouse2FScript1:
	xor a
	ld [$FFB4],a
	ld a,8
	ld [$D528],a
	ld a,1
	ld [$D60C],a
	ret

RedsHouse2FScript2:
	ret

RedsHouse2FTexts:
	db "@"

RedsHouse2FObject:
	db $0A ; border tile

	db 1 ; warps
	db 1,7,2,$25

	db 0 ; signs

	db 0 ; people

	dw $C6EF + 4 + (4 + 6) * 0 + 3
	db 1,7

INCBIN "baserom.gbc",$5c0dc,$5c0eb - $5c0dc

MuseumF1_h: ; 0x5c0eb to 0x5c0f7 (12 bytes) (id=52)
    db $0a ; tileset
    db $04, $0a ; dimensions (y, x)
    dw MuseumF1Blocks, $412b, $40f7 ; blocks, texts, scripts
    db $00 ; connections

    dw $42c1 ; objects

INCBIN "baserom.gbc",$5c0f7,$5c247 - $5c0f7
MuseumF1Text2: ; 0x5c247
    db $08 ; asm
    ld hl, $4251
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5c251,$5c256 - $5c251
MuseumF1Text3: ; 0x5c256
    db $08 ; asm
    ld a, [$d754]
    bit 1, a
    jr nz, .asm_16599 ; 0x5c25c
    ld hl, $428e
    call PrintText
    ld bc,(OLD_AMBER << 8) | 1
    call $3e2e
    jr nc, .asm_91ebf ; 0x5c26a
    ld hl, $d754
    set 1, [hl]
    ld a, $34
    ld [$cc4d], a
    ld a, $11
    call Predef
    ld hl, $4293
    jr .asm_52e0f ; 0x5c27e
.asm_91ebf ; 0x5c280
    ld hl, $429e
    jr .asm_52e0f ; 0x5c283
.asm_16599 ; 0x5c285
    ld hl, $4299
.asm_52e0f ; 0x5c288
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5c28e,$5c2a3 - $5c28e
MuseumF1Text4: ; 0x5c2a3
    db $08 ; asm
    ld hl, $42ad
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5c2ad,$5c2b2 - $5c2ad
MuseumF1Text5: ; 0x5c2b2
    db $08 ; asm
    ld hl, $42bc
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5c2bc,$5
MuseumF1Object: ; 0x5c2c1 (size=74)
    db $a ; border tile

    db $5 ; warps
    db $7, $a, $0, $ff
    db $7, $b, $0, $ff
    db $7, $10, $1, $ff
    db $7, $11, $1, $ff
    db $7, $7, $0, MUSEUM_2F

    db $0 ; signs

    db $5 ; people
    db SPRITE_OAK_AIDE, $4 + 4, $c + 4, $ff, $d2, $1 ; person
    db SPRITE_GAMBLER, $4 + 4, $1 + 4, $ff, $ff, $2 ; person
    db SPRITE_OAK_AIDE, $2 + 4, $f + 4, $ff, $d0, $3 ; person
    db SPRITE_OAK_AIDE, $4 + 4, $11 + 4, $ff, $ff, $4 ; person
    db SPRITE_OLD_AMBER, $2 + 4, $10 + 4, $ff, $ff, $5 ; person

    ; warp-to
    EVENT_DISP $a, $7, $a
    EVENT_DISP $a, $7, $b
    EVENT_DISP $a, $7, $10
    EVENT_DISP $a, $7, $11
    EVENT_DISP $a, $7, $7 ; MUSEUM_2F

MuseumF2_h: ; 0x5c30b to 0x5c317 (12 bytes) (id=53)
    db $0a ; tileset
    db $04, $07 ; dimensions (y, x)
    dw MuseumF2Blocks, $431a, $4317 ; blocks, texts, scripts
    db $00 ; connections

    dw $434b ; objects

INCBIN "baserom.gbc",$5c317,$5c31a - $5c317
MuseumF2Texts: ; 0x5c31a
    dw MuseumF2Text1, MuseumF2Text2, MuseumF2Text3, MuseumF2Text4, MuseumF2Text5, MuseumF2Text6, MuseumF2Text7

MuseumF2Text1: ; 0x5c328
    TX_FAR _MuseumF2Text1
    db $50

MuseumF2Text2: ; 0x5c32d
    TX_FAR _MuseumF2Text2
    db $50

MuseumF2Text3: ; 0x5c332
    TX_FAR _MuseumF2Text3
    db $50

MuseumF2Text4: ; 0x5c337
    TX_FAR _MuseumF2Text4
    db $50

MuseumF2Text5: ; 0x5c33c
    TX_FAR _MuseumF2Text5
    db $50

MuseumF2Text6: ; 0x5c341
    TX_FAR _MuseumF2Text6
    db $50

MuseumF2Text7: ; 0x5c346
    TX_FAR _MuseumF2Text7
    db $50

MuseumF2Object: ; 0x5c34b (size=48)
    db $a ; border tile

    db $1 ; warps
    db $7, $7, $4, MUSEUM_1F

    db $2 ; signs
    db $2, $b, $6 ; MuseumF2Text6
    db $5, $2, $7 ; MuseumF2Text7

    db $5 ; people
    db SPRITE_BUG_CATCHER, $7 + 4, $1 + 4, $fe, $2, $1 ; person
    db SPRITE_OLD_PERSON, $5 + 4, $0 + 4, $ff, $d0, $2 ; person
    db SPRITE_OAK_AIDE, $5 + 4, $7 + 4, $ff, $d0, $3 ; person
    db SPRITE_BRUNETTE_GIRL, $5 + 4, $b + 4, $ff, $ff, $4 ; person
    db SPRITE_HIKER, $5 + 4, $c + 4, $ff, $d0, $5 ; person

    ; warp-to
    EVENT_DISP $7, $7, $7 ; MUSEUM_1F

PewterGym_h: ; 0x5c37b to 0x5c387 (12 bytes) (id=54)
    db $07 ; tileset
    db $07, $05 ; dimensions (y, x)
    dw PewterGymBlocks, $4435, $4387 ; blocks, texts, scripts
    db $00 ; connections

    dw $452e ; objects

INCBIN "baserom.gbc",$5c387,$5c44e - $5c387
PewterGymText1: ; 0x5c44e
    db $08 ; asm
    ld a, [$d755]
    bit 7, a
    jr z, .asm_4a735 ; 0x5c454
    bit 6, a
    jr nz, .asm_ff7d0 ; 0x5c458
    call z, $43df
    call $30b6
    jr .asm_e0ffb ; 0x5c460
.asm_ff7d0 ; 0x5c462
    ld hl, $44a3
    call PrintText
    jr .asm_e0ffb ; 0x5c468
.asm_4a735 ; 0x5c46a
    ld hl, $449e
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $44bc
    ld de, $44bc
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $1
    ld [$d05c], a
    xor a
    ldh [$b4], a
    ld a, $3
    ld [$d5fc], a
    ld [$da39], a
.asm_e0ffb ; 0x5c49b
    jp $24d7

INCBIN "baserom.gbc",$5c49e,$5c4c6 - $5c49e
PewterGymText2: ; 0x5c4c6
    db $08 ; asm
    ld hl, $4441
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5c4d0,$5c4df - $5c4d0
PewterGymText3: ; 0x5c4df
    db $08 ; asm
    ld a, [$d72a]
    bit 0, a
    jr nz, .asm_71369 ; 0x5c4e5
    ld hl, $4515
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_6123a ; 0x5c4f4
    ld hl, $451a
    call PrintText
    jr .asm_d1578 ; 0x5c4fc
.asm_6123a ; 0x5c4fe
    ld hl, $4524
    call PrintText
.asm_d1578 ; 0x5c504
    ld hl, $451f
    call PrintText
    jr .asm_07013 ; 0x5c50a
.asm_71369 ; 0x5c50c
    ld hl, $4529
    call PrintText
.asm_07013 ; 0x5c512
    jp $24d7

INCBIN "baserom.gbc",$5c515,$19
PewterGymObject: ; 0x5c52e (size=42)
    db $3 ; border tile

    db $2 ; warps
    db $d, $4, $2, $ff
    db $d, $5, $2, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $1 + 4, $4 + 4, $ff, $d0, $41, BROCK + $C8, $1 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $6 + 4, $3 + 4, $ff, $d3, $42, JR__TRAINER_M + $C8, $1 ; trainer
    db SPRITE_GYM_HELPER, $a + 4, $7 + 4, $ff, $d0, $3 ; person

    ; warp-to
    EVENT_DISP $5, $d, $4
    EVENT_DISP $5, $d, $5

PewterGymBlocks: ; 35
    INCBIN "maps/pewtergym.blk"

PewterPokecenter_h: ; 0x5c57b to 0x5c587 (12 bytes) (id=58)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw PewterPokecenterBlocks, $458d, $4587 ; blocks, texts, scripts
    db $00 ; connections

    dw $460d ; objects

INCBIN "baserom.gbc",$5c587,$5c595 - $5c587

;XXX wtf? maybe a part of the text script?
db $ff
PewterPokecenterText1: ; 0x5c595
    TX_FAR _PewterPokecenterText1

INCBIN "baserom.gbc",$5c59a,$5c603 - $5c59a

PewterPokecenterText4: ; broken TX_FAR to _PewterPokecenterText4
    db $17, $44, $47, $26
    db $50

;XXX wtf?
db $30, $38, $34, $3c, $f6
PewterPokecenterObject: ; 0x5c60d (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $6, $ff
    db $7, $4, $6, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_GENTLEMAN, $7 + 4, $b + 4, $ff, $d2, $2 ; person
    db SPRITE_CLEFAIRY, $3 + 4, $1 + 4, $ff, $d0, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

CeruleanPokecenter_h: ; 0x5c639 to 0x5c645 (12 bytes) (id=64)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw CeruleanPokecenterBlocks, $464b, $4645 ; blocks, texts, scripts
    db $00 ; connections

    dw $465f ; objects

INCBIN "baserom.gbc",$5c645,$5c655 - $5c645

CeruleanPokecenterText1: ; 0x5c654
    TX_FAR _CeruleanPokecenterText1
    db $50

INCBIN "baserom.gbc",$5c65a,$5

CeruleanPokecenterObject: ; 0x5c65f (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $2, $ff
    db $7, $4, $2, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $a + 4, $fe, $0, $2 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $4 + 4, $ff, $d0, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

CeruleanPokecenterBlocks: ; 28
    INCBIN "maps/ceruleanpokecenter.blk"

CeruleanGym_h: ; 0x5c6a7 to 0x5c6b3 (12 bytes) (id=65)
    db $07 ; tileset
    db $07, $05 ; dimensions (y, x)
    dw CeruleanGymBlocks, $474a, $46b3 ; blocks, texts, scripts
    db $00 ; connections

    dw $4834 ; objects

INCBIN "baserom.gbc",$5c6b3,$5c771 - $5c6b3
CeruleanGymText1: ; 0x5c771
    db $08 ; asm
    ld a, [$d75e]
    bit 7, a
    jr z, .asm_10854 ; 0x5c777
    bit 6, a
    jr nz, .asm_37a1b ; 0x5c77b
    call z, $470d
    call $30b6
    jr .asm_95b04 ; 0x5c783
.asm_37a1b ; 0x5c785
    ld hl, $47c3
    call PrintText
    jr .asm_95b04 ; 0x5c78b
.asm_10854 ; 0x5c78d
    ld hl, $47be
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $47d8
    ld de, $47d8
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $2
    ld [$d05c], a
    xor a
    ldh [$b4], a
    ld a, $3
    ld [$d5fd], a
.asm_95b04 ; 0x5c7bb
    jp $24d7

INCBIN "baserom.gbc",$5c7be,$5c7df - $5c7be
CeruleanGymText2: ; 0x5c7df
    db $08 ; asm
    ld hl, $4758
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5c7e9,$5c7f8 - $5c7e9
CeruleanGymText3: ; 0x5c7f8
    db $08 ; asm
    ld hl, $4764
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5c802,$5c811 - $5c802
CeruleanGymText4: ; 0x5c811
    db $08 ; asm
    ld a, [$d75e]
    bit 7, a
    jr nz, .asm_f80ce ; 0x5c817
    ld hl, $482a
    call PrintText
    jr .asm_18a31 ; 0x5c81f
.asm_f80ce ; 0x5c821
    ld hl, $482f
    call PrintText
.asm_18a31 ; 0x5c827
    jp $24d7

INCBIN "baserom.gbc",$5c82a,$a
CeruleanGymObject: ; 0x5c834 (size=50)
    db $3 ; border tile

    db $2 ; warps
    db $d, $4, $3, $ff
    db $d, $5, $3, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_BRUNETTE_GIRL, $2 + 4, $4 + 4, $ff, $d0, $41, MISTY + $C8, $1 ; trainer
    db SPRITE_LASS, $3 + 4, $2 + 4, $ff, $d3, $42, JR__TRAINER_F + $C8, $1 ; trainer
    db SPRITE_SWIMMER, $7 + 4, $8 + 4, $ff, $d2, $43, SWIMMER + $C8, $1 ; trainer
    db SPRITE_GYM_HELPER, $a + 4, $7 + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $5, $d, $4
    EVENT_DISP $5, $d, $5

CeruleanGymBlocks: ; 35
    INCBIN "maps/ceruleangym.blk"

CeruleanMart_h: ; 0x5c889 to 0x5c895 (12 bytes) (id=67)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4000, $4898, $4895 ; blocks, texts, scripts
    db $00 ; connections

    dw $48a8 ; objects

INCBIN "baserom.gbc",$5c895,$5c89e - $5c895

CeruleanMartText2: ; 0x5c89e
    TX_FAR _CeruleanMartText2
    db $50

CeruleanMartText3: ; 0x5c8a3
    TX_FAR _CeruleanMartText3
    db $50

CeruleanMartObject: ; 0x5c8a8 (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $5, $ff
    db $7, $4, $5, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $4 + 4, $3 + 4, $fe, $1, $2 ; person
    db SPRITE_LASS, $2 + 4, $6 + 4, $fe, $2, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

LavenderPokecenter_h: ; 0x5c8ce to 0x5c8da (12 bytes) (id=141)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $4064, $48e0, $48da ; blocks, texts, scripts
    db $00 ; connections

    dw $48f4 ; objects

INCBIN "baserom.gbc",$5c8da,$5c8ea - $5c8da

LavenderPokecenterText1: ; 0x5c8e9
    TX_FAR _LavenderPokecenterText1

INCBIN "baserom.gbc",$5c8ea+4,$5c8f4 - ($5c8ea+4)

LavenderPokecenterObject: ; 0x5c8f4 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $5 + 4, $ff, $ff, $2 ; person
    db SPRITE_LITTLE_GIRL, $6 + 4, $2 + 4, $fe, $1, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

LavenderMart_h: ; 0x5c920 to 0x5c92c (12 bytes) (id=150)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4000, $492f, $492c ; blocks, texts, scripts
    db $00 ; connections

    dw $495d ; objects

INCBIN "baserom.gbc",$5c92c,$5c935 - $5c92c

LavenderMartText2: ; 0x5c935
    TX_FAR _LavenderMartText2
    db $50

LavenderMartText3: ; 0x5c93a
    db $08 ; asm
    ld a, [$d7e0]
    bit 7, a
    jr nz, .asm_c88d4 ; 0x5c940
    ld hl, $4953
    call PrintText
    jr .asm_6d225 ; 0x5c948
.asm_c88d4 ; 0x5c94a
    ld hl, $4958
    call PrintText
.asm_6d225 ; 0x5c950
    jp $24d7

INCBIN "baserom.gbc",$5c953,$a
LavenderMartObject: ; 0x5c95d (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $3, $ff
    db $7, $4, $3, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BALDING_GUY, $4 + 4, $3 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $2 + 4, $7 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

VermilionPokecenter_h: ; 0x5c983 to 0x5c98f (12 bytes) (id=89)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $4064, $4995, $498f ; blocks, texts, scripts
    db $00 ; connections

    dw $49a9 ; objects

INCBIN "baserom.gbc",$5c98f,$5c99e - $5c98f

VermilionPokecenterText1: ; 0x5c99d
    TX_FAR _VermilionPokecenterText1

INCBIN "baserom.gbc",$5c9a2,$7
VermilionPokecenterObject: ; 0x5c9a9 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $0, $ff
    db $7, $4, $0, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_FISHER, $5 + 4, $a + 4, $ff, $ff, $2 ; person
    db SPRITE_SAILOR, $4 + 4, $5 + 4, $ff, $ff, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

VermilionMart_h: ; 0x5c9d5 to 0x5c9e1 (12 bytes) (id=91)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw VermilionMartBlocks, $49e4, $49e1 ; blocks, texts, scripts
    db $00 ; connections

    dw $49f4 ; objects

INCBIN "baserom.gbc",$5c9e1,$5c9f4 - $5c9e1
VermilionMartObject: ; 0x5c9f4 (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $2, $ff
    db $7, $4, $2, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $6 + 4, $5 + 4, $ff, $ff, $2 ; person
    db SPRITE_LASS, $3 + 4, $3 + 4, $fe, $2, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

VermilionGym_h: ; 0x5ca1a to 0x5ca26 (12 bytes) (id=92)
    db $07 ; tileset
    db $09, $05 ; dimensions (y, x)
    dw VermilionGymBlocks, $4ae8, $4a26 ; blocks, texts, scripts
    db $00 ; connections

    dw $4bfe ; objects

INCBIN "baserom.gbc",$5ca26,$5cb1d - $5ca26
VermilionGymText1: ; 0x5cb1d
    db $08 ; asm
    ld a, [$d773]
    bit 7, a
    jr z, .asm_7cc29 ; 0x5cb23
    bit 6, a
    jr nz, .asm_41203 ; 0x5cb27
    call z, $4aaa
    call $30b6
    jr .asm_23621 ; 0x5cb2f
.asm_41203 ; 0x5cb31
    ld hl, $4b72
    call PrintText
    jr .asm_23621 ; 0x5cb37
.asm_7cc29 ; 0x5cb39
    ld hl, $4b6d
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4b8b
    ld de, $4b8b
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $3
    ld [$d05c], a
    xor a
    ldh [$b4], a
    ld a, $3
    ld [$d5fe], a
    ld [$da39], a
.asm_23621 ; 0x5cb6a
    jp $24d7

INCBIN "baserom.gbc",$5cb6d,$5cb90 - $5cb6d
VermilionGymText2: ; 0x5cb90
    db $08 ; asm
    ld hl, $4af8
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cb9a,$5cba9 - $5cb9a
VermilionGymText3: ; 0x5cba9
    db $08 ; asm
    ld hl, $4b04
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cbb3,$5cbc2 - $5cbb3
VermilionGymText4: ; 0x5cbc2
    db $08 ; asm
    ld hl, $4b10
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cbcc,$5cbdb - $5cbcc
VermilionGymText5: ; 0x5cbdb
    db $08 ; asm
    ld a, [$d72a]
    bit 2, a
    jr nz, .asm_13b67 ; 0x5cbe1
    ld hl, $4bf4
    call PrintText
    jr .asm_c2b38 ; 0x5cbe9
.asm_13b67 ; 0x5cbeb
    ld hl, $4bf9
    call PrintText
.asm_c2b38 ; 0x5cbf1
    jp $24d7

INCBIN "baserom.gbc",$5cbf4,$a
VermilionGymObject: ; 0x5cbfe (size=58)
    db $3 ; border tile

    db $2 ; warps
    db $11, $4, $3, $ff
    db $11, $5, $3, $ff

    db $0 ; signs

    db $5 ; people
    db SPRITE_ROCKER, $1 + 4, $5 + 4, $ff, $d0, $41, LT__SURGE + $C8, $1 ; trainer
    db SPRITE_GENTLEMAN, $6 + 4, $9 + 4, $ff, $d2, $42, GENTLEMAN + $C8, $3 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $3 + 4, $ff, $d2, $43, ROCKER + $C8, $1 ; trainer
    db SPRITE_SAILOR, $a + 4, $0 + 4, $ff, $d3, $44, SAILOR + $C8, $8 ; trainer
    db SPRITE_GYM_HELPER, $e + 4, $4 + 4, $ff, $d0, $5 ; person

    ; warp-to
    EVENT_DISP $5, $11, $4
    EVENT_DISP $5, $11, $5

VermilionGymBlocks: ; 45
    INCBIN "maps/vermiliongym.blk"

CopycatsHouseF2_h: ; 0x5cc65 to 0x5cc71 (12 bytes) (id=176)
    db $04 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4010, $4c74, $4c71 ; blocks, texts, scripts
    db $00 ; connections

    dw $4d21 ; objects

INCBIN "baserom.gbc",$5cc71,$5cc82 - $5cc71
CopycatsHouseF2Text1: ; 0x5cc82
    db $08 ; asm
    ld a, [$d7af]
    bit 0, a
    jr nz, .asm_7ccf3 ; 0x5cc88
    ld a, $1
    ld [$cc3c], a
    ld hl, $4cd4
    call PrintText
	ld b,POKE_DOLL
    call $3493
    jr z, .asm_62ecd ; 0x5cc9a
    ld hl, $4cd9
    call PrintText
    ld bc,(TM_31 << 8) | 1
    call $3e2e
    jr nc, .asm_16690 ; 0x5cca8
    ld hl, $4cde
    call PrintText
    ld a, $33
    ldh [$db], a
    ld b, $5 ; BANK(MyFunction)
    ld hl, $7f37 ; MyFunction
    call Bankswitch
    ld hl, $d7af
    set 0, [hl]
    jr .asm_62ecd ; 0x5ccc1
.asm_16690 ; 0x5ccc3
    ld hl, $4cee
    call PrintText
    jr .asm_62ecd ; 0x5ccc9
.asm_7ccf3 ; 0x5cccb
    ld hl, $4ce9
    call PrintText
.asm_62ecd ; 0x5ccd1
    jp $24d7

INCBIN "baserom.gbc",$5ccd4,$20

CopycatsHouseF2Text2: ; 0x5ccf4
    TX_FAR _CopycatsHouseF2Text2
    db $50

CopycatsHouseF2Text3: ; 0x5ccf9
    TX_FAR _CopycatsHouseF2Text3
    db $50

CopycatsHouseF2Text6: ; 0x5ccfe
    TX_FAR _CopycatsHouseF2Text6
    db $50

CopycatsHouseF2Text7: ; 0x5cd03
    db $08 ; asm
    ld a, [$c109]
    cp $4
    ld hl, $4d1c
    jr nz, .asm_399a4 ; 0x5cd0c
    ld hl, $4d17
.asm_399a4 ; 0x5cd11
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$5cd17,$a
CopycatsHouseF2Object: ; 0x5cd21 (size=48)
    db $a ; border tile

    db $1 ; warps
    db $1, $7, $2, COPYCATS_HOUSE_1F

    db $2 ; signs
    db $5, $3, $6 ; CopycatsHouseF2Text6
    db $1, $0, $7 ; CopycatsHouseF2Text7

    db $5 ; people
    db SPRITE_BRUNETTE_GIRL, $3 + 4, $4 + 4, $fe, $0, $1 ; person
    db SPRITE_BIRD, $6 + 4, $4 + 4, $fe, $2, $2 ; person
    db SPRITE_SLOWBRO, $1 + 4, $5 + 4, $ff, $d0, $3 ; person
    db SPRITE_BIRD, $0 + 4, $2 + 4, $ff, $d0, $4 ; person
    db SPRITE_CLEFAIRY, $6 + 4, $1 + 4, $ff, $d3, $5 ; person

    ; warp-to
    EVENT_DISP $4, $1, $7 ; COPYCATS_HOUSE_1F

FightingDojo_h: ; 0x5cd51 to 0x5cd5d (12 bytes) (id=177)
    db $05 ; tileset
    db $06, $05 ; dimensions (y, x)
    dw FightingDojoBlocks, $4e03, $4d5d ; blocks, texts, scripts
    db $00 ; connections

    dw $4f9b ; objects

INCBIN "baserom.gbc",$5cd5d,$5ce44 - $5cd5d
FightingDojoText1: ; 0x5ce44
    db $08 ; asm
    ld a, [$d7b1]
    bit 0, a
    jp nz, $4e7d
    bit 1, a
    jp nz, $4e85
    ld hl, $4e8e
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4e93
    ld de, $4e93
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $3
    ld [$d642], a
    ld [$da39], a
    jr .asm_9dba4 ; 0x5ce7b
    ld hl, $4e9d
    call PrintText
    jr .asm_9dba4 ; 0x5ce83
    ld hl, $4e98
    call PrintText
.asm_9dba4 ; 0x5ce8b
    jp $24d7

INCBIN "baserom.gbc",$5ce8e,$5cea2 - $5ce8e
FightingDojoText2: ; 0x5cea2
    db $08 ; asm
    ld hl, $4e13
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5ceac,$5cebb - $5ceac
FightingDojoText3: ; 0x5cebb
    db $08 ; asm
    ld hl, $4e1f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cec5,$5ced4 - $5cec5
FightingDojoText4: ; 0x5ced4
    db $08 ; asm
    ld hl, $4e2b
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cede,$5ceed - $5cede
FightingDojoText5: ; 0x5ceed
    db $08 ; asm
    ld hl, $4e37
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5cef7,$5cf06 - $5cef7
FightingDojoText6: ; 0x5cf06
    db $08 ; asm
    ld a, [$d7b1]
    and $c0
    jr z, .asm_f8e28 ; 0x5cf0c
    ld hl, $4f96
    call PrintText
    jr .asm_3a2c8 ; 0x5cf14
.asm_f8e28 ; 0x5cf16
    ld a, $2b
    call $349b
    ld hl, $4f49
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_3a2c8 ; 0x5cf28
    ld a, [$cf91]
    ld b, a
	ld c,30
    call GivePokemon
    jr nc, .asm_3a2c8 ; 0x5cf33
    ld a, $4a
    ld [$cc4d], a
    ld a, $11
    call Predef
    ld hl, $d7b1
    set 6, [hl]
    set 0, [hl]
.asm_3a2c8 ; 0x5cf46
    jp $24d7

INCBIN "baserom.gbc",$5cf49,$5cf4e - $5cf49
FightingDojoText7: ; 0x5cf4e
    db $08 ; asm
    ld a, [$d7b1]
    and $c0
    jr z, .asm_170a9 ; 0x5cf54
    ld hl, $4f96
    call PrintText
    jr .asm_f1f47 ; 0x5cf5c
.asm_170a9 ; 0x5cf5e
    ld a, $2c
    call $349b
    ld hl, $4f91
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    jr nz, .asm_f1f47 ; 0x5cf70
    ld a, [$cf91]
    ld b, a
	ld c,30
    call GivePokemon
    jr nc, .asm_f1f47 ; 0x5cf7b
    ld hl, $d7b1
    set 7, [hl]
    set 0, [hl]
    ld a, $4b
    ld [$cc4d], a
    ld a, $11
    call Predef
.asm_f1f47 ; 0x5cf8e
    jp $24d7

INCBIN "baserom.gbc",$5cf91,$a
FightingDojoObject: ; 0x5cf9b (size=72)
    db $3 ; border tile

    db $2 ; warps
    db $b, $4, $1, $ff
    db $b, $5, $1, $ff

    db $0 ; signs

    db $7 ; people
    db SPRITE_HIKER, $3 + 4, $5 + 4, $ff, $d0, $41, BLACKBELT + $C8, $1 ; trainer
    db SPRITE_HIKER, $4 + 4, $3 + 4, $ff, $d3, $42, BLACKBELT + $C8, $2 ; trainer
    db SPRITE_HIKER, $6 + 4, $3 + 4, $ff, $d3, $43, BLACKBELT + $C8, $3 ; trainer
    db SPRITE_HIKER, $5 + 4, $5 + 4, $ff, $d2, $44, BLACKBELT + $C8, $4 ; trainer
    db SPRITE_HIKER, $7 + 4, $5 + 4, $ff, $d2, $45, BLACKBELT + $C8, $5 ; trainer
    db SPRITE_BALL, $1 + 4, $4 + 4, $ff, $ff, $6 ; person
    db SPRITE_BALL, $1 + 4, $5 + 4, $ff, $ff, $7 ; person

    ; warp-to
    EVENT_DISP $5, $b, $4
    EVENT_DISP $5, $b, $5

FightingDojoBlocks: ; 30
    INCBIN "maps/fightingdojo.blk"

SaffronGym_h: ; 0x5d001 to 0x5d00d (12 bytes) (id=178)
    db $16 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw SaffronGymBlocks, $50ab, $500d ; blocks, texts, scripts
    db $00 ; connections

    dw $5259 ; objects

INCBIN "baserom.gbc",$5d00d,$5d118 - $5d00d
SaffronGymText1: ; 0x5d118
    db $08 ; asm
    ld a, [$d7b3]
    bit 1, a
    jr z, .asm_e3544 ; 0x5d11e
    bit 0, a
    jr nz, .asm_8d2f6 ; 0x5d122
    call z, $5068
    call $30b6
    jr .asm_34c2c ; 0x5d12a
.asm_8d2f6 ; 0x5d12c
    ld hl, $516e
    call PrintText
    jr .asm_34c2c ; 0x5d132
.asm_e3544 ; 0x5d134
    ld hl, $5162
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $5167
    ld de, $5167
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $6
    ld [$d05c], a
    ld a, $3
    ld [$d65c], a
.asm_34c2c ; 0x5d15f
    jp $24d7

INCBIN "baserom.gbc",$5d162,$5d187 - $5d162
SaffronGymText2: ; 0x5d187
    db $08 ; asm
    ld hl, $50c3
    call LoadTrainerHeader
    jp $24d7

SaffronGymText3: ; 0x5d191
    db $08 ; asm
    ld hl, $50cf
    call LoadTrainerHeader
    jp $24d7

SaffronGymText4: ; 0x5d19b
    db $08 ; asm
    ld hl, $50db
    call LoadTrainerHeader
    jp $24d7

SaffronGymText5: ; 0x5d1a5
    db $08 ; asm
    ld hl, $50e7
    call LoadTrainerHeader
    jp $24d7

SaffronGymText6: ; 0x5d1af
    db $08 ; asm
    ld hl, $50f3
    call LoadTrainerHeader
    jp $24d7

SaffronGymText7: ; 0x5d1b9
    db $08 ; asm
    ld hl, $50ff
    call LoadTrainerHeader
    jp $24d7

SaffronGymText8: ; 0x5d1c3
    db $08 ; asm
    ld hl, $510b
    call LoadTrainerHeader
    jp $24d7

SaffronGymText9: ; 0x5d1cd
    db $08 ; asm
    ld a, [$d7b3]
    bit 1, a
    jr nz, .asm_13f3c ; 0x5d1d3
    ld hl, $51e6
    call PrintText
    jr .asm_e9907 ; 0x5d1db
.asm_13f3c ; 0x5d1dd
    ld hl, $51eb
    call PrintText
.asm_e9907 ; 0x5d1e3
    jp $24d7

INCBIN "baserom.gbc",$5d1e6,$73
SaffronGymObject: ; 0x5d259 (size=330)
    db $2e ; border tile

    db $20 ; warps
    db $11, $8, $2, $ff
    db $11, $9, $2, $ff
    db $3, $1, $16, SAFFRON_GYM
    db $3, $5, $f, SAFFRON_GYM
    db $5, $1, $12, SAFFRON_GYM
    db $5, $5, $8, SAFFRON_GYM
    db $9, $1, $1b, SAFFRON_GYM
    db $9, $5, $10, SAFFRON_GYM
    db $b, $1, $5, SAFFRON_GYM
    db $b, $5, $d, SAFFRON_GYM
    db $f, $1, $17, SAFFRON_GYM
    db $f, $5, $1e, SAFFRON_GYM
    db $11, $1, $11, SAFFRON_GYM
    db $11, $5, $9, SAFFRON_GYM
    db $3, $9, $1a, SAFFRON_GYM
    db $3, $b, $3, SAFFRON_GYM
    db $5, $9, $7, SAFFRON_GYM
    db $5, $b, $c, SAFFRON_GYM
    db $b, $b, $4, SAFFRON_GYM
    db $f, $b, $1f, SAFFRON_GYM
    db $3, $f, $18, SAFFRON_GYM
    db $3, $13, $1c, SAFFRON_GYM
    db $5, $f, $2, SAFFRON_GYM
    db $5, $13, $a, SAFFRON_GYM
    db $9, $f, $14, SAFFRON_GYM
    db $9, $13, $1d, SAFFRON_GYM
    db $b, $f, $e, SAFFRON_GYM
    db $b, $13, $6, SAFFRON_GYM
    db $f, $f, $15, SAFFRON_GYM
    db $f, $13, $19, SAFFRON_GYM
    db $11, $f, $b, SAFFRON_GYM
    db $11, $13, $13, SAFFRON_GYM

    db $0 ; signs

    db $9 ; people
    db SPRITE_GIRL, $8 + 4, $9 + 4, $ff, $d0, $41, SABRINA + $C8, $1 ; trainer
    db SPRITE_MEDIUM, $1 + 4, $a + 4, $ff, $d0, $42, CHANNELER + $C8, $16 ; trainer
    db SPRITE_BUG_CATCHER, $1 + 4, $11 + 4, $ff, $d0, $43, PSYCHIC_TR + $C8, $1 ; trainer
    db SPRITE_MEDIUM, $7 + 4, $3 + 4, $ff, $d0, $44, CHANNELER + $C8, $17 ; trainer
    db SPRITE_BUG_CATCHER, $7 + 4, $11 + 4, $ff, $d0, $45, PSYCHIC_TR + $C8, $2 ; trainer
    db SPRITE_MEDIUM, $d + 4, $3 + 4, $ff, $d0, $46, CHANNELER + $C8, $18 ; trainer
    db SPRITE_BUG_CATCHER, $d + 4, $11 + 4, $ff, $d0, $47, PSYCHIC_TR + $C8, $3 ; trainer
    db SPRITE_BUG_CATCHER, $1 + 4, $3 + 4, $ff, $d0, $48, PSYCHIC_TR + $C8, $4 ; trainer
    db SPRITE_GYM_HELPER, $f + 4, $a + 4, $ff, $d0, $9 ; person

    ; warp-to
    EVENT_DISP $a, $11, $8
    EVENT_DISP $a, $11, $9
    EVENT_DISP $a, $3, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $3, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $5, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $5, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $9, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $9, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $b, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $b, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $f, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $f, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $11, $1 ; SAFFRON_GYM
    EVENT_DISP $a, $11, $5 ; SAFFRON_GYM
    EVENT_DISP $a, $3, $9 ; SAFFRON_GYM
    EVENT_DISP $a, $3, $b ; SAFFRON_GYM
    EVENT_DISP $a, $5, $9 ; SAFFRON_GYM
    EVENT_DISP $a, $5, $b ; SAFFRON_GYM
    EVENT_DISP $a, $b, $b ; SAFFRON_GYM
    EVENT_DISP $a, $f, $b ; SAFFRON_GYM
    EVENT_DISP $a, $3, $f ; SAFFRON_GYM
    EVENT_DISP $a, $3, $13 ; SAFFRON_GYM
    EVENT_DISP $a, $5, $f ; SAFFRON_GYM
    EVENT_DISP $a, $5, $13 ; SAFFRON_GYM
    EVENT_DISP $a, $9, $f ; SAFFRON_GYM
    EVENT_DISP $a, $9, $13 ; SAFFRON_GYM
    EVENT_DISP $a, $b, $f ; SAFFRON_GYM
    EVENT_DISP $a, $b, $13 ; SAFFRON_GYM
    EVENT_DISP $a, $f, $f ; SAFFRON_GYM
    EVENT_DISP $a, $f, $13 ; SAFFRON_GYM
    EVENT_DISP $a, $11, $f ; SAFFRON_GYM
    EVENT_DISP $a, $11, $13 ; SAFFRON_GYM

SaffronGymBlocks: ; 90
    INCBIN "maps/saffrongym.blk"

SaffronMart_h: ; 0x5d3fd to 0x5d409 (12 bytes) (id=180)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4000, $540c, $5409 ; blocks, texts, scripts
    db $00 ; connections

    dw $541c ; objects

INCBIN "baserom.gbc",$5d409,$5d412 - $5d409

SaffronMartText2: ; 0x5d412
    TX_FAR _SaffronMartText2
    db $50

SaffronMartText3: ; 0x5d417
    TX_FAR _SaffronMartText3
    db $50

SaffronMartObject: ; 0x5d41c (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $4, $ff
    db $7, $4, $4, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $4 + 4, $ff, $ff, $2 ; person
    db SPRITE_LASS, $5 + 4, $6 + 4, $fe, $0, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

SilphCo1_h: ; 0x5d442 to 0x5d44e (12 bytes) (id=181)
    db $16 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw SilphCo1Blocks, $5469, $544e ; blocks, texts, scripts
    db $00 ; connections

    dw $5470 ; objects

INCBIN "baserom.gbc",$5d44e,$5d469 - $5d44e
SilphCo1Texts: ; 0x5d469
    dw SilphCo1Text1

SilphCo1Text1: ; 0x5d46b
    TX_FAR _SilphCo1Text1
    db $50

SilphCo1Object: ; 0x5d470 (size=50)
    db $2e ; border tile

    db $5 ; warps
    db $11, $a, $5, $ff
    db $11, $b, $5, $ff
    db $0, $1a, $0, SILPH_CO_2F
    db $0, $14, $0, SILPH_CO_ELEVATOR
    db $a, $10, $6, SILPH_CO_3F

    db $0 ; signs

    db $1 ; people
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $4 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $f, $11, $a
    EVENT_DISP $f, $11, $b
    EVENT_DISP $f, $0, $1a ; SILPH_CO_2F
    EVENT_DISP $f, $0, $14 ; SILPH_CO_ELEVATOR
    EVENT_DISP $f, $a, $10 ; SILPH_CO_3F

SilphCo1Blocks: ; 135
    INCBIN "maps/silphco1.blk"

SaffronPokecenter_h: ; 0x5d529 to 0x5d535 (12 bytes) (id=182)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $4064, $553b, $5535 ; blocks, texts, scripts
    db $00 ; connections

    dw $554f ; objects

INCBIN "baserom.gbc",$5d535,$5d544 - $5d535

SaffronPokecenterText2: ; maybe
SaffronPokecenterText1: ; 0x5d543
    TX_FAR _SaffronPokecenterText1

INCBIN "baserom.gbc",$5d544+4,$5d54f - ($5d544+4)

SaffronPokecenterObject: ; 0x5d54f (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $6, $ff
    db $7, $4, $6, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_FOULARD_WOMAN, $5 + 4, $5 + 4, $ff, $ff, $2 ; person
    db SPRITE_GENTLEMAN, $3 + 4, $8 + 4, $ff, $d0, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

ViridianForestexit_h: ; 0x5d57b to 0x5d587 (12 bytes) (id=47)
    db $09 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw ViridianForestexitBlocks, $558a, $5587 ; blocks, texts, scripts
    db $00 ; connections

    dw $5598 ; objects

INCBIN "baserom.gbc",$5d587,$5d58a - $5d587
ViridianForestexitTexts: ; 0x5d58a
    dw ViridianForestexitText1, ViridianForestexitText2

ViridianForestexitText1: ; 0x5d58e
    TX_FAR _ViridianForestexitText1
    db $50

ViridianForestexitText2: ; 0x5d593
    TX_FAR _ViridianForestexitText2
    db $50

ViridianForestexitObject: ; 0x5d598 (size=48)
    db $a ; border tile

    db $4 ; warps
    db $0, $4, $1, $ff
    db $0, $5, $1, $ff
    db $7, $4, $0, VIRIDIAN_FOREST
    db $7, $5, $0, VIRIDIAN_FOREST

    db $0 ; signs

    db $2 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $3 + 4, $ff, $ff, $1 ; person
    db SPRITE_OLD_PERSON, $5 + 4, $2 + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $5, $0, $4
    EVENT_DISP $5, $0, $5
    EVENT_DISP $5, $7, $4 ; VIRIDIAN_FOREST
    EVENT_DISP $5, $7, $5 ; VIRIDIAN_FOREST

Route2Gate_h: ; 0x5d5c8 to 0x5d5d4 (12 bytes) (id=49)
    db $0c ; tileset
    db $04, $05 ; dimensions (y, x)
    dw $4090, $55d7, $55d4 ; blocks, texts, scripts
    db $00 ; connections

    dw $5620 ; objects

INCBIN "baserom.gbc",$5d5d4,$5d5db - $5d5d4
Route2GateText1: ; 0x5d5db
    db $08 ; asm
    ld a, [$d7c2]
    bit 0, a
    jr nz, .asm_6592c ; 0x5d5e1
    ld a, $a
    ldh [$db], a
    ld a, $c8
    ldh [$dc], a
    ld [$d11e], a
    call $2fcf
    ld hl, $cd6d
    ld de, $cc5b
    ld bc, $000d
    call CopyData
    ld a, $62
    call Predef
    ldh a, [$db]
    cp $1
    jr nz, .asm_ad646 ; 0x5d606
    ld hl, $d7c2
    set 0, [hl]
.asm_6592c ; 0x5d60d
    ld hl, $5616
    call PrintText
.asm_ad646 ; 0x5d613
    jp $24d7

INCBIN "baserom.gbc",$5d616,$5

Route2GateText2: ; 0x5d61b
    TX_FAR _Route2GateText2
    db $50

Route2GateObject: ; 0x5d620 (size=48)
    db $a ; border tile

    db $4 ; warps
    db $0, $4, $3, $ff
    db $0, $5, $3, $ff
    db $7, $4, $4, $ff
    db $7, $5, $4, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_OAK_AIDE, $4 + 4, $1 + 4, $ff, $d2, $1 ; person
    db SPRITE_BUG_CATCHER, $4 + 4, $5 + 4, $fe, $2, $2 ; person

    ; warp-to
    EVENT_DISP $5, $0, $4
    EVENT_DISP $5, $0, $5
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5

ViridianForestEntrance_h: ; 0x5d650 to 0x5d65c (12 bytes) (id=50)
    db $09 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw $4090, $565f, $565c ; blocks, texts, scripts
    db $00 ; connections

    dw $566d ; objects

INCBIN "baserom.gbc",$5d65c,$5d65f - $5d65c
ViridianForestEntranceTexts: ; 0x5d65f
    dw ViridianForestEntranceText1, ViridianForestEntranceText2

ViridianForestEntranceText1: ; 0x5d663
    TX_FAR _ViridianForestEntranceText1
    db $50

ViridianForestEntranceText2: ; 0x5d668
    TX_FAR _ViridianForestEntranceText2
    db $50

ViridianForestEntranceObject: ; 0x5d66d (size=48)
    db $a ; border tile

    db $4 ; warps
    db $0, $4, $3, VIRIDIAN_FOREST
    db $0, $5, $4, VIRIDIAN_FOREST
    db $7, $4, $5, $ff
    db $7, $5, $5, $ff

    db $0 ; signs

    db $2 ; people
    db SPRITE_GIRL, $4 + 4, $8 + 4, $ff, $d2, $1 ; person
    db SPRITE_LITTLE_GIRL, $4 + 4, $2 + 4, $fe, $1, $2 ; person

    ; warp-to
    EVENT_DISP $5, $0, $4 ; VIRIDIAN_FOREST
    EVENT_DISP $5, $0, $5 ; VIRIDIAN_FOREST
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5

UndergroundTunnelEntranceRoute5_h: ; 0x5d69d to 0x5d6a9 (12 bytes) (id=71)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw UndergroundTunnelEntranceRoute5Blocks, $56b0, $56a9 ; blocks, texts, scripts
    db $00 ; connections

    dw $56c1 ; objects

INCBIN "baserom.gbc",$5d6a9,$5d6b2 - $5d6a9
UndergroundTunnelEntranceRoute5Text1: ; 0x5d6b2
    db $08 ; asm
    ld a, $9
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    ld hl, $56af
    ret

UndergroundTunnelEntranceRoute5Object: ; 0x5d6c1 (size=34)
    db $a ; border tile

    db $3 ; warps
    db $7, $3, $3, $ff
    db $7, $4, $3, $ff
    db $4, $4, $0, UNDERGROUND_PATH_NS

    db $0 ; signs

    db $1 ; people
    db SPRITE_LITTLE_GIRL, $3 + 4, $2 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4
    EVENT_DISP $4, $4, $4 ; UNDERGROUND_PATH_NS

UndergroundTunnelEntranceRoute6_h: ; 0x5d6e3 to 0x5d6ef (12 bytes) (id=74)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4080, $56f7, $56ef ; blocks, texts, scripts
    db $00 ; connections

    dw $56fe ; objects

INCBIN "baserom.gbc",$5d6ef,$5d6f7 - $5d6ef
UndergroundTunnelEntranceRoute6Texts: ; 0x5d6f7
    dw UndergroundTunnelEntranceRoute6Text1

;XXX wtf? syntax error on TX_FAR?
UndergroundTunnelEntranceRoute6Text1: ; 0x5d6f9
    db $17, $cb, $40, $23
    ;TX_FAR _UndergroundTunnelEntranceRoute6Text1 ; $cb, $40, $23
    db $50

UndergroundTunnelEntranceRoute6Object: ; 0x5d6fe (size=34)
    db $a ; border tile

    db $3 ; warps
    db $7, $3, $3, $ff
    db $7, $4, $3, $ff
    db $4, $4, $1, UNDERGROUND_PATH_NS

    db $0 ; signs

    db $1 ; people
    db SPRITE_GIRL, $3 + 4, $2 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4
    EVENT_DISP $4, $4, $4 ; UNDERGROUND_PATH_NS

UndergroundPathEntranceRoute7_h: ; 0x5d720 to 0x5d72c (12 bytes) (id=77)
    db $0c ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4080, $5734, $572c ; blocks, texts, scripts
    db $00 ; connections

    dw $573b ; objects

INCBIN "baserom.gbc",$5d72c,$5d734 - $5d72c
UndergroundPathEntranceRoute7Texts: ; 0x5d734
    dw UndergroundPathEntranceRoute7Text1

UndergroundPathEntranceRoute7Text1: ; 0x5d736
    db $17, $ff, $40, $23
    ;TX_FAR _UndergroundPathEntranceRoute7Text1
    db $50

UndergroundPathEntranceRoute7Object: ; 0x5d73b (size=34)
    db $a ; border tile

    db $3 ; warps
    db $7, $3, $4, $ff
    db $7, $4, $4, $ff
    db $4, $4, $0, UNDERGROUND_PATH_WE

    db $0 ; signs

    db $1 ; people
    db SPRITE_FAT_BALD_GUY, $4 + 4, $2 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4
    EVENT_DISP $4, $4, $4 ; UNDERGROUND_PATH_WE

INCBIN "baserom.gbc",$5d75d,$52

SilphCo9_h: ; 0x5d7af to 0x5d7bb (12 bytes) (id=233)
    db $16 ; tileset
    db $09, $0d ; dimensions (y, x)
    dw SilphCo9Blocks, $588b, $57bb ; blocks, texts, scripts
    db $00 ; connections

    dw $593f ; objects

INCBIN "baserom.gbc",$5d7bb,$5d8b8 - $5d7bb
SilphCo9Text1: ; 0x5d8b8
    db $08 ; asm
    ld a, [$d838]
    bit 7, a
    jr nz, .asm_a14c3 ; 0x5d8be
    ld hl, $58e5
    call PrintText
    ld a, $7
    call Predef
    call $20d8
    call Delay3
    call $20f6
    ld hl, $58ea
    call PrintText
    jr .asm_b6e28 ; 0x5d8da
.asm_a14c3 ; 0x5d8dc
    ld hl, $58ef
    call PrintText
.asm_b6e28 ; 0x5d8e2
    jp $24d7

INCBIN "baserom.gbc",$5d8e5,$5d8f4 - $5d8e5
SilphCo9Text2: ; 0x5d8f4
    db $08 ; asm
    ld hl, $5893
    call LoadTrainerHeader
    jp $24d7

SilphCo9Text3: ; 0x5d8fe
    db $08 ; asm
    ld hl, $589f
    call LoadTrainerHeader
    jp $24d7

SilphCo9Text4: ; 0x5d908
    db $08 ; asm
    ld hl, $58ab
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5d912,$2d
SilphCo9Object: ; 0x5d93f (size=74)
    db $2e ; border tile

    db $5 ; warps
    db $0, $e, $0, SILPH_CO_10F
    db $0, $10, $0, SILPH_CO_8F
    db $0, $12, $0, SILPH_CO_ELEVATOR
    db $3, $9, $7, SILPH_CO_3F
    db $f, $11, $4, SILPH_CO_5F

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $e + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_ROCKET, $4 + 4, $2 + 4, $ff, $d1, $42, ROCKET + $C8, $25 ; trainer
    db SPRITE_OAK_AIDE, $d + 4, $15 + 4, $ff, $d0, $43, SCIENTIST + $C8, $a ; trainer
    db SPRITE_ROCKET, $10 + 4, $d + 4, $ff, $d1, $44, ROCKET + $C8, $26 ; trainer

    ; warp-to
    EVENT_DISP $d, $0, $e ; SILPH_CO_10F
    EVENT_DISP $d, $0, $10 ; SILPH_CO_8F
    EVENT_DISP $d, $0, $12 ; SILPH_CO_ELEVATOR
    EVENT_DISP $d, $3, $9 ; SILPH_CO_3F
    EVENT_DISP $d, $f, $11 ; SILPH_CO_5F

SilphCo9Blocks: ; 117
    INCBIN "maps/silphco9.blk"

VictoryRoad1_h: ; 0x5d9fe to 0x5da0a (12 bytes) (id=108)
    db $11 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw VictoryRoad1Blocks, $5a5f, $5a0a ; blocks, texts, scripts
    db $00 ; connections

    dw $5ab8 ; objects

INCBIN "baserom.gbc",$5da0a,$5da86 - $5da0a
VictoryRoad1Text1: ; 0x5da86
    db $08 ; asm
    ld hl, $5a6d
    call LoadTrainerHeader
    jp $24d7

VictoryRoad1Text2: ; 0x5da90
    db $08 ; asm
    ld hl, $5a79
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$5da9a,$1e
VictoryRoad1Object: ; 0x5dab8 (size=76)
    db $7d ; border tile

    db $3 ; warps
    db $11, $8, $2, $ff
    db $11, $9, $2, $ff
    db $1, $1, $0, VICTORY_ROAD_2

    db $0 ; signs

    db $7 ; people
    db SPRITE_LASS, $5 + 4, $7 + 4, $ff, $d3, $41, COOLTRAINER_F + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $2 + 4, $3 + 4, $ff, $d0, $42, COOLTRAINER_M + $C8, $5 ; trainer
	db SPRITE_BALL, $0 + 4, $b + 4, $ff, $ff, $83, TM_43 ; item
	db SPRITE_BALL, $2 + 4, $9 + 4, $ff, $ff, $84, RARE_CANDY ; item
    db SPRITE_BOULDER, $f + 4, $5 + 4, $ff, $10, $5 ; person
    db SPRITE_BOULDER, $2 + 4, $e + 4, $ff, $10, $6 ; person
    db SPRITE_BOULDER, $a + 4, $2 + 4, $ff, $10, $7 ; person

    ; warp-to
    EVENT_DISP $a, $11, $8
    EVENT_DISP $a, $11, $9
    EVENT_DISP $a, $1, $1 ; VICTORY_ROAD_2

VictoryRoad1Blocks: ; 90
    INCBIN "maps/victoryroad1.blk"

INCBIN "baserom.gbc",$5db5e,$24a2

SECTION "bank18",DATA,BANK[$18]

INCBIN "baserom.gbc",$60000,$60198 - $60000

UndergroundPathNSBlocks: ; 96
    INCBIN "maps/undergroundpathns.blk"

INCBIN "baserom.gbc",$601f8,$1c8

SSAnne9Blocks: ; 96
    INCBIN "maps/ssanne9.blk"

PokemonTower1_h: ; 0x60420 to 0x6042c (12 bytes) (id=142)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower1Blocks, $442f, $442c ; blocks, texts, scripts
    db $00 ; connections

    dw $4452 ; objects

INCBIN "baserom.gbc",$6042c,$6042f - $6042c
PokemonTower1Texts: ; 0x6042f
    dw PokemonTower1Text1, PokemonTower1Text2, PokemonTower1Text3, PokemonTower1Text4, PokemonTower1Text5

PokemonTower1Text1: ; 0x60439
    TX_FAR _PokemonTower1Text1
    db $50

PokemonTower1Text2: ; 0x6043e
    TX_FAR _PokemonTower1Text2
    db $50

PokemonTower1Text3: ; 0x60443
    TX_FAR _PokemonTower1Text3
    db $50

PokemonTower1Text4: ; 0x60448
    TX_FAR _PokemonTower1Text4
    db $50

PokemonTower1Text5: ; 0x6044d
    TX_FAR _PokemonTower1Text5
    db $50

PokemonTower1Object: ; 0x60452 (size=58)
    db $1 ; border tile

    db $3 ; warps
    db $11, $a, $1, $ff
    db $11, $b, $1, $ff
    db $9, $12, $1, POKEMONTOWER_2

    db $0 ; signs

    db $5 ; people
    db SPRITE_CABLE_CLUB_WOMAN, $d + 4, $f + 4, $ff, $d1, $1 ; person
    db SPRITE_MOM_GEISHA, $8 + 4, $6 + 4, $ff, $ff, $2 ; person
    db SPRITE_BALDING_GUY, $c + 4, $8 + 4, $ff, $ff, $3 ; person
    db SPRITE_GIRL, $7 + 4, $d + 4, $ff, $ff, $4 ; person
    db SPRITE_MEDIUM, $7 + 4, $11 + 4, $ff, $d2, $5 ; person

    ; warp-to
    EVENT_DISP $a, $11, $a
    EVENT_DISP $a, $11, $b
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_2

PokemonTower1Blocks: ; 90
    INCBIN "maps/pokemontower1.blk"

PokemonTower2_h: ; 0x604e6 to 0x604f2 (12 bytes) (id=143)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower2Blocks, $45db, $44f2 ; blocks, texts, scripts
    db $00 ; connections

    dw $4646 ; objects

INCBIN "baserom.gbc",$604f2,$605df - $604f2
PokemonTower2Text1: ; 0x605df
    db $08 ; asm
    ld a, [$d764]
    bit 7, a
    jr z, .asm_16f24 ; 0x605e5
    ld hl, $463c
    call PrintText
    jr .asm_41852 ; 0x605ed
.asm_16f24 ; 0x605ef
    ld hl, $462d
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4632
    ld de, $4637
    call $3354
    ld a, $f2
    ld [$d059], a
    ld a, [$d715]
    cp $b1
    jr nz, .asm_0860c ; 0x6060f
    ld a, $4
    jr .asm_99cea ; 0x60613
.asm_0860c ; 0x60615
    cp $99
    jr nz, .asm_b3e6e ; 0x60617
    ld a, $5
    jr .asm_99cea ; 0x6061b
.asm_b3e6e ; 0x6061d
    ld a, $6
.asm_99cea ; 0x6061f
    ld [$d05d], a
    ld a, $1
    ld [$d62b], a
    ld [$da39], a
.asm_41852 ; 0x6062a
    jp $24d7

INCBIN "baserom.gbc",$6062d,$14

PokemonTower2Text2: ; 0x60641
    TX_FAR _PokemonTower2Text2
    db $50

PokemonTower2Object: ; 0x60646 (size=32)
    db $1 ; border tile

    db $2 ; warps
    db $9, $3, $0, POKEMONTOWER_3
    db $9, $12, $2, POKEMONTOWER_1

    db $0 ; signs

    db $2 ; people
    db SPRITE_BLUE, $5 + 4, $e + 4, $ff, $ff, $1 ; person
    db SPRITE_MEDIUM, $7 + 4, $3 + 4, $ff, $d3, $2 ; person

    ; warp-to
    EVENT_DISP $a, $9, $3 ; POKEMONTOWER_3
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_1

PokemonTower2Blocks: ; 90
    INCBIN "maps/pokemontower2.blk"

PokemonTower3_h: ; 0x606c0 to 0x606cc (12 bytes) (id=144)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower3Blocks, $46e5, $46cc ; blocks, texts, scripts
    db $00 ; connections

    dw $475d ; objects

INCBIN "baserom.gbc",$606cc,$60712 - $606cc
PokemonTower3Text1: ; 0x60712
    db $08 ; asm
    ld hl, $46ed
    call LoadTrainerHeader
    jp $24d7

PokemonTower3Text2: ; 0x6071c
    db $08 ; asm
    ld hl, $46f9
    call LoadTrainerHeader
    jp $24d7

PokemonTower3Text3: ; 0x60726
    db $08 ; asm
    ld hl, $4705
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$60730,$2d
PokemonTower3Object: ; 0x6075d (size=51)
    db $1 ; border tile

    db $2 ; warps
    db $9, $3, $0, POKEMONTOWER_2
    db $9, $12, $1, POKEMONTOWER_4

    db $0 ; signs

    db $4 ; people
    db SPRITE_MEDIUM, $3 + 4, $c + 4, $ff, $d2, $41, CHANNELER + $C8, $5 ; trainer
    db SPRITE_MEDIUM, $8 + 4, $9 + 4, $ff, $d0, $42, CHANNELER + $C8, $6 ; trainer
    db SPRITE_MEDIUM, $d + 4, $a + 4, $ff, $d0, $43, CHANNELER + $C8, $8 ; trainer
	db SPRITE_BALL, $1 + 4, $c + 4, $ff, $ff, $84, ESCAPE_ROPE ; item

    ; warp-to
    EVENT_DISP $a, $9, $3 ; POKEMONTOWER_2
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_4

PokemonTower3Blocks: ; 90
    INCBIN "maps/pokemontower3.blk"

PokemonTower4_h: ; 0x607ea to 0x607f6 (12 bytes) (id=145)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower4Blocks, $480f, $47f6 ; blocks, texts, scripts
    db $00 ; connections

    dw $488b ; objects

INCBIN "baserom.gbc",$607f6,$60840 - $607f6
PokemonTower4Text1: ; 0x60840
    db $08 ; asm
    ld hl, $481b
    call LoadTrainerHeader
    jp $24d7

PokemonTower4Text2: ; 0x6084a
    db $08 ; asm
    ld hl, $4827
    call LoadTrainerHeader
    jp $24d7

PokemonTower4Text3: ; 0x60854
    db $08 ; asm
    ld hl, $4833
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$6085e,$2d
PokemonTower4Object: ; 0x6088b (size=65)
    db $1 ; border tile

    db $2 ; warps
    db $9, $3, $0, POKEMONTOWER_5
    db $9, $12, $1, POKEMONTOWER_3

    db $0 ; signs

    db $6 ; people
    db SPRITE_MEDIUM, $a + 4, $5 + 4, $ff, $d3, $41, CHANNELER + $C8, $9 ; trainer
    db SPRITE_MEDIUM, $7 + 4, $f + 4, $ff, $d0, $42, CHANNELER + $C8, $a ; trainer
    db SPRITE_MEDIUM, $c + 4, $e + 4, $ff, $d2, $43, CHANNELER + $C8, $c ; trainer
	db SPRITE_BALL, $a + 4, $c + 4, $ff, $ff, $84, ELIXER ; item
	db SPRITE_BALL, $a + 4, $9 + 4, $ff, $ff, $85, AWAKENING ; item
	db SPRITE_BALL, $10 + 4, $c + 4, $ff, $ff, $86, HP_UP ; item

    ; warp-to
    EVENT_DISP $a, $9, $3 ; POKEMONTOWER_5
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_3

PokemonTower4Blocks: ; 90
    INCBIN "maps/pokemontower4.blk"

PokemonTower5_h: ; 0x60926 to 0x60932 (12 bytes) (id=146)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower5Blocks, $499b, $4932 ; blocks, texts, scripts
    db $00 ; connections

    dw $4a48 ; objects

INCBIN "baserom.gbc",$60932,$609da - $60932

PokemonTower5Text1: ; 0x609da
    TX_FAR _PokemonTower5Text1
    db $50

PokemonTower5Text2: ; 0x609df
    db $08 ; asm
    ld hl, $49a9
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$609e9,$609f8 - $609e9
PokemonTower5Text3: ; 0x609f8
    db $08 ; asm
    ld hl, $49b5
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$60a02,$60a11 - $60a02
PokemonTower5Text4: ; 0x60a11
    db $08 ; asm
    ld hl, $49c1
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$60a1b,$60a2a - $60a1b
PokemonTower5Text5: ; 0x60a2a
    db $08 ; asm
    ld hl, $49cd
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$60a34,$14
PokemonTower5Object: ; 0x60a48 (size=65)
    db $1 ; border tile

    db $2 ; warps
    db $9, $3, $0, POKEMONTOWER_4
    db $9, $12, $0, POKEMONTOWER_6

    db $0 ; signs

    db $6 ; people
    db SPRITE_MEDIUM, $8 + 4, $c + 4, $ff, $ff, $1 ; person
    db SPRITE_MEDIUM, $7 + 4, $11 + 4, $ff, $d2, $42, CHANNELER + $C8, $e ; trainer
    db SPRITE_MEDIUM, $3 + 4, $e + 4, $ff, $d2, $43, CHANNELER + $C8, $10 ; trainer
    db SPRITE_MEDIUM, $a + 4, $6 + 4, $ff, $d3, $44, CHANNELER + $C8, $11 ; trainer
    db SPRITE_MEDIUM, $10 + 4, $9 + 4, $ff, $d3, $45, CHANNELER + $C8, $12 ; trainer
	db SPRITE_BALL, $e + 4, $6 + 4, $ff, $ff, $86, NUGGET ; item

    ; warp-to
    EVENT_DISP $a, $9, $3 ; POKEMONTOWER_4
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_6

PokemonTower5Blocks: ; 90
    INCBIN "maps/pokemontower5.blk"

PokemonTower6_h: ; 0x60ae3 to 0x60aef (12 bytes) (id=147)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower6Blocks, $4bb1, $4aef ; blocks, texts, scripts
    db $00 ; connections

    dw $4c5b ; objects

INCBIN "baserom.gbc",$60aef,$60be4 - $60aef
PokemonTower6Text1: ; 0x60be4
    db $08 ; asm
    ld hl, $4bbf
    call LoadTrainerHeader
    jp $24d7

PokemonTower6Text2: ; 0x60bee
    db $08 ; asm
    ld hl, $4bcb
    call LoadTrainerHeader
    jp $24d7

PokemonTower6Text3: ; 0x60bf8
    db $08 ; asm
    ld hl, $4bd7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$60c02,$59
PokemonTower6Object: ; 0x60c5b (size=58)
    db $1 ; border tile

    db $2 ; warps
    db $9, $12, $1, POKEMONTOWER_5
    db $10, $9, $0, POKEMONTOWER_7

    db $0 ; signs

    db $5 ; people
    db SPRITE_MEDIUM, $a + 4, $c + 4, $ff, $d3, $41, CHANNELER + $C8, $13 ; trainer
    db SPRITE_MEDIUM, $5 + 4, $9 + 4, $ff, $d0, $42, CHANNELER + $C8, $14 ; trainer
    db SPRITE_MEDIUM, $5 + 4, $10 + 4, $ff, $d2, $43, CHANNELER + $C8, $15 ; trainer
	db SPRITE_BALL, $8 + 4, $6 + 4, $ff, $ff, $84, RARE_CANDY ; item
	db SPRITE_BALL, $e + 4, $e + 4, $ff, $ff, $85, X_ACCURACY ; item

    ; warp-to
    EVENT_DISP $a, $9, $12 ; POKEMONTOWER_5
    EVENT_DISP $a, $10, $9 ; POKEMONTOWER_7

PokemonTower6Blocks: ; 90
    INCBIN "maps/pokemontower6.blk"

INCBIN "baserom.gbc",$60cef,$a

PokemonTower7_h: ; 0x60cf9 to 0x60d05 (12 bytes) (id=148)
    db $0f ; tileset
    db $09, $0a ; dimensions (y, x)
    dw PokemonTower7Blocks, $4e3f, $4d05 ; blocks, texts, scripts
    db $00 ; connections

    dw $4ef6 ; objects

INCBIN "baserom.gbc",$60d05,$60e6c - $60d05
PokemonTower7Text1: ; 0x60e6c
    db $08 ; asm
    ld hl, $4e47
    call LoadTrainerHeader
    jp $24d7

PokemonTower7Text2: ; 0x60e76
    db $08 ; asm
    ld hl, $4e53
    call LoadTrainerHeader
    jp $24d7

PokemonTower7Text3: ; 0x60e80
    db $08 ; asm
    ld hl, $4e5f
    call LoadTrainerHeader
    jp $24d7

PokemonTower7Text4: ; 0x60e8a
    db $08 ; asm
    ld hl, $4ec4
    call PrintText
    ld hl, $d7e0
    set 7, [hl]
    ld hl, $d769
    set 7, [hl]
    ld a, $44
    ld [$cc4d], a
    ld a, $15
    call Predef
    ld a, $17
    ld [$cc4d], a
    ld a, $11
    call Predef
    ld a, $18
    ld [$cc4d], a
    ld a, $15
    call Predef
    ld a, $4
    ld [$d630], a
    ld [$da39], a
    jp $24d7

INCBIN "baserom.gbc",$60ec4,$32
PokemonTower7Object: ; 0x60ef6 (size=42)
    db $1 ; border tile

    db $1 ; warps
    db $10, $9, $1, POKEMONTOWER_6

    db $0 ; signs

    db $4 ; people
    db SPRITE_ROCKET, $b + 4, $9 + 4, $ff, $d3, $41, ROCKET + $C8, $13 ; trainer
    db SPRITE_ROCKET, $9 + 4, $c + 4, $ff, $d2, $42, ROCKET + $C8, $14 ; trainer
    db SPRITE_ROCKET, $7 + 4, $9 + 4, $ff, $d3, $43, ROCKET + $C8, $15 ; trainer
    db SPRITE_MR_FUJI, $3 + 4, $a + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $a, $10, $9 ; POKEMONTOWER_6

PokemonTower7Blocks: ; 90
    INCBIN "maps/pokemontower7.blk"

CeladonMart1_h: ; 0x60f7a to 0x60f86 (12 bytes) (id=122)
    db $12 ; tileset
    db $04, $0a ; dimensions (y, x)
    dw CeladonMart1Blocks, $4f89, $4f86 ; blocks, texts, scripts
    db $00 ; connections

    dw $4f9e ; objects

INCBIN "baserom.gbc",$60f86,$60f89 - $60f86
CeladonMart1Texts: ; 0x60f89
    dw CeladonMart1Text1, CeladonMart1Text2, CeladonMart1Text3

CeladonMart1Text1: ; 0x60f8f
    TX_FAR _CeladonMart1Text1
    db $50

CeladonMart1Text2: ; 0x60f94
    TX_FAR _CeladonMart1Text2
    db $50

CeladonMart1Text3: ; 0x60f99
    TX_FAR _CeladonMart1Text3
    db $50

CeladonMart1Object: ; 0x60f9e (size=64)
    db $f ; border tile

    db $6 ; warps
    db $7, $2, $0, $ff
    db $7, $3, $0, $ff
    db $7, $10, $1, $ff
    db $7, $11, $1, $ff
    db $1, $c, $0, CELADON_MART_2
    db $1, $1, $0, CELADON_MART_ELEVATOR

    db $2 ; signs
    db $4, $b, $2 ; CeladonMart1Text2
    db $1, $e, $3 ; CeladonMart1Text3

    db $1 ; people
    db SPRITE_CABLE_CLUB_WOMAN, $3 + 4, $8 + 4, $ff, $d0, $1 ; person

    ; warp-to
    EVENT_DISP $a, $7, $2
    EVENT_DISP $a, $7, $3
    EVENT_DISP $a, $7, $10
    EVENT_DISP $a, $7, $11
    EVENT_DISP $a, $1, $c ; CELADON_MART_2
    EVENT_DISP $a, $1, $1 ; CELADON_MART_ELEVATOR

CeladonMart1Blocks: ; 40
    INCBIN "maps/celadonmart1.blk"

INCBIN "baserom.gbc",$61006,$fb

ViridianForest_h: ; 0x61101 to 0x6110d (12 bytes) (id=51)
    db $03 ; tileset
    db $18, $11 ; dimensions (y, x)
    dw $4000, $5126, $510d ; blocks, texts, scripts
    db $00 ; connections

    dw $51da ; objects

INCBIN "baserom.gbc",$6110d,$61167 - $6110d

ViridianForestText1: ; 0x61167
    TX_FAR _ViridianForestText1
    db $50

ViridianForestText2: ; 0x6116c
    db $08 ; asm
    ld hl, $5142
    call LoadTrainerHeader
    jp $24d7

ViridianForestText3: ; 0x61176
    db $08 ; asm
    ld hl, $514e
    call LoadTrainerHeader
    jp $24d7

ViridianForestText4: ; 0x61180
    db $08 ; asm
    ld hl, $515a
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$6118a,$2d

ViridianForestText8: ; 0x611b7
    TX_FAR _ViridianForestText8
    db $50

ViridianForestText9: ; 0x611bc
    TX_FAR _ViridianForestText9
    db $50

ViridianForestText10: ; 0x611c1
    TX_FAR _ViridianForestText10
    db $50

ViridianForestText11: ; 0x611c6
    TX_FAR _ViridianForestText11
    db $50

ViridianForestText12: ; 0x611cb
    TX_FAR _ViridianForestText12
    db $50

ViridianForestText13: ; 0x611d0
    TX_FAR _ViridianForestText13
    db $50

ViridianForestText14: ; 0x611d5
    TX_FAR _ViridianForestText14
    db $50

ViridianForestObject: ; 0x611da (size=127)
    db $3 ; border tile

    db $6 ; warps
    db $0, $1, $2, VIRIDIAN_FOREST_EXIT
    db $0, $2, $3, VIRIDIAN_FOREST_EXIT
    db $2f, $f, $1, VIRIDIAN_FOREST_ENTRANCE
    db $2f, $10, $1, VIRIDIAN_FOREST_ENTRANCE
    db $2f, $11, $1, VIRIDIAN_FOREST_ENTRANCE
    db $2f, $12, $1, VIRIDIAN_FOREST_ENTRANCE

    db $6 ; signs
    db $28, $18, $9 ; ViridianForestText9
    db $20, $10, $a ; ViridianForestText10
    db $11, $1a, $b ; ViridianForestText11
    db $18, $4, $c ; ViridianForestText12
    db $2d, $12, $d ; ViridianForestText13
    db $1, $2, $e ; ViridianForestText14

    db $8 ; people
    db SPRITE_BUG_CATCHER, $2b + 4, $10 + 4, $ff, $ff, $1 ; person
    db SPRITE_BUG_CATCHER, $21 + 4, $1e + 4, $ff, $d2, $42, BUG_CATCHER + $C8, $1 ; trainer
    db SPRITE_BUG_CATCHER, $13 + 4, $1e + 4, $ff, $d2, $43, BUG_CATCHER + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $12 + 4, $2 + 4, $ff, $d2, $44, BUG_CATCHER + $C8, $3 ; trainer
	db SPRITE_BALL, $b + 4, $19 + 4, $ff, $ff, $85, ANTIDOTE ; item
	db SPRITE_BALL, $1d + 4, $c + 4, $ff, $ff, $86, POTION ; item
	db SPRITE_BALL, $1f + 4, $1 + 4, $ff, $ff, $87, POKE_BALL ; item
    db SPRITE_BUG_CATCHER, $28 + 4, $1b + 4, $ff, $ff, $8 ; person

    ; warp-to
    EVENT_DISP $11, $0, $1 ; VIRIDIAN_FOREST_EXIT
    EVENT_DISP $11, $0, $2 ; VIRIDIAN_FOREST_EXIT
    EVENT_DISP $11, $2f, $f ; VIRIDIAN_FOREST_ENTRANCE
    EVENT_DISP $11, $2f, $10 ; VIRIDIAN_FOREST_ENTRANCE
    EVENT_DISP $11, $2f, $11 ; VIRIDIAN_FOREST_ENTRANCE
    EVENT_DISP $11, $2f, $12 ; VIRIDIAN_FOREST_ENTRANCE

SSAnne1_h: ; 0x61259 to 0x61265 (12 bytes) (id=95)
    db $0d ; tileset
    db $09, $14 ; dimensions (y, x)
    dw SSAnne1Blocks, $5269, $5265 ; blocks, texts, scripts
    db $00 ; connections

    dw $5277 ; objects

INCBIN "baserom.gbc",$61265,$61277 - $61265
SSAnne1Object: ; 0x61277 (size=104)
    db $c ; border tile

    db $b ; warps
    db $0, $1a, $1, VERMILION_DOCK
    db $0, $1b, $1, VERMILION_DOCK
    db $8, $1f, $0, SS_ANNE_8
    db $8, $17, $1, SS_ANNE_8
    db $8, $13, $2, SS_ANNE_8
    db $8, $f, $3, SS_ANNE_8
    db $8, $b, $4, SS_ANNE_8
    db $8, $7, $5, SS_ANNE_8
    db $6, $2, $6, SS_ANNE_2
    db $f, $25, $5, SS_ANNE_4
    db $10, $3, $0, SS_ANNE_6

    db $0 ; signs

    db $2 ; people
    db SPRITE_WAITER, $6 + 4, $c + 4, $fe, $2, $1 ; person
    db SPRITE_SAILOR, $5 + 4, $1b + 4, $ff, $ff, $2 ; person

    ; warp-to
    EVENT_DISP $14, $0, $1a ; VERMILION_DOCK
    EVENT_DISP $14, $0, $1b ; VERMILION_DOCK
    EVENT_DISP $14, $8, $1f ; SS_ANNE_8
    EVENT_DISP $14, $8, $17 ; SS_ANNE_8
    EVENT_DISP $14, $8, $13 ; SS_ANNE_8
    EVENT_DISP $14, $8, $f ; SS_ANNE_8
    EVENT_DISP $14, $8, $b ; SS_ANNE_8
    EVENT_DISP $14, $8, $7 ; SS_ANNE_8
    EVENT_DISP $14, $6, $2 ; SS_ANNE_2
    EVENT_DISP $14, $f, $25 ; SS_ANNE_4
    EVENT_DISP $14, $10, $3 ; SS_ANNE_6

SSAnne1Blocks: ; 180
    INCBIN "maps/ssanne1.blk"

SSAnne2_h: ; 0x61393 to 0x6139f (12 bytes) (id=96)
    db $0d ; tileset
    db $09, $14 ; dimensions (y, x)
    dw SSAnne2Blocks, $54db, $539f ; blocks, texts, scripts
    db $00 ; connections

    dw $5514 ; objects

INCBIN "baserom.gbc",$6139f,$61514 - $6139f
SSAnne2Object: ; 0x61514 (size=90)
    db $c ; border tile

    db $9 ; warps
    db $b, $9, $0, SS_ANNE_9
    db $b, $d, $2, SS_ANNE_9
    db $b, $11, $4, SS_ANNE_9
    db $b, $15, $6, SS_ANNE_9
    db $b, $19, $8, SS_ANNE_9
    db $b, $1d, $a, SS_ANNE_9
    db $4, $2, $8, SS_ANNE_1
    db $c, $2, $1, SS_ANNE_3
    db $4, $24, $0, SS_ANNE_7

    db $0 ; signs

    db $2 ; people
    db SPRITE_WAITER, $7 + 4, $3 + 4, $fe, $1, $1 ; person
    db SPRITE_BLUE, $4 + 4, $24 + 4, $ff, $d0, $42, SONY1 + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $14, $b, $9 ; SS_ANNE_9
    EVENT_DISP $14, $b, $d ; SS_ANNE_9
    EVENT_DISP $14, $b, $11 ; SS_ANNE_9
    EVENT_DISP $14, $b, $15 ; SS_ANNE_9
    EVENT_DISP $14, $b, $19 ; SS_ANNE_9
    EVENT_DISP $14, $b, $1d ; SS_ANNE_9
    EVENT_DISP $14, $4, $2 ; SS_ANNE_1
    EVENT_DISP $14, $c, $2 ; SS_ANNE_3
    EVENT_DISP $14, $4, $24 ; SS_ANNE_7

SSAnne2Blocks: ; 180
    INCBIN "maps/ssanne2.blk"

SSAnne4_h: ; 0x61622 to 0x6162e (12 bytes) (id=98)
    db $0d ; tileset
    db $04, $0f ; dimensions (y, x)
    dw SSAnne4Blocks, $5631, $562e ; blocks, texts, scripts
    db $00 ; connections

    dw $5632 ; objects

INCBIN "baserom.gbc",$6162e,$61632 - $6162e
SSAnne4Object: ; 0x61632 (size=52)
    db $c ; border tile

    db $6 ; warps
    db $3, $17, $8, SS_ANNE_10
    db $3, $13, $6, SS_ANNE_10
    db $3, $f, $4, SS_ANNE_10
    db $3, $b, $2, SS_ANNE_10
    db $3, $7, $0, SS_ANNE_10
    db $5, $1b, $9, SS_ANNE_1

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $f, $3, $17 ; SS_ANNE_10
    EVENT_DISP $f, $3, $13 ; SS_ANNE_10
    EVENT_DISP $f, $3, $f ; SS_ANNE_10
    EVENT_DISP $f, $3, $b ; SS_ANNE_10
    EVENT_DISP $f, $3, $7 ; SS_ANNE_10
    EVENT_DISP $f, $5, $1b ; SS_ANNE_1

SSAnne4Blocks: ; 60
    INCBIN "maps/ssanne4.blk"

SSAnne5_h: ; 0x616a2 to 0x616ae (12 bytes) (id=99)
    db $0d ; tileset
    db $07, $0a ; dimensions (y, x)
    dw SSAnne5Blocks, $56c7, $56ae ; blocks, texts, scripts
    db $00 ; connections

    dw $572b ; objects

INCBIN "baserom.gbc",$616ae,$616f9 - $616ae
SSAnne5Text4: ; 0x616f9
    db $08 ; asm
    ld hl, $56d1
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$61703,$61712 - $61703
SSAnne5Text5: ; 0x61712
    db $08 ; asm
    ld hl, $56dd
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$6171c,$f
SSAnne5Object: ; 0x6172b (size=54)
    db $23 ; border tile

    db $2 ; warps
    db $6, $d, $0, SS_ANNE_3
    db $7, $d, $0, SS_ANNE_3

    db $0 ; signs

    db $5 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $5 + 4, $ff, $d1, $1 ; person
    db SPRITE_SAILOR, $9 + 4, $4 + 4, $ff, $ff, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_1, $b + 4, $7 + 4, $ff, $ff, $3 ; person
    db SPRITE_SAILOR, $4 + 4, $4 + 4, $ff, $d0, $44, SAILOR + $C8, $1 ; trainer
    db SPRITE_SAILOR, $8 + 4, $a + 4, $ff, $d1, $45, SAILOR + $C8, $2 ; trainer

    ; warp-to
    EVENT_DISP $a, $6, $d ; SS_ANNE_3
    EVENT_DISP $a, $7, $d ; SS_ANNE_3

SSAnne5Blocks: ; 70
    INCBIN "maps/ssanne5.blk"

SSAnne6_h: ; 0x617a7 to 0x617b3 (12 bytes) (id=100)
    db $0d ; tileset
    db $08, $07 ; dimensions (y, x)
    dw SSAnne6Blocks, $57b7, $57b3 ; blocks, texts, scripts
    db $00 ; connections

    dw $581b ; objects

INCBIN "baserom.gbc",$617b3,$617e3 - $617b3
SSAnne6Text7: ; 0x617e3
    db $08 ; asm
    ld hl, $5807
    call PrintText
    ldh a, [$d3]
    bit 7, a
    jr z, .asm_93eb1 ; 0x617ee
    ld hl, $580c
    jr .asm_63292 ; 0x617f3
.asm_93eb1 ; 0x617f5
    bit 4, a
    jr z, .asm_7436c ; 0x617f7
    ld hl, $5811
    jr .asm_63292 ; 0x617fc
.asm_7436c ; 0x617fe
    ld hl, $5816
.asm_63292 ; 0x61801
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61807,$14
SSAnne6Object: ; 0x6181b (size=54)
    db $c ; border tile

    db $1 ; warps
    db $0, $6, $a, SS_ANNE_1

    db $0 ; signs

    db $7 ; people
    db SPRITE_COOK, $8 + 4, $1 + 4, $fe, $1, $1 ; person
    db SPRITE_COOK, $8 + 4, $5 + 4, $fe, $1, $2 ; person
    db SPRITE_COOK, $7 + 4, $9 + 4, $fe, $1, $3 ; person
    db SPRITE_COOK, $6 + 4, $d + 4, $ff, $ff, $4 ; person
    db SPRITE_COOK, $8 + 4, $d + 4, $ff, $ff, $5 ; person
    db SPRITE_COOK, $a + 4, $d + 4, $ff, $ff, $6 ; person
    db SPRITE_COOK, $d + 4, $b + 4, $ff, $d1, $7 ; person

    ; warp-to
    EVENT_DISP $7, $0, $6 ; SS_ANNE_1

SSAnne6Blocks: ; 56
    INCBIN "maps/ssanne6.blk"

SSAnne7_h: ; 0x61889 to 0x61895 (12 bytes) (id=101)
    db $0d ; tileset
    db $04, $03 ; dimensions (y, x)
    dw SSAnne7Blocks, $58a7, $5895 ; blocks, texts, scripts
    db $00 ; connections

    dw $5946 ; objects

INCBIN "baserom.gbc",$61895,$618ad - $61895
SSAnne7Text1: ; 0x618ad
    db $08 ; asm
    ld a, [$d803]
    bit 0, a
    jr nz, .asm_797c4 ; 0x618b3
    ld hl, $58ec
    call PrintText
    ld hl, $5927
    call PrintText
    ld bc,(HM_01 << 8) | 1
    call $3e2e
    jr nc, .asm_ccdcd ; 0x618c7
    ld hl, $592c
    call PrintText
    ld hl, $d803
    set 0, [hl]
    jr .asm_0faf5 ; 0x618d4
.asm_ccdcd ; 0x618d6
    ld hl, $5937
    call PrintText
    ld hl, $d72d
    set 5, [hl]
    jr .asm_0faf5 ; 0x618e1
.asm_797c4 ; 0x618e3
    ld hl, $5932
    call PrintText
.asm_0faf5 ; 0x618e9
    jp $24d7

INCBIN "baserom.gbc",$618ec,$50

SSAnne7Text2: ; 0x6193c
    TX_FAR _SSAnne7Text2
    db $50

SSAnne7Text3: ; 0x61941
    TX_FAR _SSAnne7Text3
    db $50

SSAnne7Object: ; 0x61946 (size=24)
    db $c ; border tile

    db $1 ; warps
    db $7, $0, $8, SS_ANNE_2

    db $2 ; signs
    db $1, $4, $2 ; SSAnne7Text2
    db $2, $1, $3 ; SSAnne7Text3

    db $1 ; people
    db SPRITE_SS_CAPTAIN, $2 + 4, $4 + 4, $ff, $d1, $1 ; person

    ; warp-to
    EVENT_DISP $3, $7, $0 ; SS_ANNE_2

SSAnne7Blocks: ; 12
    INCBIN "maps/ssanne7.blk"

SSAnne8_h: ; 0x6196a to 0x61976 (12 bytes) (id=102)
    db $0d ; tileset
    db $08, $0c ; dimensions (y, x)
    dw SSAnne8Blocks, $598f, $5976 ; blocks, texts, scripts
    db $00 ; connections

    dw $5a60 ; objects

INCBIN "baserom.gbc",$61976,$619d6 - $61976
SSAnne8Text1: ; 0x619d6
    db $08 ; asm
    ld hl, $59a5
    call LoadTrainerHeader
    jp $24d7

SSAnne8Text2: ; 0x619e0
    db $08 ; asm
    ld hl, $59b1
    call LoadTrainerHeader
    jp $24d7

SSAnne8Text3: ; 0x619ea
    db $08 ; asm
    ld hl, $59bd
    call LoadTrainerHeader
    jp $24d7

SSAnne8Text4: ; 0x619f4
    db $08 ; asm
    ld hl, $59c9
    call LoadTrainerHeader
    jp $24d7

SSAnne8Text8: ; 0x619fe
    TX_FAR _SSAnne8Text8
    db $08 ; asm
    ld a, $65
    call $13d0
    jp $24d7

INCBIN "baserom.gbc",$61a0b,60

SSAnne8Text5: ; 0x61a47
    TX_FAR _SSAnne8Text5
    db $50

SSAnne8Text6: ; 0x61a4c
    TX_FAR _SSAnne8Text6
    db $50

SSAnne8Text7: ; 0x61a51
    TX_FAR _SSAnne8Text7
    db $50

SSAnne8Text9: ; 0x61a56
    TX_FAR _SSAnne8Text9
    db $50

SSAnne8Text11: ; 0x61a5b
    TX_FAR _SSAnne8Text11
    db $50

SSAnne8Object: ; 0x61a60 (size=127)
    db $c ; border tile

    db $6 ; warps
    db $0, $0, $2, SS_ANNE_1
    db $0, $a, $3, SS_ANNE_1
    db $0, $14, $4, SS_ANNE_1
    db $a, $0, $5, SS_ANNE_1
    db $a, $a, $6, SS_ANNE_1
    db $a, $14, $7, SS_ANNE_1

    db $0 ; signs

    db $b ; people
    db SPRITE_GENTLEMAN, $3 + 4, $2 + 4, $ff, $d2, $41, GENTLEMAN + $C8, $1 ; trainer
    db SPRITE_GENTLEMAN, $4 + 4, $b + 4, $ff, $d1, $42, GENTLEMAN + $C8, $2 ; trainer
    db SPRITE_BUG_CATCHER, $e + 4, $b + 4, $ff, $d1, $43, YOUNGSTER + $C8, $8 ; trainer
    db SPRITE_LASS, $b + 4, $d + 4, $ff, $d2, $44, LASS + $C8, $b ; trainer
    db SPRITE_GIRL, $3 + 4, $16 + 4, $fe, $1, $5 ; person
    db SPRITE_FAT_BALD_GUY, $e + 4, $0 + 4, $ff, $ff, $6 ; person
    db SPRITE_LITTLE_GIRL, $b + 4, $2 + 4, $ff, $d0, $7 ; person
    db SPRITE_CLEFAIRY, $b + 4, $3 + 4, $ff, $d0, $8 ; person
    db SPRITE_GIRL, $d + 4, $a + 4, $ff, $d3, $9 ; person
	db SPRITE_BALL, $f + 4, $c + 4, $ff, $ff, $8a, TM_08 ; item
    db SPRITE_GENTLEMAN, $d + 4, $15 + 4, $fe, $2, $b ; person

    ; warp-to
    EVENT_DISP $c, $0, $0 ; SS_ANNE_1
    EVENT_DISP $c, $0, $a ; SS_ANNE_1
    EVENT_DISP $c, $0, $14 ; SS_ANNE_1
    EVENT_DISP $c, $a, $0 ; SS_ANNE_1
    EVENT_DISP $c, $a, $a ; SS_ANNE_1
    EVENT_DISP $c, $a, $14 ; SS_ANNE_1

SSAnne8Blocks: ; 96
    INCBIN "maps/ssanne8.blk"

SSAnne9_h: ; 0x61b3f to 0x61b4b (12 bytes) (id=103)
    db $0d ; tileset
    db $08, $0c ; dimensions (y, x)
    dw SSAnne9Blocks, $5b6a, $5b4b ; blocks, texts, scripts
    db $00 ; connections

    dw $5c8d ; objects

INCBIN "baserom.gbc",$61b4b,$61bb5 - $61b4b
SSAnne9Text1: ; 0x61bb5
    db $08 ; asm
    ld hl, $5b84
    call LoadTrainerHeader
    jp $24d7

SSAnne9Text2: ; 0x61bbf
    db $08 ; asm
    ld hl, $5b90
    call LoadTrainerHeader
    jp $24d7

SSAnne9Text3: ; 0x61bc9
    db $08 ; asm
    ld hl, $5b9c
    call LoadTrainerHeader
    jp $24d7

SSAnne9Text4: ; 0x61bd3
    db $08 ; asm
    ld hl, $5ba8
    call LoadTrainerHeader
    jp $24d7

SSAnne9Text5: ; 0x61bdd
    db $08 ; asm
    call $3719
    ld hl, $5bf2
    call PrintText
    call $3725
    ld a, $84
    call $349b
    jp $24d7

INCBIN "baserom.gbc",$61bf2,$61bf7 - $61bf2
SSAnne9Text7: ; 0x61bf7
    db $08 ; asm
    ld hl, $5c01
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c01,$61c06 - $61c01
SSAnne9Text8: ; 0x61c06
    db $08 ; asm
    ld hl, $5c10
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c10,$61c15 - $61c10
SSAnne9Text10: ; 0x61c15
    db $08 ; asm
    ld hl, $5c1f
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c1f,$61c24 - $61c1f
SSAnne9Text11: ; 0x61c24
    db $08 ; asm
    ld hl, $5c2e
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c2e,$61c33 - $61c2e
SSAnne9Text12: ; 0x61c33
    db $08 ; asm
    ld hl, $5c3d
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c3d,$61c42 - $61c3d
SSAnne9Text13: ; 0x61c42
    db $08 ; asm
    ld hl, $5c4c
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$61c4c,$41
SSAnne9Object: ; 0x61c8d (size=188)
    db $c ; border tile

    db $c ; warps
    db $5, $2, $0, SS_ANNE_2
    db $5, $3, $0, SS_ANNE_2
    db $5, $c, $1, SS_ANNE_2
    db $5, $d, $1, SS_ANNE_2
    db $5, $16, $2, SS_ANNE_2
    db $5, $17, $2, SS_ANNE_2
    db $f, $2, $3, SS_ANNE_2
    db $f, $3, $3, SS_ANNE_2
    db $f, $c, $4, SS_ANNE_2
    db $f, $d, $4, SS_ANNE_2
    db $f, $16, $5, SS_ANNE_2
    db $f, $17, $5, SS_ANNE_2

    db $0 ; signs

    db $d ; people
    db SPRITE_GENTLEMAN, $2 + 4, $a + 4, $ff, $d3, $41, GENTLEMAN + $C8, $3 ; trainer
    db SPRITE_FISHER2, $4 + 4, $d + 4, $ff, $d2, $42, FISHER + $C8, $1 ; trainer
    db SPRITE_GENTLEMAN, $e + 4, $0 + 4, $ff, $d3, $43, GENTLEMAN + $C8, $5 ; trainer
    db SPRITE_LASS, $b + 4, $2 + 4, $ff, $d0, $44, LASS + $C8, $c ; trainer
    db SPRITE_GENTLEMAN, $2 + 4, $1 + 4, $ff, $d0, $5 ; person
	db SPRITE_BALL, $1 + 4, $c + 4, $ff, $ff, $86, MAX_ETHER ; item
    db SPRITE_GENTLEMAN, $2 + 4, $15 + 4, $ff, $d0, $7 ; person
    db SPRITE_OLD_PERSON, $1 + 4, $16 + 4, $ff, $d0, $8 ; person
	db SPRITE_BALL, $c + 4, $0 + 4, $ff, $ff, $89, RARE_CANDY ; item
    db SPRITE_GENTLEMAN, $c + 4, $c + 4, $ff, $d0, $a ; person
    db SPRITE_YOUNG_BOY, $e + 4, $b + 4, $ff, $ff, $b ; person
    db SPRITE_BRUNETTE_GIRL, $c + 4, $16 + 4, $ff, $d2, $c ; person
    db SPRITE_FOULARD_WOMAN, $c + 4, $14 + 4, $ff, $d3, $d ; person

    ; warp-to
    EVENT_DISP $c, $5, $2 ; SS_ANNE_2
    EVENT_DISP $c, $5, $3 ; SS_ANNE_2
    EVENT_DISP $c, $5, $c ; SS_ANNE_2
    EVENT_DISP $c, $5, $d ; SS_ANNE_2
    EVENT_DISP $c, $5, $16 ; SS_ANNE_2
    EVENT_DISP $c, $5, $17 ; SS_ANNE_2
    EVENT_DISP $c, $f, $2 ; SS_ANNE_2
    EVENT_DISP $c, $f, $3 ; SS_ANNE_2
    EVENT_DISP $c, $f, $c ; SS_ANNE_2
    EVENT_DISP $c, $f, $d ; SS_ANNE_2
    EVENT_DISP $c, $f, $16 ; SS_ANNE_2
    EVENT_DISP $c, $f, $17 ; SS_ANNE_2

SSAnne10_h: ; 0x61d49 to 0x61d55 (12 bytes) (id=104)
    db $0d ; tileset
    db $08, $0c ; dimensions (y, x)
    dw $43c0, $5d6e, $5d55 ; blocks, texts, scripts
    db $00 ; connections

    dw $5e75 ; objects

INCBIN "baserom.gbc",$61d55,$61dcd - $61d55
SSAnne10Text1: ; 0x61dcd
    db $08 ; asm
    ld hl, $5d84
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text2: ; 0x61dd7
    db $08 ; asm
    ld hl, $5d90
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text3: ; 0x61de1
    db $08 ; asm
    ld hl, $5d9c
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text4: ; 0x61deb
    db $08 ; asm
    ld hl, $5da8
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text5: ; 0x61df5
    db $08 ; asm
    ld hl, $5db4
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text6: ; 0x61dff
    db $08 ; asm
    ld hl, $5dc0
    call LoadTrainerHeader
    jp $24d7

SSAnne10Text8: ; 0x61e09
    TX_FAR _SSAnne10Text8
    db $8 ; 0x61e0d
    ld a, $29
    call $13d0
    jp $24d7

INCBIN "baserom.gbc",$61e16,$61e70 - $61e16

SSAnne10Text7: ; 0x61e70
    TX_FAR _SSAnne10Text7
    db $50

SSAnne10Object: ; 0x61e75 (size=165)
    db $c ; border tile

    db $a ; warps
    db $5, $2, $4, SS_ANNE_4
    db $5, $3, $4, SS_ANNE_4
    db $5, $c, $3, SS_ANNE_4
    db $5, $d, $3, SS_ANNE_4
    db $5, $16, $2, SS_ANNE_4
    db $5, $17, $2, SS_ANNE_4
    db $f, $2, $1, SS_ANNE_4
    db $f, $3, $1, SS_ANNE_4
    db $f, $c, $0, SS_ANNE_4
    db $f, $d, $0, SS_ANNE_4

    db $0 ; signs

    db $b ; people
    db SPRITE_SAILOR, $d + 4, $0 + 4, $ff, $d0, $41, SAILOR + $C8, $3 ; trainer
    db SPRITE_SAILOR, $b + 4, $2 + 4, $ff, $d0, $42, SAILOR + $C8, $4 ; trainer
    db SPRITE_SAILOR, $3 + 4, $c + 4, $ff, $d2, $43, SAILOR + $C8, $5 ; trainer
    db SPRITE_SAILOR, $2 + 4, $16 + 4, $ff, $d0, $44, SAILOR + $C8, $6 ; trainer
    db SPRITE_SAILOR, $2 + 4, $0 + 4, $ff, $d3, $45, SAILOR + $C8, $7 ; trainer
    db SPRITE_FISHER2, $4 + 4, $0 + 4, $ff, $d3, $46, FISHER + $C8, $2 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $d + 4, $a + 4, $ff, $d3, $7 ; person
    db SPRITE_SLOWBRO, $c + 4, $b + 4, $ff, $ff, $8 ; person
	db SPRITE_BALL, $2 + 4, $14 + 4, $ff, $ff, $89, ETHER ; item
	db SPRITE_BALL, $2 + 4, $a + 4, $ff, $ff, $8a, TM_44 ; item
	db SPRITE_BALL, $b + 4, $c + 4, $ff, $ff, $8b, MAX_POTION ; item

    ; warp-to
    EVENT_DISP $c, $5, $2 ; SS_ANNE_4
    EVENT_DISP $c, $5, $3 ; SS_ANNE_4
    EVENT_DISP $c, $5, $c ; SS_ANNE_4
    EVENT_DISP $c, $5, $d ; SS_ANNE_4
    EVENT_DISP $c, $5, $16 ; SS_ANNE_4
    EVENT_DISP $c, $5, $17 ; SS_ANNE_4
    EVENT_DISP $c, $f, $2 ; SS_ANNE_4
    EVENT_DISP $c, $f, $3 ; SS_ANNE_4
    EVENT_DISP $c, $f, $c ; SS_ANNE_4
    EVENT_DISP $c, $f, $d ; SS_ANNE_4

UndergroundPathNS_h: ; 0x61f1a to 0x61f26 (12 bytes) (id=119)
    db $0b ; tileset
    db $18, $04 ; dimensions (y, x)
    dw UndergroundPathNSBlocks, $5f29, $5f26 ; blocks, texts, scripts
    db $00 ; connections

    dw $5f2a ; objects

INCBIN "baserom.gbc",$61f26,$61f2a - $61f26
UndergroundPathNSObject: ; 0x61f2a (size=20)
    db $1 ; border tile

    db $2 ; warps
    db $4, $5, $2, PATH_ENTRANCE_ROUTE_5
    db $29, $2, $2, PATH_ENTRANCE_ROUTE_6

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $4, $4, $5 ; PATH_ENTRANCE_ROUTE_5
    EVENT_DISP $4, $29, $2 ; PATH_ENTRANCE_ROUTE_6

UndergroundPathWE_h: ; 0x61f3e to 0x61f4a (12 bytes) (id=121)
    db $0b ; tileset
    db $04, $19 ; dimensions (y, x)
    dw $41f4, $5f4d, $5f4a ; blocks, texts, scripts
    db $00 ; connections

    dw $5f4e ; objects

INCBIN "baserom.gbc",$61f4a,$61f4e - $61f4a
UndergroundPathWEObject: ; 0x61f4e (size=20)
    db $1 ; border tile

    db $2 ; warps
    db $5, $2, $2, PATH_ENTRANCE_ROUTE_7
    db $2, $2f, $2, PATH_ENTRANCE_ROUTE_8

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $19, $5, $2 ; PATH_ENTRANCE_ROUTE_7
    EVENT_DISP $19, $2, $2f ; PATH_ENTRANCE_ROUTE_8

DiglettsCave_h: ; 0x61f62 to 0x61f6e (12 bytes) (id=197)
    db $11 ; tileset
    db $12, $14 ; dimensions (y, x)
    dw DiglettsCaveBlocks, $5f71, $5f6e ; blocks, texts, scripts
    db $00 ; connections

    dw $5f72 ; objects

INCBIN "baserom.gbc",$61f6e,$61f72 - $61f6e
DiglettsCaveObject: ; 0x61f72 (size=20)
    db $19 ; border tile

    db $2 ; warps
    db $5, $5, $2, DIGLETTS_CAVE_EXIT
    db $1f, $25, $2, DIGLETTS_CAVE_ENTRANCE

    db $0 ; signs

    db $0 ; people

    ; warp-to
    EVENT_DISP $14, $5, $5 ; DIGLETTS_CAVE_EXIT
    EVENT_DISP $14, $1f, $25 ; DIGLETTS_CAVE_ENTRANCE

DiglettsCaveBlocks: ; 360
    INCBIN "maps/diglettscave.blk"

SilphCo11_h: ; 0x620ee to 0x620fa (12 bytes) (id=235)
    db $10 ; tileset
    db $09, $09 ; dimensions (y, x)
    dw SilphCo11Blocks, $62b7, $60fa ; blocks, texts, scripts
    db $00 ; connections

    dw $6380 ; objects

INCBIN "baserom.gbc",$620fa,$622dc - $620fa
SilphCo11Text1: ; 0x622dc
    db $08 ; asm
    ld a, [$d838]
    bit 5, a
    jp nz, $6308
    ld hl, $6311
    call PrintText
    ld bc,(MASTER_BALL << 8) | 1
    call $3e2e
    jr nc, .asm_36088 ; 0x622f1
    ld hl, $6316
    call PrintText
    ld hl, $d838
    set 5, [hl]
    jr .asm_fd405 ; 0x622fe
.asm_36088 ; 0x62300
    ld hl, $6321
    call PrintText
    jr .asm_fd405 ; 0x62306
    ld hl, $631c
    call PrintText
.asm_fd405 ; 0x6230e
    jp $24d7

INCBIN "baserom.gbc",$62311,$15

SilphCo11Text2: ; 0x62326
    TX_FAR _SilphCo11Text2
    db $50

SilphCo11Text3: ; 0x6232b
    TX_FAR _SilphCo11Text3
    db $50

INCBIN "baserom.gbc",$62330,$6233a - $62330
SilphCo11Text4: ; 0x6233a
    db $08 ; asm
    ld hl, $62c3
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$62344,$62353 - $62344
SilphCo11Text5: ; 0x62353
    db $08 ; asm
    ld hl, $62cf
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$6235d,$23
SilphCo11Object: ; 0x62380 (size=72)
    db $d ; border tile

    db $4 ; warps
    db $0, $9, $1, SILPH_CO_10F
    db $0, $d, $0, SILPH_CO_ELEVATOR
    db $5, $5, $9, $ff
    db $2, $3, $3, SILPH_CO_7F

    db $0 ; signs

    db $5 ; people
    db SPRITE_MR_MASTERBALL, $5 + 4, $7 + 4, $ff, $d0, $1 ; person
    db SPRITE_FOULARD_WOMAN, $5 + 4, $a + 4, $ff, $d0, $2 ; person
    db SPRITE_GIOVANNI, $9 + 4, $6 + 4, $ff, $d0, $43, GIOVANNI + $C8, $2 ; trainer
    db SPRITE_ROCKET, $10 + 4, $3 + 4, $ff, $d1, $44, ROCKET + $C8, $29 ; trainer
    db SPRITE_ROCKET, $9 + 4, $f + 4, $ff, $d1, $45, ROCKET + $C8, $28 ; trainer

    ; warp-to
    EVENT_DISP $9, $0, $9 ; SILPH_CO_10F
    EVENT_DISP $9, $0, $d ; SILPH_CO_ELEVATOR
    EVENT_DISP $9, $5, $5
    EVENT_DISP $9, $2, $3 ; SILPH_CO_7F

SilphCo11Blocks: ; 81
    INCBIN "maps/silphco11.blk"

INCBIN "baserom.gbc",$62419,$1be7

SECTION "bank19",DATA,BANK[$19]
Tset00_GFX:
	INCBIN "baserom.gbc",$64000,$645E0-$64000
Tset00_Block:
	INCBIN "baserom.gbc",$645E0,$64DE0-$645E0
Tset01_GFX:
	INCBIN "baserom.gbc",$64DE0,$65270-$64DE0
Tset01_Block:
	INCBIN "baserom.gbc",$65270,$653A0-$65270
Tset08_GFX:
	INCBIN "baserom.gbc",$653A0,$65980-$653A0
Tset08_Block:
	INCBIN "baserom.gbc",$65980,$65BB0-$65980
Tset13_GFX:
	INCBIN "baserom.gbc",$65BB0,$66190-$65BB0
Tset13_Block:
	INCBIN "baserom.gbc",$66190,$66610-$66190
Tset0E_GFX:
	INCBIN "baserom.gbc",$66610,$66BF0-$66610
Tset0E_Block:
	INCBIN "baserom.gbc",$66BF0,$66D60-$66BF0
Tset10_GFX:
	INCBIN "baserom.gbc",$66D60,$67350-$66D60
Tset10_Block:
	INCBIN "baserom.gbc",$67350,$676F0-$67350
Tset17_GFX:
	INCBIN "baserom.gbc",$676F0,$67B50-$676F0
Tset17_Block:
	INCBIN "baserom.gbc",$67B50,$68000-$67B50

SECTION "bank1A",DATA,BANK[$1A]

DecrementPP:
; after using a move, decrement pp in battle and (if not transformed?) in party
	ld a,[de]
	cp a,STRUGGLE
	ret z
	ld hl,$D062
	ld a,[hli]
	and a,7
	ret nz
	bit 6,[hl]
	ret nz
	ld hl,$D02D ; PP of first move (in battle)
	call .DecrementPP\@

	ld a,[$D064]
	bit 3,a ; XXX transform status?
	ret nz

	ld hl,$D188 ; PP of first move (in party)
	ld a,[$CC2F] ; which mon in party is active
	ld bc,$2C
	call AddNTimes
.DecrementPP\@
	ld a,[$CC2E] ; which move (0, 1, 2, 3) did we use?
	ld c,a
	ld b,0
	add hl,bc
	dec [hl] ; Decrement PP
	ret

INCBIN "baserom.gbc",$6802F,$6807F-$6802F
Tset05_GFX:
	INCBIN "baserom.gbc",$6807F,$6867F-$6807F
Tset05_Block:
	INCBIN "baserom.gbc",$6867F,$68DBF-$6867F
Tset02_GFX:
	INCBIN "baserom.gbc",$68DBF,$693BF-$68DBF
Tset02_Block:
	INCBIN "baserom.gbc",$693BF,$6960F-$693BF
Tset09_GFX:
	INCBIN "baserom.gbc",$6960F,$69BFF-$6960F
Tset09_Block:
	INCBIN "baserom.gbc",$69BFF,$6A3FF-$69BFF
Tset03_GFX:
	INCBIN "baserom.gbc",$6A3FF,$6A9FF-$6A3FF
Tset03_Block:
	INCBIN "baserom.gbc",$6A9FF,$6B1FF-$6A9FF
Tset16_GFX:
	INCBIN "baserom.gbc",$6B1FF,$6B7FF-$6B1FF
Tset16_Block:
	INCBIN "baserom.gbc",$6B7FF,$6C000-$6B7FF

SECTION "bank1B",DATA,BANK[$1B]
Tset0F_GFX:
	INCBIN "baserom.gbc",$6C000,$6C5C0-$6C000
Tset0F_Block:
	INCBIN "baserom.gbc",$6C5C0,$6CCA0-$6C5C0
Tset11_GFX:
	INCBIN "baserom.gbc",$6CCA0,$6D0C0-$6CCA0
Tset11_Block:
	INCBIN "baserom.gbc",$6D0C0,$6D8C0-$6D0C0
Tset12_GFX:
	INCBIN "baserom.gbc",$6D8C0,$6DEA0-$6D8C0
Tset12_Block:
	INCBIN "baserom.gbc",$6DEA0,$6E390-$6DEA0
Tset0D_GFX:
	INCBIN "baserom.gbc",$6E390,$6E930-$6E390
Tset0D_Block:
	INCBIN "baserom.gbc",$6E930,$6ED10-$6E930
Tset14_GFX:
	INCBIN "baserom.gbc",$6ED10,$6F2D0-$6ED10
Tset14_Block:
	INCBIN "baserom.gbc",$6F2D0,$6F670-$6F2D0
Tset15_GFX:
	INCBIN "baserom.gbc",$6F670,$6FB20-$6F670
Tset15_Block:
	INCBIN "baserom.gbc",$6FB20,$6FD60-$6FB20
Tset0B_GFX:
	INCBIN "baserom.gbc",$6FD60,$6FEF0-$6FD60
Tset0B_Block:
	INCBIN "baserom.gbc",$6FEF0,$70000-$6FEF0

SECTION "bank1C",DATA,BANK[$1C]
INCBIN "baserom.gbc",$70000,$1100

CompressedMap: ; 5100
; you can decompress this file with the redrle program in the extras/ dir
	INCBIN "baserom.gbc",$71100,$711AB-$71100

INCBIN "baserom.gbc",$711AB,$71313-$711AB

ExternalMapEntries: ; 5313
	EMAP $2,$B,PalletTownName
	EMAP $2,$8,ViridianCityName
	EMAP $2,$3,PewterCityName
	EMAP $A,$2,CeruleanCityName
	EMAP $E,$5,LavenderTownName
	EMAP $A,$9,VermilionCityName
	EMAP $7,$5,CeladonCityName
	EMAP $8,$D,FuchsiaCityName
	EMAP $2,$F,CinnabarIslandName
	EMAP $0,$2,IndigoPlateauName
	EMAP $A,$5,SaffronCityName
	EMAP $0,$0,PalletTownName ; unused
	EMAP $2,$A,Route1Name
	EMAP $2,$6,Route2Name
	EMAP $4,$3,Route3Name
	EMAP $8,$2,Route4Name
	EMAP $A,$3,Route5Name
	EMAP $A,$8,Route6Name
	EMAP $8,$5,Route7Name
	EMAP $D,$5,Route8Name
	EMAP $D,$2,Route9Name
	EMAP $E,$4,Route10Name
	EMAP $C,$9,Route11Name
	EMAP $E,$9,Route12Name
	EMAP $D,$B,Route13Name
	EMAP $B,$C,Route14Name
	EMAP $A,$D,Route15Name
	EMAP $5,$5,Route16Name
	EMAP $4,$8,Route17Name
	EMAP $6,$D,Route18Name
	EMAP $6,$F,Route19Name
	EMAP $4,$F,Route20Name
	EMAP $2,$D,Route21Name
	EMAP $0,$8,Route22Name
	EMAP $0,$6,Route23Name
	EMAP $A,$1,Route24Name
	EMAP $B,$0,Route25Name

InternalMapEntries: ; 5382
	IMAP $29,$2,$B,PalletTownName
	IMAP $2E,$2,$8,ViridianCityName
	IMAP $33,$2,$6,Route2Name
	IMAP $34,$2,$4,ViridianForestName
	IMAP $3B,$2,$3,PewterCityName
	IMAP $3E,$6,$2,MountMoonName
	IMAP $44,$A,$2,CeruleanCityName
	IMAP $45,$5,$2,Route4Name
	IMAP $46,$A,$2,CeruleanCityName
	IMAP $49,$A,$4,Route5Name
	IMAP $4C,$A,$6,Route6Name
	IMAP $4F,$9,$5,Route7Name
	IMAP $51,$B,$5,Route8Name
	IMAP $53,$E,$3,RockTunnelName
	IMAP $54,$F,$4,PowerPlantName
	IMAP $57,$D,$9,Route11Name
	IMAP $58,$E,$7,Route12Name
	IMAP $59,$C,$0,SeaCottageName
	IMAP $5F,$A,$9,VermilionCityName
	IMAP $69,$9,$A,SSAnneName
	IMAP $6D,$0,$4,VictoryRoadName
	IMAP $77,$0,$2,PokemonLeagueName
	IMAP $78,$A,$5,UndergroundPathName
	IMAP $79,$0,$2,PokemonLeagueName
	IMAP $7A,$A,$5,UndergroundPathName
	IMAP $8D,$7,$5,CeladonCityName
	IMAP $8E,$E,$5,LavenderTownName
	IMAP $95,$F,$5,PokemonTowerName
	IMAP $98,$E,$5,LavenderTownName
	IMAP $9C,$8,$D,FuchsiaCityName
	IMAP $9D,$8,$C,SafariZoneName
	IMAP $9F,$8,$D,FuchsiaCityName
	IMAP $A3,$5,$F,SeafoamIslandsName
	IMAP $A4,$A,$9,VermilionCityName
	IMAP $A5,$8,$D,FuchsiaCityName
	IMAP $A6,$2,$F,PokemonMansionName
	IMAP $AE,$2,$F,CinnabarIslandName
	IMAP $AF,$0,$2,IndigoPlateauName
	IMAP $B8,$A,$5,SaffronCityName
	IMAP $BA,$9,$D,Route15Name
	IMAP $BD,$4,$5,Route16Name
	IMAP $BE,$E,$A,Route12Name
	IMAP $C0,$7,$D,Route18Name
	IMAP $C1,$5,$F,SeafoamIslandsName
	IMAP $C2,$0,$7,Route22Name
	IMAP $C3,$0,$4,VictoryRoadName
	IMAP $C4,$E,$7,Route12Name
	IMAP $C5,$A,$9,VermilionCityName
	IMAP $C6,$3,$4,DiglettsCaveName
	IMAP $C7,$0,$4,VictoryRoadName
	IMAP $CF,$7,$5,RocketHQName
	IMAP $D6,$A,$5,SilphCoName
	IMAP $D9,$2,$F,PokemonMansionName
	IMAP $E2,$8,$C,SafariZoneName
	IMAP $E5,$9,$1,CeruleanCaveName
	IMAP $E6,$E,$5,LavenderTownName
	IMAP $E7,$A,$2,CeruleanCityName
	IMAP $E9,$E,$3,RockTunnelName
	IMAP $ED,$A,$5,SilphCoName
	IMAP $F8,$0,$2,PokemonLeagueName
	db $FF

MapNames: ; 5473
PalletTownName:
	db "PALLET TOWN@"
ViridianCityName:
	db "VIRIDIAN CITY@"
PewterCityName:
	db "PEWTER CITY@"
CeruleanCityName:
	db "CERULEAN CITY@"
LavenderTownName:
	db "LAVENDER TOWN@"
VermilionCityName:
	db "VERMILION CITY@"
CeladonCityName:
	db "CELADON CITY@"
FuchsiaCityName:
	db "FUCHSIA CITY@"
CinnabarIslandName:
	db "CINNABAR ISLAND@"
IndigoPlateauName:
	db "INDIGO PLATEAU@"
SaffronCityName:
	db "SAFFRON CITY@"
Route1Name:
	db "ROUTE 1@"
Route2Name:
	db "ROUTE 2@"
Route3Name:
	db "ROUTE 3@"
Route4Name:
	db "ROUTE 4@"
Route5Name:
	db "ROUTE 5@"
Route6Name:
	db "ROUTE 6@"
Route7Name:
	db "ROUTE 7@"
Route8Name:
	db "ROUTE 8@"
Route9Name:
	db "ROUTE 9@"
Route10Name:
	db "ROUTE 10@"
Route11Name:
	db "ROUTE 11@"
Route12Name:
	db "ROUTE 12@"
Route13Name:
	db "ROUTE 13@"
Route14Name:
	db "ROUTE 14@"
Route15Name:
	db "ROUTE 15@"
Route16Name:
	db "ROUTE 16@"
Route17Name:
	db "ROUTE 17@"
Route18Name:
	db "ROUTE 18@"
Route19Name:
	db "SEA ROUTE 19@"
Route20Name:
	db "SEA ROUTE 20@"
Route21Name:
	db "SEA ROUTE 21@"
Route22Name:
	db "ROUTE 22@"
Route23Name:
	db "ROUTE 23@"
Route24Name:
	db "ROUTE 24@"
Route25Name:
	db "ROUTE 25@"
ViridianForestName:
	db "VIRIDIAN FOREST@"
MountMoonName:
	db "MT.MOON@"
RockTunnelName:
	db "ROCK TUNNEL@"
SeaCottageName:
	db "SEA COTTAGE@"
SSAnneName:
	db "S.S.ANNE@"
PokemonLeagueName:
	db "#MON LEAGUE@"
UndergroundPathName:
	db "UNDERGROUND PATH@"
PokemonTowerName:
	db "#MON TOWER@"
SeafoamIslandsName:
	db "SEAFOAM ISLANDS@"
VictoryRoadName:
	db "VICTORY ROAD@"
DiglettsCaveName:
	db "DIGLETT's CAVE@"
RocketHQName:
	db "ROCKET HQ@"
SilphCoName:
	db "SILPH CO.@"
PokemonMansionName:
	db $4a," MANSION@"
SafariZoneName:
	db "SAFARI ZONE@"
CeruleanCaveName:
	db "CERULEAN CAVE@"
PowerPlantName:
	db "POWER PLANT@"

INCBIN "baserom.gbc",$716BE,$71AD9-$716BE

Predef54: ; 0x71ad9
; trigger the trade offer/action specified by W_WHICHTRADE
	call $36f4
	ld hl,TradeMons
	ld a,[W_WHICHTRADE]
	ld b,a
	swap a
	sub b
	sub b
	ld c,a
	ld b,$0
	add hl,bc
	ld a,[hli]
	ld [$cd0f],a
	ld a,[hli]
	ld [$cd34],a
	ld a,[hli]
	push af
	ld de,$cd29
	ld bc,$000b
	call CopyData
	pop af
	ld l,a
	ld h,$0
	ld de,$5d64
	add hl,hl
	add hl,de
	ld a,[hli]
	ld [$cd10],a
	ld a,[hl]
	ld [$cd11],a
	ld a,[$cd0f]
	ld de,$cd13
	call Function71b6a
	ld a,[$cd34]
	ld de,$cd1e
	call Function71b6a
	ld hl,$d737
	ld a,[W_WHICHTRADE]
	ld c,a
	ld b,$2
	ld a,$10
	call Predef
	ld a,c
	and a
	ld a,$4
	ld [$cd12],a
	jr nz,.asm_99bca ; 0x71b36 $20
	xor a
	ld [$cd12],a
	call .asm_99bca
	ld a,$1
	ld [$cd12],a
	call $35ec
	ld a,[$cc26]
	and a
	jr nz,.asm_99bca ; 0x71b4b $b
	call Function71c07
	jr c,.asm_99bca ; 0x71b50 $6
	ld hl,$5d8d
	call PrintText
.asm_99bca ; 0x71b58
	ld hl,$cd12
	ld a,[hld]
	ld e,a
	ld d,$0
	ld a,[hld]
	ld l,[hl]
	ld h,a
	add hl,de
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp PrintText

Function71b6a: ; 0x71b6a
	push de
	ld [$d11e],a
	call GetMonName
	ld hl,$cd6d
	pop de
	ld bc,$b
	jp CopyData

TradeMons: ; 5B7B
; givemonster, getmonster, textstring, nickname (11 bytes), 14 bytes total
	db NIDORINO,  NIDORINA,  0,"TERRY@@@@@@"
	db ABRA,      MR_MIME,  0,"MARCEL@@@@@"
	db BUTTERFREE,BEEDRILL,  2,"CHIKUCHIKU@"
	db PONYTA,    SEEL,      0,"SAILOR@@@@@"
	db SPEAROW,   FARFETCH_D,2,"DUX@@@@@@@@"
	db SLOWBRO,   LICKITUNG, 0,"MARC@@@@@@@"
	db POLIWHIRL, JYNX,      1,"LOLA@@@@@@@"
	db RAICHU,    ELECTRODE, 1,"DORIS@@@@@@"
	db VENONAT,   TANGELA,   2,"CRINKLES@@@"
	db NIDORAN_M, NIDORAN_F, 2,"SPOT@@@@@@@"

Function71c07: ; 0x71c07
	xor a
	ld [$d07d],a
	dec a
	ld [$cfcb],a
	call $13fc
	push af
	call $5ca2
	pop af
	ld a,$1
	jp c,.asm_c4bc2
	ld a,[$cd0f]
	ld b,a
	ld a,[$cf91]
	cp b
	ld a,$2
	jr nz,.asm_c4bc2 ; 0x71c26 $75
	ld a,[$cf92]
	ld hl,$d18c
	ld bc,$002c
	call AddNTimes
	ld a,[hl]
	ld [$d127],a
	ld hl,$d737
	ld a,[W_WHICHTRADE]
	ld c,a
	ld b,$1
	ld a,$10
	call Predef
	ld hl,$5d88
	call PrintText
	ld a,[$cf92]
	push af
	ld a,[$d127]
	push af
	call $36c0
	call $5cc1
	ld a,$38
	call Predef
	pop af
	ld [$d127],a
	pop af
	ld [$cf92],a
	ld a,[$cd34]
	ld [$cf91],a
	xor a
	ld [$cc49],a
	ld [$cf95],a
	call $391f
	ld a,$80
	ld [$cc49],a
	call AddPokemonToParty
	call $5d19
	ld hl,$7d7d
	ld b,$5
	call Bankswitch
	call ClearScreen
	call $5ca2
	ld b,$3
	ld hl,$6edc
	call Bankswitch
	and a
	ld a,$3
	jr .asm_ee803 ; 0x71c9b $1
.asm_c4bc2 ; 0x71c9d
	scf
.asm_ee803 ; 0x71c9e
	ld [$cd12],a
	ret


INCBIN "baserom.gbc",$71CA2,$725C8-$71CA2

MonsterPalettes: ; 65C8
	db PAL_MEWMON    ; MISSINGNO
	db PAL_GREENMON  ; BULBASAUR
	db PAL_GREENMON  ; IVYSAUR
	db PAL_GREENMON  ; VENUSAUR
	db PAL_REDMON    ; CHARMANDER
	db PAL_REDMON    ; CHARMELEON
	db PAL_REDMON    ; CHARIZARD
	db PAL_CYANMON   ; SQUIRTLE
	db PAL_CYANMON   ; WARTORTLE
	db PAL_CYANMON   ; BLASTOISE
	db PAL_GREENMON  ; CATERPIE
	db PAL_GREENMON  ; METAPOD
	db PAL_CYANMON   ; BUTTERFREE
	db PAL_YELLOWMON ; WEEDLE
	db PAL_YELLOWMON ; KAKUNA
	db PAL_YELLOWMON ; BEEDRILL
	db PAL_BROWNMON  ; PIDGEY
	db PAL_BROWNMON  ; PIDGEOTTO
	db PAL_BROWNMON  ; PIDGEOT
	db PAL_GREYMON   ; RATTATA
	db PAL_GREYMON   ; RATICATE
	db PAL_BROWNMON  ; SPEAROW
	db PAL_BROWNMON  ; FEAROW
	db PAL_PURPLEMON ; EKANS
	db PAL_PURPLEMON ; ARBOK
	db PAL_YELLOWMON ; PIKACHU
	db PAL_YELLOWMON ; RAICHU
	db PAL_BROWNMON  ; SANDSHREW
	db PAL_BROWNMON  ; SANDSLASH
	db PAL_BLUEMON   ; NIDORAN_F
	db PAL_BLUEMON   ; NIDORINA
	db PAL_BLUEMON   ; NIDOQUEEN
	db PAL_PURPLEMON ; NIDORAN_M
	db PAL_PURPLEMON ; NIDORINO
	db PAL_PURPLEMON ; NIDOKING
	db PAL_PINKMON   ; CLEFAIRY
	db PAL_PINKMON   ; CLEFABLE
	db PAL_REDMON    ; VULPIX
	db PAL_YELLOWMON ; NINETALES
	db PAL_PINKMON   ; JIGGLYPUFF
	db PAL_PINKMON   ; WIGGLYTUFF
	db PAL_BLUEMON   ; ZUBAT
	db PAL_BLUEMON   ; GOLBAT
	db PAL_GREENMON  ; ODDISH
	db PAL_REDMON    ; GLOOM
	db PAL_REDMON    ; VILEPLUME
	db PAL_REDMON    ; PARAS
	db PAL_REDMON    ; PARASECT
	db PAL_PURPLEMON ; VENONAT
	db PAL_PURPLEMON ; VENOMOTH
	db PAL_BROWNMON  ; DIGLETT
	db PAL_BROWNMON  ; DUGTRIO
	db PAL_YELLOWMON ; MEOWTH
	db PAL_YELLOWMON ; PERSIAN
	db PAL_YELLOWMON ; PSYDUCK
	db PAL_CYANMON   ; GOLDUCK
	db PAL_BROWNMON  ; MANKEY
	db PAL_BROWNMON  ; PRIMEAPE
	db PAL_BROWNMON  ; GROWLITHE
	db PAL_REDMON    ; ARCANINE
	db PAL_BLUEMON   ; POLIWAG
	db PAL_BLUEMON   ; POLIWHIRL
	db PAL_BLUEMON   ; POLIWRATH
	db PAL_YELLOWMON ; ABRA
	db PAL_YELLOWMON ; KADABRA
	db PAL_YELLOWMON ; ALAKAZAM
	db PAL_GREYMON   ; MACHOP
	db PAL_GREYMON   ; MACHOKE
	db PAL_GREYMON   ; MACHAMP
	db PAL_GREENMON  ; BELLSPROUT
	db PAL_GREENMON  ; WEEPINBELL
	db PAL_GREENMON  ; VICTREEBEL
	db PAL_CYANMON   ; TENTACOOL
	db PAL_CYANMON   ; TENTACRUEL
	db PAL_GREYMON   ; GEODUDE
	db PAL_GREYMON   ; GRAVELER
	db PAL_GREYMON   ; GOLEM
	db PAL_REDMON    ; PONYTA
	db PAL_REDMON    ; RAPIDASH
	db PAL_PINKMON   ; SLOWPOKE
	db PAL_PINKMON   ; SLOWBRO
	db PAL_GREYMON   ; MAGNEMITE
	db PAL_GREYMON   ; MAGNETON
	db PAL_BROWNMON  ; FARFETCH_D
	db PAL_BROWNMON  ; DODUO
	db PAL_BROWNMON  ; DODRIO
	db PAL_BLUEMON   ; SEEL
	db PAL_BLUEMON   ; DEWGONG
	db PAL_PURPLEMON ; GRIMER
	db PAL_PURPLEMON ; MUK
	db PAL_GREYMON   ; SHELLDER
	db PAL_GREYMON   ; CLOYSTER
	db PAL_PURPLEMON ; GASTLY
	db PAL_PURPLEMON ; HAUNTER
	db PAL_PURPLEMON ; GENGAR
	db PAL_GREYMON   ; ONIX
	db PAL_YELLOWMON ; DROWZEE
	db PAL_YELLOWMON ; HYPNO
	db PAL_REDMON    ; KRABBY
	db PAL_REDMON    ; KINGLER
	db PAL_YELLOWMON ; VOLTORB
	db PAL_YELLOWMON ; ELECTRODE
	db PAL_PINKMON   ; EXEGGCUTE
	db PAL_GREENMON  ; EXEGGUTOR
	db PAL_GREYMON   ; CUBONE
	db PAL_GREYMON   ; MAROWAK
	db PAL_BROWNMON  ; HITMONLEE
	db PAL_BROWNMON  ; HITMONCHAN
	db PAL_PINKMON   ; LICKITUNG
	db PAL_PURPLEMON ; KOFFING
	db PAL_PURPLEMON ; WEEZING
	db PAL_GREYMON   ; RHYHORN
	db PAL_GREYMON   ; RHYDON
	db PAL_PINKMON   ; CHANSEY
	db PAL_BLUEMON   ; TANGELA
	db PAL_BROWNMON  ; KANGASKHAN
	db PAL_CYANMON   ; HORSEA
	db PAL_CYANMON   ; SEADRA
	db PAL_REDMON    ; GOLDEEN
	db PAL_REDMON    ; SEAKING
	db PAL_REDMON    ; STARYU
	db PAL_GREYMON   ; STARMIE
	db PAL_PINKMON   ; MR_MIME
	db PAL_GREENMON  ; SCYTHER
	db PAL_MEWMON    ; JYNX
	db PAL_YELLOWMON ; ELECTABUZZ
	db PAL_REDMON    ; MAGMAR
	db PAL_BROWNMON  ; PINSIR
	db PAL_GREYMON   ; TAUROS
	db PAL_REDMON    ; MAGIKARP
	db PAL_BLUEMON   ; GYARADOS
	db PAL_CYANMON   ; LAPRAS
	db PAL_GREYMON   ; DITTO
	db PAL_GREYMON   ; EEVEE
	db PAL_CYANMON   ; VAPOREON
	db PAL_YELLOWMON ; JOLTEON
	db PAL_REDMON    ; FLAREON
	db PAL_GREYMON   ; PORYGON
	db PAL_BLUEMON   ; OMANYTE
	db PAL_BLUEMON   ; OMASTAR
	db PAL_BROWNMON  ; KABUTO
	db PAL_BROWNMON  ; KABUTOPS
	db PAL_GREYMON   ; AERODACTYL
	db PAL_PINKMON   ; SNORLAX
	db PAL_BLUEMON   ; ARTICUNO
	db PAL_YELLOWMON ; ZAPDOS
	db PAL_REDMON    ; MOLTRES
	db PAL_GREYMON   ; DRATINI
	db PAL_BLUEMON   ; DRAGONAIR
	db PAL_BROWNMON  ; DRAGONITE
	db PAL_MEWMON    ; MEWTWO
	db PAL_MEWMON    ; MEW

; palettes for overworlds, title screen, monsters
SuperPalettes: ; 6660
	RGB 31,29,31 ; PAL_ROUTE
	RGB 21,28,11
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_PALLET
	RGB 25,28,27
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_VIRIDIAN
	RGB 17,26,3
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_PEWTER
	RGB 23,25,16
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_CERULEAN
	RGB 17,20,30
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_LAVENDER
	RGB 27,20,27
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_VERMILION
	RGB 30,18,0
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_CELADON
	RGB 16,30,22
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_FUCHSIA
	RGB 31,15,22
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_CINNABAR
	RGB 26,10,6
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_INDIGO
	RGB 22,14,24
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; PAL_SAFFRON
	RGB 27,27,3
	RGB 20,26,31
	RGB 3,2,2
	RGB 31,29,31 ; XXX
	RGB 20,26,31
	RGB 17,23,10
	RGB 3,2,2
	RGB 31,29,31 ; PAL_LOGO1
	RGB 30,30,17
	RGB 17,23,10
	RGB 21,0,4
	RGB 31,29,31 ; XXX
	RGB 30,30,17
	RGB 18,18,24
	RGB 7,7,16
	RGB 31,29,31 ; PAL_LOGO2
	RGB 24,20,30
	RGB 11,20,30
	RGB 3,2,2
	RGB 31,29,31 ; PAL_MEWMON
	RGB 30,22,17
	RGB 16,14,19
	RGB 3,2,2
	RGB 31,29,31 ; PAL_BLUEMON
	RGB 18,20,27
	RGB 11,15,23
	RGB 3,2,2
	RGB 31,29,31 ; PAL_REDMON
	RGB 31,20,10
	RGB 26,10,6
	RGB 3,2,2
	RGB 31,29,31 ; PAL_CYANMON
	RGB 21,25,29
	RGB 14,19,25
	RGB 3,2,2
	RGB 31,29,31 ; PAL_PURPLEMON
	RGB 27,22,24
	RGB 21,15,23
	RGB 3,2,2
	RGB 31,29,31 ; PAL_BROWNMON
	RGB 28,20,15
	RGB 21,14,9
	RGB 3,2,2
	RGB 31,29,31 ; PAL_GREENMON
	RGB 20,26,16
	RGB 9,20,11
	RGB 3,2,2
	RGB 31,29,31 ; PAL_PINKMON
	RGB 30,22,24
	RGB 28,15,21
	RGB 3,2,2
	RGB 31,29,31 ; PAL_YELLOWMON
	RGB 31,28,14
	RGB 26,20,0
	RGB 3,2,2
	RGB 31,29,31 ; PAL_GREYMON
	RGB 26,21,22
	RGB 15,15,18
	RGB 3,2,2
	RGB 31,29,31 ; PAL_SLOTS1
	RGB 26,21,22
	RGB 27,20,6
	RGB 3,2,2
	RGB 31,29,31 ; PAL_SLOTS2
	RGB 31,31,17
	RGB 25,17,21
	RGB 3,2,2
	RGB 31,29,31 ; PAL_SLOTS3
	RGB 22,31,16
	RGB 25,17,21
	RGB 3,2,2
	RGB 31,29,31 ; PAL_SLOTS4
	RGB 16,19,29
	RGB 25,17,21
	RGB 3,2,2
	RGB 31,29,31 ; PAL_BLACK
	RGB 7,7,7
	RGB 2,3,3
	RGB 3,2,2
	RGB 31,29,31 ; PAL_GREENBAR
	RGB 30,26,15
	RGB 9,20,11
	RGB 3,2,2
	RGB 31,29,31 ; PAL_YELLOWBAR
	RGB 30,26,15
	RGB 26,20,0
	RGB 3,2,2
	RGB 31,29,31 ; PAL_REDBAR
	RGB 30,26,15
	RGB 26,10,6
	RGB 3,2,2
	RGB 31,29,31 ; PAL_BADGE
	RGB 30,22,17
	RGB 11,15,23
	RGB 3,2,2
	RGB 31,29,31 ; PAL_CAVE
	RGB 21,14,9
	RGB 18,24,22
	RGB 3,2,2
	RGB 31,29,31 ; XXX
	RGB 31,28,14
	RGB 24,20,10
	RGB 3,2,2
BorderPalettes: ; 6788

INCBIN "baserom.gbc",$72788,$4000 - $2788

SECTION "bank1D",DATA,BANK[$1D]

INCBIN "baserom.gbc",$74000,$74010 - $74000

PewterMartBlocks: ; 16
    INCBIN "maps/pewtermart.blk"

FuchsiaHouse1Blocks: ; 16
    INCBIN "maps/fuchsiahouse1.blk"

FuchsiaPokecenterBlocks: ; 28
    INCBIN "maps/fuchsiapokecenter.blk"

CeruleanHouse3Blocks: ; 16
    INCBIN "maps/ceruleanhouse3.blk"

INCBIN "baserom.gbc",$7405c,$6f

Func40CB: ; 40CB
	xor a
	ld [$FFBA],a
	call $3719
	call $4183

	; display the next monster from CreditsMons
	ld hl,$CD3E
	ld c,[hl] ; how many monsters have we displayed so far?
	inc [hl]
	ld b,0
	ld hl,CreditsMons
	add hl,bc ; go that far in the list of monsters and get the next one
	ld a,[hl]
	ld [$CF91],a
	ld [$D0B5],a
	ld hl,$C420
	call $1537
	call $1389
	ld hl,$980C
	call $4164
	xor a
	ld [$FFBA],a
	call $3725
	ld hl,$9800
	call $4164
	ld a,$A7
	ld [$FF4B],a
	ld hl,$9C00
	call $4164
	call $4183
	ld a,$FC
	ld [$FF47],a
	ld bc,7
.next\@
	call $4140
	dec c
	jr nz,.next\@
	ld c,$14
.next2\@
	call $4140
	ld a,[$FF4B]
	sub 8
	ld [$FF4B],a
	dec c
	jr nz,.next2\@
	xor a
	ld [$FFB0],a
	ld a,$C0
	ld [$FF47],a
	ret

CreditsMons: ; 4131
	db VENUSAUR
	db ARBOK
	db RHYHORN
	db FEAROW
	db ABRA
	db GRAVELER
	db HITMONLEE
	db TANGELA
	db STARMIE
	db GYARADOS
	db DITTO
	db OMASTAR
	db VILEPLUME
	db NIDOKING
	db PARASECT

INCBIN "baserom.gbc",$74140,$2C3 - $140

CreditsTextPointers: ; 42C3

	dw CredRed
	dw CredTajiri
	dw CredTaOota
	dw CredMorimoto
	dw CredWatanabe
	dw CredMasuda
	dw CredNisino
	dw CredSugimori
	dw CredNishida
	dw CredMiyamoto
	dw CredKawaguchi
	dw CredIshihara
	dw CredYamauchi
	dw CredZinnai
	dw CredHishida
	dw CredSakai
	dw CredYamaguchi
	dw CredYamamoto
	dw CredTaniguchi
	dw CredNonomura
	dw CredFuziwara
	dw CredMatsusima
	dw CredTomisawa
	dw CredKawamoto
	dw CredKakei
	dw CredTsuchiya
	dw CredTaNakamura
	dw CredYuda
	dw CredMon
	dw CredDirector
	dw CredProgrammers
	dw CredCharDesign
	dw CredMusic
	dw CredSoundEffects
	dw CredGameDesign
	dw CredMonsterDesign
	dw CredGameScene
	dw CredParam
	dw CredMap
	dw CredTest
	dw CredSpecial
	dw CredProducers
	dw CredProducer
	dw CredExecutive
	dw CredTamada
	dw CredSaOota
	dw CredYoshikawa
	dw CredToOota
	dw CredUSStaff
	dw CredUSCoord
	dw CredTilden
	dw CredKawakami
	dw CredHiNakamura
	dw CredGiese
	dw CredOsborne
	dw CredTrans
	dw CredOgasawara
	dw CredIwata
	dw CredIzushi
	dw CredHarada
	dw CredMurakawa
	dw CredFukui
	dw CredClub
	dw CredPAAD

CredRed:
	db "2RED VERSION STAFF@"
CredTajiri:
	db "4SATOSHI TAJIRI@"
CredTaOota:
	db "4TAKENORI OOTA@"
CredMorimoto:
	db "3SHIGEKI MORIMOTO@"
CredWatanabe:
	db "3TETSUYA WATANABE@"
CredMasuda:
	db "4JUNICHI MASUDA@"
CredNisino:
	db "5KOHJI NISINO@"
CredSugimori:
	db "5KEN SUGIMORI@"
CredNishida:
	db "4ATSUKO NISHIDA@"
CredMiyamoto:
	db "3SHIGERU MIYAMOTO@"
CredKawaguchi:
	db "2TAKASHI KAWAGUCHI@"
CredIshihara:
	db "2TSUNEKAZU ISHIHARA@"
CredYamauchi:
	db "3HIROSHI YAMAUCHI@"
CredZinnai:
	db "3HIROYUKI ZINNAI@"
CredHishida:
	db "3TATSUYA HISHIDA@"
CredSakai:
	db "4YASUHIRO SAKAI@"
CredYamaguchi:
	db "3WATARU YAMAGUCHI@"
CredYamamoto:
	db "2KAZUYUKI YAMAMOTO@"
CredTaniguchi:
	db "2RYOHSUKE TANIGUCHI@"
CredNonomura:
	db "2FUMIHIRO NONOMURA@"
CredFuziwara:
	db "3MOTOFUMI FUZIWARA@"
CredMatsusima:
	db "3KENJI MATSUSIMA@"
CredTomisawa:
	db "3AKIHITO TOMISAWA@"
CredKawamoto:
	db "3HIROSHI KAWAMOTO@"
CredKakei:
	db "4AKIYOSHI KAKEI@"
CredTsuchiya:
	db "3KAZUKI TSUCHIYA@"
CredTaNakamura:
	db "4TAKEO NAKAMURA@"
CredYuda:
	db "4MASAMITSU YUDA@"
CredMon:
	db "7#MON@"
CredDirector:
	db "7DIRECTOR@"
CredProgrammers:
	db "5PROGRAMMERS@"
CredCharDesign:
	db "3CHARACTER DESIGN@"
CredMusic:
	db "8MUSIC@"
CredSoundEffects:
	db "4SOUND EFFECTS@"
CredGameDesign:
	db "5GAME DESIGN@"
CredMonsterDesign:
	db "4MONSTER DESIGN@"
CredGameScene:
	db "4GAME SCENARIO@"
CredParam:
	db "2PARAMETRIC DESIGN@"
CredMap:
	db "6MAP DESIGN@"
CredTest:
	db "3PRODUCT TESTING@"
CredSpecial:
	db "4SPECIAL THANKS@"
CredProducers:
	db "6PRODUCERS@"
CredProducer:
	db "6PRODUCER@"
CredExecutive:
	db "2EXECUTIVE PRODUCER@"
CredTamada:
	db "4SOUSUKE TAMADA@"
CredSaOota:
	db "5SATOSHI OOTA@"
CredYoshikawa:
	db "4RENA YOSHIKAWA@"
CredToOota:
	db "4TOMOMICHI OOTA@"
CredUSStaff:
	db "3US VERSION STAFF@"
CredUSCoord:
	db "3US COORDINATION@"
CredTilden:
	db "5GAIL TILDEN@"
CredKawakami:
	db "4NAOKO KAWAKAMI@"
CredHiNakamura:
	db "4HIRO NAKAMURA@"
CredGiese:
	db "4WILLIAM GIESE@"
CredOsborne:
	db "5SARA OSBORNE@"
CredTrans:
	db "3TEXT TRANSLATION@"
CredOgasawara:
	db "4NOB OGASAWARA@"
CredIwata:
	db "5SATORU IWATA@"
CredIzushi:
	db "3TAKEHIRO IZUSHI@"
CredHarada:
	db "3TAKAHIRO HARADA@"
CredMurakawa:
	db "3TERUKI MURAKAWA@"
CredFukui:
	db "5KOHTA FUKUI@"
CredClub:
	db "1NCL SUPER MARIO CLUB@"
CredPAAD:
	db "5PAAD TESTING@"

TheEndGfx: ; 473E
	INCBIN "gfx/theend.2bpp"

INCBIN "baserom.gbc",$747de,$74897 - $747de

ViridianGym_h: ; 0x74897 to 0x748a3 (12 bytes) (id=45)
    db $07 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw ViridianGymBlocks, $49ec, $48a3 ; blocks, texts, scripts
    db $00 ; connections

    dw $4bde ; objects

INCBIN "baserom.gbc",$748a3,$74a69 - $748a3
ViridianGymText1: ; 0x74a69
    db $08 ; asm
    ld a, [$d751]
    bit 1, a
    jr z, .asm_6de66 ; 0x74a6f
    bit 0, a
    jr nz, .asm_9fc95 ; 0x74a73
    call z, $4995
    call $30b6
    jr .asm_6dff7 ; 0x74a7b
.asm_9fc95 ; 0x74a7d
    ld a, $1
    ld [$cc3c], a
    ld hl, $4ad9
    call PrintText
    call $20ef
    ld a, $32
    ld [$cc4d], a
    ld a, $11
    call Predef
    call $2429
    call Delay3
    call $20d1
    jr .asm_6dff7 ; 0x74a9e
.asm_6de66 ; 0x74aa0
    ld hl, $4ace
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $4ad3
    ld de, $4ad3
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $8
    ld [$d05c], a
    ld a, $3
    ld [$d5fb], a
.asm_6dff7 ; 0x74acb
    jp $24d7

INCBIN "baserom.gbc",$74ace,$74af3 - $74ace
ViridianGymText2: ; 0x74af3
    db $08 ; asm
    ld hl, $4a08
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74afd,$74b0c - $74afd
ViridianGymText3: ; 0x74b0c
    db $08 ; asm
    ld hl, $4a14
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b16,$74b25 - $74b16
ViridianGymText4: ; 0x74b25
    db $08 ; asm
    ld hl, $4a20
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b2f,$74b3e - $74b2f
ViridianGymText5: ; 0x74b3e
    db $08 ; asm
    ld hl, $4a2c
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b48,$74b57 - $74b48
ViridianGymText6: ; 0x74b57
    db $08 ; asm
    ld hl, $4a38
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b61,$74b70 - $74b61
ViridianGymText7: ; 0x74b70
    db $08 ; asm
    ld hl, $4a44
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b7a,$74b89 - $74b7a
ViridianGymText8: ; 0x74b89
    db $08 ; asm
    ld hl, $4a50
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74b93,$74ba2 - $74b93
ViridianGymText9: ; 0x74ba2
    db $08 ; asm
    ld hl, $4a5c
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$74bac,$74bbb - $74bac
ViridianGymText10: ; 0x74bbb
    db $08 ; asm
    ld a, [$d751]
    bit 1, a
    jr nz, .asm_1abd1 ; 0x74bc1
    ld hl, $4bd4
    call PrintText
    jr .asm_6064d ; 0x74bc9
.asm_1abd1 ; 0x74bcb
    ld hl, $4bd9
    call PrintText
.asm_6064d ; 0x74bd1
    jp $24d7

INCBIN "baserom.gbc",$74bd4,$a
ViridianGymObject: ; 0x74bde (size=105)
    db $3 ; border tile

    db $2 ; warps
    db $11, $10, $4, $ff
    db $11, $11, $4, $ff

    db $0 ; signs

    db $b ; people
    db SPRITE_GIOVANNI, $1 + 4, $2 + 4, $ff, $d0, $41, GIOVANNI + $C8, $3 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $7 + 4, $c + 4, $ff, $d0, $42, COOLTRAINER_M + $C8, $9 ; trainer
    db SPRITE_HIKER, $b + 4, $b + 4, $ff, $d1, $43, BLACKBELT + $C8, $6 ; trainer
    db SPRITE_ROCKER, $7 + 4, $a + 4, $ff, $d0, $44, TAMER + $C8, $3 ; trainer
    db SPRITE_HIKER, $7 + 4, $3 + 4, $ff, $d2, $45, BLACKBELT + $C8, $7 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $5 + 4, $d + 4, $ff, $d3, $46, COOLTRAINER_M + $C8, $a ; trainer
    db SPRITE_HIKER, $1 + 4, $a + 4, $ff, $d0, $47, BLACKBELT + $C8, $8 ; trainer
    db SPRITE_ROCKER, $10 + 4, $2 + 4, $ff, $d3, $48, TAMER + $C8, $4 ; trainer
    db SPRITE_BLACK_HAIR_BOY_1, $5 + 4, $6 + 4, $ff, $d0, $49, COOLTRAINER_M + $C8, $1 ; trainer
    db SPRITE_GYM_HELPER, $f + 4, $10 + 4, $ff, $d0, $a ; person
	db SPRITE_BALL, $9 + 4, $10 + 4, $ff, $ff, $8b, REVIVE ; item

    ; warp-to
    EVENT_DISP $a, $11, $10
    EVENT_DISP $a, $11, $11

ViridianGymBlocks: ; 90
    INCBIN "maps/viridiangym.blk"

PewterMart_h: ; 0x74ca1 to 0x74cad (12 bytes) (id=56)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw PewterMartBlocks, $4cb6, $4cad ; blocks, texts, scripts
    db $00 ; connections

    dw $4cda ; objects

INCBIN "baserom.gbc",$74cad,$74cbc - $74cad
PewterMartText2: ; 0x74cbc
    db $08 ; asm
    ld hl, $4cc6
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$74cc6,$74ccb - $74cc6
PewterMartText3: ; 0x74ccb
    db $08 ; asm
    ld hl, $4cd5
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$74cd5,$5
PewterMartObject: ; 0x74cda (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $4, $ff
    db $7, $4, $4, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_BUG_CATCHER, $3 + 4, $3 + 4, $fe, $1, $2 ; person
    db SPRITE_BLACK_HAIR_BOY_2, $5 + 4, $5 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

UnknownDungeon1_h: ; 0x74d00 to 0x74d0c (12 bytes) (id=228)
    db $11 ; tileset
    db $09, $0f ; dimensions (y, x)
    dw UnknownDungeon1Blocks, $4d0f, $4d0c ; blocks, texts, scripts
    db $00 ; connections

    dw $4d15 ; objects

INCBIN "baserom.gbc",$74d0c,$74d15 - $74d0c
UnknownDungeon1Object: ; 0x74d15 (size=97)
    db $7d ; border tile

    db $9 ; warps
    db $11, $18, $6, $ff
    db $11, $19, $6, $ff
    db $1, $1b, $0, UNKNOWN_DUNGEON_2
    db $7, $17, $1, UNKNOWN_DUNGEON_2
    db $9, $12, $2, UNKNOWN_DUNGEON_2
    db $1, $7, $3, UNKNOWN_DUNGEON_2
    db $3, $1, $4, UNKNOWN_DUNGEON_2
    db $b, $3, $5, UNKNOWN_DUNGEON_2
    db $6, $0, $0, UNKNOWN_DUNGEON_3

    db $0 ; signs

    db $3 ; people
	db SPRITE_BALL, $d + 4, $7 + 4, $ff, $ff, $81, FULL_RESTORE ; item
	db SPRITE_BALL, $3 + 4, $13 + 4, $ff, $ff, $82, MAX_ELIXER ; item
	db SPRITE_BALL, $0 + 4, $5 + 4, $ff, $ff, $83, NUGGET ; item

    ; warp-to
    EVENT_DISP $f, $11, $18
    EVENT_DISP $f, $11, $19
    EVENT_DISP $f, $1, $1b ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $7, $17 ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $9, $12 ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $1, $7 ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $3, $1 ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $b, $3 ; UNKNOWN_DUNGEON_2
    EVENT_DISP $f, $6, $0 ; UNKNOWN_DUNGEON_3

UnknownDungeon1Blocks: ; 135
    INCBIN "maps/unknowndungeon1.blk"

CeruleanHouse3_h: ; 0x74dfd to 0x74e09 (12 bytes) (id=230)
    db $0d ; tileset
    db $04, $04 ; dimensions (y, x)
    dw CeruleanHouse3Blocks, $4e13, $4e09 ; blocks, texts, scripts
    db $00 ; connections

    dw $4ebe ; objects

INCBIN "baserom.gbc",$74e09,$74ebe - $74e09
CeruleanHouse3Object: ; 0x74ebe (size=34)
    db $c ; border tile

    db $3 ; warps
    db $0, $2, $9, $ff
    db $7, $2, $8, $ff
    db $7, $3, $8, $ff

    db $0 ; signs

    db $1 ; people
    db SPRITE_FAT_BALD_GUY, $3 + 4, $5 + 4, $ff, $d3, $1 ; person

    ; warp-to
    EVENT_DISP $4, $0, $2
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

INCBIN "baserom.gbc",$74ee0,$12c

FuchsiaHouse1_h: ; 0x7500c to 0x75018 (12 bytes) (id=153)
    db $08 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw FuchsiaHouse1Blocks, $501c, $5018 ; blocks, texts, scripts
    db $00 ; connections

    dw $5031 ; objects

INCBIN "baserom.gbc",$75018,$7501c - $75018
FuchsiaHouse1Texts: ; 0x7501c
    dw FuchsiaHouse1Text1, FuchsiaHouse1Text2, FuchsiaHouse1Text3

FuchsiaHouse1Text1: ; 0x75022
    TX_FAR _FuchsiaHouse1Text1
    db $50

FuchsiaHouse1Text2: ; 0x75027
    TX_FAR _FuchsiaHouse1Text2
    db $50

FuchsiaHouse1Text3: ; 0x7502c
    TX_FAR _FuchsiaHouse1Text3
    db $50

FuchsiaHouse1Object: ; 0x75031 (size=38)
    db $a ; border tile

    db $2 ; warps
    db $7, $2, $1, $ff
    db $7, $3, $1, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MOM_GEISHA, $3 + 4, $2 + 4, $ff, $d3, $1 ; person
    db SPRITE_GAMBLER, $2 + 4, $7 + 4, $ff, $d1, $2 ; person
    db SPRITE_BUG_CATCHER, $5 + 4, $5 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3

FuchsiaPokecenter_h: ; 0x75057 to 0x75063 (12 bytes) (id=154)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw FuchsiaPokecenterBlocks, $5069, $5063 ; blocks, texts, scripts
    db $00 ; connections

    dw $507d ; objects

INCBIN "baserom.gbc",$75063,$75072 - $75063

FuchsiaPokecenterText1: ; 0x75071 or 0x75072
    ;TX_FAR _FuchsiaPokecenterText1
    db $17, $87, $63, $27, $50

INCBIN "baserom.gbc",$75077,$6
;db $17, $de, $63, $27, $50, $f6

FuchsiaPokecenterObject: ; 0x7507d (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $2, $ff
    db $7, $4, $2, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_ROCKER, $3 + 4, $2 + 4, $ff, $ff, $2 ; person
    db SPRITE_LASS, $5 + 4, $6 + 4, $fe, $2, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

FuchsiaHouse2_h: ; 0x750a9 to 0x750b5 (12 bytes) (id=155)
    db $14 ; tileset
    db $04, $05 ; dimensions (y, x)
    dw FuchsiaHouse2Blocks, $50b8, $50b5 ; blocks, texts, scripts
    db $00 ; connections

    dw $5180 ; objects

INCBIN "baserom.gbc",$750b5,$750c2 - $750b5
FuchsiaHouse2Text1: ; 0x750c2
    db $08 ; asm
    ld a, [$d78e]
    bit 0, a
    jr nz, .asm_58feb ; 0x750c8
	ld b,GOLD_TEETH
    call $3493
    jr nz, .asm_3f30f ; 0x750cf
    ld a, [$d78e]
    bit 1, a
    jr nz, .asm_60cba ; 0x750d6
    ld hl, $5135
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    ld hl, $513f
    jr nz, .asm_61238 ; 0x750e8
    ld hl, $513a
.asm_61238 ; 0x750ed
    call PrintText
    jr .asm_52039 ; 0x750f0
.asm_3f30f ; 0x750f2
    ld hl, $5144
    call PrintText
    ld a, $40
    ldh [$db], a
    ld b, $5 ; BANK(MyFunction)
    ld hl, $7f37 ; MyFunction
    call Bankswitch
    ld hl, $d78e
    set 1, [hl]
.asm_60cba ; 0x75109
    ld hl, $514e
    call PrintText
    ld bc,(HM_04 << 8) | 1
    call $3e2e
    jr nc, .asm_53b90 ; 0x75115
    ld hl, $5153
    call PrintText
    ld hl, $d78e
    set 0, [hl]
    jr .asm_52039 ; 0x75122
.asm_58feb ; 0x75124
    ld hl, $5159
    call PrintText
    jr .asm_52039 ; 0x7512a
.asm_53b90 ; 0x7512c
    ld hl, $515e
    call PrintText
.asm_52039 ; 0x75132
    jp $24d7

INCBIN "baserom.gbc",$75135,$75163 - $75135
FuchsiaHouse2Text4: ; 0x75163
    db $08 ; asm
    ldh a, [$8c]
    cp $4
    ld hl, $517b
    jr nz, .asm_4c9a2 ; 0x7516b
    ld hl, $5176
.asm_4c9a2 ; 0x75170
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75176,$a
FuchsiaHouse2Object: ; 0x75180 (size=45)
    db $17 ; border tile

    db $2 ; warps
    db $7, $4, $3, $ff
    db $7, $5, $3, $ff

    db $2 ; signs
    db $3, $4, $4 ; FuchsiaHouse2Text4
    db $3, $5, $5 ; FuchsiaHouse2Text5

    db $3 ; people
    db SPRITE_WARDEN, $3 + 4, $2 + 4, $ff, $ff, $1 ; person
	db SPRITE_BALL, $3 + 4, $8 + 4, $ff, $ff, $82, RARE_CANDY ; item
    db SPRITE_BOULDER, $4 + 4, $8 + 4, $ff, $10, $3 ; person

    ; warp-to
    EVENT_DISP $5, $7, $4
    EVENT_DISP $5, $7, $5

FuchsiaHouse2Blocks: ; 20
    INCBIN "maps/fuchsiahouse2.blk"

SafariZoneEntrance_h: ; 0x751c1 to 0x751cd (12 bytes) (id=156)
    db $0c ; tileset
    db $03, $04 ; dimensions (y, x)
    dw SafariZoneEntranceBlocks, $52b9, $51cd ; blocks, texts, scripts
    db $00 ; connections

    dw $53f5 ; objects

INCBIN "baserom.gbc",$751cd,$752c5 - $751cd

SafariZoneEntranceText1: ; 0x752c5
    TX_FAR _SafariZoneEntranceText1
    db $50

INCBIN "baserom.gbc",$752ca,$753ca - $752ca
SafariZoneEntranceText2: ; 0x753ca
    db $08 ; asm
    ld hl, $53e6
    call PrintText
    call $35ec
    ld a, [$cc26]
    and a
    ld hl, $53f0
    jr nz, .asm_278a6 ; 0x753db
    ld hl, $53eb
.asm_278a6 ; 0x753e0
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$753e6,$f
SafariZoneEntranceObject: ; 0x753f5 (size=48)
    db $a ; border tile

    db $4 ; warps
    db $5, $3, $4, $ff
    db $5, $4, $4, $ff
    db $0, $3, $0, SAFARI_ZONE_CENTER
    db $0, $4, $1, SAFARI_ZONE_CENTER

    db $0 ; signs

    db $2 ; people
    db SPRITE_WHITE_PLAYER, $2 + 4, $6 + 4, $ff, $d2, $1 ; person
    db SPRITE_WHITE_PLAYER, $4 + 4, $1 + 4, $ff, $d3, $2 ; person

    ; warp-to
    EVENT_DISP $4, $5, $3
    EVENT_DISP $4, $5, $4
    EVENT_DISP $4, $0, $3 ; SAFARI_ZONE_CENTER
    EVENT_DISP $4, $0, $4 ; SAFARI_ZONE_CENTER

SafariZoneEntranceBlocks: ; 12
    INCBIN "maps/safarizoneentrance.blk"

FuchsiaGym_h: ; 0x75431 to 0x7543d (12 bytes) (id=157)
    db $07 ; tileset
    db $09, $05 ; dimensions (y, x)
    dw FuchsiaGymBlocks, $54d5, $543d ; blocks, texts, scripts
    db $00 ; connections

    dw $5658 ; objects

INCBIN "baserom.gbc",$7543d,$75534 - $7543d
FuchsiaGymText1: ; 0x75534
    db $08 ; asm
    ld a, [$d792]
    bit 1, a
    jr z, .asm_181b6 ; 0x7553a
    bit 0, a
    jr nz, .asm_adc3b ; 0x7553e
    call z, $5497
    call $30b6
    jr .asm_e84c6 ; 0x75546
.asm_adc3b ; 0x75548
    ld hl, $558b
    call PrintText
    jr .asm_e84c6 ; 0x7554e
.asm_181b6 ; 0x75550
    ld hl, $5581
    call PrintText
    ld hl, $d72d
    set 6, [hl]
    set 7, [hl]
    ld hl, $5586
    ld de, $5586
    call $3354
    ldh a, [$8c]
    ld [$cf13], a
    call $336a
    call $32d7
    ld a, $5
    ld [$d05c], a
    xor a
    ldh [$b4], a
    ld a, $3
    ld [$d65b], a
.asm_e84c6 ; 0x7557e
    jp $24d7

INCBIN "baserom.gbc",$75581,$755a4 - $75581
FuchsiaGymText2: ; 0x755a4
    db $08 ; asm
    ld hl, $54eb
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$755ae,$755bd - $755ae
FuchsiaGymText3: ; 0x755bd
    db $08 ; asm
    ld hl, $54f7
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$755c7,$755d6 - $755c7
FuchsiaGymText4: ; 0x755d6
    db $08 ; asm
    ld hl, $5503
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$755e0,$755ef - $755e0
FuchsiaGymText5: ; 0x755ef
    db $08 ; asm
    ld hl, $550f
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$755f9,$75608 - $755f9
FuchsiaGymText6: ; 0x75608
    db $08 ; asm
    ld hl, $551b
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$75612,$75621 - $75612
FuchsiaGymText7: ; 0x75621
    db $08 ; asm
    ld hl, $5527
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$7562b,$7563a - $7562b
FuchsiaGymText8: ; 0x7563a
    db $08 ; asm
    ld a, [$d792]
    bit 1, a
    ld hl, $5653
    jr nz, .asm_50671 ; 0x75643
    ld hl, $564e
.asm_50671 ; 0x75648
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$7564e,$a
FuchsiaGymObject: ; 0x75658 (size=82)
    db $3 ; border tile

    db $2 ; warps
    db $11, $4, $5, $ff
    db $11, $5, $5, $ff

    db $0 ; signs

    db $8 ; people
    db SPRITE_BLACKBELT, $a + 4, $4 + 4, $ff, $d0, $41, KOGA + $C8, $1 ; trainer
    db SPRITE_ROCKER, $d + 4, $8 + 4, $ff, $d0, $42, JUGGLER + $C8, $7 ; trainer
    db SPRITE_ROCKER, $8 + 4, $7 + 4, $ff, $d3, $43, JUGGLER + $C8, $3 ; trainer
    db SPRITE_ROCKER, $c + 4, $1 + 4, $ff, $d0, $44, JUGGLER + $C8, $8 ; trainer
    db SPRITE_ROCKER, $5 + 4, $3 + 4, $ff, $d1, $45, TAMER + $C8, $1 ; trainer
    db SPRITE_ROCKER, $2 + 4, $8 + 4, $ff, $d0, $46, TAMER + $C8, $2 ; trainer
    db SPRITE_ROCKER, $7 + 4, $2 + 4, $ff, $d2, $47, JUGGLER + $C8, $4 ; trainer
    db SPRITE_GYM_HELPER, $f + 4, $7 + 4, $ff, $d0, $8 ; person

    ; warp-to
    EVENT_DISP $5, $11, $4
    EVENT_DISP $5, $11, $5

FuchsiaGymBlocks: ; 45
    INCBIN "maps/fuchsiagym.blk"

FuchsiaMeetingRoom_h: ; 0x756d7 to 0x756e3 (12 bytes) (id=158)
    db $14 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw FuchsiaMeetingRoomBlocks, $56e7, $56e3 ; blocks, texts, scripts
    db $00 ; connections

    dw $56fc ; objects

INCBIN "baserom.gbc",$756e3,$756e7 - $756e3
FuchsiaMeetingRoomTexts: ; 0x756e7
    dw FuchsiaMeetingRoomText1, FuchsiaMeetingRoomText2, FuchsiaMeetingRoomText3

FuchsiaMeetingRoomText1: ; 0x756ed
    TX_FAR _FuchsiaMeetingRoomText1
    db $50

FuchsiaMeetingRoomText2: ; 0x756f2
    TX_FAR _FuchsiaMeetingRoomText2
    db $50

FuchsiaMeetingRoomText3: ; 0x756f7
    TX_FAR _FuchsiaMeetingRoomText3
    db $50

FuchsiaMeetingRoomObject: ; 0x756fc (size=38)
    db $17 ; border tile

    db $2 ; warps
    db $7, $4, $6, $ff
    db $7, $5, $6, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_WHITE_PLAYER, $1 + 4, $4 + 4, $ff, $d0, $1 ; person
    db SPRITE_WHITE_PLAYER, $2 + 4, $0 + 4, $ff, $d1, $2 ; person
    db SPRITE_WHITE_PLAYER, $1 + 4, $a + 4, $ff, $d0, $3 ; person

    ; warp-to
    EVENT_DISP $7, $7, $4
    EVENT_DISP $7, $7, $5

FuchsiaMeetingRoomBlocks: ; 28
    INCBIN "maps/fuchsiameetingroom.blk"

CinnabarGym_h: ; 0x7573e to 0x7574a (12 bytes) (id=166)
    db $16 ; tileset
    db $09, $0a ; dimensions (y, x)
    dw $5b26, $589f, $574a ; blocks, texts, scripts
    db $00 ; connections

    dw $5acc ; objects

INCBIN "baserom.gbc",$7574a,$75939 - $7574a
CinnabarGymText2: ; 0x75939
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 2, a
    jr nz, .asm_46bb4 ; 0x75942
    ld hl, $595f
    call PrintText
    ld hl, $5964
    ld de, $5964
    call $3354
    jp $58b7
.asm_46bb4 ; 0x75956
    ld hl, $5969
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$7595f,$7596e - $7595f
CinnabarGymText3: ; 0x7596e
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 3, a
    jr nz, .asm_4b406 ; 0x75977
    ld hl, $5994
    call PrintText
    ld hl, $5999
    ld de, $5999
    call $3354
    jp $58b7
.asm_4b406 ; 0x7598b
    ld hl, $599e
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75994,$759a3 - $75994
CinnabarGymText4: ; 0x759a3
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 4, a
    jr nz, .asm_c0673 ; 0x759ac
    ld hl, $59c9
    call PrintText
    ld hl, $59ce
    ld de, $59ce
    call $3354
    jp $58b7
.asm_c0673 ; 0x759c0
    ld hl, $59d3
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$759c9,$759d8 - $759c9
CinnabarGymText5: ; 0x759d8
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 5, a
    jr nz, .asm_5cfd7 ; 0x759e1
    ld hl, $59fe
    call PrintText
    ld hl, $5a03
    ld de, $5a03
    call $3354
    jp $58b7
.asm_5cfd7 ; 0x759f5
    ld hl, $5a08
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$759fe,$75a0d - $759fe
CinnabarGymText6: ; 0x75a0d
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 6, a
    jr nz, .asm_776b4 ; 0x75a16
    ld hl, $5a33
    call PrintText
    ld hl, $5a38
    ld de, $5a38
    call $3354
    jp $58b7
.asm_776b4 ; 0x75a2a
    ld hl, $5a3d
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75a33,$75a42 - $75a33
CinnabarGymText7: ; 0x75a42
    db $08 ; asm
    call $57a0
    ld a, [$d79a]
    bit 7, a
    jr nz, .asm_2f755 ; 0x75a4b
    ld hl, $5a68
    call PrintText
    ld hl, $5a6d
    ld de, $5a6d
    call $3354
    jp $58b7
.asm_2f755 ; 0x75a5f
    ld hl, $5a72
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75a68,$75a77 - $75a68
CinnabarGymText8: ; 0x75a77
    db $08 ; asm
    call $57a0
    ld a, [$d79b]
    bit 0, a
    jr nz, .asm_d87be ; 0x75a80
    ld hl, $5a9d
    call PrintText
    ld hl, $5aa2
    ld de, $5aa2
    call $3354
    jp $58b7
.asm_d87be ; 0x75a94
    ld hl, $5aa7
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75a9d,$75aac - $75a9d
CinnabarGymText9: ; 0x75aac
    db $08 ; asm
    ld a, [$d79a]
    bit 1, a
    jr nz, .asm_627d9 ; 0x75ab2
    ld hl, $5ac2
    jr .asm_0b11d ; 0x75ab7
.asm_627d9 ; 0x75ab9
    ld hl, $5ac7
.asm_0b11d ; 0x75abc
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$75ac2,$a
CinnabarGymObject: ; 0x75acc (size=90)
    db $2e ; border tile

    db $2 ; warps
    db $11, $10, $1, $ff
    db $11, $11, $1, $ff

    db $0 ; signs

    db $9 ; people
    db SPRITE_FAT_BALD_GUY, $3 + 4, $3 + 4, $ff, $d0, $41, BLAINE + $C8, $1 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $11 + 4, $ff, $d0, $42, SUPER_NERD + $C8, $9 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $11 + 4, $ff, $d0, $43, BURGLAR + $C8, $4 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $4 + 4, $b + 4, $ff, $d0, $44, SUPER_NERD + $C8, $a ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $b + 4, $ff, $d0, $45, BURGLAR + $C8, $5 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $e + 4, $b + 4, $ff, $d0, $46, SUPER_NERD + $C8, $b ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $e + 4, $3 + 4, $ff, $d0, $47, BURGLAR + $C8, $6 ; trainer
    db SPRITE_BLACK_HAIR_BOY_2, $8 + 4, $3 + 4, $ff, $d0, $48, SUPER_NERD + $C8, $c ; trainer
    db SPRITE_GYM_HELPER, $d + 4, $10 + 4, $ff, $d0, $9 ; person

    ; warp-to
    EVENT_DISP $a, $11, $10
    EVENT_DISP $a, $11, $11

CinnabarGymBlocks: ; 90
    INCBIN "maps/cinnabargym.blk"

Lab1_h: ; 0x75b80 to 0x75b8c (12 bytes) (id=167)
    db $14 ; tileset
    db $04, $09 ; dimensions (y, x)
    dw Lab1Blocks, $5b90, $5b8c ; blocks, texts, scripts
    db $00 ; connections

    dw $5bb3 ; objects

INCBIN "baserom.gbc",$75b8c,$75b90 - $75b8c
Lab1Texts: ; 0x75b90
    dw Lab1Text1, Lab1Text2, Lab1Text3, Lab1Text4, Lab1Text5

Lab1Text1: ; 0x75b9a
    TX_FAR _Lab1Text1
    db $50

Lab1Text2: ; 0x75b9f
    TX_FAR _Lab1Text2
    db $50

Lab1Text3: ; 0x75ba4
    TX_FAR _Lab1Text3
    db $50

Lab1Text4: ; 0x75ba9
    TX_FAR _Lab1Text4
    db $50

Lab1Text5: ; 0x75bae
    TX_FAR _Lab1Text5
    db $50

Lab1Object: ; 0x75bb3 (size=62)
    db $17 ; border tile

    db $5 ; warps
    db $7, $2, $2, $ff
    db $7, $3, $2, $ff
    db $4, $8, $0, CINNABAR_LAB_2
    db $4, $c, $0, CINNABAR_LAB_3
    db $4, $10, $0, CINNABAR_LAB_4

    db $4 ; signs
    db $2, $3, $2 ; Lab1Text2
    db $4, $9, $3 ; Lab1Text3
    db $4, $d, $4 ; Lab1Text4
    db $4, $11, $5 ; Lab1Text5

    db $1 ; people
    db SPRITE_FISHER, $3 + 4, $1 + 4, $ff, $ff, $1 ; person

    ; warp-to
    EVENT_DISP $9, $7, $2
    EVENT_DISP $9, $7, $3
    EVENT_DISP $9, $4, $8 ; CINNABAR_LAB_2
    EVENT_DISP $9, $4, $c ; CINNABAR_LAB_3
    EVENT_DISP $9, $4, $10 ; CINNABAR_LAB_4

Lab1Blocks: ; 36
    INCBIN "maps/lab1.blk"

Lab2_h: ; 0x75c15 to 0x75c21 (12 bytes) (id=168)
    db $14 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw Lab2Blocks, $5c24, $5c21 ; blocks, texts, scripts
    db $00 ; connections

    dw $5c45 ; objects

INCBIN "baserom.gbc",$75c21,$75c2a - $75c21

Lab2Text1: ; 0x75c2a
    TX_FAR _Lab2Text1
    db $50

Lab2Text2: ; 0x75c2f
    db $8
    ld a, $7
    ld [W_WHICHTRADE], a
    jr asm_78552 ; 0x75c35 $6

Lab2Text3:
    db $8
    ld a, $8
    ld [W_WHICHTRADE], a
asm_78552: ; 0x75c3d
    ld a, $54
    call Predef
    jp $24d7

Lab2Object: ; 0x75c45 (size=38)
    db $17 ; border tile

    db $2 ; warps
    db $7, $2, $2, CINNABAR_LAB_1
    db $7, $3, $2, CINNABAR_LAB_1

    db $0 ; signs

    db $3 ; people
    db SPRITE_BLACK_HAIR_BOY_2, $2 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_OLD_PERSON, $4 + 4, $1 + 4, $ff, $ff, $2 ; person
    db SPRITE_FOULARD_WOMAN, $5 + 4, $5 + 4, $ff, $d1, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; CINNABAR_LAB_1
    EVENT_DISP $4, $7, $3 ; CINNABAR_LAB_1

Lab2Blocks: ; 16
    INCBIN "maps/lab2.blk"

Lab3_h: ; 0x75c7b to 0x75c87 (12 bytes) (id=169)
    db $14 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw Lab3Blocks, $5c8a, $5c87 ; blocks, texts, scripts
    db $00 ; connections

    dw $5cec ; objects

INCBIN "baserom.gbc",$75c87,$75c94 - $75c87
Lab3Text1: ; 0x75c94
    db $08 ; asm
    ld a, [$d7a1]
    bit 7, a
    jr nz, .asm_e551a ; 0x75c9a
    ld hl, $5cc8
    call PrintText
    ld bc,(TM_35 << 8) | 1
    call $3e2e
    jr nc, .asm_6c187 ; 0x75ca8
    ld hl, $5ccd
    call PrintText
    ld hl, $d7a1
    set 7, [hl]
    jr .asm_eb896 ; 0x75cb5
.asm_6c187 ; 0x75cb7
    ld hl, $5cd8
    call PrintText
    jr .asm_eb896 ; 0x75cbd
.asm_e551a ; 0x75cbf
    ld hl, $5cd3
    call PrintText
.asm_eb896 ; 0x75cc5
    jp $24d7

INCBIN "baserom.gbc",$75cc8,$15

Lab3Text2: ; 0x75cdd
    TX_FAR _Lab3Text2
    db $50

Lab3Text3: ; 0x75ce2
    TX_FAR _Lab3Text3
    db $50

Lab3Text5: ; 0x75ce7
    TX_FAR _Lab3Text5
    db $50

Lab3Object: ; 0x75cec (size=41)
    db $17 ; border tile

    db $2 ; warps
    db $7, $2, $3, CINNABAR_LAB_1
    db $7, $3, $3, CINNABAR_LAB_1

    db $3 ; signs
    db $4, $0, $3 ; Lab3Text3
    db $4, $1, $4 ; Lab3Text4
    db $1, $2, $5 ; Lab3Text5

    db $2 ; people
    db SPRITE_OAK_AIDE, $2 + 4, $7 + 4, $ff, $d0, $1 ; person
    db SPRITE_OAK_AIDE, $3 + 4, $2 + 4, $fe, $2, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; CINNABAR_LAB_1
    EVENT_DISP $4, $7, $3 ; CINNABAR_LAB_1

Lab3Blocks: ; 16
    INCBIN "maps/lab3.blk"

Lab4_h: ; 0x75d25 to 0x75d31 (12 bytes) (id=170)
    db $14 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw Lab4Blocks, $5d34, $5d31 ; blocks, texts, scripts
    db $00 ; connections

    dw $5df0 ; objects

INCBIN "baserom.gbc",$75d31,$75dda - $75d31
Lab4Text2: ; 0x75dda
    db $08 ; asm
    ld a, $3
    ld [W_WHICHTRADE], a
    ld a, $54
    call Predef
    jp $24d7

INCBIN "baserom.gbc",$75de8,$8
Lab4Object: ; 0x75df0 (size=32)
    db $17 ; border tile

    db $2 ; warps
    db $7, $2, $4, CINNABAR_LAB_1
    db $7, $3, $4, CINNABAR_LAB_1

    db $0 ; signs

    db $2 ; people
    db SPRITE_OAK_AIDE, $2 + 4, $5 + 4, $fe, $2, $1 ; person
    db SPRITE_OAK_AIDE, $6 + 4, $7 + 4, $ff, $d1, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2 ; CINNABAR_LAB_1
    EVENT_DISP $4, $7, $3 ; CINNABAR_LAB_1

Lab4Blocks: ; 16
    INCBIN "maps/lab4.blk"

CinnabarPokecenter_h: ; 0x75e20 to 0x75e2c (12 bytes) (id=171)
    db $06 ; tileset
    db $04, $07 ; dimensions (y, x)
    dw $4030, $5e32, $5e2c ; blocks, texts, scripts
    db $00 ; connections

    dw $5e46 ; objects

INCBIN "baserom.gbc",$75e2c,$75e3b - $75e2c

CinnabarPokecenterText1: ; 0x75e3a
    TX_FAR _CinnabarPokecenterText1

INCBIN "baserom.gbc",$75e3b+4,$75e46-($75e3b+4)

CinnabarPokecenterObject: ; 0x75e46 (size=44)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $3, $ff
    db $7, $4, $3, $ff

    db $0 ; signs

    db $4 ; people
    db SPRITE_NURSE, $1 + 4, $3 + 4, $ff, $d0, $1 ; person
    db SPRITE_LASS, $4 + 4, $9 + 4, $fe, $0, $2 ; person
    db SPRITE_GENTLEMAN, $6 + 4, $2 + 4, $ff, $ff, $3 ; person
    db SPRITE_CABLE_CLUB_WOMAN, $2 + 4, $b + 4, $ff, $d0, $4 ; person

    ; warp-to
    EVENT_DISP $7, $7, $3
    EVENT_DISP $7, $7, $4

CinnabarMart_h: ; 0x75e72 to 0x75e7e (12 bytes) (id=172)
    db $02 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4010, $5e81, $5e7e ; blocks, texts, scripts
    db $00 ; connections

    dw $5e91 ; objects

INCBIN "baserom.gbc",$75e7e,$75e87 - $75e7e

CinnabarMartText2: ; 0x75e87
    TX_FAR _CinnabarMartText2
    db $50

CinnabarMartText3: ; 0x75e8c
    TX_FAR _CinnabarMartText3
    db $50

CinnabarMartObject: ; 0x75e91 (size=38)
    db $0 ; border tile

    db $2 ; warps
    db $7, $3, $4, $ff
    db $7, $4, $4, $ff

    db $0 ; signs

    db $3 ; people
    db SPRITE_MART_GUY, $5 + 4, $0 + 4, $ff, $d3, $1 ; person
    db SPRITE_ERIKA, $2 + 4, $6 + 4, $ff, $ff, $2 ; person
    db SPRITE_OAK_AIDE, $4 + 4, $3 + 4, $ff, $ff, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $7, $4

CopycatsHouseF1_h: ; 0x75eb7 to 0x75ec3 (12 bytes) (id=175)
    db $01 ; tileset
    db $04, $04 ; dimensions (y, x)
    dw $4000, $5ec6, $5ec3 ; blocks, texts, scripts
    db $00 ; connections

    dw $5ee3 ; objects

INCBIN "baserom.gbc",$75ec3,$75ec6 - $75ec3
CopycatsHouseF1Texts: ; 0x75ec6
    dw CopycatsHouseF1Text1, CopycatsHouseF1Text2, CopycatsHouseF1Text3

CopycatsHouseF1Text1: ; 0x75ecc
    TX_FAR _CopycatsHouseF1Text1
    db $50

CopycatsHouseF1Text2: ; 0x75ed1
    TX_FAR _CopycatsHouseF1Text2
    db $50

CopycatsHouseF1Text3: ; 0x75ed6
    TX_FAR _CopycatsHouseF1Text3
    db $8
    ld a, $28
    call $13d0
    jp $24d7

CopycatsHouseF1Object: ; 0x75ee3 (size=46)
    db $a ; border tile

    db $3 ; warps
    db $7, $2, $0, $ff
    db $7, $3, $0, $ff
    db $1, $7, $0, COPYCATS_HOUSE_2F

    db $0 ; signs

    db $3 ; people
    db SPRITE_MOM_GEISHA, $2 + 4, $2 + 4, $ff, $d0, $1 ; person
    db SPRITE_FAT_BALD_GUY, $4 + 4, $5 + 4, $ff, $d2, $2 ; person
    db SPRITE_CLEFAIRY, $4 + 4, $1 + 4, $fe, $1, $3 ; person

    ; warp-to
    EVENT_DISP $4, $7, $2
    EVENT_DISP $4, $7, $3
    EVENT_DISP $4, $1, $7 ; COPYCATS_HOUSE_2F

INCBIN "baserom.gbc",$75f11,$760e0 - $75f11
GaryText1: ; 0x760e0
    db $08 ; asm
    ld a, [$d867]
    bit 1, a
    ld hl, $60f4
    jr z, .asm_17e9f ; 0x760e9
    ld hl, $6103
.asm_17e9f ; 0x760ee
    call PrintText
    jp $24d7

INCBIN "baserom.gbc",$760f4,$14

GaryText2: ; 0x76108
    TX_FAR _GaryText2
    db $50

INCBIN "baserom.gbc",$7610d,$22
GaryObject: ; 0x7612f (size=48)
    db $3 ; border tile

    db $4 ; warps
    db $7, $3, $1, LANCES_ROOM
    db $7, $4, $2, LANCES_ROOM
    db $0, $3, $0, HALL_OF_FAME
    db $0, $4, $0, HALL_OF_FAME

    db $0 ; signs

    db $2 ; people
    db SPRITE_BLUE, $2 + 4, $4 + 4, $ff, $d0, $1 ; person
    db SPRITE_OAK, $7 + 4, $3 + 4, $ff, $d1, $2 ; person

    ; warp-to
    EVENT_DISP $4, $7, $3 ; LANCES_ROOM
    EVENT_DISP $4, $7, $4 ; LANCES_ROOM
    EVENT_DISP $4, $0, $3 ; HALL_OF_FAME
    EVENT_DISP $4, $0, $4 ; HALL_OF_FAME

GaryBlocks: ; 16
    INCBIN "maps/gary.blk"

Loreli_h: ; 0x7616f to 0x7617b (12 bytes) (id=245)
    db $07 ; tileset
    db $06, $05 ; dimensions (y, x)
    dw LoreliBlocks, $6251, $617b ; blocks, texts, scripts
    db $00 ; connections

    dw $6280 ; objects

INCBIN "baserom.gbc",$7617b,$76262 - $7617b
LoreliText1: ; 0x76262
    db $08 ; asm
    ld hl, $6255
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$7626c,$14
LoreliObject: ; 0x76280 (size=44)
    db $3 ; border tile

    db $4 ; warps
    db $b, $4, $2, INDIGO_PLATEAU_LOBBY
    db $b, $5, $2, INDIGO_PLATEAU_LOBBY
    db $0, $4, $0, BRUNOS_ROOM
    db $0, $5, $1, BRUNOS_ROOM

    db $0 ; signs

    db $1 ; people
    db SPRITE_LORELEI, $2 + 4, $5 + 4, $ff, $d0, $41, LORELEI + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $5, $b, $4 ; INDIGO_PLATEAU_LOBBY
    EVENT_DISP $5, $b, $5 ; INDIGO_PLATEAU_LOBBY
    EVENT_DISP $5, $0, $4 ; BRUNOS_ROOM
    EVENT_DISP $5, $0, $5 ; BRUNOS_ROOM

LoreliBlocks: ; 30
    INCBIN "maps/loreli.blk"

Bruno_h: ; 0x762ca to 0x762d6 (12 bytes) (id=246)
    db $07 ; tileset
    db $06, $05 ; dimensions (y, x)
    dw BrunoBlocks, $63a8, $62d6 ; blocks, texts, scripts
    db $00 ; connections

    dw $63d7 ; objects

INCBIN "baserom.gbc",$762d6,$763b9 - $762d6
BrunoText1: ; 0x763b9
    db $08 ; asm
    ld hl, $63ac
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$763c3,$14
BrunoObject: ; 0x763d7 (size=44)
    db $3 ; border tile

    db $4 ; warps
    db $b, $4, $2, LORELEIS_ROOM
    db $b, $5, $3, LORELEIS_ROOM
    db $0, $4, $0, AGATHAS_ROOM
    db $0, $5, $1, AGATHAS_ROOM

    db $0 ; signs

    db $1 ; people
    db SPRITE_BRUNO, $2 + 4, $5 + 4, $ff, $d0, $41, BRUNO + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $5, $b, $4 ; LORELEIS_ROOM
    EVENT_DISP $5, $b, $5 ; LORELEIS_ROOM
    EVENT_DISP $5, $0, $4 ; AGATHAS_ROOM
    EVENT_DISP $5, $0, $5 ; AGATHAS_ROOM

BrunoBlocks: ; 30
    INCBIN "maps/bruno.blk"

Agatha_h: ; 0x76421 to 0x7642d (12 bytes) (id=247)
    db $0f ; tileset
    db $06, $05 ; dimensions (y, x)
    dw AgathaBlocks, $6505, $642d ; blocks, texts, scripts
    db $00 ; connections

    dw $6534 ; objects

INCBIN "baserom.gbc",$7642d,$76516 - $7642d
AgathaText1: ; 0x76516
    db $08 ; asm
    ld hl, $6509
    call LoadTrainerHeader
    jp $24d7

INCBIN "baserom.gbc",$76520,$14
AgathaObject: ; 0x76534 (size=44)
    db $0 ; border tile

    db $4 ; warps
    db $b, $4, $2, BRUNOS_ROOM
    db $b, $5, $3, BRUNOS_ROOM
    db $0, $4, $0, LANCES_ROOM
    db $0, $5, $0, LANCES_ROOM

    db $0 ; signs

    db $1 ; people
    db SPRITE_AGATHA, $2 + 4, $5 + 4, $ff, $d0, $41, AGATHA + $C8, $1 ; trainer

    ; warp-to
    EVENT_DISP $5, $b, $4 ; BRUNOS_ROOM
    EVENT_DISP $5, $b, $5 ; BRUNOS_ROOM
    EVENT_DISP $5, $0, $4 ; LANCES_ROOM
    EVENT_DISP $5, $0, $5 ; LANCES_ROOM

AgathaBlocks: ; 30
    INCBIN "maps/agatha.blk"
INCBIN "baserom.gbc",$7657e,$1a82

SECTION "bank1E",DATA,BANK[$1E]
INCBIN "baserom.gbc",$78000,$F1

PlayAnimation: ; 40F1
	xor a
	ld [$FF8B],a
	ld [$D08B],a
	ld a,[$D07C] ; get animation number
	dec a
	ld l,a
	ld h,0
	add hl,hl
	ld de,$607D
	add hl,de
	ld a,[hli]
	ld h,[hl]
	ld l,a
.next7\@
	ld a,[hli]
	cp a,$FF
	jr z,.AnimationOver\@
	cp a,$C0 ; is this animation for a monster onscreen?
	jr c,.next2\@
	ld c,a
	ld de,$50DA
.next4\@
	ld a,[de]
	cp c
	jr z,.next3\@
	inc de
	inc de
	inc de
	jr .next4\@
.next3\@
	ld a,[hli]
	cp a,$FF
	jr z,.next5\@
	ld [$CF07],a
	push hl
	push de
	call $586F
	call $23B1
	pop de
	pop hl
.next5\@
	push hl
	inc de
	ld a,[de]
	ld l,a
	inc de
	ld a,[de]
	ld h,a
	ld de,.next6\@
	push de
	jp [hl]
.next2\@
	ld c,a
	and a,$3F
	ld [$D086],a
	xor a
	sla c
	rla
	sla c
	rla
	ld [$D09F],a
	ld a,[hli]
	ld [$CF07],a
	ld a,[hli]
	ld c,l
	ld b,h
	ld l,a
	ld h,0
	add hl,hl
	ld de,$676D
	add hl,de
	ld a,l
	ld [$D094],a
	ld a,h
	ld [$D095],a
	ld l,c
	ld h,b
	push hl
	ld a,[rOBP0]
	push af
	ld a,[$CC79]
	ld [rOBP0],a
	call $41D2
	call $417C
	call RealPlayAnimation
	pop af
	ld [rOBP0],a
.next6\@
	pop hl
	jr .next7\@
.AnimationOver\@ ; 417B
	ret

INCBIN "baserom.gbc",$7817C,$78D5E - $7817C

AttackAnimation: ; 4D5E
	push hl
	push de
	push bc
	push af
	call $3748
	call $4E23
	ld a,[$D07C]
	and a
	jr z,.AnimationFinished\@

	; if throwing a Poké Ball, skip the regular animation code
	cp a,TOSS_ANIM
	jr nz,.AttackAnimation\@
	ld de,.AnimationFinished\@
	push de
	jp TossBallAnimation

.AttackAnimation\@
	; check if battle animations are disabled in the options
	ld a,[$D355]
	bit 7,a
	jr nz,.AnimationsDisabled\@
	call ShareAttackAnimations
	call PlayAnimation
	jr .next4\@
.AnimationsDisabled\@
	ld c,30
	call DelayFrames
.next4\@
	call $4DBD ; reload pic and flash the pic in and out (to show damage)
.AnimationFinished\@
	call $3748
	xor a
	ld [$D096],a
	ld [$D09B],a
	ld [$D08B],a
	dec a
	ld [$CF07],a
	pop af
	pop bc
	pop de
	pop hl
	ret

ShareAttackAnimations: ; 4DA6
; some moves just reuse animations from status conditions
	ld a,[H_WHOSETURN]
	and a
	ret z

	; opponent’s turn

	ld a,[$D07C]

	cp a,AMNESIA
	ld b,CONF_ANIM
	jr z,.Replace\@

	cp a,REST
	ld b,SLP_ANIM
	ret nz

.Replace\@
	ld a,b
	ld [$D07C],a
	ret

Function4DBD: ; 4DBD
	ld a,[$CC5B]
	and a
	ret z
	dec a
	add a
	ld c,a
	ld b,0
	ld hl,Pointer4DCF
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]

Pointer4DCF: ; 4DCF
	dw $4DDB,$4DE3,$4DEB,$4DF0,$4DF6,$4DFE

INCBIN "baserom.gbc",$78DDB,$78E53-$78DDB
RealPlayAnimation: ; 4E53
	ld a,[$CF07] ; get animation # − 1
	cp a,$FF
	jr z,.Next4E60
	call $586F
	call $23B1 ; play sound effect
.Next4E60
	ld hl,$C300
	ld a,l
	ld [$D09D],a
	ld a,h
	ld [$D09C],a
	ld a,[$D097]
	ld h,a
	ld a,[$D096]
	ld l,a
	push hl
	ld c,[hl]
	ld b,0
	ld hl,PointerTable6F74
	add hl,bc
	add hl,bc
	ld a,[hli]
	ld c,a
	ld a,[hli]
	ld b,a
	pop hl
	inc hl
	push hl
	ld e,[hl]
	ld d,0
	ld hl,$7C85
	add hl,de
	add hl,de
	ld a,[hli]
	ld [$D082],a
	ld a,[hl]
	ld [$D081],a
	pop hl
	inc hl
	ld a,[hl]
	ld [$D09E],a
	call $4000
	call $4ED7
	ld a,[$D087]
	dec a
	ld [$D087],a
	ret z
	ld a,[$D097]
	ld h,a
	ld a,[$D096]
	ld l,a
	ld a,[$D08B]
	cp a,4
	ld bc,3
	jr nz,.Next4EBC
	ld bc,$FFFD
.Next4EBC
	add hl,bc
	ld a,h
	ld [$D097],a
	ld a,l
	ld [$D096],a
	jp $4E73

INCBIN "baserom.gbc",$78EC8,$7986F - $78EC8

Func586F: ; 586F
	ld hl,MoveSoundTable
	ld e,a
	ld d,0
	add hl,de
	add hl,de
	add hl,de
	ld a,[hli]
	ld b,a
	call IsCryMove
	jr nc,.NotCryMove
	ld a,[H_WHOSETURN]
	and a
	jr nz,.next\@
	ld a,[$D014] ; get number of current monster
	jr .Continue\@
.next\@
	ld a,[$CFE5]
.Continue\@
	push hl
	call $13D9
	ld b,a
	pop hl
	ld a,[$C0F1]
	add [hl]
	ld [$C0F1],a
	inc hl
	ld a,[$C0F2]
	add [hl]
	ld [$C0F2],a
	jr .done\@
.NotCryMove
	ld a,[hli]
	ld [$C0F1],a
	ld a,[hli]
	ld [$C0F2],a
.done\@
	ld a,b
	ret
IsCryMove:
; set carry if the attack animation involves playing a monster cry
	ld a,[$D07C]
	cp a,GROWL
	jr z,.CryMove
	cp a,ROAR
	jr z,.CryMove
	and a ; clear carry
	ret
.CryMove
	scf
	ret

MoveSoundTable:
	db $a0,$00,$80
	db $a2,$10,$80
	db $b3,$00,$80
	db $a1,$01,$80
	db $a3,$00,$40
	db $e9,$00,$ff
	db $a3,$10,$60
	db $a3,$20,$80
	db $a3,$00,$a0
	db $a6,$00,$80
	db $a5,$20,$40
	db $a5,$00,$80
	db $a4,$00,$a0
	db $a7,$10,$c0
	db $a7,$00,$a0
	db $a8,$00,$c0
	db $a8,$10,$a0
	db $a9,$00,$e0
	db $a7,$20,$c0
	db $aa,$00,$80
	db $b9,$00,$80
	db $ab,$01,$80
	db $b7,$00,$80
	db $ad,$f0,$40
	db $b0,$00,$80
	db $ad,$00,$80
	db $b8,$10,$80
	db $b1,$01,$a0
	db $ae,$00,$80
	db $b4,$00,$60
	db $b4,$01,$40
	db $b6,$00,$a0
	db $b0,$10,$a0
	db $b7,$00,$c0
	db $aa,$10,$60
	db $b0,$00,$a0
	db $b9,$11,$c0
	db $b0,$20,$c0
	db $b8,$00,$80
	db $b1,$00,$80
	db $b1,$20,$c0
	db $af,$00,$80
	db $db,$ff,$40
	db $b4,$00,$80
	db $a1,$00,$c0
	db $a1,$00,$40
	db $e4,$00,$80
	db $bf,$40,$60
	db $bf,$00,$80
	db $bf,$ff,$40
	db $c7,$80,$c0
	db $af,$10,$a0
	db $af,$21,$e0
	db $c5,$00,$80
	db $bb,$20,$60
	db $c7,$00,$80
	db $cc,$00,$80
	db $c2,$40,$80
	db $c5,$f0,$e0
	db $cf,$00,$80
	db $c7,$f0,$60
	db $c2,$00,$80
	db $e6,$00,$80
	db $9d,$01,$a0
	db $a9,$f0,$20
	db $ba,$01,$c0
	db $ba,$00,$80
	db $b0,$00,$e0
	db $be,$01,$60
	db $be,$20,$40
	db $bb,$00,$80
	db $bb,$40,$c0
	db $b1,$03,$60
	db $bd,$11,$e0
	db $a8,$20,$e0
	db $d2,$00,$80
	db $b2,$00,$80
	db $b2,$11,$a0
	db $b2,$01,$c0
	db $a9,$14,$c0
	db $b1,$02,$a0
	db $c5,$f0,$80
	db $c5,$20,$c0
	db $d5,$00,$20
	db $d5,$20,$80
	db $d2,$12,$60
	db $be,$00,$80
	db $aa,$01,$e0
	db $c5,$0f,$e0
	db $c5,$11,$20
	db $a6,$10,$40
	db $a5,$10,$c0
	db $aa,$00,$20
	db $d8,$00,$80
	db $e4,$11,$18
	db $9f,$20,$c0
	db $9e,$20,$c0
	db $bd,$00,$10
	db $be,$f0,$20
	db $df,$f0,$c0
	db $a7,$f0,$e0
	db $9f,$f0,$40
	db $db,$00,$80
	db $df,$80,$40
	db $df,$00,$80
	db $aa,$11,$20
	db $aa,$22,$10
	db $b1,$f1,$ff
	db $a9,$f1,$ff
	db $aa,$33,$30
	db $dd,$40,$c0
	db $a4,$20,$20
	db $a4,$f0,$10
	db $a5,$f8,$10
	db $a7,$f0,$10
	db $bd,$00,$80
	db $ae,$00,$c0
	db $dd,$c0,$ff
	db $9f,$f2,$20
	db $e1,$00,$80
	db $e1,$00,$40
	db $9f,$00,$40
	db $a7,$10,$ff
	db $c7,$20,$20
	db $dd,$00,$80
	db $c5,$1f,$20
	db $bd,$2f,$80
	db $a5,$1f,$ff
	db $ca,$1f,$60
	db $be,$1e,$20
	db $be,$1f,$18
	db $aa,$0f,$80
	db $9f,$f8,$10
	db $9e,$18,$20
	db $dd,$08,$40
	db $ad,$01,$e0
	db $a7,$09,$ff
	db $e4,$42,$01
	db $b2,$00,$ff
	db $dd,$08,$e0
	db $bb,$00,$80
	db $9f,$88,$10
	db $bd,$48,$ff
	db $9e,$ff,$ff
	db $bb,$ff,$10
	db $9e,$ff,$04
	db $b2,$01,$ff
	db $a9,$f8,$ff
	db $a2,$f0,$f0
	db $a5,$08,$10
	db $a3,$f0,$ff
	db $b0,$f0,$ff
	db $e1,$10,$ff
	db $a4,$f0,$20
	db $ca,$f0,$60
	db $b8,$12,$10
	db $e6,$f0,$20
	db $b4,$12,$ff
	db $db,$80,$04
	db $df,$f0,$10
	db $c5,$f8,$ff
	db $be,$f0,$ff
	db $a7,$01,$ff
	db $cc,$d8,$04
	db $a1,$00,$80
	db $a1,$00,$80

INCBIN "baserom.gbc",$79AAE,$79E16 - $79AAE

TossBallAnimation: ; 5E16
	ld a,[W_ISINBATTLE]
	cp a,2
	jr z,.BlockBall\@ ; if in trainer battle, play different animation
	ld a,[$D11E]
	ld b,a

	; upper nybble: how many animations (from PokeBallAnimations) to play
	; this will be 4 for successful capture, 6 for breakout
	and a,$F0
	swap a
	ld c,a

	; lower nybble: number of shakes
	; store these for later
	ld a,b
	and a,$F
	ld [$CD3D],a

	ld hl,.PokeBallAnimations
	; choose which toss animation to use
	ld a,[$CF91]
	cp a,POKE_BALL
	ld b,TOSS_ANIM
	jr z,.done\@
	cp a,GREAT_BALL
	ld b,GREATTOSS_ANIM
	jr z,.done\@
	ld b,ULTRATOSS_ANIM
.done\@
	ld a,b
.PlayNextAnimation\@
	ld [$D07C],a
	push bc
	push hl
	call PlayAnimation
	pop hl
	ld a,[hli]
	pop bc
	dec c
	jr nz,.PlayNextAnimation\@
	ret

.PokeBallAnimations: ; 5E50
; sequence of animations that make up the Poké Ball toss
	db POOF_ANIM,HIDEPIC_ANIM,$C2,POOF_ANIM,SHOWPIC_ANIM

.BlockBall\@ ; 5E55
	ld a,$C1
	ld [$D07C],a
	call PlayAnimation
	ld a,$95
	call $23B1 ; play sound effect
	ld a,BLOCKBALL_ANIM
	ld [$D07C],a
	jp PlayAnimation

INCBIN "baserom.gbc",$79E6A,$7AF74 - $79E6A

PointerTable6F74: ; 6F74
	dw $7de7
	dw $7068
	dw $708d
	dw $70ce
	dw $70df
	dw $70f0
	dw $7101
	dw $7132
	dw $7173
	dw $71b4
	dw $71e5
	dw $7216
	dw $7227
	dw $7238
	dw $7259
	dw $726a
	dw $727b
	dw $729c
	dw $72bd
	dw $72ca
	dw $72db
	dw $72fc
	dw $732d
	dw $734e
	dw $735f
	dw $7364
	dw $736d
	dw $7376
	dw $737f
	dw $7388
	dw $7391
	dw $73ab
	dw $73b4
	dw $73cd
	dw $73fe
	dw $744b
	dw $745c
	dw $7465
	dw $7496
	dw $74a7
	dw $74bc
	dw $74d5
	dw $74e6
	dw $74f7
	dw $7500
	dw $7505
	dw $7526
	dw $7547
	dw $7558
	dw $7569
	dw $756e
	dw $758b
	dw $75a8
	dw $75ad
	dw $75c6
	dw $75d7
	dw $75e8
	dw $75f9
	dw $760a
	dw $761b
	dw $7630
	dw $7649
	dw $7666
	dw $7687
	dw $76a8
	dw $76b5
	dw $76c6
	dw $76f3
	dw $7720
	dw $7731
	dw $7742
	dw $7753
	dw $7764
	dw $7775
	dw $785a
	dw $786b
	dw $787c
	dw $788d
	dw $789e
	dw $78bf
	dw $78f0
	dw $7911
	dw $7932
	dw $7943
	dw $7950
	dw $7961
	dw $796e
	dw $7987
	dw $79ac
	dw $79c9
	dw $79ce
	dw $79ff
	dw $7a10
	dw $7a31
	dw $7a5e
	dw $7a9b
	dw $7aac
	dw $7acd
	dw $7afe
	dw $7b3f
	dw $7b58
	dw $7b71
	dw $7b8a
	dw $7b93
	dw $7b98
	dw $7ba9
	dw $7bae
	dw $7bcf
	dw $7bf0
	dw $7c11
	dw $7c1a
	dw $7c2b
	dw $7c3c
	dw $77b6
	dw $77f7
	dw $7828
	dw $7849
	dw $739a
	dw $7c4d
	dw $7c6a
	dw $7c7b
	dw $7c80

INCBIN "baserom.gbc",$7B068,$7C000 - $7B068

SECTION "bank1F",DATA,BANK[$1F]
INCBIN "baserom.gbc",$7C000,$4000

SECTION "bank20",DATA,BANK[$20]
INCBIN "baserom.gbc",$80000,$800b1 - $80000

_VictoryRoad3Text10:
_VictoryRoad3Text9:
_VictoryRoad3Text8:
_VictoryRoad3Text7:
_VictoryRoad2Text13:
_VictoryRoad2Text12:
_VictoryRoad2Text11:
_SeafoamIslands1Text2:
_SeafoamIslands1Text1:
_SeafoamIslands5Text2:
_SeafoamIslands5Text1:
_SeafoamIslands4Text6:
_SeafoamIslands4Text5:
_SeafoamIslands4Text4:
_SeafoamIslands4Text3:
_SeafoamIslands4Text2:
_SeafoamIslands4Text1:
_SeafoamIslands3Text2:
_SeafoamIslands3Text1:
_SeafoamIslands2Text2:
_SeafoamIslands2Text1:
_FuchsiaHouse2Text3:
_VictoryRoad1Text7:
_VictoryRoad1Text6:
_VictoryRoad1Text5: ; 0x800b1
    db $0, "This requires", $4f
    db "STRENGTH to move!", $57

_SaffronCityText19:
_CinnabarIslandText4:
_FuchsiaCityText14:
_VermilionCityText9:
_LavenderTownText6:
_CeruleanCityText14:
_PewterCityText8:
_ViridianCityText11: ; 0x800d2
    db $0, "All your item", $4f
    db "needs fulfilled!", $55
    db "#MON MART", $57

_ViridianCityText12: ; 0x800fc
    db $0, "Heal Your #MON!", $4f
    db "#MON CENTER", $57

INCBIN "baserom.gbc",$80119,$8031d - $80119

_ViridianForestText1: ; 0x8031d
    db $0, "I came here with", $4f
    db "some friends!", $51
    db "They're out for", $4f
    db "#MON fights!", $57

INCBIN "baserom.gbc",$80359,$804c7 - $80359

_ViridianForestText8: ; 0x804c7
    db $0, "I ran out of #", $4f
    db "BALLs to catch", $55
    db "#MON with!", $51
    db "You should carry", $4f
    db "extras!", $57

_ViridianForestText9: ; 0x8050a
    db $0, "TRAINER TIPS", $51
    db "If you want to", $4f
    db "avoid battles,", $55
    db "stay away from", $55
    db "grassy areas!", $57

_ViridianForestText10: ; 0x80553
    db $0, "For poison, use", $4f
    db "ANTIDOTE! Get it", $55
    db "at #MON MARTs!", $57

_ViridianForestText11: ; 0x80584
    db $0, "TRAINER TIPS", $51
    db "Contact PROF.OAK", $4f
    db "via PC to get", $55
    db "your #DEX", $55
    db "evaluated!", $57

_ViridianForestText12: ; 0x805c6
    db $0, "TRAINER TIPS", $51
    db "No stealing of", $4f
    db "#MON from", $55
    db "other trainers!", $55
    db "Catch only wild", $55
    db "#MON!", $57

_ViridianForestText13: ; 0x80613
    db $0, "TRAINER TIPS", $51
    db "Weaken #MON", $4f
    db "before attempting", $55
    db "capture!", $51
    db "When healthy,", $4f
    db "they may escape!", $57

_ViridianForestText14: ; 0x80667
    db $0, "LEAVING", $4f
    db "VIRIDIAN FOREST", $55
    db "PEWTER CITY AHEAD", $57

INCBIN "baserom.gbc",$80692,$8093a - $80692

_MtMoon1Text14: ; 0x8093a
    db $0, "Beware! ZUBAT is", $4f
    db "a blood sucker!", $57

INCBIN "baserom.gbc",$8095c,$80c70 - $8095c

_SSAnne1Text1: ; 0x80c70
    db $0, "Bonjour!", $4f
    db "I am le waiter on", $55
    db "this ship!", $51
    db "I will be happy", $4f
    db "to serve you any-", $55
    db "thing you please!", $51
    db "Ah! Le strong", $4f
    db "silent type!", $57

_SSAnne1Text2: ; 0x80ce6
    db $0, "The passengers", $4f
    db "are restless!", $51
    db "You might be", $4f
    db "challenged by the", $55
    db "more bored ones!", $57

_SSAnne2Text1: ; 0x80d34
    db $0, "This ship, she is", $4f
    db "a luxury liner", $55
    db "for trainers!", $51
    db "At every port, we", $4f
    db "hold parties with", $55
    db "invited trainers!", $57

INCBIN "baserom.gbc",$80d9a,$80f4b - $80d9a

_SSAnne3Text1: ; 0x80f4b
    db $0, "Our CAPTAIN is a", $4f
    db "sword master!", $51
    db "He even teaches", $4f
    db "CUT to #MON!", $57

_SSAnne5Text1: ; 0x80f88
    db $0, "The party's over.", $4f
    db "The ship will be", $55
    db "departing soon.", $57

_SSAnne5Text2: ; 0x80fbb
    db $0, "Scrubbing decks", $4f
    db "is hard work!", $57

_SSAnne5Text3: ; 0x80fda
    db $0, "Urf. I feel ill.", $51
    db "I stepped out to", $4f
    db "get some air.", $57

INCBIN "baserom.gbc",$8100b,$810e5 - $8100b

_SSAnne6Text1: ; 0x810e5
    db $0, "You, mon petit!", $4f
    db "We're busy here!", $55
    db "Out of the way!", $57

_SSAnne6Text2: ; 0x81116
    db $0, "I saw an odd ball", $4f
    db "in the trash.", $57

_SSAnne6Text3: ; 0x81137
    db $0, "I'm so busy I'm", $4f
    db "getting dizzy!", $57

_SSAnne6Text4: ; 0x81155
    db $0, "Hum-de-hum-de-", $4f
    db "ho...", $51
    db "I peel spuds", $4f
    db "every day!", $55
    db "Hum-hum...", $57

_SSAnne6Text5: ; 0x8118e
    db $0, "Did you hear about", $4f
    db "SNORLAX?", $51
    db "All it does is", $4f
    db "eat and sleep!", $57

_SSAnne6Text6: ; 0x811c9
    db $0, "Snivel...Sniff...", $51
    db "I only get to", $4f
    db "peel onions...", $55
    db "Snivel...", $57

INCBIN "baserom.gbc",$81203,$81480 - $81203

_SSAnne7Text2: ; 0x81480
    db $0, "Yuck! Shouldn't", $4f
    db "have looked!", $57

_SSAnne7Text3: ; 0x8149d
    db $0, "How to Conquer", $4f
    db "Seasickness...", $55
    db "The CAPTAIN's", $55
    db "reading this!", $57

_SSAnne8Text8: ; 0x814d7
    db $0, "WIGGLYTUFF: Puup", $4f
    db "pupuu!@@"

INCBIN "baserom.gbc",$814f1,$1d6

_SSAnne8Text5: ; 0x816c7
    db $0, "Waiter, I would", $4f
    db "like a cherry pie", $55
    db "please!", $57

_SSAnne8Text6: ; 0x816f2
    db $0, "A cruise is so", $4f
    db "elegant yet cozy!", $57

_SSAnne8Text7: ; 0x81714
    db $0, "I always travel", $4f
    db "with WIGGLYTUFF!", $57

_SSAnne8Text9: ; 0x81736
    db $0, "We are cruising", $4f
    db "around the world.", $57

_SSAnne8Text11: ; 0x81759
    db $0, "Ssh! I'm a GLOBAL", $4f
    db "POLICE agent!", $51
    db "I'm on the trail", $4f
    db "of TEAM ROCKET!", $57

INCBIN "baserom.gbc",$81799,$81aaa - $81799

_SSAnne10Text8: ; 0x81aaa
    db $0, "MACHOKE: Gwoh!", $4f
    db "Goggoh!@@"

INCBIN "baserom.gbc",$81ac3,$289

_SSAnne10Text7: ; 0x81d4c
    db $0, "My buddy, MACHOKE,", $4f
    db "is super strong!", $51
    db "He has enough", $4f
    db "STRENGTH to move", $55
    db "big rocks!", $57

INCBIN "baserom.gbc",$81d9b,$2265

SECTION "bank21",DATA,BANK[$21]

INCBIN "baserom.gbc",$84000,$840a4 - $84000

_SilphCo5Text9: ; 0x840a4
    db $0, "It's a #MON", $4f
    db "REPORT!", $51
    db "#MON LAB", $4f
    db "created PORYGON,", $55
    db "the first virtual", $55
    db "reality #MON.", $57

_SilphCo5Text10: ; 0x840f2
    db $0, "It's a #MON", $4f
    db "REPORT!", $51
    db "Over 160 #MON", $4f
    db "techniques have", $55
    db "been confirmed.", $57

_SilphCo5Text11: ; 0x84134
    db $0, "It's a #MON", $4f
    db "REPORT!", $51
    db "4 #MON evolve", $4f
    db "only when traded", $55
    db "by link-cable.", $57

INCBIN "baserom.gbc",$84176,$8502f - $84176

_SilphCo11Text2: ; 0x8502f
    db $0, "SECRETARY: Thank", $4f
    db "you for rescuing", $55
    db "all of us!", $51
    db "We admire your", $4f
    db "courage.", $57

_SilphCo11Text3: ; 0x85075
    db $0, "Ah ", $52, "!", $4f
    db "So we meet again!", $51
    db "The PRESIDENT and", $4f
    db "I are discussing", $55
    db "a vital business", $55
    db "proposition.", $51
    db "Keep your nose", $4f
    db "out of grown-up", $55
    db "matters...", $51
    db "Or, experience a", $4f
    db "world of pain!", $57

INCBIN "baserom.gbc",$85119,$21d

_Mansion2Text3: ; 0x85336
    db $0, "Diary: July 5", $4f
    db "Guyana,", $55
    db "South America", $51
    db "A new #MON was", $4f
    db "discovered deep", $55
    db "in the jungle.", $57

_Mansion2Text4: ; 0x85389
    db $0, "Diary: July 10", $4f
    db "We christened the", $55
    db "newly discovered", $55
    db "#MON, MEW.", $57

INCBIN "baserom.gbc",$853c7,$854a3 - $853c7

_Mansion3Text5: ; 0x854a3
    db $0, "Diary: Feb. 6", $4f
    db "MEW gave birth.", $51
    db "We named the", $4f
    db "newborn MEWTWO.", $57

INCBIN "baserom.gbc",$854df,$85583 - $854df

_Mansion4Text7: ; 0x85583
    db $0, "Diary; Sept. 1", $4f
    db "MEWTWO is far too", $55
    db "powerful.", $51
    db "We have failed to", $4f
    db "curb its vicious", $55
    db "tendencies...", $57

_SafariZoneEastText5: ; 0x855e0
    db $0, "REST HOUSE", $57

_SafariZoneEastText6: ; 0x855ec
    db $0, "TRAINER TIPS", $51
    db "The remaining time", $4f
    db "declines only", $55
    db "while you walk!", $57

_SafariZoneEastText7: ; 0x8562b
    db $0, "CENTER AREA", $4f
    db "NORTH: AREA 2", $57

_SafariZoneNorthText3: ; 0x85646
    db $0, "REST HOUSE", $57

_SafariZoneNorthText4: ; 0x85652
    db $0, "TRAINER TIPS", $51
    db "The SECRET HOUSE", $4f
    db "is still ahead!", $57

_SafariZoneNorthText5: ; 0x85681
    db $0, "AREA 2", $57

_SafariZoneNorthText6: ; 0x85689
    db $0, "TRAINER TIPS", $51
    db "#MON hide in", $4f
    db "tall grass!", $51
    db "Zigzag through", $4f
    db "grassy areas to", $55
    db "flush them out.", $57

_SafariZoneNorthText7: ; 0x856df
    db $0, "TRAINER TIPS", $51
    db "Win a free HM for", $4f
    db "finding the", $55
    db "SECRET HOUSE!", $57

_SafariZoneWestText5: ; 0x85719
    db $0, "REST HOUSE", $57

_SafariZoneWestText6: ; 0x85725
    db $0, "REQUEST NOTICE", $51
    db "Please find the", $4f
    db "SAFARI WARDEN's", $55
    db "lost GOLD TEETH.", $55
    db "They're around", $55
    db "here somewhere.", $51
    db "Reward offered!", $4f
    db "Contact: WARDEN", $57

_SafariZoneWestText7: ; 0x857a3
    db $0, "TRAINER TIPS", $51
    db "Zone Exploration", $4f
    db "Campaign!", $51
    db "The Search for", $4f
    db "the SECRET HOUSE!", $57

_SafariZoneWestText8: ; 0x857ed
    db $0, "AREA 3", $4f
    db "EAST: CENTER AREA", $57

_SafariZoneCenterText2: ; 0x85807
    db $0, "REST HOUSE", $57

_SafariZoneCenterText3: ; 0x85813
    db $0, "TRAINER TIPS", $51
    db "Press the START", $4f
    db "Button to check", $55
    db "remaining time!", $57

_SafariZoneRestHouse1Text1: ; 0x85851
    db $0, "SARA: Where did", $4f
    db "my boy friend,", $55
    db "ERIK, go?", $57

_SafariZoneRestHouse1Text2: ; 0x8587b
    db $0, "I'm catching", $4f
    db "#MON to take", $55
    db "home as gifts!", $57

INCBIN "baserom.gbc",$858a4,$85a2f - $858a4

_SafariZoneRestHouse2Text1: ; 0x85a2f
    db $0, "Tossing ROCKs at", $4f
    db "#MON might", $55
    db "make them run,", $55
    db "but they'll be", $55
    db "easier to catch.", $57

_SafariZoneRestHouse2Text2: ; 0x85a7a
    db $0, "Using BAIT will", $4f
    db "make #MON", $55
    db "easier to catch.", $57

_SafariZoneRestHouse2Text3: ; 0x85aa6
    db $0, "I hiked a lot, but", $4f
    db "I didn't see any", $55
    db "#MON I wanted.", $57

_SafariZoneRestHouse3Text1: ; 0x85ad9
    db $0, "How many did you", $4f
    db "catch? I'm bushed", $55
    db "from the work!", $57

_SafariZoneRestHouse3Text2: ; 0x85b0b
    db $0, "I caught a", $4f
    db "CHANSEY!", $51
    db "That makes this", $4f
    db "all worthwhile!", $57

_SafariZoneRestHouse3Text3: ; 0x85b40
    db $0, "Whew! I'm tired", $4f
    db "from all the fun!", $57

_SafariZoneRestHouse4Text1: ; 0x85b62
    db $0, "You can keep any", $4f
    db "item you find on", $55
    db "the ground here.", $51
    db "But, you'll run", $4f
    db "out of time if", $55
    db "you try for all", $55
    db "of them at once!", $57

_SafariZoneRestHouse4Text2: ; 0x85bd5
    db $0, "Go to the deepest", $4f
    db "part of the", $55
    db "SAFARI ZONE. You", $55
    db "will win a prize!", $57

_SafariZoneRestHouse4Text3: ; 0x85c17
    db $0, "My EEVEE evolved", $4f
    db "into FLAREON!", $51
    db "But, a friend's", $4f
    db "EEVEE turned into", $55
    db "a VAPOREON!", $55
    db "I wonder why?", $57

INCBIN "baserom.gbc",$85c72,$343

_HallofFameRoomText1: ; 0x85fb5
    db $0, "OAK: Er-hem!", $4f
    db "Congratulations", $55
    db $52, "!", $51
    db "This floor is the", $4f
    db "#MON HALL OF", $55
    db "FAME!", $51
    db "#MON LEAGUE", $4f
    db "champions are", $55
    db "honored for their", $55
    db "exploits here!", $51
    db "Their #MON are", $4f
    db "also recorded in", $55
    db "the HALL OF FAME!", $51
    db $52, "! You have", $4f
    db "endeavored hard", $55
    db "to become the new", $55
    db "LEAGUE champion!", $51
    db "Congratulations,", $4f
    db $52, ", you and", $55
    db "your #MON are", $55
    db "HALL OF FAMERs!", $57

INCBIN "baserom.gbc",$860e1,$863c1 - $860e1

_GaryText2: ; 0x863c1
    db $0, "OAK: ", $52, "!", $57

INCBIN "baserom.gbc",$863ca,$1c36

SECTION "bank22",DATA,BANK[$22]

INCBIN "baserom.gbc",$88000,$8807e - $88000

_SeafoamIslands5Text4: ; 0x8807e
    db $0, "Boulders might", $4f
    db "change the flow", $55
    db "of water!", $57

_SeafoamIslands5Text5: ; 0x880a8
    db $0, "DANGER", $4f
    db "Fast current!", $57

_AIBattleWithdrawText:
	db 1
	dw $D04A
	db 0," with-",$4F,"drew @",1
	dw $CFDA
	db 0,"!",$58
_AIBattleUseItemText:
	db 1
	dw $D04A
	db 0,$4F,"used @",1
	dw $CD6D
	db 0,$55,"on @",1
	dw $CFDA
	db 0,"!",$58

INCBIN "baserom.gbc",$880EF,$89784 - $880EF

_TrainerAboutToUseText:
	db 1
	dw $D04A
	db 0," is",$4F
	db "about to use",$55,"@",1
	dw $CFDA
	db 0,"!",$51
	db "Will ",$52,$4F
	db "change #MON?",$57

_TrainerSentOutText:
	db 1
	dw $D04A
	db 0," sent",$4F
	db "out @",1
	dw $CFDA
	db 0,"!",$57

INCBIN "baserom.gbc",$897C9,$898AA - $897C9

_MultiHitText:
	db 0,"Hit the enemy",$4F,"@"
	TX_NUM W_NUMHITS,1,1
	db 0," times!",$58

_ScaredText:
	db 1
	dw $D009
	db 0," is too",$4F
	db "scared to move!",$58

_GetOutText:
	db 0,"GHOST: Get out...",$4F
	db "Get out...",$58

_FastAsleepText:
	db 0,$5A,$4F
	db "is fast asleep!",$58

_WokeUpText:
	db 0,$5A,$4F
	db "woke up!",$58

_FrozenText:
	db 0,$5A,$4F
	db "is frozen solid!",$58

_FullyParalyzedText:
	db 0,$5A,"'s",$4F
	db "fully paralyzed!",$58

_FlinchedText:
	db 0,$5A,$4F
	db "flinched!",$58

_MustRechargeText:
	db 0,$5A,$4F
	db "must recharge!",$58

_DisabledNoMoreText:
	db 0,$5A,"'s",$4F
	db "disabled no more!",$58

_IsConfusedText:
	db 0,$5A,$4F
	db "is confused!",$58

_HurtItselfText:
	db 0,"It hurt itself in",$4F
	db "its confusion!",$58

_ConfusedNoMoreText:
	db 0,$5A,"'s",$4F
	db "confused no more!",$58

_SavingEnergyText:
	db 0,$5A,$4F
	db "is saving energy!",$58

_UnleashedEnergyText:
	db 0,$5A,$4F
	db "unleashed energy!",$58

_ThrashingAboutText:
	db 0,$5A,"'s",$4F
	db "thrashing about!",$57

_AttackContinuesText:
	db 0,$5A,"'s",$4F
	db "attack continues!",$57

_CantMoveText:
	db 0,$5A,$4F
	db "can't move!",$58

INCBIN "baserom.gbc",$89A29,$8A28E - $89A29

_RequireCoinCaseText: ; 22:628E
        db 0,"A COIN CASE is",$4F
        db "required!@@"

_ExchangeCoinsForPrizesText: ; 22:62A9
        db 0,"We exchange your",$4F
        db "coins for prizes.",$58

_WhichPrizeText: ; 22:62CD
        db 0,"Which prize do",$4F
        db "you want?",$57

_HereYouGoText: ; 22:62E7
        db 0,"Here you go!@@"

_SoYouWantPrizeText: ; 22:62F6
        db 0,"So, you want",$4F
        db "@"
        db 1
        dw $CD6D
        db 0,"?",$57

_SorryNeedMoreCoins: ; 22:630B
        db 0,"Sorry, you need",$4F
        db "more coins.@@"

_OopsYouDontHaveEnoughRoomText: ; 22:6329
        db 0,"Oops! You don't",$4F
        db "have enough room.@@"

_OhFineThenText: ; 22:634C
        db 0,"Oh, fine then.@@"
;635d

INCBIN "baserom.gbc",$8A35D,$8A425 - $8A35D

INCLUDE "text/oakspeech.tx"

INCBIN "baserom.gbc",$8A605,$6696 - $6605

_Char00Text:
	TX_NUM $FF8C,1,2
	db 0," ERROR.",$57

_Char55Text:
	db 0,$4B,"@@"

_DiglettsCaveRoute2Text1: ; 0x8a6a7
    db $0, "I went to ROCK", $4f
    db "TUNNEL, but it's", $55
    db "dark and scary.", $51
    db "If a #MON's", $4f
    db "FLASH could light", $55
    db "it up...", $57

_ViridianForestexitText1: ; 0x8a6fd
    db $0, "Many #MON live", $4f
    db "only in forests ", $55
    db "and caves.", $51
    db "You need to look", $4f
    db "everywhere to get", $55
    db "different kinds!", $57

_ViridianForestexitText2: ; 0x8a75d
    db $0, "Have you noticed", $4f
    db "the bushes on the", $55
    db "roadside?", $51
    db "They can be cut", $4f
    db "down by a special", $55
    db "#MON move.", $57

_Route2HouseText1: ; 0x8a7b8
    db $0, "A fainted #MON", $4f
    db "can't fight. But, ", $55
    db "it can still use ", $55
    db "moves like CUT!", $57

INCBIN "baserom.gbc",$8a7fc,$8a82c - $8a7fc

_Route2GateText2: ; 0x8a82c
    db $0, "Once a #MON", $4f
    db "learns FLASH, you", $55
    db "can get through", $55
    db "ROCK TUNNEL.", $57

_ViridianForestEntranceText1: ; 0x8a868
    db $0, "Are you going to", $4f
    db "VIRIDIAN FOREST?", $55
    db "Be careful, it's", $55
    db "a natural maze!", $57

_ViridianForestEntranceText2: ; 0x8a8ab
    db $0, "RATTATA may be", $4f
    db "small, but its", $55
    db "bite is wicked!", $55
    db "Did you get one?", $57

_MtMoonPokecenterText1: ; 0x8a8eb
    db $0, "I've 6 # BALLs", $4f
    db "set in my belt.", $51
    db "At most, you can", $4f
    db "carry 6 #MON.", $57

_MtMoonPokecenterText3: ; 0x8a929
    db $0, "TEAM ROCKET", $4f
    db "attacks CERULEAN", $55
    db "citizens...", $51
    db "TEAM ROCKET is", $4f
    db "always in the", $55
    db "news!", $57

INCBIN "baserom.gbc",$8a976,$8aa5a - $8a976

_MtMoonPokecenterText5: ; 0x8aa5a
    db $0, $57

INCBIN "baserom.gbc",$8aa5c,$15a4

SECTION "bank23",DATA,BANK[$23]

INCBIN "baserom.gbc",$8c000,$8c0cb - $8c000

_UndergroundTunnelEntranceRoute6Text1: ; 0x8c0cb
    db $0, "People often lose", $4f
    db "things in that", $55
    db "UNDERGROUND PATH.", $57

_UndergroundPathEntranceRoute7Text1: ; 0x8c0ff
    db $0, "I heard a sleepy", $4f
    db "#MON appeared", $55
    db "near CELADON CITY.", $57

INCBIN "baserom.gbc",$8c132,$8c28d - $8c132

_UndergroundPathEntranceRoute8Text1: ; 0x8c28d
    db $0, "The dept. store", $4f
    db "in CELADON has a", $55
    db "great selection!", $57

_RockTunnelPokecenterText1: ; 0x8c2c0
    db $0, "The element types", $4f
    db "of #MON make", $55
    db "them stronger", $55
    db "than some types", $55
    db "and weaker than", $55
    db "others!", $57

_RockTunnelPokecenterText3: ; 0x8c316
    db $0, "I sold a useless", $4f
    db "NUGGET for ", $f0, "5000!", $57

INCBIN "baserom.gbc",$8c33a,$8c5b7 - $8c33a

_RockTunnel1Text8: ; 0x8c5b7
    db $0, "ROCK TUNNEL", $4f
    db "CERULEAN CITY -", $55
    db "LAVENDER TOWN", $57

INCBIN "baserom.gbc",$8c5e2,$8c5f3 - $8c5e2

_Route11GateText1: ; 0x8c5f3
    db $0, "When you catch", $4f
    db "lots of #MON,", $55
    db "isn't it hard to", $55
    db "think up names?", $51
    db "In LAVENDER TOWN,", $4f
    db "there's a man who", $55
    db "rates #MON", $55
    db "nicknames.", $51
    db "He'll help you", $4f
    db "rename them too!", $57

INCBIN "baserom.gbc",$8c689,$8c7f9 - $8c689

_DiglettsCaveEntranceRoute11Text1: ; 0x8c7f9
    db $0, "What a surprise!", $4f
    db "DIGLETTs dug this", $55
    db "long tunnel!", $51
    db "It goes right to", $4f
    db "VIRIDIAN CITY!", $57

_Route12GateText1: ; 0x8c84a
    db $0, "There's a lookout", $4f
    db "spot upstairs.", $57

INCBIN "baserom.gbc",$8c86b,$8cb73 - $8c86b

_Route15GateText1: ; 0x8cb73
    db $0, "Are you working", $4f
    db "on a #DEX?", $51
    db "PROF.OAK's AIDE", $4f
    db "came by here.", $57

INCBIN "baserom.gbc",$8cbac,$8cd2a - $8cbac

_Route16GateMapText2: ; 0x8cd2a
    db $0, "How'd you get in?", $4f
    db "Good effort!", $57

INCBIN "baserom.gbc",$8cd49,$956

_Route1Text2: ; 0x8d69f
    db $0, "See those ledges", $4f
    db "along the road?", $51
    db "It's a bit scary,", $4f
    db "but you can jump", $55
    db "from them.", $51
    db "You can get back", $4f
    db "to PALLET TOWN", $55
    db "quicker that way.", $57

_Route1Text3: ; 0x8d720
    db $0, "ROUTE 1", $4f
    db "PALLET TOWN -", $55
    db "VIRIDIAN CITY", $57

_Route2Text3: ; 0x8d745
    db $0, "ROUTE 2", $4f
    db "VIRIDIAN CITY -", $55
    db "PEWTER CITY", $57

_Route2Text4: ; 0x8d76a
    db $0, "DIGLETT's CAVE", $57

_Route3Text1: ; 0x8d779
    db $0, "Whew... I better", $4f
    db "take a rest...", $55
    db "Groan...", $51
    db "That tunnel from", $4f
    db "CERULEAN takes a", $55
    db "lot out of you!", $57

INCBIN "baserom.gbc",$8d7d5,$8db07 - $8d7d5

_Route3Text10: ; 0x8db07
    db $0, "ROUTE 3", $4f
    db "MT.MOON AHEAD", $57

_Route4Text1: ; 0x8db1e
    db $0, "Ouch! I tripped", $4f
    db "over a rocky", $55
    db "#MON, GEODUDE!", $57

INCBIN "baserom.gbc",$8db4b,$8dbcd - $8db4b

_Route4Text5: ; 0x8dbcd
    db $0, "MT.MOON", $4f
    db "Tunnel Entrance", $57

_Route4Text6: ; 0x8dbe6
    db $0, "ROUTE 4", $4f
    db "MT.MOON -", $55
    db "CERULEAN CITY", $57

_Route5Text1: ; 0x8dc07
    db $0, "UNDERGROUND PATH", $4f
    db "CERULEAN CITY -", $55
    db "VERMILION CITY", $57

INCBIN "baserom.gbc",$8dc38,$8de49 - $8dc38

_Route6Text7: ; 0x8de49
    db $0, "UNDERGROUND PATH", $4f
    db "CERULEAN CITY -", $55
    db "VERMILION CITY", $57

_Route7Text1: ; 0x8de7a
    db $0, "UNDERGROUND PATH", $4f
    db "CELADON CITY -", $55
    db "LAVENDER TOWN", $57

INCBIN "baserom.gbc",$8dea9,$8e262 - $8dea9

_Route8Text10: ; 0x8e262
    db $0, "UNDERGROUND PATH", $4f
    db "CELADON CITY -", $55
    db "LAVENDER TOWN", $57

INCBIN "baserom.gbc",$8e291,$8e61e - $8e291

_Route9Text11: ; 0x8e61e
    db $0, "ROUTE 9", $4f
    db "CERULEAN CITY-", $55
    db "ROCK TUNNEL", $57

INCBIN "baserom.gbc",$8e642,$8e8d4 - $8e642

_Route10Text9: ; 0x8e8d4
_Route10Text7: ; 0x8e8d4
    db $0, "ROCK TUNNEL", $57

_Route10Text10: ; 0x8e8e1
    db $0, "POWER PLANT", $57

INCBIN "baserom.gbc",$8e8ee,$1712

SECTION "bank24",DATA,BANK[$24]
INCBIN "baserom.gbc",$90000,$9008f - $90000

_Route11Text11: ; 0x9008f
    db $0, "DIGLETT's CAVE", $57

_Route12Text1: ; 0x9009e
    db $0, "A sleeping #MON", $4f
    db "blocks the way!", $57

INCBIN "baserom.gbc",$900bf,$903bc - $900bf

_Route12Text11: ; 0x903bc
    db $0, "ROUTE 12 ", $4f
    db "North to LAVENDER", $57

_Route12Text12: ; 0x903d9
    db $0, "SPORT FISHING AREA", $57

INCBIN "baserom.gbc",$903ed,$90781 - $903ed

_Route13Text11: ; 0x90781
    db $0, "TRAINER TIPS", $51
    db "Look to the left", $4f
    db "of that post!", $57

_Route13Text12: ; 0x907ae
    db $0, "TRAINER TIPS", $51
    db "Use SELECT to", $4f
    db "switch items in", $55
    db "the ITEM window!", $57

_Route13Text13: ; 0x907eb
    db $0, "ROUTE 13", $4f
    db "North to SILENCE", $55
    db "BRIDGE", $57

INCBIN "baserom.gbc",$9080d,$90c1f - $9080d

_Route14Text11: ; 0x90c1f
    db $0, "ROUTE 14", $4f
    db "West to FUCHSIA", $55
    db "CITY", $57

INCBIN "baserom.gbc",$90c3e,$91062 - $90c3e

_Route15Text12: ; 0x91062
    db $0, "ROUTE 15", $4f
    db "West to FUCHSIA", $55
    db "CITY", $57

INCBIN "baserom.gbc",$91081,$91287 - $91081

_Route16Text7: ; 0x91287
    db $0, "A sleeping #MON", $4f
    db "blocks the way!", $57

INCBIN "baserom.gbc",$912a8,$9130d - $912a8

_Route16Text8: ; 0x9130d
    db $0, "Enjoy the slope!", $4f
    db "CYCLING ROAD", $57

_Route16Text9: ; 0x9132c
    db $0, "ROUTE 16", $4f
    db "CELADON CITY -", $55
    db "FUCHSIA CITY", $57

INCBIN "baserom.gbc",$91352,$91649 - $91352

_Route17Text11: ; 0x91649
    db $0, "It's a notice!", $51
    db "Watch out for", $4f
    db "discarded items!", $57

_Route17Text12: ; 0x91677
    db $0, "TRAINER TIPS", $51
    db "All #MON are", $4f
    db "unique.", $51
    db "Even #MON of", $4f
    db "the same type and", $55
    db "level grow at", $55
    db "different rates.", $57

_Route17Text13: ; 0x916d8
    db $0, "TRAINER TIPS", $51
    db "Press the A or B", $4f
    db "Button to stay in", $55
    db "place while on a", $55
    db "slope.", $57

_Route17Text14: ; 0x91721
    db $0, "ROUTE 17", $4f
    db "CELADON CITY -", $55
    db "FUCHSIA CITY", $57

_Route17Text15: ; 0x91747
    db $0, "It's a notice!", $51
    db "Don't throw the", $4f
    db "game, throw #", $55
    db "BALLs instead!", $57

_Route17Text16: ; 0x91782
    db $0, "CYCLING ROAD", $4f
    db "Slope ends here!", $57

INCBIN "baserom.gbc",$917a1,$9189d - $917a1

_Route18Text4: ; 0x9189d
    db $0, "ROUTE 18", $4f
    db "CELADON CITY -", $55
    db "FUCHSIA CITY", $57

_Route18Text5: ; 0x918c3
    db $0, "CYCLING ROAD", $4f
    db "No pedestrians", $55
    db "permitted!", $57

INCBIN "baserom.gbc",$918eb,$91c3c - $918eb

_Route19Text11: ; 0x91c3c
    db $0, "SEA ROUTE 19", $4f
    db "FUCHSIA CITY -", $55
    db "SEAFOAM ISLANDS", $57

INCBIN "baserom.gbc",$91c69,$91fa7 - $91c69

_Route20Text12: ; 0x91fa7
_Route20Text11: ; 0x91fa7
    db $0, "SEAFOAM ISLANDS", $57

INCBIN "baserom.gbc",$91fb8,$92606 - $91fb8

_Route22Text3: ; 0x92606
    db $0, "#MON LEAGUE", $4f
    db "Front Gate", $57

INCBIN "baserom.gbc",$9261e,$92700 - $9261e

_Route23Text8: ; 0x92700
    db $0, "VICTORY ROAD GATE", $4f
    db "- #MON LEAGUE", $57

INCBIN "baserom.gbc",$92721,$18df

SECTION "bank25",DATA,BANK[$25]
INCBIN "baserom.gbc",$94000,$945d3 - $94000

_Route25Text11: ; 0x945d3
    db $0, "SEA COTTAGE", $4f
    db "BILL lives here!", $57

INCBIN "baserom.gbc",$945f1,$94b01 - $945f1

_BattleCenterMText1: ; 0x94b01
    db $0, "!", $57

_TradeCenterMText1: ; 0x94b04
    db $0, "!", $57

INCLUDE "text/mapRedsHouse1F.tx"
INCLUDE "text/mapBluesHouse.tx"

INCBIN "baserom.gbc",$94d5b,$95268 - $94d5b

_OaksLabText8: ; 0x95268
    db $0, "?", $57

INCBIN "baserom.gbc",$9526b,$95ba1 - $9526b

_ViridianPokeCenterText2: ; 0x95ba1
_ViridianPokeCenterText1: ; 0x95ba1
    db $0, "You can use that", $4f
    db "PC in the corner.", $51
    db "The receptionist", $4f
    db "told me. So kind!", $57

_ViridianPokeCenterText3: ; 0x95be8
    db $0, "There's a #MON", $4f
    db "CENTER in every", $55
    db "town ahead.", $51
    db "They don't charge", $4f
    db "any money either!", $57

_ViridianMartText1: ; 0x95c36
    db $0, "Okay! Say hi to", $4f
    db "PROF.OAK for me!", $57

INCBIN "baserom.gbc",$95c58,$95cd5 - $95c58

_ViridianMartText2: ; 0x95cd5
    db $0, "This shop sells", $4f
    db "many ANTIDOTEs.", $57

_ViridianMartText3: ; 0x95cf6
    db $0, "No! POTIONs are", $4f
    db "all sold out.", $57

_SchoolText1: ; 0x95d15
    db $0, "Whew! I'm trying", $4f
    db "to memorize all", $55
    db "my notes.", $57

_SchoolText2: ; 0x95d40
    db $0, "Okay!", $51
    db "Be sure to read", $4f
    db "the blackboard", $55
    db "carefully!", $57

_ViridianHouseText1: ; 0x95d71
    db $0, "Coming up with", $4f
    db "nicknames is fun,", $55
    db "but hard.", $51
    db "Simple names are", $4f
    db "the easiest to", $55
    db "remember.", $57

_ViridianHouseText2: ; 0x95dc7
    db $0, "My Daddy loves", $4f
    db "#MON too.", $57

INCBIN "baserom.gbc",$95de1,$95df3 - $95de1

_ViridianHouseText4: ; 0x95df3
    db $0, "SPEAROW", $4f
    db "Name: SPEARY", $57

INCBIN "baserom.gbc",$95e09,$96841 - $95e09

_MuseumF2Text1: ; 0x96841
    db $0, "MOON STONE?", $51
    db "What's so special", $4f
    db "about it?", $57

_MuseumF2Text2: ; 0x96869
    db $0, "July 20, 1969!", $51
    db "The 1st lunar", $4f
    db "landing!", $51
    db "I bought a color", $4f
    db "TV to watch it!", $57

_MuseumF2Text3: ; 0x968b1
    db $0, "We have a space", $4f
    db "exhibit now.", $57

_MuseumF2Text4: ; 0x968cf
    db $0, "I want a PIKACHU!", $4f
    db "It's so cute!", $51
    db "I asked my Daddy", $4f
    db "to catch me one!", $57

_MuseumF2Text5: ; 0x96911
    db $0, "Yeah, a PIKACHU", $4f
    db "soon, I promise!", $57

_MuseumF2Text6: ; 0x96933
    db $0, "SPACE SHUTTLE", $4f
    db "COLUMBIA", $57

_MuseumF2Text7: ; 0x9694b
    db $0, "Meteorite that", $4f
    db "fell on MT.MOON.", $55
    db "(MOON STONE?)", $57

INCBIN "baserom.gbc",$9697a,$1686

SECTION "bank26",DATA,BANK[$26]

INCBIN "baserom.gbc",$98000,$984ce - $98000

_PewterHouse1Text1: ; 0x984ce
    db $0, "NIDORAN: Bowbow!@@"

_PewterHouse1Text2: ; 0x984e1
    db $0, "NIDORAN sit!", $57

_PewterHouse1Text3: ; 0x984ef
    db $0, "Our #MON's an", $4f
    db "outsider, so it's", $55
    db "hard to handle.", $51
    db "An outsider is a", $4f
    db "#MON that you", $55
    db "get in a trade.", $51
    db "It grows fast, but", $4f
    db "it may ignore an", $55
    db "unskilled trainer", $55
    db "in battle!", $51
    db "If only we had", $4f
    db "some BADGEs...", $57

INCBIN "baserom.gbc",$985ac,$98656 - $985ac

_PewterHouse2Text1: ; 0x98656
    db $0, "#MON learn new", $4f
    db "techniques as", $55
    db "they grow!", $51
    db "But, some moves", $4f
    db "must be taught by", $55
    db "the trainer!", $57

_PewterHouse2Text2: ; 0x986ae
    db $0, "#MON become", $4f
    db "easier to catch", $55
    db "when they are", $55
    db "hurt or asleep!", $51
    db "But, it's not a", $4f
    db "sure thing!", $57

_PewterPokecenterText1: ; 0x98704
    db $0, "What!?", $51
    db "TEAM ROCKET is", $4f
    db "at MT.MOON? Huh?", $55
    db "I'm on the phone!", $51
    db "Scram!", $57

INCBIN "baserom.gbc",$98744,$98834 - $98744

_CeruleanHouseTrashedText2: ; 0x98834
    db $0, "TEAM ROCKET must", $4f
    db "be trying to DIG", $55
    db "their way into no", $55
    db "good!", $57

_CeruleanHouseTrashedText3: ; 0x9886f
    db $0, "TEAM ROCKET left", $4f
    db "a way out!", $57

_CeruleanHouse2Text1: ; 0x9888c
    db $0, "My husband likes", $4f
    db "trading #MON.", $51
    db "If you are a", $4f
    db "collector, would", $55
    db "you please trade", $55
    db "with him?", $57

_CeruleanPokecenterText1: ; 0x988e5
    db $0, "That BILL!", $51
    db "I heard that", $4f
    db "he'll do whatever", $55
    db "it takes to get", $55
    db "rare #MON!", $57

_CeruleanPokecenterText3: ; 0x9892a
    db $0, "Have you heard", $4f
    db "about BILL?", $51
    db "Everyone calls", $4f
    db "him a #MANIAC!", $51
    db "I think people", $4f
    db "are just jealous", $55
    db "of BILL, though.", $51
    db "Who wouldn't want", $4f
    db "to boast about", $55
    db "their #MON?", $57

INCBIN "baserom.gbc",$989c1,$99012 - $989c1

_CeruleanMartText2: ; 0x99012
    db $0, "Use REPEL to keep", $4f
    db "bugs and weak", $55
    db "#MON away.", $51
    db "Put your strongest", $4f
    db "#MON at the", $55
    db "top of the list", $55
    db "for best results!", $57

_CeruleanMartText3: ; 0x9907f
    db $0, "Have you seen any", $4f
    db "RARE CANDY?", $51
    db "It's supposed to", $4f
    db "make #MON go", $55
    db "up one level!", $57

INCBIN "baserom.gbc",$990c9,$9940e - $990c9

_LavenderPokecenterText4:
_LavenderPokecenterText2:
_LavenderPokecenterText1: ; 0x9940e
    db $0, "TEAM ROCKET will", $4f
    db "do anything for", $55
    db "the sake of gold!", $57

_LavenderPokecenterText3: ; 0x99442
    db $0, "I saw CUBONE's", $4f
    db "mother die trying", $55
    db "to escape from", $55
    db "TEAM ROCKET!", $57

_PokemonTower1Text1: ; 0x9947f
    db $0, "#MON TOWER was", $4f
    db "erected in the", $55
    db "memory of #MON", $55
    db "that had died.", $57

_PokemonTower1Text2: ; 0x994bc
    db $0, "Did you come to", $4f
    db "pay respects?", $55
    db "Bless you!", $57

_PokemonTower1Text3: ; 0x994e6
    db $0, "I came to pray", $4f
    db "for my CLEFAIRY.", $51
    db "Sniff! I can't", $4f
    db "stop crying...", $57

_PokemonTower1Text4: ; 0x99524
    db $0, "My GROWLITHE...", $4f
    db "Why did you die?", $57

_PokemonTower1Text5: ; 0x99546
    db $0, "I am a CHANNELER!", $4f
    db "There are spirits", $55
    db "up to mischief!", $57

INCBIN "baserom.gbc",$9957b,$9971a - $9957b

_PokemonTower2Text2: ; 0x9971a
    db $0, "Even we could not", $4f
    db "identify the", $55
    db "wayward GHOSTs!", $51
    db "A SILPH SCOPE", $4f
    db "might be able to", $55
    db "unmask them.", $57

INCBIN "baserom.gbc",$99776,$99958 - $99776

_PokemonTower5Text1: ; 0x99958
    db $0, "Come, child! I", $4f
    db "sealed this space", $55
    db "with white magic!", $51
    db "You can rest here!", $57

INCBIN "baserom.gbc",$9999f,$99f72 - $9999f

_LavenderHouse1Text3: ; 0x99f72
    db $0, "PSYDUCK: Gwappa!@@"

_LavenderHouse1Text4: ; 0x99f85
    db $0, "NIDORINO: Gaoo!@@"

INCBIN "baserom.gbc",$99f97,$9a0aa - $99f97

_LavenderHouse1Text6: ; 0x9a0aa
    db $0, "#MON Monthly", $4f
    db "Grand Prize", $55
    db "Drawing!", $51
    db "The application", $4f
    db "form is...", $51
    db "Gone! It's been", $4f
    db "clipped out!", $57

_LavenderMartText2: ; 0x9a104
    db $0, "I'm searching for", $4f
    db "items that raise", $55
    db "the abilities of", $55
    db "#MON during a", $55
    db "single battle.", $51
    db "X ATTACK, X", $4f
    db "DEFEND, X SPEED", $55
    db "and X SPECIAL are", $55
    db "what I'm after.", $51
    db "Do you know where", $4f
    db "I can get them?", $57

INCBIN "baserom.gbc",$9a1b4,$9a238 - $9a1b4

_LavenderHouse2Text1: ; 0x9a238
    db $0, "CUBONE: Kyarugoo!@@"

INCBIN "baserom.gbc",$9a24c,$266

_VermilionPokecenterText2: ; 0x9a4b2
_VermilionPokecenterText1: ; 0x9a4b2
    db $0, "Even if they are", $4f
    db "the same level,", $55
    db "#MON can have", $55
    db "very different", $55
    db "abilities.", $51
    db "A #MON raised", $4f
    db "by a trainer is", $55
    db "stronger than one", $55
    db "in the wild.", $57

_VermilionPokecenterText3: ; 0x9a539
    db $0, "My #MON was", $4f
    db "poisoned! It", $55
    db "fainted while we", $55
    db "were walking!", $57

INCBIN "baserom.gbc",$9a572,$9a948 - $9a572

_FanClubText6: ; 0x9a948
    db $0, "Our Chairman is", $4f
    db "very vocal about", $55
    db "#MON.", $57

_FanClubText7: ; 0x9a970
    db $0, "Let's all listen", $4f
    db "politely to other", $55
    db "trainers!", $57

_FanClubText8: ; 0x9a99d
    db $0, "If someone brags,", $4f
    db "brag right back!", $57

_VermilionMartText2: ; 0x9a9c1
    db $0, "There are evil", $4f
    db "people who will", $55
    db "use #MON for", $55
    db "criminal acts.", $51
    db "TEAM ROCKET", $4f
    db "traffics in rare", $55
    db "#MON.", $51
    db "They also abandon", $4f
    db "#MON that they", $55
    db "consider not to", $55
    db "be popular or", $55
    db "useful.", $57

_VermilionMartText3: ; 0x9aa67
    db $0, "I think #MON", $4f
    db "can be good or", $55
    db "evil. It depends", $55
    db "on the trainer.", $57

INCBIN "baserom.gbc",$9aaa5,$155b

SECTION "bank27",DATA,BANK[$27]
INCBIN "baserom.gbc",$9c000,$9c449 - $9c000

_VermilionHouse1Text1: ; 0x9c449
    db $0, "I'm getting my", $4f
    db "PIDGEY to fly a", $55
    db "letter to SAFFRON", $55
    db "in the north!", $57

_VermilionHouse1Text2: ; 0x9c488
    db $0, "PIDGEY: Kurukkoo!@@"

_VermilionHouse1Text3: ; 0x9c49c
    db $0, "Dear PIPPI, I hope", $4f
    db "to see you soon.", $51
    db "I heard SAFFRON", $4f
    db "has problems with", $55
    db "TEAM ROCKET.", $51
    db "VERMILION appears", $4f
    db "to be safe.", $57

INCBIN "baserom.gbc",$9c50e,$9c672 - $9c50e

_CeladonMart1Text1: ; 0x9c672
    db $0, "Hello! Welcome to", $4f
    db "CELADON DEPT.", $55
    db "STORE.", $51
    db "The board on the", $4f
    db "right describes", $55
    db "the store layout.", $57

_CeladonMart1Text2: ; 0x9c6cd
    db $0, "1F: SERVICE", $4f
    db "    COUNTER", $51
    db "2F: TRAINER'S", $4f
    db "    MARKET", $51
    db "3F: TV GAME SHOP", $51
    db "4F: WISEMAN GIFTS", $51
    db "5F: DRUG STORE", $51
    db "ROOFTOP SQUARE:", $4f
    db "VENDING MACHINES", $57

_CeladonMart1Text3: ; 0x9c752
    db $0, "1F: SERVICE", $4f
    db "    COUNTER", $57

_CeladonMart2Text3: ; 0x9c76b
    db $0, "SUPER REPEL keeps", $4f
    db "weak #MON at", $55
    db "bay...", $51
    db "Hmm, it's a more", $4f
    db "powerful REPEL!", $57

_CeladonMart2Text4: ; 0x9c7b2
    db $0, "For long outings,", $4f
    db "you should buy", $55
    db "REVIVE.", $57

_CeladonMart2Text5: ; 0x9c7dc
    db $0, "Top Grade Items", $4f
    db "for Trainers!", $51
    db "2F: TRAINER'S", $4f
    db "    MARKET", $57

INCBIN "baserom.gbc",$9c814,$9c8c7 - $9c814

_CeladonMart3Text2: ; 0x9c8c7
    db $0, "Captured #MON", $4f
    db "are registered", $55
    db "with an ID No.", $55
    db "and OT, the name", $55
    db "of the Original", $55
    db "Trainer that", $55
    db "caught it!", $57

_CeladonMart3Text3: ; 0x9c92d
    db $0, "All right!", $51
    db "My buddy's going", $4f
    db "to trade me his", $55
    db "KANGASKHAN for my", $55
    db "GRAVELER!", $57

_CeladonMart3Text4: ; 0x9c975
    db $0, "Come on GRAVELER!", $51
    db "I love GRAVELER!", $4f
    db "I collect them!", $51
    db "Huh?", $51
    db "GRAVELER turned", $4f
    db "into a different", $55
    db "#MON!", $57

_CeladonMart3Text5: ; 0x9c9d5
    db $0, "You can identify", $4f
    db "#MON you got", $55
    db "in trades by", $55
    db "their ID Numbers!", $57

_CeladonMart3Text6: ; 0x9ca13
    db $0, "It's an SNES!", $57

_CeladonMart3Text7: ; 0x9ca21
    db $0, "An RPG! There's", $4f
    db "no time for that!", $57

_CeladonMart3Text9: ; 0x9ca43
    db $0, "A sports game!", $4f
    db "Dad'll like that!", $57

_CeladonMart3Text11: ; 0x9ca64
    db $0, "A puzzle game!", $4f
    db "Looks addictive!", $57

_CeladonMart3Text13: ; 0x9ca85
    db $0, "A fighting game!", $4f
    db "Looks tough!", $57

_CeladonMart3Text14: ; 0x9caa4
    db $0, "3F: TV GAME SHOP", $57

_CeladonMart3Text15: ; 0x9cab6
    db $0, "Red and Blue!", $4f
    db "Both are #MON!", $57

_CeladonMart4Text2: ; 0x9cad4
    db $0, "I'm getting a", $4f
    db "# DOLL for my", $55
    db "girl friend!", $57

_CeladonMart4Text3: ; 0x9cafd
    db $0, "I heard something", $4f
    db "useful.", $51
    db "You can run from", $4f
    db "wild #MON by", $55
    db "distracting them", $55
    db "with a # DOLL!", $57

_CeladonMart4Text4: ; 0x9cb56
    db $0, "Express yourself", $4f
    db "with gifts!", $51
    db "4F: WISEMAN GIFTS", $51
    db "Evolution Special!", $4f
    db "Element STONEs on", $55
    db "sale now!", $57

INCBIN "baserom.gbc",$9cbb5,$9cd97 - $9cbb5

_CeladonMartRoofText1: ; 0x9cd97
    db $0, "My sister is a", $4f
    db "trainer, believe", $55
    db "it or not.", $51
    db "But, she's so", $4f
    db "immature, she", $55
    db "drives me nuts!", $57

INCBIN "baserom.gbc",$9cdee,$9ce50 - $9cdee

_CeladonMartRoofText6: ; 0x9ce50
    db $0, "ROOFTOP SQUARE:", $4f
    db "VENDING MACHINES", $57

INCBIN "baserom.gbc",$9ce72,$9ceee - $9ce72

_CeladonMansion1Text1: ; 0x9ceee
    db $0, "MEOWTH: Meow!@@"

_CeladonMansion1Text2: ; 0x9cefe
    db $0, "My dear #MON", $4f
    db "keep me company.", $51
    db "MEOWTH even brings", $4f
    db "money home!", $57

_CeladonMansion1Text3: ; 0x9cf3c
    db $0, "CLEFAIRY: Pi", $4f
    db "pippippi!@@"

_CeladonMansion1Text4: ; 0x9cf55
    db $0, "NIDORAN: Kya", $4f
    db "kyaoo!@@"

_CeladonMansion1Text5: ; 0x9cf6b
    db $0, "CELADON MANSION", $4f
    db "Manager's Suite", $57

_CeladonMansion2Text1: ; 0x9cf8b
    db $0, "GAME FREAK", $4f
    db "Meeting Room", $57

_CeladonMansion3Text1: ; 0x9cfa4
    db $0, "Me? I'm the", $4f
    db "programmer!", $57

_CeladonMansion3Text2: ; 0x9cfbc
    db $0, "I'm the graphic", $4f
    db "artist!", $55
    db "I drew you!", $57

_CeladonMansion3Text3: ; 0x9cfe0
    db $0, "I wrote the story!", $4f
    db "Isn't ERIKA cute?", $51
    db "I like MISTY a", $4f
    db "lot too!", $51
    db "Oh, and SABRINA,", $4f
    db "I like her!", $57

INCBIN "baserom.gbc",$9d03a,$9d0ed - $9d03a

_CeladonMansion3Text5: ; 0x9d0ed
    db $0, "It's the game", $4f
    db "program! Messing", $55
    db "with it could bug", $55
    db "out the game!", $57

_CeladonMansion3Text6: ; 0x9d12c
    db $0, "Someone's playing", $4f
    db "a game instead of", $55
    db "working!", $57

_CeladonMansion3Text7: ; 0x9d159
    db $0, "It's the script!", $4f
    db "Better not look", $55
    db "at the ending!", $57

_CeladonMansion3Text8: ; 0x9d189
    db $0, "GAME FREAK", $4f
    db "Development Room", $57

_CeladonMansion4Text1: ; 0x9d1a6
    db $0, "I KNOW EVERYTHING!", $57

_CeladonMansion5Text1: ; 0x9d1ba
    db $0, "I know everything", $4f
    db "about the world", $55
    db "of #MON in", $55
    db "your GAME BOY!", $51
    db "Get together with", $4f
    db "your friends and", $55
    db "trade #MON!", $57

_CeladonPokecenterText1: ; 0x9d226
    db $0, "# FLUTE awakens", $4f
    db "#MON with a", $55
    db "sound that only", $55
    db "they can hear!", $57

_CeladonPokecenterText3: ; 0x9d262
    db $0, "I rode uphill on", $4f
    db "CYCLING ROAD from", $55
    db "FUCHSIA!", $57

INCBIN "baserom.gbc",$9d28f,$9d8d5 - $9d28f

_CeladonGameCornerText1: ; 0x9d8d5
    db $0, "Welcome!", $51
    db "You can exchange", $4f
    db "your coins for", $55
    db "fabulous prizes", $55
    db "next door.", $57

INCBIN "baserom.gbc",$9d91a,$9da1c - $9d91a

_CeladonGameCornerText3: ; 0x9da1c
    db $0, "Keep this quiet.", $51
    db "It's rumored that", $4f
    db "this place is run", $55
    db "by TEAM ROCKET.", $57

_CeladonGameCornerText4: ; 0x9da61
    db $0, "I think these", $4f
    db "machines have", $55
    db "different odds.", $57

INCBIN "baserom.gbc",$9da8e,$9daf4 - $9da8e

_CeladonGameCornerText6: ; 0x9daf4
    db $0, "I'm having a", $4f
    db "wonderful time!", $57

INCBIN "baserom.gbc",$9db11,$9dc06 - $9db11

_CeladonGameCornerText8: ; 0x9dc06
    db $0, "Games are scary!", $4f
    db "It's so easy to", $55
    db "get hooked!", $57

INCBIN "baserom.gbc",$9dc33,$9ddff - $9dc33

_CeladonMart5Text1: ; 0x9ddff
    db $0, "#MON ability", $4f
    db "enhancers can be", $55
    db "bought only here.", $51
    db "Use CALCIUM to", $4f
    db "increase SPECIAL", $55
    db "abilities.", $51
    db "Use CARBOS to", $4f
    db "increase SPEED.", $57

_CeladonMart5Text2: ; 0x9de79
    db $0, "I'm here for", $4f
    db "#MON ability", $55
    db "enhancers.", $51
    db "PROTEIN increases", $4f
    db "ATTACK power.", $51
    db "IRON increases", $4f
    db "DEFENSE!", $57

_CeladonMart5Text5: ; 0x9ded6
    db $0, "5F: DRUG STORE", $57

_CeladonPrizeRoomText1: ; 0x9dee6
    db $0, "I sure do fancy", $4f
    db "that PORYGON!", $51
    db "But, it's hard to", $4f
    db "win at slots!", $57

_CeladonPrizeRoomText2: ; 0x9df24
    db $0, "I had a major", $4f
    db "haul today!", $57

_CeladonDinerText1: ; 0x9df3f
    db $0, "Hi!", $51
    db "We're taking a", $4f
    db "break now.", $57

_CeladonDinerText2: ; 0x9df5d
    db $0, "My #MON are", $4f
    db "weak, so I often", $55
    db "have to go to the", $55
    db "DRUG STORE.", $57

_CeladonDinerText3: ; 0x9df99
    db $0, "Psst! There's a", $4f
    db "basement under", $55
    db "the GAME CORNER.", $57

_CeladonDinerText4: ; 0x9dfc9
    db $0, "Munch...", $51
    db "The man at that", $4f
    db "table lost it all", $55
    db "at the slots.", $57

INCBIN "baserom.gbc",$9e003,$9e0d5 - $9e003

_CeladonHouse2Text1: ; 0x9e0d5
    db $0, "Hehehe! The slots", $4f
    db "just reel in the", $55
    db "dough, big time!", $57

_CeladonHouse2Text2: ; 0x9e10a
    db $0, "CHIEF!", $51
    db "We just shipped", $4f
    db "2000 #MON as", $55
    db "slot prizes!", $57

_CeladonHouse2Text3: ; 0x9e13c
    db $0, "Don't touch the", $4f
    db "poster at the", $55
    db "GAME CORNER!", $51
    db "There's no secret", $4f
    db "switch behind it!", $57

_CeladonHotelText1: ; 0x9e18a
    db $0, "#MON? No, this", $4f
    db "is a hotel for", $55
    db "people.", $51
    db "We're full up.", $57

_CeladonHotelText2: ; 0x9e1bf
    db $0, "I'm on vacation", $4f
    db "with my brother", $55
    db "and boy friend.", $51
    db "CELADON is such a", $4f
    db "pretty city!", $57

_CeladonHotelText3: ; 0x9e20e
    db $0, "Why did she bring", $4f
    db "her brother?", $57

_FuchsiaMartText2: ; 0x9e22e
    db $0, "Do you have a", $4f
    db "SAFARI ZONE flag?", $51
    db "What about cards", $4f
    db "or calendars?", $57

_FuchsiaMartText3: ; 0x9e26e
    db $0, "Did you try X", $4f
    db "SPEED? It speeds", $55
    db "up a #MON in", $55
    db "battle!", $57

_FuchsiaHouse1Text1: ; 0x9e2a3
    db $0, "SAFARI ZONE's", $4f
    db "WARDEN is old,", $55
    db "but still active!", $51
    db "All his teeth are", $4f
    db "false, though.", $57

_FuchsiaHouse1Text2: ; 0x9e2f3
    db $0, "Hmm? You've met", $4f
    db "BILL?", $51
    db "He's my grandson!", $51
    db "He always liked", $4f
    db "collecting things", $55
    db "even as a child!", $57

_FuchsiaHouse1Text3: ; 0x9e34d
    db $0, "BILL files his", $4f
    db "own #MON data", $55
    db "on his PC!", $51
    db "Did he show you?", $57

_FuchsiaPokecenterText1: ; 0x9e387
    db $0, "You can't win", $4f
    db "with just one", $55
    db "strong #MON.", $51
    db "It's tough, but", $4f
    db "you have to raise", $55
    db "them evenly.", $57

_FuchsiaPokecenterText3: ; 0x9e3de
    db $0, "There's a narrow", $4f
    db "trail west of", $55
    db "VIRIDIAN CITY.", $51
    db "It goes to #MON", $4f
    db "LEAGUE HQ.", $55
    db "The HQ governs", $55
    db "all trainers.", $57

INCBIN "baserom.gbc",$9e444,$9e6c7 - $9e444

_SafariZoneEntranceText1: ; 0x9e6c7
    db $0, "Welcome to the", $4f
    db "SAFARI ZONE!", $57

INCBIN "baserom.gbc",$9e6e4,$191c

SECTION "bank28",DATA,BANK[$28]
INCBIN "baserom.gbc",$a0000,$a05a1 - $a0000

_FuchsiaMeetingRoomText1: ; 0xa05a1
    db $0, "We nicknamed the", $4f
    db "WARDEN SLOWPOKE.", $51
    db "He and SLOWPOKE", $4f
    db "both look vacant!", $57

_FuchsiaMeetingRoomText2: ; 0xa05e6
    db $0, "SLOWPOKE is very", $4f
    db "knowledgeable", $55
    db "about #MON!", $51
    db "He even has some", $4f
    db "fossils of rare,", $55
    db "extinct #MON!", $57

_FuchsiaMeetingRoomText3: ; 0xa0642
    db $0, "SLOWPOKE came in,", $4f
    db "but I couldn't", $55
    db "understand him.", $51
    db "I think he's got", $4f
    db "a speech problem!", $57

INCBIN "baserom.gbc",$a0695,$a0df7 - $a0695

_Lab1Text1: ; 0xa0df7
    db $0, "We study #MON", $4f
    db "extensively here.", $51
    db "People often bring", $4f
    db "us rare #MON", $55
    db "for examination.", $57

_Lab1Text2: ; 0xa0e49
    db $0, "A photo of the", $4f
    db "LAB's founder,", $55
    db "DR.FUJI!", $57

_Lab1Text3: ; 0xa0e70
    db $0, "#MON LAB", $4f
    db "Meeting Room", $57

_Lab1Text4: ; 0xa0e87
    db $0, "#MON LAB", $4f
    db "R-and-D Room", $57

_Lab1Text5: ; 0xa0e9e
    db $0, "#MON LAB", $4f
    db "Testing Room", $57

_Lab2Text1: ; 0xa0eb5
    db $0, "I found this very", $4f
    db "strange fossil in", $55
    db "MT.MOON!", $51
    db "I think it's a", $4f
    db "rare, prehistoric", $55
    db "#MON!", $57

INCBIN "baserom.gbc",$a0f09,$a0fe3 - $a0f09

_Lab3Text2: ; 0xa0fe3
    db $0, "EEVEE can evolve", $4f
    db "into 1 of 3 kinds", $55
    db "of #MON.", $57

_Lab3Text3: ; 0xa1010
    db $0, "There's an e-mail", $4f
    db "message!", $51
    db "...", $51
    db "The 3 legendary", $4f
    db "bird #MON are", $55
    db "ARTICUNO, ZAPDOS", $55
    db "and MOLTRES.", $51
    db "Their whereabouts", $4f
    db "are unknown.", $51
    db "We plan to explore", $4f
    db "the cavern close", $55
    db "to CERULEAN.", $51
    db "From: #MON", $4f
    db "RESEARCH TEAM", $51
    db "...", $57

_Lab3Text5: ; 0xa10d8
    db $0, "An amber pipe!", $57

INCBIN "baserom.gbc",$a10e8,$a12de - $a10e8

_CinnabarPokecenterText2:
_CinnabarPokecenterText1: ; 0xa12de
    db $0, "You can cancel", $4f
    db "evolution.", $51
    db "When a #MON is", $4f
    db "evolving, you can", $55
    db "stop it and leave", $55
    db "it the way it is.", $57

_CinnabarPokecenterText3: ; 0xa133e
    db $0, "Do you have any", $4f
    db "friends?", $51
    db "#MON you get", $4f
    db "in trades grow", $55
    db "very quickly.", $51
    db "I think it's", $4f
    db "worth a try!", $57

_CinnabarMartText2: ; 0xa139b
    db $0, "Don't they have X", $4f
    db "ATTACK? It's good", $55
    db "for battles!", $57

_CinnabarMartText3: ; 0xa13cb
    db $0, "It never hurts to", $4f
    db "have extra items!", $57

_IndigoPlateauLobbyText1: ; 0xa13f0
    db $0, "Yo! Champ in", $4f
    db "making!", $51
    db "At #MON LEAGUE,", $4f
    db "you have to face", $55
    db "the ELITE FOUR in", $55
    db "succession.", $51
    db "If you lose, you", $4f
    db "have to start all", $55
    db "over again! This", $55
    db "is it! Go for it!", $57

_IndigoPlateauLobbyText3: ; 0xa148b
    db $0, "From here on, you", $4f
    db "face the ELITE", $55
    db "FOUR one by one!", $51
    db "If you win, a", $4f
    db "door opens to the", $55
    db "next trainer!", $55
    db "Good luck!", $57

_CopycatsHouseF1Text1: ; 0xa14f7
    db $0, "My daughter is so", $4f
    db "self-centered.", $55
    db "She only has a", $55
    db "few friends.", $57

_CopycatsHouseF1Text2: ; 0xa1535
    db $0, "My daughter likes", $4f
    db "to mimic people.", $51
    db "Her mimicry has", $4f
    db "earned her the", $55
    db "nickname COPYCAT", $55
    db "around here!", $57

_CopycatsHouseF1Text3: ; 0xa1596
    db $0, "CHANSEY: Chaan!", $4f
    db "Sii!@@"

INCBIN "baserom.gbc",$a15ad,$a1749 - $a15ad

_CopycatsHouseF2Text2: ; 0xa1749
    db $0, "DODUO: Giiih!", $51
    db "MIRROR MIRROR ON", $4f
    db "THE WALL, WHO IS", $55
    db "THE FAIREST ONE", $55
    db "OF ALL?", $57

_CopycatsHouseF2Text3: ; 0xa1792
    db $0, "This is a rare", $4f
    db "#MON! Huh?", $55
    db "It's only a doll!", $57

_CopycatsHouseF2Text6: ; 0xa17be
    db $0, "A game with MARIO", $4f
    db "wearing a bucket", $55
    db "on his head!", $57

INCBIN "baserom.gbc",$a17ef,$a2305 - $a17ef

_SaffronHouse1Text1: ; 0xa2305
    db $0, "Thank you for", $4f
    db "writing. I hope", $55
    db "to see you soon!", $51
    db "Hey! Don't look", $4f
    db "at my letter!", $57

_SaffronHouse1Text2: ; 0xa2352
    db $0, "PIDGEY: Kurukkoo!@@"

_SaffronHouse1Text3: ; 0xa2366
    db $0, "The COPYCAT is", $4f
    db "cute! I'm getting", $55
    db "her a # DOLL!", $57

_SaffronHouse1Text4: ; 0xa2395
    db $0, "I was given a PP", $4f
    db "UP as a gift.", $51
    db "It's used for", $4f
    db "increasing the PP", $55
    db "of techniques!", $57

_SaffronMartText2: ; 0xa23e3
    db $0, "MAX REPEL lasts", $4f
    db "longer than SUPER", $55
    db "REPEL for keeping", $55
    db "weaker #MON", $55
    db "away!", $57

_SaffronMartText3: ; 0xa242a
    db $0, "REVIVE is costly,", $4f
    db "but it revives", $55
    db "fainted #MON!", $57

_SilphCo1Text1: ; 0xa245a
    db $0, "Welcome!", $51
    db "The PRESIDENT is", $4f
    db "in the boardroom", $55
    db "on 11F!", $57

_SaffronPokecenterText1: ; 0xa248e
    db $0, "#MON growth", $4f
    db "rates differ from", $55
    db "specie to specie.", $57

_SaffronPokecenterText3: ; 0xa24bf
    db $0, "SILPH CO. is very", $4f
    db "famous. That's", $55
    db "why it attracted", $55
    db "TEAM ROCKET!", $57

INCBIN "baserom.gbc",$a24fe,$1b02

SECTION "bank29",DATA,BANK[$29]

INCBIN "baserom.gbc",$A4000,$245

INCLUDE "text/mapPalletTown.tx"

_ViridianCityText1:
    db $0, "Those # BALLs", $4f
    db "at your waist!", $55
    db "You have #MON!", $51
    db "It's great that", $4f
    db "you can carry and", $55
    db "use #MON any", $55
    db "time, anywhere!", $57

INCBIN "baserom.gbc",$a4437,$a4833 - $a4437

_ViridianCityText8: ; 0xa4833
    db $0, "VIRIDIAN CITY ", $4f
    db "The Eternally", $55
    db "Green Paradise", $57

_ViridianCityText9: ; 0xa4860
    db $0, "TRAINER TIPS", $51
    db "Catch #MON", $4f
    db "and expand your", $55
    db "collection!", $51
    db "The more you have,", $4f
    db "the easier it is", $55
    db "to fight!", $57

_ViridianCityText10: ; 0xa48c3
    db $0, "TRAINER TIPS", $51
    db "The battle moves", $4f
    db "of #MON are", $55
    db "limited by their", $55
    db "POWER POINTs, PP.", $51
    db "To replenish PP,", $4f
    db "rest your tired", $55
    db "#MON at a", $55
    db "#MON CENTER!", $57

_ViridianCityText13: ; 0xa4949
    db $0, "VIRIDIAN CITY", $4f
    db "#MON GYM", $57

INCBIN "baserom.gbc",$a4961,$a497f - $a4961

_PewterCityText1: ; 0xa497f
    db $0, "It's rumored that", $4f
    db "CLEFAIRYs came", $55
    db "from the moon!", $51
    db "They appeared ", $4f
    db "after MOON STONE", $55
    db "fell on MT.MOON.", $57

_PewterCityText2: ; 0xa49e0
    db $0, "There aren't many", $4f
    db "serious #MON", $55
    db "trainers here!", $51
    db "They're all like", $4f
    db "BUG CATCHERs,", $55
    db "but PEWTER GYM's", $55
    db "BROCK is totally", $55
    db "into it!", $57

INCBIN "baserom.gbc",$a4a56,$a4bfe - $a4a56

_PewterCityText6: ; 0xa4bfe
    db $0, "TRAINER TIPS", $51
    db "Any #MON that", $4f
    db "takes part in", $55
    db "battle, however", $55
    db "short, earns EXP!", $57

_PewterCityText7: ; 0xa4c4a
    db $0, "NOTICE!", $51
    db "Thieves have been", $4f
    db "stealing #MON", $55
    db "fossils at MT.", $55
    db "MOON! Please call", $55
    db "PEWTER POLICE", $55
    db "with any info!", $57

_PewterCityText10: ; 0xa4cb1
    db $0, "PEWTER MUSEUM", $4f
    db "OF SCIENCE", $57

_PewterCityText11: ; 0xa4ccb
    db $0, "PEWTER CITY", $4f
    db "#MON GYM", $55
    db "LEADER: BROCK", $51
    db "The Rock Solid", $4f
    db "#MON Trainer!", $57

_PewterCityText12: ; 0xa4d0c
    db $0, "PEWTER CITY", $4f
    db "A Stone Gray", $55
    db "City", $57

INCBIN "baserom.gbc",$a4d2b,$a5030 - $a4d2b

_CeruleanCityText3: ; 0xa5030
    db $0, "You're a trainer", $4f
    db "too? Collecting,", $55
    db "fighting, it's a", $55
    db "tough life.", $57

_CeruleanCityText4: ; 0xa506e
    db $0, "That bush in", $4f
    db "front of the shop", $55
    db "is in the way.", $51
    db "There might be a", $4f
    db "way around.", $57

_CeruleanCityText5: ; 0xa50ba
    db $0, "You're making an", $4f
    db "encyclopedia on", $55
    db "#MON? That", $55
    db "sounds amusing.", $57

_CeruleanCityText6: ; 0xa50f6
    db $0, "The people here", $4f
    db "were robbed.", $51
    db "It's obvious that", $4f
    db "TEAM ROCKET is", $55
    db "behind this most", $55
    db "heinous crime!", $51
    db "Even our POLICE", $4f
    db "force has trouble", $55
    db "with the ROCKETs!", $57

INCBIN "baserom.gbc",$a5188,$a52d6 - $a5188

_CeruleanCityText9: ; 0xa52d6
    db $0, "I want a bright", $4f
    db "red BICYCLE!", $51
    db "I'll keep it at", $4f
    db "home, so it won't", $55
    db "get dirty!", $57

_CeruleanCityText10: ; 0xa531f
    db $0, "This is CERULEAN", $4f
    db "CAVE! Horribly", $55
    db "strong #MON", $55
    db "live in there!", $51
    db "The #MON LEAGUE", $4f
    db "champion is the", $55
    db "only person who", $55
    db "is allowed in!", $57

_CeruleanCityText12: ; 0xa539a
    db $0, "CERULEAN CITY", $4f
    db "A Mysterious,", $55
    db "Blue Aura", $55
    db "Surrounds It", $57

_CeruleanCityText13: ; 0xa53ce
    db $0, "TRAINER TIPS", $51
    db "Pressing B Button", $4f
    db "during evolution", $55
    db "cancels the whole", $55
    db "process.", $57

_CeruleanCityText16: ; 0xa541a
    db $0, "Grass and caves", $4f
    db "handled easily!", $55
    db "BIKE SHOP", $57

_CeruleanCityText17: ; 0xa5445
    db $0, "CERULEAN CITY", $4f
    db "#MON GYM", $55
    db "LEADER: MISTY", $51
    db "The Tomboyish", $4f
    db "Mermaid!", $57

INCBIN "baserom.gbc",$a5482,$a5506 - $a5482

_LavenderTownText2: ; 0xa5506
    db $0, "This town is known", $4f
    db "as the grave site", $55
    db "of #MON.", $51
    db "Memorial services", $4f
    db "are held in", $55
    db "#MON TOWER.", $57

_LavenderTownText3: ; 0xa555f
    db $0, "GHOSTs appeared", $4f
    db "in #MON TOWER.", $51
    db "I think they're", $4f
    db "the spirits of", $55
    db "#MON that the", $55
    db "ROCKETs killed.", $57

_LavenderTownText4: ; 0xa55bb
    db $0, "LAVENDER TOWN", $4f
    db "The Noble Purple", $55
    db "Town", $57

_LavenderTownText5: ; 0xa55e0
    db $0, "New SILPH SCOPE!", $51
    db "Make the Invisible", $4f
    db "Plain to See!", $51
    db "SILPH CO.", $57

_LavenderTownText8: ; 0xa561d
    db $0, "LAVENDER VOLUNTEER", $4f
    db "#MON HOUSE", $57

_LavenderTownText9: ; 0xa563c
    db $0, "May the Souls of", $4f
    db "#MON Rest Easy", $55
    db "#MON TOWER", $57

_VermilionCityText1: ; 0xa5668
    db $0, "We're careful", $4f
    db "about pollution!", $51
    db "We've heard GRIMER", $4f
    db "multiplies in", $55
    db "toxic sludge!", $57

INCBIN "baserom.gbc",$a56b5,$a5805 - $a56b5

_VermilionCityText4: ; 0xa5805
    db $0, "I'm putting up a", $4f
    db "building on this", $55
    db "plot of land.", $51
    db "My #MON is", $4f
    db "tamping the land.", $57

_VermilionCityText5: ; 0xa5852
    db $0, "MACHOP: Guoh!", $4f
    db "Gogogoh!@@"

INCBIN "baserom.gbc",$a586b,$a5891 - $a586b

_VermilionCityText6: ; 0xa5891
    db $0, "S.S.ANNE is a", $4f
    db "famous luxury", $55
    db "cruise ship.", $51
    db "We visit VERMILION", $4f
    db "once a year.", $57

_VermilionCityText7: ; 0xa58db
    db $0, "VERMILION CITY", $4f
    db "The Port of", $55
    db "Exquisite Sunsets", $57

_VermilionCityText8: ; 0xa5909
    db $0, "NOTICE!", $51
    db "ROUTE 12 may be", $4f
    db "blocked off by a", $55
    db "sleeping #MON.", $51
    db "Detour through", $4f
    db "ROCK TUNNEL to", $55
    db "LAVENDER TOWN.", $51
    db "VERMILION POLICE", $57

_VermilionCityText11: ; 0xa5980
    db $0, "#MON FAN CLUB", $4f
    db "All #MON fans", $55
    db "welcome!", $57

_VermilionCityText12: ; 0xa59a6
    db $0, "VERMILION CITY", $4f
    db "#MON GYM", $55
    db "LEADER: LT.SURGE", $51
    db "The Lightning ", $4f
    db "American!", $57

_VermilionCityText13: ; 0xa59e9
    db $0, "VERMILION HARBOR", $57

_CeladonCityText1: ; 0xa59fb
    db $0, "I got my KOFFING", $4f
    db "in CINNABAR!", $51
    db "It's nice, but it", $4f
    db "breathes poison", $55
    db "when it's angry!", $57

_CeladonCityText2: ; 0xa5a4b
    db $0, "Heheh! This GYM", $4f
    db "is great! It's", $55
    db "full of women!", $57

_CeladonCityText3: ; 0xa5a79
    db $0, "The GAME CORNER", $4f
    db "is bad for our", $55
    db "city's image!", $57

_CeladonCityText4: ; 0xa5aa6
    db $0, "Moan! I blew it", $4f
    db "all at the slots!", $51
    db "I knew I should", $4f
    db "have cashed in my", $55
    db "coins for prizes!", $57

INCBIN "baserom.gbc",$a5afd,$a5bd9 - $a5afd

_CeladonCityText6: ; 0xa5bd9
    db $0, "This is my trusted", $4f
    db "pal, POLIWRATH!", $51
    db "It evolved from", $4f
    db "POLIWHIRL when I", $55
    db "used WATER STONE!", $57

_CeladonCityText7: ; 0xa5c30
    db $0, "POLIWRATH: Ribi", $4f
    db "ribit!@@"

_CeladonCityText8: ; 0xa5c49
    db $0, "What are you", $4f
    db "staring at?", $57

_CeladonCityText9: ; 0xa5c63
    db $0, "Keep out of TEAM", $4f
    db "ROCKET's way!", $57

_CeladonCityText10: ; 0xa5c82
    db $0, "TRAINER TIPS", $51
    db "X ACCURACY boosts", $4f
    db "the accuracy of", $55
    db "techniques!", $51
    db "DIRE HIT jacks up", $4f
    db "the likelihood of", $55
    db "critical hits!", $51
    db "Get your items at", $4f
    db "CELADON DEPT.", $55
    db "STORE!", $57

_CeladonCityText11: ; 0xa5d18
    db $0, "CELADON CITY", $4f
    db "The City of", $55
    db "Rainbow Dreams", $57

_CeladonCityText13: ; 0xa5d41
    db $0, "CELADON CITY", $4f
    db "#MON GYM", $55
    db "LEADER: ERIKA", $51
    db "The Nature Loving", $4f
    db "Princess!", $57

_CeladonCityText14: ; 0xa5d82
    db $0, "CELADON MANSION", $57

_CeladonCityText15: ; 0xa5d93
    db $0, "Find what you", $4f
    db "need at CELADON", $55
    db "DEPT. STORE!", $57

_CeladonCityText16: ; 0xa5dbf
    db $0, "TRAINER TIPS", $51
    db "GUARD SPEC.", $4f
    db "protects #MON", $55
    db "against SPECIAL", $55
    db "attacks such as", $55
    db "fire and water!", $51
    db "Get your items at", $4f
    db "CELADON DEPT.", $55
    db "STORE!", $57

_CeladonCityText17: ; 0xa5e3e
    db $0, "Coins exchanged", $4f
    db "for prizes!", $55
    db "PRIZE EXCHANGE", $57

_CeladonCityText18: ; 0xa5e6a
    db $0, "ROCKET GAME CORNER", $4f
    db "The playground", $55
    db "for grown-ups!", $57

_FuchsiaCityText1: ; 0xa5e9c
    db $0, "Did you try the", $4f
    db "SAFARI GAME? Some", $55
    db "#MON can only", $55
    db "be caught there.", $57

_FuchsiaCityText2: ; 0xa5ede
    db $0, "SAFARI ZONE has a", $4f
    db "zoo in front of", $55
    db "the entrance.", $51
    db "Out back is the", $4f
    db "SAFARI GAME for", $55
    db "catching #MON.", $57

_FuchsiaCityText3: ; 0xa5f3e
    db $0, "ERIK: Where's", $4f
    db "SARA? I said I'd", $55
    db "meet her here.", $57

_FuchsiaCityText4: ; 0xa5f6b
    db $0, "That item ball in", $4f
    db "there is really a", $55
    db "#MON.", $57

_FuchsiaCityText5: ; 0xa5f96
    db $0, "!", $57

_FuchsiaCityText11: ; 0xa5f99
    db $0, "FUCHSIA CITY", $4f
    db "Behold! It's", $55
    db "Passion Pink!", $57

_FuchsiaCityText13: ; 0xa5fc1
    db $0, "SAFARI GAME", $4f
    db "#MON-U-CATCH!", $57

_FuchsiaCityText16: ; 0xa5fdc
    db $0, "SAFARI ZONE", $4f
    db "WARDEN's HOME", $57

_FuchsiaCityText17: ; 0xa5ff6
    db $0, "#MON PARADISE", $4f
    db "SAFARI ZONE", $57

_FuchsiaCityText18: ; 0xa6011
    db $0, "FUCHSIA CITY", $4f
    db "#MON GYM", $55
    db "LEADER: KOGA", $51
    db "The Poisonous", $4f
    db "Ninja Master", $57

INCBIN "baserom.gbc",$a6050,$a61e6 - $a6050

_CinnabarIslandText1: ; 0xa61e6
    db $0, "CINNABAR GYM's", $4f
    db "BLAINE is an odd", $55
    db "man who has lived", $55
    db "here for decades.", $57

_CinnabarIslandText2: ; 0xa622a
    db $0, "Scientists conduct", $4f
    db "experiments in", $55
    db "the burned out", $55
    db "building.", $57

_CinnabarIslandText3: ; 0xa6266
    db $0, "CINNABAR ISLAND", $4f
    db "The Fiery Town of", $55
    db "Burning Desire", $57

_CinnabarIslandText6: ; 0xa6298
    db $0, "#MON LAB", $57

_CinnabarIslandText7: ; 0xa62a2
    db $0, "CINNABAR ISLAND", $4f
    db "#MON GYM", $55
    db "LEADER: BLAINE", $51
    db "The Hot-Headed", $4f
    db "Quiz Master!", $57

_SaffronCityText1: ; 0xa62e7
    db $0, "What do you want?", $4f
    db "Get lost!", $57

_SaffronCityText2: ; 0xa6304
    db $0, "BOSS said he'll", $4f
    db "take this town!", $57

_SaffronCityText3: ; 0xa6324
    db $0, "Get out of the", $4f
    db "way!", $57

_SaffronCityText4: ; 0xa6339
    db $0, "SAFFRON belongs", $4f
    db "to TEAM ROCKET!", $57

_SaffronCityText5: ; 0xa635a
    db $0, "Being evil makes", $4f
    db "me feel so alive!", $57

_SaffronCityText6: ; 0xa637e
    db $0, "Ow! Watch where", $4f
    db "you're walking!", $57

_SaffronCityText7: ; 0xa639e
    db $0, "With SILPH under", $4f
    db "control, we can", $55
    db "exploit #MON", $55
    db "around the world!", $57

_SaffronCityText8: ; 0xa63df
    db $0, "You beat TEAM", $4f
    db "ROCKET all alone?", $55
    db "That's amazing!", $57

_SaffronCityText9: ; 0xa640f
    db $0, "Yeah! TEAM ROCKET", $4f
    db "is gone!", $55
    db "It's safe to go", $55
    db "out again!", $57

_SaffronCityText10: ; 0xa6445
    db $0, "People should be", $4f
    db "flocking back to", $55
    db "SAFFRON now.", $57

_SaffronCityText11: ; 0xa6475
    db $0, "I flew here on my", $4f
    db "PIDGEOT when I", $55
    db "read about SILPH.", $51
    db "It's already over?", $4f
    db "I missed the", $55
    db "media action.", $57

_SaffronCityText12: ; 0xa64d6
    db $0, "PIDGEOT: Bi bibii!@@"

_SaffronCityText13: ; 0xa64eb
    db $0, "I saw ROCKET", $4f
    db "BOSS escaping", $55
    db "SILPH's building.", $57

_SaffronCityText14: ; 0xa6518
    db $0, "I'm a security", $4f
    db "guard.", $51
    db "Suspicious kids I", $4f
    db "don't allow in!", $57

_SaffronCityText15: ; 0xa654f
    db $0, "...", $4f
    db "Snore...", $51
    db "Hah! He's taking", $4f
    db "a snooze!", $57

_SaffronCityText16: ; 0xa6577
    db $0, "SAFFRON CITY", $4f
    db "Shining, Golden", $55
    db "Land of Commerce", $57

_SaffronCityText17: ; 0xa65a6
    db $0, "FIGHTING DOJO", $57

_SaffronCityText18: ; 0xa65b5
    db $0, "SAFFRON CITY", $4f
    db "#MON GYM", $55
    db "LEADER: SABRINA", $51
    db "The Master of", $4f
    db "Psychic #MON!", $57

_SaffronCityText20: ; 0xa65f8
    db $0, "TRAINER TIPS", $51
    db "FULL HEAL cures", $4f
    db "all ailments like", $55
    db "sleep and burns.", $51
    db "It costs a bit", $4f
    db "more, but it's", $55
    db "more convenient.", $57

_SaffronCityText21: ; 0xa6667
    db $0, "TRAINER TIPS", $51
    db "New GREAT BALL", $4f
    db "offers improved", $55
    db "capture rates.", $51
    db "Try it on those", $4f
    db "hard-to-catch", $55
    db "#MON.", $57

_SaffronCityText22: ; 0xa66c7
    db $0, "SILPH CO.", $4f
    db "OFFICE BUILDING", $57

_SaffronCityText24: ; 0xa66e2
    db $0, "MR.PSYCHIC's", $4f
    db "HOUSE", $57

_SaffronCityText25: ; 0xa66f5
    db $0, "SILPH's latest", $4f
    db "product!", $51
    db "Release to be", $4f
    db "determined...", $57

_ItemUseBallText00:
	db 0,"It dodged the",$4F
	db "thrown BALL!",$51
	db "This #MON",$4F
	db "can't be caught!",$58

_ItemUseBallText01:
	db 0,"You missed the",$4F
	db "#MON!",$58

_ItemUseBallText02:
	db 0,"Darn! The #MON",$4F
	db "broke free!",$58

_ItemUseBallText03:
	db 0,"Aww! It appeared",$4F
	db "to be caught! ",$58

_ItemUseBallText04:
	db 0,"Shoot! It was so",$4F
	db "close too!",$58

_ItemUseBallText05:
	db 0,"All right!",$4F,"@",1
	dw $CFDA
	db 0," was",$55
	db "caught!@@"

_ItemUseBallText07:
	db 1
	dw $DE06
	db 0," was",$4F
	db "transferred to",$55
	db "BILL's PC!",$58

_ItemUseBallText08:
	db 1
	dw $DE06
	db 0," was",$4F
	db "transferred to",$55
	db "someone's PC!",$58

_ItemUseBallText06:
	db 0,"New #DEX data",$4F
	db "will be added for",$55,"@",1
	dw $CFDA
	db 0,"!@@"

INCBIN "baserom.gbc",$A685E,$4000 - $285E

SECTION "bank2A",DATA,BANK[$2A]

_ItemUseText001:
	db 0,$52," used@@"

_ItemUseText002:
	db 1
	dw $CF4B
	db 0,"!",$57

INCBIN "baserom.gbc",$A800F,$4000-$F

SECTION "bank2B",DATA,BANK[$2B]
INCLUDE "text/pokedex.tx"

SECTION "bank2C",DATA,BANK[$2C]

MoveNames: ; 4000
	db "POUND@"
	db "KARATE CHOP@"
	db "DOUBLESLAP@"
	db "COMET PUNCH@"
	db "MEGA PUNCH@"
	db "PAY DAY@"
	db "FIRE PUNCH@"
	db "ICE PUNCH@"
	db "THUNDERPUNCH@"
	db "SCRATCH@"
	db "VICEGRIP@"
	db "GUILLOTINE@"
	db "RAZOR WIND@"
	db "SWORDS DANCE@"
	db "CUT@"
	db "GUST@"
	db "WING ATTACK@"
	db "WHIRLWIND@"
	db "FLY@"
	db "BIND@"
	db "SLAM@"
	db "VINE WHIP@"
	db "STOMP@"
	db "DOUBLE KICK@"
	db "MEGA KICK@"
	db "JUMP KICK@"
	db "ROLLING KICK@"
	db "SAND-ATTACK@"
	db "HEADBUTT@"
	db "HORN ATTACK@"
	db "FURY ATTACK@"
	db "HORN DRILL@"
	db "TACKLE@"
	db "BODY SLAM@"
	db "WRAP@"
	db "TAKE DOWN@"
	db "THRASH@"
	db "DOUBLE-EDGE@"
	db "TAIL WHIP@"
	db "POISON STING@"
	db "TWINEEDLE@"
	db "PIN MISSILE@"
	db "LEER@"
	db "BITE@"
	db "GROWL@"
	db "ROAR@"
	db "SING@"
	db "SUPERSONIC@"
	db "SONICBOOM@"
	db "DISABLE@"
	db "ACID@"
	db "EMBER@"
	db "FLAMETHROWER@"
	db "MIST@"
	db "WATER GUN@"
	db "HYDRO PUMP@"
	db "SURF@"
	db "ICE BEAM@"
	db "BLIZZARD@"
	db "PSYBEAM@"
	db "BUBBLEBEAM@"
	db "AURORA BEAM@"
	db "HYPER BEAM@"
	db "PECK@"
	db "DRILL PECK@"
	db "SUBMISSION@"
	db "LOW KICK@"
	db "COUNTER@"
	db "SEISMIC TOSS@"
	db "STRENGTH@"
	db "ABSORB@"
	db "MEGA DRAIN@"
	db "LEECH SEED@"
	db "GROWTH@"
	db "RAZOR LEAF@"
	db "SOLARBEAM@"
	db "POISONPOWDER@"
	db "STUN SPORE@"
	db "SLEEP POWDER@"
	db "PETAL DANCE@"
	db "STRING SHOT@"
	db "DRAGON RAGE@"
	db "FIRE SPIN@"
	db "THUNDERSHOCK@"
	db "THUNDERBOLT@"
	db "THUNDER WAVE@"
	db "THUNDER@"
	db "ROCK THROW@"
	db "EARTHQUAKE@"
	db "FISSURE@"
	db "DIG@"
	db "TOXIC@"
	db "CONFUSION@"
	db "PSYCHIC@"
	db "HYPNOSIS@"
	db "MEDITATE@"
	db "AGILITY@"
	db "QUICK ATTACK@"
	db "RAGE@"
	db "TELEPORT@"
	db "NIGHT SHADE@"
	db "MIMIC@"
	db "SCREECH@"
	db "DOUBLE TEAM@"
	db "RECOVER@"
	db "HARDEN@"
	db "MINIMIZE@"
	db "SMOKESCREEN@"
	db "CONFUSE RAY@"
	db "WITHDRAW@"
	db "DEFENSE CURL@"
	db "BARRIER@"
	db "LIGHT SCREEN@"
	db "HAZE@"
	db "REFLECT@"
	db "FOCUS ENERGY@"
	db "BIDE@"
	db "METRONOME@"
	db "MIRROR MOVE@"
	db "SELFDESTRUCT@"
	db "EGG BOMB@"
	db "LICK@"
	db "SMOG@"
	db "SLUDGE@"
	db "BONE CLUB@"
	db "FIRE BLAST@"
	db "WATERFALL@"
	db "CLAMP@"
	db "SWIFT@"
	db "SKULL BASH@"
	db "SPIKE CANNON@"
	db "CONSTRICT@"
	db "AMNESIA@"
	db "KINESIS@"
	db "SOFTBOILED@"
	db "HI JUMP KICK@"
	db "GLARE@"
	db "DREAM EATER@"
	db "POISON GAS@"
	db "BARRAGE@"
	db "LEECH LIFE@"
	db "LOVELY KISS@"
	db "SKY ATTACK@"
	db "TRANSFORM@"
	db "BUBBLE@"
	db "DIZZY PUNCH@"
	db "SPORE@"
	db "FLASH@"
	db "PSYWAVE@"
	db "SPLASH@"
	db "ACID ARMOR@"
	db "CRABHAMMER@"
	db "EXPLOSION@"
	db "FURY SWIPES@"
	db "BONEMERANG@"
	db "REST@"
	db "ROCK SLIDE@"
	db "HYPER FANG@"
	db "SHARPEN@"
	db "CONVERSION@"
	db "TRI ATTACK@"
	db "SUPER FANG@"
	db "SLASH@"
	db "SUBSTITUTE@"
	db "STRUGGLE@"
