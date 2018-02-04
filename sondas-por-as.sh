#!/bin/bash

function nombre_asn {
  # Descargar la información del número autónomo
  [ -e /tmp/$1.txt  ] || curl -s https://rdap.lacnic.net/rdap/autnum/$1 > /tmp/$1.txt
  # En caso de error "429" (Query rate limit exceeded), avisar y salir
  if [ $(jq .errorCode /tmp/$1.txt) = "429" ]
  then
    nombre="Error -> Query rate limit exceeded"
    mv /tmp/$1.txt /tmp/$1.txt.old
  else
    nombre=$(cat /tmp/$1.txt | jq --raw-output --from-file nombre_asn.jq)
  fi
  printf "AS %s - nombre: %s\n" "$1" "$nombre"
}

# Lista de los ASN de Bolivia
[ -e /tmp/asns.txt  ] || curl -s www.cc2asn.com/data/bo_asn > /tmp/asn.txt;

# Sacar el prefijo "AS"
sed -i s/AS// /tmp/asn.txt

# Buscar el nombre de la entidad que reservó el ASN
cat /tmp/asn.txt | while read line ; do nombre_asn $line ; done
