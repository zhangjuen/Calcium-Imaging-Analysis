

%%
[filename,pathname,index] = uigetfile('D:\ImageData\LiveImaging\*.mat');
if ~index
    return;
end
str = [pathname,filename];
dFtoF = importdata(str);
% dFtoF = 0-dFtoF;
%%
figure;imagesc(dFtoF,[-20 50]);
set(gca,'xticklabel',{100,200,300,400,500,600})
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
ylabel('\bf Cell number','FontName','Arial','FontSize',13);
box off;

%%
N = 60  ;
% Title = 'G15Gust-Sucralose-2.5min';
Ylim = [-20 100];
YlimMax = [-100 250];
CellNumber = size(dFtoF,1);
RowNumber = 4;
ColumnNumber = 5;
PageNumer = ceil(CellNumber/(RowNumber*ColumnNumber));
xData = 0.5:0.5:600;
FramTime = 0.5;%second
StimuTime = [2 4.5];%miniute

for i = 1:PageNumer
    figure('Units','inches','Name','Traces','Position',[1 1 7.3 5.7]);hold on;
    % title(Title)
    for j = 1:RowNumber*ColumnNumber        
        CellNow = (i-1)*RowNumber*ColumnNumber+j;
        if CellNow<=CellNumber
            subplot(RowNumber,ColumnNumber,j);hold on;
            title(num2str(CellNow));
            plot(xData,dFtoF(CellNow,:));
            plot([StimuTime(1)*60,StimuTime(2)*60],[-5,-5],'-k','LineWidth',2)
            YlimAuto = get(gca,'ylim');
            YlimSet(1) = min(YlimAuto(1),Ylim(1));
            YlimSet(1) = max(YlimSet(1),YlimMax(1));
            YlimSet(2) = max(YlimAuto(2),Ylim(2));
            YlimSet(2) = min(YlimSet(2),YlimMax(2));
            box off
            set(gca,'ylim',YlimSet)
            % set(gca,'ylim',[-20 100])
        end
    end
end
% set(gca,'ylim',Ylim)
% set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
% xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
% ylabel('\bf dF/F','FontName','Arial','FontSize',13);
% box off;

