%%%%% Section D %%%%%
% This m file is used to test your code for Section D
% Ensure that when you run this script file
%--- 1.
I = imread('./letter.bmp');
figure(1);
imshow(I);
hold on;
%Compute the edge map of the test image.
[T,Iout] = intermeans(I);
I_edge = bwperim(Iout,8);
figure(2);
imshow(I_edge);

%Hough Transform
a_range =20;
a_step = 81;
b_range = 50000;
b_step = 20001;
a_de = 2*a_range/(a_step-1);
b_de = 2*b_range/(b_step-1);
a = zeros(1,a_step);
for i = 1:a_step
    a(i) = -a_range + a_de*(i-1);
end
b = int32(linspace(-b_range,b_range,b_step));
A = zeros(a_step,b_step);
for x = 0:size(I_edge,2)-1
    for y = 0:size(I_edge,1)-1
         for i = 1:a_step
             if I_edge(size(I_edge,1)-y, x+1) == 1
                 b_new = int32(-x * a(i) + y);
                 if b_new < -b_range + b_de
                     b_r = -b_range;
                 elseif b_new > b_range - b_de
                     b_r = b_range;
                 elseif mod(b_new,b_de) == 0
                     b_r = b_new;
                 elseif mod(b_new,b_de) >= b_de/2
                     b_r = (idivide(b_new,b_de,'floor') + 1) * b_de;
                 else
                     b_r = idivide(b_new,b_de,'floor') * b_de;
                 end
                 j = b_r / b_de;
                 j = j + (b_step-1)/2 + 1;
                 A(i,j) = A(i,j) + 1;
             end
         end
    end
end
%find n highest
n=20;
[AS,pos] = sort(A(:));
a_result = zeros(n,1);
b_result = zeros(n,1);
for i = 0:n-1
    if mod(pos(a_step*b_step-i),a_step)~=0
        a_result(i+1) = mod(pos(a_step*b_step-i),a_step)*a_de-a_range-a_de;
        a_mod =  mod(pos(a_step*b_step-i),a_step);
    else
        a_result(i+1) = a_step*a_de-a_range-a_de;
        a_mod = a_step;
    end
    b_result(i+1) = (pos(a_step*b_step-i)-a_mod)/a_step*b_de-b_range;
    %avoid overlap
    flag = 0;
    for j = 1:i+1
        if (abs(a_result(j)-a_result(i+1))<=a_de) && (j~=i+1) 
            for n =0:8
                x_mid = size(I,2)/8*n;
                if (abs(a_result(j)*x_mid+b_result(j)-a_result(i+1)*x_mid-b_result(i+1))<=10)
                    flag = 1;
                    break;
                end
            end
        end
        if flag == 1
            break;
        end
    end
    if flag == 0
        p1_x = 0;
        p1_y = a_result(i+1)*p1_x+b_result(i+1);
        p2_x = 500;
        p2_y = a_result(i+1)*p2_x+b_result(i+1);
        p1 = [size(I,1)-p1_y,p1_x+1];
        p2 = [size(I,1)-p2_y,p2_x+1];
        figure(1);
        plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)
    end
end
saveas(gcf,'letter_line','bmp');
    
