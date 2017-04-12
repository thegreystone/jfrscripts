@ECHO OFF
REM This script will periodically create a time limited recording. Useful to sample a bit of data every once in a while.
REM
REM Usage: precord <pid> <template> <folder> <period (seconds)> <recordingtime (seconds)> <numberofdumps> 
REM
REM Example: precord 4711 profile C:\tmp\myrecordings 3600 60 24
REM
REM     This would create a recording from process 4711 using the template named profile (you can also specify the 
REM     absolute path to a .jfc file) every hour for the next 24 hours. Each recording will be a minute long.

SETLOCAL enabledelayedexpansion

SET PID=%1
IF NOT DEFINED PID (
	ECHO First argument must be the PID to do recordings on!
	EXIT /B 1
)

SET SETTINGS=%2
IF NOT DEFINED SETTINGS (
	ECHO Second argument must be the template to use!
	EXIT /B 2
)


SET FOLDER=%3
IF NOT DEFINED FOLDER (
	ECHO Third argument must be the folder to write recordings to!
	EXIT /B 3
)


SET DELAY=%4
IF NOT DEFINED DELAY (
	ECHO Fourth argument must be the delay between invocations in seconds!
	EXIT /B 4
)
 
SET RECORDINGTIME=%5
IF NOT DEFINED RECORDINGTIME (
	ECHO Fifth argument must be the recording time in seconds!
	EXIT /B 5
)

SET NUMBEROFDUMPS=%6
IF NOT DEFINED NUMBEROFDUMPS (
	ECHO Sixth argument must be the number of dumps to make!
	EXIT /B 6
)


echo Doing %NUMBEROFDUMPS% number of dumps with %DELAY% second interval of PID %PID%

FOR /L %%a IN (1,1,%NUMBEROFDUMPS%) DO (
	echo Will now do: jcmd %PID% JFR.start name="Recording_%PID%_%%a" filename=%FOLDER%\recording_%PID%_%%a.jfr settings=%SETTINGS% duration=%RECORDINGTIME%s
	call jcmd %PID% JFR.start name="Recording_%PID%_%%a" filename=%FOLDER%\recording_%PID%_%%a.jfr settings=%SETTINGS% duration=%RECORDINGTIME%s
	TIMEOUT /T %DELAY%
)
