unit Shader;

interface

uses
  Classes, Types, Graphics, ColorTypes, Math3D, RenderTypes;

type

  TPointF = record
    X: Single;
    Y: Single;
  end;

  TVertexShaderInput = record
    VertexID: Integer;
  end;

  TShader = class(TObject)
  private
    FPixelBuffer: TBitmap;
    FPixel: TPoint;
    FLineLength: Integer;
    FFirstLine: PRGB32Array;
    FMinX: Cardinal;
    FMinY: Cardinal;
    procedure SetPixelBuffer(const Value: TBitmap);
  public
    constructor Create(); virtual;
    procedure VertexShader(const AWorld, AProjection: TMatrix4x4; var AVertex: TFloat4; const AVInput: TVertexShaderInput; const AAttributeBuffer: Pointer); virtual; abstract;
    procedure Shade8X8Quad(); virtual; abstract;
    procedure ShadeSinglePixel(); virtual; abstract;
//    procedure InitTriangle(AVecA, AVecB, AVecC: TFloat4); virtual; abstract;
    class function GetRasterizer: TRasterizer; virtual; abstract;
    class function GetAttributeBufferSize: Integer; virtual; abstract;
    property Pixel: TPoint read FPixel write FPixel;
    property LineLength: Integer read FLineLength;
    property FirstLine: PRGB32Array read FFirstLine;
    property MinX: Cardinal read FMinX write FMinX;
    property MinY: Cardinal read FMinY write FMinY;
    property PixelBuffer: TBitmap read FPixelBuffer write SetPixelBuffer;
  end;

  TShader<T: record> = class(TShader)
  public
    type
      PAttributeType = ^T;
    class function GetRasterizer: TRasterizer; override;
    class function GetAttributeBufferSize: Integer; override;
    procedure VertexShader(const AWorld, AProjection: TMatrix4x4; var AVertex: TFloat4; const AVInput: TVertexShaderInput; const AAttributeBuffer: Pointer); override;
    procedure Vertex(const AWorld, AProjection: TMatrix4x4; var AVertex: TFloat4; const AVInput: TVertexShaderInput; const AAttributeBuffer: PAttributeType); virtual;
    procedure Fragment(X, Y: Integer; const PSInput: PAttributeType); virtual; abstract;
  end;

  TShaderClass = class of TShader;

  function PointF(X, Y: Single): TPointF;

implementation

uses
  Rasterizer;

function PointF(X, Y: Single): TPointF;
begin
  Result.X := X;
  Result.Y := Y;
end;

{ TShader }

constructor TShader.Create();
begin
  inherited;
end;

procedure TShader.SetPixelBuffer(const Value: TBitmap);
begin
  FPixelBuffer := Value;
  if Assigned(FPixelBuffer) then
  begin
    FFirstLine := FPixelBuffer.ScanLine[0];
    FLineLength := (LongInt(FPixelBuffer.Scanline[1]) - LongInt(FFirstLine)) div SizeOf(TRGB32);
  end;
end;

{ TSHader<T> }

class function TShader<T>.GetAttributeBufferSize: Integer;
begin
  Result := SizeOf(T);
end;

class function TShader<T>.GetRasterizer: TRasterizer;
begin
  Result := TRasterizer(@TRasterizerFactory.RasterizeTriangle<T, TShader<T>>);
end;

procedure TShader<T>.Vertex(const AWorld, AProjection: TMatrix4x4; var AVertex: TFloat4; const AVInput: TVertexShaderInput; const AAttributeBuffer: PAttributeType);
begin
  AVertex := AProjection.Transform(AVertex);
end;

procedure TShader<T>.VertexShader(const AWorld, AProjection: TMatrix4x4; var AVertex: TFloat4; const AVInput: TVertexShaderInput; const AAttributeBuffer: Pointer);
begin
  Vertex(AWorld, AProjection, AVertex, AVInput, AAttributeBuffer);
end;

end.
