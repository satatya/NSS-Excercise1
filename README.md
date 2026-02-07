# Network Security Lab: FreeBSD Firewalling, NAT, and Access Control

**Course:** Networks and Systems Security II (CSE 554)
**Student Name:** Satatya De
**Date:** February 4, 2026

---

## 📖 Project Overview
This project involves the deployment and securing of a multi-node network environment using **FreeBSD** and **Linux** virtual machines. The primary objective was to demonstrate defense-in-depth strategies by combining network-level mediation (Firewalling/NAT) with host-level access control (ACLs) and analyzing operating system security mechanisms (SetUID).

The exercise was executed in three distinct phases:
1.  **Network Mediation (Part A):** configured a FreeBSD router to manage traffic between isolated subnets using Static Routing, Bidirectional NAT, and Packet Filtering (`pf`).
2.  **Access Control (Part B):** Implemented fine-grained file permissions using Access Control Lists (ACLs) to secure sensitive data on an enterprise server.
3.  **Privilege Escalation Analysis (Part C):** Investigated security vulnerabilities and OS-level defenses regarding SetUID on shell scripts.

---

## ⚙️ Environment Setup & Topology

The lab consists of three Virtual Machines configured in a linear topology to simulate a corporate network environment.

### Network Diagram
`[VM1 Client] <---(Subnet A)---> [VM2 Router] <---(Subnet B)---> [VM3 Server]`

### Node Configuration
* **VM1 (Client):** Linux Workstation
    * **Interface (`eth1`):** `192.168.10.1`
    * **Role:** Simulates an external or internal client attempting to access resources.
* **VM2 (Router/Firewall):** FreeBSD 14.x
    * **Interface (`em1`):** `192.168.10.2` (Gateway for Subnet A)
    * **Interface (`em2`):** `192.168.20.1` (Gateway for Subnet B)
    * **Role:** Performs routing, Network Address Translation (NAT), and packet filtering.
* **VM3 (Enterprise Server):** Linux/FreeBSD
    * **Interface (`eth1`):** `192.168.20.2`
    * **Role:** Hosts the web server and sensitive files.

---

## 🚀 Part A: FreeBSD Router & Firewall Configuration

### 1. Connectivity & Routing
* **Action:** Configured static IP addresses and enabled packet forwarding on VM2 by adding `gateway_enable="YES"` to `/etc/rc.conf`.
* **Verification:** successfully pinged across subnets. A `traceroute` from VM1 to VM3 confirmed the path traverses the router (2 hops).

### 2. Bidirectional NAT & Port Forwarding
* **Objective:** Hide internal network structure and expose specific services.
* **Configuration (`/etc/pf.conf`):**
    * **NAT:** Mapped all traffic from Subnet A (`10.0/24`) to the Router's external IP (`20.1`).
    * **Redirection (RDR):** Forwarded traffic hitting the Router's internal IP on Port 80 to the Server's actual IP (`192.168.20.2`).
* **Outcome:** The server logs show requests originating from the Router's IP (`192.168.20.1`), confirming NAT is active.

### 3. Firewall Policy (Default Deny)
* **Objective:** Secure the network by blocking non-essential traffic.
* **Policy:**
    * **Block:** All traffic by default (`block all`).
    * **Allow:** Only HTTP (80) and HTTPS (443).
* **Outcome:** Web access (`curl`) succeeds, while SSH (`ssh user@host`) times out, proving the firewall is enforcing the rules.

---

## 🔐 Part B: File Access Control (ACLs)

### 1. The Challenge
Standard Unix permissions (`rwx`) were insufficient to grant the web server (`temphttp`) and a student user (`student`) read access to specific files without exposing them to everyone ("others").

### 2. The Solution: ACLs
Used `setfacl` to implement a granular permission model on **VM3**:
* **Files Created:** `/srv/webfiles/public.txt` and `/srv/webfiles/secret.txt`.
* **Permissions Applied:**
    * `student`: Granted Read access to `public.txt`.
    * `temphttp`: Granted Read access to `public.txt`.
    * `secret.txt`: No ACLs added; remains locked to root.

### 3. Verification
* `getfacl public.txt` shows specific user entries.
* User `student` can read public info but receives "Permission denied" when attempting to read the secret file.

---

## 🛡️ Part C: SetUID & Privilege Escalation

### 1. The Experiment
Created a shell script (`readsecret.sh`) owned by **root** with the **SetUID** bit enabled (`chmod 4755`). The script attempts to display the current user ID and read the secret file.

### 2. The Result
When executed by a standard user (`student`):
* **Outcome:** `Permission denied`.
* **Analysis:** Modern operating system kernels (Linux/FreeBSD) strictly ignore the SetUID bit on interpreted executables (like shell scripts) to prevent inherent race condition vulnerabilities. The script executed with the privileges of the *caller* (`student`), not the *owner* (`root`).

### 3. Web-Based Vector
Attempted to access the secret via the web server (`curl http://server/readsecret.sh`):
* **Outcome:** The server returned the source code of the script as text but did not execute it.
* **Conclusion:** The web server user (`temphttp`) lacked ACL permissions to read the secret file, and the web server configuration treated `.sh` files as plain text rather than CGI scripts.

---

## 📦 Files Included in Submission
1.  **MT25084_E1.pdf :** A single pdf file containing all the screenshots and explanations of the different sections given in our Excercise.

---
*End of Readme*
