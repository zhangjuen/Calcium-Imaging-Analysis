figure; 
LineColor = [0 0.9 0.0];
plot(Fluo_ElutionVolume,Green_signal,'-','color',LineColor,'linewidth',2);
xlim([0 25]);
ylim([-1 30]);
set(gca,'xtick',0:2.5:25)
set(gca,'LineWidth',1,'FontName','Arial','FontSize',11,'Color','none','TickDir','out','FontWeight','bold');
box(gca,'off');
xlabel('Elution Volume (mL)','FontName','Arial','FontSize',13);
ylabel('Fluoresence','FontName','Arial','FontSize',13);
% set(gca,'YAxisLocation', 'right','YColor',LineColor,'XColor','none');

