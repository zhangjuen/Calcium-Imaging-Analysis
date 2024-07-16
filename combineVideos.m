%%%when saving data in individual tif images
%%%use the following code to combine them into a single tiff stack
[filename,pathname,index] = uigetfile('D:\ImageData\LiveImaging\*','MultiSelect','on');
if ~index
    return;
end
SaveFile = [pathname,'Combined.tif'];

for i = 1:size(filename,2)
    i
    V = tiffreadVolume([pathname,filename{i}]);
    for j = 1:size(V,3)
        if mod(j,100)==0
            disp(j)
        end
        % temp = V(:,:,j);
        imwrite(V(:,:,j),SaveFile,"WriteMode","append");
    end
end
disp('Done!')