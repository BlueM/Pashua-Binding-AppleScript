
-- This example loads script "Pashua.scpt" (to be compiled from "Pashua.applescript") from the
-- same folder which contains this file. Pashua.scpt handles the communication with Pashua.app.
-- You can either take the handlers out of Pashua.scpt and use them inline whenever you write
-- a script which uses Pashua, use Pashua.scpt as an AppleScript Library (OS X 10.9 or newer)
-- or use the "load script" approach used in this file.


-- Get the path to the folder containing this script
tell application "Finder"
	set thisFolder to (container of (path to me)) as string
	if "Pashua:Pashua.app:" exists then
		-- Looks like the Pashua disk image is mounted. Run from there.
		set customLocation to "Pashua:"
	else
		-- Search for Pashua in the standard locations
		set customLocation to ""
	end if
end tell

try
	set thePath to alias (thisFolder & "Pashua.scpt")
	set pashuaBinding to load script thePath
	
	tell pashuaBinding
		-- Display the dialog
		
		try
			set pashuaLocation to getPashuaPath(customLocation)
			set dialogConfiguration to my getDialogConfiguration(pashuaLocation)
			set theResult to showDialog(dialogConfiguration, customLocation)
			
			-- Display the result. The record keys ("... of theResult") are defined in the
			-- dialog configuration string.
			if {} = theResult then
				display alert "Empty return value" message "It looks like Pashua had some problems using the window configuration." as warning
			else if cb of theResult is not "1" then
				display dialog "AppleScript received this record: " & return & return & ¬
					"pop: " & pop of theResult & return & ¬
					"ob: " & ob of theResult & return & ¬
					"tf: " & tf of theResult & return & ¬
					"chk: " & chk of theResult & return & ¬
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
	          img.y = 248
			  img.maxwidth = 128
			  img.tooltip = This is an element of type “image”
	          img.path = " & (POSIX path of pashuaLocation) & "/Contents/Resources/AppIcon@2.png" & return
	else
		set img to ""
	end if
	
	return "
# Set window title
*.title = Welcome to Pashua

# Introductory text
txt.type = text
txt.default = Pashua is an application for generating dialog windows from programming languages which lack support for creating native GUIs on Mac OS X. Any information you enter in this example window will be returned to the calling script when you hit “OK”; if you decide to click “Cancel” or press “Esc” instead, no values will be returned.[return][return]This window shows nine of the UI element types that are available. You can find a full list of all GUI elements and their corresponding attributes in the documentation (➔ Help menu) that is included with Pashua.
txt.height = 276
txt.width = 310
txt.x = 340
txt.y = 44
txt.tooltip = This is an element of type “text”

# Add a text field
tf.type = textfield
tf.label = Example textfield
tf.default = Textfield content
tf.width = 310
tf.tooltip = This is an element of type “textfield”

# Add a filesystem browser
ob.type = openbrowser
ob.label = Example filesystem browser (textfield + open panel)
ob.width=310
ob.tooltip = This is an element of type “openbrowser”

# Define radiobuttons
rb.type = radiobutton
rb.label = Example radiobuttons
rb.option = Radiobutton item #1
rb.option = Radiobutton item #2
rb.option = Radiobutton item #3
rb.tooltip = This is an element of type “radiobutton”

# Add a popup menu
pop.type = popup
pop.label = Example popup menu
pop.width = 310
pop.option = Popup menu item #1
pop.option = Popup menu item #2
pop.option = Popup menu item #3
pop.default = Popup menu item #2
pop.tooltip = This is an element of type “popup”

# Add 2 checkboxes
chk.rely = -18
chk.type = checkbox
chk.label = Pashua offers checkboxes, too
chk.tooltip = This is an element of type “checkbox”
chk.default = 1
chk2.type = checkbox
chk2.label = But this one is disabled
chk2.disabled = 1
chk2.tooltip = Another element of type “checkbox”

# Add a cancel button with default label
cb.type = cancelbutton
cb.tooltip = This is an element of type “cancelbutton”

db.type = defaultbutton
db.tooltip = This is an element of type “defaultbutton” (which is automatically added to each window, if not included in the configuration)
" & img
end getDialogConfiguration
