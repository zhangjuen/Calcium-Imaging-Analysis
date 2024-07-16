function varargout = CalciumImagingAnalysis(varargin)
% CALCIUMIMAGINGANALYSIS MATLAB code for CalciumImagingAnalysis.fig
%      CALCIUMIMAGINGANALYSIS, by itself, creates a new CALCIUMIMAGINGANALYSIS or raises the existing
%      singleton*.
%
%      H = CALCIUMIMAGINGANALYSIS returns the handle to a new CALCIUMIMAGINGANALYSIS or the handle to
%      the existing singleton*.
%
%      CALCIUMIMAGINGANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCIUMIMAGINGANALYSIS.M with the given input arguments.
%
%      CALCIUMIMAGINGANALYSIS('Property','Value',...) creates a new CALCIUMIMAGINGANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalciumImagingAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalciumImagingAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalciumImagingAnalysis

% Last Modified by GUIDE v2.5 08-Apr-2024 16:52:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalciumImagingAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @CalciumImagingAnalysis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CalciumImagingAnalysis is made visible.
function CalciumImagingAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalciumImagingAnalysis (see VARARGIN)

% Choose default command line output for CalciumImagingAnalysis
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CalciumImagingAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalciumImagingAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_loadFile.
function pushbutton_loadFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = getappdata(0,'A_path');
if ~isempty(pathname)
    str = [pathname '*.*'];
else
    str = '*.*';
end
[filename,pathname,index] = uigetfile(str);
if ~index
    return;
end
str = [pathname filename];
setappdata(0,'A_path',pathname);
setappdata(0,'FilePathName',str);
set(handles.edit_fileName,'string',filename)

if strfind(filename,'.tif')
FrameToShow = str2num(get(handles.edit_FrameToShow,'String'));
V = tiffreadVolume(str,'PixelRegion',{[1 1 inf],[1 1 inf],[FrameToShow(1) FrameToShow(end)]});
if numel(FrameToShow)==2
    V = max(V,[],3);
end
V2 = double(V);
V_min = min(min(V2))+30;
V_max = max(max(V2));
delta = V_max-V_min;

V2 = (V2-V_min)./delta;

V2 = imadjust(V2,[0 0.9],[0 0.8],0.5);
% V_max = V_min + delta*0.2;
axes(handles.axes_image);
% imshow(V,[V_min*0.9 V_max]);
hImage = imshow(V2,[0.03 0.6]);
setappdata(0,'hImage',hImage);
% imwrite(V2,[pathname,'ExampleImage.png']);
end
if contains(filename,'.png')%%load presaved image
    V2 = imread(str);
    assignin('base',"V2",V2)
    hImage = imshow(V2,[0.03 0.4]*255);
    setappdata(0,'hImage',hImage);

end

%%%%reset 
messageNow = ['Reset roi?'];
answer = questdlg(messageNow,'Reset ROI', 'Yes', 'No','Yes');
if strcmp(answer,'Yes') 
set(handles.uitable_roiStack,'ColumnName',{'Show','Keep'});
set(handles.uitable_roiStack,'data',[]);
listData = cell(0,2);
currentROI = 0;
setappdata(0,'roi_stack',[]);
setappdata(0,'currentROI',currentROI);
setappdata(0,'listData',listData);
end


function edit_fileName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fileName as text
%        str2double(get(hObject,'String')) returns contents of edit_fileName as a double


% --- Executes during object creation, after setting all properties.
function edit_fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_FrameToShow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FrameToShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_FrameToShow as text
%        str2double(get(hObject,'String')) returns contents of edit_FrameToShow as a double


% --- Executes during object creation, after setting all properties.
function edit_FrameToShow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_FrameToShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ROI.
function pushbutton_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

roi = drawpolygon(handles.axes_image,'LineWidth',1,'FaceAlpha',0);
wait(roi);
roi.Color = [0.8 0.1 0.2];
roi.MarkerSize = 0.5;
roi.LineWidth = 2;
drawnow;
ROI_mask = createMask(roi);
setappdata(0,'ROI_mask',ROI_mask);
setappdata(0,'ROI',roi);


% --- Executes on button press in pushbutton_background.
function pushbutton_background_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
roi = drawellipse(handles.axes_image,'LineWidth',1,'FaceAlpha',0);
wait(roi);
roi.Color = [0.8 0.8 0.3];
% roi.MarkerSize = 0.5;
% roi.FaceAlpha = 0;
mask = createMask(roi);
setappdata(0,'BackGroundROI',roi);
setappdata(0,'BackGroundROI_mask',mask);
save backgroundROI roi



% --- Executes on button press in pushbutton_plotImage.
function pushbutton_plotImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plotImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = getappdata(0,'FilePathName');
FrameToShow = str2double(get(handles.edit_FrameToShow,'String'));
V = tiffreadVolume(str,'PixelRegion',{[1 1 inf],[1 1 inf],[FrameToShow FrameToShow]});

prompt = {'Min:','Max:'};
dlgtitle = 'Image Range';
fieldsize = [1 45; 1 45];
definput = {'100','1100'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput)
V_min = str2double(answer{1});
V_max = str2double(answer{2});
figure;
imshow(V,[V_min V_max]);


% --- Executes on button press in pushbutton_Plot.
function pushbutton_Plot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = getappdata(0,'FilePathName');
Tiff_info = imfinfo(str);
FrameNumber = length(Tiff_info);
BackGroundROI_mask = getappdata(0,'BackGroundROI_mask');
% BackGround_pixel_number = sum(sum(BackGroundROI_mask));
BasalRange = [180,220];
frameTime = 0.500;%s

ROI_mask = getappdata(0,'ROI_mask');

Value_ROI = zeros(FrameNumber,1);
Value_background = zeros(FrameNumber,1);
ReadFrameBatch = 500;
for i = 1:ReadFrameBatch:FrameNumber
    i
    if i+ReadFrameBatch-1<FrameNumber
        EndNow = i+ReadFrameBatch-1;
    else
        EndNow = FrameNumber;
    end
     V = tiffreadVolume(str,'PixelRegion',{[1 1 inf],[1 1 inf],[i 1 EndNow]}); 
     for j = 1:size(V,3)
        temp = V(:,:,j);
     Value_background(i+j-1,1) = mean(mean(temp(BackGroundROI_mask)));
     Value_ROI(i+j-1,1) = mean(mean(temp(ROI_mask)));
     end
end
Value = Value_ROI - Value_background;
baseline = mean(Value(BasalRange(1):BasalRange(2)));
dFtoF = (Value-baseline)/baseline*100;
% figure;plot(Value_ROI);
% figure;plot(Value_background)
xData = (1:length(dFtoF))*frameTime;
figure;plot(xData,dFtoF,'color',[0.1 0.8 0.1],'linewidth',1);
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
box(gca,'off');
xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
ylabel('\bf \DeltaF/F (%)','FontName','Arial','FontSize',13);


% --- Executes on button press in pushbutton_Re_BackGround.
function pushbutton_Re_BackGround_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Re_BackGround (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = getappdata(0,'FilePathName');
Tiff_info = imfinfo(str);
FrameNumber = length(Tiff_info);
BackGroundROI_mask = getappdata(0,'BackGroundROI_mask');
% BackGround_pixel_number = sum(sum(BackGroundROI_mask));
BasalRange = [180,220];

Value_background = zeros(FrameNumber,1);

index = strfind(str,'\');
str_TiffSave = [str(1:index(end)),'Remove_background.tiff'];
ReadFrameBatch = 500;
for i = 1:ReadFrameBatch:FrameNumber
    i
    if i+ReadFrameBatch-1<FrameNumber
        EndNow = i+ReadFrameBatch-1;
    else
        EndNow = FrameNumber;
    end
     V = tiffreadVolume(str,'PixelRegion',{[1 1 inf],[1 1 inf],[i 1 EndNow]}); 
     for j = 1:size(V,3)
        temp = V(:,:,j);
     Value_background(i+j-1,1) = mean(mean(temp(BackGroundROI_mask)));
     temp2 = temp-Value_background(i+j-1,1);
     temp2(temp2<0) = 0;
     imwrite(temp2,str_TiffSave,"WriteMode","append");
     % Value_ROI(i+j-1,1) = mean(mean(temp(ROI_mask)));
     end
end
disp('Done!!!');


% --- Executes on button press in pushbutton_RecROI.
function pushbutton_RecROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RecROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
roi = drawrectangle(handles.axes_image);
wait(roi);
roi.Color = [0.8 0.1 0.2];
drawnow;
Pos = round(roi.Position);
Pos(Pos==0) = 1;%make sure not zero

setappdata(0,'RecROIpos',Pos);

% --- Executes on button press in pushbutton_ROIvideo.
function pushbutton_ROIvideo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ROIvideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pos = getappdata(0,'RecROIpos');
if isempty(Pos)
    Pos = [1 1 inf inf];
    disp('Save whole image')
else
    disp('Save ROI image')
end
prompt = {'pixel_min:','pixel_max:','FrameBin:','FrameRate:'};
dlgtitle = 'Input';
fieldsize = [1 40; 1 40; 1 40;1 40];
definput = {'800','4000','5','20'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
if isempty(answer)
    return;
end

str = getappdata(0,'FilePathName');
Tiff_info = imfinfo(str);
FrameNumber = length(Tiff_info);
index = strfind(str,'\');
[filename,pathname,idx] = uiputfile([str(1:index(end)),'*.mp4']);
if ~idx
    return;
end
% str_TiffSave = [FilePathName(1:index(end)),'Remove_background.tiff'];
str_TiffSave = [pathname filename];
ReadFrameBatch = 500;
% V = zeros(Pos(4),Pos(3),FrameNumber);
for i = 1:ReadFrameBatch:FrameNumber
    i
    if i+ReadFrameBatch-1<FrameNumber
        EndNow = i+ReadFrameBatch-1;
    else
        EndNow = FrameNumber;
    end
     V(:,:,i:EndNow) = tiffreadVolume(str,'PixelRegion',{[Pos(2) 1 Pos(2)+Pos(4)-1],[Pos(1) 1 Pos(1)+Pos(3)-1],[i 1 EndNow]}); 
end



pixel_min = str2double(answer{1});
pixel_max = str2double(answer{2});
V2 = double(V);
V2 = (V2-pixel_min)./(pixel_max-pixel_min);
V2(V2>1)=1;
V2(V2<0)=0;

FrameBin = str2double(answer{3});
Video_obj = VideoWriter(str_TiffSave,'MPEG-4');
Video_obj.FrameRate = str2double(answer{4});
open(Video_obj);
for i = 1:FrameBin:FrameNumber
    if i+FrameBin-1<FrameNumber
        EndNow = i+FrameBin-1;
    else
        EndNow = FrameNumber;
    end
    V3 = mean(V2(:,:,i:EndNow),3);
    writeVideo(Video_obj,V3);    
end
close(Video_obj);

disp('Done!!!')


% --- Executes on button press in pushbutton_loadROIs.
function pushbutton_loadROIs_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_loadROIs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = getappdata(0,'A_path');
if ~isempty(pathname)
    str = [pathname '*.mat'];
else
    str = '*.mat';
end
[filename,pathname,index] = uigetfile(str);
if ~index
    return;
end

[filename_back,pathname_back,index] = uigetfile(str);
if ~index
    return;
end
str = [pathname filename];
str_back = [pathname_back filename_back];
set(handles.edit_roiFile,'string',filename);
roi_stack = importdata(str);
% setappdata(0,'roi_stack',roi_stack);
BackGroundROI = importdata(str_back);
setappdata(0,'BackGroundROI',BackGroundROI);
axes(handles.axes_image);hold on;
for i = 1:size(roi_stack,1)
%     pgon = polyshape(roi_stack(i).Position);
%     plot(pgon);

    roi_stack2(i,1) = drawpolygon('Position',roi_stack(i).Position,'MarkerSize',0.5,'LineWidth',1,'Color',[0.8 0.1 0.2]);
end
listData = cell(size(roi_stack,1),2);
for i = 1:size(roi_stack,1)
    listData{i,2} = true;
end

setappdata(0,'listData',listData);
set(handles.uitable_roiStack,'data',listData);
setappdata(0,'roi_stack',roi_stack2);





function edit_roiFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_roiFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_roiFile as text
%        str2double(get(hObject,'String')) returns contents of edit_roiFile as a double


% --- Executes during object creation, after setting all properties.
function edit_roiFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_roiFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_analysis.
function pushbutton_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
roi_stack = getappdata(0,'roi_stack');
hImage = getappdata(0,'hImage');
roi_Num = length(roi_stack);
Mask = false([size(hImage.CData),roi_Num]);
for i = 1:roi_Num
Mask(:,:,i) = createMask(roi_stack(i),hImage);
end

str = getappdata(0,'FilePathName');
Tiff_info = imfinfo(str);
FrameNumber = length(Tiff_info);
BackGroundROI = getappdata(0,'BackGroundROI');
BackGroundROI_mask = createMask(BackGroundROI,hImage);
% BackGround_pixel_number = sum(sum(BackGroundROI_mask));
BasalRange = [180,220];
frameTime = 0.500;%ms

Value_ROI = zeros(roi_Num,FrameNumber);
Value_background = zeros(1,FrameNumber);
ReadFrameBatch = 500;
PixelNumber = Tiff_info(1).Width*Tiff_info(1).Height;
for i = 1:ReadFrameBatch:FrameNumber
    i
    if i+ReadFrameBatch-1<FrameNumber
        EndNow = i+ReadFrameBatch-1;
    else
        EndNow = FrameNumber;
    end
     V = tiffreadVolume(str,'PixelRegion',{[1 1 inf],[1 1 inf],[i 1 EndNow]}); 
     V = reshape(V,[PixelNumber,[],EndNow-i+1]);
     Value_background(1,i:EndNow) = mean(V(BackGroundROI_mask,:));     
     for roi_index = 1:roi_Num
         Value_ROI(roi_index,i:EndNow) = mean(V(Mask(:,:,roi_index),:));
     end
     % for j = 1:size(V,3)
     %     temp = V(:,:,j);
     %     Value_background(1,i+j-1) = mean(mean(temp(BackGroundROI_mask)));
     %     for roi_index = 1:roi_Num
     %         Value_ROI(roi_index,i+j-1) = mean(mean(temp(Mask(:,:,roi_index))));
     %     end
     % end
end
Value = Value_ROI - mean(Value_background);
% Value = Value_ROI;
baseline = mean(Value(:,BasalRange(1):BasalRange(2)),2);
dFtoF = (Value-baseline)./baseline*100;
pathname = getappdata(0,'A_path');
save([pathname,'dFtoF.mat'],'dFtoF');
save([pathname,'Value.mat'],'Value');
save([pathname,'Value_background.mat'],'Value_background');
assignin('base','dFtoF',dFtoF);
% xData = (1:length(dFtoF))*frameTime;
figure;imagesc(dFtoF,[0 100]);
set(gca,'xticklabel',{100,200,300,400,500,600})
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
ylabel('\bf Cell number','FontName','Arial','FontSize',13);
box off;

% xData = (1:length(dFtoF))*frameTime;
% figure;plot(xData,dFtoF,'color',[0.1 0.8 0.1],'linewidth',1);
% set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
% box(gca,'off');
% xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
% ylabel('\bf \DeltaF/F (%)','FontName','Arial','FontSize',13);
disp('Done!!!');
% figure;imshow(Mask(:,:,1))
% figure;imshow(Mask(:,:,2))

% --- Executes when entered data in editable cell(s) in uitable_roiStack.
function uitable_roiStack_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_roiStack (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if eventdata.NewData==0&&eventdata.Indices(2)==2
    messageNow = ['Would you like delete roi: ', num2str(eventdata.Indices(1))];
    answer = questdlg(messageNow,'Delete ROI', 'Yes', 'No','Yes');
    if strcmp(answer,'Yes')
        roi_stack = getappdata(0,'roi_stack');
        delete(roi_stack(eventdata.Indices(1)));
        roi_stack(eventdata.Indices(1)) = [];
        listData = getappdata(0,'listData');
        listData(eventdata.Indices(1),:) = [];
        setappdata(0,'roi_stack',roi_stack);
        setappdata(0,'listData',listData);
        set(handles.uitable_roiStack,'data',listData);
    end
end
if eventdata.Indices(2)==1
    roi_stack = getappdata(0,'roi_stack');
    if eventdata.NewData==0 %disable the highlight
        roi_stack(eventdata.Indices(1)).Color = [0.8 0.1 0.2];
        roi_stack(eventdata.Indices(1)).LineWidth = 1;
        drawnow;
    end
    if eventdata.NewData==1 %highlight selected ROI
        roi_stack(eventdata.Indices(1)).Color = [0.2 0.6 0.1];
        roi_stack(eventdata.Indices(1)).LineWidth = 2;  
        drawnow;
    end

end
% eventdata.Indices(2)

% --- Executes on button press in pushbutton_addROI.
function pushbutton_addROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_addROI, 'BackgroundColor',	[0.7 0.2 0.2]);
ROIaddingStatus = getappdata(0,'ROIaddingStatus');
if ROIaddingStatus==1
    return;
end
setappdata(0,'ROIaddingStatus',1);

roi_stack = getappdata(0,'roi_stack');
roi = drawpolygon(handles.axes_image,'LineWidth',1,'FaceAlpha',0);
% roi = drawassisted(handles.axes_image,'LineWidth',1,'FaceAlpha',0);
% wait(roi);
roi.Color = [0.8 0.1 0.2];
% roi.MarkerSize = 0.5;
% roi.LineWidth = 2;
drawnow;
if ~isempty(roi.Position)%only save correct RIO
    roi_stack = [roi_stack;roi];
    listData = getappdata(0,'listData');
    N = size(roi_stack,1);
    listData{N,1} = logical(0);
    listData{N,2} = logical(1);
    setappdata(0,'roi_stack',roi_stack);
    setappdata(0,'listData',listData);
    set(handles.uitable_roiStack,'data',listData);
    save roi_stack roi_stack
end

set(handles.pushbutton_addROI, 'BackgroundColor',	[0.467 0.675 0.188]);

setappdata(0,'ROIaddingStatus',0);

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if length(eventdata.Key)>1%%%other special keys, like alt, ctrl, shift ...
    return;
end
if eventdata.Key == 'a'||eventdata.Key=='A' %%add a new roi
    ROIaddingStatus = getappdata(0,'ROIaddingStatus');
    if ROIaddingStatus==1
        return;
    end
    disp('add a new roi')
    pushbutton_addROI_Callback(hObject, eventdata, handles);
end
if eventdata.Key == 'c'||eventdata.Key=='C' %%reset adding roi
    set(handles.pushbutton_addROI, 'BackgroundColor',	[0.467 0.675 0.188]);
    setappdata(0,'ROIaddingStatus',0);

end


% --- Executes on key press with focus on pushbutton_addROI and none of its controls.
function pushbutton_addROI_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_addROI (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_saveROI.
function pushbutton_saveROI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
messageNow = ['Background??? '];
answer = questdlg(messageNow,'Background', 'Yes', 'No','Yes');
if strcmp(answer,'No')
    return;
end

roi_stack = getappdata(0,'roi_stack');
pathname = getappdata(0,'A_path');
if ~isempty(pathname)
    str = [pathname '*.mat'];
else
    str = '*.mat';
end
[filename, filepath,index] = uiputfile(str);
if ~index
    save roi_stack roi_stack
    return;
end
save([filepath filename],'roi_stack');

BackGroundROI = getappdata(0,'BackGroundROI');
save([filepath,filename(1:end-5),'_BackGround.mat'],'BackGroundROI');
