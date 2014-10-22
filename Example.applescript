
-- This example loads script "Pashua.scpt" (to be compiled from "Pashua.applescript") from the
-- same folder which contains this file. Pashua.scpt handles the communcation with Pashua.app.
-- You can either take the handlers out of Pashua.scpt and use them inline whenever you write
-- a script which uses Pashua, use Pashua.scpt as an AppleScript Library (OS X 10.9 or newer)
-- or use the "load script" approach used in this file.


-- Get the path to the folder containing this script
tell application "Finder" to set thisFolder to (container of (path to me)) as string

try
	set thePath to alias (thisFolder & "Pashua.scpt")
	set pashuaBinding to load script thePath
	
	tell pashuaBinding
		-- Display the dialog
		
		try
			set pashuaLocation to getPashuaPath("Pashua:")
			set dialogConfiguration to my getDialogConfiguration(pashuaLocation)
			set theResult to showDialog(dialogConfiguration, "Pashua:")
			
			-- Display the result. The record keys ("... of theResult") are defined in the
			-- dialog configuration string.
			if {} = theResult then
				display alert "Empty return value" message "It looks like Pashua had some problems using the window configuration." as warning
			else if cb of theResult is not "1" then
				display dialog "AppleScript received this record: " & return & return & Â
					"pop: " & pop of theResult & return & Â
					"ob: " & ob of theResult & return & Â
					"tf: " & tf of theResult & return & Â
					"chk: " & chk of theResult & return & Â
					"rb: " & rb of theResult & return
			else
				-- The cancelbutton (named "cb" in the config string) was pressed
				display dialog "The dialog was closed without submitting the values"
			end if
		on error errorMessage
			display alert "An error occurred" message errorMessage as warning
		end try
	end tell
	
on error errStr number errorNumber
	display dialog errStr
end try


-- Returns the configuration string for an example dialog
on getDialogConfiguration(pashuaLocation)
	
	if pashuaLocation is not "" then
		set img to "img.type = image
	          img.x = 435
	          img.y = 240
			  img.maxwidth = 128
	          img.path = " & (POSIX path of pashuaLocation) & "/Contents/Resources/AppIcon@2.png" & return
	else
		set img to ""
	end if
	
	return "
# Set window title
*.title = Welcome to Pashua

# Introductory text
txt.type = text
txt.default = Pashua is an application for generating dialog windows from programming languages which lack support for creating native GUIs on Mac OS X. Any information you enter in this example window will be returned to the calling script when you hit ÒOKÓ; if you decide to click ÒCancelÓ or press ÒEscÓ instead, no values will be returned.[return][return]This window shows nine of the UI element types that are available. You can find a full list of all GUI elements and their corresponding attributes in the documentation that is included with Pashua.
txt.height = 276
txt.width = 310
txt.x = 340
txt.y = 44

# Add a text field
tf.type = textfield
tf.label = Example textfield
tf.default = Textfield content
tf.width = 310

# Add a filesystem browser
ob.type = openbrowser
ob.label = Example filesystem browser (textfield + open panel)
ob.width=310
ob.tooltip = Blabla filesystem browser

# Define radiobuttons
rb.type = radiobutton
rb.label = Example radiobuttons
rb.option = Radiobutton item #1
rb.option = Radiobutton item #2
rb.option = Radiobutton item #3
rb.default = Radiobutton item #2

# Add a popup menu
pop.type = popup
pop.label = Example popup menu
pop.width = 310
pop.option = Popup menu item #1
pop.option = Popup menu item #2
pop.option = Popup menu item #3
pop.default = Popup menu item #2

# Add 2 checkboxes
chk.rely = -18
chk.type = checkbox
chk.label = Pashua offers checkboxes, too
chk.default = 1
chk2.type = checkbox
chk2.label = But this one is disabled
chk2.disabled = 1

# Add a cancel button with default label
cb.type=cancelbutton
" & img
end getDialogConfiguration
