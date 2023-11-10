#Requires AutoHotkey v2.0
#NoTrayIcon


<!j::Left  ;Left Alt + j = Left Arrow
<!k::Down  ;Alt + k = Down Arrow
<!i::Up    ;Alt + i = Up Arrow
<!l::Right ;Alt + l = Right Arrow
<!u::Home  ;Alt + u = Page Up
<!o::End  ;Alt + o = Page Down
<!Enter::Enter ;Enter retains function through Alt press

#HotIf WinActive("ahk_exe pycharm64.exe")
<!Space::+F10 ;Alt + Space = Shift F10 (for pycharm)
#HotIf

#HotIf WinActive("ahk_exe devenv.exe")
<!Space::^F5 ;Alt + Space = Shift F10 (for Visual Studio)
#HotIf