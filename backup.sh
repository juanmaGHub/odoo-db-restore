# !/bin/bash

echo "Please make sure that the odoo service is not running."

echo "Gathering facts..."
if [ -f ".env" ]; then
    export $(grep -v '^#' ".env" | xargs)
else
    echo "The required .env file is missing. Please check the README.md file."
    exit 1
fi

BACKUP_DIR=odoo_backups
echo "Creating backup directory..."
mkdir -p ${BACKUP_DIR}

if [ ! -z ${ODOO_HOST_PORT} ]; then
    ODOO_HOST_PORT=":${ODOO_HOST_PORT}"
fi
ODOO_URL=${ODOO_HOST_PROTOCOL}://${ODOO_HOST_NAME}${ODOO_HOST_PORT}/web/database/backup
echo "Creating backup from $ODOO_URL..."
echo "Database name: $ODOO_DB_NAME"
echo "Backup directory: $BACKUP_DIR"
echo "Backup filepath: ${BACKUP_DIR}/${ODOO_DB_NAME}-$(date +%F).zip"
echo "curl -X POST \
    -F "master_pwd=${ODOO_MASTER_PASSWORD}" \
    -F "name=${ODOO_DB_NAME}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DB_NAME}-$(date +%F).zip \
    ${ODOO_URL}"
curl -X POST \
    -F "master_pwd=${ODOO_MASTER_PASSWORD}" \
    -F "name=${ODOO_DB_NAME}" \
    -F "backup_format=zip" \
    -o ${BACKUP_DIR}/${ODOO_DB_NAME}-$(date +%F).zip \
    ${ODOO_URL}

echo "Unzipping backup..."
unzip ${BACKUP_DIR}/${ODOO_DB_NAME}-$(date +%F) -d ${BACKUP_DIR}