
function res = findH( img, mode )

% RES = findH( IMG, MODE )
%
% Given an image IMG, returns RES = true if an 'H' pattern is recognized in
% the image. Returns RES = false otherwise.
%
% An additional MODE parameter is required. It refers to the expected
% colour of the 'H' pattern, either 'white' or 'black'.
%
% It has some limitations, listed below
%   Target 'H' must be either white or black
%   Target 'H' must be filled homogeneously
%   Brighter or darker objects in the background may confuse the code
%
% By ferranroigtio, Feb 19th 2021

%% Initialization

% Control parameters
factorForHIsolation = 0.4; % (Between 0 and 1) 0 is most restrictive, 1 is least restrictive
factorForFineTuning = 1 / 50; % (Between 0 and 1) 0 is least restrictive, 1 is most restrictive
tolForEdgeDefinition = 5; % Maximum number of pixels that elements in the same edge are allowed apart. Reduce for increased constraint
edgeFraction = 1 / 8; % (Between 0 and 1) Minimum length of edge as fraction of image size. Decrease to filter shorter edges
slopeTolerance = 1e-1; % Tolerance to consider equal edge slope

% Return false unless pattern found
res = false;

%% Image analysis

origImg = imread( img ); % Read image
reading = rgb2gray( origImg ); % Convert to black and white
if strcmp( mode, 'black' )
    reading = 255 - reading; % If MODE = 'black', work with negative of image
elseif ~strcmp( mode, 'white' )
    error( 'Unexpected MODE value, should be either ''white'' or ''black''.' )
end
[ rows, cols ] = size( reading );

% 'H' isolation logic
% It assumes 'H' is at the highest extreme in the colour scale
hColour = max( max( reading ) );
hThreshold = hColour - ( hColour - mean( mean( reading ) ) ) * factorForHIsolation;
mask = uint8( zeros( rows, cols ) );
for i = 1 : rows
    for j = 1 : cols
        if reading( i, j ) > hThreshold
            mask( i, j ) = uint8( 1 );
        end
    end
end

% Fine-tune the pattern
% Will keep only blocks of ones in MASK with size greater than 2 * ARM
arm = round( min( size( mask ) ) * factorForFineTuning );
maskTuned = uint8( zeros( size( mask ) ) );
for i = 1 + arm : size( mask, 1 ) - arm
    for j = 1 + arm : size( mask, 2 ) - arm
        if doesItFit( mask, i, j, arm )
            maskTuned( i, j ) = uint8( 1 );
        end
    end
end

%% Plots
% For debugging purposes, comment if in production

isol = mask .* reading;
tune = maskTuned .* reading;
figure
subplot( 1, 3, 1 )
imshow( origImg )
title( 'Original image' )
subplot( 1, 3, 2 )
imshow( isol )
title( 'Pattern identified' )
subplot( 1, 3, 3 )
imshow( tune )
title( 'Fine-tuned' )

%% Recognition logic
% From the fine-tuned mask, the code will look for 'H' edges. Once it has
% gathered the most promising ones, will apply a check to decide whether
% they belong to an 'H' pattern or not

% Find edges by looking for ones and zeros alternately
edges = {};
for i = 1 : size( maskTuned, 1 )
    forOnes = true;
    forZeros = false;
    for j = 1 : size( maskTuned, 2 )
        if forOnes && maskTuned( i, j ) == 1
            edges = compareToExistingEdges( edges, i, j, tolForEdgeDefinition );
            forOnes = false;
            forZeros = true;
        end
        if forZeros && maskTuned( i, j ) == 0
            forZeros = false;
            forOnes = true;
        end
    end
end

% Keep relevant edges only by checking length and continuity
% Should find a total of three edges, one continuous and another one split
relEdges = {};
totalEdges = 0;
flagSplitEdge = false;
for p = 1 : length( edges )
    if edges{ p }.count > 2 * size( maskTuned, 1 ) * edgeFraction
        relEdges = keepRelevantEdges( relEdges, edges{ p }, tolForEdgeDefinition, round( size( maskTuned, 1 ) * edgeFraction ) );
        totalEdges = totalEdges + relEdges{ end }.numberOfEdges;
        if relEdges{ end }.numberOfEdges == 2 % This means this edge is split
            flagSplitEdge = true;
        end
    end
end

%% Result
% 'H' pattern is identified if three edges with one of them split have been
% found, and if slopes are equal

if totalEdges == 3 && flagSplitEdge
    if abs( relEdges{ 1 }.slope - relEdges{ 2 }.slope ) < slopeTolerance
        res = true;
    end
end
