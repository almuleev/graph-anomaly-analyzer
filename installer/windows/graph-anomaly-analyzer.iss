#ifndef AppName
  #define AppName "Graph Anomaly Analyzer"
#endif

#ifndef AppVersion
  #define AppVersion "0.2.0"
#endif

#ifndef DistDir
  #define DistDir "..\..\dist\windows\graph-anomaly-analyzer"
#endif

[Setup]
AppId={{6E65E2D7-6D63-46CE-A8AF-E6B8F3625A95}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=graph-anomaly-analyzer
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
OutputDir=..\..\dist
OutputBaseFilename=graph-anomaly-analyzer-setup-v{#AppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#DistDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Graph Anomaly Analyzer"; Filename: "{app}\graph-anomaly-analyzer.exe"
Name: "{autodesktop}\Graph Anomaly Analyzer"; Filename: "{app}\graph-anomaly-analyzer.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\graph-anomaly-analyzer.exe"; Description: "{cm:LaunchProgram,Graph Anomaly Analyzer}"; Flags: nowait postinstall skipifsilent
