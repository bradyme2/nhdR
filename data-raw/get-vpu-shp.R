library(sf)
library(rgdal)

# http://www.horizon-systems.com/NHDPlus/V2GlobalData.php
remote_path <- "http://www.horizon-systems.com/NHDPlusData/NHDPlusV21/Data/GlobalData/NHDPlusV21_NHDPlusGlobalData_02.7z"
temp_dir <- tempdir()
in_path <- file.path(temp_dir, "nhdglobal.7z")
# in_path <- "/tmp/RtmpsyMbWy/nhdglobal.7z"
# temp_dir <- "/tmp/RtmpsyMbWy"
curl::curl_download(remote_path, in_path)

if(Sys.info()["sysname"] == "Windows"){
  system(paste0("7za.exe e ", in_path, " -o", temp_dir))
}else{
  system(paste0("7z -y e ", in_path, " -o", temp_dir))
}

out_path <- tempfile(fileext = ".shp")
system(paste0("ogr2ogr -simplify 0.06 ", out_path, " ", file.path(temp_dir, "BoundaryUnit.shp")))

vpu_shp <- sf::st_read(out_path)
devtools::use_data(vpu_shp)
