function  T = mat2col(city_xy,time,j)

    A = city_xy.name;
    B = num2cell(time{j});
    T = cell(size(B,1)*size(B,2),3);
    tt = 1;
    for ii = 1:size(B,1)
        for jj = 1:size(B,2)
            T(tt,:) = {A{ii,1}, A{jj,1}, B{ii,jj}};
            tt =  tt + 1;
        end
    end



end