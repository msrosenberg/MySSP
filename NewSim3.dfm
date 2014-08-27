object DirForm: TDirForm
  Left = 536
  Top = 143
  BorderStyle = bsDialog
  Caption = 'Directory'
  ClientHeight = 220
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ShellTreeView: TShellTreeView
    Left = 0
    Top = 0
    Width = 290
    Height = 169
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Align = alTop
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
  end
  object OkButton: TBitBtn
    Left = 32
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = OkButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 184
    Top = 184
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = CancelButtonClick
    Kind = bkCancel
  end
end
