#!/bin/bash

# Limitar el número de conexiones nuevas por IP a 5 cada 10 segundos
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 10 --hitcount 5 -j DROP

# Bloquear IPs que intenten más de 10 conexiones en 10 segundos
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 10 --hitcount 10 -j DROP

# Limitar el número de paquetes ICMP (ping) a 1 por segundo, con un burst de 5
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 5 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Bloquear paquetes fragmentados
iptables -A INPUT -f -j DROP

# Limitar el número de conexiones SSH (puerto 22) a 3 por minuto por IP (si es necesario)
# iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
# iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 3 -j DROP

# Limitar conexiones simultáneas a Nginx (puerto 443)
iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 5 -j REJECT

echo "Reglas de IPTABLES aplicadas con éxito"