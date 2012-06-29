#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Icon, ampGreen.ico
Menu, Tray, Tip, Html Code Converter
Letters = 0¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ
OddLetters = 0ŒœŠšŸƒ–—‘’‚“”„†‡•…‰€™
FixChars = ░▒▓■□▪▫▬

AutoTrim, Off
!c::
    cb := clipboardAll
    clipboard = ;clear the clipboard
    Send ^x
    clipwait, 1
    Selected = %clipboard%
    StringGetPos, pos, Selected, %A_Tab%

    clipboard =
    clipboard := "`t"
    ClipWait
    
    ; Fix control/odd characters
    StringReplace, Selected, Selected, #, ░, 1
    StringReplace, Selected, Selected, !, ▒, 1
    StringReplace, Selected, Selected, ^, ▓, 1
    StringReplace, Selected, Selected, +, ■, 1
    StringReplace, Selected, Selected, {, □, 1
    StringReplace, Selected, Selected, }, ▪, 1
    StringReplace, Selected, Selected, %A_Tab%, ▫, 1
    StringReplace, Selected, Selected, %A_Space%, ▬, 1
    
    ; fixes new lines being doubled from clipboard
    StringReplace,Selected,Selected,`n,,1

    Loop, Parse, Selected
    {
        test := ParseChar(A_LoopField)
        if (test != 0){
            Send &{#}%test%{;}
        } else {
            StringGetPos, pos, FixChars, %A_LoopField%

            if (pos = -1){
                Send %A_LoopField%
            } else if (pos = 0){
                Send {#}
            } else if (pos = 1){
                Send {!}
            } else if (pos = 2){
                Send {^}
            } else if (pos = 3){
                Send {+}
            } else if (pos = 4){
                Send {{}
            } else if (pos = 5){
                Send {}}
            } else if (pos = 6){
                Send, ^v
            } else if (pos = 7){
                Send {Space}
            }
        }
    }
    Sleep, 5000
    clipboard := cb ;restore the clipboard's contents
Return

Parsechar(c)
{
    global
    num = 0
    StringGetPos, pos, Letters, %c%
    if (pos > 0){
        num := pos + 160
    } else {
        StringGetPos, pos, OddLetters, %c%
        if (pos = 1 || pos = 2){
            num := pos + 337
        } else if (pos = 3 || pos = 4){
            num := pos + 349 ;351 - 2
        } else if (pos = 5){
            num := 376
        } else if (pos = 6){
            num := 402
        } else if (pos = 7 || pos = 8){
            num := pos + 8204 ;8210 - 6
        } else if (pos = 9 || pos = 10 || pos = 11){
            num := pos + 8207 ;8215 - 8
        } else if (pos = 12 || pos = 13 || pos = 14){
            num := pos + 8208 ;8219 - 11
        } else if (pos = 15 || pos = 16 || pos = 17){
            num := pos + 8209 ;8223 - 14
        } else if (pos = 18){
            num := 8230
        } else if (pos = 19){
            num := 8240
        } else if (pos = 20){
            num := 8364
        } else if (pos = 21){
            num := 8482
        }
    }
    
    return %num%
}