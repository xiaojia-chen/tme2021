function  [coor_row,coor_col] = latlon2rowcol(coor_map,coordinates)

xmin = coor_map{1,1}; 
xmax = coor_map{1,3}; 
ymin = coor_map{1,2}; 
ymax = coor_map{1,4}; 
width = coor_map{1,6};
height = coor_map{1,7};

coor_col = ceil((((coordinates.x) - xmin)./(xmax - xmin)).*width);
coor_row = ceil(((ymax - coordinates.y)./(ymax - ymin)).*height);

end
