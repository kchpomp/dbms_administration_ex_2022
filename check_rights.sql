-- CODE THAT ALLOWS TO ITERATE OVER ALL TABLES IN THE DATABASE USING T-SQL
--USE [testing_db]
--GO

CREATE PROCEDURE [CheckRights]
	AS BEGIN
	DECLARE @Table TABLE
	(
	TableName VARCHAR(50),
	Id int identity(1,1)
	)


	INSERT INTO @Table
	SELECT table_name FROM INFORMATION_SCHEMA.COLUMNS 


	DECLARE @max int
	DECLARE @SQL VARCHAR(MAX) 
	DECLARE @TableName VARCHAR(50)
	DECLARE @id int = 1

	select @max = MAX(Id) from @Table


	WHILE (@id <= @max)
		BEGIN
			SELECT @TableName = TableName FROM @Table WHERE Id = @id
			-- RIGHTS OF SERVER LEVEL
			SET @SQL = 'SELECT * FROM fn_my_permissions (NULL, ''SERVER'');'
			PRINT(@SQL)
			EXEC(@SQL)
			-- RIGHTS OF DATABASE LEVEL
			SET @SQL = 'SELECT * FROM fn_my_permissions (NULL, ''DATABASE'');'
			PRINT(@SQL)
			EXEC(@SQL)
			-- RIGHTS FOR OBJECT
			SET @SQL = 'SELECT * FROM fn_my_permissions ('''+@TableName+''', ''OBJECT'');'
			PRINT(@SQL)
			EXEC(@SQL)
			
			SET @id = @id +1
		END
	END
GO

EXEC [CheckRights]
