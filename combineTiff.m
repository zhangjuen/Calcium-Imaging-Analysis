%%%when saving data in individual tif images
%%%use the following code to combine them into a single tiff stack
pathname = uigetdir('D:\ImageData\LiveImaging');
if pathname==0
    return;
end
SaveFile = [pathname(1:end-4),'Combined.tif'];
AllFileNames = dir(pathname);
for i = 3:size(AllFileNames,1)-1
    %images start from the 3rd file, not the last file
    if mod(i,100)==0
        disp(i)
    end
    ImageNow = imread([pathname, '\',AllFileNames(i).name]);
    imwrite(ImageNow,SaveFile,"WriteMode","append")
end