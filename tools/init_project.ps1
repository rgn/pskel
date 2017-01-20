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
    
    Write-Host "Initialize " $_.Name  -ForegroundColor Gray

    $fileContent = $text = Get-Content $_.FullName -Raw

    if ($fileContent.Length -gt 0) {
        Write-Debug "Replace variables in $($_.Name)"

        $variables.Keys | % {
            
            $key = $_
            $value = $variables.Item($_)

            Write-Debug "replace $key  with $value"

            $fileContent = $fileContent.Replace($key, $value)
        }
    }
    else {
        Write-Debug "skipt $($_.Name) due to zero length"
    }

    Set-Content $_.FullName $fileContent

    # Rename PSKel* files to $ProjectName*
    If ($_.Name.StartsWith("PSkel"))
    {
        $newName = $_.Name.Replace("PSkel", $ProjectName)
        
        Write-Debug "Rename $($_.Name) to $newName"

        Rename-Item -Path $_.FullName -NewName $newName        
    }
}

Write-Host "Project initialized." -ForegroundColor Green