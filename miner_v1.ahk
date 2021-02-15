#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen


SetKeyDelay, 250
SetDefaultMouseSpeed, 100
SetControlDelay 5

InteliSleep(sec)
{
   GuiControl +Range0-%sec%,MyProgress
   GuiControl,, MyProgress, 0
   cnt := 0
   mvtime := 0
   Random, mvtime, 10, 60
   Loop, %sec%
   {
		cnt := cnt + 1
		if cnt >= %mvtime%
		{
			Random, randx, 1, 1279
			Random, randy, 1, 1023
			MouseMove, %randx%, %randy%
			Random, mvtime, 10, 60
			cnt := 0
		}
		Sleep, 1000
		GuiControl,, MyProgress, +1
   }
}

movemouse(x,y){
	global silent
	if(!silent)
		WinActivate, EVE 
	MouseGetPos, curx, cury
	devx := round((abs(x-curx)/2))
	devy := round((abs(y-cury)/2))
	Loop{
		adx := round(0.3*abs(devx - abs(devx-abs(curx-x)))+1)
		ady := round(0.3*abs(devy - abs(devy-abs(cury-y)))+1)
		if(x < curx) 
			curx-=adx
		if(x > curx) 
			curx+=adx
		if(y < cury)
			cury-=ady
		if(y > cury)
			cury+=ady
		if(abs(x-curx)<3 and abs(y-cury)<3)
			break
		if(silent)
			controlclick,,EVE,,,0,% "NA x" curx " y" cury
		else
			MouseMove, curx, cury
		random, rnd, 20, 60
		sleep, %rnd%		
	}
	;MouseMove, x, y
}


checkcargo(cargofull)
{
Send {Alt down}
Sleep,1000
Send {c}
Sleep,1000
Send {Alt up}
Sleep,1000
PixelGetColor, color1, 900,443
if (color1>0x505050)
{
	cargofull=1	
}	

Send {Alt down}
InteliSleep(2)
Send {c}
InteliSleep(1)
Send {Alt up}

return cargofull
}

docktobase()
{
;Return to base
movemouse(164,779)
Sleep,1000
MouseClick, right,164,779
Sleep,1000
movemouse(204,788)
Sleep,1000
MouseClick,left,204,788
Sleep,65000 	;Wait for warping
}

microwarp()
{
movemouse(1107,979)
InteliSleep(1)
MouseClick, left ,1107,979
InteliSleep(1)
}

ActivateEve()
{
   WinWait, EVE, 
   IfWinNotActive, EVE, , WinActivate, EVE, 
   WinWaitActive, EVE,   
}


cargofull=0
Loop
{

ActivateEve()
;Undock
movemouse(1732,174)
Sleep,1000
MouseClick, left, 1736, 174
Sleep, 13000

;Go to the belt
movemouse(82,123)
Sleep,1500
MouseClick, right,82,123
Sleep,1500
movemouse(143,164) ;1)164 2)182 7)322
Sleep,1500
movemouse(286,325)
Sleep,1500
movemouse(443,326) 
Sleep,1500
MouseClick, left, 443,326
Sleep,50000 	;Wait for warping

;Mine the asteroids
movemouse(1817,474)
Sleep,1000
MouseClick, left,1817,474 ;Open Mining tab
Sleep,1000
movemouse(1558,513)	;choose top asteroid
Sleep,1000
Send ^{Click} ;Lock target
Sleep,1000
movemouse(1555,517)
Sleep,1000
MouseClick, right, 1558,513	;open up approach panel
Sleep,1000
movemouse(1594,534)
Sleep,1000
MouseClick, left, 1594,534	;Click Approach


microwarp()

;send drones out
Send {Shift down}
Sleep,1000
Send {f}
Sleep,1000
Send {Shift up}
InteliSleep(1)
Send {f}


;movemouse to microwarp and click
InteliSleep(45)
Send {LCtrl down}
InteliSleep(1)
Send {Space}
InteliSleep(1)
Send {LCtrl up}
InteliSleep(2)
microwarp()
movemouse(1412,386)

;movemouse(1078,921)
;InteliSleep(1)
;MouseClick, left, 1078,920	;activate laser1
;InteliSleep(1)
;movemouse(1132,932)		;activate laser2
;InteliSleep(1)
;MouseClick, left, 1132,932

Send {1}
InteliSleep(1)
Send {2}
InteliSleep(1)


while(cargofull =0)
{
InteliSleep(120)			;wait for the mine


;deactivate lasers first
;movemouse(1078,921)
;;Sleep,1000
;MouseClick, left, 1078,920	;activate laser1
;Sleep,1000
;movemouse(1132,932)		;activate laser2
;Sleep,1000
;MouseClick, left, 1132,932
InteliSleep(2)
Send {1}
InteliSleep(1)
Send {2}
InteliSleep(1)


Send {Alt down}
Sleep,1000
Send {c}
Sleep,1000
Send {Alt up}
Sleep,1000
PixelGetColor, color1, 842,438
if (color1>0x505050)
{
	cargofull=1	
}	

Send {Alt down}
InteliSleep(2)
Send {c}
InteliSleep(1)
Send {Alt up}


if (cargofull=0)
{
;check mine again

movemouse(1558,513)	;choose top asteroid
Sleep,1000
Send ^{Click} ;Lock target

;activate lasers back
;movemouse(1078,921)
;Sleep,1000
;MouseClick, left, 1078,920	;activate laser1
;Sleep,1000
;movemouse(1132,932)		;activate laser2
;Sleep,1000
;MouseClick, left, 1132,932
Send {1}
InteliSleep(1)
Send {2}
InteliSleep(4)
Send {f}
InteliSleep(1)
}
}

;Drones return to bay
Send {r}
InteliSleep(10)

docktobase()


Send {Alt Down}
InteliSleep(2)
Send {c}
InteliSleep(2)
Send {Alt Up}
InteliSleep(2)
PixelGetColor, color1, 726, 665
while (color1>0x505050)
{
	movemouse(1421,960)
	send {click down}
	movemouse(743,702)
	send {click up}
	InteliSleep(2)	

	movemouse(770,719)
	send {click down}
	movemouse(1750,790)
	send {click up}
	InteliSleep(2)

	;MouseClickDrag, left, 770, 719, 1750, 790 , 100
	;InteliSleep(4)
	;MouseClickDrag, left, 770, 719, 1750, 790 , 100
	;InteliSleep(4)
	;MouseClickDrag, left, 770, 719, 1750, 790 , 100
	;InteliSleep(10)
	MouseClick, right, 1750,790
	InteliSleep(2)
	movemouse(1816,863)
	InteliSleep(1)
	MouseClick, left, 1816, 863
	PixelGetColor, color1, 726, 665
}

Send {Alt Down}
InteliSleep(2)
Send {c}
InteliSleep(2)
Send {Alt Up}

cargofull=0

}



Esc::exitapp


