; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Reverse Engineer's Toolkit"
#define MyAppVersion "2021c"
#define MyAppPublisher "Mente Bin�ria"
#define MySetupFileName "ret2021c_setup"
#define MyAppURL "https://github.com/mentebinaria/retoolkit"
#define MySrcDir "c:\tools\ret\"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{BB46345D-F5E9-408E-AA39-64A5EDD92E30}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=lowest
OutputBaseFilename={#MySetupFileName}
;Compression=none
WizardStyle=modern

[Components]
Name: "dotnet"; Description: ".NET"; Types: full;
#include "dotnet\de4dot.iss"
#include "dotnet\dnspy.iss"
#include "dotnet\ilspy.iss"

[Components]
Name: "compilers"; Description: "Compilers"; Types: full;
#include "compilers\fasm.iss"

[Components]
Name: "debuggers"; Description: "Debuggers"; Types: full;
#include "debuggers\x64dbg.iss"

[Components]
Name: "decompilers"; Description: "Decompilers"; Types: full;
#include "decompilers\exe2aut.iss"
#include "decompilers\ghidra.iss"
#include "decompilers\idr.iss"
#include "decompilers\jdgui.iss"
#include "decompilers\myauttoexe.iss"
#include "decompilers\recaf.iss"

[Components]
Name: "documentanalysis"; Description: "Document analysis"; Types: full;
#include "documentanalysis\officemalscanner.iss"

[Components]
Name: "hexadecimaleditors"; Description: "Hexadecimal editors"; Types: full;
#include "hexadecimaleditors\fhex.iss"
#include "hexadecimaleditors\imhex.iss"
#include "hexadecimaleditors\rehex.iss"

[Components]
Name: "peanalysers"; Description: "PE analysers"; Types: full;
#include "peanalysers\capa.iss"
#include "peanalysers\die.iss"
#include "peanalysers\exeinfope.iss"
#include "peanalysers\floss.iss"
#include "peanalysers\pebear.iss"
#include "peanalysers\pestudio.iss"
#include "peanalysers\pev.iss"

[Components]
Name: "peresourceeditors"; Description: "PE resource editors"; Types: full;
#include "peresourceeditors\reshack.iss"

[Components]
Name: "processmonitors"; Description: "Process monitors"; Types: full;
#include "processmonitors\apimonitor.iss"
#include "processmonitors\filegrab.iss"
#include "processmonitors\processhacker.iss"
#include "processmonitors\sysexp.iss"

[Components]
Name: "signaturetools"; Description: "Signature tools"; Types: full;
#include "signaturetools\yara.iss"

[Components]
Name: "unpacking"; Description: "Unpacking"; Types: full;
#include "unpacking\novmp.iss"
#include "unpacking\qunpack.iss"
#include "unpacking\upx.iss"
#include "unpacking\xvolkolak.iss"

[Components]
Name: "utilities"; Description: "Utilities"; Types: full;
;#include "utilities\7zip.iss"
#include "utilities\cyberchef.iss"
#include "utilities\bewareircd.iss"
#include "utilities\errorlookup.iss"
#include "utilities\manw.iss"
#include "utilities\ssview.iss"
#include "utilities\vt.iss"
#include "utilities\winapiexec.iss"

; ---

; [Icons]
; Name: "{userdesktop}\{#MyAppName}\Explore all tools"; Filename: "c:\windows\explorer.exe"

[Tasks]
Name: "addtopath"; Description: "Add programs to PATH (requires logging in again)";

[Code]
procedure EnvAddPath(Path: string);
var
    Paths: string;
begin
    { Retrieve current path (use empty string if entry not exists) }
    if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Paths)
    then Paths := '';

    { Skip if string already found in path }
    if Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';') > 0 then exit;

    { App string to the end of the path variable }
    Paths := Paths + ';'+ Path //+';'

    { Overwrite (or create if missing) path environment variable }
    if RegWriteStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Paths)
    then Log(Format('The [%s] added to PATH: [%s]', [Path, Paths]))
    else Log(Format('Error while adding the [%s] to PATH: [%s]', [Path, Paths]));
end;

procedure EnvRemovePath(Path: string);
var
    Paths: string;
    P: Integer;
begin
    { Skip if registry entry not exists }
    if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Paths) then
        exit;

    { Skip if string not found in path }
    P := Pos(';' + Uppercase(Path) + ';', ';' + Uppercase(Paths) + ';');
    if P = 0 then exit;

    { Update path variable }
    Delete(Paths, P - 1, Length(Path) + 1);

    { Overwrite path environment variable }
    if RegWriteStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', Paths)
    then Log(Format('The [%s] removed from PATH: [%s]', [Path, Paths]))
    else Log(Format('Error while removing the [%s] from PATH: [%s]', [Path, Paths]));
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
    if CurStep = ssPostInstall then
    begin
      EnvAddPath(ExpandConstant('{app}') +'\bin');
      if CompareText(WizardSelectedComponents(False), 'dotnet,dotnet\de4dot') = 0 then EnvAddPath(ExpandConstant('{app}') +'\de4dot');
      if CompareText(WizardSelectedComponents(False), 'utilities,utilities\winapiexec') = 0 then EnvAddPath(ExpandConstant('{app}') +'\winapiexec');
      if CompareText(WizardSelectedComponents(False), 'documentanalysis,documentanalysis\officemalscanner') = 0 then EnvAddPath(ExpandConstant('{app}') +'\officemalscanner');
    end
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    if CurUninstallStep = usPostUninstall then
    begin
      EnvRemovePath(ExpandConstant('{app}') +'\bin');
      EnvRemovePath(ExpandConstant('{app}') +'\de4dot');
      EnvRemovePath(ExpandConstant('{app}') +'\winapiexec');
      EnvRemovePath(ExpandConstant('{app}') +'\officemalscanner');
    end
end;