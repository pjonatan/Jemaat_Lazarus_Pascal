unit Unit6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids, DB, sqldb, sqlite3conn, libjpfpdf, Global;

type

  { TForm6 }

  TForm6 = class(TForm)
    Pekerjaan: TComboBox;
    Edit1: TEdit;
    Image1: TImage;
    Image2: TImage;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
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
  Form6: TForm6;

implementation

{$R *.lfm}

{ TForm6 }

procedure TForm6.FormCreate(Sender: TObject);
begin
  SG.Options:= SG.Options + [goEditing];
end;

procedure TForm6.FormShow(Sender: TObject);
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
  pQry.SQL.Text := 'select * from pekerjaan';
  pQry.DataBase:= Scon;
  pQry.Open;
  Pekerjaan.Items.Clear;
  while not pQry.EOF do
  begin
    Pekerjaan.Items.Add(pQry.FieldByName('pekerjaan').AsString);
    pQry.Next;
  end;
  SG.TitleFont.Color:=clRed;
  SG.Cells[0,0]:= 'PID';
  SG.Cells[1,0]:='Pekerjaan';
  pQry.First;
  i:=0;
  while not pQry.EOF do
   begin
      i := i + 1;
      SG.Cells[0,i]:=pQry.FieldByName('ja_id').AsString;
      SG.Cells[1,i]:=pQry.FieldByName('pekerjaan').AsString;
      pQry.Next;
   end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm6.Image1Click(Sender: TObject);
var
  pdf: TJPFpdf;
  PdfY: integer;
  filename: string;
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  if(Pekerjaan.Text='Pekerjaan') then
  begin
    ShowMessage('Pekerjaan belum dipilih!!');
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
           pdf.Cell(190,8,'Jemaat dengan pekerjaan: ' + Pekerjaan.Text ,'1',0,'C',0);
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
           pQry.SQL.Text := 'select * from jemaat where pekerjaan =:pk';
           pQry.ParamByName('pk').Value:=IntToStr(Pekerjaan.ItemIndex + 1);
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

procedure TForm6.Image2Click(Sender: TObject);
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
      pQry.SQL.Text := 'insert into pekerjaan(pekerjaan) values(:pk)';
      pQry.ParamByName('pk').Value:=Form6.Edit1.Text;
      pQry.DataBase:=SCon;
      pQry.ExecSQL;
      STran.Commit;
      pQry.Close;
      SCon.Close;
      pQry.Free;
      STran.Free;
      SCon.Free;
      ShowMessage('Sudah disimpan');
      Form6.Visible:=False;
      Form6.Visible:=True;
    end;
end;

procedure TForm6.Ubah(sender: TObject; aCol, aRow: Integer;
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
      pQry.SQL.Text:= 'update pekerjaan set pekerjaan=:pk where ja_id=:ji';
      pQry.ParamByName('pk').Value:=SG.Cells[aCol,aRow];
      pQry.ParamByName('ji').Value:=SG.Cells[0,aRow];
      pQry.DataBase:=SCon;
      pQry.ExecSQL;
      STran.Commit;
      pQry.Close;
      SCon.Close;
      pQry.Free;
      STran.Free;
      SCon.Free;
      Form6.Visible:=False;
      Form6.Visible:=True;
    end;
end;

end.

