
set theFolderName to "Exported albums"

set theDestinationFolder to POSIX file (POSIX path of file ((path to desktop as text) & theFolderName & ":"))

tell application "Finder"
	
	if not (exists theDestinationFolder) then
		
		make new folder at desktop with properties {name:theFolderName}
		
	end if
	
end tell

tell application "Photos"
	
	activate
	
	set myAlbums to {}
	
	repeat with thisContainer in containers
		
		set thisContainer to contents of thisContainer
		
		if name of thisContainer is not in {"Favorites", "Last Import"} then
			
			copy thisContainer to the end of myAlbums
			
		end if
		
	end repeat
	
	repeat with thisAlbum in myAlbums
		log "album being processed: "
		log thisAlbum
		
		set thisAlbum to contents of thisAlbum
		
		set thisName to name of thisAlbum
		
		try
			set thesePhotos to media items of thisAlbum
		on error errMsg number errorNumber
			log "errMsg: " & errMsg
		end try
		
		try
			
			tell application "Finder"
				
				make new folder at theDestinationFolder with properties {name:thisName}
				
				set thisExportedAlbum to result as alias
				
			end tell
			
			export thesePhotos to thisExportedAlbum with using originals
			
		end try
		
	end repeat
	
end tell

say "Done"
