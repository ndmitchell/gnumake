@echo off
rem Copyright (C) 1996-2012 Free Software Foundation, Inc.
rem This file is part of GNU Make.
rem
rem GNU Make is free software; you can redistribute it and/or modify it under
rem the terms of the GNU General Public License as published by the Free
rem Software Foundation; either version 3 of the License, or (at your option)
rem any later version.
rem
rem GNU Make is distributed in the hope that it will be useful, but WITHOUT
rem ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
rem FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for.
rem more details.
rem
rem You should have received a copy of the GNU General Public License along
rem with this program.  If not, see <http://www.gnu.org/licenses/>.

if exist config.h.W32 GoTo NotSCM
sed -n "s/^AC_INIT(\[GNU make\],\[\([^]]\+\)\].*/s,%%VERSION%%,\1,g/p" configure.in > config.h.W32.sed
echo s,%%PACKAGE%%,make,g >> config.h.W32.sed
sed -f config.h.W32.sed config.h.W32.template > config.h.W32
:NotSCM
if not exist config.h copy config.h.W32 config.h

rem Guile configuration
set GUILECFLAGS=
set GUILELIBS=
set GUILESRC=
set PKGMSC=
if "%1" == "--without-guile" GoTo NoGuile
if "%2" == "--without-guile" GoTo NoGuile
rem Build with Guile is supported only on NT and later versions
if not "%OS%" == "Windows_NT" GoTo NoGuile
pkg-config --help > guile.tmp 2> NUL
if ERRORLEVEL 1 GoTo NoPkgCfg
echo "Checking for Guile 2.0"
if not "%1" == "gcc" set PKGMSC=--msvc-syntax
pkg-config --cflags --short-errors "guile-2.0" > guile.tmp
if not ERRORLEVEL 1 set /P GUILECFLAGS= < guile.tmp
pkg-config --libs --static --short-errors %PKGMSC% "guile-2.0" > guile.tmp
if not ERRORLEVEL 1 set /P GUILELIBS= < guile.tmp
if not "%GUILECFLAGS%" == "" GoTo GuileDone
echo "Checking for Guile 1.8"
pkg-config --cflags --short-errors "guile-1.8" > guile.tmp
if not ERRORLEVEL 1 set /P GUILECFLAGS= < guile.tmp
pkg-config --libs --static --short-errors %PKGMSC% "guile-1.8" > guile.tmp
if not ERRORLEVEL 1 set /P GUILELIBS= < guile.tmp
if not "%GUILECFLAGS%" == "" GoTo GuileDone
echo "No Guile found, building without Guile"
GoTo NoGuile
:NoPkgCfg
echo "pkg-config not found, building without Guile"
:NoGuile
:GuileDone
if not "%GUILECFLAGS%" == "" echo "Guile found, building with Guile"
if not "%GUILECFLAGS%" == "" set GUILESRC=guile.c
if not "%GUILECFLAGS%" == "" set GUILECFLAGS=%GUILECFLAGS% -DHAVE_GUILE
if "%1" == "--without-guile" shift
cd w32\subproc
echo "Creating the subproc library"
%ComSpec% /c build.bat %1
cd ..\..

if exist link.dbg del link.dbg
if exist link.rel del link.rel
echo "Creating GNU Make for Windows 9X/NT/2K/XP"
if "%1" == "gcc" GoTo GCCBuild
set make=gnumake
echo on
if not exist .\WinDebug\nul mkdir .\WinDebug
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D TIVOLI /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c variable.c
echo WinDebug\variable.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c rule.c
echo WinDebug\rule.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c remote-stub.c
echo WinDebug\remote-stub.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c commands.c
echo WinDebug\commands.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c file.c
echo WinDebug\file.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c getloadavg.c
echo WinDebug\getloadavg.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c default.c
echo WinDebug\default.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c signame.c
echo WinDebug\signame.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c expand.c
echo WinDebug\expand.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c dir.c
echo WinDebug\dir.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od %GUILECFLAGS% /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c main.c
echo WinDebug\main.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c getopt1.c
echo WinDebug\getopt1.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c job.c
echo WinDebug\job.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c read.c
echo WinDebug\read.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c version.c
echo WinDebug\version.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c getopt.c
echo WinDebug\getopt.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c arscan.c
echo WinDebug\arscan.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c hash.c
echo WinDebug\hash.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c strcache.c
echo WinDebug\strcache.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c remake.c
echo WinDebug\remake.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c misc.c
echo WinDebug\misc.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c ar.c
echo WinDebug\ar.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c function.c
echo WinDebug\function.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c vpath.c
echo WinDebug\vpath.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c implicit.c
echo WinDebug\implicit.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c  .\w32\compat\dirent.c
echo WinDebug\dirent.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c  .\glob\glob.c
echo WinDebug\glob.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c  .\glob\fnmatch.c
echo WinDebug\fnmatch.obj >>link.dbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c  .\w32\pathstuff.c
echo WinDebug\pathstuff.obj >>link.dbg
if "%GUILESRC%" == "" GoTo LinkDbg
cl.exe /nologo /MT /W4 /GX /Zi /YX /Od %GUILECFLAGS%% /I . /I glob /I w32/include /D _DEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinDebug/ /Fp.\WinDebug/%make%.pch /Fo.\WinDebug/ /Fd.\WinDebug/%make%.pdb /c guile.c
echo WinDebug\guile.obj >>link.dbg
:LinkDbg
echo off
echo "Linking WinDebug/%make%.exe"
rem link.exe %GUILELIBS% kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib w32\subproc\windebug\subproc.lib /NOLOGO /SUBSYSTEM:console /INCREMENTAL:yes /PDB:.\WinDebug/%make%.pdb /DEBUG /OUT:.\WinDebug/%make%.exe .\WinDebug/variable.obj  .\WinDebug/rule.obj  .\WinDebug/remote-stub.obj  .\WinDebug/commands.obj  .\WinDebug/file.obj  .\WinDebug/getloadavg.obj  .\WinDebug/default.obj  .\WinDebug/signame.obj  .\WinDebug/expand.obj  .\WinDebug/dir.obj  .\WinDebug/main.obj  .\WinDebug/getopt1.obj  .\WinDebug/job.obj  .\WinDebug/read.obj  .\WinDebug/version.obj  .\WinDebug/getopt.obj  .\WinDebug/arscan.obj  .\WinDebug/remake.obj  .\WinDebug/hash.obj  .\WinDebug/strcache.obj  .\WinDebug/misc.obj  .\WinDebug/ar.obj  .\WinDebug/function.obj  .\WinDebug/vpath.obj  .\WinDebug/implicit.obj  .\WinDebug/dirent.obj  .\WinDebug/glob.obj  .\WinDebug/fnmatch.obj  .\WinDebug/pathstuff.obj
echo %GUILELIBS% kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib w32\subproc\windebug\subproc.lib >>link.dbg
link.exe /NOLOGO /SUBSYSTEM:console /INCREMENTAL:yes /PDB:.\WinDebug/%make%.pdb /DEBUG /OUT:.\WinDebug/%make%.exe @link.dbg
if not exist .\WinDebug/%make%.exe echo "WinDebug build failed"
if exist .\WinDebug/%make%.exe echo "WinDebug build succeeded!"
if not exist .\WinRel\nul mkdir .\WinRel
echo on
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /D TIVOLI /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c variable.c
echo WinRel\variable.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c rule.c
echo WinRel\rule.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c remote-stub.c
echo WinRel\remote-stub.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c commands.c
echo WinRel\commands.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c file.c
echo WinRel\file.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c getloadavg.c
echo WinRel\getloadavg.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c default.c
echo WinRel\default.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c signame.c
echo WinRel\signame.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c expand.c
echo WinRel\expand.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c dir.c
echo WinRel\dir.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 %GUILECFLAGS% /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c main.c
echo WinRel\main.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c getopt1.c
echo WinRel\getopt1.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c job.c
echo WinRel\job.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c read.c
echo WinRel\read.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c version.c
echo WinRel\version.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c getopt.c
echo WinRel\getopt.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c arscan.c
echo WinRel\arscan.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c remake.c
echo WinRel\remake.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c hash.c
echo WinRel\hash.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c strcache.c
echo WinRel\strcache.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c misc.c
echo WinRel\misc.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c ar.c
echo WinRel\ar.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c function.c
echo WinRel\function.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c vpath.c
echo WinRel\vpath.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c implicit.c
echo WinRel\implicit.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c  .\w32\compat\dirent.c
echo WinRel\dirent.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c  .\glob\glob.c
echo WinRel\glob.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c  .\glob\fnmatch.c
echo WinRel\fnmatch.obj >>link.rel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c  .\w32\pathstuff.c
echo WinRel\pathstuff.obj >>link.rel
if "%GUILESRC%" == "" GoTo LinkRel
cl.exe /nologo /MT /W4 /GX /YX /O2 /I . /I glob /I w32/include /D NDEBUG /D WINDOWS32 /D WIN32 /D _CONSOLE /D HAVE_CONFIG_H /FR.\WinRel/ /Fp.\WinRel/%make%.pch /Fo.\WinRel/ /c guile.c
echo WinRel\guile.obj >>link.rel
:LinkRel
echo off
echo "Linking WinRel/%make%.exe"
rem link.exe %GUILELIBS% kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib w32\subproc\winrel\subproc.lib /NOLOGO /SUBSYSTEM:console /INCREMENTAL:no /PDB:.\WinRel/%make%.pdb /OUT:.\WinRel/%make%.exe .\WinRel/variable.obj  .\WinRel/rule.obj  .\WinRel/remote-stub.obj  .\WinRel/commands.obj  .\WinRel/file.obj  .\WinRel/getloadavg.obj  .\WinRel/default.obj  .\WinRel/signame.obj  .\WinRel/expand.obj  .\WinRel/dir.obj  .\WinRel/main.obj  .\WinRel/getopt1.obj  .\WinRel/job.obj  .\WinRel/read.obj  .\WinRel/version.obj  .\WinRel/getopt.obj  .\WinRel/arscan.obj  .\WinRel/remake.obj  .\WinRel/misc.obj  .\WinRel/hash.obj  .\WinRel/strcache.obj  .\WinRel/ar.obj  .\WinRel/function.obj  .\WinRel/vpath.obj  .\WinRel/implicit.obj  .\WinRel/dirent.obj  .\WinRel/glob.obj  .\WinRel/fnmatch.obj  .\WinRel/pathstuff.obj
echo %GUILELIBS% kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib w32\subproc\winrel\subproc.lib >>link.rel
link.exe /NOLOGO /SUBSYSTEM:console /INCREMENTAL:no /PDB:.\WinRel/%make%.pdb /OUT:.\WinRel/%make%.exe @link.rel
if not exist .\WinRel/%make%.exe echo "WinRel build failed"
if exist .\WinRel/%make%.exe echo "WinRel build succeeded!"
set make=
GoTo BuildEnd
:GCCBuild
echo on
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c variable.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c rule.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c remote-stub.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c commands.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c file.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c getloadavg.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c default.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c signame.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c expand.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c dir.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H %GUILECFLAGS% -c main.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c getopt1.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c job.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c read.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c version.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c getopt.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c arscan.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c remake.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c hash.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c strcache.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c misc.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c ar.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c function.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c vpath.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c implicit.c
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c ./glob/glob.c -o glob.o
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c ./glob/fnmatch.c -o fnmatch.o
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c ./w32/pathstuff.c -o pathstuff.o
@echo off
set GUILEOBJ=
if "%GUILESRC%" == "" GoTo LinkGCC
set GUILEOBJ=guile.o
echo on
gcc -mthreads -Wall -gdwarf-2 -g3 -O2 %GUILECFLAGS% -I. -I./glob -I./w32/include -DWINDOWS32 -DHAVE_CONFIG_H -c guile.c
:LinkGCC
@echo on
gcc -mthreads -gdwarf-2 -g3 -o gnumake.exe variable.o rule.o remote-stub.o commands.o file.o getloadavg.o default.o signame.o expand.o dir.o main.o getopt1.o %GUILEOBJ% job.o read.o version.o getopt.o arscan.o remake.o misc.o hash.o strcache.o ar.o function.o vpath.o implicit.o glob.o fnmatch.o pathstuff.o w32_misc.o sub_proc.o w32err.o %GUILELIBS% -lkernel32 -luser32 -lgdi32 -lwinspool -lcomdlg32 -ladvapi32 -lshell32 -lole32 -loleaut32 -luuid -lodbc32 -lodbccp32
:BuildEnd
@echo off
set GUILEOBJ=
set GUILESRC=
set GUILELIBS=
set GUILECFLAGS=
set PKGMSC=
echo on
