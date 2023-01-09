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
% for the unablated case, and the D-ON, V-ON and V-OFF ablation
% experiments. The Raphe_Data.mat contains the corresponding 4 variables.



clc;
load Raphe_Data.mat 
lightsOn = [45, 86, 127, 168]; %Indicates the time-points at which light was switched on for 20s in these experiments

unablated_to_use = unablated;
dOn_abl_to_use = dOn_abl;
vOn_abl_to_use = vOn_abl;
vOff_abl_to_use = vOff_abl;
%%
data = []; 
clf; clc;
toAdd_x = [24;27;29];
y_lims = [0.8 1.4];
unablated_mean = mean(unablated_to_use(:,lightsOn(1):(lightsOn(1)+29))); data(1,:) = unablated_mean;
dOn_abl_mean = mean(dOn_abl_to_use(:,lightsOn(1):(lightsOn(1)+29)));  data(2,:) = dOn_abl_mean;
vOn_abl_mean = mean(vOn_abl_to_use(:,lightsOn(1):(lightsOn(1)+29))); data(3,:) = vOn_abl_mean;
vOff_abl_mean = mean(vOff_abl_to_use(:,lightsOn(1):(lightsOn(1)+29))); data(4,:) = vOff_abl_mean;

raphe_responses = smoothExtrapolateRapheData(data,toAdd_x);

raphe_interp = getRapheOutputForMLP(raphe_responses);
output_filename = 'raphe_all_for_mlp.csv';  
csvwrite(output_filename,raphe_interp);
%%
clf;
y_lims = [0.8 1.2; 0.8 1.4; 0.8 1.2; 0.8 1.2];
for i = 1:4
    subplot(4,1,i);
    plot(raphe_responses(:,i),'Color',[0 0 0.9],'Linewidth',1.75);
    hold on;
    rectangle('Position',[21,y_lims(i,1),20,y_lims(i,2)-y_lims(i,1)],'FaceColor',[0.8 0 0 0.2],'EdgeColor','none');
    ylim(y_lims(i,:));
    grid minor;
    set(gca,'box','off','fontsize',13);
    xlabel('Time');
    ylabel('Intensity(F/F0');
end




