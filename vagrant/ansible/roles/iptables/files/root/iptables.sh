#!/bin/sh

systemctl stop iptables

# flush everything
iptables -F

## DROP
# null packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# syn-flood packets
iptables -A INPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
# xmas packets
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
# invalid packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
##

## ACCEPT
# loopback interface
iptables -A INPUT -i lo -j ACCEPT

# established and related incoming connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# established outgoing connections
#iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

# web traffic
#iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# mail traffic
#iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 465 -j ACCEPT
# POP
#iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
# IMAP
#iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT

# ssh
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# vpn
iptables -A INPUT -i eth0 -m conntrack --ctstate NEW -p tcp --dport 1194 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

## extras
# plex
iptables -A INPUT -p tcp -m tcp --dport 32400 -s 10.8.0.1/16 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 32400 -s 86.247.33.85/32 -j ACCEPT
# transmission
iptables -A INPUT -p tcp -m tcp --dport 9091 -s 10.8.0.1/16 -j ACCEPT
##

# allow all outgoing connections and block everything else
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP

# save + start
iptables-save | sudo tee /etc/sysconfig/iptables
systemctl start iptables
