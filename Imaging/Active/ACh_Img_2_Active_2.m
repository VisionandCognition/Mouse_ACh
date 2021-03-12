%% IMAGING DATA PROCESSING - Step 2 Active 2
%  Combine 1sNL img data from multiple days/sessions into one matrix  
%  Required: Extracted 1sNL img data

%% Get the lists of days/sessions for each type of trials

list_hit = who('hit*');
list_CR = who('CR*');
list_miss = who('miss*');
list_FA = who('FA*');

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
figure;
subplot(2,2,1);
trl_to_plot = trls_img_hit;
semshade(trl_to_plot, 0.5, 'r', trl_time);
title('Hit - 1sNL trials');
grid on
grid minor
xlabel('ms')
ylabel('df/f0')
xline(0, '--g');
xline(1000,'--k');
xline(2000,'--r');
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);

subplot(2,2,2);
trl_to_plot = trls_img_CR;
semshade(trl_to_plot, 0.5, 'r', trl_time);
title('CR - 1sNL trials');
grid on
grid minor
xlabel('ms')
ylabel('df/f0')
xline(0, '--g');
xline(1000,'--k');
xline(2000,'--r');
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);

subplot(2,2,4);
trl_to_plot =  trls_img_FA;
semshade(trl_to_plot, 0.5, 'r', trl_time);
title('FA - 1sNL trials');
grid on
grid minor
xlabel('ms')
ylabel('df/f0')
xline(0, '--g');
xline(1000,'--k');
xline(2000,'--r');
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);

subplot(2,2,3);
trl_to_plot =  trls_img_miss;
semshade(trl_to_plot, 0.5, 'r', trl_time);
title('Miss - 1sNL trials');
grid on
grid minor
xlabel('ms')
ylabel('df/f0')
xline(0, '--g');
xline(1000,'--k');
xline(2000,'--r');
txt = strcat('N=', num2str(size(trl_to_plot,1)));
text(2000,0,txt,'FontSize',14);

% subplot(2,2,1); ylim([-0.025 0.025]);
% subplot(2,2,2); ylim([-0.025 0.025]);
% subplot(2,2,3); ytyuiop[
lim([-0.025 0.025]);
% subplot(2,2,4); ylim([-0.025 0.025]);

% sgtitle(strcat(fn,'_GREEN_Fullfield'),'Interpreter', 'none');
% savefig(strcat(fn,"_GREEN_Fullfield_Outcomes"))



