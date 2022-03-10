<# 
This will need to be ran from elevated PowerShell session. Before running the script, you will need to type the following:
Set-ExecutionPolicy unrestricted

To adjust this script for your Windows user, replace all "XXXXX" strings with the name of your user account using Find & Replace feature.

If something breaks, it's due to the URL being outdated, or Microsoft Edge version, specified in this script, being outdated.

The ASCII art included here was found on https://www.asciiart.eu/computers/computers, slightly modified by me.
This script will remove most of the built-in programs from Windows 10, including Microsoft Edge.
The tools/programs that will be added with this script:
- Chrome
- Nmap (along with Npcap & Ncat)
- Burp Suite
- Python3
- Metasploit Framework
- Git
- RSAT
- 7zip
- impacket
- Golang
- Covenant
- SysInternals
- PowerSploit
- SecLists
- Nishang
- PayloadAllTheThings
- Gobuster
- WinPEAS
- Visual Studio Code

The script is made to be compatible with the fresh installation of Windows 10 Professional.
Note that the program-installation is GUI-based, you will need to be near keyboard in order for those installation to be completed.
This script doesn't require defender to be disabled, but don't change the installation path for Metasploit framework, otherwise it will get caught by defender.
#>

$art = @"
 ______________
||            ||
||C:\> mrs.ps1||
||            ||
||            ||
||____________||
|______________|
 \\############\\
  \\############\\
   \      ____    \   
    \_____\___\____\CA15
"@

$ProgressPreference = 'SilentlyContinue' 

echo $art
Start-Sleep -S 2
echo "This line was supposed to be funny, but I changed my mind."
Start-Sleep -S 6
echo "Downloading & installing Chrome."
Invoke-WebRequest 'http://dl.google.com/chrome/install/375.126/chrome_installer.exe'  -OutFile 'C:\Users\XXXXX\Downloads\chrome-installer.exe'
Start-Process "C:\Users\XXXXX\Downloads\chrome-installer.exe" -Wait
echo "Done, proceeds to remove some built-in Windows programs..."
Get-AppxPackage -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
Get-AppxPackage *bingnews* | Remove-AppxPackage
Get-AppxPackage *bingweather* | Remove-AppxPackage
get-appxpackage *bing* | remove-appxpackage
echo "OK, proceeds to take care of OneDrive & Edge"
taskkill /f /im OneDrive.exe
cmd.exe /c "%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall"
cd 'C:\Program Files (x86)\Microsoft\Edge\Application\99.0.1150.36\Installer\';.\setup.exe --uninstall --system-level --verbose-logging --force-uninstall;cd C:\Users\XXXXX\Downloads\
echo "Waiting on setup.exe to finish"
Start-Sleep -S 15
New-Item HKLM:\SOFTWARE\Microsoft -Name EdgeUpdate
New-ItemProperty HKLM:\SOFTWARE\Microsoft\EdgeUpdate -Name DoNotUpdateToEdgeWithChromium -Value 1
echo "Now, proceeds to install some good tools!"
Start-Sleep -S 7
Invoke-WebRequest 'https://nmap.org/dist/nmap-7.92-setup.exe'  -OutFile 'C:\Users\XXXXX\Downloads\nmap.exe'
Start-Process "C:\Users\XXXXX\Downloads\nmap.exe" -Wait
Invoke-WebRequest 'https://windows.metasploit.com/metasploitframework-latest.msi'  -OutFile 'C:\Users\XXXXX\Downloads\metasploit.msi'
Start-Process "C:\Users\XXXXX\Downloads\metasploit.msi" -Wait
Add-MpPreference -ExclusionPath "C:\metasploit-framework\"
Invoke-WebRequest 'https://portswigger.net/burp/releases/startdownload?product=community&version=2022.1.1&type=WindowsX64'  -OutFile 'C:\Users\XXXXX\Downloads\burp.exe'
Start-Process "C:\Users\XXXXX\Downloads\burp.exe" -Wait
Invoke-WebRequest 'https://www.python.org/ftp/python/3.10.2/python-3.10.2-amd64.exe'  -OutFile 'C:\Users\XXXXX\Downloads\python.exe'
Start-Process "C:\Users\XXXXX\Downloads\python.exe" -Wait
Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/download/v2.35.1.windows.2/Git-2.35.1.2-64-bit.exe'  -OutFile 'C:\Users\XXXXX\Downloads\git.exe'
Start-Process "C:\Users\XXXXX\Downloads\git.exe" -Wait
Invoke-WebRequest 'https://www.7-zip.org/a/7z2107-x64.exe'  -OutFile 'C:\Users\XXXXX\Downloads\7z.exe'
Start-Process "C:\Users\XXXXX\Downloads\7z.exe"

Invoke-WebRequest 'https://download.visualstudio.microsoft.com/download/pr/962fa33f-e57c-4e8a-abc9-01882ff74e3d/23e11ee6c3da863fa1489f951aa7e75e/dotnet-sdk-3.1.417-win-x64.exe'  -OutFile 'C:\Users\XXXXX\Downloads\net.exe'
Start-Process "C:\Users\XXXXX\Downloads\net.exe" -Wait

Invoke-WebRequest 'https://go.dev/dl/go1.17.8.windows-amd64.msi'  -OutFile 'C:\Users\XXXXX\Downloads\go.msi'
Start-Process "C:\Users\XXXXX\Downloads\go.msi" -Wait

echo "Refresh the path..."
Start-Sleep -S 5
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

python -m pip install --upgrade pip
Add-MpPreference -ExclusionPath "C:\Users\XXXXX\AppData\Local\Temp"
Add-MpPreference -ExclusionPath "C:\Users\XXXXX\AppData\Local\Programs\Python\Python310\Scripts"
pip install impacket

echo "Refresh the path, once again..."
Start-Sleep -S 5
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

mkdir C:\c2
mkdir C:\useful
Add-MpPreference -ExclusionPath "C:\c2"
Add-MpPreference -ExclusionPath "C:\useful"
cd c:\c2
git clone --recurse-submodules https://github.com/cobbr/Covenant
echo "To run the covenant, use the following command in the C:\c2\Covenant\Covenant :"
echo "dotnet run"
Start-Sleep -S 7

cd C:\useful
Invoke-WebRequest 'https://download.sysinternals.com/files/SysinternalsSuite.zip'  -OutFile 'C:\Users\XXXXX\Downloads\sysinternals.zip'
Expand-Archive -LiteralPath 'C:\Users\XXXXX\Downloads\sysinternals.zip' -DestinationPath C:\useful\sysinternals
Start-Sleep -S 30
git clone https://github.com/PowerShellMafia/PowerSploit.git
git clone https://github.com/samratashok/nishang.git
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git

git clone https://github.com/OJ/gobuster.git
cd gobuster
go get
go build
go install


Invoke-WebRequest 'https://github.com/carlospolop/PEASS-ng/releases/download/20220310/winPEASx64.exe'  -OutFile 'C:\useful\winpeas.exe'


echo "Adding RSAT, this will take some time to finish..."
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability –Online

echo "The last thing to install: Visual Studio Community 2022!"
Start-Sleep -S 6
Invoke-WebRequest 'https://aka.ms/vs/17/release/vs_community.exe'  -OutFile 'C:\Users\XXXXX\Downloads\vs.exe'
Start-Process "C:\Users\XXXXX\Downloads\vs.exe" -Wait

echo "Done! Run cleanmgr.exe to free the memory of your VM."
echo "Make sure to delete the installers in the Downloads folder."
Remove-MpPreference -ExclusionPath "C:\Users\XXXXX\AppData\Local\Temp"
rm C:\Users\XXXXX\AppData\Local\Temp\* -Force