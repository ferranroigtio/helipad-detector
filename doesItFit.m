
function res = doesItFit( mat, row, col, len )

% RES = doesItFit( MAT, ROW, COL, LEN )
%
% Returns RES = true if a square of size 2 * LEN + 1 centered at
% MAT( ROW, COL ) contains only ones. Returns RES = false otherwise.
%
% By ferranroigtio, Feb 19th 2021

sec = mat( row - len : row + len, col - len : col + len );
ref = ones( 2 * len + 1 );

if isequal( sec, ref )
    res = true;
else
    res = false;
end
