
function map_road = weight_map(map,unit_speed,relate_speed_offroad)

% map to weighted map


% xmin = coor_map{1,1};  xmax = coor_map{1,3};  width = coor_map{1,6};
% km_per_pixel = (xmax - xmin)*111/width;  % 一经纬度大约等于111公里
% time_per_pixel = km_per_pixel/unit_speed;


map_road = cell(size(map));
for i = 1:size(map,1)
    temp = NaN(size(map{i})); 
    temp(map{i}==1) = unit_speed;
    temp(map{i}==0) = relate_speed_offroad;
    map_road{i} = temp;
end

end