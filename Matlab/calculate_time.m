
clear
clc


cd "Z:/Matlab" % 引号内输入Matlab文件所在位置
	
feature('DefaultCharacterSet', 'UTF-8');

% 此代码计算交通网络的城际运输时间,以两年的高速公路和铁路两种交通网络数据为例。

%% 导入图片格式的交通网络数据，并转为01矩阵，1表示线路，0表示非线路
k = 2; % 有多少年的交通网络地图就输入多少，例如这里要保存2年的数据

% 读入历年高速公路数据
highway_map = cell(k,1); % 用于保存高速公路数据
image_highway2000 = imread("../Network/Highway_2000.shp.png");
highway_map(1) = {double(image_highway2000(:,:,1)==0)};
image_highway2005 = imread("../Network/Highway_2005.shp.png");
highway_map(2) = {double(image_highway2005(:,:,1)==0)};

% 读入历年铁路数据
railway_map = cell(k,1); % 用于保存铁路数据
image_railway2000 = imread("../Network/Railway_2000.shp.png");
railway_map(1) = {double(image_railway2000(:,:,1)==0)};
image_railway2005 = imread("../Network/Railway_2005.shp.png");
railway_map(2) = {double(image_railway2005(:,:,1)==0)};

%% 导入要计算两点之间距离的经纬度

% 导入城市经纬度
city_xy = readtable('../Input/city.csv');

% 导入交通网络图片四个角的经纬度
coor_map = readtable('../Network/four_corner_coordinates.xls','ReadVariableNames',0);

% 经纬度转为图片像素的行列号
[city_xy.railway_row,city_xy.railway_col] = latlon2rowcol(coor_map,city_xy);
[city_xy.highway_row,city_xy.highway_col] = latlon2rowcol(coor_map,city_xy);


% 测试北京经纬度是否正确
imagesc(railway_map{2}) 
hold on 
plot(city_xy.railway_col(1), city_xy.railway_row(1),'.r', "MarkerSize", 20);

%% 设置交通方式的单位速度
speed_railway = 160; % 铁路160公里/小时
speed_highway = 90; % 高速公路90公里/小时

% 公里/小时转为像素/小时
xmin = coor_map{1,1};  xmax = coor_map{1,3};  width = coor_map{1,6};
km_per_pixel = (xmax - xmin)*111/width;  % 一经纬度大约等于111公里，每个像素大约4公里
time_per_pixel_railway = km_per_pixel/speed_railway; % 火车经过一个像素需要多长时间
time_per_pixel_highway = km_per_pixel/speed_highway;

% 设置相对速度，高速公路速度标准化为1
relate_time_highway = time_per_pixel_highway/time_per_pixel_highway;
relate_time_railway = time_per_pixel_railway/time_per_pixel_highway;
relate_time_offroad = 2; % 设置一个比铁路和高速公路时间更大的数值, graydist寻找时间

%% 计算交通时间


% 高速公路
% 根据交通速度设置交通网络权重
weight_highway = weight_map(highway_map,relate_time_highway,relate_time_offroad);

n = size(weight_highway,1); % year
m = size(city_xy,1); % city
iterations=[n,m];
time_highway = cell(n,m);
Col = city_xy.highway_col;
Row = city_xy.highway_row;

% 计算交通时间
for ix=1:prod(iterations) % 如需加快速度可用parfor做并行计算
    [nn,mm]=ind2sub(iterations,ix);
    time = graydist_tool(weight_highway,Col,Row,nn,mm);
    time_highway(ix) = {time}; 
end


% 铁路 
% 根据交通速度设置交通网络权重
weight_railway = weight_map(railway_map,relate_time_railway,relate_time_offroad);

n = size(weight_railway,1); % year
m = size(city_xy,1); % city
iterations=[n,m];
time_railway = cell(n,m);
Col = city_xy.railway_col;
Row = city_xy.railway_row;

% 计算交通时间
for ix=1:prod(iterations)
    [nn,mm]=ind2sub(iterations,ix); 
    time = graydist_tool(weight_railway,Col,Row,nn,mm);
    time_railway(ix) = {time}; 
end


%% 导出数据

j = 0;
for i = [2000,2005]
    j = j + 1;
    % export higway data
    T = mat2col(city_xy,time_highway,j);
    writetable(cell2table(T),['../Network/time_highway',num2str(i),'.csv'])
 
    % export rail data
    T2 = mat2col(city_xy,time_railway,j);
    writetable(cell2table(T2),['../Network/time_railway',num2str(i),'.csv'])   
end



