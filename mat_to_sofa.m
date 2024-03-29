%%%% This MATLAB script modifies an HRTF dataset saved as a matrix (.mat)
%%%% and save it as a .sofa file.
%%%% Last edited: Yuqing Li, 19/04/2022.
clear
close all

%% options
datatype = 'mat';          % select between 'wav' and 'mat'
%% import data (HRTF/HRIR matrix)
% currentFolder = pwd
% cd(currentFolder)
N = 512;
Ndir = 37;
Nchn = 2;
cd 'C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs'
% filename = 'HRIR_mea';
% if strcmp(datatype,'wav')
%     data = audioread(strcat(filename,'.wav'));
%     HRIR_mat = zeros(N,Nchn,101,Ndir);
%     for i = 1:101  
%         for j = 1:Ndir
%             for k = 1:Nchn
%                 HRIR_mat(:,k,i,j) = data(N*(Ndir*(i-1)+j)+1:N*(Ndir*(i-1)+j)+N,Nchn,i,j);
%             end
%         end
%     end
% else
%     HRIR_mat = importdata(strcat(filename,'.mat'));
% end
data = importdata('VSSLMS_HRIRwin.mat');
HRIR_mat = data;

Obj = SOFAgetConventions('SimpleFreeFieldHRIR');  % sampling rate: 48000Hz

% Define positions 
lat1= round([0:10:360]);    % lateral angles (azimuth)
pol1= 0;                % polar angles (elevation)
pol=repmat(pol1',length(lat1),1);
lat=lat1(round(0.5:1/length(pol1):length(lat1)+0.5-1/length(pol1)));

% Create the HRIR matrix
M = length(lat1)*length(pol1);  % directions
Obj.Data.IR = zeros(M*101,2,N); % data.IR must be [M R N]

sofa_ir = zeros(M*101,2,N); % data.IR must be [M R N]
% HRIR_forsofa = permute(HRIR, [3 2 1]);
% Fill data with data
for ll = 1:101 % distance
    for aa=1:length(lat1)  % azimuth
		Obj.Data.IR(M*(ll-1)+aa,1,:) = squeeze(HRIR_mat(:,1,ll,aa)); % in the sofa convention, 90 degrees = left = channel 1
		Obj.Data.IR(M*(ll-1)+aa,2,:) = squeeze(HRIR_mat(:,2,ll,aa));
		[azi,ele]=hor2sph(lat(aa),pol(aa));
        Obj.SourcePosition((ll-1)*M+aa,:)=[azi ele (ll-1)/100+0.19];
    end
 end

% Update dimensions
Obj=SOFAupdateDimensions(Obj);

% Fill with attributes
Obj.GLOBAL_ListenerShortName = 'Neumann KU100';
Obj.GLOBAL_Comment = 'This is a database of near-field HRIRs measured on the KU100 dummy head using a continuously moving sound source and the VSSLMS method. Distance resolution: 1 cm.';
Obj.GLOBAL_DatabaseName = 'continuous-distance near-field HRIR (KU100)';
% Obj.GLOBAL_ApplicationName = 'Demo of the SOFA API';
Obj.GLOBAL_ApplicationVersion = SOFAgetVersion('API');
Obj.GLOBAL_Organization = 'Institut für Kommunikationstechnik, Leibniz Universität Hannover';
Obj.GLOBAL_AuthorContact = 'yuqing.li@ikt.uni-hannover.de';

% save the SOFA file
SOFAfn=fullfile('C:\Users\root\Documents\00 phd\measurement\Continuous-distance-NF-HRTF\220619ContinuousDistanceHRTFKU100\data\HRTFs','KU100_hrir_measurement_vsslms.sofa');
disp(['Saving:  ' SOFAfn]);
compression=0;
Obj=SOFAsave(SOFAfn, Obj,compression);

