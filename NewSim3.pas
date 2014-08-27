unit NewSim3;

interface

uses
  Windows, Variants, Classes, Controls, Forms,
  StdCtrls, Buttons, ComCtrls, ShellCtrls;

type
  TDirForm = class(TForm)
    ShellTreeView: TShellTreeView;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DirForm: TDirForm;

implementation

uses NewSim1;

{$R *.dfm}

procedure TDirForm.CancelButtonClick(Sender: TObject);
begin
     Close;
end;

procedure TDirForm.OkButtonClick(Sender: TObject);
begin
     MainForm.OutputDirBox.Text := ShellTreeView.Path;
end;

end.
