# snipehunt
A small PowerShell tool for finding information quickly on malicious IPs or FQDNs.
If one of the IPs that you have entered into the text box have been reported, it will oepn tabs for AbuseIPDB, Threatcrowd, ARIN, VirusTotal with their respective information on the reported hosts. 

![SnIpEhUnT](https://i.imgur.com/F3w1WAL.png)
v0.7.5.1

## Download
The link below directs to the old version that uses Firefox. Its's also been known to be caught by AV. **But this is a false postive**. 
You'll get the same results if you use this (https://github.com/b3b0/PowerShell-To-EXE) to turn these exact scripts into an EXE.

I highly recommend simply downloading this repo and using the scripts.

But if you insist:

[Get it right here!](https://github.com/b3b0/snipehunt/releases/download/v0.7.5/snipehunt-0.7.5-x86_x64.exe)

## Versions
- cli.ps1:          the command-line interface version of the tool. Can be used on Linux! Launches Firefox in Linux. Plans to change to Chrome.
- graphical.ps1:    the graphical version of this tool. Windows only. Will launch Chrome with all requested information.

## Requirements
- Google Chrome
- PowerShell
- Internet Connection

### Etc
Feel free to contribute or fork! 
