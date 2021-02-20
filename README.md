
# Helipad Detector
Matlab function to identify *H* pattern in image.

The main function, `findH.m`, should be called. It uses three additional functions internally – `doesItFit.m`, `compareToExistingEdges.m` and `keepRelevantEdges.m`.

Check the main function's help below.

```matlab
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
```