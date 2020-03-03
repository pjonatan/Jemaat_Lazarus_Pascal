unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, DB, sqldb, sqlite3conn, Unit2, Unit3, Unit4, Unit5, Unit6,
   Unit7, Global;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image10: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Pekerjaan: TComboBox;
    Pendidikan: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    SG: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Ubah(sender: TObject; aCol, aRow: Integer;
           const OldValue: string; var NewValue: String);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure Create_Header;   //Header SG Tstringgrid
begin
   Form1.SG.Cells[0,0] := 'JID';
   Form1.SG.Cells[1,0] := 'Nomor Anggota';
   Form1.SG.Cells[2,0] := 'Nama';
   Form1.SG.Cells[3,0] := 'Alamat';
   Form1.SG.Cells[4,0] := 'Phone';
   Form1.SG.Cells[5,0] := 'Gender';
   Form1.SG.Cells[6,0] := 'Gol_Darah';
   Form1.SG.Cells[7,0] := 'Status';
   Form1.SG.Cells[8,0] := 'Tempat Lahir';
   Form1.SG.Cells[9,0] := 'Tg_Lahir';
   Form1.SG.Cells[10,0] := 'Pendidikan';
   Form1.SG.Cells[11,0] := 'Pekerjaan';
   Form1.SG.Cells[12,0] := 'Tg_Update';
end;
procedure Create_Cells(Ind: Integer; Qry: TSQLQuery);  //Tstringgrid cell
Var
  pnd: String;
  pkj: String;

begin
Form1.SG.Cells[0,Ind] := Qry.FieldByName('j_id').AsString;
Form1.SG.Cells[1,Ind] := Qry.FieldByName('no_anggota').AsString;
Form1.SG.Cells[2,Ind] := Qry.FieldByName('nama').AsString;
Form1.SG.Cells[3,Ind] := Qry.FieldByName('alamat').AsString;
Form1.SG.Cells[4,Ind] := Qry.FieldByName('phone').AsString;
Form1.SG.Cells[5,Ind] := Qry.FieldByName('gender').AsString;
Form1.SG.Cells[6,Ind] := Qry.FieldByName('go_darah').AsString;
Form1.SG.Cells[7,Ind] := Qry.FieldByName('status').AsString;
Form1.SG.Cells[8,Ind] := Qry.FieldByName('tempat_lahir').AsString;
Form1.SG.Cells[9,Ind] := CHari(Qry.FieldByName('tanggal_lahir').AsDateTime);
pnd:=Qry.FieldByName('pendidikan').AsString;
Case pnd of
 '1':
   Form1.SG.Cells[10,Ind] :='D1';
 '2':
   Form1.SG.Cells[10,Ind] :='D2';
 '3':
   Form1.SG.Cells[10,Ind] :='D3';
 '4':
   Form1.SG.Cells[10,Ind] :='Kejuruan';
 '5':
   Form1.SG.Cells[10,Ind] :='S1';
 '6':
   Form1.SG.Cells[10,Ind] :='S2';
 '7':
   Form1.SG.Cells[10,Ind] :='S3';
 '8':
   Form1.SG.Cells[10,Ind] :='SD';
 '9':
   Form1.SG.Cells[10,Ind] :='SLTP';
 '10':
   Form1.SG.Cells[10,Ind] :='SMU';
 '11':
   Form1.SG.Cells[10,Ind] :='TK';
 '12':
   Form1.SG.Cells[10,Ind] :='Lain-lain';
 end;
pkj:=Qry.FieldByName('pekerjaan').AsString;
Case pkj of
 '1':
   Form1.SG.Cells[11,Ind] :='Ibu RT';
 '2':
   Form1.SG.Cells[11,Ind] :='P.Negeri';
 '3':
   Form1.SG.Cells[11,Ind] :='P.Swasta';
 '4':
   Form1.SG.Cells[11,Ind] :='Pel/Mhs';
 '5':
   Form1.SG.Cells[11,Ind] :='Pensiunan';
 '6':
   Form1.SG.Cells[11,Ind] :='Petani';
 '7':
   Form1.SG.Cells[11,Ind] :='Profesional';
 '8':
   Form1.SG.Cells[11,Ind] :='Lain-lain';
 end;
Form1.SG.Cells[12,Ind] := CHari(Qry.FieldByName('tg_update').AsDateTime);
end;
procedure populate(Key: integer);
var
  i: integer;
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
begin
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  case Key of
   1:
      pQry.SQL.Text := 'select * from jemaat sort order by nama';
   2:
      pQry.SQL.Text := 'select * from jemaat sort order by alamat';
   3:
      pQry.SQL.Text := 'select * from jemaat sort order by no_anggota';
  end;
  pQry.DataBase:= Scon;
  pQry.Open;
  Form1.SG.Clean;
  Form1.SG.TitleFont.Color:=clRed;
  Form1.SG.TitleFont.Style:=[fsBold];
  i := 0;
  Create_Header;
  while not pQry.EOF do
   begin
      i := i + 1;
      Create_Cells(i, pQry);
      pQry.Next;
   end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
   Form2.Visible:=True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 populate(1);
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
SCon : TSQLConnection;
STran: TSQLTransaction;
pQry : TSQLQuery;

begin
   SG.Options:= SG.Options + [goEditing];           //for Tstringgrid editable
   SCon  := TSQLite3Connection.Create(nil);
   STran := TSQLTransaction.Create(SCon);
   SCon.Transaction := STran;
   SCon.DatabaseName:='jemaat.db';
   pQry := TSQLQuery.Create(nil);
   pQry.SQL.Text := 'select * from pekerjaan';
   pQry.DataBase:= Scon;
   pQry.Open;
   while not pQry.EOF do                          //populate Combo
   begin
     Pekerjaan.Items.Add(pQry.FieldByName('pekerjaan').AsString);
     pQry.Next;
   end;
   pQry.Close;
   pQry.SQL.Text := 'select * from pendidikan';
   pQry.DataBase:= Scon;
   pQry.Open;
   while not pQry.EOF do                        //populate combo
   begin
     Pendidikan.Items.Add(pQry.FieldByName('pendidikan').AsString);
     pQry.Next;
   end;
   pQry.Close;
   SCon.Close;
   pQry.Free;
   STran.Free;
   SCon.Free;
end;

procedure TForm1.Image10Click(Sender: TObject);
begin
  Form7.Visible:=True;
end;

procedure TForm1.Image1Click(Sender: TObject);
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
   pQry.Params.CreateParam(ftString, 'k_nama', ptInput);
   pQry.SQL.Text := 'select * from jemaat where nama like :k_nama';
   pQry.ParamByName('k_nama').Value:='%' + Edit1.Text + '%';
   pQry.Database := SCon;
   pQry.Open;
   SG.Clean;
   SG.TitleFont.Color:=clRed;
   SG.TitleFont.Style:=[fsBold];
   i := 0;
   Create_Header;
   while not pQry.EOF do
   begin
      i := i + 1;
      Create_Cells(i, pQry);
      pQry.Next;
   end;
   pQry.Close;
    SCon.Close;
    pQry.Free;
    STran.Free;
    SCon.Free;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
  Form4.Visible:=True;
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  Form3.ID3:=StrToInt(Edit2.Text);
  Form3.Visible:=True;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
 Form6.Visible:=True;
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
  Form5.Visible:= True;
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
  populate(2);
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
  populate(3);
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
  populate(1);
end;

procedure TForm1.Ubah(sender: TObject; aCol, aRow: Integer;
       const OldValue: string; var NewValue: String);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  Pkj: String;
  Pnd: String;

begin
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  Case aCol of
   1: begin
      pQry.SQL.Text := 'update jemaat set no_anggota=:noa where j_id=:hid';
      pQry.ParamByName('noa').Value:=SG.Cells[aCol,aRow];
   end;
   2: begin
      pQry.SQL.Text := 'update jemaat set nama=:nm where j_id=:hid';
      pQry.ParamByName('nm').Value:=SG.Cells[aCol,aRow];
   end;
   3: begin
      pQry.SQL.Text := 'update jemaat set alamat=:al where j_id=:hid';
      pQry.ParamByName('al').Value:=SG.Cells[aCol,aRow];
   end;
   4: begin
      pQry.SQL.Text := 'update jemaat set phone=:ph where j_id=:hid';
      pQry.ParamByName('ph').Value:=SG.Cells[aCol,aRow];
   end;
   5: begin
      pQry.SQL.Text := 'update jemaat set gender=:gd where j_id=:hid';
      pQry.ParamByName('gd').Value:=SG.Cells[aCol,aRow];
   end;
   6: begin
      pQry.SQL.Text := 'update jemaat set go_darah=:gh where j_id=:hid';
      pQry.ParamByName('gh').Value:=SG.Cells[aCol,aRow];
   end;
   7: begin
      pQry.SQL.Text := 'update jemaat set status=:st where j_id=:hid';
      pQry.ParamByName('st').Value:=SG.Cells[aCol,aRow];
   end;
   8: begin
      pQry.SQL.Text := 'update jemaat set tempat_lahir=:tl where j_id=:hid';
      pQry.ParamByName('tl').Value:=SG.Cells[aCol,aRow];
   end;
   9: begin
      pQry.SQL.Text := 'update jemaat set tanggal_lahir=:tr where j_id=:hid';
      pQry.ParamByName('tr').Value:=StrToDate(SG.Cells[aCol,aRow]);
   end;
   10:begin
      pQry.SQL.Text := 'update jemaat set pendidikan=:pd where j_id=:hid';
      Pnd:=SG.Cells[aCol,aRow];
      Case Pnd of
       'D1':
         pQry.ParamByName('pd').Value:='1';
       'D2':
         pQry.ParamByName('pd').Value:='2';
       'D3':
         pQry.ParamByName('pd').Value:='3';
       'Kejuruan':
         pQry.ParamByName('pd').Value:='4';
       'S1':
         pQry.ParamByName('pd').Value:='5';
       'S2':
         pQry.ParamByName('pd').Value:='6';
       'S3':
         pQry.ParamByName('pd').Value:='7';
       'SD':
         pQry.ParamByName('pd').Value:='8';
       'SLTP':
         pQry.ParamByName('pd').Value:='9';
       'SMU':
         pQry.ParamByName('pd').Value:='10';
       'TK':
         pQry.ParamByName('pd').Value:='11';
       'Lain-lain':
         pQry.ParamByName('pd').Value:='12';
      end;
   end;
   11: begin
      pQry.SQL.Text := 'update jemaat set pekerjaan=:pk where j_id=:hid';
      Pkj:=SG.Cells[aCol,aRow];
      Case Pkj of
       'Ibu RT':
         pQry.ParamByName('pk').Value:='1';
       'P.Negeri':
         pQry.ParamByName('pk').Value:='2';
       'P.Swasta':
         pQry.ParamByName('pk').Value:='3';
       'Pel/Mhs':
         pQry.ParamByName('pk').Value:='4';
       'Pensiunan':
         pQry.ParamByName('pk').Value:='5';
       'Petani':
         pQry.ParamByName('pk').Value:='6';
       'Profesional':
         pQry.ParamByName('pk').Value:='7';
       'Lain-lain':
         pQry.ParamByName('pk').Value:='8';
      end;
   end;
   12: begin
      pQry.SQL.Text := 'update jemaat set tg_update=:tu where j_id=:hid';
      pQry.ParamByName('tu').Value:=StrToDate(SG.Cells[aCol,aRow]);
   end;
  end;
  pQry.ParamByName('hid').Value:=SG.Cells[0,aRow];
  pQry.DataBase:=SCon;
  pQry.ExecSQL;
  STran.Commit;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

end.

