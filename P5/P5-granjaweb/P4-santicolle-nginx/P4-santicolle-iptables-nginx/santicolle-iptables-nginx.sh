# #!/bin/bash

# # Limpiar reglas existentes
# iptables -F
# iptables -X

# # Establecer políticas por defecto
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT ACCEPT

# # Permitir tráfico local
# iptables -A INPUT -i lo -j ACCEPT

# # Permitir conexiones establecidas y relacionadas
# iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# # Permitir tráfico HTTP (puerto 80) y HTTPS (puerto 443)
# iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# # Limitar el número de conexiones nuevas por IP a 10 cada 60 segundos
# iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
# iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
# iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set
# iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

# # Bloquear IPs que intenten más de 20 conexiones en 60 segundos
# iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set
# iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 60 --hitcount 20 -j DROP
# iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --set
# iptables -A INPUT -p tcp --dport 443 -m state --state NEW -m recent --update --seconds 60 --hitcount 20 -j DROP

# # Limitar el número de paquetes ICMP (ping) a 1 por segundo, con un burst de 5
# iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 5 -j ACCEPT
# iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# # Bloquear paquetes fragmentados
# iptables -A INPUT -f -j DROP

# # Limitar conexiones simultáneas a Nginx (puerto 80 y 443)
# iptables -A INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 20 -j REJECT
# iptables -A INPUT -p tcp --syn --dport 443 -m connlimit --connlimit-above 20 -j REJECT

# # Guardar las reglas
# iptables-save > /etc/iptables/rules.v4

# echo "Reglas de IPTABLES aplicadas con éxito en el balanceador de carga"
