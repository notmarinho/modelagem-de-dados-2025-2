# apt install -y default-mysql-client # Necessário no DEBIAN
# Apenas para o script que usa LOAD DATA LOCAL INFILE
# Recomendo que execute isso via CLI no ambiente
# mysql -h 127.0.0.1 -u root -p DB_CRIMES_LA < popular_tabelas.sql

#!/bin/bash

# ==============================================================================
# Script para Instalar o MySQL 8.0 via Docker no Debian
# ATENÇÃO: Expõe a porta 3306 publicamente. Use apenas em desenvolvimento.
# ==============================================================================

# --- Variáveis de Configuração (EDITAR AQUI) ---

# Nome do contêiner Docker
CONTAINER_NAME="mysql"

# SENHA DO ROOT: Troque por uma senha forte e segura!
MYSQL_ROOT_PASSWORD="Model@2025"

# Banco de dados inicial que será criado (opcional)
MYSQL_DATABASE="crimes"

# Diretório no servidor Debian para persistir os dados do MySQL
# IMPORTANTE: Isso garante que seus dados não sejam perdidos se o contêiner for removido.
DATA_VOLUME_PATH="/var/lib/mysql-docker-data"

# --- Fim da Configuração ---


# Função para imprimir mensagens
echo_info() {
    echo "INFO: $1"
}


# 2. Verificação de Segurança da Senha
if [ "$MYSQL_ROOT_PASSWORD" == "sua_senha_super_secreta_aqui" ]; then
    echo "====================================================="
    echo "!!! ATENÇÃO: Você está usando a senha padrão. !!!"
    echo "!!! Por favor, edite o script e defina uma senha forte na variável MYSQL_ROOT_PASSWORD."
    echo "====================================================="
    exit 1
fi

# 3. Criação do diretório de volume
if [ ! -d "$DATA_VOLUME_PATH" ]; then
    echo_info "Criando diretório para dados persistentes em ${DATA_VOLUME_PATH}..."
    sudo mkdir -p "$DATA_VOLUME_PATH"
fi

# 4. Parar e remover qualquer contêiner antigo com o mesmo nome
if [ "$(sudo docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo_info "Parando contêiner antigo chamado ${CONTAINER_NAME}..."
    sudo docker stop $CONTAINER_NAME
fi
if [ "$(sudo docker ps -aq -f status=exited -f name=$CONTAINER_NAME)" ]; then
    echo_info "Removendo contêiner antigo chamado ${CONTAINER_NAME}..."
    sudo docker rm $CONTAINER_NAME
fi

# 5. Iniciar o Contêiner MySQL
echo_info "Iniciando o contêiner MySQL..."
sudo docker run -d \
    --name $CONTAINER_NAME \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    -e MYSQL_DATABASE=$MYSQL_DATABASE \
    -v $DATA_VOLUME_PATH:/var/lib/mysql \
    --restart=always \
    mysql:8.0 --local-infile=1

echo_info "Aguardando o MySQL iniciar..."
sleep 20

# 6. Verificar o status do contêiner
echo_info "Verificando o status do contêiner:"
sudo docker ps -f name=$CONTAINER_NAME

echo ""
echo_info "Script concluído! Seu servidor MySQL está rodando."
echo_info "Para ver os logs, use o comando: sudo docker logs ${CONTAINER_NAME}"

