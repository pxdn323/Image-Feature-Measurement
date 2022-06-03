% To calculate the intermeans threshold;
% input is the gray level image ¡®test1.bmp¡¯
% output is the threshold value T and the binary thresholded
% image Iout.
function [T,Iout] = intermeans(Iin)
T = mean2(Iin);%mean2 need Image Processing Toolbox for average intensity
T_new = 0;
while T ~= T_new
    T_new = T;
    R1 = mean2(Iin(Iin <= T));
    R2 = mean2(Iin(Iin > T));
    T = round((R1 + R2)/2);
end
Iout = Iin > T;%binary matrix
Iout = bwareafilt(Iout,1);
end

