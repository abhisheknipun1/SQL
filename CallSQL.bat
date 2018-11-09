cd /D Filepath  ----> c:/abc/pqr
sqlcmd -b -i "Filepath  ----> c:/abc/pqr/abc.sql"
ECHO Errorlevel: %errorlevel%
if %errorlevel% GEQ 1 (
echo Backup of Database has Failed
exit 1) else (echo Backup of Database has successfully completed)
