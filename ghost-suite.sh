#!/bin/bash

# Ghost Suite v1.0 - Stealth Operations Toolkit
# Author: Nyra

show_menu() {
    clear
    echo "╔════════════════════════════╗"
    echo "║     🕶️ Ghost Suite Menu     ║"
    echo "╠════════════════════════════╣"
    echo "1) Enable Ghost Mode"
    echo "2) Disable Ghost Mode"
    echo "3) Block IPv6"
    echo "4) Check DNS Leaks"
    echo "5) Monitor DNSCrypt Health"
    echo "6) Exit"
    echo "╚════════════════════════════╝"
}

enable_ghost_mode() {
    echo "[*] Enabling Ghost Mode..."
    sudo iptables -F
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A OUTPUT -o lo -j ACCEPT
    sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
    sudo iptables -A INPUT -p tcp --sport 443 -j ACCEPT
    echo "[+] Ghost Mode Enabled."
}

disable_ghost_mode() {
    echo "[*] Disabling Ghost Mode..."
    sudo iptables -F
    sudo iptables -P INPUT ACCEPT
    sudo iptables -P FORWARD ACCEPT
    sudo iptables -P OUTPUT ACCEPT
    echo "[+] Ghost Mode Disabled."
}

block_ipv6() {
    echo "[*] Blocking IPv6..."
    echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo "[+] IPv6 Blocked."
}

check_dns_leak() {
    echo "[*] Checking DNS Leaks..."
    dig +short txt o-o.myaddr.l.google.com @ns1.google.com
    curl -s https://dnsleaktest.com | grep -Eo "Your IP:.*|ISP:.*|Country:.*"
}

monitor_dnscrypt() {
    echo "[*] Monitoring dnscrypt-proxy..."
    sudo systemctl status dnscrypt-proxy
}

while true; do
    show_menu
    read -rp "Select an option [1-6]: " choice
    case $choice in
        1) enable_ghost_mode ;;
        2) disable_ghost_mode ;;
        3) block_ipv6 ;;
        4) check_dns_leak ;;
        5) monitor_dnscrypt ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Press Enter."; read ;;
    esac
    echo "Press Enter to return to menu..."
    read
done
