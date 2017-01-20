param(
    # Parameter help description
    [Parameter(Mandatory=$true)]
    [string]
    $ProjectName,

    [Parameter(Mandatory=$true)]
    [string]
    $ProjectAuthor,

    [Parameter(Mandatory=$false)]
    [string]
    $ProjectDescription,

    [Parameter(Mandatory=$false)]
    [string]
    $ProjectCompany,

    [Parameter(Mandatory=$false)]
    [string]
    $ProjectReleaseNotes,

    [Parameter(Mandatory=$false)]
    [string[]]
    $ProjectTags,

    [Parameter(Mandatory=$false)]
    [string]
    $ProjectOwners,

    [Parameter(Mandatory=$false)]
    [string]
    $ProjectAssemblyName
)

$variables = @{
    'PSkel' = $ProjectName
    '%ProjectName%' = $ProjectName
    '%ProjectAssemblyName%' = $ProjectAssemblyName
    '%ProjectAuthor%' = $ProjectAuthor
    '%ProjectOwner%' = $ProjectOwner
    '%ProjectCompany%' = $ProjectOwner
    '%ProjectDescription%' = $ProjectDescription
    '%ProjectReleaseNotes%' = $ProjectReleaseNotes
    '%ProjectTags%' = $ProjectTags
    '%ProjectGuid%' = [guid]::NewGuid()
    '%ProjectYear%' = $(get-date -Format yyyy)    
}

Get-ChildItem -Path ..\ -Filter *.* -Recurse -File | % {

    if ($_.Name -eq "init_project.ps1") { continue }
    
    $fileContent = $text = Get-Content $_.FullName -Raw
    
    if ($fileContent.Length > 0)
    {
        $variables | % {
            $fileContent = $fileContent.Replace($_.Name, $_.Value)
        }
    }

    Set-Content $_.FullName

    # Rename PSKel* files to $ProjectName*
    If ($_.Name.StartsWith("PSkel"))
    {
        $newName = $_.Name.Replace("PSkel", $ProjectName)
        
        Write-Host "$($_.Name) --> $newName"
        Rename-Item -Path $_.FullName -NewName $newName        
    }
}

Write-Host "Project initialized."