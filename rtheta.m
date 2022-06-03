% To compute the r-theta plot;
% input is a boundary image ‘test3.bmp’
% output is the array containing the r-theta value
function [r, theta] = rtheta(Iin)
Iin = Iin > 0;
Iin = bwareafilt(Iin,1);
% calculate average for x and y
xbar = 0;
ybar = 0;
for x = 0:size(Iin,2)-1
    for y = 0:size(Iin,1)-1
         xbar = xbar + x * Iin(size(Iin,1)-y, x+1);
         ybar = ybar + y * Iin(size(Iin,1)-y, x+1);
    end
end
xbar = xbar / sum(sum(Iin));
ybar = ybar / sum(sum(Iin));

r = zeros(sum(sum(Iin)),1);
theta = zeros(sum(sum(Iin)),1);
i = 0;
for x = 0:size(Iin,2)-1
    for y = 0:size(Iin,1)-1
         if Iin(size(Iin,1)-y, x+1) == 1
            i = i + 1;
            r(i) = sqrt((x - xbar)^2 + (y - ybar)^2);
            theta(i) = atan2(y - ybar, x - xbar);
         end
    end
end
for i = 1:size(theta,1)
    if theta(i)<0
        theta(i) = theta(i) + 2*pi;
    end
end
end