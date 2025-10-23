#!/bin/bash
# Script para encontrar o log de build mais recente do Android Studio e copiá-lo para o projeto.

# 1. Diretório base onde os logs do Android Studio são armazenados.
STUDIO_CACHE_DIR="$HOME/.cache/Google"
LOG_DESTINATION_FILE="./build_log.txt"

# 2. Encontra o arquivo build.log mais recentemente modificado em todas as pastas de versão do Android Studio.
LOG_SOURCE_FILE=$(find "$STUDIO_CACHE_DIR" -name build.log -printf '%T@ %p\n' | sort -n | tail -n 1 | cut -d' ' -f2-)

# 3. Verifica se um arquivo de log foi encontrado.
if [ -n "$LOG_SOURCE_FILE" ] && [ -f "$LOG_SOURCE_FILE" ]; then
    echo "Log de build mais recente encontrado em:"
    echo "$LOG_SOURCE_FILE"
    echo "Copiando para o projeto..."
    cp "$LOG_SOURCE_FILE" "$LOG_DESTINATION_FILE"
    echo "Log copiado com sucesso para: $LOG_DESTINATION_FILE"
else
    echo "ERRO: Nenhum arquivo 'build.log' do Android Studio foi encontrado."
    echo "Verifique se você já executou um build e se o diretório de cache está correto."
fi
