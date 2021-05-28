animal = "Magenta";
date = "20210514";

chan = "chG";
fn_load = strcat(animal,"_",date,"_RT_",chan,"_fullfield.csv");
cut = readmatrix("cut.xlsx");
rt = csvread(fn_load,1,0);
for i = 1:size(cut,1)
    table = [];
    table = rt(cut(i,3):cut(i,4),:);
    fn_save = strcat(animal,"_",date,"_RT_",chan,"_",num2str(cut(i,2)),".mat");
    save(fn_save,"table");
end

% chan = "RED";
% fn_load = strcat(animal,"_",date,"_RT_",chan,"_all.csv");
% cut = readmatrix("cut.xlsx");
% rt = csvread(fn_load,1,0);
% for i = 1:size(cut,1)
%     table = [];
%     table = rt(cut(i,3):cut(i,4),:);
%     fn_save = strcat(animal,"_",date,"_RT_",chan,"_",num2str(cut(i,2)),".mat");
%     save(fn_save,"table");
% end