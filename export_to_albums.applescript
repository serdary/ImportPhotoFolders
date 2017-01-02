on run
	set rootFolderName to "Exported albums"
	set rootFolder to POSIX file (POSIX path of file ((path to desktop as text) & rootFolderName))
	
	createFolder(rootFolder as text)
	
	set rootContainers to {}
	tell application "Photos"
		activate
		delay 2
		repeat with thisContainer in containers
			if name of thisContainer is not in {"Favorites", "Last Import", "People", "Places", "Videos", "All Photos", "Selfies", "Panoramas", "Slo-mo", "Bursts", "Depth Effect"} then
				copy thisContainer to the end of rootContainers
			end if
		end repeat
	end tell
	
	repeat with aContainer in rootContainers
		exportPhotosFrom(aContainer, rootFolder)
	end repeat
	
	say "DONE"
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
			set nameOfAContainer to name of aContainer
			exportPhotosFrom(aSubContainer, parentFolder & ":" & nameOfAContainer)
		end repeat
	end if
end exportPhotosFrom

on exportPhotos(aContainer, parentFolder)
	set nameOfAContainer to name of aContainer
	set fullPath to (parentFolder as text) & ":" & nameOfAContainer
	createFolder(fullPath)
	
	log "album being processed: " & nameOfAContainer
	set thisAlbum to contents of aContainer
	
	tell application "Photos"
		try
			set thesePhotos to media items of thisAlbum
		on error errMsg number errorNumber
			log "errMsg: " & errMsg
		end try
		
		try
			set fullPathAlias to fullPath as alias
			export thesePhotos to fullPathAlias with using originals
		on error errMsg number errorNumber
			log "errMessage: " & errMsg
		end try
	end tell
end exportPhotos

on createFolder(fullPath)
	set fullFolder to POSIX file (quoted form of POSIX path of fullPath)
	
	log fullPath
	set pathWithColon to fullPath & ":"
	do shell script "mkdir -p " & quoted form of POSIX path of fullPath
	do shell script "chmod 777 " & quoted form of POSIX path of fullPath
end createFolder
