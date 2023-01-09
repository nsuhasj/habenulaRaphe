%{ 
Copyright (C) 2023  N. Suhas Jagannathan
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
%}

% This script loads the Raphe ablation data from the Raphe_Data.mat file
% and performs preprocessing to obtain the 100s characteristic responses
% (10X cross validation) for the unablated case, and the D-ON, V-ON and 
% V-OFF ablation experiments. The Raphe_Data.mat contains the corresponding 4 variables.

%%
clc;
load Raphe_Data.mat 
lightsOn = [45, 86, 127, 168]; %Indicates the time-points at which light was switched on for 20s in these experiments


unablated_to_use = unablated;
dOn_abl_to_use = dOn_abl;
vOn_abl_to_use = vOn_abl;
vOff_abl_to_use = vOff_abl;

%% Shuffle neurons in all datasets
unablated_to_use = unablated(randperm(size(unablated, 1)), :);
dOn_abl_to_use = dOn_abl(randperm(size(dOn_abl, 1)), :);
vOn_abl_to_use = vOn_abl(randperm(size(vOn_abl, 1)), :);
vOff_abl_to_use = vOff_abl(randperm(size(vOff_abl, 1)), :);

%%
toAdd_x = [24;27;29];
y_lims = [0.8 1.4];

raphe_data_train = [];
raphe_data_val =  [];

for crossVal = 1:10
    data_train = []; data_val = [];
    [unablated_train, unablated_val] = removeDataForCrossVal(unablated_to_use,10,crossVal);
    [dOn_abl_train, dOn_abl_val] = removeDataForCrossVal(dOn_abl_to_use,10,crossVal);
    [vOn_abl_train, vOn_abl_val] = removeDataForCrossVal(vOn_abl_to_use,10,crossVal);
    [vOff_abl_train, vOff_abl_val] = removeDataForCrossVal(vOff_abl_to_use,10,crossVal);
    
    unablated_train_mean = mean(unablated_train(:,lightsOn(1):(lightsOn(1)+29))); data_train(1,:) = unablated_train_mean;
    dOn_abl_train_mean = mean(dOn_abl_train(:,lightsOn(1):(lightsOn(1)+29)));  data_train(2,:) = dOn_abl_train_mean;
    vOn_abl_train_mean = mean(vOn_abl_train(:,lightsOn(1):(lightsOn(1)+29))); data_train(3,:) = vOn_abl_train_mean;
    vOff_abl_train_mean = mean(vOff_abl_train(:,lightsOn(1):(lightsOn(1)+29))); data_train(4,:) = vOff_abl_train_mean;
    
    unablated_val_mean = mean(unablated_val(:,lightsOn(1):(lightsOn(1)+29))); data_val(1,:) = unablated_val_mean;
    dOn_abl_val_mean = mean(dOn_abl_val(:,lightsOn(1):(lightsOn(1)+29)));  data_val(2,:) = dOn_abl_val_mean;
    vOn_abl_val_mean = mean(vOn_abl_val(:,lightsOn(1):(lightsOn(1)+29))); data_val(3,:) = vOn_abl_val_mean;
    vOff_abl_val_mean = mean(vOff_abl_val(:,lightsOn(1):(lightsOn(1)+29))); data_val(4,:) = vOff_abl_val_mean;
    
    data_train_smooth = smoothExtrapolateRapheData(data_train,toAdd_x);
    data_val_smooth = smoothExtrapolateRapheData(data_val,toAdd_x);
    
    raphe_train_pt01 = getRapheOutputForMLP(data_train_smooth);
    raphe_val_pt01 = getRapheOutputForMLP(data_val_smooth);
    
    raphe_data_train(:,crossVal) = raphe_train_pt01;
    raphe_data_val(:,crossVal) = raphe_val_pt01;
    
    train_filename = ['raphe_data_train_cv_',num2str(crossVal),'.csv'];
    val_filename = ['raphe_data_val_cv_',num2str(crossVal),'.csv'];
    
    csvwrite(train_filename,raphe_train_pt01);
    csvwrite(val_filename,raphe_val_pt01);
end

%%
clf;
for crossVal = 1:10
    subplot(5,2,crossVal);
    plot(raphe_data_train(:,crossVal),'k','LineWidth',1.25);
    hold on;
    plot(raphe_data_val(:,crossVal),'r','LineWidth',1.25);
    ylim([0.8 1.6]);
    set(gca,'box','off','XTickLabel',[]);
    grid minor;   
    legend({'Training set','Validation set'},'Location','best');  
    title(['Cross Validation set ',num2str(crossVal)]);
end




