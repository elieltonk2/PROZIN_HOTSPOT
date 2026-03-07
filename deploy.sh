#!/bin/bash

# =================================================================
# SCRIPT DE DEPLOY AUTOMÁTICO - PROZIN HOTSPOT
# =================================================================

# 1. Entrar na pasta do projeto (ajuste o caminho se necessário)
# cd /caminho/para/seu/app

echo "🚀 Iniciando Deploy..."

# 2. Puxar as últimas alterações do GitHub
echo "📥 Atualizando código do GitHub..."
git pull origin main

# 3. Instalar dependências (sem mexer no sistema global)
echo "📦 Instalando dependências..."
npm install

# 4. Gerar o Build do Frontend
echo "🏗️ Gerando build de produção..."
npm run build

# 5. Reiniciar o processo
# Verificamos se o PM2 está instalado para reiniciar de forma segura
if command -v pm2 &> /dev/null
then
    echo "🔄 Reiniciando com PM2..."
    # Tenta reiniciar, se não existir, inicia usando o arquivo de configuração
    pm2 restart prozin-hotspot || pm2 start ecosystem.config.cjs
# 31. Caso o PM2 não esteja disponível
else
    echo "⚠️ PM2 não encontrado. Tentando reiniciar manualmente..."
    # Em vez de matar tudo na porta 3000, apenas tentamos iniciar o app
    # Se a porta estiver ocupada, o próprio Node vai avisar o erro
    nohup npm start > output.log 2>&1 &
    echo "✅ Tentativa de início em background finalizada. Verifique output.log"
fi

echo "✨ Deploy finalizado com sucesso!"
