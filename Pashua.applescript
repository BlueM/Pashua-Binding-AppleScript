-- Pashua binding for AppleScript.
-- See Readme.md for authors/contributors and license

-- Usage: either take the handlers out of this file and use them directly,
--        use this file as an AppleScript Library (OS X 10.9 or newer) or 
--        follow the "classical" approach using "load script". The example
--        script shipped with this file uses "load script" for maximum
--        compatibility.

-- Runs a Pashua dialog and returns the results as a list
-- 
-- Argument 1: Dialog/window configuration string
-- Argument 2: Folder that contains Pashua.app; if an empty string is given, default locations are searched
-- 
-- Returns: Record
on showDialog(config, customLocation)
	
	-- Create path for temporary file
	set AppleScript's text item delimiters to ""
	set tmpfile to ((path to temporary items folder as string) & "Pashua_" & (characters 3 thru end of ((random number) as string)) as string)
	
	-- Write temporary file and fill it with the configuration string
	set fhandle to open for access tmpfile with write permission
	write (config as string) to fhandle as «class utf8»
	close access fhandle
	
	-- Get temporary file's POSIX path
	set posixtmpfile to POSIX path of tmpfile
	
	--	try
	set pashua to getPashuaPath(customLocation)
	--	on error errorMessage
	--		display dialog errorMessage
	--	end try
	
	-- Append binary position inside app bundle to "regular" path
	-- and convert path from HFS to POSIX representation
	set pashuabinary to (POSIX path of pashua) & "Contents/MacOS/Pashua"
	
	-- Execute pashua and get the string returned
	set pashuaCall to quoted form of pashuabinary & " " & quoted form of posixtmpfile
	set pashuaResult to do shell script (pashuaCall)
	
	-- Delete the temporary file
	tell application "System Events" to delete file tmpfile -- silently and immediately delete the tempfile
	
	-- Check whether the dialog was submitted at all.
	-- If this is not the case, return an empty list
	if pashuaResult = "" then
		return {}
	end if
	
	-- Parse the result
	set AppleScript's text item delimiters to return
	set resultLines to text items of pashuaResult
	set AppleScript's text item delimiters to ""
	set recordComponents to {}
	repeat with currentLine in resultLines
		set eqpos to offset of "=" in currentLine
		if eqpos is not 0 then
			set varKey to word 1 of currentLine
			try
				set varValue to (text (eqpos + 1) thru end of currentLine)
				-- Quote any quotation marks in varValue with a backslash.
				-- The proper way to do this would be a handler, but as
				-- all code for interfacing to Pashua should be as compact
				-- as possible, we rather do it inline
				set AppleScript's text item delimiters to "\""
				set textItems to every text item of varValue
				set AppleScript's text item delimiters to "\\\""
				set varValue to textItems as string
				set AppleScript's text item delimiters to ""
			on error
				set varValue to ""
			end try
			copy (varKey & ":\"" & varValue & "\"") to end of recordComponents
		end if
	end repeat
	
	-- Return the record we read from the tmpfile
	set AppleScript's text item delimiters to ", "
	set resultList to (run script "return {" & (recordComponents as string) & "}")
	set AppleScript's text item delimiters to {""}
	return resultList
	
end showDialog


-- Searches Pashua.app in the location given as argument and in standard search paths
-- 
-- Will trigger an error if Pashua.app cannot be found
-- 
-- Argument: Folder that contains Pashua.app; if an empty string is given, default locations are searched
-- 
-- Returns: string
on getPashuaPath(customFolder)
	
	set myself to (path to me as string)
	
	-- Try to find Pashua application
	tell application "Finder"
		
		-- Custom location
		if customFolder is not "" then
			if last character of customFolder = ":" then
				set dirsep to ""
			else
				set dirsep to ":"
			end if
			if item (customFolder & dirsep & "Pashua.app") exists then
				return customFolder & dirsep & "Pashua.app:"
			end if
		end if
		
		-- Try to find it in this script application bundle
		if item (myself & "Contents:MacOS:Pashua") exists then
			return myself
		end if
		
		-- Try to find it in this script's parent's path
		set myFolder to (container of alias myself as string)
		if item (myFolder & "Pashua.app") exists then
			return (myFolder & "Pashua.app:")
		end if
		
		-- Try to find it in global application folder
		if item ((path to applications folder from system domain as text) & "Pashua.app") exists then
			return (path to applications folder from system domain as text) & "Pashua.app:"
		end if
		
		-- Try to find it in user's application folder
		if item ((path to applications folder from user domain as text) & "Pashua.app") exists then
			return ((path to applications folder from user domain as text) & "Pashua.app:")
		end if
		
		error "Could not find Pashua.app" & return & return & "It looks like it is is neither in one of the standard locations nor in the folder this AppleScript is in."
		
	end tell
	
end getPashuaPath
