#!/usr/bin/env bash
RED='\033[1;31m'
GREEN='\033[1;32m'
YLLW='\033[1;33m'
NC='\033[0m'
# Comprobando permisos de administrador
if [ "$EUID" -ne 0 ]; then
	echo -e "[${RED}ERROR${NC}]\nEste script necesita ejecutarse como ${YLLW}administrador${NC}, por favor utilice \"${GREEN}sudo ./demo.sh${NC}\" para ejecutar el archivo";
	exit 1;
fi



# Iniciando Plymouth deamon para mostrar pantalla de inicio
echo -n "Iniciando plymounthd                                  >>>   ";
plymouthd ;
if [ $? -gt 0 ]; then
	echo -e "[${RED}ERROR${NC}]\nHubo un fallo al iniciar plymounthd" ;
	echo "Saliendo de plymouthd <<<"
	plymouth --quit ;
	if [ $? -gt 0 ]; then
		echo "Hubo un error al salir de plymouthd" ;
		echo "plymouthd seguirá ejecutando en segundo plano"
		exit 1;
	fi
	exit 1;
fi
echo -e "[${GREEN}OK${NC}]" ;



echo -n "Mostrando actual tema de pantalla de arranque         >>>   ";
plymouth show-splash ;
sleep 15 ;
echo -e "[${GREEN}OK${NC}]" ;



echo -n "Saliendo de plymouthd                                 >>>   ";
plymouth --quit ;
if [ $? -gt 0 ]; then
	echo -e "${RED}ERROR${NC}]\nHubo un fallo al intentar detener plymouthd, reintentando..." ;
	n=0 ;
	while [ $? -gt 0 -a $n -le 20 ]; do
		plymouth --quit ;
		n=$(( n+1 )) ;
	done
fi
echo -e "[${GREEN}OK${NC}]" ;



exit 0;
