Import-Module au
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = ''

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "([$]url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
      "([$]url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.URL64)'"
      "([$]checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
      "([$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
    }
  }
}

function global:au_AfterUpdate {
  Set-DescriptionFromReadme -SkipFirst 1
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '\.exe$'
  $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

  $version = $url -split '[._-]|.exe' | Select-Object -Last 1 -Skip 2

  $latest = @{ URL32 = $url32; URL64 = $url64; Version = $version}
  return $Latest
}

update