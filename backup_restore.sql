-- TEST BACKUP STORED PROCEDURE
USE master
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [DB_Backup]

	@name VARCHAR(MAX) -- DB NAME TO CREATE BACKUP
	AS
	BEGIN

		DECLARE @path VARCHAR(256) -- path of backup files
		DECLARE @fileName VARCHAR(256) -- filename for backup
		DECLARE @fileDate VARCHAR(20) -- used for file name
		DECLARE @filenum INT -- version number

		SET @path = 'C:\Users\Public\DBMS Administration\'
		SET @filenum = 1

		-- specify filename format
		SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

		BEGIN
			SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
			BACKUP DATABASE @name TO DISK = @fileName WITH --DIFFERENTIAL,
														   STATS=10,
														   COMPRESSION,
														   INIT -- creating differential database backup with backup progress, compression
		END

		SET @filenum = @filenum + 1

	END
GO

-- Likewise just pass names of db’s to stored procedure to create backup. 
EXEC [DB_Backup] @name = 'testing_db'

-- GRANT EXECUTE ON [dbo].[DB_Backup] to [dmalt]


-- DATABASE RESTORATION STORED PROCEDURE
USE [master]
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

-- TEST RESTORE STORED PROCEDURE
ALTER PROCEDURE DB_Restore 

	@dbname NVARCHAR(MAX),
	@restoredDBname NVARCHAR(MAX)

	AS BEGIN
		-- DECLARE ALL HELPING VARIABLES
		DECLARE @path VARCHAR(256)
		DECLARE @fileDate VARCHAR(20)
		DECLARE @log_name VARCHAR(MAX)
		DECLARE @backup_dir_bak NVARCHAR(256)
		DECLARE @store_dir NVARCHAR(256)
		DECLARE @backup_dir_dat NVARCHAR(256)
		DECLARE @backup_dir_log NVARCHAR(256)

		-- SET FIXED VARIABLES
		SET @path = 'C:\Users\Public\DBMS Administration\'
		SET @store_dir = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA'
		SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

		BEGIN
			-- SET NECESSARY VARIABLES
			SET @log_name = @restoredDBname + '_log'
			SET @backup_dir_bak = @path + @dbname + '_' + @fileDate + '.BAK' -- directory where to take backup file
			SET @backup_dir_dat = @store_dir + @restoredDBname + '.MDF' -- directory for storing *.mdf file
			SET @backup_dir_log = @store_dir + @log_name + '.LDF' -- directory for storing *.log file


			--RESTORE DATABASE @dbname FROM DISK = @backup_dir_bak WITH MOVE @restoredDBname TO @backup_dir_dat,
																	  --MOVE @log_name TO @backup_dir_log,
																	  --NOUNLOAD,
																	  --REPLACE,
																	  --STATS=10

			RESTORE DATABASE @dbname FROM DISK = @backup_dir_bak WITH NOUNLOAD,
																	  NORECOVERY,
																	  REPLACE,
																	  STATS=10;	
		END
	END
GO

EXEC [DB_Restore] @dbname='testing_db', @restoredDBname='new_testing_db';

---------------------------------------------------------------------------------------------------------------------------------------
