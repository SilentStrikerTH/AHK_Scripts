#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon


<!j::Left  ;Left Alt + j = Left ArrowSELECTED
<!k::Down  ;Alt + k = Down Arrow
<!i::Up    ;Alt + i = Up Arrow
<!l::Right ;Alt + l = Right Arrow
<!u::Home  ;Alt + u = Homw
<!o::End  ;Alt + o = End
<!Enter::Enter ;Enter retains function through Alt press
LShift::SelectCurrentWord() ;Double tap Left Shift


;Selects the word to the left of the cursor
SelectCurrentWord() {
    if (A_PriorHotkey != "LShift" or A_TimeSincePriorHotkey > 250) {
        send "{LShift down}"
        KeyWait "LShift"
        send "{LShift up}"
        return
    }
    send "^{Left}"
    send "^+{Right}"
}

;PyCharm
#HotIf WinActive("ahk_exe pycharm64.exe")
<!Space::+F10 ;Alt + Space = Shift F10
#HotIf

;Visual Studio
#HotIf WinActive("ahk_exe devenv.exe")
<!Space::^F5 ;Alt + Space = Control F5
<!;::Send "{End};" ;Alt + ; = Move to end and add a ";"
#HotIf
