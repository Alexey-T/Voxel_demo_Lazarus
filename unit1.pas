unit Unit1;

{$mode objfpc}{$H+}
{$R-}

interface

{
  CODE1 = Bitmap.Canvas
  CODE2 = Panel.Canvas
  CODE3 = Windows native
  CODE4 = BGRABitmap (https://github.com/bgrabitmap/bgrabitmap)
  CODE5 = IntfImage
  CODE6 = BZScene (https://github.com/jdelauney/BZScene)

--------------------------------------------------------------------------------

  Average frame rate in ms, benchmark template
 ______________________________________________________________________________
 |  CPU     :                                                                 |
 |  OS      :                                                                 |
 |  FPC     :                                                                 |
 |  LAZARUS :                                                                 |
 |____________________________________________________________________________|
 |  MEHTOD |  CODE 1  |  CODE 2  |  CODE 3  |  CODE 4  |  CODE 5  |  CODE 6   |
 |=========|==========|==========|==========|==========|==========|===========|
 |  Debug  |          |          |          |          |          |           |
 |---------|----------|----------|----------|----------|----------|-----------|
 | Release |          |          |          |          |          |           |
 |----------------------------------------------------------------------------|

--------------------------------------------------------------------------------
                                 BeanzMaster
 ______________________________________________________________________________
 |  CPU     : AMD A10-7870K Radeon R7, 12 Compute Cores 4C+8G                 |
 |  OS      : Windows 10 64bit                                                |
 |  FPC     : 3.2.0                                                           |
 |  LAZARUS : 2.0.10                                                          |
 |____________________________________________________________________________|
 |  MEHTOD |  CODE 1  |  CODE 2  |  CODE 3  |  CODE 4  |  CODE 5  |  CODE 6   |
 |=========|==========|==========|==========|==========|==========|===========|
 |  Debug  | 39,9572  | 686,1903 |  0,5434  |  1,2037  |  1,5852  |  0,8171   |
 |---------|----------|----------|----------|----------|----------|-----------|
 | Release | 38,7973  | 671,5684 |  0,4201  |  1,0717  |  1,3234  |  0,7014   |
 |----------------------------------------------------------------------------|

 ______________________________________________________________________________
 |  CPU     : AMD A10-7870K Radeon R7, 12 Compute Cores 4C+8G                 |
 |  OS      : Linux Manjaro 64bit                                             |
 |  FPC     : 3.2.0                                                           |
 |  LAZARUS : 2.0.10                                                          |
 |____________________________________________________________________________|
 |  MEHTOD |  CODE 1  |  CODE 2  |  CODE 3  |  CODE 4  |  CODE 5  |  CODE 6   |
 |=========|==========|==========|==========|==========|==========|===========|
 |  Debug  | 11,2772  |  35,1391 |   N/A    |  2,3768  |  3,1898  |  2,1478   |
 |---------|----------|----------|----------|----------|----------|-----------|
 | Release | 11,2917  |  37,6608 |   N/A    |  2,1562  |  2,7684  |  2,0740   |
 |----------------------------------------------------------------------------|

--------------------------------------------------------------------------------
}

{$DEFINE CODE1}

uses
  {$IFDEF WINDOWS}Windows, {$ENDIF}Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, LCLProc
  {$IFDEF CODE4}, BGRABitmap, BGRABitmapTypes{$ENDIF}
  {$IFDEF CODE5}, IntfGraphics, GraphType{$ENDIF}
  {$IFDEF CODE6}, BZColors, BZGraphic, BZBitmap{$ENDIF};


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

type
  TLargeArray=array[0..65535] of byte;

type
  { TForm1 }

  TForm1 = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
		procedure Panel1Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    MP, Scr: TLargeArray;
    Dir, PosX, PosY: integer;


    FrameCounter, Freq : Int64;
    TotalTime : Double;

    voxdep : array[1..689] of char;
    cDep : Integer;
    SinMoveLut, CosMoveLUT : Array[-360..360] of integer;
    SinLut256, CosLut256 : Array[-360..360] of integer;

    {$IF defined(CODE1) or defined(CODE2)}
      palColor: array[1..length(pal) div 3] of TColor;
    {$ENDIF}

    {$IF defined(CODE1) or defined(CODE3) or defined(CODE5)}
    bmp: TBitmap;
    {$ENDIF}

    {$IFDEF CODE3}
    Header:Windows.PBitmapInfo;
    {$ENDIF}

    {$IFDEF CODE4}
    bgra:TBGRABitmap;
    palBGRA: array[1..length(pal) div 3] of TBGRAPixel;
    {$ENDIF}

    {$IFDEF CODE5}
    IntfImage:TLazIntfImage;
    palIntf: array[1..length(pal) div 3] of Longword;
    {$ENDIF}

    {$IFDEF CODE6}
    bzBmp:TBZBitmap;
    palBZScene: array[1..length(pal) div 3] of TBZColor;
    {$ENDIF}


    procedure DrawVoxel(xp, yp, aDir:integer; var map: TLargeArray);

    {$IF defined(CODE1) or defined(CODE2)}
    procedure UpdateBitmap;
    {$ENDIF}

    {$IFDEF CODE3}
    procedure MyUpdateBitmap(C: TCanvas);
    {$ENDIF}

    {$IFDEF CODE4}
    procedure MyUpdateBitmap2(C: TCanvas);
    {$ENDIF}

    {$IFDEF CODE5}
    procedure MyUpdateBitmap3(C: TCanvas);
    {$ENDIF}

    {$IFDEF CODE6}
    procedure MyUpdateBitmap4(C: TCanvas);
    {$ENDIF}

    procedure UpdateImage;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}





function GetFreq:Int64;
begin
  Result := 1000;
  {$IFDEF WINDOWS}
  if not QueryPerformanceFrequency(Result) or (Result = 0) then Result := 1000;
  {$ENDIF}
end;

function GetCounter:Int64;
begin
  Result := 0;
  {$IFDEF WINDOWS}
  if not QueryPerformanceFrequency(Result) or (Result = 0) then begin
  {$ENDIF}
    Result := GetTickCount64;
  {$IFDEF WINDOWS}
	end
	else begin
    QueryPerformanceCounter(Result);
  end;
  {$ENDIF}
end;

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

procedure TForm1.DrawVoxel(xp, yp, aDir:integer; var map: TLargeArray);
var
  z,zobs,ix,iy,iy1,iyp,ixp,x,y,s,csf,snf,mpc,i,j, dpiy, dpix :integer;
  rng: array[0..320] of byte;
begin
  fillchar(rng,sizeof(rng),200);
  zobs := 100 + map[WORD(yp shl 8 + xp)];
  csf := CosLUT256[aDir];
  snf := SinLUT256[aDir];

  {$IFDEF CODE1}
  With bmp.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Rectangle(0,0,SizeX - 1, SizeY -1);
  end;
  {$ENDIF}

  {$IF defined(CODE2) or defined(CODE3) or defined(CODE5)}
  fillchar(scr,SizeOf(scr),0);
  {$ENDIF}

  {$IFDEF CODE4}
  bgra.Fill(BGRABlack);
  {$ENDIF}

  {$IFDEF CODE6}
  bzBmp.Clear(clrBlack);
  {$ENDIF}

  for iy:=yp to yp+55 do
   begin
    dpiy := (iy-yp);
    iy1 := 1 + (dpiy + dpiy);
    s := 4 + 300 div iy1;
    for ix := (xp + yp - iy) to (xp - yp + iy) do
    begin
      dpix := (ix-xp);
      ixp := xp + (dpix * csf + dpiy * snf) shr 8;
      iyp := yp + (dpiy * csf - dpix * snf) shr 8;
      x := 160 + 360 * dpix div iy1;
      if (x>=0) and (x+s<=318) then
       begin
        z := map[WORD(iyp shl 8 + ixp)];
        mpc:=z shr 1;
        if (z<47) then z:=46;
        y := 100 + (zobs-z)*30 div iy1;
        if (y<=199) and (y>=0) then
        begin
          for i := x to x+s do
          begin
            for j:=y to rng[i] do
            begin
              {$IFDEF CODE1}
                bmp.Canvas.Pixels[i, j] := palColor[mpc];
              {$ENDIF}

              {$IF Defined(CODE2) or Defined(CODE3) or Defined(CODE5)}
                scr[WORD(320 * j + i)] := mpc; // calcul of offset can be improve with two SHL
              {$ENDIF}

              {$IFDEF CODE4}
                bgra.DrawPixel(i,j, palBgra[mpc]);
              {$ENDIF}

              {$IFDEF CODE6}
                bzBmp.SetPixel(i, j, palBZScene[mpc]);
              {$ENDIF}
            end;
            if (y < rng[WORD(i)]) then rng[WORD(i)] := y;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I:Integer;
  {$IFDEF CODE5}
  lRawImage: TRawImage;
  {$ENDIF}

  {$IF defined(CODE1) or defined(CODE2)}
  procedure ComputePalColor;
  var
    IndexPal, NColor: Integer;
    ByteB, ByteG, ByteR: Byte;
  begin
    for NColor := 1 to length(palColor) do
    begin
      IndexPal:= NColor*3;
      ByteR:= (pal[IndexPal+1] shl 2) + (pal[IndexPal+1] shr 4);
      ByteG:= (pal[IndexPal+2] shl 2) + (pal[IndexPal+2] shr 4);
      ByteB:= (pal[IndexPal+3] shl 2) + (pal[IndexPal+3] shr 4);
      palColor[NColor]:= (ByteB shl 16) + (ByteG shl 8) + ByteR;
    end;
  end;
  {$ENDIF}

  {$IFDEF CODE4}
  procedure ComputePalBGRA;
  var
    IndexPal, NColor: Integer;
    ByteB, ByteG, ByteR: Byte;
  begin
    for NColor := 1 to length(palBGRA) do
    begin
      IndexPal:= NColor*3;
      ByteR:= (pal[IndexPal+1] shl 2) + (pal[IndexPal+1] shr 4);
      ByteG:= (pal[IndexPal+2] shl 2) + (pal[IndexPal+2] shr 4);
      ByteB:= (pal[IndexPal+3] shl 2) + (pal[IndexPal+3] shr 4);
      palBGRA[NColor]:= BGRABitmapTypes.BGRA(ByteR, ByteG, ByteB);
    end;
  end;
  {$ENDIF}

  {$IFDEF CODE5}
  procedure ComputePalIntf;
  var
    IndexPal, NColor: Integer;
    ByteB, ByteG, ByteR: Byte;
  begin
    for NColor := 1 to length(palIntf) do
    begin
      IndexPal:= NColor*3;
      ByteR:= (pal[IndexPal+1] shl 2) + (pal[IndexPal+1] shr 4);
      ByteG:= (pal[IndexPal+2] shl 2) + (pal[IndexPal+2] shr 4);
      ByteB:= (pal[IndexPal+3] shl 2) + (pal[IndexPal+3] shr 4);

      if IntfImage.DataDescription.ByteOrder = riboLSBFirst then
        palIntf[NColor]:= NtoLE(LongWord((ByteR shl IntfImage.DataDescription.RedShift) +
                          (ByteG shl IntfImage.DataDescription.GreenShift) +
                          (ByteB shl IntfImage.DataDescription.BlueShift) +
                          (255 shl IntfImage.DataDescription.AlphaShift)))
      else
        palIntf[NColor]:= NtoBE(LongWord((ByteR shl IntfImage.DataDescription.RedShift) +
                          (ByteG shl IntfImage.DataDescription.GreenShift) +
                          (ByteB shl IntfImage.DataDescription.BlueShift) +
                          (255 shl IntfImage.DataDescription.AlphaShift)));
    end;
  end;
  {$ENDIF}

  {$IFDEF CODE6}
  procedure ComputePalBZScene;
  var
    IndexPal, NColor: Integer;
    ByteB, ByteG, ByteR: Byte;
  begin
    for NColor := 1 to length(palBZScene) do
    begin
      IndexPal:= NColor*3;
      ByteR:= (pal[IndexPal+1] shl 2) + (pal[IndexPal+1] shr 4);
      ByteG:= (pal[IndexPal+2] shl 2) + (pal[IndexPal+2] shr 4);
      ByteB:= (pal[IndexPal+3] shl 2) + (pal[IndexPal+3] shr 4);
      palBZScene[NColor]:= BZColor(ByteR, ByteG, ByteB);
    end;
  end;
  {$ENDIF}

  {$IFDEF CODE3}
  procedure PrepareBitmapHeader;
  var I: integer;
  begin
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
  end;
  {$ENDIF}

begin
  Freq := GetFreq;

  for i:=-360 to 360 do
  begin
    CosMoveLUT[I] := round(5 * System.Sin((Dir)/180*pi));
    SinMoveLUT[I] := round(5 * System.Cos((Dir)/180*pi));
  End;

  for i:=-360 to 360 do
  begin
    SinLUT256[I] := round(256 * System.Sin(I / 180 * pi));
    CosLUT256[I] := round(256 * System.Cos(I / 180 * pi));
  End;

  //Randomize;
  RandSeed := 1234567; // To generate always the same landscape for comparing each method

  // Construct a travel way
  for i:=1 to 100 do voxDep[i]:=#72;
  for i:=101 to 130 do voxDep[i]:=#76;
  for i:=131 to 231 do voxDep[i]:=#72;
  for i:=232 to 267 do voxDep[i]:=#78;
  for i:=268 to 367 do voxDep[i]:=#75;
  for i:=368 to 450 do voxDep[i]:=#72;
  for i:=451 to 530 do voxDep[i]:=#77;
  for i:=531 to 688 do voxDep[i]:=#80;
  voxDep[689]:=#32; // Stop
  cDep:=0;

  PosX:=0;
  PosY:=0;
  Dir:=0;

  FillChar(MP,SizeOf(MP),0);
  MP[$0000]:=128;
  plasma(0,0,256,256,MP);

  {$IF defined(CODE1) or defined(CODE3) or defined(CODE5)}
  bmp:= TBitmap.Create;
  {$ENDIF}
  
  {$IF defined(CODE1) or defined(CODE3)}
  bmp.SetSize(SizeX, SizeY);
  {$ENDIF}

  {$IF defined(CODE1) or defined(CODE2)}
  ComputePalColor;
  {$ENDIF}

  {$IFDEF CODE4}
  bgra := TBGRABitmap.Create(SizeX, SizeY, BGRABlack);
  ComputePalBGRA;
  {$ENDIF}

  {$IFDEF CODE3}
  PrepareBitmapHeader;
  {$ENDIF}

  {$IFDEF CODE5}
  IntfImage := TLazIntfImage.Create(SizeX, SizeY, [riqfRGB, riqfAlpha]);
  IntfImage.CreateData;
  //lRawImage.Init;
  //  {$IFDEF WINDOWS}
  //    lRawImage.Description.Init_BPP32_B8G8R8A8_BIO_TTB(SizeX, SizeY);
  //  {$ELSE}
  //    lRawImage.Description.Init_BPP32_R8G8B8A8_BIO_TTB(SizeX, SizeY);
  //  {$ENDIF}
  //lRawImage.CreateData(True);
  //
  //IntfImage := TLazIntfImage.Create(0,0);
  //IntfImage.SetRawImage(lRawImage);

  ComputePalIntf;
  {$ENDIF}

  {$IFDEF CODE6}
  bzBmp := TBZBitmap.Create(SizeX, SizeY, clrBlack);
  ComputePalBZScene;
  {$ENDIF}

  ClientWidth:= SizeX;
  ClientHeight:= SizeY;
  TotalTime := 0;
  FrameCounter := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  {$IF defined(CODE1) or defined(CODE3) or defined(CODE5)}
  bmp.Free;
  {$ENDIF}
  {$IFDEF CODE3}
  FreeMem(Header);
  {$ENDIF}
  {$IFDEF CODE4}
  bgra.Free;
  {$ENDIF}
  {$IFDEF CODE5}
  IntfImage.Free;
  {$ENDIF}
  {$IFDEF CODE6}
  FreeAndNil(bzBmp);
  {$ENDIF}
end;

{$IF defined(CODE1) or defined(CODE2)}
procedure TForm1.UpdateBitmap;
{$IFDEF CODE2}
var
  i, j: integer;
  Src: PByte;
{$ENDIF}
begin
  {$IFDEF CODE1}
  bmp.BeginUpdate(true);
  {$ENDIF}
  drawVoxel(PosX,PosY,Dir,MP);
  {$IFDEF CODE1}
  bmp.EndUpdate();
  {$ENDIF}

  {$IFDEF CODE2}
  Src := @Scr;
  for j:= 0 to SizeY-1 do
  begin
    for i:= 0 to SizeX-1 do
    begin
      Panel1.Canvas.Pixels[i, j]:= palColor[Src^];
      inc(Src);
    end;
  end;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF CODE3}
procedure TForm1.MyUpdateBitmap(C: TCanvas);
begin
  drawVoxel(PosX,PosY,Dir,MP);
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
end;
{$ENDIF}

{$IFDEF CODE4}
procedure TForm1.MyUpdateBitmap2(C: TCanvas);
begin
  drawVoxel(PosX,PosY,Dir,MP);
  bgra.Draw(C, 0, 0);
end;
{$IFEND}

{$IFDEF CODE5}
procedure TForm1.MyUpdateBitmap3(C: TCanvas);
var
  i, j: integer;
  Src:PByte;
  Dest:PLongword;
  //Bitmap, Mask:HBITMAP;
begin

  drawVoxel(PosX,PosY,Dir,MP);

  IntfImage.BeginUpdate;
  Dest := PLongword(IntfImage.PixelData);
  Src := @Scr;
  for i:= 0 to SizeY-1 do
  begin
    for j:= 0 to SizeX-1 do
    begin
      Dest^ := palIntf[Src^];
      Inc(Src);
      Inc(Dest);
    end;
  end;
  IntfImage.EndUpdate;

  //IntfImage.CreateBitmaps(Bitmap, Mask, True);
  //Bmp.Handle := Bitmap;
  //bmp.MaskHandle := Mask;

  bmp.LoadFromIntfImage(IntfImage);

  // Need to clear background canvas
  With C do
  begin
    Brush.Style := bsSolid;
    Brush.Color := clBlack;
    Rectangle(0,0,SizeX - 1, SizeY -1);
  end;

  C.Draw(0, 0, bmp);
end;
{$IFEND}

{$IFDEF CODE6}
procedure TForm1.MyUpdateBitmap4(C: TCanvas);
begin
  drawVoxel(PosX,PosY,Dir,MP);
  bzBmp.DrawToCanvas(C, Panel1.ClientRect);
end;
{$IFEND}

procedure TForm1.UpdateImage;
var
  Tick:Int64;
  d : Double;
begin
  Tick := GetCounter;
  {$IFDEF CODE1}
  UpdateBitmap;
  Panel1.Canvas.Draw(0, 0, bmp);
  {$ENDIF}

  {$IFDEF CODE2}
  UpdateBitmap;
  {$ENDIF}

  {$IFDEF CODE3}
  MyUpdateBitmap(Panel1.Canvas);
  {$ENDIF}

  {$IFDEF CODE4}
  MyUpdateBitmap2(Panel1.Canvas);
  {$ENDIF}

  {$IFDEF CODE5}
  //Panel1.Canvas.Clear;
  MyUpdateBitmap3(Panel1.Canvas);
  {$ENDIF}

  {$IFDEF CODE6}
  MyUpdateBitmap4(Panel1.Canvas);
  {$ENDIF}

  d := (GetCounter - Tick) * 1000 / Freq;
  TotalTime := TotalTime + d;
  inc(FrameCounter);
  Caption := FloatToStr(d) + 'ms';
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (shift=[ssShift]) then
  begin
    dec(Dir,10);
    Dir := Dir mod 360;
    PosY := PosY - CosMoveLUT[Dir];
    PosX := PosX - SinMoveLUT[Dir];
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

  if (shift=[ssCtrl]) then
  begin
    inc(Dir,10);
    Dir := Dir mod 360;
    PosY := PosY + CosMoveLUT[Dir];
    PosX := PosX + SinMoveLUT[Dir];
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

  if (Key=VK_UP) and (shift=[]) then
  begin
    PosY := PosY + 5;
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

  if (Key=VK_DOWN) and (shift=[]) then
  begin
    PosY := PosY - 5;
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

  if (Key=VK_LEFT) and (shift=[]) then
  begin
    PosX := PosX - 5;
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

  if (Key=VK_RIGHT) and (shift=[]) then
  begin
    PosX := PosX + 5;
    key:= 0;
    Panel1.Repaint;
    exit;
  end;

end;

procedure TForm1.Panel1Paint(Sender: TObject);
begin
  UpdateImage;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Dep : Char;
Begin
  Dir := Dir mod 360;
  {$if not(defined(CODE1)) and not(Defined(CODE6))}
     UpdateImage;
  {$ELSE}
    Panel1.Repaint;
  {$ENDIF}
  inc(cdep);
  Dep := voxDep[cDep];
  Case Dep of
    #75:
    begin
      Dec(Dir,5);
    End;
    #77:
    begin
      Inc(Dir,5);
    End;
    #76:
    begin
      Dec(Dir,5);
      PosY := PosY + CosMoveLUT[Dir];
      PosX := PosX + SinMoveLUT[Dir];
    End;
    #78 :
    begin
      Inc(Dir,5);
      PosY := PosY + CosMoveLUT[Dir];
      PosX := PosX + SinMoveLUT[Dir];
    End;
    #72 :
    begin
      PosY := PosY + CosMoveLUT[Dir];
      PosX := PosX + SinMoveLUT[Dir];
    End;
    #80 :
    begin
      PosY := PosY - CosMoveLUT[Dir];
      PosX := PosX - SinMoveLUT[Dir];
    End;
    #32:
    begin
      Timer1.Enabled := false;
      ShowMessage('Average Frame speed : ' + FloatToStr(TotalTime / FrameCounter) + ' ms');
    End;
  End;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if UpCase(Key) = 'A' then
  begin
    Timer1.Enabled := not(Timer1.Enabled);
  end;
end;

end.


