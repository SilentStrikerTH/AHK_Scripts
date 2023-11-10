#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon
SendMode "Input"
; Written by SilentStrikerTH


class ClipboardManager {
    contents := Array()

    menu := Menu()

    ; Params
    clipboardMaxEntries := 7 ; How many entries it will store at a time (Don't go beyond 9, idk what will happen)
    displayMaxLength := 25  ; How many characters of an item the menu will display

    _genMenu() {
        displayItem(item) {
            ; Return the first {displayMaxLength} letters of the item and ""..." if it is longer
            if (StrLen(item) > this.displayMaxLength) {
                Return (SubStr(item, 1, this.displayMaxLength) . "...")
            } else {
                Return SubStr(item, 1, this.displayMaxLength)
            }
        }
        pasteItem(itemName, itemNumber, *) {
            ; I use this instead of "Send"ing the actual text because Windows clipboard works instantaneously.
            SavedClip := ClipboardAll()  ; Hold the previous contents of the clipboard
            A_Clipboard := RegExReplace(this.contents[itemNumber], "\r\n?|\n\r?", "`n")  ; Put the item in the clipboard and replace the additional newlines that Windows adds
            Send '^v'  ; Paste from clipboard
            Sleep 100  ; Wait 100ms (Buffer or else the next command runs before paste occurs)
            A_Clipboard := SavedClip  ; Return the contents to the clipboard
        }
        clearClipboard(*) {
            this.contents := []
        }
        doNothing(*) {
        }


        this.menu.Delete()  ; Remake list
        if (this.contents.Length = 0) {
            this.menu.Add("Clipboard is empty!", doNothing)
            this.menu.Disable("Clipboard is empty!")
        } else {
            counter := 0
            for (item in this.contents) {
                counter := counter + 1  ; This counter provides number shortcuts for each item in the menu
                this.menu.Add("&" . counter . ": [ " . displayItem(item) . " ]", pasteItem)  ; The "&"" makes an Alt key shortcut for the item
            }
            this.menu.Add()  ; Separator
            this.menu.Add("&X: Clear clipboard", clearClipboard)
        }
        this.menu.Show()
    }

    Copy() {
        SavedClip := ClipboardAll()  ; Hold the previous contents of the clipboard
        A_Clipboard := ""  ; Clear the clipboard
        Send '^c'
        
        if (!ClipWait(0.5)) {
            ; Check for error in clipping
            A_Clipboard := SavedClip  ; Return the contents to the clipboard
            Return
        }
        MyText := A_Clipboard
        A_Clipboard := SavedClip  ; Return the contents to the clipboard
        this._saveEntry(MyText)  ; Save the text to the contents Array
    }

    _saveEntry(newEntry) {
        contentsFull := this.contents.Length = this.clipboardMaxEntries  ; If the contents Array contains 5 entries this is True
        for item in this.contents  ; Check if the newEntry already exists in the contents Array
            if (item = newEntry) {  ; If it does exist, then return
                Return
            }
        if (contentsFull) {  ; If the contents Array is full, remove the oldest item
            this.contents.RemoveAt(this.clipboardMaxEntries)
        }
        this.contents.InsertAt(1, newEntry)  ; Add the item to the contents Array
    }

    Paste() {
        this._genMenu()  ; Generate and show the paste menu
    }
}


; Initialize new ClipboardManager object
clipboard := ClipboardManager()

; Set keybinds
<!c:: {  ; Alt + C
    clipboard.Copy()
}
<!v::{  ; Alt + V
    clipboard.Paste()
}
