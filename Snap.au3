#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <ScreenCapture.au3>
#include <WindowsConstants.au3>
#include <Date.au3>
#include <File.au3>
#include <TrayConstants.au3>

Opt("TrayMenuMode", 3) ; Items are not checked when selected.
;#NoTrayIcon

TraySetToolTip("Take screenshot or copy clipboard")
TraySetIcon("shell32.dll", -44)

_Main()

Func _Main()

	Local $button_save, $buttonNotepad,$buttonclose

	GUICreate("Startbar", 120, 45,80,0,$WS_POPUP,$WS_EX_TOPMOST)

	$buttonNotepad=GUICtrlCreateButton("&Notepad", 1, 3, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "shell32.dll", 2)
    $button_save = GUICtrlCreateButton("&Save", 40, 3, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "shell32.dll", 7)
    $buttonclose = GUICtrlCreateButton("&close", 80, 3, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "shell32.dll", 28)
	GUISetState()

	; Run the GUI until the dialog is closed
	While 1

		Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $button_save
					Capture()
			Case $buttonNotepad
					Notepad()
			Case $buttonclose
					ExitLoop
			Case Else
		EndSwitch
	WEnd

	GUIDelete()



EndFunc

Func Capture()
	Local $FileName, $PathName
   $PathName = @DesktopDir &"\snap"
   If Not FileExists($PathName) Then
		DirCreate($PathName)
    EndIf
	$FileName= _NowCalc() &".jpg"
	$FileName = StringReplace($FileName,":","_")
	$FileName = StringReplace($FileName,"\","_")
    $FileName = StringReplace($FileName,"/","_")
	$FileName = StringReplace($FileName," ","_")
    $PathName = $PathName &"\"& $FileName
    $hBmp = _ScreenCapture_Capture( $PathName, 0, 0, 1280,800)
	; $hBmp = _ScreenCapture_Capture( $PathName)

   TrayTip("Captured at location",  $PathName, 0, $TIP_ICONASTERISK)
EndFunc

Func Notepad()

    Local $hFileOpen, $sFilePath,$sTimeStamp, $sClip

   $sFilePath = @DesktopDir & "\notes.log"
   If Not FileExists($sFilePath) Then
		_FileCreate($sFilePath)
   EndIf

    $sTimeStamp= _DateTimeFormat(_NowCalc(), 1)

	$hFileOpen= FileOpen($sFilePath, $FO_APPEND)
	FileWrite($hFileOpen, "========================================" &@CRLF)
    FileWrite($hFileOpen,  $sTimeStamp &@CRLF)
	FileWrite($hFileOpen, "========================================" &@CRLF)
	$sClip = ClipGet()
    FileWrite($hFileOpen, $sClip & @CRLF & @CRLF)
    FileClose($hFileOpen)
	TrayTip("Captured at location",  $sFilePath, 0, $TIP_ICONASTERISK)
EndFunc
