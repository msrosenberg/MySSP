unit MolDefs;

interface

uses Classes, SysUtils, {$IFNDEF FPC}Graphics,{$ENDIF} Dialogs;

const
     Nucleotides = 'ACGT';
     NucNames : array[1..4] of string = ('Adenine','Cytosine','Guanine','Thymine');
     { The amino acids are listed in alphabetical order by the 3 letter code }
     AminoAcids = 'ARNDCQEGHILKMFPSTWYV';
     AminoAcid3 : array[1..20] of string[3] = ('Ala','Arg','Asn','Asp','Cys',
                'Gln','Glu','Gly','His','Ile','Leu','Lys','Met','Phe','Pro',
                'Ser','Thr','Trp','Tyr','Val');
     AANames : array[1..20] of string = ('Alanine','Arginine','Asparagine',
             'Aspartic Acid','Cysteine','Glutamine','Glutamic Acid','Glycine',
             'Histidine','Isoleucine','Leucine','Lysine','Methionine',
             'Phenylalanine','Proline','Serine','Threonine','Tryptophan',
             'Tyrosine','Valine');

     DayhoffMat : array[1..20,1..20] of integer =
         ((9867,1,4,6,1,3,10,21,1,2,3,2,1,1,13,28,22,0,1,13),
          (2,9913,1,0,1,9,0,1,8,2,1,37,1,1,5,11,2,2,0,2),
          (9,1,9822,42,0,4,7,12,18,3,3,25,0,1,2,34,13,0,3,1),
          (10,0,36,9859,0,5,56,11,3,1,0,6,0,0,1,7,4,0,0,1),
          (3,1,0,0,9973,0,0,1,1,2,0,0,0,0,1,11,1,0,3,3),
          (8,10,4,6,0,9876,35,3,20,1,6,12,2,0,8,4,3,0,0,2),
          (17,0,6,53,0,27,9865,7,1,2,1,7,0,0,3,6,2,0,1,2),
          (21,0,6,6,0,1,4,9935,0,0,1,2,0,1,2,16,2,0,0,3),
          (2,10,21,4,1,23,2,1,9912,0,4,2,0,2,5,2,1,0,4,3),
          (6,3,3,1,1,1,3,0,0,9872,22,4,5,8,1,2,11,0,1,57),
          (4,1,1,0,0,3,1,1,1,9,9947,1,8,6,2,1,2,0,1,11),
          (2,19,13,3,0,6,4,2,1,2,2,9926,4,0,2,7,8,0,0,1),
          (6,4,0,0,0,4,1,1,0,12,45,20,9874,4,1,4,6,0,0,17),
          (2,1,1,0,0,0,0,1,2,7,13,0,1,9946,1,3,1,1,21,1),
          (22,4,2,1,1,6,3,3,3,0,3,3,0,0,9926,17,5,0,0,3),
          (35,6,20,5,5,2,4,21,1,1,1,8,1,2,12,9840,32,1,1,2),
          (32,1,9,3,1,2,2,3,1,7,3,11,2,1,4,38,9871,0,1,10),
          (0,8,1,0,0,0,0,0,1,0,4,0,0,3,0,5,0,9976,2,0),
          (2,0,4,0,3,0,1,0,4,1,2,1,0,28,0,2,2,1,9945,2),
          (18,1,1,1,2,1,2,5,1,33,15,1,4,0,2,2,9,0,1,9901));

type
    TDataTypes = (dtNucleotide, dtAminoAcid);
    TNucModels = (nmJC, nmK2, nmEqInp, nmHKY, nmGenRes);
    TAAModels = (amPoisson, amDayhoff);
    TIndelDistType = (idtPoisson, idtPower);
    TAAFreqs = array[1..20] of double;
    TSqNucMat = array[1..4,1..4] of double;
    TSqAAMat = array[1..20,1..20] of double;
    TDoubleArray = array of array of double;
    TIntArray = array of integer;
    TDArray = array of double;

    TIndelModel = class
      private
        fActive : boolean;
        fDist : TIndelDistType;
        fRate : double;
        fSize : double;
        fPower : double;
        fSizeProb : TDArray;
        function GetSizeProb(i : integer) : double;
        function FromPowerDistribution(var seed : integer) : integer;
        procedure InitPowerDistribution;
      public
        property IsActive : boolean read fActive;
        property Dist : TIndelDistType read fDist;
        property Rate : double read fRate;
        property Size : double read fSize;
        property Powre : double read fPower;
        property SizeProb[i : integer] : double read GetSizeProb;
        constructor Create;
        destructor Destroy; override;
        function NewIndel(var seed : integer) : integer;
        procedure SetModel(NewType : TIndelDistType; NewRate,NewSize,NewPower : double);
    end;

    {-----Substitution Model Declarations-----}
    TSubstitutionModel = class
      private
         fTotalRate : double;
         fRate : double;                // Substitution rate per site
         fIsGamma : boolean;            // Are we using a gamma distribution?
         fGammaA : double;              // gamma parameter
         fInsertionModel : TIndelModel;
         fDeletionModel : TIndelModel;
         fAlpha : double;               // transition rate
         fBeta : double;                // transversion rate
         fAA : TAAFreqs;                // Frequency of amino acids
         GenResParams,                  // parameters for the general reversible model
         NucTransMat : TSqNucMat;
//         SiteRates : array of double;
         RelRate : array[1..4] of double;
//         AATransMat : TSqAAMat;
//         function Dayhoff_Sub(t : double; var seed : integer; x : char) : char;
         procedure CalcNucTransMat;
         procedure SetupSiteRates(seq : string);
         procedure SetRelRates;
         function NewAminoAcid(x : char; var seed : integer) : char;
         function NewNucleotide(x : char; var seed : integer) : char;
         //function NewNucleotide2(CMat : TSqNucMat; x : char; var seed : integer) : char;
         //function FindSite (var seed : integer): integer;
         function FindSite (var seed : integer; seq : string): integer;
         procedure AdjustTotalRate(site : integer; oldnuc,newnuc : char);
         function GetTransRatio : double;
         function GetKappa : double;
         function GetAAf(i : integer) : double;
         procedure PutAAf(i : integer; freq : double);
         procedure SetPowerDistribution(P : TDArray; a,b : double);
      public
         DataType : TDataTypes;        // Nucleotide or Amino Acid data?
         NucModel : TNucModels;        // Which nuclear model are we using?
         AAModel : TAAModels;          // Which amino acid model are we using?
         fNuc : array[1..4] of double; // Frequency of nucleotides
         GammaRates : array of extended;
         //alpha2,beta2 : double;
         property AAFreq[i : integer] : double read GetAAf write PutAAf;
         property Alpha : double read fAlpha write fAlpha;
         property Beta : double read fBeta write fBeta;
         property Rate : double read fRate write fRate;
         property IsGamma : boolean read fIsGamma;
         property GammaA : double read fGammaA;
         property Insertions : TIndelModel read fInsertionModel write fInsertionModel;
         property Deletions : TIndelModel read fDeletionModel write fDeletionModel;
         property TRatio : double read GetTransRatio; { transition/transversion ratio }
         property kappa : double read GetKappa;
         //procedure CalcPMat(var CMat : TSqNucMat; t : double);
         constructor Create;
         destructor Destroy; override;
         function Simulate(expected : double; var realized,seed : integer; Sequence : string;
                  var InsSite,InsSize : TIntArray; IndList : TStringList) : string;
         //function Simulate2(brlength : double; var seed : integer; Sequence : string) : string;
         procedure SetupNucFreq(fa,fc,fg,ft : double);
         procedure SetGenRes(pAC,pAG,pAT,pCG,pCT,pGT : double); // setup paramaters for general reversible model
         procedure SetGamma(a : double; n : integer; var seed : integer);
         procedure SetGammaDesc(a : double; n : integer; var seed : integer;
                   OldRates : array of extended);
         procedure CopyGamma(a : double; OldRates : array of extended);
      end;

    {-----Gene Declarations-----}
    TGene = class
       public
         Name,
         Sequence : string;
         Expected : double;
         Observed,
         Realized : integer;
         SubstitutionModel : TSubstitutionModel;
         constructor create;
       end;

    {-----Tree Declarations-----}
    TNode = class
        { Add ability to include other characters are trait values }
        public
          Genes : TList;
          Name : string;
          BrLength : double;
          Ancestor : TNode;
          Descendents : TList;
          constructor create;
          destructor Destroy; override;
          procedure AddChild(newchild : TNode);
          procedure SetGeneNumber(n : integer);
      end;

    TDrawnNode = record
             startx,endx,yp : integer;
             LNode : TNode;
        end;
    TDrawRecs = array of TDrawnNode;

    TSubRec = record
            SNode : TNode;
            SModel : TSubstitutionModel;
        end;
    TSubList = array of TSubRec;

{ Essential math functions }
FUNCTION gammln(xx: real): real;
FUNCTION ran3(VAR idum: integer): extended;
FUNCTION gasdev(VAR idum: integer): double;
FUNCTION poidev(xm: real; VAR idum: integer): real;
function rand(var seed : integer; lo,hi:integer):integer;
function NewGam(alpha : double; var seed : integer) : extended;
function NewGamma(alpha : double; var seed : integer) : extended;
PROCEDURE indexx(n: integer; VAR arrin: TDArray;
          VAR indx: TIntArray);

{ Sequence functions }
function RandomNucSequence(n : integer; var seed : integer; ga,gc,gg,gt : double) : string;
function RandomAASequence(n : integer; var seed : integer; ExpAAF : TAAFreqs) : string;
procedure CalcNucF(seq : string; var fa,fc,fg,ft : double);
procedure CalcAAF(seq : string; var AAFreqs : TAAFreqs);
procedure CalcDDMatrix(seqs : TStringList; var DDMat : TDoubleArray);
function CountNonGapSites(seq : string) : integer;
function InsertGapIntoSequence(seq : string; ISites,ILengths : TIntArray) : string;

{ Tree functions }
procedure WriteTreePar(node : TNode; dat : byte; gene : integer; blformat : string; var parout : string);
procedure ReadTreePar(tree : string; var start : TNode);
procedure ReadTreeKumar(inname : string; var tree : TNode);
procedure ReadTreeNodal(inname : string; var Tree : TNode);
procedure ClearSequences(node : TNode);
function FindRootNode(node : TNode) : TNode;
function IsDescendent(a,d : TNode) : boolean;
function AreSiblings(n1,n2 : TNode) : boolean;
function AncestorToDescendentDistance(A,D : TNode) : double;
function DistanceonTree(n1,n2 : TNode) : double;
function CountTips(node : TNode) : integer;
procedure LadLeft(node : TNode);
procedure LadRight(node : TNode);
function MaxNodeTipLength(node : TNode) : double;
function MaxNodeName(node : TNode) : string;
{$IFNDEF FPC}
function DrawTree(canv : TCanvas; var cnt : integer; minx,maxx,miny,maxy : integer; tree : TNode;
                        scale : double; DoLabels,DoBrLen : boolean; lines : TDrawRecs) : integer;
{$ENDIF}
procedure SetSubMatrix(node : TNode; gene : integer; SM : TSubstitutionModel);
//procedure CalcExpectedChanges(node : TNode; gn,n : integer);
function WriteExpectedChanges(node : TNode; gene : integer; blformat,outp : string) : string;
function WriteObservedChanges(node : TNode; gene : integer; outp : string) : string;
function WriteRealizedChanges(node : TNode; gene : integer; outp : string) : string;
function LowDivergence(node : TNode) : boolean;
function LowAADiv(node : TNode) : boolean;
procedure SimulateOnTree(tree : TNode; var seed : integer; IndList : TStringList);
procedure WriteTipSequences(Tree : TNode; var OutP : TStringList);
procedure WriteTipSequencesGene(Tree : TNode; gn : integer; var OutP : TStringList);
procedure WriteTipNames(Tree : TNode; var outp : string; pref : string);
procedure GetTipNames(Tree : TNode; outp : TStringList; pref : string);
procedure CreateNodeList(Tree : TNode; NodeList : TList);
procedure OutputInternalNodes(Tree : TNode; NodeList : TStringList);
procedure OutputAllNodes(Tree : TNode; NodeList : TStringList);
procedure OutputNodeSequences(Tree : TNode; NodeList : TStringList; SeqList : TStringList);
procedure AddInsertionsToTree(Tree,Base : TNode; GeneN : integer;
          InsSite,InsSize : TIntArray);
procedure GetTipNodes(Tree : TNode; NodeList : TList);
procedure GetModelList(Node : TNode; GeneN : integer; ModelList : TList);
procedure AddNewGammaRates(SubModel : TSubstitutionModel; ISites,ILengths : TIntArray);
procedure UpdateTreeGamma(TreeNode : TNode; GeneN : integer; ISites,ILengths : TIntArray);

function CalcExpected(SModel : TSubstitutionModel; nsites : integer;
              BrLength,ga,gc,gg,gt : double) : double;

procedure CalcJCParameter(rate : double; var alpha : double);
procedure CalcK2Parameters(rate,transratio : double; var alpha,beta : double);
procedure CalcEqInpParameters(rate,fa,fc,fg,ft : double; var alpha : double);
procedure CalcHKYParameters(rate,transratio,fa,fc,fg,ft : double; var alpha,beta : double);
procedure CalcGenResParameters(rate,fa,fc,fg,ft : double; var Pac,Pag,Pat,Pcg,Pct,Pgt : double);

{ Random # generator variables }
var
   Ran3Inext,Ran3Inextp: integer;
   Ran3Ma: array[1..55] of extended;
   PoidevOldm,PoidevSq,PoidevAlxm,PoidevG: extended;
   GamNa,GamNd,GamNc : double;
   GasdevIset: integer;
   GasdevGset: extended;

implementation

Uses Math;

{---------------From Numerical Recipes---------------}
FUNCTION gammln(xx: real): real;
CONST
   stp  =  2.50662827465;
VAR
   x,tmp,ser: double;
BEGIN
   x := xx-1.0;
   tmp := x+5.5;
   tmp := (x+0.5)*ln(tmp)-tmp;
   ser := 1.0+76.18009173/(x+1.0)-86.50532033/(x+2.0)+24.01409822/(x+3.0)
            -1.231739516/(x+4.0)+0.120858003e-2/(x+5.0)-0.536382e-5/(x+6.0);
   gammln := tmp+ln(stp*ser)
END;

PROCEDURE indexx(n: integer; VAR arrin: TDArray; VAR indx: TIntArray);
LABEL 99;
VAR
   l,j,ir,indxt,i: integer;
   q: real;
BEGIN
   FOR j := 1 TO n DO
      indx[j] := j;
   IF n = 1 THEN GOTO 99;
   l := (n DIV 2) + 1;
   ir := n;
   WHILE true DO BEGIN
      IF l > 1 THEN BEGIN
         l := l-1;
         indxt := indx[l];
         q := arrin[indxt]
      END
      ELSE BEGIN
         indxt := indx[ir];
         q := arrin[indxt];
         indx[ir] := indx[1];
         ir := ir-1;
         IF ir = 1 THEN BEGIN
            indx[1] := indxt;
            GOTO 99
         END
      END;
      i := l;
      j := l+l;
      WHILE j <= ir DO BEGIN
         IF j < ir THEN
            IF arrin[indx[j]] < arrin[indx[j+1]] THEN j := j+1;
         IF q < arrin[indx[j]] THEN BEGIN
            indx[i] := indx[j];
            i := j;
            j := j+j
         END
         ELSE
         j := ir+1
      END;
      indx[i] := indxt
   END;
99:
END;

{----------Random Number Generator----------}
FUNCTION ran3(VAR idum: integer): extended;
CONST
   mbig = 4.0e6;
   mseed = 1618033.0;
   mz = 0.0;
   fac = 2.5e-7;
VAR
   i,ii,k: integer;
   mj,mk: extended;
BEGIN
   IF idum < 0 THEN BEGIN
      mj := mseed+idum;
      IF mj >= 0.0 THEN
         mj := mj-mbig*trunc(mj/mbig)
      ELSE
         mj := mbig-abs(mj)+mbig*trunc(abs(mj)/mbig);
      Ran3Ma[55] := mj;
      mk := 1;
      FOR i := 1 TO 54 DO BEGIN
         ii := 21*i MOD 55;
         Ran3Ma[ii] := mk;
         mk := mj-mk;
         IF mk < mz THEN mk := mk+mbig;
         mj := Ran3Ma[ii]
      END;
      FOR k := 1 TO 4 DO BEGIN
         FOR i := 1 TO 55 DO BEGIN
            Ran3Ma[i] := Ran3Ma[i]-Ran3Ma[1+((i+30) MOD 55)];
            IF Ran3Ma[i] < mz THEN Ran3Ma[i] := Ran3Ma[i]+mbig
         END
      END;
      Ran3Inext := 0;
      Ran3Inextp := 31;
      idum := 1
   END;
   Ran3Inext := Ran3Inext+1;
   IF Ran3Inext = 56 THEN
      Ran3Inext := 1;
   Ran3Inextp := Ran3Inextp+1;
   IF Ran3Inextp = 56 THEN Ran3Inextp := 1;
   mj := Ran3Ma[Ran3Inext]
            -Ran3Ma[Ran3Inextp];
   IF mj < mz THEN mj := mj+mbig;
   Ran3Ma[Ran3Inext] := mj;
   ran3 := mj*fac
END;

{----------Random Numbers from  Normal Distribution----------}
FUNCTION gasdev(VAR idum: integer): double;
VAR
   fac,r,v1,v2: double;
BEGIN
   IF GasdevIset = 0 THEN BEGIN
      REPEAT
         v1 := 2.0*ran3(idum)-1.0;
         v2 := 2.0*ran3(idum)-1.0;
         r := sqr(v1)+sqr(v2);
      UNTIL (r < 1.0) AND (r > 0.0);
      fac := sqrt(-2.0*ln(r)/r);
      GasdevGset := v1*fac;
      gasdev := v2*fac;
      GasdevIset := 1
   END
   ELSE BEGIN
      GasdevIset := 0;
      gasdev := GasdevGset;
   END
END;

{----------Random Numbers from  Poisson Distribution----------}
FUNCTION poidev(xm: real; VAR idum: integer): real;
CONST
   pi = 3.141592654;
VAR
   em,t,y: real;
BEGIN
   IF xm < 12.0 THEN BEGIN
      IF xm <> PoidevOldm THEN BEGIN
         PoidevOldm := xm;
         PoidevG := exp(-xm)
      END;
      em := -1;
      t := 1.0;
      REPEAT
         em := em+1.0;
         t := t*ran3(idum);
      UNTIL t <= PoidevG
   END
   ELSE BEGIN
      IF xm <> PoidevOldm THEN BEGIN
         PoidevOldm := xm;
         PoidevSq := sqrt(2.0*xm);
         PoidevAlxm := ln(xm);
         PoidevG := xm*PoidevAlxm
            -gammln(xm+1.0)
      END;
      REPEAT
         REPEAT
            y := pi*ran3(idum);
            y := sin(y)/cos(y);
            em := PoidevSq*y+xm;
         UNTIL em >= 0.0;
         em := trunc(em);
         t := 0.9*(1.0+sqr(y))*exp(em*PoidevAlxm-gammln(em+1.0)-PoidevG);
      UNTIL ran3(idum) <= t
   END;
   poidev := em
END;

{------------------------------}

function NewGam(alpha : double; var seed : integer) : extended;
var
   v,x,u : extended;
   done : boolean;
begin
     if (alpha <> GamNa) then begin
        GamNd := alpha - 1.0 / 3.0;
        GamNc := 1.0 / sqrt(9.0 * GamNd);
     end;
     done := false;
     repeat
           repeat
                 x := GasDev(Seed);
                 v := 1.0 + GamNc * x;
           until (v > 0.0);
           //v := v*v*v;
           v := IntPower(v,3);
           u := ran3(seed);
           if (u < 1.0-0.0331*(sqr(x)*sqr(x))) or
              (log10(u) < 0.5*sqr(x)+GamNd*(1.0-v+log10(v))) then done := true;
     until done;
     result := GamNd * v;
end;

function NewGamma(alpha : double; var seed : integer) : extended;
begin
     if (alpha <= 0.0) then result := sqrt(-1)
     else if (alpha < 1.0) then
          result := NewGam(1.0+alpha,seed) * power(ran3(seed),1.0/alpha)
     else if (alpha > 1.0) then result := NewGam(alpha,seed)
     else result := -log10(ran3(seed));
end;

{-----------Uniform Random Integer Between lo and hi----------}
function rand(var seed : integer; lo,hi:integer):integer;
begin
     rand := trunc(ran3(seed) * (hi - lo + 1)) + lo;
end;

{----------Insertion/Deletion Models----------}
constructor TIndelModel.Create;
begin
     inherited Create;
     fActive := false;
     fRate := 10;
     fSize := 4;
     fPower := 1;
     fSizeProb := nil;
     fDist := idtPoisson;
end;

destructor TIndelModel.Destroy;
begin
     fSizeProb := nil;
end;

function TIndelModel.GetSizeProb(i : integer) : double;
begin
     if (i > 0) and (i <= length(fSizeProb)) then
        result := fSizeProb[i-1]
     else result := 0.0;
end;

function TIndelModel.NewIndel(var seed : integer) : integer;
begin
     case fDist of
          idtPoisson : result := round(PoiDev(Size-1.0,seed)) + 1;
          idtPower : result := FromPowerDistribution(seed);
          else result := 1;
     end;
end;

function TIndelModel.FromPowerDistribution(var seed : integer) : integer;
var
   p,s : double;
   i,m : integer;
begin
     m := length(fSizeProb);
     p := ran3(seed);
     i := 1;
     s := SizeProb[i];
     while (p > s) and (i < m) do begin
           inc(i);
           s := s + SizeProb[i];
     end;
     result := i;
end;

procedure TIndelModel.SetModel(NewType : TIndelDistType;
          NewRate,NewSize,NewPower : double);
begin
     fActive := true;
     fDist := NewType;
     fRate := NewRate;
     fSize := NewSize;
     fPower := NewPower;
     if (fDist = idtPower) then InitPowerDistribution;
end;

procedure TIndelModel.InitPowerDistribution;
var
   m,i: Integer;
   s : double;
begin
     // currently the length of 100 is a temporary value that should be replaced
     // by a variable
     m := 100;

     SetLength(fSizeProb,m);
     s := 0.0;
     for i := 0 to m - 1 do begin
         fSizeProb[i] := fRate * power(i+1,fPower);
         s := s + fSizeProb[i];
     end;
     for i := 0 to m - 1 do fSizeProb[i] := fSizeProb[i] / s;
end;

{----------Substitution Model----------}
constructor TSubstitutionModel.Create;
begin
     inherited create;
//     SiteRates := nil;
     GammaRates := nil;
     { defaults }
     DataType := dtNucleotide;
     NucModel := nmJC;
     fIsGamma := false;
     fInsertionModel := TIndelModel.Create;
     fDeletionModel := TIndelModel.Create;
end;

destructor TSubstitutionModel.Destroy;
begin
//     SiteRates := nil;
     GammaRates := nil;
     fInsertionModel.Free;
     fDeletionModel.Free;
     inherited destroy;
end;

function TSubstitutionModel.Simulate(expected : double; var realized,seed : integer;
         Sequence : string; var InsSite,InsSize : TIntArray; IndList : TStringList) : string;
var
   r,i,j,o,l,ss : integer;
   oldn : char;
   e : double;
   tempseq,inseq : string;
begin
     InsSite := nil; InsSize := nil;
     { Setup transition matrix }
     SetRelRates;

     case DataType of
          dtNucleotide : begin
                  case NucModel of
                       nmJC : begin
                                   for i := 1 to 4 do fNuc[i] := 0.25;
                                   beta := alpha;
                              end;
                       nmK2 : for i := 1 to 4 do fNuc[i] := 0.25;
                       nmEqInp : beta := alpha;
                  end;
                  CalcNucTransMat;
              end;
     end;

     SetupSiteRates(sequence);

     Realized := round(PoiDev(Expected,seed));

     for i := 1 to Realized do begin
         r := FindSite(seed,Sequence);
         oldn := Sequence[r];
         case DataType of
              dtNucleotide : Sequence[r] := NewNucleotide(Sequence[r],seed);
              dtAminoAcid : case AAModel of
                                 amPoisson : Sequence[r] := NewAminoAcid(Sequence[r],seed);
                                // amDayhoff : Sequence[r] := Dayhoff_Sub(seed,Sequence[i]);
                            end;
         end;

         if (DataType = dtNucleotide) then
            case NucModel of
                 nmEqInp,nmHKY,nmGenRes : AdjustTotalRate(r,oldn,Sequence[r]);
            end;

     end;

     // deletion events
     if Deletions.IsActive then begin
        e := Realized / Deletions.Rate;
        o := round(PoiDev(e,seed));
        for i := 1 to o do begin
            r := rand(seed,1,length(Sequence));
            l := Deletions.NewIndel(seed);
            for j:= 1 to l do begin
                if (r <= length(Sequence)) then begin
                   while (Sequence[r] = '-') and (r < length(Sequence)) do inc(r);
                   Sequence[r] := '-';
                end;
            end;
            IndList.Add(IntToStr(l));
        end;
     end;

     // insertion events
     if Insertions.IsActive then begin
        e := Realized / Insertions.Rate;
        o := round(PoiDev(e,seed));
        for i := 1 to o do begin
            repeat
                  r := rand(seed,1,length(Sequence));
            until (Sequence[r] <> '-');
            l := Insertions.NewIndel(seed);
            SetLength(InsSite,length(InsSite)+1);
            SetLength(InsSize,length(InsSize)+1);
            j := length(InsSite) - 1;
            InsSite[j] := r;
            InsSize[j] := l;
            inseq := RandomNucSequence(l,seed,FNuc[1],FNuc[2],FNuc[3],FNuc[4]);
            tempseq := Sequence;
            if (r < length(Sequence)) then begin
               Sequence := Copy(tempseq,1,r) + inseq + Copy(tempseq,r+1,length(tempseq));
               if fIsGamma then begin
                  j := length(GammaRates);
                  //SetLength(GammaRates,j + l);
                  SetLength(GammaRates,length(Sequence));
                  //for ss := j + l - 1 downto r + l - 1 do GammaRates[ss] := GammaRates[ss - l];
                  for ss := length(Sequence) - 1 downto r + l - 1 do GammaRates[ss] := GammaRates[ss - l];
                  for ss := r to r + l - 1 do GammaRates[ss] := NewGamma(GammaA,seed);
               end;
            end else begin
                Sequence := tempseq + inseq;
                if fIsGamma then begin
                   j := length(GammaRates);
                   //SetLength(GammaRates,j + l);
                   //for ss := j to j + l - 1 do GammaRates[ss] := NewGamma(GammaA,seed);
                   SetLength(GammaRates,length(Sequence));
                   for ss := j to length(Sequence) - 1 do GammaRates[ss] := NewGamma(GammaA,seed);
                end;
            end;
            IndList.Add(IntToStr(l));
        end;
     end;

     result := Sequence;
end;

procedure TSubstitutionModel.SetRelRates;
var
   i,j : integer;
begin
     if (DataType = dtNucleotide) then
        case NucModel of
             nmJC,nmK2 : for i := 1 to 4 do relrate[i] := 1.0;
             nmEqInp : for i := 1 to 4 do
                           relrate[i] := alpha * (1.0 - fNuc[i]);
             nmHKY : begin
                          relrate[1] := beta * (fNuc[2] + fNuc[4]) + alpha * fNuc[3];
                          relrate[2] := beta * (fNuc[1] + fNuc[3]) + alpha * fNuc[4];
                          relrate[3] := beta * (fNuc[2] + fNuc[4]) + alpha * fNuc[1];
                          relrate[4] := beta * (fNuc[1] + fNuc[3]) + alpha * fNuc[2];
                     end;
             nmGenRes : for i := 1 to 4 do begin
                            relrate[i] := 0.0;
                            for j := 1 to 4 do
                                if (i <> j) then
                                   relrate[i] := relrate[i] + GenResParams[i,j] * fNuc[j];
                        end;
        end;
end;

procedure TSubstitutionModel.SetupSiteRates(seq : string);
var
   i,n : integer;
   NCnt : array[1..4] of integer;
begin
     n := length(seq);
     fTotalRate := 0.0;
     if IsGamma then begin
        for i := 0 to n - 1 do
            if (seq[i+1] <> '-') then
               fTotalRate := fTotalRate + GammaRates[i] * relrate[Pos(seq[i+1],Nucleotides)];
     end else begin
         case DataType of
              dtNucleotide : case NucModel of
                                  nmJc,nmK2 : fTotalRate := CountNonGapSites(seq);
                                  else begin
                                       { count curent frequencies }
                                       for i := 1 to 4 do NCnt[i] := 0;
                                       for i := 1 to n do
                                           if (seq[i] <> '-') then
                                              inc(Ncnt[Pos(Seq[i],Nucleotides)]);
                                       for i := 1 to 4 do fTotalRate := fTotalRate + NCnt[i] * RelRate[i];
                                  end;
                             end;
              dtAminoAcid : fTotalRate := n;
         end;
     end;
end;

procedure TSubstitutionModel.AdjustTotalRate(site : integer; oldnuc,newnuc : char);
var
   gam : double;
begin
     // Relase 1.0.3 fixed bug where the following line had GammaRates[site]
     // rather than GammaRates[site-1]
     if IsGamma then gam := GammaRates[site-1]
     else gam := 1.0;
     fTotalRate := fTotalRate - gam *
        (relrate[Pos(oldnuc,Nucleotides)] - relrate[Pos(newnuc,Nucleotides)]);
end;

{procedure TSubstitutionModel.CalcPMat(var CMat : TSqNucMat; t : double);
var
   bigP : array[1..4] of double;
   kap,
   u,w,x,y,z,p,bP,min4beta : double;
   i,j : integer;
begin
     bigP[1] := fNuc[1] + fNuc[3];
     bigP[2] := fNuc[2] + fNuc[4];
     bigP[3] := fNuc[1] + fNuc[3];
     bigP[4] := fNuc[2] + fNuc[4];
     min4beta := -4.0 * beta2;
     //min4beta := -4.0;
     kap := alpha2 / beta2;
     for i := 1 to 4 do begin
         for j := 1 to 4 do begin
             bP := bigP[j];
             p := fNuc[j];
             u := (1.0 / bP) - 1.0;
             w := min4beta * (1.0 + bP * (kap - 1.0));
             x := exp(min4beta * t);
             y := exp(w * t);
             z := (bP - p) / bP;
             if (i = j) then
                CMat[i,j] := p + p * u * x + z * y
             else if ((i = 1) and (j = 3)) or ((i = 3) and (j = 1)) or
                     ((i = 2) and (j = 4)) or ((i = 4) and (j = 2)) then
                CMat[i,j] := p + p * u * x - (p / bP) * y
             else CMat[i,j] := p * (1.0 - x);
         end;
     end;
end;}

{function TSubstitutionModel.NewNucleotide2(CMat : TSqNucMat; x : char; var seed : integer) : char;
var
   i : integer;
   s,P : double;
begin
     P := ran3(seed);
     i := 0; s := 0.0;
     repeat
           inc(i);
           s := s + CMat[Pos(x,Nucleotides),i];
     until (P <= s) or (i = 4);
     result := Nucleotides[i];
end;}

{function TSubstitutionModel.Simulate2(brlength : double; var seed : integer;
         Sequence : string) : string;
var
   i : integer;
   r : double;
   ChMat : TSqNucMat;
begin
     for i := 1 to length(Sequence) do begin
         //if IsGamma then r := SiteRates[i] else
         r := 1.0;
         CalcPMat(ChMat,brlength*r);
         Sequence[i] := NewNucleotide2(ChMat,Sequence[i],seed);
     end;
     result := Sequence;
end;}

function TSubstitutionModel.GetTransRatio : double;
begin
     case NucModel of
          nmJC,nmEqInp : result := 0.5;
          nmHKY,nmK2 : result := alpha / (2.0 * beta);
          else result := 0.5;
     end;
end;

function TSubstitutionModel.GetKappa : double;
begin
     case NucModel of
          nmJC,nmEqInp : result := 1.0;
          nmHKY,nmK2 : result := alpha / beta;
          else result := 1.0;
     end;
end;

procedure TSubstitutionModel.SetupNucFreq(fa,fc,fg,ft : double);
begin
     FNuc[1] := fa; FNuc[2] := fc; FNuc[3] := fg; FNuc[4] := ft;
end;

function TSubstitutionModel.GetAAf(i : integer) : double;
begin
     result := fAA[i];
end;

procedure TSubstitutionModel.PutAAf(i : integer; freq : double);
begin
     fAA[i] := freq;
end;

procedure TSubstitutionModel.CopyGamma(a : double; OldRates : array of extended);
var
   i : integer;
begin
     FIsGamma := true;
     FGammaA := a;
     SetLength(GammaRates,length(OldRates));
     for i := 0 to length(OldRates) - 1 do GammaRates[i] := OldRates[i];
end;

procedure TSubstitutionModel.SetGamma(a : double; n : integer; var seed : integer);
var
   i : integer;
begin
     FIsGamma := true;
     FGammaA := a;
     SetLength(GammaRates,n);
     { calculate a gamma value for each site }
     for i := 0 to n - 1 do GammaRates[i] := NewGamma(GammaA,seed);
end;

procedure TSubstitutionModel.SetGammaDesc(a : double; n : integer; var seed : integer;
          OldRates : array of extended);
var
   i : integer;
   tempold,temprates : TDArray;
   newind,oldind : TIntArray;
begin
     FIsGamma := true;
     FGammaA := a;
     SetLength(temprates,n+1);
     SetLength(tempold,n+1);
     SetLength(newind,n+1);
     SetLength(oldind,n+1);
     { calculate a gamma value for each site }
     for i := 1 to n do begin
         temprates[i] := NewGamma(GammaA,seed);
         tempold[i] := Oldrates[i-1];
     end;
     indexx(n,temprates,newind);
     indexx(n,tempold,oldind);
     // similarly placed rates go in same spot
     SetLength(GammaRates,n);
     for i := 1 to n do begin
         GammaRates[oldind[i]-1] := temprates[newind[i]];
     end;
     tempold := nil; temprates := nil;
     newind := nil; oldind := nil;
end;

procedure TSubstitutionModel.SetPowerDistribution(P : TDArray; a,b : double);
var
   i: Integer;
   s : double;
begin
     // currently the length of 100 is a temporary value that should be replaced
     // by a variable
     SetLength(P,101);
     s := 0.0;
     for i := 1 to 100 do begin
         P[i] := a * power(i,b);
         s := s + P[i];
     end;
     for i := 1 to 100 do P[i] := P[i] / s;
end;

procedure TSubstitutionModel.SetGenRes(pAC,pAG,pAT,pCG,pCT,pGT : double);
var
   i : integer;
begin
     for i := 1 to 4 do GenResParams[i,i] := 0.0;
     GenResParams[1,2] := pAC; GenResParams[2,1] := pAC;
     GenResParams[1,3] := pAG; GenResParams[3,1] := pAG;
     GenResParams[1,4] := pAT; GenResParams[4,1] := pAT;
     GenResParams[2,3] := pCG; GenResParams[3,2] := pCG;
     GenResParams[2,4] := pCT; GenResParams[4,2] := pCT;
     GenResParams[3,4] := pGT; GenResParams[4,3] := pGT;
end;

function TSubstitutionModel.FindSite(var seed : integer; seq : string) : integer;
var
   i : integer;
   runtot,P : extended;
begin
           //try
              repeat
                    P := ran3(seed) * fTotalRate;
                    i := 0; runtot := 0.0;
                    repeat
                          inc(i);
                          if (seq[i] <> '-') then begin
                             if IsGamma then
                                runtot := runtot + GammaRates[i-1] * relrate[Pos(seq[i],Nucleotides)]
                             else runtot := runtot + relrate[Pos(seq[i],Nucleotides)];
                          end;
                    until (P <= runtot) or (i = length(Seq));
                    result := i;
              until (seq[i] <> '-');
           //except on EMathError do begin end; //DoOver := true;
           //end;
end;

procedure TSubstitutionModel.CalcNucTransMat;
var
   i,j : integer;
   total : double;
begin
     for i := 1 to 4 do begin
         total := 0.0;
         case NucModel of
              nmK2 : total := alpha + 2.0 * beta;
              nmEqInp : for j := 1 to 4 do if (j <> i) then
                            total := total + alpha * fNuc[j];
              nmHKY : for j := 1 to 4 do if (j <> i) then
                          if ((i = 1) and (j = 3)) or ((i = 3) and (j = 1)) or
                             ((i = 2) and (j = 4)) or ((i = 4) and (j = 2)) then
                                 total := total + alpha * fNuc[j]
                          else total := total + beta * fNuc[j];
              nmGenRes : for j := 1 to 4 do if (j <> i) then
                           total := total + GenResParams[i,j] * fNuc[j];
         end;
         for j := 1 to 4 do begin
             if (i = j) then NucTransMat[i,j] := 0.0
             else case NucModel of
                  nmJC : NucTransMat[i,j] := 1.0 / 3.0;
                  nmK2 : if ((i = 1) and (j = 3)) or ((i = 3) and (j = 1)) or
                            ((i = 2) and (j = 4)) or ((i = 4) and (j = 2)) then
                                NucTransMat[i,j] := alpha / total
                         else NucTransMat[i,j] := beta / total;
                  nmEqInp : NucTransMat[i,j] := (alpha * fNuc[j]) / total;
                  nmHKY : if ((i = 1) and (j = 3)) or ((i = 3) and (j = 1)) or
                             ((i = 2) and (j = 4)) or ((i = 4) and (j = 2)) then
                                 NucTransMat[i,j] := (alpha * fNuc[j]) / total
                          else NucTransMat[i,j] := (beta * fNuc[j]) / total;
                  nmGenRes : NucTransMat[i,j] := (GenResParams[i,j] * fNuc[j]) / total;
             end;
         end;
     end;
end;

function TSubstitutionModel.NewAminoAcid(x : char; var seed : integer) : char;
var
   r : integer;
begin
     repeat
           r := rand(seed,1,20);
     until (r <> pos(x,AminoAcids));
     result := AminoAcids[r];
end;

function TSubstitutionModel.NewNucleotide(x : char; var seed : integer) : char;
var
   i : integer;
   s,P : double;
begin
     P := ran3(seed);
     i := 0; s := 0.0;
     repeat
           inc(i);
           s := s + NucTransMat[Pos(x,Nucleotides),i];
     until (P <= s) or (i = 4);
     result := Nucleotides[i];
end;

{function TSubstitutionModel.Dayhoff_Sub(t : double; var seed : integer; x : char) : char;
var
   i,j : integer;
   s,P : double;
begin
     for j := 1 to trunc(t) do begin
         P := ran3(seed);
         i := 0; s := 0.0;
         repeat
               inc(i);
               s := s + DayhoffMat[Pos(x,Nucleotides),i] / 10000.0;
         until (P <= s) or (i = 20);
         x := AminoAcids[i];
     end;
     result := x;
end;}

{----------Gene----------}
constructor TGene.Create;
begin
     Name := '';
     Sequence := '';
     Expected := 0.0;
     Observed := 0;
     Realized := 0;
end;

{----------Tree Node----------}
constructor TNode.Create;
begin
     Name := '';
     BrLength := 1.0;
     Ancestor := nil;
     Descendents := TList.Create;
     Genes := TList.Create;
end;

destructor TNode.destroy;
var
   i : integer;
begin
     for i := 0 to Descendents.Count - 1 do
         TNode(Descendents[i]).Free;
     for i := 0 to Genes.Count - 1 do
         TGene(Genes[i]).Free;
     Descendents.Free;
end;

procedure TNode.AddChild(NewChild : TNode);
begin
     Descendents.Add(NewChild);
     NewChild.Ancestor := Self;
end;

procedure TNode.SetGeneNumber(n : integer);
var
   i : integer;
   NewGene : TGene;
begin
     { Free Old Genes }
     for i := 0 to Genes.Count - 1 do
         TGene(Genes[i]).Free;
     Genes.Clear;
     { Create New Genes }
     for i := 1 to n do begin
         NewGene := TGene.create;
         Genes.Add(NewGene);
     end;
     { Pass on to descendents }
     for i := 0 to Descendents.Count - 1 do TNode(Descendents[i]).SetGeneNumber(n);
end;

{----------Sequence Functions----------}

function RandomNucSequence(n : integer; var seed : integer; ga,gc,gg,gt : double) : string;
{ Create a random nucleotide sequence of n bases and expected nucleotide
  frequencies of ga, gc, gg, and gt }
var
   i : integer;
   seq : string;
   p : double;
begin
     seq := '';
     for i := 1 to n do begin
         p := ran3(seed);
         if (P <= ga) then seq := seq + 'A'
         else if (P <= ga + gc) then seq := seq + 'C'
         else if (P <= ga + gc + gg) then seq := seq + 'G'
         else seq := seq + 'T';
     end;
     result := seq;
end;

{ Create a random Amino Acid sequence with n acids and expected frequencies
  as given in ExpAAF }
function RandomAASequence(n : integer; var seed : integer; ExpAAF : TAAFreqs) : string;
var
   i,j : integer;
   seq : string;
   s,p : double;
begin
     seq := '';
     for i := 1 to n do begin
         p := ran3(seed);
         j := 0; s := 0.0;
         repeat
               inc(j);
               s := s + ExpAAF[j];
         until (P <= s) or (j = 20);
         seq := seq + AminoAcids[j];
     end;
     result := seq;
end;

procedure CalcNucF(seq : string; var fa,fc,fg,ft : double);
var
   i : integer;
   cnts : array[1..4] of integer;
begin
     for i := 1 to 4 do cnts[i] := 0;
     for i := 1 to length(seq) do inc(cnts[pos(seq[i],Nucleotides)]);
     fa := cnts[1] / length(seq); fc := cnts[2] / length(seq);
     fg := cnts[3] / length(seq); ft := cnts[4] / length(seq);
end;

procedure CalcAAF(seq : string; var AAFreqs : TAAFreqs);
var
   i : integer;
   cnts : array[1..20] of integer;
begin
     for i := 1 to 20 do cnts[i] := 0;
     for i := 1 to length(seq) do inc(cnts[pos(seq[i],AminoAcids)]);
     for i := 1 to 20 do AAFreqs[i] := cnts[i] / length(seq);
end;

procedure CalcDDMatrix(seqs : TStringList; var DDMat : TDoubleArray);
var
   nnuc1,nnuc2 : array[1..4] of integer;
   seql,Nd,n,i,j,k,l : integer;
   seq1,seq2 : string;
   SumD : double;
begin
     n := Seqs.Count;
     seql := length(Seqs[0]);
     SetLength(DDMat,n,n);
     for i := 0 to n - 1 do begin
         seq1 := Seqs[i];
         DDMat[i,i] := 0.0;
         for j := i + 1 to n - 1 do begin
             seq2 := Seqs[j];
             Nd := 0;
             for k := 1 to 4 do begin
                 nnuc1[k] := 0; nnuc2[k] := 0;
             end;
             for k := 1 to seql do begin
                 l := Pos(seq1[k],Nucleotides);
                 inc(nnuc1[l]);
                 l := Pos(seq2[k],Nucleotides);
                 inc(nnuc2[l]);
                 if (seq1[k] <> seq2[k]) then inc(Nd);
             end;
             SumD := 0.0;
             for k := 1 to 4 do
             //    SumD := SumD + sqr((nnuc1[k] - nnuc2[k])/seql);
                 SumD := SumD + sqr(nnuc1[k] - nnuc2[k]);
             if (Nd = 0) then DDMat[i,j] := 0.0
             else DDMat[i,j] := Max(0.0,(0.5 * SumD - Nd) / Sqr(Nd));
             DDMat[j,i] := DDMat[i,j];
         end;
     end;
end;

{-----miscellaneous tree routines-----}
procedure WriteTreePar(node : TNode; dat : byte; gene : integer; blformat : string; var parout : string);
{ This procedure will write out a tree in the paranthetical format.  If
  blformat is not '' it will include branch lengths in the format specified
  by the blformat string }
var
   i : integer;
begin
     if (Node.Descendents.Count = 0) then begin
        parout := parout + trim(Node.Name);
        { Choose which type of data to list as the branch lengths }
        case dat of
             1 : parout := parout + ':' + format(blformat,[Node.BrLength]);
             2 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Expected]);
             3 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Observed]);
             4 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Realized]);
        end;
     end else begin
         parout := parout + '(';
         for i := 0 to Node.Descendents.Count - 1 do begin
             WriteTreePar(TNode(Node.Descendents[i]),dat,gene,blformat,parout);
             if (i + 1 < Node.Descendents.Count) then
                parout := parout + ',';
         end;
         parout := parout + ')';
         case dat of
              1 : parout := parout + ':' + format(blformat,[Node.BrLength]);
              2 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Expected]);
              3 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Observed]);
              4 : parout := parout + ':' + format(blformat,[TGene(Node.Genes[gene]).Realized]);
         end;
     end;
end;

procedure ReadTreePar(tree : string; var start : TNode);
const
     search = ['(',')',',',';'];
var
   i,j : integer;
   NewNode,
   Current : TNode;
   NewName : string;
begin
     i := 1;
     Current := Start;
     repeat
           if (tree[i] = '(') then begin
              NewNode := TNode.Create;
              Current.AddChild(NewNode);
              Current := NewNode;
           end else if (tree[i] = ',') then begin
               Current := Current.Ancestor;
               NewNode := TNode.Create;
               Current.AddChild(NewNode);
               Current := NewNode;
           end else if (tree[i] = ')') then begin
               if Current.Ancestor <> nil then
                  Current := Current.Ancestor;
           end else begin { Must be a name and/or branch length }
               j := i;
               repeat inc(j)
               until tree[j] in search;
               NewName := Copy(tree,i,j-i);
               case Pos(':',NewName) of
                    0 : Current.Name := NewName;
                    1 : Current.BrLength :=
                           StrToFloat(trim(Copy(NewName,2,length(NewName))));
                    else begin
                         { Separate name and branch length }
                         Current.Name := Copy(NewName,1,Pos(':',NewName)-1);
                         Current.BrLength :=
                            StrToFloat(trim(Copy(NewName,Pos(':',NewName)+1,length(NewName))));
                    end;
               end;
               i := j - 1;
           end;
           inc(i);
     until (tree[i] = ';');
end;

procedure ReadTreeKumar(inname : string; var tree : TNode);
const
     okchars = '1234567890-' + ^M + ^J;
var
   infile : TextFile;
   blx,bly : double;
   s,x,y,
   start,n,i : integer;
   good : boolean;
   c : char;
   line : string;
   NewNode : TNode;
   Used : array of TNode;
begin
     AssignFile(infile,trim(inname)); Reset(infile);
     readln(infile,n);
     SetLength(used,n);
     for i := 1 to n - 1 do used[i] := nil;
     Tree := TNode.Create;
     Tree.Name := '1';
     Used[0] := Tree;
     good := true;
     start := 0;
     repeat
        try
           repeat
                 read(infile,c);
           until (c <> ' ');
           if (pos(c,okchars) = 0) then good := false
           else begin
                if (c = '-') then begin
                   readln(infile,start);
                end else if (c = ^M) or (c = ^J) then begin
                end else begin
                    line := c;
                    repeat
                          read(infile,c);
                          line := line + c;
                    until (c = ' ');
                    { the leading number doesn't appear to actually play
                      a useful role, so you end up throwing it away }
                    s := start;
                    readln(infile,x,y,blx,bly);
                    { Create nodes if necessary }
                    if Used[x+s] = nil then begin
                       NewNode := TNode.Create;
                       NewNode.Name := IntToStr(x+s+1);
                       Used[x+s] := NewNode;
                    end;
                    if Used[y+s] = nil then begin
                       NewNode := TNode.Create;
                       NewNode.Name := IntToStr(y+s+1);
                       Used[y+s] := NewNode;
                    end;
                    { Note: the following line is used to maintain the distance
                      of 1 between the basal clades; the format gives one of them
                      a length of 1 and the other a length of zero, but the way
                      I store the data this creates an apparent polytomy at the
                      base of the tree.  By changing both lengths to 1/2 you
                      maintain the constant distance, but remove the polytomy.
                      When it comes time to do the simulatin, we must check and
                      make sure this will be ok }
                    {if ((blx = 1) and (bly = 0)) or
                       ((blx = 0) and (bly = 1)) then begin
                             blx := 0.5;
                             bly := 0.5;
                    end;}
                    { Store branch lengths }
                    TNode(FindRootNode(Used[x+s])).BrLength := blx;
                    TNode(FindRootNode(Used[y+s])).BrLength := bly;
                    { Attach to Tree }
                    NewNode := TNode.Create;
                    NewNode.AddChild(FindRootNode(Used[x+s]));
                    NewNode.AddChild(FindRootNode(Used[y+s]));
                end;
           end;
        except on EInOutError do good := false;
        end;
     until not good;
     Used := nil;
     Closefile(infile);
end;

procedure ReadTreeNodal(inname : string; var Tree : TNode);
var
   infile : TextFile;
   blx,bly : double;
   s,x,y,n,i : integer;
   NewNode : TNode;
   Used : array of TNode;
begin
     AssignFile(infile,trim(inname)); Reset(infile);
     { Read # of taxa }
     read(infile,n); readln(infile);
     readln(infile);
     SetLength(used,2*n-1);
     for i := 0 to 2 * n - 2 do used[i] := nil;
     for i := n + 1 to 2 * n - 1 do begin
         readln(infile,s,x,y,blx,bly);
         if (Used[x-1] = nil) then begin
            NewNode := TNode.Create;
            NewNode.Name := IntToStr(x);
            Used[x-1] := NewNode;
         end;
         if (Used[y-1] = nil) then begin
            NewNode := TNode.Create;
            NewNode.Name := IntToStr(y);
            Used[y-1] := NewNode;
         end;
         { This line is specially designed to add the root properly to the
           large 228 taxa tree }
         if (s=455) then begin
            blx := 20.07;
            bly := 20.07;
         end;

         TNode(Used[x-1]).BrLength := blx;
         TNode(Used[y-1]).BrLength := bly;
         { Create new node }
         NewNode := TNode.Create;
         NewNode.Name := IntToStr(s);
         Used[s-1] := NewNode;
         NewNode.AddChild(Used[x-1]);
         NewNode.AddChild(Used[y-1]);

     end;
     Tree := Used[0];
     Used := nil;
     Closefile(infile);
end;

procedure ClearSequences(node : TNode);
var
   i : integer;
begin
     for i := 0 to Node.Genes.Count - 1 do
         with TGene(Node.Genes[i]) do begin
              Sequence := '';
              Observed := 0;
              Realized := 0;
         end;
     for i := 0 to Node.Descendents.Count - 1 do
         ClearSequences(Node.Descendents[i]);
end;

function FindRootNode(node : TNode) : TNode;
begin
     if Node.Ancestor <> nil then
        result := FindRootNode(Node.Ancestor)
     else result := node;
end;

function IsDescendent(a,d : TNode) : boolean;
var
   i : integer;
   tempres : boolean;
begin
     tempres := false;
     for i := 0 to a.Descendents.Count - 1 do begin
         if (a.Descendents[i] = d) then tempres := true
         else if IsDescendent(A.Descendents[i],d) then tempres := true;
     end;
     result := tempres;
end;

function AreSiblings(n1,n2 : TNode) : boolean;
var
   root : TNode;
   i : integer;
begin
     root := n1.Ancestor;
     result := false;
     for i := 0 to root.Descendents.Count - 1 do
         if (TNode(root.Descendents[i]) = n2) then result := true;
end;

function AncestorToDescendentDistance(A,D : TNode) : double;
var
   dist : double;
   Current : TNode;
begin
     dist := 0; Current := D;
     repeat
           dist := dist + Current.BrLength;
           Current := Current.Ancestor;
     until (Current = A);
     result := dist;
end;

function DistanceonTree(n1,n2 : TNode) : double;
var
   Root : TNode;
   dist : double;
begin
     dist := 0.0;
     if IsDescendent(n1,n2) then
        dist := AncestorToDescendentDistance(n1,n2)
     else if IsDescendent(n2,n1) then
          dist := AncestorToDescendentDistance(n2,n1)
     else begin
          Root := n1;
          repeat
                Root := Root.Ancestor;
          until IsDescendent(Root,n2);
          dist := dist + AncestorToDescendentDistance(root,n1);
          dist := dist + AncestorToDescendentDistance(root,n2);
     end;
     Result := dist;
end;

function CountTips(node : TNode) : integer;
var
   i,cnt : integer;
begin
     if (node.Descendents.Count = 0) then result := 1
     else begin
          cnt := 0;
          for i := 0 to Node.Descendents.Count - 1 do
              cnt := cnt + CountTips(Node.Descendents[i]);
          result := cnt;
     end;
end;

procedure LadLeft(node : TNode);
var
   i,j : integer;
begin
     for i := 0 to Node.Descendents.Count - 1 do begin
         LadLeft(Node.Descendents[i]);
         for j := i - 1 downto 0 do begin
             if (CountTips(Node.Descendents[i]) > CountTips(Node.Descendents[j])) then
                Node.Descendents.Move(i,j);
         end;
     end;
end;

procedure LadRight(node : TNode);
var
   i,j : integer;
begin
     for i := 0 to Node.Descendents.Count - 1 do begin
         LadRight(Node.Descendents[i]);
         for j := i - 1 downto 0 do begin
             if (CountTips(Node.Descendents[i]) < CountTips(Node.Descendents[j])) then
                Node.Descendents.Move(i,j);
         end;
     end;
end;

function MaxNodeTipLength(node : TNode) : double;
var
   long,decl : double;
   i : integer;
begin
     long := 0.0;
     for i := 0 to Node.Descendents.Count - 1 do begin
         decl := MaxNodeTipLength(Node.Descendents[i]);
         if (decl > long) then
            long := decl;
     end;
     result := long + Node.BrLength;
end;

function MaxNodeName(node : TNode) : string;
{ This procedure will find the longest name associated with any node }
var
   decname,long : string;
   i : integer;
begin
     long := trim(Node.Name);
     for i := 0 to Node.Descendents.Count - 1 do begin
         decname := MaxNodeName(Node.Descendents[i]);
         if (length(decname) > length(long)) then
            long := decname;
     end;
     result := long;
end;

{$IFNDEF FPC}
function DrawTree(canv : TCanvas; var cnt : integer; minx,maxx,miny,maxy : integer; tree : TNode;
                        scale : double; DoLabels,DoBrLen : boolean; lines : TDrawRecs) : integer;
var
   topy,bottomy,topline,bottomline,
   nd,i,ndd,
   yadj,xadj,
   x,y : integer;
   lentxt : string;
begin
     with canv do begin
          yadj := TextHeight('W') div 2;
          Pen.Color := clBlack;
          Pen.Style := psSolid;
          Pen.Width := 1;
          Brush.Style := bsClear;
          x := trunc(Tree.BrLength*scale);
          if (Tree.Descendents.Count > 0) then begin
             topline := 0; bottomline := 0;
             nd := CountTips(tree);
             topy := miny;
             for i := 0 to Tree.Descendents.Count - 1 do begin
                 ndd := CountTips(tree.Descendents[i]);
                 bottomy := topy + trunc((ndd/nd) * (maxy - miny));
                 y := DrawTree(canv,cnt,minx + x,maxx,topy,bottomy,
                         Tree.Descendents[i],scale,DoLabels,DoBrLen,lines);
                 if (i = 0) then topline := y
                 else if (i = Tree.Descendents.Count - 1) then bottomline := y;
                 topy := bottomy;
             end;
             MoveTo(minx+x,bottomline); LineTo(minx+x,topline);
             y := ((bottomline-topline) div 2) + topline;
          end else begin
              y := ((maxy-miny) div 2) + miny;
              if DoLabels then TextOut(minx + x + 10,y-yadj,trim(Tree.Name));
          end;
          MoveTo(minx,y); LineTo(minx + x,y);
          { Add branch length? }
          if DoBrLen then begin
             lentxt := format('%1.4f',[Tree.BrLength]);
             xadj := TextWidth(lentxt) div 2;
             TextOut(minx + (x div 2) - xadj,y - TextHeight(lentxt),lentxt);
          end;
          
          with lines[cnt] do begin
               startx := minx;
               endx := minx + x;
               yp := y;
               lnode := tree;
          end;
          inc(cnt);

          result := y;
     end;
end;
{$ENDIF}

procedure SetSubMatrix(node : TNode; gene : integer; SM : TSubstitutionModel);
var
   i : integer;
begin
     TGene(Node.Genes[gene]).SubstitutionModel := SM;
     for i := 0 to Node.Descendents.Count - 1 do
         SetSubMatrix(Node.Descendents[i],gene,SM);
end;

function CalcExpected(SModel : TSubstitutionModel; nsites : integer; BrLength,
                 ga,gc,gg,gt : double) : double;
begin
     result := 0.0;
     with SModel do case DataType of
          dtNucleotide : case NucModel of
                              nmJC : result := BrLength * 3.0 * alpha * nsites;
                              nmK2 : result := BrLength * (alpha + 2.0 * beta) * nsites;
                              nmEqInp : result := BrLength * nsites * alpha * 2.0 *
                                      (ga*gc + ga*gg + ga*gt +
                                       gc*gg + gc*gt + gg*gt);
                              nmHKY : result := BrLength * nsites * 2.0 *
                                      (alpha * (ga*gg + gc*gt) +
                                       beta * (ga*gt + ga*gc + gc*gg + gg*gt));
                              nmGenRes : result := BrLength * nsites * 2.0 *
                                       (ga*gc*GenResParams[1,2] +
                                        ga*gg*GenResParams[1,3] +
                                        ga*gt*GenResParams[1,4] +
                                        gc*gg*GenResParams[2,3] +
                                        gc*gt*GenResParams[2,4] +
                                        gg*gt*GenResParams[3,4]);
                              {nmEqInp : result := BrLength * nsites * alpha * 2.0 *
                                      (fNuc[1]*fNuc[2] + fNuc[1]*fNuc[3] + fNuc[1]*fNuc[4] +
                                       fNuc[2]*fNuc[3] + fNuc[2]*fNuc[4] + fNuc[3]*fNuc[4]);
                              nmHKY : result := BrLength * nsites * 2.0 *
                                      (alpha * (fNuc[1]*fNuc[3] + fNuc[2]*fNuc[4]) +
                                       beta * (fNuc[1]*fNuc[4] + fNuc[1]*fNuc[2] +
                                               fNuc[2]*fNuc[3] + fNuc[3]*fNuc[4]));
                              nmGenRes : result := BrLength * nsites * 2.0 *
                                       (fNuc[1]*fNuc[2]*GenResParams[1,2] +
                                        fNuc[1]*fNuc[3]*GenResParams[1,3] +
                                        fNuc[1]*fNuc[4]*GenResParams[1,4] +
                                        fNuc[2]*fNuc[3]*GenResParams[2,3] +
                                        fNuc[2]*fNuc[4]*GenResParams[2,4] +
                                        fNuc[3]*fNuc[4]*GenResParams[3,4]);}
                         end;
          dtAminoAcid : case AAModel of
                           amPoisson : result := BrLength * rate * nsites;
                           { The following is NOT setup yet }
                           amDayhoff : begin end;
                        end;
     end;
end;

{procedure CalcExpectedChanges(node : TNode; gn,n : integer);
var
   Gene : TGene;
   i : integer;
begin
     Gene := TGene(Node.Genes[gn]);
     Gene.Expected := CalcExpected(Gene.SubstitutionModel,n,Node.BrLength);
     for i := 0 to Node.Descendents.Count - 1 do
         CalcExpectedChanges(Node.Descendents[i],gn,n);
end;}

function WriteExpectedChanges(node : TNode; gene : integer; blformat,outp : string) : string;
var
   i : integer;
begin
     if (Node.Descendents.Count = 0) then
        outp := outp + format(blformat,[TGene(Node.Genes[gene]).Expected]) + ' '
     else begin
         for i := 0 to Node.Descendents.Count - 1 do
             outp := WriteExpectedChanges(node.Descendents[i],gene,blformat,outp);
         outp := outp + format(blformat,[TGene(Node.Genes[gene]).Expected]) + ' ';
     end;
     result := outp;
end;

function WriteObservedChanges(node : TNode; gene : integer; outp : string) : string;
var
   i : integer;
begin
     if (Node.Descendents.Count = 0) then
        outp := outp + IntToStr(TGene(Node.Genes[gene]).Observed) + ' '
     else begin
         for i := 0 to Node.Descendents.Count - 1 do
             outp := WriteObservedChanges(node.Descendents[i],gene,outp);
         outp := outp + IntToStr(TGene(Node.Genes[gene]).Observed) + ' ';
     end;
     result := outp;
end;

function WriteRealizedChanges(node : TNode; gene : integer; outp : string) : string;
var
   i : integer;
begin
     if (Node.Descendents.Count = 0) then
        outp := outp + IntToStr(TGene(Node.Genes[gene]).Realized) + ' '
     else begin
         for i := 0 to Node.Descendents.Count - 1 do
             outp := WriteRealizedChanges(node.Descendents[i],gene,outp);
         outp := outp + IntToStr(TGene(Node.Genes[gene]).Realized) + ' ';
     end;
     result := outp;
end;

procedure GetModelList(Node : TNode; GeneN : integer; ModelList : TList);
{ This produces a list of all unique substitution models found on the tree }
var
   i : integer;
   IsOld : boolean;
   CModel : TSubstitutionModel;
begin
     IsOld := false;
     CModel := TGene(Node.Genes[GeneN]).SubstitutionModel;
     for i := 0 to ModelList.Count - 1 do
         if (TSubstitutionModel(ModelList[i]) = CModel) then IsOld := true;
     if not IsOld then ModelList.Add(CModel);
     for i := 0 to Node.Descendents.Count - 1 do
         GetModelList(Node.Descendents[i],GeneN,ModelList);
end;

procedure AddNewGammaRates(SubModel : TSubstitutionModel; ISites,ILengths : TIntArray);
var
   r,l,c,i,j,n : integer;
begin
     n := length(ISites);
     for i := 0 to n - 1 do begin
         c := length(SubModel.GammaRates);
         l := ILengths[i];
         r := ISites[i];
         SetLength(SubModel.GammaRates,c+l);
         // move current sites to make room for gap
         for j := c + l - 1 downto r + l - 1 do
             SubModel.GammaRates[j] := SubModel.GammaRates[j-l];
         // place rates of zero in gap
         for j := r to r + l - 1 do SubModel.GammaRates[j] := 0.0;
     end;
end;

procedure UpdateTreeGamma(TreeNode : TNode; GeneN : integer; ISites,ILengths : TIntArray);
var
   ModelList : TList;
   NModel,OModel : TSubstitutionModel;
   i : integer;
   D : TNode;
begin
     OModel := TGene(TreeNode.Genes[GeneN]).SubstitutionModel;
     ModelList := TList.Create;
     GetModelList(FindRootNode(TreeNode),GeneN,ModelList);
     for i := 0 to ModelList.Count - 1 do
         if (ModelList[i] <> OModel) and TSubstitutionModel(ModelList[i]).IsGamma then 
            AddNewGammaRates(TSubstitutionModel(ModelList[i]),ISites,ILengths);
     ModelList.Free;
end;

{----------Miscellaneous Sequence Routines----------}
procedure SimulateOnTree(tree : TNode; var seed : integer; IndList : TStringList);
var
   {cnt,}i,{j,}k : integer;
   D : TNode;
   OldGene,Gene : TGene;
   fa,fc,fg,ft : double;
   InsSize,InsSite : TIntArray;
begin
     InsSize := nil; InsSite := nil;
     for i := 0 to Tree.Descendents.Count - 1 do begin
         D := Tree.Descendents[i];
         for k := 0 to Tree.Genes.Count - 1 do begin
             OldGene := TGene(Tree.Genes[k]);
             Gene := TGene(D.Genes[k]);

             CalcNucF(OldGene.Sequence,fa,fc,fg,ft);
             Gene.Expected := CalcExpected(Gene.SubstitutionModel,
                  length(OldGene.Sequence),D.BrLength,fa,fc,fg,ft);

             Gene.Sequence := Gene.SubstitutionModel.Simulate(Gene.Expected,
                Gene.Realized,seed,OldGene.Sequence,InsSite,InsSize,IndList);

             if (length(InsSize) > 0) then begin
                AddInsertionsToTree(FindRootNode(D),D,k,InsSite,InsSize);
                UpdateTreeGamma(D,k,InsSite,InsSize);
             end;
             { Count Observed Changes }
             {cnt := 0;
             for j := 1 to length(Gene.Sequence) do
                 if (OldGene.Sequence[j] <> Gene.Sequence[j]) then inc(cnt);
             Gene.Observed := cnt;}
         end;
         { Continue Simulating Evolution Up Each Branch }
         SimulateOnTree(D,seed,IndList);
     end;
     InsSize := nil; InsSite := nil;
end;

function InsertGapIntoSequence(seq : string; ISites,ILengths : TIntArray) : string;
var
   n,i,j : integer;
   newseq,oldseq,iseq : string;
begin
     newseq := seq;
     n := length(ISites);
     for i := 0 to n - 1 do begin
         iseq := '';
         for j := 1 to ILengths[i] do iseq := iseq + '-';
         oldseq := newseq;
         if (ISites[i] < length(oldseq)) then
            newseq := Copy(oldseq,1,ISites[i]) + iseq + Copy(oldseq,ISites[i]+1,length(oldseq))
         else newseq := oldseq + iseq;
     end;
     result := newseq;
end;

procedure AddInsertionsToTree(Tree,Base : TNode; GeneN : integer;
          InsSite,InsSize : TIntArray);
var
   i : integer;
   Gene : TGene;
   D : TNode;
begin
     if (Tree <> Base) then begin
        Gene := TGene(Tree.Genes[GeneN]);
        if (length(Gene.Sequence) > 0) then
           Gene.Sequence := InsertGapIntoSequence(Gene.Sequence,InsSite,InsSize);
     end;
     for i := 0 to Tree.Descendents.Count - 1 do begin
         D := Tree.Descendents[i];
         AddInsertionsToTree(D,Base,GeneN,InsSite,InsSize);
     end;
end;

{ Pull the tip names and sequences out of a treefile }
procedure WriteTipSequences(Tree : TNode; var OutP : TStringList);
var
   i : integer;
   seq : string;
begin
     if (Tree.Descendents.Count = 0) then begin
        seq := '';
        for i := 0 to Tree.Genes.Count - 1 do
            seq := seq + trim(TGene(Tree.Genes[i]).Sequence);
        OutP.Add(seq);
     end else for i := 0 to Tree.Descendents.Count - 1 do
         WriteTipSequences(Tree.Descendents[i],OutP);
end;

{ Pull the tip names and sequences out of a treefile, one gene only }
procedure WriteTipSequencesGene(Tree : TNode; gn : integer; var OutP : TStringList);
var
   i : integer;
begin
     if (Tree.Descendents.Count = 0) then
        OutP.Add(trim(TGene(Tree.Genes[gn]).Sequence))
     else for i := 0 to Tree.Descendents.Count - 1 do
         WriteTipSequencesGene(Tree.Descendents[i],gn,OutP);
end;

{ Pull the tip names and sequences out of a treefile }
procedure WriteTipNames(Tree : TNode; var outp : string; pref : string);
var
   i : integer;
begin
     if (Tree.Descendents.Count = 0) then begin
        if (StrToIntDef(trim(Tree.Name),-999) = -999) then
           outp := outp + trim(Tree.Name) + ' '
        else outp := outp + pref + trim(Tree.Name) + ' ';
     end else for i := 0 to Tree.Descendents.Count - 1 do
          WriteTipNames(Tree.Descendents[i],OutP,pref);
end;

{ Pull the tip names and sequences out of a treefile }
procedure GetTipNames(Tree : TNode; outp : TStringList; pref : string);
var
   i : integer;
begin
     if (Tree.Descendents.Count = 0) then begin
        if (StrToIntDef(trim(Tree.Name),-999) = -999) then
           Outp.Add(trim(Tree.Name))
        else outp.Add(pref + trim(Tree.Name));
     end else for i := 0 to Tree.Descendents.Count - 1 do
          GetTipNames(Tree.Descendents[i],OutP,pref);
end;

procedure GetTipNodes(Tree : TNode; NodeList : TList);
var
   i : integer;
begin
     if (Tree.Descendents.Count = 0) then
        NodeList.Add(Tree)
     else for i := 0 to Tree.Descendents.Count - 1 do
          GetTipNodes(Tree.Descendents[i],NodeList);
end;

{ Calculate whether the most divergent taxa violate the rules for a specific
  type of distance }
function LowDivergence(node : TNode) : boolean;
var
   IsGood : boolean;
   p1cnt,p2cnt,
   pcnt,qcnt,i,j,k : integer;
   ga,gc,gg,gt,gr,gy,
   p1div,p2div,pdiv,qdiv : double;
   Data : TStringList;
   x,y : string;
   SM : TSubstitutionModel;
begin
     IsGood := true;
     Data := TStringList.Create;
     WriteTipSequences(Node,Data);
     // check based on the model of the first node only!!!
     SM := TGene(Node.Genes[0]).SubstitutionModel;
     with SM do begin
          ga := FNuc[1]; gc := FNuc[2];
          gg := FNuc[3]; gt := FNuc[4];
          gr := ga + gg; gy := gc + gt;
     end;
     for i := 1 to Data.Count do begin
         for j := i + 1 to Data.Count do begin
             pcnt := 0; qcnt := 0; p1cnt := 0; p2cnt := 0;
             x := Data[i-1]; y := Data[j-1];
             case SM.NucModel of
                  nmJC : begin
                              for k := 1 to length(x) do if (x[k] <> y[k]) then
                                  inc(pcnt);
                              PDiv := pcnt / length(x);
                              if (PDiv >= 0.75) then IsGood := false;
                         end;
                  nmK2 : begin
                              for k := 1 to length(x) do if (x[k] <> y[k]) then
                                  if ((x[k] = 'A') and (y[k] = 'G')) or
                                     ((x[k] = 'G') and (y[k] = 'A')) or
                                     ((x[k] = 'T') and (y[k] = 'C')) or
                                     ((x[k] = 'C') and (y[k] = 'T')) then inc(pcnt)
                                  else inc(qcnt);
                              PDiv := Pcnt / length(x);
                              QDiv := Qcnt / length(x);
                              if (QDiv >= 0.5) then IsGood := false
                              else if (2.0*PDiv + QDiv >= 1.0) then IsGood := false;
                         end;
                  nmHKY : begin
                              for k := 1 to length(x) do if (x[k] <> y[k]) then
                                  if ((x[k] = 'A') and (y[k] = 'G')) or
                                     ((x[k] = 'G') and (y[k] = 'A'))  then inc(p1cnt)
                                  else if
                                     ((x[k] = 'T') and (y[k] = 'C')) or
                                     ((x[k] = 'C') and (y[k] = 'T')) then inc(p2cnt)
                                  else inc(qcnt);
                              P1Div := P1cnt / length(x);
                              P2Div := P2cnt / length(x);
                              QDiv := Qcnt / length(x);
                              if (((gr/(2.0*ga*gg))*P1Div) + (QDiv/(2.0*gr)) >= 1.0) then
                                 IsGood := false;
                              if (((gy/(2.0*gt*gc))*P2Div) + (QDiv/(2.0*gy)) >= 1.0) then
                                 IsGood := false;
                              if ((QDiv/(2.0*gr*gy)) >= 1.0) then IsGood := false;
                          end;
             end;

         end;
     end;
     Data.Free;
     result := IsGood;
end;

function LowAADiv(node : TNode) : boolean;
var
   IsGood : boolean;
   pcnt,i,j,k : integer;
   pdiv : double;
   Data : TStringList;
   x,y : string;
begin
     IsGood := true;
     Data := TStringList.Create;
     WriteTipSequences(Node,Data);
     // check based on the model of the first node only!!!
     for i := 1 to Data.Count do begin
         for j := i + 1 to Data.Count do begin
             pcnt := 0;
             x := Data[i-1]; y := Data[j-1];
             for k := 1 to length(x) do if (x[k] <> y[k]) then
                 inc(pcnt);
             PDiv := pcnt / length(x);
             if (PDiv >= 1.0) then IsGood := false;
         end;
     end;
     Data.Free;
     result := IsGood;
end;

function CountNonGapSites(seq : string) : integer;
var
   i : integer;
begin
     result := 0;
     for i := 1 to length(seq) do
         if (seq[i] <> '-') then inc(result);
end;

procedure CalcJCParameter(rate : double; var alpha : double);
begin
     alpha := rate / 3.0;
end;

procedure CalcK2Parameters(rate,transratio : double; var alpha,beta : double);
begin
     alpha := (rate * transratio) / (transratio + 1.0);
     beta := (rate - alpha) / 2.0;
end;

procedure CalcEqInpParameters(rate,fa,fc,fg,ft : double; var alpha : double);
begin
     alpha := rate / (2.0 * (fa*fc + fa*fg + fa*ft + fc*fg + fc*ft + fg*ft));
end;

procedure CalcHKYParameters(rate,transratio,fa,fc,fg,ft : double; var alpha,beta : double);
begin
     alpha := rate / (2.0*((fa*fg + fc*ft) + ((fa*ft + fa*fc + fc*fg + fg*ft) /
                   (2.0*transratio))));
     beta := alpha / (2.0 * transratio);
end;

procedure CalcGenResParameters(rate,fa,fc,fg,ft : double; var Pac,Pag,Pat,Pcg,Pct,Pgt : double);
var
   r,m : double;
begin
     r := 2.0 * (pac*fa*fc + pag*fa*fg + pat*fa*ft + pcg*fc*fg + pct*fc*ft + pgt*fg*ft);
     m := rate / r;
     pac := pac * m;
     pag := pag * m;
     pat := pat * m;
     pcg := pcg * m;
     pct := pct * m;
     pgt := pgt * m;
end;

procedure CreateNodeList(Tree : TNode; NodeList : TList);
var
   i : integer;
begin
     NodeList.Add(Tree);
     for i := 0 to Tree.Descendents.Count - 1 do
         CreateNodeList(TNode(Tree.Descendents[i]),NodeList);
end;

procedure OutputInternalNodes(Tree : TNode; NodeList : TStringList);
var
   NList : TList;
   i : integer;
   tempstr : string;
   node : TNode;
begin
     NodeList.Clear;
     NList := TList.Create;
     CreateNodeList(Tree,NList);
     for i := 0 to NList.Count - 1 do begin
         Node := NList[i];
         if (Node.Descendents.Count > 0) then begin
            tempstr := '';
            WriteTipNames(Node,tempstr,'');
            NodeList.Add(IntToStr(i) + ': ' + tempstr);
         end;
     end;
     NList.Free;
end;

procedure OutputAllNodes(Tree : TNode; NodeList : TStringList);
var
   NList : TList;
   i : integer;
   tempstr : string;
   node : TNode;
begin
     NodeList.Clear;
     NList := TList.Create;
     CreateNodeList(Tree,NList);
     for i := 0 to NList.Count - 1 do begin
         Node := NList[i];
         tempstr := '';
         WriteTipNames(Node,tempstr,'');
         NodeList.Add(IntToStr(i) + ': ' + tempstr);
     end;
     NList.Free;
end;

procedure OutputNodeSequences(Tree : TNode; NodeList : TStringList; SeqList : TStringList);
var
   NList : TList;
   i,g : integer;
   seq,tempstr : string;
   node : TNode;
begin
     NodeList.Clear;
     SeqList.Clear;
     NList := TList.Create;
     CreateNodeList(Tree,NList);
     for i := 0 to NList.Count - 1 do begin
         Node := NList[i];
         tempstr := '';
         WriteTipNames(Node,tempstr,'');
         NodeList.Add(IntToStr(i) + ': ' + tempstr);
         seq := '';
         for g := 0 to Node.Genes.Count - 1 do
             seq := seq + trim(TGene(Node.Genes[g]).Sequence);
         SeqList.Add(seq);
     end;
     NList.Free;
end;

initialization
     GamNa := 0.0;
     GasdevIset := 0;
     PoidevOldm := -1.0;
end.
