-- Step1 - Setting the DATABASE to SINGLE_USER
-- Step2 - Restoring the database
-- Step3 - Setting the DATABASE to MULTI_USER
-- Step4 - Setting the DATABASE to READ_WRITE Mode

DECLARE @DB NNVARCHAR(256) -- DATABASE
DECLARE @path VARCHAR(256) -- path for backup files
DECLARE @fileName NNVARCHAR(256) -- filename for backup
DECLARE @query1 NVARCHAR(256)
DECLARE @query2 NVARCHAR(256)
DECLARE @query3 NVARCHAR(256)

SET @path = 'A:\'	-----> Sample Path where need to restore, It will be any Path
DECLARE DBCursor CURSOR FOR 
        SELECT Name 
        FROM [DATABASE] ----->this is sample one ewmove []
        WHERE Name IN  
                ('database name 1','database name 2'.......'database name n')
        ORDER BY [database_id] DESC
OPEN DBCursor
FETCH NEXT FROM DBCursor INTO @DB
WHILE @@fetch_status = 0
        BEGIN -- WHILE BEGIN
                PRINT @DB
                SET @fileName = @path + @DB + '.BAK'
                SET @query1 ='ALTER DATABASE  ['+@DB+'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
                EXEC sp_executesql @query1
                RESTORE DATABASE @DB From DISK = @fileName WITH REPLACE
                SET @query2 ='ALTER DATABASE ['+@DB+'] SET MULTI_USER WITH ROLLBACK IMMEDIATE'
                EXEC sp_executesql @query2
                SET @query3 ='ALTER DATABASE ['+@DB+'] SET READ_WRITE WITH ROLLBACK IMMEDIATE'
                EXEC sp_executesql @query3
                SELECT user_access_desc FROM [DATABASE] ---> remove [] WHERE name = @DB
                select top 1 destination_database_name,restore_date  from where destination_database_name= '@DB' and user_name='user_name' order by restore_date desc
        FETCH NEXT FROM DBCursor INTO @DB
        END -- WHILE END
         
CLOSE DBCursor
DEALLOCATE DBCursor
EXEC sp_readerrorlog 0,1,'restore'
