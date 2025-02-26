# Odoo Backup and Restore Script

Scripts to backup and restore odoo databases. Typically to restore production database into test environments

## Overview
This script automates the process of backing up an Odoo database and restoring it to a target database. It:
- Downloads a backup from an Odoo instance.
- Extracts the backup.
- Restores the database.
- Cleans up the database with predefined SQL scripts.
- Restores the filestore.

## Prerequisites
Ensure that you have the following dependencies installed:
- `curl`
- `unzip`
- `psql` (PostgreSQL client)
- `pg_dump`
- `dropdb`
- `createdb`
- `chown`

## Environment Variables
The script requires a `.env` file in the same directory. The file should contain the following variables (see env.j2 template):

```env
# Odoo instance settings
ODOO_HOST_PROTOCOL=http
ODOO_HOST_NAME=localhost
ODOO_HOST_PORT=8069
ODOO_DB_NAME=your_db_name
ODOO_MASTER_PASSWORD=your_master_password

# PostgreSQL settings
POSTGRES_HOST=localhost
POSTGRES_PASSWORD=your_postgres_password
ODOO_TARGET_DB_NAME=your_target_db_name

# File storage path
FILESTORE_PATH=/path/to/filestore
```

> **Important:** Ensure that your `.env` file is correctly formatted and does not contain any syntax errors.

## Usage

### 1. Stop the Odoo Service
Before running the script, **ensure that the Odoo service is stopped** to prevent conflicts.

### 2. Run the Script
Execute the script with the following command:

```sh
bash run.sh
```

### 3. Backup Process
- The script will create a backup directory (`odoo_backups`) if it does not exist.
- It will send a request to the Odoo instance to generate a backup.
- The backup file is saved in the `odoo_backups` directory.

### 4. Restore Process
- The script extracts the backup.
- It checks if the target database exists:
  - If it exists, it creates a backup and then drops it.
  - It then creates a new database and restores the Odoo database dump.
- It runs predefined SQL scripts (`scripts/default.sql` and `scripts/custom.sql`) for cleanup.
- The filestore is restored and appropriate permissions are set.

### 5. Start the Odoo Service
Once the script completes successfully, restart the Odoo service:

```sh
sudo systemctl start odoo
```

## Troubleshooting

### 1. "End-of-central-directory signature not found"
This error may indicate that the backup file is corrupted or incomplete. Try:
- Checking if the backup was fully downloaded.
- Running `file your_backup.zip` to verify its format.
- Using `unzip -l your_backup.zip` to inspect its contents.

### 2. "Database does not exist"
If you get an error stating that the database does not exist:
- Ensure that the correct database name is set in `.env`.
- Confirm that PostgreSQL is running with `systemctl status postgresql`.

### 3. "Permission denied" Errors
- Ensure that the script has execution permissions:
  ```sh
  chmod +x run.sh
  ```
- If running as a different user, make sure they have permission to access the database and filestore.

## Notes
- **Do not commit your `.env` file to version control** as it contains sensitive credentials.
- The script assumes that the Odoo database is backed up in **ZIP format** with a PostgreSQL dump and filestore.

## License
This script is provided "as-is" without any warranties. Use at your own risk.

## Author
SomIT


