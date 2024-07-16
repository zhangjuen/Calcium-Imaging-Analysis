clear;clc;

%%
%preset parameters

TrialNumber = 3;
% StimuTime = [2 2.5; 12 14.5];%miniute
StimuStart = 2.2;
StimuDuration = 0.5;
StimuInterval = 6.5;
StimuTime(:,1) = StimuStart:StimuInterval:StimuStart+StimuInterval*(TrialNumber-1);
StimuTime(:,2) = StimuTime(:,1)+StimuDuration;
%%
dFtoF = [];
path = ['D:\ImageData\LiveImaging\','\','*.mat'];
for i = 1:TrialNumber
    BoxTitle = ['Trial: ', num2str(i)];
[filename,pathname,index] = uigetfile(path,BoxTitle);
if ~index
    return;
end
str = [pathname,filename];
dFtoF_temp = importdata(str);
dFtoF = [dFtoF dFtoF_temp];
end
[filename,pathname,index] = uiputfile(path);
strSave = [pathname,filename];
save(strSave,'dFtoF');
% dFtoF = 0-dFtoF;

%%
%heatmap
figure('Position',[300 300 1200 500]);hold on;
imagesc(dFtoF,[-20 150]);
CellNumber = size(dFtoF,1);
for k = 1:TrialNumber
    plot([StimuTime(k,1)*60*2,StimuTime(k,1)*60*2],[0,CellNumber],'--r','LineWidth',1);
    plot([StimuTime(k,2)*60*2,StimuTime(k,2)*60*2],[0,CellNumber],'--r','LineWidth',1);
end
X_tick = 0:6.5*60*2:size(dFtoF,2);
X_tick_Label = X_tick/(60*2);
set(gca,'xtick',X_tick)
set(gca,'xticklabel',{X_tick_Label})
set(gca,'ylim',[0,CellNumber]);
% set(gca,'xticklabel',{100,200,300,400,500,600})
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
xlabel('\bf Time (min)','FontName','Arial','FontSize',13);
ylabel('\bf Cell number','FontName','Arial','FontSize',13);
box off;

%%
%plot all trials
Ylim = [-50 200];
YlimMax = [-100 250];
CellNumber = size(dFtoF,1);
% CellNumber = 8;
RowNumber = 4;
ColumnNumber = 2;
PageNumer = ceil(CellNumber/(RowNumber*ColumnNumber));
xData = 0.5:0.5:StimuInterval*60*TrialNumber;
FramTime = 0.5;%second

for i = 1:PageNumer
    figure('Units','inches','Name','Traces','Position',[1 1 7.3 5.7]);hold on;
    % title(Title)
    for j = 1:RowNumber*ColumnNumber        
        CellNow = (i-1)*RowNumber*ColumnNumber+j;
        if CellNow<=CellNumber
            subplot(RowNumber,ColumnNumber,j);hold on;
            title(num2str(CellNow));
            plot(xData,dFtoF(CellNow,:));
            
            % YlimAuto = get(gca,'ylim');
            % YlimSet(1) = min(YlimAuto(1),Ylim(1));
            % YlimSet(1) = max(YlimSet(1),YlimMax(1));
            % YlimSet(2) = max(YlimAuto(2),Ylim(2));
            % YlimSet(2) = min(YlimSet(2),YlimMax(2));
            box off
            % set(gca,'ylim',YlimSet)
            % set(gca,'ylim',Ylim)
            YlimNow = get(gca,'ylim');
            for k = 1:TrialNumber
                plot([StimuTime(k,1)*60,StimuTime(k,1)*60],[YlimNow],'--r','LineWidth',0.5);
                plot([StimuTime(k,2)*60,StimuTime(k,2)*60],[YlimNow],'--r','LineWidth',0.5);
            end
        end
    end
end
% set(gca,'ylim',Ylim)
% set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
% xlabel('\bf Time (s)','FontName','Arial','FontSize',13);
% ylabel('\bf dF/F','FontName','Arial','FontSize',13);
% box off;



%%
%statistics
BasalRange(:,1) = StimuTime(:,1)-0.7;
BasalRange(:,2) = StimuTime(:,1)-0.2;
StimuRange(:,1) = StimuTime(:,1)+ 0.1;
StimuDur = 1;
StimuRange(:,2) = StimuTime(:,1)+ 0.1+StimuDur;
dFtoF_Thresh = 15; %minimum dFtoF
Dur_Thresh = 0.1; %minimum time (min) surpass the threshold
STD_Thresh = 1.6; %dFtoF versus STD of BaseRange
Responder = zeros(CellNumber,TrialNumber);
AUC = zeros(CellNumber,TrialNumber);
FS = 120;%frame per min
for i = 1:CellNumber
    for j = 1:TrialNumber
        BasalSignal = dFtoF(i,BasalRange(j,1)*FS:BasalRange(j,2)*FS-1);
        StimuSignal = dFtoF(i,StimuRange(j,1)*FS:StimuRange(j,2)*FS-1);
        Dur1 = sum(StimuSignal>dFtoF_Thresh)/FS;
        % MaxResponse = max(StimuSignal);
        STD = std(BasalSignal);
        Dur2 = sum(StimuSignal>STD)/FS;
        AUC(i,j) = sum(StimuSignal)/FS/StimuDur;
        if Dur1>=Dur_Thresh&&Dur2>=Dur_Thresh
            Responder(i,j) = 1;
        end
    end
end

Responder2(1,:) = sum(Responder);%%%respond cell number in a trial
Responder2(2,:) = CellNumber-Responder2(1,:);%%%total cell number
Res_check_trial = 5;% the trial to sort responder
index = Responder(:,Res_check_trial);
Res_dFtoF = dFtoF(index==1,:);
nonRes_dFtoF = dFtoF(index==0,:);
Res_AUC = AUC(index==1,:);

figure;
f_bar = bar(Responder2','stacked');
f_bar(2).FaceColor = [0.8 0.8 0.8];
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
% xlabel('\bf Time (min)','FontName','Arial','FontSize',13);
set(gca,'xtick',[]);
ylabel('\bf Cell Number','FontName','Arial','FontSize',13);
box off;

figure;
Res_Ratio = Responder2(1,:)./(Responder2(1,:)+Responder2(2,:))*100;
f_bar = bar(Res_Ratio);
% f_bar(2).FaceColor = [0.8 0.8 0.8];
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
% xlabel('\bf Time (min)','FontName','Arial','FontSize',13);
set(gca,'xtick',[]);
ylabel('\bf Response Cell Ratio (%)','FontName','Arial','FontSize',13);
box off;

CellNumber_Res = size(Res_dFtoF,1);
meanAUC = mean(Res_AUC);
semAUC = std(Res_AUC)/sqrt(CellNumber_Res-1);
figure;hold on;
bar(meanAUC);

errorbar(meanAUC,semAUC,'k','LineStyle','none','LineWidth',1);
set(gca,'xtick',[]);
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
ylabel('\bf AUC','FontName','Arial','FontSize',13);
box off;
h = gca;
h.XAxis.Visible = 'off';

%heatmap responder
c_lim = [-5 50];
figure('Position',[300 300 1200 500]);hold on;
imagesc(Res_dFtoF,c_lim);
CellNumber_Res = size(Res_dFtoF,1);
for k = 1:TrialNumber
    plot([StimuTime(k,1)*60*2,StimuTime(k,1)*60*2],[0,CellNumber_Res],'--r','LineWidth',1);
    plot([StimuTime(k,2)*60*2,StimuTime(k,2)*60*2],[0,CellNumber_Res],'--r','LineWidth',1);
end
X_tick = 0:6.5*60*2:size(Res_dFtoF,2);
X_tick_Label = X_tick/(60*2);
set(gca,'xtick',X_tick)
set(gca,'xticklabel',{X_tick_Label})
set(gca,'ylim',[0,CellNumber_Res]);
% set(gca,'xticklabel',{100,200,300,400,500,600})
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
xlabel('\bf Time (min)','FontName','Arial','FontSize',13);
ylabel('\bf Cell number','FontName','Arial','FontSize',13);
box off;

%heatmap non responder
figure('Position',[300 300 1200 500]);hold on;
imagesc(nonRes_dFtoF,c_lim);
CellNumber_NonRes = size(nonRes_dFtoF,1);
for k = 1:TrialNumber
    plot([StimuTime(k,1)*60*2,StimuTime(k,1)*60*2],[0,CellNumber_NonRes],'--r','LineWidth',1);
    plot([StimuTime(k,2)*60*2,StimuTime(k,2)*60*2],[0,CellNumber_NonRes],'--r','LineWidth',1);
end
X_tick = 0:6.5*60*2:size(nonRes_dFtoF,2);
X_tick_Label = X_tick/(60*2);
set(gca,'xtick',X_tick)
set(gca,'xticklabel',{X_tick_Label})
set(gca,'ylim',[0,CellNumber_NonRes]);
% set(gca,'xticklabel',{100,200,300,400,500,600})
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
xlabel('\bf Time (min)','FontName','Arial','FontSize',13);
ylabel('\bf Cell number','FontName','Arial','FontSize',13);
box off;

%%
%plot single trial
N = 1;
Ylim = [-50 100];
xData = 0.5:0.5:StimuInterval*60*TrialNumber;
FramTime = 0.5;%second
figure('Units','inches','Name','Traces','Position',[1 1 7.3 5.7]);hold on;

plot(xData,dFtoF(N,:));

for k = 1:TrialNumber
    plot([StimuTime(k,1)*60,StimuTime(k,1)*60],Ylim,'--r','LineWidth',1);
    plot([StimuTime(k,2)*60,StimuTime(k,2)*60],Ylim,'--r','LineWidth',1);
end


box off
set(gca,'ylim',Ylim)

%%
