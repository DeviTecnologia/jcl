{**************************************************************************************************}
{                                                                                                  }
{ Project JEDI Code Library (JCL) extension                                                        }
{                                                                                                  }
{ The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License"); }
{ you may not use this file except in compliance with the License. You may obtain a copy of the    }
{ License at http://www.mozilla.org/MPL/                                                           }
{                                                                                                  }
{ Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF   }
{ ANY KIND, either express or implied. See the License for the specific language governing rights  }
{ and limitations under the License.                                                               }
{                                                                                                  }
{ The Original Code is JediInstallIntf.pas.                                                        }
{                                                                                                  }
{ The Initial Developer of the Original Code is Petr Vones. Portions created by Petr Vones are     }
{ Copyright (C) of Petr Vones. All Rights Reserved.                                                }
{                                                                                                  }
{ Contributor(s): Robert Rossmair (crossplatform & BCB support)                                    }
{                                                                                                  }
{ Last modified: $Date$                                                      }
{                                                                                                  }
{**************************************************************************************************}

unit JediInstall;

interface

uses
  SysUtils, Classes,
  JclSysUtils, JclBorlandTools;

type
  TJediInstallOption =
    (
      ioTarget,
      ioJCL,
      ioJclEnv,
      ioJclEnvLibPath,
      ioJclEnvBrowsingPath,
      ioJclEnvDebugDCUPath,
      ioJclMake,
      ioJclMakeRelease,
      ioJclMakeReleaseVClx,
      ioJclMakeDebug,
      ioJclMakeDebugVClx,
      ioJclCopyHppFiles,
      ioJclPackages,
      ioJclExperts,
      ioJclExpertDebug,
      ioJclExpertAnalyzer,
      ioJclExpertFavorite,
      ioJclExpertsThrNames,
      ioJclCopyPackagesHppFiles,
      ioJclExcDialog,
      ioJclExcDialogVCL,
      ioJclExcDialogVCLSnd,
      ioJclExcDialogCLX,
      ioJclHelp,
      ioJclHelpHlp,
      ioJclHelpChm              // = ioJclLast, see below.
    );

  TInstallOptionData = record
    Parent: TJediInstallOption;
    Caption: string;
    Hint: string;
  end;

const
  ioJclLast = ioJclHelpChm;
  Prefixes: array[TJclBorRadToolKind] of Char = ('D', 'C');

type
  TDialogType = (dtWarning, dtError, dtInformation, dtConfirmation);
  TDialogResponse = (drYes, drNo, drOK, drCancel);
  TDialogResponses = set of TDialogResponse;

  TInstallationEvent = procedure (Installation: TJclBorRADToolInstallation) of object;
  TInstallationProgressEvent = procedure (Percent: Cardinal) of object;

  EJediInstallInitFailure = class(Exception);

  IJediInstallTool = interface
    ['{85408C67-92B5-42D0-84E0-D30201C0400D}']
    function Dialog(const Text: string; DialogType: TDialogType = dtInformation;
      Options: TDialogResponses = [drOK]): TDialogResponse;
    function BPLPath(Installation: TJclBorRADToolInstallation): string;
    function DCPPath(Installation: TJclBorRADToolInstallation): string;
    function FeatureChecked(FeatureID: Cardinal; Installation: TJclBorRADToolInstallation): Boolean;
    function GetBorRADToolInstallations: TJclBorRADToolInstallations;
    function OptionGUI(Installation: TJclBorRADToolInstallation): TObject;
    function GUIAddOption(GUI, Parent: TObject; Option: TJediInstallOption; const Text: string;
      StandAlone: Boolean = False; Checked: Boolean = True): TObject;
    procedure SetReadme(const FileName: string);
    procedure UpdateInfo(Installation: TJclBorRADToolInstallation; const InfoText: string);
    procedure UpdateStatus(const Text: string);
    procedure WriteInstallLog(Installation: TJclBorRADToolInstallation; const Text: string);
    property BorRADToolInstallations: TJclBorRADToolInstallations read GetBorRADToolInstallations;
    property Readme: string write SetReadme;
  end;

  IJediInstall = interface
    ['{2C4A8C85-18BB-4A67-B37F-806C60632569}']
    function FeatureInfoFileName(FeatureID: Cardinal): string;
    function GetHint(Option: TJediInstallOption): string;
    function InitInformation(const ApplicationFileName: string): Boolean;
    function Install: Boolean;
    function Uninstall: Boolean;
    function ReadmeFileName: string;
    //function InitFailures: TJediInstallInitFailures;
    procedure SetTool(const Value: IJediInstallTool);
    procedure SetOnProgress(Value: TInstallationProgressEvent);
    function Supports(Installation: TJclBorRADToolInstallation): Boolean;
    procedure SetOnWriteLog(Installation: TJclBorRADToolInstallation; Value: TTextHandler);
    procedure SetOnStarting(Value: TInstallationEvent);
    procedure SetOnEnding(Value: TInstallationEvent); // OnEnding called on success only
  end;

function OptionToStr(const Option: TJediInstallOption): string;

resourcestring
  RsCantFindFiles   = 'Can not find installation files, check your installation.';
  RsCloseRADTool    = 'Please close all running instances of Delphi/C++Builder IDE before the installation.';
  RsConfirmInstall  = 'Are you sure to install all selected features?';
  RsInstallSuccess  = 'Installation finished';
  RsInstallFailure  = 'Installation failed.'#10'Check compiler output for details.';
  RsNoInstall       = 'There is no Delphi/C++Builder installation on this machine. Installer will close.';
  RsUpdateNeeded    = 'You should install latest Update Pack #%d for %s.'#13#10 +
                      'Would you like to open Borland support web page?';

implementation

uses
  TypInfo;

function OptionToStr(const Option: TJediInstallOption): string;
begin
  Result := GetEnumName(TypeInfo(TJediInstallOption), Ord(Option));
end;

// History:

// $Log$
// Revision 1.9  2004/11/14 05:55:55  rrossmair
// - installer refactoring (continued)
//
// Revision 1.8  2004/11/09 07:51:37  rrossmair
// - installer refactoring (incomplete)
//

end.
