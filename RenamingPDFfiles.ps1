#$fulldate = get-date

#$year = $fulldate.tostring("yyyy")
#$day = $fulldate.tostring("dd")
#$month =$fulldate.tostring("MM")

#Parent folder name: (\\gryphon\Accounting\RBC Reports)
$originalpath = "\\samarth\Accounting\Reports"

#Get the information of all the folders whose names contain only numeric values. Sort through these folders and find the folder that was most recently created
$Dirs = Get-ChildItem -Path $originalpath | Where-Object { $_.Name -match '^\d+$' } | Sort-Object | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

#Creating a path by concatenating the parent folder with the name of the most recently created folder
$lastfoldercreatedY= $originalpath + "\" + $Dirs.Name

$lastfoldercreatedM = gci $lastfoldercreatedY | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

$lastfoldercreatedMY = $lastfoldercreatedY + "\" + $lastfoldercreatedM.Name

$lastfoldercreated = gci $lastfoldercreatedMY | ? { $_.PSIsContainer } | sort CreationTime -desc | select -f 1

#Split the name of the last child path using period
$splitdate = $lastfoldercreated.Name -split "\."

#Creating object names
$day = $splitdate[0]
$month = $splitdate[1]
$year = $splitdate[2]

#Creating the full path
$filePath = $originalpath + $year + "\"+ [decimal]$month + "-" + (Get-Culture).DateTimeFormat.GetMonthName($month) + " " + $year + "\"+ $day + "." + $month + "." + $year

#Getting the names of all the files with .pdf extension and removing their extension
$Files = Get-ChildItem -Recurse -path $filePath | where {$_.extension -eq ".pdf"} | Select -ExpandProperty BaseName

#Function to rename the pdf files. 
#The function will take the existing pdf files' names and add the date
Function RenameFile($locationPath, $oldfileName, $Day, $Month, $Year, $extension)
{
$old = $locationPath + "\" + $oldfileName + $extension
$new = $locationPath + "\" + $Day + "." + $Month + "." + "$Year" + " " + $oldfileName + $extension
Rename-Item $old $new
}

#Arguments used to run the function
Foreach ($i in $Files)
{
RenameFile -locationPath $filePath -oldfileName "$i" -Day "$day" -Month "$month" -Year "$year" -extension ".pdf"
} 


