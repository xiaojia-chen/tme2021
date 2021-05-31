import glob, os
import arcpy
import xlwt

#################################################################################################
### 该代码可将 D:\Map 文件下面的所有交通网络地图（.shp格式）转变为图片格式的交通网络地图（.png格式） ###
#################################################################################################

# 注意：
# D:\Map文件下面可以放历年的交通网络地图，以不同文件名命名，程序循环读取所有的地图批量处理。
# 代码执行后输出：
#               图片格式的交通网络地图
#               和图片格式地图四个角的经纬度（数据在excel文件中four_corner_coordinates.xls）
# 代码执行需要在 ArcGis 的 Python 窗口中输入 execfile(r"")

# 转换文件所保存的路径
shp_input = r"D:\Map"

# 转换后输出的路径
png_output = r"D:\Map"

# 国界border.shp：用于确保转为图片后大小都一致
border_shp = r"D:\Map\border.shp"

# 样式Standard_Symbology.lyr：用于修改网络矢量图的样式，比如线加粗
symbologyLayer = r"D:\Map\Standard_Symbology.lyr"

# 图片四个角的经纬度
xls_output = r"D:\Map\four_corner_coordinates.xls"

###################
### 以下不须修改 ###
###################

book = xlwt.Workbook()
sheet1 = book.add_sheet("Sheet1")

os.chdir(shp_input)
row = 1
for file in sorted(glob.glob(net+"*.shp"),reverse=True):
    print(file)

    borderlayer = arcpy.MakeFeatureLayer_management(border_shp, "border_Layer", "", "", "")
    mxd = arcpy.mapping.MapDocument("current")
    df = arcpy.mapping.ListDataFrames(mxd, "Layers")[0]
    layers = arcpy.mapping.ListLayers(mxd, "*", df)
    for layer in layers:
         if layer.name == "border_Layer":
            layer.visible = False

    # create a new layer
    newlayer = arcpy.mapping.Layer(shp_input+file)

    arcpy.ApplySymbologyFromLayer_management(newlayer, symbologyLayer)

    # Refresh things
    arcpy.RefreshActiveView()
    arcpy.RefreshTOC()

    extent = df.extent
    print(extent.XMin,extent.YMin,extent.XMax,extent.YMax)
    sheet1.write(row,1,extent.XMin)
    sheet1.write(row,2,extent.YMin)
    sheet1.write(row,3,extent.XMax)
    sheet1.write(row,4,extent.YMax)

    if row == 1:
        x_width = (extent.XMax - extent.XMin)*111/4
        y_height = (extent.YMax - extent.YMin)*111/4

    sheet1.write(row,6,x_width)
    sheet1.write(row,7,y_height)

    row += 1

    result_png = png_output + file + ".png"

    arcpy.mapping.ExportToPNG(mxd, result_png, df,
                              df_export_width = x_width,
                              df_export_height = y_height,
                              world_file = True)

    layers = arcpy.mapping.ListLayers(mxd, "*", df)

    for df in arcpy.mapping.ListDataFrames(mxd):
        for lyr in arcpy.mapping.ListLayers(mxd, "", df):
                arcpy.mapping.RemoveLayer(df, lyr)

    arcpy.RefreshTOC()
    arcpy.RefreshActiveView()


book.save(xls_output)
print("Workbook Created")

