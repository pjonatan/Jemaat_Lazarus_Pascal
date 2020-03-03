unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  ExtCtrls, DB, sqldb, sqlite3conn, libjpfpdf, Global;

type

  { TForm5 }

  TForm5 = class(TForm)
    Pendidikan: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    SG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Ubah(sender: TObject; aCol, aRow: Integer;
              const OldValue: string; var NewValue: String);
  private

  public

  end;

var
  Form5: TForm5;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.FormCreate(Sender: TObject);
begin
  SG.Options:= SG.Options + [goEditing];
end;

procedure TForm5.FormShow(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  i: integer;
begin
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  pQry.SQL.Text := 'select * from pendidikan';
  pQry.DataBase:= Scon;
  pQry.Open;
  Pendidikan.Items.Clear;
  while not pQry.EOF do
  begin
    Pendidikan.Items.Add(pQry.FieldByName('pendidikan').AsString);
    pQry.Next;
  end;
  SG.TitleFont.Color:=clRed;
  SG.Cells[0,0]:= 'PID';
  SG.Cells[1,0]:='Pendidikan';
  pQry.First;
  i:=0;
  while not pQry.EOF do
   begin
      i := i + 1;
      SG.Cells[0,i]:=pQry.FieldByName('p_id').AsString;
      SG.Cells[1,i]:=pQry.FieldByName('pendidikan').AsString;
      pQry.Next;
   end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm5.Image2Click(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  if MessageDlg('Menyimpan data', 'Mau menyimpan data?', mtConfirmation,
    [mbYes, mbNo, mbIgnore],0) = mrYes
  then
    begin
      SCon  := TSQLite3Connection.Create(nil);
      STran := TSQLTransaction.Create(SCon);
      SCon.Transaction := STran;
      SCon.DatabaseName:='jemaat.db';
      pQry := TSQLQuery.Create(nil);
      pQry.SQL.Text := 'insert into pendidikan(pendidikan) values(:pd)';
      pQry.ParamByName('pd').Value:=Form5.Edit1.Text;
      pQry.DataBase:=SCon;
      pQry.ExecSQL;
      STran.Commit;
      pQry.Close;
      SCon.Close;
      pQry.Free;
      STran.Free;
      SCon.Free;
      ShowMessage('Sudah disimpan');
      Form5.Visible:=False;
      Form5.Visible:=True;
    end;
end;

procedure TForm5.Image1Click(Sender: TObject);
var
  pdf: TJPFpdf;
  PdfY: integer;
  filename: string;
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  if(Pendidikan.Text='Pendidikan') then
  begin
    ShowMessage('Pendidikan belum dipilih!!');
  end else
    begin
       if MessageDlg('Export data', 'Mau mengexport data ke pdf?', mtConfirmation,
         [mbYes, mbNo, mbIgnore],0) = mrYes
       then
         begin
           if SaveDialog1.Execute then
           begin
             filename := SaveDialog1.Filename;
             ShowMessage('Diexport ke : ' + filename + '.pdf');
           end;
           pdf:= TJPFpdf.Create(poPortrait,puMM,pfA4);
           pdf.AddPage();
           pdf.SetFont(ffHelvetica,fsBold,14);
           pdf.SetTextColor(cRed);
           pdf.SetXY(10,10);
           pdf.Cell(190,8,'Jemaat dengan pendidikan: ' + Pendidikan.Text ,'1',0,'C',0);
           pdf.SetFont(ffHelvetica,fsBold,12);
           pdf.SetTextColor(cBlue);
           pdf.SetXY(10,18);
           pdf.Cell(55,7,'Nama','1',0,'C',0);
           pdf.SetX(65);
           pdf.Cell(70,7,'Alamat','1',0,'C',0);
           pdf.SetX(135);
           pdf.Cell(30,7,'Tanggal Lahir','1',0,'C',0);
           pdf.SetX(165);
           pdf.Cell(35,7,'Phone','1',0,'C',0);
           pdf.SetTextColor(cBlack);
           pdf.SetFont(ffHelvetica,fsNormal,10);
           PdfY:= 18;
           SCon  := TSQLite3Connection.Create(nil);
           STran := TSQLTransaction.Create(SCon);
           SCon.Transaction := STran;
           SCon.DatabaseName:='jemaat.db';
           pQry := TSQLQuery.Create(nil);
           pQry.SQL.Text := 'select * from jemaat where pendidikan =:pd';
           pQry.ParamByName('pd').Value:=IntToStr(Pendidikan.ItemIndex + 1);
           pQry.Database := Scon;
           pQry.Open;
           while not pQry.EOF do
            begin
               PdfY := PdfY + 7;
               pdf.SetXY(10,PdfY);
               pdf.Cell(55,7,pQry.FieldByName('nama').AsString,'1',0,'L',0);
               pdf.SetX(65);
               pdf.Cell(70,7,pQry.FieldByName('alamat').AsString,'1',0,'L',0);
               pdf.SetX(135);
               pdf.Cell(30,7,CHari(pQry.FieldByName('tanggal_lahir').AsDateTime),'1',0,'L',0);
               pdf.SetX(165);
               pdf.Cell(35,7,pQry.FieldByName('phone').AsString ,'1',0,'L',0);
               pQry.Next;
            end;
           pQry.Close;
           SCon.Close;
           pQry.Free;
           STran.Free;
           SCon.Free;
           pdf.SaveToFile(filename + '.pdf');
           pdf.Free;
           ShowMessage('Sudah di export!');
         end;
    end;
end;

procedure TForm5.Ubah(sender: TObject; aCol, aRow: Integer;
               const OldValue: string; var NewValue: String);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  if(aCol=1) then
    begin
      SCon  := TSQLite3Connection.Create(nil);
      STran := TSQLTransaction.Create(SCon);
      SCon.Transaction := STran;
      SCon.DatabaseName:='jemaat.db';
      pQry := TSQLQuery.Create(nil);
      pQry.SQL.Text:= 'update pendidikan set pendidikan=:pd where p_id=:pi';
      pQry.ParamByName('pd').Value:=SG.Cells[aCol,aRow];
      pQry.ParamByName('pi').Value:=SG.Cells[0,aRow];
      pQry.DataBase:=SCon;
      pQry.ExecSQL;
      STran.Commit;
      pQry.Close;
      SCon.Close;
      pQry.Free;
      STran.Free;
      SCon.Free;
      Form5.Visible:=False;
      Form5.Visible:=True;
    end;
end;

end.

