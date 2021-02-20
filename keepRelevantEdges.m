
function relEdges = keepRelevantEdges( relEdges, bigEdge, tol, minLen )

% RELEDGES = keepRelevantEdges( RELEDGES, BIGEDGE, TOL, MINLEN )
%
% Loops through an edge BIGEDGE and discards isolated points, separated
% from adjacent point by more than TOL pixels. Continuous subedges may be
% discarted too if their length is less than MINLEN.
%
% Returns the updated RELEDGES collection with information to be treated in
% the main function findH.m.
%
% By ferranroigtio, Feb 19th 2021

smallEdge.numberOfEdges = 0;
smallEdge.chain = 0;
for i = 2 : bigEdge.count
    cond1 = abs( bigEdge.rows( i ) - bigEdge.rows( i - 1 ) ) > tol;
    cond2 = abs( bigEdge.cols( i ) - bigEdge.cols( i - 1 ) ) > tol;
    tooFar = cond1 || cond2;
    if tooFar
        smallEdge.chain = 0;
    else
        smallEdge.chain = smallEdge.chain + 1;
        smallEdge.lastRow = bigEdge.rows( i );
        smallEdge.lastCol = bigEdge.cols( i );
        if smallEdge.chain == minLen
            smallEdge.numberOfEdges = smallEdge.numberOfEdges + 1;
            smallEdge.firstRow = bigEdge.rows( i - smallEdge.chain + 1 );
            smallEdge.firstCol = bigEdge.cols( i - smallEdge.chain + 1 );
        end
    end
end

if smallEdge.numberOfEdges > 0
    smallEdge.slope = ( smallEdge.lastCol - smallEdge.firstCol ) / ( smallEdge.lastRow - smallEdge.firstCol );
end

relEdges{ end + 1 } = smallEdge;
