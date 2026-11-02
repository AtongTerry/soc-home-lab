# Detections Log: SOC Analyst Home Lab

Results of the Phase 4 attack and detection exercises.

| ID | Activity | Source to target | Wazuh result | Verdict | Action |
|---|---|---|---|---|---|
| DET-001 | Nmap service and OS scan (`nmap -sV -O`) | 10.10.30.100 to 10.10.20.101 | No alerts. One open port (135/msrpc). Fingerprinted as Windows 11. | **Detection gap** | Host logs do not catch passive network scanning. Add a network IDS (Suricata or Zeek) |
| DET-002 | PowerShell creates a `__PSScriptPolicyTest_*.ps1` temp file | WIN11-CLIENT (local) | Rule 92213, "Executable file dropped in folder," level 15 | **False positive** | PowerShell's built-in script-policy check, not malware. Candidate for a tuning rule |
| DET-003 | SMB password guessing with netexec against `aadmin` | 10.10.30.100 to WIN11-CLIENT | Rule 60122 failures (level 5), then rule 92652 success (level 6), same source IP | **True positive** | Credential was valid. Rotate it and enforce lockout, then re-test |
| DET-004 | Same brute-force sequence as DET-003 | Same | Custom rule **100100** fired at **level 12** (T1110) | **True positive** | Correlation works. No failure threshold or source-IP match yet |
| DET-005 | pfSense firewall logs to Wazuh | pfSense to SIEM01 (UDP 514) | Delivery confirmed with tcpdump. Events reach the archive | **Visibility confirmed** | None |

## Triage notes

**DET-002 (false positive):** Level 15 looks critical, but the file is a PowerShell policy self-test. The right response is to document it and tune the rule, not to escalate.

**DET-003 and DET-004 (true positive):** Read the timeline in order: failures from one source IP, then a success from the same IP, then rule 100100. The source IP in the logon event attributes the activity to Kali.

## Open items

- [ ] Add a failure-count threshold to rule 100100 (for example, three or more failures in 120 seconds)
- [ ] Add Suricata or Zeek to cover the DET-001 gap
- [ ] Rotate the `aadmin` password, enforce lockout, and re-test DET-003

## Evidence

### DET-001: Nmap scan
No screenshot. Nmap showed one open port and no Wazuh alerts.

### DET-003: credential attack, failures and success
![DET-003 failures](screenshots/07-wazuh-60122-logon-failures.png)

![DET-003 success from same source IP](screenshots/08-wazuh-discover-60122-and-92652-source-ip.png)

### DET-004: rule 100100 fires
![DET-004 rule 100100 fired](screenshots/12-rule-100100-fired-level-12.png)
