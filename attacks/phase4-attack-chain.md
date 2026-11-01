# Phase 4: Attack chain (Kali 10.10.30.100 to WIN11-CLIENT 10.10.20.101)

The attacker sits on ATTACKER_DMZ. The only path to the target is a single pfSense pass rule
(ATTACKER_DMZ to 10.10.20.101, logged, "Phase 4 attack sim").

## 1. Reconnaissance
```bash
nmap -sV -O 10.10.20.101
```
Result: one open port (135/msrpc), host fingerprinted as Windows 11. **No Wazuh alerts.** See DET-001.

## 2. Credential attack (SMB)
```bash
nxc smb 10.10.20.101 -u aadmin -p /tmp/small-pw-list.txt
```
- Hydra RDP failed with connection errors and the SMB module returned invalid replies, so netexec was used instead.
- Multi-password runs produced intermittent `Broken Pipe` errors. A single explicit password test worked.
- Valid credential found. The password is intentionally weak and is not recorded here.

Screenshot: `screenshots/06-attack-netexec-smb-broken-pipe.png`

## 3. What Wazuh saw
- Logon failures, rule 60122 (level 5), source 10.10.30.100 (`screenshots/07`, `screenshots/10`)
- Logon success, rule 92652 (level 6), same source IP, NTLM (`screenshots/08`, `screenshots/09`)
- Correlation rule 100100 (level 12, T1110) (`screenshots/12`)

## 4. Verifying the evidence in Discover
Query used: `agent.name: "WIN11-CLIENT" and (rule.id: "60122" or "92652")`
Four hits, all with `data.win.eventdata.ipAddress: 10.10.30.100`.
