# SOC Home Lab

A segmented virtual network built in Oracle VirtualBox on one host. It includes a pfSense firewall, an Active Directory domain, a monitored Windows 11 client, a Wazuh SIEM, and a Kali attacker. The goal is to practice network segmentation, log collection, attack simulation, and detection engineering.

## Contents

| Path | What it holds |
|---|---|
| `docs/network-diagram.md` | Architecture, segments, and addressing |
| `docs/troubleshooting.md` | Problems hit during the build and how each was resolved |
| `docs/lessons-learned.md` | Takeaways |
| `attacks/phase4-attack-chain.md` | Recon, credential attack, and what Wazuh saw |
| `detections/detections-log.md` | Detection results and verdicts (DET-001 to DET-005) |
| `wazuh/local_rules.xml` | Custom correlation rule 100100 |
| `wazuh/ossec-agent-sysmon-localfile.xml` | Agent config for Sysmon event collection |
| `wazuh/validate-and-restart.sh` | Validate rules before restarting the manager |
| `scripts/windows-firewall-lab-scope.ps1` | Lab-only firewall scope fix on WIN11-CLIENT |
| `screenshots/` | Evidence, numbered in the order they were captured |

## Build status

| Phase | Scope | Status |
|---|---|---|
| 1. Foundation | VirtualBox host-only networks, pfSense with 4 NICs, subnets and DHCP, segmentation tests | Complete |
| 2. Corporate environment | DC01 for `corp.local`, OUs (Employees, IT, Contractors), users, GPO, WIN11-CLIENT domain-joined, Sysmon with the SwiftOnSecurity config | Complete |
| 3. SIEM and visibility | Wazuh all-in-one on SIEM01, agents on DC01 and WIN11-CLIENT, pfSense syslog, Sysmon collection | Complete |
| 4. Attacker box and detections | Nmap recon (undetected), netexec SMB credential attack (detected), custom rule 100100 | Complete |
| 5. Documentation | This repo | In progress |

## Detection rule

`wazuh/local_rules.xml` defines rule **100100** (level 12, MITRE T1110). It fires when a successful logon (92652) follows a logon failure (60122). In the test, it fired once, at level 12, for the attack from Kali.

Known limitations:
- No failure threshold yet (it fires after any prior failure).
- No source-IP match. `same_source_ip` blocked the correlation in this Wazuh version, so it was removed. A production rule should verify the `srcip` field mapping first.

## Key screenshots

| Step | Screenshot |
|---|---|
| Attack runs from Kali | `screenshots/06-attack-netexec-smb-broken-pipe.png` |
| Logon failures in Wazuh | `screenshots/07-wazuh-60122-logon-failures.png` |
| Success from the same source IP | `screenshots/08-wazuh-discover-60122-and-92652-source-ip.png` |
| Rule 100100 fires at level 12 | `screenshots/12-rule-100100-fired-level-12.png` |

## Security note

Credentials in this lab are intentionally weak so the brute-force scenario works. They exist only on this isolated virtual network. The real password is not recorded in this repo.
