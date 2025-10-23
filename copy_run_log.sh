#!/bin/bash
# Script para capturar o logcat do dispositivo/emulador e salvá-lo na raiz do projeto.

# 1. Caminho padrão para a ferramenta adb do Android SDK.
ADB_PATH="$HOME/Android/Sdk/platform-tools/adb"
LOG_DESTINATION_FILE="./run_log.txt"

# 2. Verifica se a ferramenta adb existe.
if [ ! -f "$ADB_PATH" ]; then
    echo "ERRO: A ferramenta 'adb' não foi encontrada em:"
    echo "$ADB_PATH"
    echo "Verifique se o Android SDK está instalado no local padrão."
    exit 1
fi

echo "Capturando o logcat do dispositivo..."
# 3. Limpa logs antigos antes de capturar os novos, e depois captura.
"$ADB_PATH" logcat -c
"$ADB_PATH" logcat -d > "$LOG_DESTINATION_FILE"

echo "Log do 'Run' (logcat) salvo com sucesso em: $LOG_DESTINATION_FILE"
EOF
