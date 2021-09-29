%% IMAGING DATA PROCESSING - Step 1
% Requires: 1. Data table for a session extracted from ImageJ 
%           2. Scanbox log for that session

%% Input base file name
fn_img.animal = input('Enter animal name =','s');
fn_img.date = input('Enter date (YYYYMMDD) =','s');
fn_img.session = input('Enter session num. (e.g. 001) =','s');
fn_img.channel = input('Enter channel name (RED or GREEN) =','s');
fn_img.roitype = input('Enter ROI type (Indv or Fullfield) =','s');
fn_img.base = strcat(fn_img.animal,'_', fn_img.date,'_',fn_img.session,'_',fn_img.channel,'_',fn_img.roitype);

%% Find out the number of ROIs
numROIs = (size(table,2)-1)/4;
% numROIs = (size(table,2)-1)/3;

%% Frame correction
frame = info.frame;
for i = 1:size(info.line,1)
    if info.line(i) > 100
        frame(i) = frame(i)+1;
    end
end

%% Check spurious triggers
if size(info.messages,1) ~= size(info.frame,1)
    disp('Sprious triggers detected! Press any key to start the removal process.')
    pause;
    frame(info.event_id~=1,1) = NaN;
    frame = frame(~isnan(frame));
    disp('Sprious triggers removed!');
end

%% Get trial conditions
temp = char(info.messages);
ntrl = size(temp,1);
cond = zeros(ntrl,1);
for i=1:ntrl
    cond(i,1) = str2double(temp(i,:));
end
clear temp

% Check if irrelavent stimuli were presented
if max(unique(cond))==1000
    disp('Irrelevant stimuli triggers detected!')
    ProcPar_Base.trlIrrelevant = input('Enter type of trl triggers for use in analysis: 0 - Normal stim; 1 - Irrelevant stim;')
    if ProcPar_Base.trlIrrelevant == 1
        frameX = frame(cond==1000,:);
    else
        frameX = frame(~cond==1000,:);
    end
else
    ProcPar_Base.trlIrrelevant = 0;
end


    
%% Establish trials
ProcPar_Base.scanHz = input('Please enter sampling rate (Hz) =');
ProcPar_Base.preMs = input('Please pre-stimulus onset length (in ms) =');
ProcPar_Base.postMs = input('Please post-stimulus onset length (in ms) =');
trl_len_fm_pre = ceil(ProcPar_Base.preMs/(1000/ProcPar_Base.scanHz));
trl_len_fm_post = ceil(ProcPar_Base.postMs/(1000/ProcPar_Base.scanHz));
trl = [frame-trl_len_fm_pre frame+trl_len_fm_post-1];

%% Establish a trl_time axis (0=onset)
% trl_time = [0-ProcPar_Base.preMs:(1000/ProcPar_Base.scanHz):(ProcPar_Base.postMs-1000/ProcPar_Base.scanHz)];
trl_time = [0-ProcPar_Base.preMs+1000/ProcPar_Base.scanHz:(1000/ProcPar_Base.scanHz):(ProcPar_Base.postMs)];

%% Gather trial data for ROIs

% Whole trace ROI table
table_roi = zeros(size(table,1),numROIs);
for roi = 1:numROIs
    table_roi(:,roi) = table(:,(1+4*roi-2));
%     table_roi(:,roi) = table(:,(1+3*roi-1));
end

% Pad the first 2 seconds with the remaining session mean
pad = mean(table_roi(30:end,:),1);
pad = repmat(pad,30,1);
table_roi(1:30,:) = pad;
clear pad

% Detrend
table_roi_offset = mean(table_roi); %compute raw mean
table_roi = detrend(table_roi,1);
table_roi = table_roi + table_roi_offset; %correct detrended value to mean level; 

% ROI trace per trial
data_trl_all = {};
for roi = 1:numROIs
    data_trl_all{roi} = zeros(size(frame,1),(trl_len_fm_pre+trl_len_fm_post));
    for i = 1:size(frame,1)
            data_trl_all{roi}(i,:) = table_roi(trl(i,1):trl(i,2),roi);
            baseline = mean(data_trl_all{roi}(i,1:trl_len_fm_pre));
            data_trl_all{roi}(i,:) = (data_trl_all{roi}(i,:) - baseline)/baseline;
            clear baseline
    end
end
data_trl_all_3d = cat(3,data_trl_all{:});

%% Get big ROI (avg dF/F0 of all ROIs)
data_trl_bigROI = mean(data_trl_all_3d, 3);

%% Save base data file
save(strcat(fn_img.base,'_ImgBase'));

%% Plotting based on conditions

% % Plot big ROI per condition
% cond_list = unique(cond);
% n_cond = size(cond_list,1);
% figure;
% for i = 1:n_cond
%     subplot(ceil(n_cond/2),2,i);
%     semshade(data_trl_bigROI(cond==cond_list(i),:), 0.5, 'r', trl_time);
%     title(num2str(cond_list(i)));
%     grid on
%     grid minor
%     xlabel('ms')
%     ylabel('df/f0')
%     xline(0, '--g');
% %     xline(1500, '--b');
%     xline(2000,'--r');
% end
% sgtitle(strcat(fn,"_Tuning_ROIall SEM")','Interpreter', 'none');
% savefig(strcat(fn,"_Tuning_ROIall"));
% 
% % Plot VER for the big ROI
% figure;
% semshade(data_trl_bigROI, 0.5, 'r', trl_time);
% sgtitle(strcat(fn,"_VER_ROIall SEM")','Interpreter', 'none');
% grid on
% grid minor
% xline(0, '--g');
% xline(2000,'--r');
% savefig(strcat(fn,"_VER_ROIall"));

% for a given ROI, plot each condition in a subplot
% cond_list = unique(cond);
% n_cond = size(cond_list,1);
% roi = 22; % Define ROI to plot
% figure;
% for i = 1:n_cond
%     subplot(ceil(n_cond/2),2,i);
%     semshade(data_trl_all{roi}(cond==cond_list(i),:), 0.5, 'r', trl_time);
%     %ylim([-0.02 0.04]);
%     title(num2str(cond_list(i)));
%     grid on
%     grid minor
%     xlabel('ms')
%     ylabel('df/f0')
%     xline(0, '--g');
% %     xline(1500, '--b');
%     xline(1000,'--r');
% end
% sgtitle(strcat('ROI ',num2str(roi)));

