unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
      ExtCtrls,  StdCtrls, DB, sqldb, sqlite3conn, libjpfpdf, Grids,
      Global;

type

  { TForm4 }

  TForm4 = class(TForm)
    Image1: TImage;
    SG: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public
    Tg: String;
    i: Integer;
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

procedure Create_Header;   //Header SG Tstringgrid
begin
   Form4.SG.Cells[0,0] := 'JID';
   Form4.SG.Cells[1,0] := 'Nama';
   Form4.SG.Cells[2,0] := 'Alamat';
   Form4.SG.Cells[3,0] := 'Tanggal Lahir';
   Form4.SG.Cells[4,0] := 'Phone';
end;
procedure Create_Cells(Ind: Integer; Qry: TSQLQuery);  //Tstringgrid cell

begin
Form4.SG.Cells[0,Ind] := Qry.FieldByName('j_id').AsString;
Form4.SG.Cells[1,Ind] := Qry.FieldByName('nama').AsString;
Form4.SG.Cells[2,Ind] := Qry.FieldByName('alamat').AsString;
Form4.SG.Cells[3,Ind] := CHari(Qry.FieldByName('tanggal_lahir').AsDateTime);
Form4.SG.Cells[4,Ind] := Qry.FieldByName('phone').AsString;
end;
procedure TForm4.FormCreate(Sender: TObject);
begin
  Tg:=copy(hari,4,2);
  Form4.Caption:=Tg;
end;

procedure TForm4.FormShow(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  s: String;

begin
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  pQry.SQL.Text := 'select * from jemaat';
  pQry.Database := Scon;
  pQry.Open;
  SG.TitleFont.Color:=clRed;
  i := 0;
  Create_Header;
  while not pQry.EOF do
   begin
     s:=copy(CHari(pQry.FieldByName('tanggal_lahir').AsDateTime),4,2);
     if(s=Tg) then
      begin
        i := i + 1;
        Create_Cells(i, pQry);
      end;
      pQry.Next;
   end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm4.Image1Click(Sender: TObject);
var
  pdf: TJPFpdf;
  ct: Integer;
  PdfY: Integer;

begin
  pdf:= TJPFpdf.Create(poPortrait,puMM,pfA4);
  pdf.AddPage();
  pdf.SetFont(ffHelvetica,fsBold,14);
  pdf.SetTextColor(cRed);
  pdf.SetXY(10,10);
  pdf.Cell(190,8,'Daftar yang berulang tahun bulan: ' + Tg,'1',0,'C',0);
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
  pdf.SetFont(ffHelvetica,fsNormal,12);
  PdfY:= 18;
  ct:=0;
  while ct<i do
   begin
     inc(ct);
     PdfY := PdfY + 7;
     Pdf.SetXY(10,PdfY);
     pdf.Cell(55,7,Form4.SG.Cells[1,ct],'1',0,'L',0);
     pdf.SetX(65);
     pdf.Cell(70,7,Form4.SG.Cells[2,ct],'1',0,'L',0);
     pdf.SetX(135);
     pdf.Cell(30,7,Form4.SG.Cells[3,ct],'1',0,'L',0);
     pdf.SetX(165);
     pdf.Cell(35,7,Form4.SG.Cells[4,ct],'1',0,'L',0);
   end;
  pdf.SaveToFile('/home/bt/Ulang_tahun_' + Tg + '.pdf');
  pdf.Free;
  ShowMessage('Sudah diexport!');
end;

end.

