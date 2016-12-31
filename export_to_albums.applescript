on run
	set rootFolderName to "Exported albums"
	set rootFolder to POSIX file (POSIX path of file ((path to desktop as text) & rootFolderName))
	
	createFolder(rootFolder as text)
	
	set rootContainers to {}
	tell application "Photos"
		activate
		delay 2
		repeat with thisContainer in containers
			if name of thisContainer is not in {"Favorites", "Last Import"} then
				copy thisContainer to the end of rootContainers
			end if
		end repeat
	end tell
	
	repeat with aContainer in rootContainers
		exportPhotosFrom(aContainer, rootFolder)
	end repeat
end run

on exportPhotosFrom(aContainer, parentFolder)
	set aaa to name of aContainer
	log "------------------- aContainer is=" & aaa
	set subContainers to {}
	tell application "Photos"
		try
			set subs to containers of aContainer
			repeat with subContainer in subs
				copy subContainer to the end of subContainers
			end repeat
		on error errMsg number errorNumber
		end try
	end tell
	
	exportPhotos(aContainer, parentFolder)
	
	if (count of subContainers) > 0 then
		repeat with aSubContainer in subContainers
			tell application "Photos"
				#set loc to (location in library for aContainer as text)
				#log "===========" & loc
			end tell
			set nameOfAContainer to name of aContainer
			exportPhotosFrom(aSubContainer, parentFolder & ":" & nameOfAContainer)
		end repeat
	end if
end exportPhotosFrom

on exportPhotos(aContainer, parentFolder)
	set nameOfAContainer to name of aContainer
	set fullPath to (parentFolder as text) & ":" & nameOfAContainer
	log fullPath
	createFolder(fullPath)
end exportPhotos

on createFolder(fullPath)
	#log "----------------------"
	log fullPath
	do shell script "mkdir -p " & quoted form of POSIX path of fullPath
	
	#	tell application "Finder"
	#		if parentFolder is null then
	#			make new folder named folderPath
	#		else
	#			make new folder named folderPath at parentFolder#;
	#		end if
	#	end tell
	
	#	tell application "Finder"
	#make new folder named folderName at parentFolder as text
	#		make new folder at parentFolder with properties {name:folderName}
	#	end tell
end createFolder
