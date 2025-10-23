#!/bin/bash
# Master script para copiar o arquivo de log correto (build ou run) baseado no input.

# Verifica o primeiro argumento passado para o script
case "$1" in
  build)
    echo "--> Copiando o log de BUILD..."
    # Verifica se o script de build existe antes de tentar executá-lo
    if [ -f "./copy_build_log.sh" ]; then
        ./copy_build_log.sh
    else
        echo "ERRO: O script 'copy_build_log.sh' não foi encontrado!"
        exit 1
    fi
    ;;

  run)
    echo "--> Copiando o log de RUN (logcat)..."
    # Verifica se o script de run existe antes de tentar executá-lo
    if [ -f "./copy_run_log.sh" ]; then
        ./copy_run_log.sh
    else
        echo "ERRO: O script 'copy_run_log.sh' não foi encontrado!"
        exit 1
    fi
    ;;

  *)
    # Se nenhum argumento (ou um argumento inválido) for passado, mostra a ajuda
    echo "Uso: $0 {build|run}"
    echo
    echo "  build   - Use este comando quando o projeto falhar ao compilar."
    echo "  run     - Use este comando quando o aplicativo rodar, mas travar ou apresentar erros."
    exit 1
    ;;
esac
