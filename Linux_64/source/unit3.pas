unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
      ExtCtrls,  StdCtrls, DB, sqldb, sqlite3conn,
      Global;

type

  { TForm3 }

  TForm3 = class(TForm)
    Gender: TComboBox;
    GD: TComboBox;
    Status: TComboBox;
    Tanggal: TComboBox;
    Bulan: TComboBox;
    Tahun: TComboBox;
    Pendidikan: TComboBox;
    Pekerjaan: TComboBox;
    Edit1: TEdit;
    Edit13: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit9: TEdit;
    Simpan: TImage;
    Hapus: TImage;
    Panel1: TPanel;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HapusClick(Sender: TObject);
    procedure SimpanClick(Sender: TObject);
  private

  public
    ID3: Integer;
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure Ubah;
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  s: String;
begin
  SCon:= TSQLite3Connection.Create(nil);
  Stran:= TSQLTransaction.Create(SCon);
  SCon.Transaction:= STran;
  SCon.DatabaseName:='jemaat.db';
  pQry:= TSQLQuery.Create(nil);
  pQry.SQL.Text := 'update jemaat set no_anggota=:no, nama=:nm, ' +
        'alamat=:al, phone=:ph, gender=:gd, go_darah=:dr, ' +
        'status=:st, tempat_lahir=:kt, tanggal_lahir=:tl, ' +
        'pendidikan=:pd, pekerjaan=:pk, tg_update=:tu where j_id = :key';
  pQry.ParamByName('no').Value:=Form3.Edit2.Text;
  pQry.ParamByName('nm').Value:=Form3.Edit3.Text;
  pQry.ParamByName('al').Value:=Form3.Edit4.Text;
  pQry.ParamByName('ph').Value:=Form3.Edit5.Text;
  pQry.ParamByName('gd').Value:= Form3.Gender.Text;
  pQry.ParamByName('dr').Value:=Form3.GD.Text;
  pQry.ParamByName('st').Value:=Form3.Status.Text;
  pQry.ParamByName('kt').Value:=Form3.Edit9.Text;
  s:=Form3.Tahun.Text + '-' + Form3.Bulan.Text + '-' + Form3.Tanggal.Text;
  pQry.ParamByName('tl').Value:=s;
  s:=Form3.Pendidikan.Text;
  case s of
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
  s:=Form3.Pekerjaan.Text;
  case s of
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

  pQry.ParamByName('tu').Value:=StrToDate(Form3.Edit13.Text);
  pQry.ParamByName('key').Value:= Form3.ID3;
  pQry.DataBase:= SCon;
  Stran.StartTransaction;
  pQry.ExecSQL;
  Stran.Commit;
  pQry.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
  Form3.Close;
end;

procedure TForm3.FormShow(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  s: String;

begin
  Form3.Edit1.Text:= IntToStr(ID3);
  SCon  := TSQLite3Connection.Create(nil);
  STran := TSQLTransaction.Create(SCon);
  SCon.Transaction := STran;
  SCon.DatabaseName:='jemaat.db';
  pQry := TSQLQuery.Create(nil);
  pQry.SQL.Text := 'select * from jemaat where j_id=:key';
  pQry.ParamByName('key').Value:=ID3;
  pQry.Database := Scon;
  pQry.Open;
  Edit2.Text:=pQry.FieldByName('no_anggota').AsString;
  Edit3.Text:=pQry.FieldByName('nama').AsString;
  Edit4.Text:=pQry.FieldByName('alamat').AsString;
  Edit5.Text:=pQry.FieldByName('phone').AsString;
  s:=pQry.FieldByName('gender').AsString;
  Gender.Text:=s;
  s:=pQry.FieldByName('go_darah').AsString;
  GD.Text:=s;
  Status.Text:=pQry.FieldByName('status').AsString;
  Edit9.Text:=pQry.FieldByName('tempat_lahir').AsString;
  s:=CHari(pQry.FieldByName('tanggal_lahir').AsDateTime);
  Tahun.Text:=copy(s,7,4);
  Bulan.Text:=copy(s,4,2);
  Tanggal.Text:=copy(s,1,2);
  s:= pQry.FieldByName('pendidikan').AsString;
  case s of
    '1':
      Pendidikan.Text:='D1';
    '2':
      Pendidikan.Text:='D2';
    '3':
      Pendidikan.Text:='D3';
    '4':
      Pendidikan.Text:='Kejuruan';
    '5':
      Pendidikan.Text:='S1';
    '6':
      Pendidikan.Text:='S2';
    '7':
      Pendidikan.Text:='S3';
    '8':
      Pendidikan.Text:='SD';
    '9':
      Pendidikan.Text:='SLTP';
    '10':
      Pendidikan.Text:='SMU';
    '11':
      Pendidikan.Text:='TK';
    '12':
      Pendidikan.Text:='Lain-lain';
  end;
  s:= pQry.FieldByName('pekerjaan').AsString;
  case s of
    '1':
      Pekerjaan.Text:='Ibu RT';
    '2':
      Pekerjaan.Text:='P.Negeri';
    '3':
      Pekerjaan.Text:='P.Swasta';
    '4':
      Pekerjaan.Text:='Pel/Mhs';
    '5':
      Pekerjaan.Text:='Pensiunan';
    '6':
      Pekerjaan.Text:='Petani';
    '7':
      Pekerjaan.Text:='Profesional';
    '8':
      Pekerjaan.Text:='Lain-lain';
  end;
  Edit13.Text:=CHari(pQry.FieldByName('tg_update').AsDateTime);
  pQry.Close;
  pQry.Free;
  STran.Free;
  SCon.Free;
end;

procedure TForm3.HapusClick(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;

begin
  if MessageDlg('Menghapus data', 'Mau menghapus data?', mtConfirmation,
  [mbYes, mbNo, mbIgnore],0) = mrYes
  then
   begin
     SCon  := TSQLite3Connection.Create(nil);
     STran := TSQLTransaction.Create(SCon);
     SCon.Transaction := STran;
     SCon.DatabaseName:='jemaat.db';
     pQry := TSQLQuery.Create(nil);
     pQry.SQL.Text := 'delete from jemaat where j_id=:key';
     pQry.ParamByName('key').Value:=ID3;
     pQry.DataBase:= SCon;
     Stran.StartTransaction;
     pQry.ExecSQL;
     Stran.Commit;
     pQry.Close;
     pQry.Free;
     STran.Free;
     SCon.Free;
     Form3.Close;
   end;
end;

procedure TForm3.SimpanClick(Sender: TObject);
begin
  if MessageDlg('Mengubah data', 'Mau mengubah data?', mtConfirmation,
  [mbYes, mbNo, mbIgnore],0) = mrYes
  then
    try
      Ubah;
    except
      ShowMessage('Ada yang salah, coba periksa!');
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  SCon : TSQLConnection;
  STran: TSQLTransaction;
  pQry : TSQLQuery;
  i: Integer;
begin
  Form3.Edit13.Text:= hari;
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

end.

