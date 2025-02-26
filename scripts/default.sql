-- Purpose: Default SQL queries to normally be executed after restoring a production
-- database to a staging environment. You can comment, replace or remove any of the 
-- queries below if they are not needed.

-- If you are restoring a production database to a production environment, better
-- check this https://handbook.coopdevs.org/ca/Sysadmin/Odoo/manage-db-via-curl
-- -----------------------------------------------------------------------------------
-- Incoming mail servers
UPDATE fetchmail_server SET active='f';

-- Outgoing mail servers
UPDATE ir_mail_server SET active='f';

-- Disable crons
UPDATE ir_cron SET active ='f';