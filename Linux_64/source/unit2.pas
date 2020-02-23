unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
      ExtCtrls,  StdCtrls, DB, sqldb, sqlite3conn,
      Global;

type

  { TForm2 }

  TForm2 = class(TForm)
    Bulan: TComboBox;
    Gender: TComboBox;
    Ulang: TImage;
    Pendidikan: TComboBox;
    Edit13: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit9: TEdit;
    GD: TComboBox;
    Masuk: TImage;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Pekerjaan: TComboBox;
    Status: TComboBox;
    Tahun: TComboBox;
    Tanggal: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure UlangClick(Sender: TObject);
    procedure MasukClick(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure Simpan;
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  tgl: String;

begin
 SCon  := TSQLite3Connection.Create(nil);
 STran := TSQLTransaction.Create(SCon);
 SCon.Transaction := STran;
 SCon.DatabaseName:='jemaat.db';
 pQry := TSQLQuery.Create(nil);
 pQry.SQL.Text := 'insert into jemaat(no_anggota,nama,alamat,phone,gender,' +
 'go_darah,status,tempat_lahir,tanggal_lahir,pendidikan,pekerjaan,tg_update)' +
 'values(:no,:nm,:ala,:ph,:gd,:dr,:st,:kt,:tl,:pd,:pk,:tu)';
 pQry.ParamByName('no').Value:= Form2.Edit2.Text;
 pQry.ParamByName('nm').Value:= Form2.Edit3.Text;
 pQry.ParamByName('ala').Value:=Form2.Edit4.Text;
 pQry.ParamByName('ph').Value:=Form2.Edit5.Text;
 pQry.ParamByName('gd').Value:=Form2.Gender.Text;
 pQry.ParamByName('dr').Value:=Form2.GD.Text;
 pQry.ParamByName('st').Value:=Form2.Status.Text;
 pQry.ParamByName('kt').Value:=Form2.Edit9.Text;
 tgl:= Form2.Tahun.Text + '-' + Form2.Bulan.Text + '-' + Form2.Tanggal.Text;
 pQry.ParamByName('tl').Value:=tgl;
 tgl:=Form2.Pendidikan.Text;
 case tgl of
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
 tgl:=Form2.Pekerjaan.Text;
 case tgl of
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
 pQry.ParamByName('tu').Value:=StrToDate(Form2.Edit13.Text);
 pQry.DataBase:= SCon;
 pQry.ExecSQL;
 STran.Commit;
 pQry.Close;
 SCon.Close;
 pQry.Free;
 STran.Free;
 SCon.Free;
 end;
procedure TForm2.MasukClick(Sender: TObject);
begin
  if MessageDlg('Menyimpan data', 'Mau menyimpan data?', mtConfirmation,
    [mbYes, mbNo, mbIgnore],0) = mrYes
  then
    try
      Simpan;
    except
      ShowMessage('Ada yang belum diisi atau dipilih!');
   end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  i: Integer;
begin
  Edit13.Text:=hari;
  Gender.Items.Add('P');
  Gender.Items.Add('W');
  Status.Items.Add('B');
  Status.Items.Add('S');
  Status.Items.Add('-');
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  pQry.SQL.Text := 'select * from golongan_darah';
  pQry.DataBase:= Scon;
  pQry.Open;
  while not pQry.EOF do
  begin
    GD.Items.Add(pQry.FieldByName('golongan').AsString);
    pQry.Next;
  end;
  pQry.Close;
  pQry.SQL.Text := 'select * from pendidikan';
  pQry.Open;
  while not pQry.EOF do
  begin
    Pendidikan.Items.Add(pQry.FieldByName('pendidikan').AsString);
    pQry.Next;
  end;
  pQry.Close;
  pQry.SQL.Text := 'select * from pekerjaan';
  pQry.Open;
  while not pQry.EOF do
  begin
    Pekerjaan.Items.Add(pQry.FieldByName('pekerjaan').AsString);
    pQry.Next;
  end;
  pQry.Close;
  SCon.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
  i:=0;
  while i<31 do
  begin
    i:=i + 1;
    Tanggal.Items.Add(format('%.2d',[i]));
  end;
  i:=0;
  while i<12 do
  begin
    i:=i + 1;
    Bulan.Items.Add(format('%.2d',[i]));
  end;
  i:=1930;
  while i<2025 do
  begin
    i:=i + 1;
    Tahun.Items.Add(format('%.4s',[IntToStr(i)]));
  end;
end;

procedure TForm2.UlangClick(Sender: TObject);
begin
  Edit2.Text:= '';
  Edit3.Text:= '';
  Edit4.Text:= '';
  Edit9.Text:= '';
  Gender.Text:='Gender';
  GD.Text:='Gol_Darah';
  Status.Text:='Status';
  Pendidikan.Text:='Pendidikan';
  Pekerjaan.Text:='Pekerjaan';
  Tanggal.Text:='Tg';
  Bulan.Text:='Bl';
  Tahun.Text:='Tahun';
end;

end.

