#!/bin/bash

# Definir los colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
WHITE='\033[0;37m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'  # Sin color

# Definir una lista de colores para cada nivel de dependencias
COLORS=($GREEN $RED $BLUE $YELLOW $WHITE $CYAN $PURPLE)

# Función recursiva para obtener las dependencias sin repetir, mostrando con colores e indentación
get_dependencies() {
    local package=$1
    local level=$2
    local indent=$(printf "%${level}s")  # Generar la indentación
    local deps

    # Si ya hemos listado este paquete, no lo repetimos
    if [[ " ${visited[@]} " =~ " ${package} " ]]; then
        return
    fi

    # Marcar el paquete como visitado
    visited+=("$package")

    # Obtener las dependencias del paquete
    deps=$(apt-cache depends --no-pre-depends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances -qqqq "$package" \
           | sed -z 's/\n  Depends: /,/g;s/\n |Depends: /,/g;s/\n    /,/g;s/>//g;s/<//g' | tr ',' '\n' | sort -u)

    # Obtener el color correspondiente al nivel actual
    color=${COLORS[$((level % ${#COLORS[@]}))]}

    # Imprimir el paquete con el color correspondiente al nivel y con la indentación
    echo -e "${indent}${color}${package}${NC}"

    # Llamar a la función recursiva para cada dependencia
    for dep in $deps; do
        if [[ -n "$dep" ]]; then
            get_dependencies "$dep" $((level + 2))  # Incrementar la indentación
        fi
    done
}

# Función para manejar múltiples paquetes
process_packages() {
    for package in "$@"; do
        echo -e "${CYAN}Procesando paquete: ${package}${NC}"
        get_dependencies "$package" 0
    done
}

# Si no se proporciona ningún paquete
if [ -z "$1" ]; then
    echo -e "${RED}No se proporcionó ningún paquete como argumento.${NC}"
else
    # Inicializar una lista de paquetes visitados
    visited=()

    # Guardar la salida en una variable y pasarla a less -R para mantener los colores
    output=$(process_packages "$@")
    echo "$output" | less -R
fi
