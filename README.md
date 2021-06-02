# 《交通结构、市场规模与经济增长》一文代码说明书

该仓库包含文章所用的代码和示例数据。参考该代码时，请引用文献“陈晓佳,徐玮,安虎森.交通结构、市场规模与经济增长[J].世界经济,2021.”。

代码将陆续整理上传。

## 1 计算城际交通时间 ![](http://latex.codecogs.com/svg.latex?T_{ijt}^m)

#### 1.1 利用Arcpy文件下shp2png.py代码将shapefile格式的交通网络数据转为图片格式。
* Z:\Network文件下面可以放历年的交通网络地图，以不同文件名命名，程序循环读取所有的地图批量处理。
* 代码执行后输出： 图片格式的交通网络地图 和 图片格式地图四个角的经纬度（数据在excel文件中four_corner_coordinates.xls）。
* 代码执行需要在 ArcGis 的 Python 窗口中输入 execfile(r'Z:\Arcpy\shp2png.py')。
* 具体操作见ScreenRecord目录下的视频。

#### 1.2 利用图片格式的交通地图和城市经纬度计算城际交通时间
* 利用Matlab文件下的calculate_time.m计算城市之间的交通时间。
* 需要图片格式的交通网络、城市经纬度、交通速度等数据。
* calculate_time.m运行过程需要调用到weight_map.m,gradist_tool.m,mat2col.m,latlon2rowcol.m。
* 运行结果将历年不同类型交通网络的城际交通速度的数据保持到Network文件下，格式为csv。

## 2 计算冰山成本 ![](http://latex.codecogs.com/svg.latex?tau_{it})


## 3 计算市场规模 ![](http://latex.codecogs.com/svg.latex?MS_{it})


## 4 最小生成树工具变量构造

## 其他链接 
可以在以下网址下载文章的代码：
* https://github.com/xiaojia-chen/tme2021
* https://gitee.com/xiaojia-chen/tme2021
