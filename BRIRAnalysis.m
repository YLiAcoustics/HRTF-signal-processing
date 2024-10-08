clear
close all

cd 'L:\Cloud\DataBackup\KEMARtrajectory'

fs=44100;
c=343;
traj = 2;

if traj == 1
    disV=[0:0.1:3.5];
    for i=1:length(disV)
        dis=disV(i);
        fname_S4=['IR' num2str(dis) 'm_S4.mat'];
        fname_S5=['IR' num2str(dis) 'm_S5.mat'];
        fname_S7=['IR' num2str(dis) 'm_S7.mat'];
        fname_STV=['IR' num2str(dis) 'm_STV.mat'];

        IRmat(:,:,i,1)=importdata(fname_S4);
        IRmat(:,:,i,2)=importdata(fname_S5);
        IRmat(:,:,i,3)=importdata(fname_S7);
        IRmat(:,:,i,4)=importdata(fname_STV);
    end
elseif traj==2
    disV=[0:0.1:2];
    for i=1:length(disV)
        dis=disV(i);
        fname_S4=['IR_Kitchen' num2str(dis) 'm_S4.mat'];
        fname_S5=['IR_Kitchen' num2str(dis) 'm_S5.mat'];
        fname_S7=['IR_Kitchen' num2str(dis) 'm_S7.mat'];
        fname_STV=['IR_Kitchen' num2str(dis) 'm_STV.mat'];

        IRmat(:,:,i,1)=importdata(fname_S4);
        IRmat(:,:,i,2)=importdata(fname_S5);
        IRmat(:,:,i,3)=importdata(fname_S7);
        IRmat(:,:,i,4)=importdata(fname_STV);
    end
end
IRmat=IRmat(1:2048,:,:,:);

Specmat=fft(IRmat);

%%
fAxis=[0:floor(length(Specmat)/2)-1]/length(Specmat)*fs;
Specmat_plot=2*Specmat([1:floor(length(Specmat)/2)],:,:,:);
Specmat_plot(1,:,:,:)=Specmat_plot(1,:,:,:)/2;

[X,Y]=meshgrid(fAxis,disV);
[X1,Y1]=meshgrid([0:length(IRmat)-1]/fs,disV);
figname={'S4','S5','S7','STV'};
for j = 1:4
    figure
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0.1 0.1 0.3 0.6]);
    t=tiledlayout(2,1,"TileSpacing","compact");
    nexttile
    pc1=pcolor(X,Y,transpose(squeeze(mag2db(abs(Specmat_plot(:,1,:,j))))));cb=colorbar;clim([-20 20]);
    cb.Label.String='Mag (dB)'
%     colormap('gray');
    pc1.LineStyle="none";
    pc1.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1);
    ylabel('Distance (m)');
    title([figname(j) 'left']);
    nexttile
    pc2=pcolor(X,Y,transpose(squeeze(mag2db(abs(Specmat_plot(:,2,:,j))))));cb=colorbar;clim([-20 20]);
    cb.Label.String='Mag (dB)'
%     colormap('gray');
    pc2.LineStyle='none';
    pc2.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1);
    xlabel('Freq (Hz)');
    ylabel('Distance (m)');
    title([figname(j) ' right']);

    figure
    set(gcf,'Units','normalized');
    set(gcf,'Position',[0.1 0.1 0.3 0.6]);
    t=tiledlayout(2,1,"TileSpacing","compact");
    nexttile
    pc3=pcolor(X1,Y1,transpose(squeeze(mag2db(abs(IRmat(:,1,:,j))))));colorbar;clim([-50 0]);
    oldcmap = colormap('gray');
%     colormap( flipud(oldcmap) );
    colormap('gray');
    pc3.LineStyle="none";
    pc3.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1);
    ylabel('Distance (m)');
    xlim([0 0.05]);
    title([figname(j) 'left']);
    nexttile
    pc4=pcolor(X1,Y1,transpose(squeeze(mag2db(abs(IRmat(:,2,:,j))))));colorbar;clim([-50 0]);
%     colormap( flipud(oldcmap) );
    colormap('gray');
    pc4.LineStyle='none';
    pc4.FaceColor="interp";
    set(gca,'Layer','top');
    set(gca,'FontSize',14);
    set(gca,'LineWidth',1);
    xlim([0 0.05]);
    xlabel('Time (s)');
    ylabel('Distance (m)');
    title([figname(j) ' right']);
end
