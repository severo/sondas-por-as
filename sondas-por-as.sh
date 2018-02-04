#!/bin/bash

function nombre_asn {
  # Descargar la información del número autónomo - TODO: refrescar periodicamente
  [ -e /tmp/$1.json  ] || curl -s https://rdap.lacnic.net/rdap/autnum/$1 > /tmp/$1.json

  # En caso de error "429" (Query rate limit exceeded), avisar y salir
  if [ $(jq .errorCode /tmp/$1.json) = "429" ]
  then
    nombre="Error -> Query rate limit exceeded"
    mv /tmp/$1.json /tmp/$1.json.old
  else
    nombre=$(cat /tmp/$1.json | jq --raw-output --from-file nombre_asn.jq)
    numero_sondas=$(jq --raw-output --from-file numero_sondas.jq --argjson asn $1 /tmp/atlas_bo.json)
  fi

  # Añadir en el archivo JSON de salida
  jq --arg asn "$1" --arg nombre "$nombre" --argjson sondas $numero_sondas '. += [{asn: $asn, nombre: $nombre, sondas: $sondas}]' /tmp/sondas_asn.json > /tmp/sondas_asn.json.tmp
  mv /tmp/sondas_asn.json.tmp /tmp/sondas_asn.json
}

# Lista de los ASN de Bolivia, y sacar el prefijo "AS" - siempre descargar
curl -s www.cc2asn.com/data/bo_asn | sed s/AS// > /tmp/asn.json;

# Recuperar la lista de sondas en Bolivia - siempre descargar
curl -s https://atlas.ripe.net:443/api/v2/probes/?country_code=BO > /tmp/atlas_bo.json;

# Crear un JSON con los datos de cada ASN
jq -n '[]' > /tmp/sondas_asn.json
cat /tmp/asn.json | while read line ; do nombre_asn $line; done

# Ordenar por número de sondas
cat /tmp/sondas_asn.json | jq 'sort_by(.sondas) | reverse' > /tmp/sondas_asn.json.tmp
mv /tmp/sondas_asn.json.tmp /tmp/sondas_asn.json

# Mostrar
#jq --raw-output --from-file mostrar_sondas_asn.jq /tmp/sondas_asn.json
