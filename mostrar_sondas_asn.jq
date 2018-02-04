# Mostrar el contenido del archivo sondas_asn.json

"Hay " + (length | tostring) + " ASN en Bolivia. Número de sondas para cada ASN:",
  (.[] | (" - " + (.sondas|tostring) + " sondas - "0 + .nombre + " (" + .asn + ")") )
