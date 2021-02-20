
function edges = compareToExistingEdges( edges, i, j, tol )

% EDGES = compareToExistingEdges( EDGES, I, J, TOL )
%
% Loops over existing edges in EDGES to decide wether image element in
% position [ I, J ] belongs to any of them. If so, it is appended to the
% corresponding edge. A new edge is created otherwise. Returns updated
% EDGES collection.
%
% By ferranroigtio, Feb 19th 2021

new = true;
for p = 1 : length( edges )
    if abs( j - edges{ p }.cols( end ) ) <= tol
        edges{ p }.count = edges{ p }.count + 1;
        edges{ p }.rows( end + 1 ) = i;
        edges{ p }.cols( end + 1 ) = j;
        new = false;
        break
    end
end
if new
    pole.count = 1;
    pole.rows = i;
    pole.cols = j;
    edges{ end + 1 } = pole;
end
