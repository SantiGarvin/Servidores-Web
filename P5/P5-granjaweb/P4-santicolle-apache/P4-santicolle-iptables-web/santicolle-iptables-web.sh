# #!/bin/bash

# # Limpiamos todas las reglas existentes
# iptables -F
# iptables -X

# # Establecemos políticas por defecto
# iptables -P INPUT DROP
# iptables -P FORWARD DROP
# iptables -P OUTPUT DROP

# # Permite el tráfico entrante y saliente en interfaces locales
# iptables -A INPUT -i lo -j ACCEPT
# iptables -A OUTPUT -o lo -j ACCEPT

# # Permite el tráfico entrante y saliente para HTTP (puerto 80) y HTTPS (puerto 443)
# iptables -A INPUT -p tcp --dport 80 -j ACCEPT
# iptables -A INPUT -p tcp --dport 443 -j ACCEPT
# iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
# iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

# # Permite conexiones establecidas y relacionadas 
# # (importante para seguir la secuencia de paquetes de una conexión ya aceptada)
# iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# # Asegura la comunicación específica entre el balanceador de carga y los servidores web
# iptables -A INPUT -p tcp -s 192.168.10.50 --dport 80 -j ACCEPT
# iptables -A INPUT -p tcp -s 192.168.10.50 --dport 443 -j ACCEPT

# # Registrar todo el tráfico no permitido (opcional)
# iptables -A INPUT -j LOG --log-prefix "IPTables-INPUT-Denied: " --log-level 4
# iptables -A OUTPUT -j LOG --log-prefix "IPTables-OUTPUT-Denied: " --log-level 4

# #### Comandos adicionales para configurar IPTABLES ####

# # Bloquear paquetes TCP con opciones de paquete inusuales
# iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
# iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# # Limitar conexiones nuevas (esto puede ayudar a detectar y bloquear escaneos de puertos)
# iptables -A INPUT -p tcp --syn -m limit --limit 1/second -j ACCEPT

# # Limitar el número de conexiones TCP simultáneas desde una sola IP
# iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 10 -j REJECT

# # Bloquear IPs que intentan demasiadas conexiones en un corto período de tiempo
# iptables -A INPUT -p tcp --dport 80 -m recent --name portscan --rcheck --seconds 86400 -j DROP
# iptables -A INPUT -p tcp --dport 80 -m recent --name portscan --remove
# iptables -A INPUT -p tcp --dport 80 -m recent --name portscan --set -j REJECT

# # Guardar las reglas
# iptables-save > /etc/iptables/rules.v4

# echo "Configuración de IPTABLES aplicada."


