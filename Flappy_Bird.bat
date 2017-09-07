:    Flappy Bird Coded In Batch: Another example using Seta:DSP, Seta:GPU
:    Copyright (C) 2013,2014  Honguito98
:
:    This program is free software: you can redistribute it and/or modify
:    it under the terms of the GNU General Public License as published by
:    the Free Software Foundation, either version 3 of the License, or
:    (at your option) any later version.
:
:    This program is distributed in the hope that it will be useful,
:    but WITHOUT ANY WARRANTY; without even the implied warranty of
:    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:    GNU General Public License for more details.
:
:    You should have received a copy of the GNU General Public License
:    along with this program.  If not, see README.TXT
@Echo Off
	Setlocal EnableExtensions EnableDelayedExpansion
	Set ANSICON_EXC=nvd3d9wrap.dll;nvd3d9wrapx.dll
	If "%1" Neq "LoadANSI" (
		SetLocal
		Core\Bin\Ansi.dll "%~0" LoadANSI
		EndLocal
		Exit
	)
	Call :Flush
	Set "Game=%~0"
	Set "Fn=Core\Bin\Fn.dll"
	Set "Dsp=Core\Bin\Dsp.dll"
	Set "C=Core\Chr"
	Set "P=Core\Palette"
	Set "Dip=<Nul Set/p="
	Set "Delims_1=#$FDSGK\OO"
	Set "Delims_2=ÿd}TRBFd][K"
	Set "PDsp=>Nul 2>&1 Start /b Cmd /C %Dsp% Core\Effects.sdsp -d -q trim"
	!Fn! Font 1
	!Fn! Cursor 0
	Mode 50,45
	Echo;[1;31m[24;15H Loading Game[1;33m[25;17H Please Wait...
	For %%a in (
	"ScoreUp:0 =0.697"
	"Select:0.697 =0.741"
	"Fly:0.744 =1.013"
	"Hit:1.018 =1.412"
	"Dead:1.418 =2.115"
	"Swooshing:2.130 =2.673"
	) Do (
		For /F "Tokens=1-2 Delims=:" %%x in ("%%~a") Do Set "%%x=%%y"
	)
	For %%a in (Sky_Blue;Orange) Do %P%\%%a.pal
	Set/p BScore=<Core\Sc.dat
	For %%A in (1;2) Do For %%C in ("!Delims_%%A!") Do Set "BScore=!BScore:%%~C=!"

	For %%C in (1;2) Do Type Core\Sc.dat|Find "!Delims_%%C!" >Nul || (
		Echo;!Delims_1!0!Delims_2!>Core\Sc.dat
		Set BScore=0
	)
	Title Flappy Bird - Text Mode

	Set Ticks=950000
	Set Delay=10
	Set "start=!time!"
	For /L %%N in (1 1 !Ticks!) do rem
	Set "stop=!time!"
	For /F "Tokens=3,4 Delims=:.," %%A in ("!start!") do set /a start=1%%A%%B-10000
	For /F "Tokens=3,4 Delims=:.," %%A in ("!stop!") do set /a stop=1%%A%%B-10000
	If !start! gtr !stop! set /a stop+=6000
	Set/a "RemDelay=(!Delay!*!Ticks!/(!Stop!-!Start!)/10)-1800"
	Cls
	:Main_
	Color b3
	%Dip%[10;1H
	Type %C%\Logo.chr
	%Dip%[38;1H
	Type %C%\Floor.chr
	%Dip%[20;1H
	Type %C%\Options.chr
	%Dip%[0;5;46;32m
	%Dip%[30;7HCopyright (C^) Dong Nguyen 2013, 2014
	%Dip%[31;10H Copyright (C^) Honguito98 2014
	Set Sel=1
	:Main
	If !Sel! Equ 1 (
		%Dip%[0;5;46;31m
		%Dip%[21;10H._______.
		%Dip%[22;10HÝ       Ý
		%Dip%[23;10HÝ      Ý
		%Dip%[24;10HÝ_______Ý
	) Else (
		%Dip%[0;5;46;31m
		%Dip%[21;29H._______.
		%Dip%[22;29HÝ  [1]  Ý
		%Dip%[23;29HÝ[3] [2]Ý
		%Dip%[24;29HÝ_______Ý
	)
	%Fn% kbd
	If !Errorlevel! Equ 332 (
		%PDsp% !Select!
		Set/a Sel=2
	)
	If !Errorlevel! Equ 330 (
		Set/a Sel=1
		%PDsp% !Select!
	)
	If !Errorlevel! Equ 32 (
		If !Sel! Equ 1 Goto :Start
		If !Sel! Equ 2 Goto :Score_s
	)
	%Dip%[20;1H
	Type %C%\Options.chr
	Goto :Main
	
	:Start
	Call :Shade
	%Fn% Sleep 100
	Set N=0
	For %%X in (Bird;F[;N[;N;Pipe;) Do (
		For /F "Tokens=1 Delims==" %%a in ('Set^|Findstr /B "%%X"') Do Set "%%a="
	)
	For /F "Delims=" %%a in ('Type %C%\Numbers.chr') Do (
		Set/a N+=1
		Set N[!N!]=%%a
	)
	Set/a Col=0,N_=0
	For /L %%a in (0,1,9) Do (
		For /L %%b in (1,1,%N%) Do (
			For /F "Tokens=1-2" %%c in ("!Col! !N_!") Do Set N%%a=!N%%a!!N[%%b]:~%%c,3![3D[B
		)
		Set N%%a=!N%%a![5A[4C
		Set/a Col+=3+1,N_+=1
	)
	For /L %%a in (1,1,%N%) Do Set N[%%a]=
	Set N=&Set Col=&Set N_=

	Set Ln=0
	For %%O in (Bird;
	Pipe_Up_1;Pipe_Dn_1;
	Pipe_Up_2;Pipe_Dn_2;
	Pipe_Up_3;Pipe_Dn_3;
	Pipe_Up_4;Pipe_Dn_4;
	Pipe_Up_5;Pipe_Dn_5;
	) Do (
		For /F "Delims=" %%a in ('Type %C%\%%O.chr') Do Set %%O=!%%O!%%a
	)
	For /F "Delims=" %%a in ('Type %C%\Floor_Bg.chr') Do (
		Set/a Ln+=1
		Set "F[!Ln!]=%%a"
	)
	Set Ln=
	Color b7
	%Dip%[38;1H
	Type %C%\Floor.chr
	%Dip%[10;1H[5;1;46;31m
	Type %C%\Ready.chr
	Rem Y.X
	Set Pipe_Up_1.Size=15
	Set Pipe_Dn_1.Size=14
	Set Pipe_Up_2.Size=7
	Set Pipe_Dn_2.Size=23
	Set Pipe_Up_3.Size=18
	Set Pipe_Dn_3.Size=8
	Set Pipe_Up_4.Size=23
	Set Pipe_Dn_4.Size=12
	Set Pipe_Up_5.Size=5
	Set Pipe_Dn_5.Size=30
	Rem Set>tmp.txt
	Set/a Fbc=0,ToDwn=6,ToDwnC=0,Score=0,NextP=30,NextPC=0,Float=2,FloatC=0,Clock=0
	Set Up=Off
	Set Block=On
	Rem Y.X
	Rem Pipe_Up = pipe with hole up
	Rem Pipe_Dn = pipe with hole dn
	Rem Sprites: 
	::  Pipe[U][Type].pos=
	::  Pipe[D][Type].pos=
	:: Lenghts:
	::  Pipe[U]
	Set Bird.Pos=25.10
	Set Pipes=;
	For /F "Tokens=1-2 Delims=." %%X in ("!Bird.Pos!") Do Set/a Y=%%X,X=%%Y
	Call :ScoreTab

	:Game
	For /L %%! in (1,1,255) Do (
		For /L %%d in (1,1,%RemDelay%) Do Rem
		%Fn% _Kbd
		If !Errorlevel! Equ 32 (
			If !Block! Equ On (
				Set Block=Off
				%Dip%[10;1H[5;1;46;36m
				Type %C%\Ready.chr
			)
			%PDsp% !Fly!
			Set Up=On
			Set ToDwnC=0
		)
		If !Errorlevel! Equ 27 (
			Exit
		)
		If Not !Block! Equ On (
			For /F "Tokens=1-2 Delims=." %%X in ("!Bird.Pos!") Do (
				If !Up! Equ On (
					If Not %%X Leq 1 (
						Set/a Y=%%X-1,X=%%Y
						Set Bird.Pos=!Y!.!X!
						Echo;%Bird%
					)
				) Else (
					Rem If !FloatC! Geq !Float! (
						Set/a Y=%%X+1,X=%%Y,FloatC=0
						If %%X Geq 38 Goto :Over_2
						Set Bird.Pos=!Y!.!X!
						Echo;%Bird%
					Rem )
				)
				If !ToDwnC! Geq !ToDwn! (
					Set Up=Off
					Set ToDwnC=0
				)
			)
		) Else Echo;%Bird%
		%== More Speed ==%
		For %%t in (
			50 100 150 200 250 300 350
			400 450 500 550 600 650 700 750
			800 850 900 1200 1300 1400 1500
		) Do If !Clock! Equ %%t Set/a NextP-=1

		%== Random Pipes ==%
		If Not !Block! Equ On (
			If !NextPC! Geq !NextP! (
				Set/a Rnd=!Random!%%5,NextPC=0
				Rem Set/a Rnd=0,NextPC=0
				If !Rnd! Equ 0 (
					Set Pipe_Up_1.Pos=!Pipe_Up_1.Pos!22.40,
					Set Pipe_Dn_1.Pos=!Pipe_Dn_1.Pos!1.40,
				)
				If !Rnd! Equ 1 (
					Set Pipe_Up_2.Pos=!Pipe_Up_2.Pos!36.40,
					Set Pipe_Dn_2.Pos=!Pipe_Dn_2.Pos!1.40,
				)
				If !Rnd! Equ 2 (
					Set Pipe_Up_3.Pos=!Pipe_Up_3.Pos!16.40,
					Set Pipe_Dn_3.Pos=!Pipe_Dn_3.Pos!1.40,
				)
				If !Rnd! Equ 3 (
					Set Pipe_Up_4.Pos=!Pipe_Up_4.Pos!20.40,
					Set Pipe_Dn_4.Pos=!Pipe_Dn_4.Pos!1.40,
				)
				If !Rnd! Equ 4 (
					Set Pipe_Up_5.Pos=!Pipe_Up_5.Pos!36.40,
					Set Pipe_Dn_5.Pos=!Pipe_Dn_5.Pos!1.40,
				)
				For /L %%# in (1,1,5) Do (
					If Defined Pipe_Up_%%#.Pos (
						Set "Pipes=!Pipes:Pipe_Up_%%#;Pipe_Dn_%%#;=!Pipe_Up_%%#;Pipe_Dn_%%#;"
					)
				)
			)
		)
		
		%== Collitions And Plain Logic ==%
		For %%A in (!Pipes!) Do (
			For %%B in (!%%A.Pos!) Do (
				For /F "Tokens=1-2 Delims=." %%C in ("%%B") Do (
					Set/a X=%%D,Y=%%C
					For %%E in ("!%%A!") Do Echo;[0;5;46;32m%%~E[H
					
					%== Compare Bird.Pos With Current Pipe_Type_N.Pos ==%
					For /F "Tokens=1-2 Delims=." %%X in ("!Bird.Pos!") Do (
						Rem X_= Bird size by X;  X__= Pipe size by X
						Rem Y_= Bird size by Y;  Y__= Pipe size by Y
						Set "Tmp_=%%~A"
						Set/a X_=%%Y+4,X__=!X!+5,Y_=%%X+4,Y__=!Y!+!%%A.Size!-1
						If "!Tmp_:~0,7!" Equ "Pipe_Up" (
							If !X_! Gtr !X! If %%Y Lss !X__! If !Y_! Geq !Y! If %%X Leq !Y__! (
								Call :GetPipe "%%A"
								Rem Title Pipe_Up
								Goto :Over_1
							)
						) Else (
							If !X_! Gtr !X! If %%Y Lss !X__! If %%Y Geq !Y! If !Y_! Leq !Y__! (
								Rem Title Pipe_Dn
								Call :GetPipe "%%A"
								Goto :Over_1
							)
						)
						If %%Y Equ !X! (
							If !NSc! Neq On (
								%== Extra Point ==%
								Set/a Score+=1
								%PDsp% !ScoreUp!
								Call :ScoreTab
								Set Nsc=On
							)
						)
					)
					Set/a X-=1
					If !X! Leq 1 ( 
						Set %%A.Pos=!%%A.Pos:%%C.%%D,=!
						If "!%%A.Pos!" Equ "," (
							Set Pipes=!Pipes:%%A=!
							Set %%A.Pos=
						)
						For %%E in ("!%%A!") Do Echo;[5;1;46;36m%%~E[H
					) Else (
						For %%X in (!X!) Do (
							Set %%A.Pos=!%%A.Pos:%%C.%%D,=%%C.%%X,!
						)
					)
				)
			)
		)
		
		
		%== Floor Bg Graphic rendering ==%
		Set/a Fbc+=17,ToDwnC+=1,NextPC+=1,FloatC+=1,Clock+=1
		Set NSc=Off
		If !Fbc! Geq 834 Set Fbc=0
		For %%F in (!Fbc!) Do (

			Rem Echo:[1;1H[0;37mDebug: !Pipes!_ !pipe_dn_1.pos!
			Echo;[1;5;46;37m[2;23H!Score_![38;1H!F[1]:~%%F,834![39;1H!F[2]:~%%F,834![40;1H!F[3]:~%%F,834![41;1H!F[4]:~%%F,834!
		)
	)
	Goto :Game
	:ScoreTab
	Set Score_=!Score!
	For /L %%a in (0,1,9) Do Set Score_=!Score_:%%a=_%%a!
	For /L %%a in (0,1,9) Do (
		For %%c in ("!N%%a!") Do Set "Score_=!Score_:_%%a=%%~c!"
	)
	Goto :Eof
	:GetPipe
	Set Tmp_=%~1
	For %%t in (Dn;Up) Do (
		If %%t Equ Dn (Set "Tmp_=!Tmp_:Dn=Up!") Else (Set "Tmp_=!Tmp_:Up=Dn!")
		For %%O in ("!Tmp_!") Do (
			For /F "Tokens=1-2 Delims=.," %%a in ("!%%~O.Pos!") Do (
				Set/a X=%%b,Y=%%a 2>Nul
				Set Pipe_Bg_%%t.Pos=!Y!.!X!
				For %%H in ("!%%~O!") Do Set Pipe_Bg_%%t=[0;5;46;32m%%~H[H
			)
		)
	)
	Goto :Eof

	:Over_1
	%PDsp% !Hit!
	%PDsp% !Dead!
	:Over_1_
	For %%t in (Up;Dn) Do (
		For /F "Tokens=1-2 Delims=." %%X in ("!Pipe_Bg_%%t.Pos!") Do (
			Set/a X=%%Y,Y=%%X
			For %%a in ("!Pipe_Bg_%%t!") Do Echo;%%~a
		)
	)
	For /F "Tokens=1-2 Delims=." %%X in ("!Bird.Pos!") Do (
		Set/a X=%%Y,Y=%%X+1
		Set Bird.Pos=!Y!.!X!
	)
	Echo;%Bird%
	If Not !Y! Geq 39 Goto :Over_1_
	For %%t in (Up;Dn) Do (
		For /F "Tokens=1-2 Delims=." %%X in ("!Pipe_Bg_%%t.Pos!") Do (
			Set/a X=%%Y,Y=%%X
			For %%a in ("!Pipe_Bg_%%t!") Do Echo;%%~a
		)
	)
	Goto :Score_v

:Over_2
	%PDsp% !Hit!
	:Score_v
	%PDsp% !Swooshing!
	%Fn% Sleep 500
	%Dip%[5;1;46;31m[10;1H
	Type %C%\GameOver_Logo.Chr
	Type %C%\Score.chr
	%Dip%[20;36H!Score!

	If !Score! Gtr 10 Type %C%\Bronze.chr
	If !Score! Gtr 20 Type %C%\Silver.chr
	If !Score! Gtr 30 Type %C%\Gold.chr
	If !Score! Gtr 40 Type %C%\Platinum.chr

	If !Score! Gtr !BScore! (
		Set BSCore=!Score!
		Set BSCore_=!Score!
		%Dip%[25;36H!BScore![23;29HNEW
		For /L %%# in (0,1,9) Do (
			For /F "Tokens=1-2 Delims=;" %%C in ("!Delims_1!;!Delims_2!") Do Set "BSCore_=!BScore_:%%#=%%C%%#%%D!"
		)
		Echo;!BSCore_!>Core\Sc.dat
	) Else %Dip%[25;36H!BScore!
	Pause>nul
	Goto :Start
	:Score_s
	Call :Shade
	%Fn% Sleep 250
	Color b7
	%Dip%[38;1H
	Type %C%\Floor.chr
	%Dip%[5;1;46;31m[10;1H
	Type %C%\Score_Logo.Chr
	Type %C%\Score.chr
	%Dip%[20;36H!Score![25;36H!BScore!
	
	If !Score! Geq 10 Type %C%\Bronze.chr
	If !Score! Geq 20 Type %C%\Silver.chr
	If !Score! Geq 30 Type %C%\Gold.chr
	If !Score! Geq 40 Type %C%\Platinum.chr
	:Score_s_
	%Fn% Kbd
	If !Errorlevel! Neq 32 Goto :Score_s_
	Call :Shade
	%Fn% Sleep 250
	Goto :Main_
	:Shade nocls
	For %%a in (
	8f 8f 8f 8f 87 87 87 87 0f 0f 0f 0f
	07 07 07 07 08 08 08 08
	) Do (
		For /L %%# in (1,1,3000) Do Rem
		Color %%a
	)
	If /i "%1" Neq "NoCls" Cls
	Goto :Eof
	:Flush
	For /f "Tokens=1 Delims==" %%a in ('Set') Do (
	If /i "%%a" Neq "Comspec" (
	If /i "%%a" Neq "Tmp" (
	If /i "%%a" Neq "Userprofile" (
	IF /i "%%a" Neq "SystemRoot" (
	IF /i "%%a" Neq "Game" (
	IF /i "%%a" Neq "SystemDrive" (
	Set "%%a="))))))
	)
	Set "Path=%comspec:~0,-8%;%SystemRoot%;%Comspec:~0,-8%\Wbem"
	Goto :Eof