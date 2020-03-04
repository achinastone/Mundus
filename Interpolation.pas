unit Interpolation;

interface

uses
  Math3D;

function CalculateFactorA(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single; inline;
function CalculateFactorB(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single; inline;
function CalculateFactorC(const AVecA, AVecB, AVecC: TFloat4): Single; inline;
function CalculateFactorD(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single; inline;

implementation

//formulas
//FStepA := y1 * (r2 - r3) + y2 * (r3 - r1) + y3 * (r1 - r2);
//  FStepB := r1 * (x2 - x3) + r2 * (x3 - x1) + r3 * (x1 - x2);
//  FStepC := x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2);
//  FStepD := -(x1 * (y2 * r3 - y3 * r2) + x2 * (y3 * r1 - y1 * r3) + x3 * (y1 * r2 - y2 * r1));

function CalculateFactorA(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single;
begin
  Result := AvecA.Y*(AValB-AValC) + AVecB.Y*(AValC-AValA) + AVecC.Y*(AValA-AValB);
end;

function CalculateFactorB(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single;
begin
  Result := AValA*(AVecB.X-AvecC.X) + AValB*(AvecC.X - AvecA.X) + AValC*(AVecA.X-AvecB.X);
end;

function CalculateFactorC(const AVecA, AVecB, AVecC: TFloat4): Single;
begin
  Result := AvecA.X*(AVecB.Y - AvecC.Y) + AvecB.X*(AvecC.Y-AvecA.Y) + AvecC.X*(AvecA.Y - AvecB.Y);
end;

function CalculateFactorD(const AVecA, AVecB, AVecC: TFloat4; AValA, AValB, AValC: Single): Single;
begin
  Result := -(AVecA.X*(AVecB.Y*AValC - AvecC.Y*AValB) + AvecB.X*(AVecC.Y*AValA - AvecA.Y*AValC) + AVecC.X*(AVecA.Y*AValB - AVecB.Y*AValA));
end;

end.
