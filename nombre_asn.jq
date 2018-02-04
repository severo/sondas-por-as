# Obtiene el nombre de todas las entidades de un número autónomo

# Seleccionar las entidades
.entities
  # Filtrar solo las entidades que tienen el rol "registrant"
  | .[] | select(.roles == ["registrant"])
  # Guardar solo la primera, si hubiera varias
  # Obtener la vCard
  | .vcardArray
  | .[1]
  # Extraer la parte "fn"
  | .[] | select(.[0] == "fn")
  # El nombre es el cuarto elemento
  | .[3]
