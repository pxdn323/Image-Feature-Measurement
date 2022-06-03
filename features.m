% To compute the features;
% input is the binary thresholded image
% outputs are the feature values
function [P, A, C, xbar, ybar, phione] = features(Iin)

%perimeter
Iin_Boundary = bwperim(Iin,8);
P = regionprops(Iin_Boundary,'Perimeter').Perimeter;

%area 
I_fill = imfill(Iin_Boundary, 'holes');%fill with perimeter above
A = sum(sum(I_fill));

%compactness
C = P*P/4/pi/A;

%centroid
m00 = 0;
m10 = 0;
m01 = 0;
for x = 0:size(I_fill,2)-1
    for y = 0:size(I_fill,1)-1
        for i = 1:3
            if i == 1
                m00 = m00 + 1 * I_fill(size(I_fill,1)-y, x+1);
            end
            if i == 2
                m10 = m10 + x * I_fill(size(I_fill,1)-y, x+1);
            end
            if i == 3
                m01 = m01 + y * I_fill(size(I_fill,1)-y, x+1);
            end
        end
    end
end
xbar = m10 / m00;
ybar = m01 / m00;

%invariant moment 𝜙1
%  𝜙1 = u20/(u00)^2 + u02/(u00)^2
u00 = m00;
m20 = 0;
m02 = 0;
for x = 0:size(I_fill,2)-1
    for y = 0:size(I_fill,1)-1
        for i = 1:2
            if i == 1
                m20 = m20 + x^2 * I_fill(size(I_fill,1)-y, x+1);
            end
            if i == 2
                m02 = m02 + y^2 * I_fill(size(I_fill,1)-y, x+1);
            end
        end
    end
end
u20 = m20 - xbar*m10;
u02 = m02 - ybar*m01;
phione = u20/(u00)^2 + u02/(u00)^2;
end