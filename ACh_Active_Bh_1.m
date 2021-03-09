% Input base file name
fn.animal = input('Enter animal name =','s');
fn.date = input('Enter date (YYYYMMDD) =','s');
fn.session = input('Enter session num. (e.g. 001) =','s');
fn.base = strcat(fn.animal,'_', fn.date,'_',fn.session);

% Convert t_stim and t_lick to ms
t_trl_abs = t_trl_abs';
t_trl_abs(:,2) = round(t_trl_abs(:,2),3)*1000;
t_trl_abs(:,2) = round(t_trl_abs(:,2));
t_lick_abs = round(round(t_lick_abs,3)*1000)'; % needs to be rounded 2x

% Calculate N stim trials and licks
ntrls = size(data_table,1);
nlicks = size(t_lick_abs,1);

% Add trial time relative to abs in data_table
data_table.timeAbs0 = t_trl_abs(1:end-1,2); %exclude the last trl due to missing entry in the data_table

% Build the timecourse (tc) matrix
tc = [1:1:data_table.timeAbs0(end)+5000]'; % first col time, from abs0 in ms
tc(1,2:4) = 0; % col 2: stim trigger mark (1 or 0); col 3: reward delivery mark (1 or 0); col 4: lick mark (1 or 0)
tc(data_table.timeAbs0,2) = 1; % transfer stim trigger mark into tc
for i = 1:ntrls
    if data_table.TrlType(i) == 1 && data_table.Outcome(i) == 1
        tc(data_table.timeAbs0(i)+Par.StimDur*1000+data_table.RT(i),3) = 1;
    elseif data_table.TrlType(i) == 101
        tc(data_table.timeAbs0(i)+Par.StimDur*1000+50,3) = 1;
    end
end
tc(t_lick_abs,4) = 1; % transfer lick from t_lick to tc

% Define each trial 
ms_before = 1000; % pre length in ms
ms_after = 5000; % post length in ms
trl = [data_table.timeAbs0-1000+1 data_table.timeAbs0+5000]; % ms number for each trl
trl_time_Bh = (-999:1:5000)'; % trl time axis

% Construct licks for each trial
trl_lick = zeros(ms_before+ms_after,ntrls);
trl_reward = zeros(ms_before+ms_after,ntrls);
for i = 1:ntrls
    if i == 1 % needed to catch error caused by insuficient datapoint before 1st stim
        if trl(1,1) < 0
            trl_lick(:,1) = [zeros(abs(trl(1,1))+1,1); tc(1:trl(1,2),4)]; %if so, pad by 0
            trl_reward(:,1) = [zeros(abs(trl(1,1))+1,1); tc(1:trl(1,2),3)];
        else
            trl_lick(:,1) = tc(trl(1,1):trl(1,2),4);
            trl_reward(:,1) = tc(trl(i,1):trl(i,2),3);
        end
    else           
        trl_lick(:,i) = tc(trl(i,1):trl(i,2),4);
        trl_reward(:,i) = tc(trl(i,1):trl(i,2),3);
    end
end

% Plot the trial-wise lick raster
lick_fig = figure;
hold on;
for i = 1:ntrls

    if data_table.TrlType(i) == 1
        dotcolor = '.b';
    elseif data_table.TrlType(i)  == 0
        dotcolor = '.r';
    elseif data_table.TrlType(i)  == 101
        dotcolor = '.g';
    elseif data_table.TrlType(i)  == 100
        dotcolor = '.r';
    end
    plot(trl_time_Bh, trl_lick(:,i)*i, dotcolor, 'MarkerSize', 10);
    plot(trl_time_Bh, trl_reward(:,i)*i,dotcolor,'MarkerSize', 8, 'Marker', 'd')
    
end
xline(0);
xline(2000);hold off;
ylim([1 ntrls]);
xlabel('Time rel. onset (ms)'); ylabel('Trial');
title(fn.base,'Interpreter', 'none');
set(gcf,'color','w');
savefig(lick_fig,strcat(fn.base,"_Bh_Lick"));

%% Check behavorial perf

dp_fig = figure; 
plot(perfdata.log.DP_i);
dp_ax = gca;
grid on; grid minor; xlabel('Trial'); ylabel('iDprime');hold on;
trlN_BhStable.start = input('Enter trial start for stable performance =');
trlN_BhStable.end = input('Enter trial end for stable performance =');
xline(dp_ax,trlN_BhStable.start,'--g','LineWidth',1.5);
xline(dp_ax,trlN_BhStable.end,'--g','LineWidth',1.5);
hold off;
title(fn.base,'Interpreter', 'none')
set(dp_fig,'color','w');
savefig(dp_fig, strcat(fn.base,"_Bh_Dprime"));

%% Find certain trials

% Make list for all trials (col 1: TrlType; col 2: Outcome
% col 3; 1s-no-lick)
trl_list = [data_table.TrlType data_table.Outcome];

% Find 1s-no-lick trials
temp = sum(trl_lick(1000:1999,:))';
trl_list(temp==0,3) = 1;
clear temp

% Find HIT+1sNL
trlN_1sNL.hit = find(trl_list(:,1) == 1 & trl_list(:,2) == 1 & trl_list(:,3) == 1);
trlN_1sNL.hit(trlN_1sNL.hit<trlN_BhStable.start | trlN_1sNL.hit>trlN_BhStable.end)=[]; %Refine

% Find CR + 1sNL
trlN_1sNL.CR = find(trl_list(:,1) == 0 & trl_list(:,2) == 1 & trl_list(:,3) == 1);
trlN_1sNL.CR(trlN_1sNL.CR<trlN_BhStable.start | trlN_1sNL.CR>trlN_BhStable.end)=[];%Refine

% Find FA + 1sNL
trlN_1sNL.FA = find(trl_list(:,1) == 0 & trl_list(:,2) == 0 & trl_list(:,3) == 1);
trlN_1sNL.FA(trlN_1sNL.FA<trlN_BhStable.start | trlN_1sNL.FA>trlN_BhStable.end)=[];%Refine

% Find MISS + 1sNL
trlN_1sNL.miss = find(trl_list(:,1) == 1 & trl_list(:,2) == 0 & trl_list(:,3) == 1);
trlN_1sNL.miss(trlN_1sNL.miss<trlN_BhStable.start | trlN_1sNL.miss>trlN_BhStable.end)=[];%Refine

% Print the number of each type of trials on screen
disp(strcat('1sNL hit:',num2str(size(trlN_1sNL.hit,1))));
disp(strcat('1sNL miss:',num2str(size(trlN_1sNL.miss,1))));
disp(strcat('1sNL CR:',num2str(size(trlN_1sNL.CR,1))));
disp(strcat('1sNL FA:',num2str(size(trlN_1sNL.FA,1))));

%% Save

save(strcat(fn.base,'_Bh'),'tc','trl_lick','trl_reward','trlN_1sNL','trlN_BhStable','trl_time_Bh','fn');
