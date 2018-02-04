# Obtiene el número de sondas del AS dado por el parametro "asn"

# Seleccionar las sondas
.results
  # Filtrar solo las sondas que usan del número autónomo $asn
  | [.[] | select(.asn_v4 == $asn or .asn_v6 == $asn)]
  # Contar
  | length
