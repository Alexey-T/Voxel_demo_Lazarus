unit Unit1;

{$mode objfpc}{$H+}
{$R-}

{$DEFINE CODE1}
//CODE1..CODE2 have the same speed
//CODE3 is for Windows, 100x faster

interface

uses
  {$ifdef CODE3}Windows,{$endif}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, LCLProc;

type
  TLargeArray=array[0..65534] of byte;

type
  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Panel1Paint(Sender: TObject);
  private
    MP, Scr: TLargeArray;
    Dir, PosX, PosY: integer;
    bmp: TBitmap;
    Freq: Int64;
    {$ifdef CODE3}
    FreqSupported: Boolean;
    Header: Windows.PBitmapInfo;
    {$endif}
    procedure DoNext;
    procedure UpdateBitmap(C: TCanvas);
    procedure MyUpdateBitmap(C: TCanvas);
    procedure UpdateImage;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  SizeX=320;
  SizeY=200;

const
  pal:array[1..384] of byte=(
  0,0,0,48,48,48,1,0,43,1,3,43,2,5,44,2,7,44,3,9,45,4,11,46,5,13,47,6,15,48,
  7,17,49,8,19,50,9,21,51,10,22,52,11,24,52,12,26,54,13,28,54,14,30,56,15,32,
  56,16,34,58,17,34,58,17,36,58,18,38,60,19,40,60,20,42,62,21,44,62,10,31,0,
  11,31,0,11,31,1,11,32,1,12,32,1,12,32,2,12,33,2,13,33,2,14,33,3,15,33,3,15,
  34,3,15,34,4,15,35,4,16,35,4,16,35,5,16,36,5,17,36,5,17,36,6,18,37,6,18,38,
  7,19,38,8,20,39,8,20,40,9,21,40,10,22,41,10,22,42,11,23,42,12,24,43,12,24,
  44,13,25,44,14,25,45,14,26,46,15,27,46,16,27,47,17,28,47,18,28,48,19,29,49,
  19,30,49,20,30,50,21,31,51,21,32,51,22,32,52,23,33,53,23,34,53,24,34,54,25,
  35,55,25,36,55,26,36,56,27,37,57,27,38,57,27,39,57,27,41,57,27,42,57,27,43,
  57,27,44,57,27,45,57,27,46,57,27,47,57,27,49,57,27,50,57,27,51,57,27,52,57,
  27,53,57,27,55,57,27,56,57,27,57,57,27,58,57,27,58,57,26,58,57,25,58,57,24,
  58,56,23,58,55,22,58,54,20,58,53,19,58,51,18,58,50,17,58,50,16,58,49,15,58,
  48,14,58,47,13,58,46,12,58,45,11,58,44,11,58,44,10,58,43,10,58,42,9,57,41,
  8,57,40,8,56,39,7,56,38,6,55,37,5,55,35,4,54,33,4,54,31,2,32,32,32,63,63,63,
  63,63,63,63,63,63,63,63,63,48,48,48,63,63,63,63,63,63);

function ncol(mc,n,dvd:integer):integer;
var loc:integer;
begin
  loc:=(mc+n-random(2*n)) div dvd; ncol:=loc;
  if loc>250 then ncol:=250; if loc<5 then ncol:=5
end;

procedure plasma(x1,y1,x2,y2:word; var mp: TLargeArray);
var xn,yn,dxy,p1,p2,p3,p4:word;
begin
  if (x2-x1<2) and (y2-y1<2) then
   exit;
  p1:=mp[WORD(256*y1+x1)]; p2:=mp[WORD(256*y2+x1)]; p3:=mp[WORD(256*y1+x2)];
  p4:=mp[WORD(256*y2+x2)]; xn:=((x2+x1) shr 1) and $ffff; yn:=((y2+y1) shr 1) and $ffff;
  dxy:=5*(x2-x1+y2-y1) div 3;
  if mp[WORD(256*y1+xn)]=0 then mp[WORD(256*y1+xn)]:=ncol(p1+p3,dxy,2);
  if mp[WORD(256*yn+x1)]=0 then mp[WORD(256*yn+x1)]:=ncol(p1+p2,dxy,2);
  if mp[WORD(256*yn+x2)]=0 then mp[WORD(256*yn+x2)]:=ncol(p3+p4,dxy,2);
  if mp[WORD(256*y2+xn)]=0 then mp[WORD(256*y2+xn)]:=ncol(p2+p4,dxy,2);
  mp[WORD(word(256*yn)+xn)]:=ncol(word(p1+p2+p3+p4),word(dxy),4);
  plasma(x1,y1,xn,yn,mp); plasma(xn,y1,x2,yn,mp);
  plasma(x1,yn,xn,y2,mp); plasma(xn,yn,x2,y2,mp);
end;

procedure draw(xp,yp,dir:integer; var scr,mp: TLargeArray);
var
  z,zobs,ix,iy,iy1,iyp,ixp,x,y,s,csf,snf,mpc,i,j:integer;
  rng: array[0..320] of byte;
begin
  fillchar(rng,sizeof(rng),200); zobs:=100+mp[WORD(256*yp+xp)];
  csf:=round(256*cos((dir)/180*pi)); snf:=round(256*sin((dir)/180*pi));
  fillchar(scr,SizeOf(scr),0);
  for iy:=yp to yp+55 do
   begin
    iy1:=1+2*(iy-yp); s:=4+300 div iy1;
    for ix:=xp+yp-iy to xp-yp+iy do
     begin
      ixp:=xp+((ix-xp)*csf+(iy-yp)*snf) shr 8;
      iyp:=yp+((iy-yp)*csf-(ix-xp)*snf) shr 8;
      x:=160+360*(ix-xp) div iy1;
      if (x>=0) and (x+s<=318) then
       begin
        z:=mp[WORD(iyp shl 8+ixp)]; mpc:=z shr 1;
        if z<47 then z:=46;  y:=100+(zobs-z)*30 div iy1;
        if (y<=199) and (y>=0) then
         for j:=x to x+s do
          begin
           for i:=y to rng[j] do
            scr[WORD(320*i+j)]:=mpc;
           if y<rng[WORD(j)] then rng[WORD(j)]:=y
          end;
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  {$ifdef CODE3}
  QueryPerformanceFrequency(Freq);
  FreqSupported := Freq <> 0;
  if not FreqSupported then Freq := 1000;
  {$else}
  Freq:= 1000;
  {$endif}

  Randomize;
  PosX:=0;
  PosY:=0;
  Dir:=0;
  FillChar(MP,SizeOf(MP),0);
  MP[$0000]:=128;
  plasma(0,0,256,256,MP);

  {$IFDEF CODE1}
  bmp:= TBitmap.Create;
  bmp.SetSize(SizeX, SizeY);
  Panel1.Visible := True;
  {$ENDIF}

  {$IF defined(CODE2) or defined(CODE3)}
  Image1.Width:= SizeX;
  Image1.Height:= SizeY;
  Image1.Picture.Bitmap.Width := SizeX;
  Image1.Picture.Bitmap.Height := SizeY;
  Image1.Visible := True;
  {$IFEND}

  {$IFDEF CODE3}
  Header := GetMem(SizeOf(TBitmapInfoHeader) + (SizeOf(TRGBQuad) * 256));
  with Header^.bmiHeader do begin
     biSize := SizeOf(TBitmapInfoHeader);
     biWidth := SizeX;
     biHeight := -SizeY;
     biPlanes := 1;
     biBitCount := 8;
     biCompression := BI_RGB;
     biSizeImage := SizeX * SizeY;
     biXPelsPerMeter := 0;
     biYPelsPerMeter := 0;
     biClrUsed := 0;
     biClrImportant := 0;
 end;
  for I := 0 to ((SizeOf(pal) div 3) - 1) do begin
     with Header^.bmiColors[I] do begin
        rgbBlue := pal[I * 3 + 3] shl 2;
        rgbGreen := pal[I * 3 + 2] shl 2;
        rgbRed := pal[I * 3 + 1] shl 2;
     end
 end;
  {$ENDIF}

  ClientWidth:= SizeX;
  ClientHeight:= SizeY;

  {$IF defined(CODE2) or defined(CODE3)}
  UpdateImage;
  {$IFEND}
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  {$IFDEF CODE3}
  FreeMem(Header);
  {$ENDIF}
end;

procedure TForm1.UpdateBitmap(C: TCanvas);
var
  NColor, IndexPal: integer;
  ByteR, ByteG, ByteB: byte;
  i, j: integer;
begin
  draw(PosX,PosY,Dir,Scr,MP);
  for i:= 0 to SizeX-1 do
    for j:= 0 to SizeY-1 do
    begin
      NColor:= Scr[j*SizeX+i];
      IndexPal:= NColor*3;
      ByteB:= pal[IndexPal+1] shl 2;
      ByteG:= pal[IndexPal+2] shl 2;
      ByteR:= pal[IndexPal+3] shl 2;
      NColor:= (ByteR shl 16) + (ByteG shl 8) + ByteB;
      C.Pixels[i, j]:= NColor;
    end;
end;

procedure TForm1.MyUpdateBitmap(C: TCanvas);
begin
  {$ifdef CODE3}
  draw(PosX,PosY,Dir,Scr,MP);
  SetDIBitsToDevice(
    C.Handle,
    0,
    0,
    SizeX,
    SizeY,
    0,
    0,
    0,
    SizeY,
    @Scr,
    Header^,
    DIB_RGB_COLORS
  );
  {$endif}
end;

procedure TForm1.UpdateImage;
  var Tick, Tick2:Int64;
begin
  {$ifdef CODE3}
  if FreqSupported then begin
    QueryPerformanceCounter(Tick);
  end
  else begin
    Tick := GetTickCount64;
  end;
  {$else}
  Tick := GetTickCount64;
  {$endif}

  {$IFDEF CODE1}
  UpdateBitmap(bmp.Canvas);
  Panel1.Canvas.Draw(0, 0, bmp);
  {$ENDIF}

  {$IFDEF CODE2}
  Image1.Picture.Bitmap.BeginUpdate(True);
  UpdateBitmap(Image1.Picture.Bitmap.Canvas);
  Image1.Picture.Bitmap.EndUpdate;
  {$ENDIF}

  {$IFDEF CODE3}
  Image1.Picture.Bitmap.BeginUpdate(True);
  MyUpdateBitmap(Image1.Picture.Bitmap.Canvas);
  Image1.Picture.Bitmap.EndUpdate;
  {$ENDIF}

  {$ifdef CODE3}
  if FreqSupported then begin
     QueryPerformanceCounter(Tick2);
  end
  else begin
     Tick2 := GetTickCount64;
  end;
  {$else}
  Tick2 := GetTickCount64;
  {$endif}

  Caption := FloatToStr((Tick2 - Tick)*1000/Freq) + 'ms';
end;

procedure TForm1.DoNext;
begin
  {$IFDEF CODE1}
  Panel1.Repaint;
  {$ENDIF}
  {$IF defined(CODE2) or defined(CODE3)}
  UpdateImage;
  {$ENDIF}
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_LEFT) and (shift=[]) then
  begin
    dec(Dir,10);
    Dir:=Dir mod 360;
    key:= 0;
    DoNext;
    exit;
  end;

  if (Key=VK_RIGHT) and (shift=[]) then
  begin
    inc(Dir,10);
    Dir:=Dir mod 360;
    key:= 0;
    DoNext;
    exit;
  end;

  if (Key=VK_UP) and (shift=[]) then
  begin
    PosY:=PosY+round(5*cos((Dir)/180*pi));
    PosX:=PosX+round(5*sin((Dir)/180*pi));
    key:= 0;
    DoNext;
    exit;
  end;

  if (Key=VK_DOWN) and (shift=[]) then
  begin
    PosY:=PosY-round(5*cos((Dir)/180*pi));
    PosX:=PosX-round(5*sin((Dir)/180*pi));
    key:= 0;
    DoNext;
    exit;
  end;
end;

procedure TForm1.Panel1Paint(Sender: TObject);
begin
  UpdateImage;
end;

end.
