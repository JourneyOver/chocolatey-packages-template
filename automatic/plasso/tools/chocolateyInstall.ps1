$ErrorActionPreference = 'Stop'
$ServerOS = (Get-WmiObject -Class Win32_OperatingSystem).Caption
$pp = Get-PackageParameters

$packageName = 'plasso'
$url = 'https://bitsum.com/files/processlassosetup32.exe'
$url64 = 'https://bitsum.com/files/processlassosetup64.exe'
$checksum = '98f17ecaa61d08e75fc466e3f3fa43a8ab39744c0c7c8707da86ce1bddf9dffb'
$checksum64 = '7558e631c38c27d96135df9cfedf6a97a85e85aca169ef045bdba0fa39dd1f85'

$checksumType = 'sha256'

$surl = 'https://bitsum.com/files/server/processlassosetup32.exe'
$surl64 = 'https://bitsum.com/files/server/processlassosetup64.exe'
$schecksum = '07b11b7c56f494e14076a79b23d18e95acac4a70a31ff99022a1d75e03e8ed50'
$schecksum64 = '6a0a043e3ee78601c332bae2d17fb5d8e16369ca39bd6cfa5a03ba74100a247a'

if (!$pp['language']) { $pp['language'] = 'English' }
if (!$pp['gui_start_type']) { $pp['gui_start_type'] = 'all,uac' }
if (!$pp['governor_start_type']) { $pp['governor_start_type'] = 'all,uac' }
if (!$pp['launch_gui']) { $pp['launch_gui'] = 'false' }
if (!$pp['logfolder']) { $pp['logfolder'] = "$env:APPDATA\ProcessLasso\logs" }
if (!$pp['configfolder']) { $pp['configfolder'] = "$env:APPDATA\ProcessLasso\config" }

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  url            = $url
  url64Bit       = $url64
  silentArgs     = "/S /language=$($pp['language']) /gui_start_type=$($pp['gui_start_type']) /governor_start_type=$($pp['governor_start_type']) /launch_gui=$($pp['launch_gui']) /logfolder=$($pp['logfolder']) /configfolder=$($pp['configfolder'])"
  validExitCodes = @(0)
  checksum       = $checksum
  checksum64     = $checksum64
  checksumType   = $checksumType
  checksumType64 = $checksumType
}

if ($ServerOS -match "Server") {
  Write-Host 'Installing Server Version'
  $packageArgs.url = $surl
  $packageArgs.url64Bit = $surl64
  $packageArgs.checksum = $schecksum
  $packageArgs.checksum64 = $schecksum64
  Install-ChocolateyPackage @packageArgs
} else {
  Write-Host 'Installing Workstations Version'
  Install-ChocolateyPackage @packageArgs
}