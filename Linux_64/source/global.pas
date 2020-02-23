unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function hari: String;
function CHari(Waktu: TDateTime): String;

implementation

function hari: String;
var
 YY,MM,DD: Word;
begin
  DecodeDate(Date,YY,MM,DD);
  hari:= format('%.2d-%.2d-%d',[dd,mm,yy]);
end;
//convert date to spesial format string
function CHari(Waktu: TDateTime): String;
var
  YY,MM,DD: Word;
  begin
   DecodeDate(Waktu,YY,MM,DD);
   CHari:= format('%.2d-%.2d-%d',[dd,mm,yy]);
  end;
end.

