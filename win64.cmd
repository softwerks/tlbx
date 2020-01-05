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
echo Building sqlite3...
cl /MP /O2 /LD /MD /DSQLITE_API=__declspec(dllexport) /Fobuild\ /nologo lib\sqlite3\sqlite3.c /link /out:bin\sqlite3.dll /implib:build\sqlite3.lib
rem Lua
set lua_files=lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c lundump.c lvm.c lzio.c lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c liolib.c lmathlib.c loslib.c lstrlib.c ltablib.c lutf8lib.c loadlib.c linit.c
pushd lib\lua\src
echo Building lua library...
cl /MP /O2 /LD /MD /DLUA_BUILD_AS_DLL /Fo..\..\..\build\ /nologo %lua_files% /link /out:..\..\..\bin\lua53.dll /implib:..\..\..\build\lua53.lib
echo Building lua interpreter...
cl /MP /O2 /MD /Fo..\..\..\build\ /nologo lua.c /link ..\..\..\build\lua53.lib /out:..\..\..\bin\lua.exe
echo Building lua compiler...
cl /MP /O2 /MD /Fo..\..\..\build\ /nologo luac.c %lua_files% /link /out:..\..\..\bin\luac.exe
popd
rem GLFW3
set glfw3_files=context.c init.c input.c monitor.c vulkan.c window.c win32_init.c win32_joystick.c win32_monitor.c win32_time.c win32_thread.c win32_window.c wgl_context.c egl_context.c osmesa_context.c
pushd lib\glfw3\src
echo Building glfw3...
cl /MP /O2 /LD /MD /D_GLFW_WIN32 /D_GLFW_BUILD_DLL /Fo..\..\..\build\ /nologo %glfw3_files% /link user32.lib gdi32.lib shell32.lib /out:..\..\..\bin\glfw3.dll /implib:..\..\..\build\glfw3.lib
popd

:fast
echo Building tlbx...
cl /MP /O2 /MD /Fobuild\ /nologo src\*.c /link build\sqlite3.lib build\lua53.lib build\glfw3.lib opengl32.lib /out:bin\tlbx.exe
