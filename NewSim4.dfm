object ProgForm: TProgForm
  Left = 363
  Top = 662
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Simulation Progress'
  ClientHeight = 31
  ClientWidth = 295
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
  object BatchLabel: TLabel
    Left = 0
    Top = 16
    Width = 166
    Height = 15
    Caption = 'Processing Line 0 of Batchfile'
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 0
    Width = 295
    Height = 16
    Align = alTop
    Min = 0
    Max = 100
    Smooth = True
    Step = 1
    TabOrder = 0
  end
end
