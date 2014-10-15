#NoEnv
#include class InsertBinToPNG.ahk
SetWorkingDir %A_ScriptDir%

BinInPNG.init()
BinInPNG.selectPic("F:\nigh\ahk_git\AutoHotkey.net-Website-Generator\Resources\Picturesque Green\Background.jpg")
Loop, 8
msgbox, % BinInPNG.getChar(A_Index)

; file1:=new binMsg("main.ahk")
; file1.addOffset(1)
; loop, % file1.length
; output.=chr(file1.content[A_Index])

; Msgbox, % output
