unit NewSim1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, MolDefs, Grids, StBase,
  StVInfo, Contnrs, NewSimCMD;

type

  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    TreeButton: TBitBtn;
    TreeLabel: TLabel;
    DisplayTreeButton: TBitBtn;
    NodesButton: TBitBtn;
    NGeneBox: TLabeledEdit;
    Bevel1: TBevel;
    CreateGenes: TBitBtn;
    Bevel2: TBevel;
    GeneNBox: TLabeledEdit;
    UpDown: TUpDown;
    GroupBox3: TGroupBox;
    SeqLengthBox: TLabeledEdit;
    FaBox: TLabeledEdit;
    FcBox: TLabeledEdit;
    FtBox: TLabeledEdit;
    FgBox: TLabeledEdit;
    GroupBox4: TGroupBox;
    ModelBox: TRadioGroup;
    RateBox: TLabeledEdit;
    KappaBox: TLabeledEdit;
    GammaBox: TCheckBox;
    AlphaBox: TLabeledEdit;
    TargABox: TLabeledEdit;
    TargCBox: TLabeledEdit;
    TargGBox: TLabeledEdit;
    TargTBox: TLabeledEdit;
    TargetLabel: TLabel;
    Output: TGroupBox;
    PrefixBox: TLabeledEdit;
    RepBox: TLabeledEdit;
    CloseButton: TBitBtn;
    RunButton: TBitBtn;
    BatchButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    OutputDirBox: TLabeledEdit;
    DirButton: TSpeedButton;
    BatchDialog: TOpenDialog;
    ResetButton: TBitBtn;
    ProgressBar: TProgressBar;
    BatchLabel: TLabel;
    SimLabel: TLabel;
    gracbox: TLabeledEdit;
    gragbox: TLabeledEdit;
    gratbox: TLabeledEdit;
    grcgbox: TLabeledEdit;
    grctbox: TLabeledEdit;
    grgtbox: TLabeledEdit;
    Bevel3: TBevel;
    OutputBox: TRadioGroup;
    IndelBox: TGroupBox;
    InsertionBox: TCheckBox;
    InsertionRateBox: TLabeledEdit;
    InsertionSizeBox: TLabeledEdit;
    DeletionBox: TCheckBox;
    DeletionRateBox: TLabeledEdit;
    DeletionSizeBox: TLabeledEdit;
    VersionInfo: TStVersionInfo;
    AncestralBox: TCheckBox;
    InsertionDistBox: TRadioGroup;
    DeletionDistBox: TRadioGroup;
    InsertionExpBox: TLabeledEdit;
    DeletionExpBox: TLabeledEdit;
    procedure GammaBoxClick(Sender: TObject);
    procedure ModelBoxClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure TreeButtonClick(Sender: TObject);
    procedure DisplayTreeButtonClick(Sender: TObject);
    procedure NodesButtonClick(Sender: TObject);
    procedure CreateGenesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GeneNBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunButtonClick(Sender: TObject);
    procedure DirButtonClick(Sender: TObject);
    procedure BatchButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure InsertionBoxClick(Sender: TObject);
    procedure DeletionBoxClick(Sender: TObject);
    procedure InsertionDistBoxClick(Sender: TObject);
    procedure DeletionDistBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //SubRootList, //: TList;
    //GeneList : TObjectList;
    //SubRootNumbers : array of TBranchModel;
    CGene{,//Rcnt,
    Seed} : integer;
    DoBatch : boolean;
    procedure ResetGenes;
    procedure SetGeneValues(Gene : TInitGene);
    procedure FillSubModel(IGene : TInitGene; SModel : TSubstitutionModel; Node : TNode; GeneN : integer);
    function ExecuteBatchCommand(batcom : string): boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses NewSim2, NewSim3;

{--------------------Main Code--------------------}

procedure TMainForm.GammaBoxClick(Sender: TObject);
begin
     if GammaBox.Checked then
        AlphaBox.Enabled := true
     else AlphaBox.Enabled := false;
end;

procedure TMainForm.ModelBoxClick(Sender: TObject);
begin
     case ModelBox.ItemIndex of
          0 : begin
                   KappaBox.Enabled := false;
                   TargABox.Enabled := false;
                   TargCBox.Enabled := false;
                   TargGBox.Enabled := false;
                   TargTBox.Enabled := false;
                   TargetLabel.Enabled := false;
                   grACBox.Enabled := false;
                   grAGBox.Enabled := false;
                   grATBox.Enabled := false;
                   grCGBox.Enabled := false;
                   grCTBox.Enabled := false;
                   grGTBox.Enabled := false;
              end;
          1 : begin
                   KappaBox.Enabled := true;
                   TargABox.Enabled := false;
                   TargCBox.Enabled := false;
                   TargGBox.Enabled := false;
                   TargTBox.Enabled := false;
                   TargetLabel.Enabled := false;
                   grACBox.Enabled := false;
                   grAGBox.Enabled := false;
                   grATBox.Enabled := false;
                   grCGBox.Enabled := false;
                   grCTBox.Enabled := false;
                   grGTBox.Enabled := false;
              end;
          2 : begin
                   KappaBox.Enabled := false;
                   TargABox.Enabled := true;
                   TargCBox.Enabled := true;
                   TargGBox.Enabled := true;
                   TargTBox.Enabled := true;
                   TargetLabel.Enabled := true;
                   grACBox.Enabled := false;
                   grAGBox.Enabled := false;
                   grATBox.Enabled := false;
                   grCGBox.Enabled := false;
                   grCTBox.Enabled := false;
                   grGTBox.Enabled := false;
              end;
          3 : begin
                   KappaBox.Enabled := true;
                   TargABox.Enabled := true;
                   TargCBox.Enabled := true;
                   TargGBox.Enabled := true;
                   TargTBox.Enabled := true;
                   TargetLabel.Enabled := true;
                   grACBox.Enabled := false;
                   grAGBox.Enabled := false;
                   grATBox.Enabled := false;
                   grCGBox.Enabled := false;
                   grCTBox.Enabled := false;
                   grGTBox.Enabled := false;
              end;
          4 : begin
                   KappaBox.Enabled := false;
                   TargABox.Enabled := true;
                   TargCBox.Enabled := true;
                   TargGBox.Enabled := true;
                   TargTBox.Enabled := true;
                   TargetLabel.Enabled := true;
                   grACBox.Enabled := true;
                   grAGBox.Enabled := true;
                   grATBox.Enabled := true;
                   grCGBox.Enabled := true;
                   grCTBox.Enabled := true;
                   grGTBox.Enabled := true;
              end;
     end;
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
     Close;
end;

procedure TMainForm.TreeButtonClick(Sender: TObject);
begin
     if OpenDialog.Execute then begin
        TreeLabel.Caption := ExtractFileName(OpenDialog.FileName);
        DisplayTreeButton.Enabled := true;
        NodesButton.Enabled := true;
        RunButton.Enabled := true;
     end;
end;

procedure TMainForm.DisplayTreeButtonClick(Sender: TObject);
var
   DForm : TDisplayTreeForm;
begin
     if (OpenDialog.Filename <> '') then begin
        DForm := TDisplayTreeForm.Create(self);
        with DForm do begin
             InitTree(OpenDialog.FileName);
             Redraw;
             Show;
        end;
     end;
end;

procedure TMainForm.NodesButtonClick(Sender: TObject);
var
   NList : TStringList;
   TempTree,MainTree : TNode;
   infile : TextFile;
   instr,TreeText : string;
begin
     if (OpenDialog.Filename <> '') then
        if SaveDialog.Execute then begin
           NList := TStringList.Create;
           TempTree := TNode.Create;
           AssignFile(infile,OpenDialog.Filename); Reset(infile);
           TreeText := '';
           repeat
                 ReadLn(infile,instr);
                 treetext := TreeText + instr;
           until (Pos(';',TreeText) <> 0);
           Closefile(infile);
           ReadTreePar(treetext,TempTree);
           MainTree := FindRootNode(TempTree);
           //OutputInternalNodes(MainTree,NList);
           OutputAllNodes(MainTree,NList);
           NList.Insert(0,'Branch#: All Descendent OTUs');
           NList.SaveToFile(SaveDialog.FileName);
           NList.Free;
        end;
end;

procedure TMainForm.CreateGenesClick(Sender: TObject);
var
   doit : boolean;
   i,ngene : integer;
   newgene : TInitGene;
begin
     ngene := StrToIntDef(NGeneBox.Text,-1);
     if (ngene > 0) then begin
        doit := true;
        UpDown.Max := ngene;
        if (GeneList = nil) then
           GeneList := TObjectList.Create
        else if (MessageDlg('This will clear all of the genes currently in memory.  Continue?',
                 mtConfirmation,[mbYes,mbNo],0) = mrYes) then begin
                   {for i := 0 to GeneList.Count - 1 do
                       TInitGene(GeneList[i]).Free;}
                   GeneList.Clear;
        end else doit := false;
        if doit then begin
           for i := 1 to ngene do begin
               NewGene := TInitGene.Create;
               SetGeneValues(NewGene);
               GeneList.Add(NewGene);
           end;
        end;
     end else MessageDlg('There must be at least one gene.',mtError,[mbOk],0);
end;

procedure TMainForm.SetGeneValues(Gene : TInitGene);
begin
     with Gene do begin
          SeqLength := StrToInt(trim(SeqLengthBox.Text));
          initA := StrToFloat(trim(FaBox.Text));
          initC := StrToFloat(trim(FcBox.Text));
          initG := StrToFloat(trim(FgBox.Text));
          initT := StrToFloat(trim(FtBox.Text));
          TiTv := StrToFloat(trim(KappaBox.Text)) / 2.0;
          case ModelBox.ItemIndex of
               0 : NucModel := nmJC;
               1 : NucModel := nmK2;
               2 : NucModel := nmEqInp;
               3 : NucModel := nmHKY;
               4 : NucModel := nmGenRes;
          end;
          targA := StrToFloat(trim(TargABox.Text));
          targC := StrToFloat(trim(TargCBox.Text));
          targG := StrToFloat(trim(TargGBox.Text));
          targT := StrToFloat(trim(TargTBox.Text));
          Rate := StrToFloat(trim(RateBox.Text));
          if GammaBox.Checked then DoGamma := true
          else DoGamma := false;
          GammaAlpha := StrToFloat(trim(AlphaBox.Text));
          pAC := StrToFloat(trim(grACBox.Text));
          pAG := StrToFloat(trim(grAGBox.Text));
          pAT := StrToFloat(trim(grATBox.Text));
          pCG := StrToFloat(trim(grCGBox.Text));
          pCT := StrToFloat(trim(grCTBox.Text));
          pGT := StrToFloat(trim(grGTBox.Text));
          if InsertionBox.Checked then DoIns := true
          else DoIns := false;
          InRate := StrToFloat(trim(InsertionRateBox.Text));
          InSize := StrToFloat(trim(InsertionSizeBox.Text));
          InPower := StrToFloat(trim(InsertionExpBox.Text));
          InDist := InsertionDistBox.ItemIndex;
          if DeletionBox.Checked then DoDel := true
          else DoDel := false;
          DelRate := StrToFloat(trim(DeletionRateBox.Text));
          DelSize := StrToFloat(trim(DeletionSizeBox.Text));
          DelPower := StrToFloat(trim(DeletionExpBox.Text));
          DelDist := DeletionDistBox.ItemIndex;
     end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
   NewGene : TInitGene;
begin
     BatchLabel.Visible := false;
     SimLabel.Visible := false;
     ProgressBar.Visible := false;
     GeneList := TObjectList.Create;
     SubRootList := TObjectList.Create;
     NewGene := TInitGene.Create;
     SubRootNumbers := nil;
     SetGeneValues(NewGene);
     GeneList.Add(NewGene);
     CGene := 0;
     Rcnt := 0;
     Randomize;
     Seed := -1 * random(30000);
     DoBatch := false;
     { File Version }
     VersionInfo.FileName := Application.ExeName;
     Caption := 'MySSP (' +
             VersionInfo.FileVersion + ')';
end;

procedure TMainForm.GeneNBoxChange(Sender: TObject);
var
   OldC : integer;
begin
     SetGeneValues(TInitGene(GeneList[CGene]));
     OldC := CGene;
     CGene := StrToIntDef(GeneNBox.Text,-1) - 1;
     if (CGene > -1) and (CGene < GeneList.Count) then begin
        with TInitGene(GeneList[CGene]) do begin
             SeqLengthBox.Text := IntToStr(SeqLength);
             FaBox.Text := format('%1.5f',[initA]);
             FcBox.Text := format('%1.5f',[initC]);
             FgBox.Text := format('%1.5f',[initG]);
             FtBox.Text := format('%1.5f',[initT]);
             KappaBox.Text := format('%1.5f',[2.0 * TiTv]);
             case NucModel of
                  nmJC : ModelBox.ItemIndex := 0;
                  nmK2 : ModelBox.ItemIndex := 1;
                  nmEqInp : ModelBox.ItemIndex := 2;
                  nmHKY : ModelBox.ItemIndex := 3;
                  nmGenRes : ModelBox.ItemIndex := 4;
             end;
             TargABox.Text := format('%1.5f',[targA]);
             TargCBox.Text := format('%1.5f',[targC]);
             TargGBox.Text := format('%1.5f',[targG]);
             TargTBox.Text := format('%1.5f',[targT]);
             RateBox.Text := format('%1.5f',[Rate]);
             if DoGamma then GammaBox.Checked := true
             else GammaBox.Checked := false;
             AlphaBox.Text := format('%1.5f',[GammaAlpha]);
             grACBox.Text := format('%1.5f',[pAC]);
             grAGBox.Text := format('%1.5f',[pAG]);
             grATBox.Text := format('%1.5f',[pAT]);
             grCGBox.Text := format('%1.5f',[pCG]);
             grCTBox.Text := format('%1.5f',[pCT]);
             grGTBox.Text := format('%1.5f',[pGT]);
             if DoIns then InsertionBox.Checked := true
             else InsertionBox.Checked := false;
             if DoDel then DeletionBox.Checked := true
             else DeletionBox.Checked := false;
             InsertionSizeBox.Text := format('%1.5f',[InSize]);
             InsertionRateBox.Text := format('%1.5f',[InRate]);
             InsertionExpBox.Text := format('%1.5f',[InPower]);
             InsertionDistBox.ItemIndex := InDist;
             DeletionSizeBox.Text := format('%1.5f',[DelSize]);
             DeletionRateBox.Text := format('%1.5f',[DelRate]);
             DeletionExpBox.Text := format('%1.5f',[DelPower]);
             DeletionDistBox.ItemIndex := DelDist;
             InsertionBoxClick(Self);
             DeletionBoxClick(Self);
             GammaBoxClick(Self);
             ModelBoxClick(Self);
           end;
     end else begin
         CGene := OldC;
         GeneNBox.Text := IntToStr(CGene+1);
         MessageDlg('Please enter a valid gene number.',mtError,[mbOk],0);
     end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
{var
   i : integer;}
begin
     if (GeneList <> nil) then begin
        {for i := 0 to GeneList.Count - 1 do
            TInitGene(GeneList[i]).Free;}
        GeneList.Free;
     end;
     if (SubRootList <> nil) then begin
        {for i := 0 to SubRootList.Count - 1 do
            TInitGene(SubRootList[i]).Free;}
        SubRootList.Free;
     end;
     SubRootNumbers := nil;
end;

procedure TMainForm.FillSubModel(IGene : TInitGene; SModel : TSubstitutionModel;
          Node : TNode; GeneN : integer);
var
   n : integer;
   a,b : double;
   InType,DelType : TIndelDistType;
begin
     with IGene do begin
          SModel.DataType := dtNucleotide;
          SModel.NucModel := NucModel;
          SModel.SetupNucFreq(targA,targC,targG,targT);
          case NucModel of
               nmJC : begin
                           CalcJCParameter(Rate,a);
                           SModel.Alpha := a;
                      end;
               nmK2 : begin
                           CalcK2Parameters(Rate,TiTv,a,b);
                           SModel.Alpha := a;
                           SModel.Beta := b;
                      end;
               nmEqInp : begin
                              CalcEqInpParameters(Rate,targA,targC,targG,targT,a);
                              SModel.Alpha := a;
                         end;
               nmHKY : begin
                            CalcHKYParameters(rate,TiTv,targA,targC,targG,targT,a,b);
                            SModel.Alpha := a;
                            SModel.Beta := b;
                       end;
               nmGenRes : begin
                               CalcGenResParameters(rate,targA,targC,targG,targT,
                                   pac,pag,pat,pcg,pct,pgt);
                               SModel.SetGenRes(pAC,pAG,pAT,pCG,pCT,pGT);
                          end;
          end;

          if DoGamma then begin
             n := SeqLength;
             if (node = nil) then SModel.SetGamma(GammaAlpha,SeqLength,seed)
             else if (node.Ancestor = nil) then SModel.SetGamma(GammaAlpha,SeqLength,seed)
             else begin
                  if TGene(Node.Ancestor.Genes[GeneN]).SubstitutionModel.IsGamma then begin
                     if (TGene(Node.Ancestor.Genes[GeneN]).SubstitutionModel.GammaA = GammaAlpha) then
                        SModel.CopyGamma(GammaAlpha,TGene(Node.Ancestor.Genes[GeneN]).SubstitutionModel.GammaRates)
                     else SModel.SetGammaDesc(GammaAlpha,n,seed,
                       TGene(Node.Ancestor.Genes[GeneN]).SubstitutionModel.GammaRates);
                  end else SModel.SetGamma(GammaAlpha,SeqLength,seed);
             end;
          end;

          case InDist of
               0 : InType := idtPoisson;
               1 : InType := idtPower;
               else InType := idtPoisson;
          end;
          case DelDist of
               0 : DelType := idtPoisson;
               1 : DelType := idtPower;
               else DelType := idtPoisson;
          end;
          if DoIns then SModel.Insertions.SetModel(InType,InRate,InSize,InPower);
          if DoDel then SModel.Deletions.SetModel(DelType,DelRate,DelSize,DelPower);
     end;
end;

procedure TMainForm.RunButtonClick(Sender: TObject);
var
   IsGood : boolean;
   TempTree,MainTree : TNode;
   infile : TextFile;
   outname,outdir,curdir,
   StartSeq,prefix,
   instr,TreeText : string;
   n,i,j : integer;
   NodeList : TList;
   SubModelList : TObjectList;
   SubModel : TSubstitutionModel;
   IndelSizes : TStringList;
begin
     SetGeneValues(TInitGene(GeneList[CGene]));
     Screen.Cursor := crHourglass;
     ProgressBar.Position := 0;
     ProgressBar.Visible := true;
     SimLabel.Visible := true;
     //if not DoBatch then ProgForm.ShowModal;
     // Load Tree
     TempTree := TNode.Create;
     AssignFile(infile,OpenDialog.Filename); Reset(infile);
     TreeText := '';
     repeat
           ReadLn(infile,instr);
           treetext := TreeText + instr;
     until (Pos(';',TreeText) <> 0);
     Closefile(infile);
     ReadTreePar(treetext,TempTree);
     MainTree := FindRootNode(TempTree);
     NodeList := TList.Create;
     CreateNodeList(MainTree,NodeList);
     // Prepare Genes
     SubModelList := TObjectList.Create;
     MainTree.SetGeneNumber(GeneList.Count);
     for i := 1 to GeneList.Count do begin
         SubModel := TSubstitutionModel.Create;
         FillSubModel(TInitGene(GeneList[i-1]),SubModel,nil,0);
         SetSubMatrix(MainTree,i-1,SubModel);
         SubModelList.Add(SubModel);
     end;
     // add nonstationarity if necessary
     if DoBatch and (Rcnt > 0) then begin
        for i := 1 to Rcnt do begin
            SubModel := TSubstitutionModel.Create;
            FillSubModel(TInitGene(SubRootList[i-1]),SubModel,NodeList[SubRootNumbers[i-1].branch],SubRootNumbers[i-1].gene-1);
            SetSubMatrix(NodeList[SubRootNumbers[i-1].branch],SubRootNumbers[i-1].gene-1,SubModel);
            SubModelList.Add(SubModel);
        end;
     end;
     // Setup Iterations
     prefix := trim(PrefixBox.Text);
     n := StrToInt(trim(RepBox.Text));
     ProgressBar.Max := n;
     {// calculate the expected # changes on each branch for each gene
     for i := 0 to GeneList.Count - 1 do
         CalcExpectedChanges(MainTree,i,TInitGene(GeneList[i]).length);
     TreeText := '';}
     { Perform Iterations }
     outdir := trim(OutputDirBox.Text);
     if not DirectoryExists(outdir) then MkDir(outdir);
     GetDir(0,CurDir);
     ChDir(outdir);
     IndelSizes := TStringList.Create;
     for j := 1 to n do begin
         repeat
               IsGood := true;
               ClearSequences(MainTree);
               for i := 0 to GeneList.Count - 1 do
                   with TInitGene(GeneList[i]) do begin
                        StartSeq := RandomNucSequence(seqlength,seed,inita,initc,initg,initt);
                        TGene(MainTree.Genes[i]).Sequence := StartSeq;
                   end;
               IndelSizes.Clear;
               SimulateOnTree(MainTree,seed,IndelSizes);
               { Check to make sure divergence isn't too strong }
               {if ImposeBox.Checked then
                  case SeqTypeBox.ItemIndex of
                       0 : IsGood := LowDivergence(MainTree);
                       1 : IsGood := LowAADiv(MainTree);
                       else IsGood := true;
                  end
               else IsGood := true;}
         until IsGood;
         case OutputBox.ItemIndex of
              0 : begin
                       outname := prefix + IntToStr(j) + '.nex';
                       WritePaupInput(outname,prefix,MainTree,AncestralBox.Checked);
                  end;
              1 : begin
                       outname := prefix + IntToStr(j) + '.meg';
                       WriteMegaInput(outname,prefix,MainTree,AncestralBox.Checked);
                  end;
              2 : begin
                       outname := prefix + IntToStr(j) + '.fas';
                       WriteFASTAInput(outname,prefix,MainTree,AncestralBox.Checked);
                  end;
         end;
//         IndelSizes.SaveToFile(prefix + IntToStr(j)+'_indelsizes.txt');
         ProgressBar.StepIt;
         Application.ProcessMessages;
     end;
     ChDir(CurDir);
     IndelSizes.Free;
     // clear memory
     NodeList.Free;
     if (SubModelList <> nil) then begin
        {for i := 0 to SubModelList.Count - 1 do
            TSubstitutionModel(SubModelList[i]).Free;}
        SubModelList.Free;
     end;
     //if not DoBatch then ProgForm.Hide;
     ProgressBar.Visible := false;
     SimLabel.Visible := false;
     Screen.Cursor := crDefault;
end;

procedure TMainForm.DirButtonClick(Sender: TObject);
var
   DForm : TDirForm;
begin
     DForm := TDirForm.Create(Self);
     DForm.ShowModal;
end;

procedure TMainForm.BatchButtonClick(Sender: TObject);
var
   batfile : TextFile;
   comstr,instr : string;
   badcommand,quit : boolean;
   tot,cnt : integer;
   tempf : TStringList;
begin
     if BatchDialog.Execute then try
        DoBatch := true;
        Batchlabel.Visible := true;
        tempf := TStringList.Create;
        tempf.LoadFromFile(BatchDialog.Filename);
        tot := tempf.count;
        tempf.free;
        AssignFile(batfile,BatchDialog.Filename); Reset(batfile);
        quit := false;
        comstr := '';
        cnt := 0;
        badcommand := true;
        repeat
              readln(batfile,instr);
              inc(cnt);
              BatchLabel.Caption := 'Processing Line '+IntToStr(cnt)+' of '
                  + IntToStr(tot) + ' of Batchfile';
              if (trim(instr) <> '') then
                 if (trim(instr)[1] <> '#') then begin
                    instr := instr + ' ';
                    while (Pos(';',instr) > 0) and not quit do begin
                          comstr := comstr + ' ' + Copy(instr,1,Pos(';',instr));
                          //execute command
                          comstr := trim(Copy(comstr,1,length(comstr)-1));
                          //if (comstr[1] = '#') then comstr := ''
                          if (UpperCase(comstr) = 'QUIT') then quit := true
                          else badcommand := ExecuteBatchCommand(comstr);
                          comstr := '';
                          instr := Copy(instr,Pos(';',instr)+1,length(instr));
                          if badcommand then quit := true;
                    end;
                    comstr := comstr + ' ' + instr;
                 end;
        until quit or eof(batfile);
        if badcommand then begin
           MessageDlg('Error in batch file - line '+IntToStr(cnt),mtError,[mbOk],0);
           Rcnt := 0;
           SubRootNumbers := nil;
        end;
        CloseFile(batfile);
     finally
            BatchLabel.Caption := 'Batch File Processing Complete';
            DoBatch := false;
     end;
end;

function TMainForm.ExecuteBatchCommand(batcom : string) : boolean;
{ Batch Commands:
  quit = end batch routine; translated in main batch control loop : "quit;"
  execute = run simulation : "execute;"
  tree = set tree file : "tree treefile.txt;"
  output = set output parameters : "output nreps=100 dir=output prefix=outsim format=nex;"
  ngenes = set the number of genes : "ngenes 5;"
  gene = set gene parameters :
      "Gene 2 NSites=1000 StartA=0.25 StartC=0.25 StartG=0.25 StartT=0.25
        / 0: Model=HKY  Rate=0.01 Kappa=2 GammaAlpha=0 EqA=0.25 EqC=0.25 EqG=0.25 EqT=0.25
        / 5: Model=GenRes  Rate=0.01 Kappa=2 GammaAlpha=0 EqA=0.25 EqC=0.25 EqG=0.25 EqT=0.25
             GenResPar=(1,10,5,4,2,3)"
  cleargenes = clear all gene values and reset to defaults : "cleargenes;"
  }
var
   rstr,parstr,comstr : string;
   IsError : boolean;
   gn,i,intval : integer;
   newgene : TInitGene;
   gpars : array[1..6] of double;
   fval : double;
   {DoDel,DoIns : boolean;
   IRate,ISize,DRate,DSize : double;}
begin
     fval := -1.0;
     IsError := false;
     if (UpperCase(batcom) = 'EXECUTE') then RunButtonClick(Self)
     else if (UpperCase(batcom) = 'CLEARGENES') then ResetGenes
     else if (Pos(' ',batcom) > 0) then begin
          comstr := UpperCase(trim(Copy(batcom,1,Pos(' ',batcom))));
          batcom := trim(Copy(batcom,Pos(' ',batcom),length(batcom)));
          if (comstr = 'TREE') then begin
             if (Pos(' ',batcom) > 0) or (Pos('=',batcom) > 0) then IsError := true
             else begin
                  OpenDialog.Filename := batcom;
                  TreeLabel.Caption := ExtractFileName(OpenDialog.FileName);
                  DisplayTreeButton.Enabled := true;
                  NodesButton.Enabled := true;
                  RunButton.Enabled := true;
             end;
          end else if (comstr = 'SEED') then begin
             if (Pos(' ',batcom) > 0) or (Pos('=',batcom) > 0) then IsError := true
             else begin
                  i := StrToIntDef(batcom,0);
                  if (i > -1) then IsError := true
                  else seed := i;
             end;
          end else if (comstr = 'OUTPUT') then begin
              while (batcom <> '') do begin
                    IsError := GetParam(batcom,comstr,parstr);
                    if (comstr = 'NREPS') then begin
                       intval := StrToIntDef(parstr,-1);
                       if (intval > 0) then RepBox.Text := parstr
                       else IsError := true;
                    end else if (comstr = 'DIR') then OutputDirBox.Text := parstr
                    else if (comstr = 'PREFIX') then PrefixBox.Text := parstr
                    else if (comstr = 'ANC') then begin
                         if (UpperCase(parstr) = 'YES') then AncestralBox.Checked := true
                         else AncestralBox.Checked := false;
                    end else if (comstr = 'FORMAT') then begin
                         if (UpperCase(parstr) = 'NEX') then
                            OutputBox.ItemIndex := 0
                         else if (UpperCase(parstr) = 'MEG') then
                              OutputBox.ItemIndex := 1
                         else if (UpperCase(parstr) = 'FAS') then
                              Outputbox.ItemIndex := 2
                         else IsError := true;
                    end else IsError := true;
              end;
          end else if (comstr = 'NGENES') then begin
              if (Pos(' ',batcom) > 0) or (Pos('=',batcom) > 0) then IsError := true
              else begin
                   intval := StrToIntDef(batcom,-1);
                   if (intval > 0) then begin
                      if (GeneList = nil) then GeneList := TObjectList.Create
                      else begin
                           {for i := 0 to GeneList.Count - 1 do
                               TInitGene(GeneList[i]).Free;}
                           GeneList.Clear;
                      end;
                      for i := 1 to intval do begin
                          NewGene := TInitGene.Create;
                          SetGeneValues(NewGene);
                          GeneList.Add(NewGene);
                      end;
                      NGeneBox.Text := batcom;
                      UpDown.Max := intval;
                      Rcnt := 0;
                      SubRootNumbers := nil;
                   end else IsError := true;
              end;
          end else if (comstr = 'GENE') then begin
              // read gene number
              if (Pos(' ',batcom) > 0) then begin
                 comstr := trim(Copy(batcom,1,Pos(' ',batcom)));
                 batcom := trim(Copy(batcom,Pos(' ',batcom),length(batcom)))+' ';
                 intval := StrToIntDef(comstr,-1);
                 if (intval > 0) and (intval <= GeneList.Count) then begin
                    gn := intval;
                    GeneNBox.Text := ComStr;
                    GeneNBoxChange(Self);
                    if (Pos('/',batcom) > 0) then begin
                       rstr := trim(Copy(batcom,Pos('/',batcom)+1,length(batcom)));
                       batcom := trim(Copy(batcom,1,Pos('/',batcom)-1));
                       // read initial gene parameters
                       while (batcom <> '') do begin
                             IsError := GetParam(batcom,comstr,parstr);
                             if (comstr = 'NSITES') then SeqLengthBox.Text := parstr
                             else if (comstr = 'STARTA') then FaBox.Text := parstr
                             else if (comstr = 'STARTC') then FcBox.Text := parstr
                             else if (comstr = 'STARTG') then FgBox.Text := parstr
                             else if (comstr = 'STARTT') then FtBox.Text := parstr
                             else IsError := true;
                       end;
                       if not IsError then repeat
                          batcom := rstr + ' ';
                          if (Pos('/',batcom) > 0) then begin
                             rstr := trim(Copy(batcom,Pos('/',batcom)+1,length(batcom)));
                             batcom := trim(Copy(batcom,1,Pos('/',batcom)-1));
                          end else rstr := '';
                          if (Pos(':',batcom) > 0) then begin
                             comstr := trim(Copy(batcom,1,Pos(':',batcom)-1));
                             batcom := trim(Copy(batcom,Pos(':',batcom)+1,length(batcom)));
                             intval := StrToIntDef(comstr,-1);
                             if (intval < 0) then IsError := true
                             // root node
                             else if (intval = 0) then while (batcom <> '') do begin
                                  IsError := GetParam(batcom,comstr,parstr);
                                  if (comstr = 'RATE') then RateBox.Text := parstr
                                  else if (comstr = 'KAPPA') then KappaBox.Text := parstr
                                  else if (comstr = 'MODEL') then begin
                                       if (UpperCase(parstr) = 'JC') then ModelBox.ItemIndex := 0
                                       else if (UpperCase(parstr) = 'K2') then ModelBox.ItemIndex := 1
                                       else if (UpperCase(parstr) = 'EQINP') then ModelBox.ItemIndex := 2
                                       else if (UpperCase(parstr) = 'HKY') then ModelBox.ItemIndex := 3
                                       else if (UpperCase(parstr) = 'GENRES') then ModelBox.ItemIndex := 4
                                       else IsError := true;
                                  end else if (comstr = 'EQA') then TargaBox.Text := parstr
                                  else if (comstr = 'EQC') then TargcBox.Text := parstr
                                  else if (comstr = 'EQG') then TarggBox.Text := parstr
                                  else if (comstr = 'EQT') then TargtBox.Text := parstr
                                  else if (comstr = 'DOINS') then begin
                                       if (UpperCase(parstr) = 'YES') then InsertionBox.Checked := true
                                       else InsertionBox.Checked := false;
                                  end else if (comstr = 'INSRATE') then InsertionRateBox.Text := parstr
                                  else if (comstr = 'INSSIZE') then InsertionSizeBox.Text := parstr
                                  else if (comstr = 'DODEL') then begin
                                       if (UpperCase(parstr) = 'YES') then DeletionBox.Checked := true
                                       else DeletionBox.Checked := false;
                                  end else if (comstr = 'DELRATE') then DeletionRateBox.Text := parstr
                                  else if (comstr = 'DELSIZE') then DeletionSizeBox.Text := parstr
                                  else if (comstr = 'GAMMAALPHA') then begin
                                       try
                                          fval := StrToFloat(parstr);
                                       except on EConvertError do fval := -1.0;
                                       end;
                                       if (fval < 0.0) then IsError := true
                                       else if (fval = 0.0) then GammaBox.Checked := false
                                       else begin
                                            GammaBox.Checked := true;
                                            AlphaBox.Text := parstr;
                                       end;
                                  end else if (comstr = 'GENRESPAR') then begin
                                      // GenResPar=(1,10,5,4,2,3)
                                      if (parstr[1] = '(') and (parstr[length(parstr)] = ')') then begin
                                         comstr := Copy(parstr,2,length(parstr)-2)+' ';
                                         for i := 1 to 5 do
                                             if (Pos(',',comstr) > 0) then begin
                                                parstr := Copy(comstr,1,Pos(',',comstr)-1);
                                                comstr := Copy(comstr,Pos(',',comstr)+1,length(comstr));
                                                case i of
                                                     1 : grACBox.text := parstr;
                                                     2 : grAGBox.text := parstr;
                                                     3 : grATBox.text := parstr;
                                                     4 : grCGBox.text := parstr;
                                                     5 : grCTBox.text := parstr;
                                                end;
                                             end else IsError := true;
                                         grGTBox.text := comstr;
                                      end else IsError := true;
                                  end else IsError := true;
                             end else begin
                                 // non-root node
                                 inc(Rcnt);
                                 SetLength(SubRootNumbers,Rcnt);
                                 SubRootNumbers[Rcnt-1].gene := gn;
                                 SubRootNumbers[Rcnt-1].branch := intval;
                                 NewGene := TInitGene.Create;
                                 NewGene.seqlength := StrToInt(SeqLengthBox.Text);
                                 NewGene.initA := StrToFloat(FaBox.Text);
                                 NewGene.initC := StrToFloat(FcBox.Text);
                                 NewGene.initG := StrToFloat(FgBox.Text);
                                 NewGene.initT := StrToFloat(FtBox.Text);
                                 {DoDel := false; DoIns := false;
                                 IRate := -1; ISize := -1; DRate := -1; DSize := -1;}
                                 with NewGene do
                                      while (batcom <> '') do try
                                            IsError := GetParam(batcom,comstr,parstr);
                                            if (comstr = 'RATE') then Rate := StrToFloat(parstr)
                                            else if (comstr = 'MODEL') then begin
                                                 if (UpperCase(parstr) = 'JC') then NucModel := nmJC
                                                 else if (UpperCase(parstr) = 'K2') then NucModel := nmK2
                                                 else if (UpperCase(parstr) = 'EQINP') then NucModel := nmEqInp
                                                 else if (UpperCase(parstr) = 'HKY') then NucModel := nmHKY
                                                 else if (UpperCase(parstr) = 'GENRES') then NucModel := nmGenRes
                                                 else IsError := true;
                                            end else if (comstr = 'KAPPA') then TiTv := StrToFloat(parstr)/2.0
                                            else if (comstr = 'EQA') then Targa := StrToFloat(parstr)
                                            else if (comstr = 'EQC') then Targc := StrToFloat(parstr)
                                            else if (comstr = 'EQG') then Targg := StrToFloat(parstr)
                                            else if (comstr = 'EQT') then Targt := StrToFloat(parstr)
                                            else if (comstr = 'DOINS') then begin
                                                 if (UpperCase(parstr) = 'YES') then DoIns := true
                                                 else DoIns := false;
                                            end else if (comstr = 'INSRATE') then InRate := StrToFloat(parstr)
                                            else if (comstr = 'INSSIZE') then InSize := StrToFloat(parstr)
                                            else if (comstr = 'DODEL') then begin
                                                 if (UpperCase(parstr) = 'YES') then DoDel := true
                                                 else DoDel := false;
                                            end else if (comstr = 'DELRATE') then DelRate := StrTofloat(parstr)
                                            else if (comstr = 'DELSIZE') then DelSize := StrToFloat(parstr)
                                            else if (comstr = 'GAMMAALPHA') then begin
                                                 try
                                                    fval := StrToFloat(parstr);
                                                 except on EConvertError do fval := -1.0;
                                                 end;
                                                 if (fval < 0.0) then IsError := true
                                                 else if (fval = 0.0) then DoGamma := false
                                                 else begin
                                                      DoGamma := true;
                                                      GammaAlpha := fval;
                                                 end;
                                            end else if (comstr = 'GENRESPAR') then begin
                                                // GenResPar=(1,10,5,4,2,3)
                                                if (parstr[1] = '(') and (parstr[length(parstr)] = ')') then begin
                                                   comstr := Copy(parstr,2,length(parstr)-2)+' ';
                                                   for i := 1 to 5 do
                                                       if (Pos(',',comstr) > 0) then begin
                                                          parstr := Copy(comstr,1,Pos(',',comstr)-1);
                                                          comstr := Copy(comstr,Pos(',',comstr)+1,length(comstr));
                                                          try
                                                             fval := StrToFloat(trim(parstr));
                                                          except on EconvertError do IsError := true;
                                                          end;
                                                          GPars[i] := fval;
                                                       end else IsError := true;
                                                   try
                                                      fval := StrToFloat(trim(comstr));
                                                   except on EconvertError do IsError := true;
                                                   end;
                                                   GPars[6] := fval;
                                                   if not IsError then begin
                                                      pAC := GPars[1];
                                                      pAG := GPars[2];
                                                      pAT := GPars[3];
                                                      pCG := GPars[4];
                                                      pCT := GPars[5];
                                                      pGT := GPars[6];
                                                   end;
                                                end else IsError := true;
                                            end else IsError := true;
                                      except on EConvertError do IsError := true;
                                      end;
                                 SubRootList.Add(NewGene);
                             end;
                          end else IsError := true;
                       until IsError or (rstr = '');
                    end else IsError := true;
                 end else IsError := true;
              end else IsError := true;
              // end of GENE command
          end else IsError := true;
          // end of command types with spaces
     end else IsError := true;
     // end of command types without spaces
     result := IsError;
end;

procedure TMainForm.ResetGenes;
var
   NewGene : TInitGene;
   i : integer;
begin
     NGeneBox.Text := '1';
     GeneNBox.Text := '1';
     UpDown.Max := 1;
     SeqLengthBox.Text := '1000';
     FaBox.Text := '0.25'; FcBox.Text := '0.25';
     FgBox.Text := '0.25'; FtBox.Text := '0.25';
     ModelBox.ItemIndex := 0;
     RateBox.Text := '0.001';
     KappaBox.Text := '2';
     KappaBox.Text := '2';
     TargaBox.Text := '0.25'; TargcBox.Text := '0.25';
     TarggBox.Text := '0.25'; TargtBox.Text := '0.25';
     AlphaBox.Text := '0.5';
     GammaBox.Checked := false;
     grACBox.Text := '1';
     grAGBox.Text := '1';
     grATBox.Text := '1';
     grCGBox.Text := '1';
     grCTBox.Text := '1';
     grGTBox.Text := '1';
     InsertionBox.Checked := false;
     DeletionBox.Checked := false;
     InsertionSizeBox.Text := '4';
     InsertionRateBox.Text := '100';
     InsertionExpBox.Text := '-2';
     InsertionDistBox.ItemIndex := 0;
     DeletionSizeBox.Text := '4';
     DeletionRateBox.Text := '40';
     DeletionExpBox.Text := '-2';
     DeletionDistBox.ItemIndex := 0;
     {for i := 0 to GeneList.Count - 1 do
         TInitGene(GeneList[i]).Free;}
     GeneList.Clear;
     // clear nonstationary models
     {for i := 0 to SubRootList.Count - 1 do
         TInitGene(SubRootList[i]).Free;}
     SubRootList.Clear;
     Rcnt := 0;
     // create new gene
     NewGene := TInitGene.Create;
     SetGeneValues(NewGene);
     GeneList.Add(NewGene);
end;

procedure TMainForm.ResetButtonClick(Sender: TObject);
begin
     if (MessageDlg('Are you sure you want to clear all genes?',
           mtConfirmation,[mbYes,mbNo],0) = mrYes) then ResetGenes;
end;

procedure TMainForm.InsertionBoxClick(Sender: TObject);
begin
     if InsertionBox.Checked then begin
        InsertionSizeBox.Enabled := true;
        InsertionRateBox.Enabled := true;
        InsertionDistBox.Enabled := true;
        InsertionDistBoxClick(Self);
     end else begin
        InsertionSizeBox.Enabled := false;
        InsertionRateBox.Enabled := false;
        InsertionDistBox.Enabled := false;
        InsertionExpBox.Enabled := false;
     end;
end;

procedure TMainForm.InsertionDistBoxClick(Sender: TObject);
begin
     if (InsertionDistBox.ItemIndex = 0) then begin
        InsertionExpBox.Enabled := false;
        InsertionSizeBox.EditLabel.Caption := 'Mean Size';
     end else begin
         InsertionExpBox.Enabled := true;
         InsertionSizeBox.EditLabel.Caption := 'Constant';
     end;
end;

procedure TMainForm.DeletionBoxClick(Sender: TObject);
begin
     if DeletionBox.Checked then begin
        DeletionSizeBox.Enabled := true;
        DeletionRateBox.Enabled := true;
        DeletionDistBox.Enabled := true;
        DeletionDistBoxClick(Self);
     end else begin
        DeletionSizeBox.Enabled := false;
        DeletionRateBox.Enabled := false;
        DeletionDistBox.Enabled := false;
        DeletionExpBox.Enabled := false;
     end;
end;

procedure TMainForm.DeletionDistBoxClick(Sender: TObject);
begin
     if (DeletionDistBox.ItemIndex = 0) then begin
        DeletionExpBox.Enabled := false;
        DeletionSizeBox.EditLabel.Caption := 'Mean Size';
     end else begin
         DeletionExpBox.Enabled := true;
         DeletionSizeBox.EditLabel.Caption := 'Constant';
     end;
end;

end.
