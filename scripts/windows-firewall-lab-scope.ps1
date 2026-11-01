# LAB ONLY. Run in an elevated PowerShell on WIN11-CLIENT.
# Windows Firewall defaults these rules to RemoteAddress=LocalSubnet4, which blocks
# traffic that pfSense already allows across segments. Do not use this on a real network.
Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' | Set-NetFirewallRule -RemoteAddress Any
Get-NetFirewallRule -DisplayName '*Echo Request*ICMPv4*' | Set-NetFirewallRule -RemoteAddress Any
