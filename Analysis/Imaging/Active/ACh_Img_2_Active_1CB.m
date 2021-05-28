%% IMAGING DATA PROCESSING - Step 2 Active 1 Contrast Blocks
%  Gather img data for different types of 1sNL trials
%  Required: 1. Behavioral analysis output
%            2. ImgBase output from step 1

%% Check the file name of the loaded behavioral and img files
if exist('fn_bh','var') == 0
    error('fn_bh does not exist!'); 
elseif exist('fn_img','var') == 0
    error('fn_img does not exist!'); 
elseif fn_bh.animal ~= fn_img.animal
    error('Animal names do not match!');
elseif fn_bh.date ~= fn_img.date
    error('Dates do not match!');
elseif fn_bh.session ~= fn_img.session
    error('Session numbers do not match!');
end

%% Extract trials from img data
selection = [data_table.Contrast == 1] & [data_table.OutcomeNL == 1];
    eval(strcat('hit_',fn_img.date,'_',fn_img.session,'= data_trl_all_3d(selection,:,:)'));
selection = [data_table.Contrast == 1] & [data_table.OutcomeNL == 3];
    eval(strcat('CR_',fn_img.date,'_',fn_img.session,'= data_trl_all_3d(selection,:,:)'));
selection = [data_table.Contrast == 1] & [data_table.OutcomeNL == 2];
    eval(strcat('miss_',fn_img.date,'_',fn_img.session,'= data_trl_all_3d(selection,:,:)'));
selection = [data_table.Contrast == 1] & [data_table.OutcomeNL == 4];
    eval(strcat('FA_',fn_img.date,'_',fn_img.session,'= data_trl_all_3d(selection,:,:)'));

%% Save
save(strcat(fn_img.base,'_ImgBase_1sNL'), strcat('hit_',fn_img.date,'_',fn_img.session),...
    strcat('CR_',fn_img.date,'_',fn_img.session),...
    strcat('miss_',fn_img.date,'_',fn_img.session),...
    strcat('FA_',fn_img.date,'_',fn_img.session));