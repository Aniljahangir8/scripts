ECHO OFF
:: set path to save backup files e.g. D:\backup
set BACKUPPATH=D:\DB_BACKUP

:: set name of the server and instance
set SERVERNAME=LOCALHOST\SQLEXPRESS

:: set database name
set DATABASENAME=DB_NAME

:: filename format Name-Date
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)

set DATESTAMP=%mydate%_%mytime%
set BACKUPFILENAME=%BACKUPPATH%\%DATABASENAME%-%DATESTAMP%.bak

SqlCmd -E -S %SERVERNAME% -d master -Q "BACKUP DATABASE [%DATABASENAME%] TO DISK = N'%BACKUPFILENAME%' WITH INIT, NOUNLOAD, NAME = N'%DATABASENAME% backup', NOSKIP, STATS = 10, NOFORMAT"

REM Delete BackupFiles older then 60 days
REM
REM Change the path to the directory where the MSSQL Backups are saved (This is set in the BackupSQLDatabases.sql file)
REM 
	FORFILES /p "D:\DB_BACKUP" /s /m *.bak /d -60 /c "CMD /C del /Q @FILE"


REM ----------
REM End of File
REM ----------

ECHO.