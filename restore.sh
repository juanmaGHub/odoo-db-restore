# !/bin/bash

echo "Restoring database..."
PGPASSWORD=$POSTGRES_PASSWORD
export PGPASSWORD
if [ $(psql -h $POSTGRES_HOST -U postgres -lqt | cut -d \| -f 1 | grep -w $ODOO_TARGET_DB_NAME) ]; then
    echo "A target database with the same name already exists."
    echo "Creating a backup of the target database ($ODOO_TARGET_DB_NAME-OLD-$(date +%F).sql)..."
    pg_dump -h $POSTGRES_HOST -U postgres $ODOO_TARGET_DB_NAME > $ODOO_TARGET_DB_NAME-OLD-$(date +%F).sql
    echo "Dropping the target database..."
    dropdb -h $POSTGRES_HOST -U postgres $ODOO_TARGET_DB_NAME
fi
echo "Creating the target database..."
createdb -h $POSTGRES_HOST -U postgres -O odoo $ODOO_TARGET_DB_NAME
echo "Restoring the database..."
psql -h $POSTGRES_HOST -U postgres -d $ODOO_TARGET_DB_NAME < ${BACKUP_DIR}/dump.sql
echo "Database restored."
echo "Cleaning the database..."
psql -h $POSTGRES_HOST -U postgres -d $ODOO_TARGET_DB_NAME -f scripts/default.sql
psql -h $POSTGRES_HOST -U postgres -d $ODOO_TARGET_DB_NAME -f scripts/custom.sql
echo "Database cleaned."
unset PGPASSWORD

echo "Restoring filestore..."
rm -rf $FILESTORE_PATH/$ODOO_TARGET_DB_NAME
mkdir -p $FILESTORE_PATH/$ODOO_TARGET_DB_NAME
cp -r ${BACKUP_DIR}/filestore/* $FILESTORE_PATH/$ODOO_TARGET_DB_NAME/
chown -R odoo:odoo $FILESTORE_PATH/$ODOO_TARGET_DB_NAME
echo "Filestore restored."

echo "Restore completed."
echo "You can now start the Odoo service."