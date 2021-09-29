%% IMAGING DATA PROCESSING - Step 2 Active 2
%  Combine 1sNL img data from multiple days/sessions into one matrix  
%  Required: Extracted 1sNL img data

%% Get the lists of days/sessions for each type of trials

list_hit = who('hit*');
list_CR = who('CR*');
list_miss = who('miss*');
list_FA = who('FA*');

list_lick_hit = who('lick_hit*');
list_lick_CR = who('lick_CR*');
list_lick_miss = who('lick_miss*');
list_lick_FA = who('lick_FA*');

%% 
trls_img_hit = [];
for i = 1:size(list_hit,1)
    trls_img_hit = [trls_img_hit;eval(list_hit{i})];
end
trls_img_miss = [];
for i = 1:size(list_miss,1)
    trls_img_miss = [trls_img_miss;eval(list_miss{i})];
end
trls_img_FA = [];
for i = 1:size(list_FA,1)
    trls_img_FA = [trls_img_FA;eval(list_FA{i})];
end
trls_img_CR = [];
for i = 1:size(list_CR,1)
    trls_img_CR = [trls_img_CR;eval(list_CR{i})];
end

%% Plotting

try
    NLcutoff = trlN_1sNL.cutoff*1000;
catch
    NLcutoff = 1000;
end

figure;
subplot(2,2,1);
trl_to_plot = trls_img_hit;
if size(trl_to_plot,1) >= 3
    semshade(trl_to_plot, 0.5, 'r', trl_time);
    grid on
    grid minor
    xlabel('ms')
    ylabel('df/f0')
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);
title('Hit - 1sNL trials');
ax = gca;
    ax.YAxis.Exponent = 0;
ytickformat('%.3f');

subplot(2,2,2);
trl_to_plot = trls_img_CR;
if size(trl_to_plot,1) >= 3
    semshade(trl_to_plot, 0.5, 'r', trl_time);
    grid on
    grid minor
    xlabel('ms')
    ylabel('df/f0')
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);
title('CR - 1sNL trials');
ax = gca;
    ax.YAxis.Exponent = 0;
ytickformat('%.3f');

subplot(2,2,4);
trl_to_plot =  trls_img_FA;
if size(trl_to_plot,1) >= 3
    semshade(trl_to_plot, 0.5, 'r', trl_time);
    grid on
    grid minor
    xlabel('ms')
    ylabel('df/f0')
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);
title('FA - 1sNL trials');
ax = gca;
    ax.YAxis.Exponent = 0;
ytickformat('%.3f');

subplot(2,2,3);
trl_to_plot =  trls_img_miss;
if size(trl_to_plot,1) >= 3
    semshade(trl_to_plot, 0.5, 'r', trl_time);
    grid on
    grid minor
    xlabel('ms')
    ylabel('df/f0')
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);
title('Miss - 1sNL trials');
ax = gca;
    ax.YAxis.Exponent = 0;
ytickformat('%.3f');


% Standarize y axis
y1 = input('Enter common y minimum for all subplots =');
y2 = input('Enter common y maximum for all subplots =');
subplot(2,2,1); ylim([y1 y2]);
subplot(2,2,2); ylim([y1 y2]);
subplot(2,2,3); ylim([y1 y2]);
subplot(2,2,4); ylim([y1 y2]);

if exist('sessionInfo','var') == 1
    sgtitle(strcat(fn_img.base,'_',sessionInfo.type,'_',sessionInfo.note),'Interpreter', 'none');
    savefig(strcat(fn_img.base,'_Outcomes','_',sessionInfo.type,'_',sessionInfo.note));
else
    sgtitle(fn_img.base,'Interpreter', 'none');
    savefig(strcat(fn_img.base,'_Outcomes'));
    error('Unable to automatically determine session type. Please check and change figure and file name if necessary!')
end

%% Plot the lick PSTH

trls_lick_hit = [];
for i = 1:size(list_lick_hit,1)
    trls_lick_hit = [trls_lick_hit eval(list_lick_hit{i})];
end
trls_lick_miss = [];
for i = 1:size(list_lick_miss,1)
    trls_lick_miss = [trls_lick_miss eval(list_lick_miss{i})];
end
trls_lick_FA = [];
for i = 1:size(list_lick_FA,1)
    trls_lick_FA = [trls_lick_FA eval(list_lick_FA{i})];
end
trls_lick_CR = [];
for i = 1:size(list_lick_CR,1)
    trls_lick_CR = [trls_lick_CR eval(list_lick_CR{i})];
end

figure;
subplot(2,2,1);
trl_to_plot = trls_lick_hit';
trls_to_plot_N = size(trl_to_plot,1);
if trls_to_plot_N >= 3
    trl_to_plot = sum(trl_to_plot);
    trl_to_plot = movsum(trl_to_plot,66);
    trl_to_plot = trl_to_plot(33:66:66*90-33);
    plot(trl_time, (trl_to_plot/trls_to_plot_N)/0.066);
    xlabel('ms')
    ylabel('Licks rate (Hz)');
    ylim([0 10]);
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(trls_to_plot_N));
text(2000,0,txt,'FontSize',14);
title('Hit - 1sNL licks');

subplot(2,2,2);
trl_to_plot = trls_lick_CR';
trls_to_plot_N = size(trl_to_plot,1);
if trls_to_plot_N >= 3
    trl_to_plot = sum(trl_to_plot);
    trl_to_plot = movsum(trl_to_plot,66);
    trl_to_plot = trl_to_plot(33:66:66*90-33);
    plot(trl_time, (trl_to_plot/trls_to_plot_N)/0.066);
    xlabel('ms')
    ylabel('Licks rate (Hz)');
    ylim([0 10]);
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(trls_to_plot_N));
text(2000,0,txt,'FontSize',14);
title('CR - 1sNL licks');

subplot(2,2,3);
trl_to_plot = trls_lick_miss';
trls_to_plot_N = size(trl_to_plot,1);
if trls_to_plot_N >= 3
    trl_to_plot = sum(trl_to_plot);
    trl_to_plot = movsum(trl_to_plot,66);
    trl_to_plot = trl_to_plot(33:66:66*90-33);
    plot(trl_time, (trl_to_plot/trls_to_plot_N)/0.066);
    xlabel('ms')
    ylabel('Licks rate (Hz)');
    ylim([0 10]);
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(trls_to_plot_N));
text(2000,0,txt,'FontSize',14);
title('Miss - 1sNL trials');

subplot(2,2,4);
trl_to_plot = trls_lick_FA';
trls_to_plot_N = size(trl_to_plot,1);
if trls_to_plot_N >= 3
    trl_to_plot = sum(trl_to_plot);
    trl_to_plot = movsum(trl_to_plot,66);
    trl_to_plot = trl_to_plot(33:66:66*90-33);
    plot(trl_time, (trl_to_plot/trls_to_plot_N)/0.066);
    xlabel('ms')
    ylabel('Licks rate (Hz)');
    ylim([0 10]);
    xline(0, '--g');
    xline(NLcutoff,'--k');
    xline(2000,'--r');
end
txt = strcat('N=', num2str(trls_to_plot_N));
text(2000,0,txt,'FontSize',14);
title('FA - 1sNL licks');

if exist('sessionInfo','var') == 1
    sgtitle(strcat(fn_img.base,'_',sessionInfo.type,'_',sessionInfo.note),'Interpreter', 'none');
    savefig(strcat(fn_img.base,'_Outcomes_Licks','_',sessionInfo.type,'_',sessionInfo.note));
else
    sgtitle(fn_img.base,'Interpreter', 'none');
    savefig(strcat(fn_img.base,'_Outcomes_Licks'));
    error('Unable to automatically determine session type. Please check and change figure and file name if necessary!')
end
