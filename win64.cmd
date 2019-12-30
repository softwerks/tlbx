@echo off

call vsprompt.cmd -arch=x64 -host_arch=x64

if [%1]==[] (set target=all) else (set target=%1)
goto %target%

:clean
rd /s /q build
rd /s /q bin

:all
if not exist build md build
if not exist bin md bin

:lib
rem SQLite
cl /O2 /DSQLITE_API=__declspec(dllexport) /Fobuild\ lib\sqlite3\sqlite3.c /LD /link /dll /out:bin\sqlite3.dll /implib:build\sqlite3.lib
rem Lua
set lua_files=lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c liolib.c lmathlib.c loslib.c lstrlib.c ltablib.c lutf8lib.c loadlib.c linit.c
pushd lib\lua\src
cl /O2 /DLUA_BUILD_AS_DLL /Fo..\..\..\build\ %lua_files% /LD /link /dll /out:..\..\..\bin\lua53.dll /implib:..\..\..\build\lua53.lib
popd

:fast
cl /Fobuild\ src\*.c /link build\sqlite3.lib build\lua53.lib /out:bin\tlbx.exe
