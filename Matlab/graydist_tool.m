function  dist = graydist_tool(weight_map,Col,Row,yr,i)

% T = graydist(A,C,R) computes the gray-weighted distance transform of
% the grayscale image A. C and R are vectors containing the column and
% row indices of the seed locations. C and R must contain values which
% are valid pixel indices in A.

Col2 = Col;
Row2 = Row;
input_map = weight_map{yr};
C = Col(i);
R = Row(i);
T = graydist(input_map,C,R);
idx = sub2ind(size(T), Row2, Col2);
dist = T(idx);



end
