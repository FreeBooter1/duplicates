# PowerShell Script to Find Duplicate Files and Delete Them in Folder

	
	while ($true)
	{
		Write-Output ""
		$path = Read-Host "Please Enter a Directory Path to Scan"
		$path = $path -replace '"', ""
		
		
		if (Test-Path $path)
		{
			Write-Host "Valid directory path: $path"
			break
		}
		else
		{
			Write-Host "Invalid directory path, please try again."
		}
	}
	
	
	Clear-Host
	
	Write-Output "Scanning Directory: $path"
	
	
	# Define the directory to scan
	$directoryPath = $path
	
	# Get all files in the directory
	$files = Get-ChildItem -Path $directoryPath -File
	
	# Create a hash table to store file hashes
	$fileHashes = @{ }
	
	# Variable to track if duplicates are found
	$duplicatesFound = $false
	
	# Iterate through each file in the directory
	foreach ($file in $files)
	{
		# Compute the hash of the file
		$fileHash = Get-FileHash -Path $file.FullName -Algorithm MD5
		
		# Check if the hash already exists in the hash table
		if ($fileHashes.ContainsKey($fileHash.Hash))
		{
			Write-Output ""
			# Duplicate found
			Write-Host "Duplicate found: $($file.FullName)"
			$duplicatesFound = $true
			Write-Output ""
		}
		else
		{
			# Add the hash to the hash table
			$fileHashes[$fileHash.Hash] = $file.FullName
		}
	}
	
	# Notify the user if no duplicates were found
	if (-not $duplicatesFound)
	{
		Clear-Host
		Write-Output ""
		Write-Host "No duplicates found in the ""$directoryPath"" directory."
		Write-Output ""
		Exit
		
		
	}
	
	
	
	# Prompt the user for confirmation
	$confirmation = Read-Host "Are you sure you want to delete the files in $path directory? (Y/N)"
	
	if ($confirmation -eq 'Y' -or $confirmation -eq 'y')
	{
		Clear-Host
		# Define the directory to search for duplicate files
		$directory = $path
		
		# Get all files in the directory and subdirectories
		$files = Get-ChildItem -Path $directory -Recurse -File
		
		# Group files by their hash value
		$duplicates = $files | Group-Object -Property { (Get-FileHash $_.FullName).Hash } | Where-Object { $_.Count -gt 1 }
		
		
		foreach ($group in $duplicates)
		{
			$filesToDelete = $group.Group | Select-Object -Skip 1
			foreach ($file in $filesToDelete)
			{
				Remove-Item -Path $file.FullName -Force
				
				Clear-Host
				Write-Output ""
				Write-Output ""
				# Optional: Confirm completion
				Write-Output "Script completed. All Duplicates Files Deleted."
				Write-Output ""
				Write-Output ""
				
				
			}
		}
		
		
	}
	











