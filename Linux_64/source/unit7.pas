unit Unit7;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,  DB, sqldb, sqlite3conn, libjpfpdf, Global;

type

  { TForm7 }

  TForm7 = class(TForm)
    Darah: TComboBox;
    Image1: TImage;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private

  public

  end;

var
  Form7: TForm7;

implementation

{$R *.lfm}

{ TForm7 }

procedure TForm7.FormCreate(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  pQry.SQL.Text := 'select * from golongan_darah';
  pQry.DataBase:= Scon;
  pQry.Open;
  Darah.Items.Clear;
  while not pQry.EOF do
  begin
    Darah.Items.Add(pQry.FieldByName('golongan').AsString);
    pQry.Next;
  end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm7.Image1Click(Sender: TObject);
var
  pdf: TJPFpdf;
  PdfY: integer;
  filename: string;
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  if(Darah.ItemIndex=-1) then
  begin
    ShowMessage('Golongan Darah belum dipilih!!');
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
           pdf.Cell(190,8,'Jemaat dengan Golongan darah: ' + Darah.Text ,'1',0,'C',0);
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
           pQry.SQL.Text := 'select * from jemaat where go_darah=:gd';
           pQry.ParamByName('gd').Value:=Darah.Text;
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

end.

