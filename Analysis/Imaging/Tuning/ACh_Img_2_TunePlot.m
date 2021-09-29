disp('Choose an action to perform:')
disp('1 - Plot tuning for all ROIs combined');
disp('2 - Plot tuning for a particular ROI');
choice = input('Enter your choice =');

if choice == 1
    % Plot big ROI per condition
    cond_list = unique(cond);
    n_cond = size(cond_list,1);
    figure;
    for i = 1:n_cond
        subplot(ceil(n_cond/2),2,i);
        semshade(data_trl_bigROI(cond==cond_list(i),:), 0.5, 'r', trl_time);
        title(num2str(cond_list(i)));
        grid on
        grid minor
        xlabel('ms')
        ylabel('df/f0')
        xline(0, '--g');
        %     xline(1500, '--b');
        xline(2000,'--r');
    end
elseif choice == 2
    % for a given ROI, plot each condition in a subplot
    cond_list = unique(cond);
    n_cond = size(cond_list,1);
    roi = input('Define the ROI to plot ='); % Define ROI to plot
    figure;
    for i = 1:n_cond
        subplot(ceil(n_cond/2),2,i);
        semshade(data_trl_all{roi}(cond==cond_list(i),:), 0.5, 'r', trl_time);
        %ylim([-0.02 0.04]);
        title(num2str(cond_list(i)));
        grid on
        grid minor
        xlabel('ms')
        ylabel('df/f0')
        xline(0, '--g');
        %     xline(1500, '--b');
        xline(1000,'--r');
    end
    sgtitle(strcat('ROI ',num2str(roi)));
else
    error('Invalid choice!');
end


y0 = input('Enter the lower Y-limit for all subplots =');
y1 = input('Enter the upper Y-limit for all subplots =');
for i = 1:n_cond
    subplot(ceil(n_cond/2),2,i);
    ylim([y0 y1])
end



sgtitle(strcat(fn_img.base,"_Tuning SEM")','Interpreter', 'none');
savefig(strcat(fn_img.base,"_Tuning"));