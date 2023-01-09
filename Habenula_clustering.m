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

% This program loads the unclustered Habenula data in the file 
% Habenula_Dorsal_ventral_data_preClustering.mat. This file contains data 
% that is separated out into dorsal and ventral regions. The program then
% performs averaging and k-means clustering on this data. 

clf;clc;
load Habenula_Dorsal_ventral_data_preClustering.mat
dorsal_data = dorsal_hb_data;
ventral_data = ventral_hb_data;
onPeriod = 20;
offPeriod = 24;
ld_averaged = false;

%% Use this section only if required to normalise baseline neuron response to 1 

%{
norm_data = dorsal_hb_data;
for i = 1:size(norm_data,1)
    m = median(norm_data(i,1:30));
    norm_data(i,:) = norm_data(i,:)/m;
end

norm_dorsal = norm_data;

norm_data = ventral_hb_data;
for i = 1:size(norm_data,1)
    m = median(norm_data(i,1:30));
    norm_data(i,:) = norm_data(i,:)/m;
end

norm_ventral = norm_data;
dorsal_data = norm_dorsal;
ventral_data = norm_ventral;
%}

%% Use this section to average light/dark cycles before clustering

%{
data = norm_dorsal;
t = onPeriod + offPeriod;
tmp = zeros(size(data,1),t);
num_light_dark = 1;
for i = 1:num_light_dark %Only the first light/dark cycle
    tmp2 = data(:,(lightOn(i)+1):(lightOn(i)+t));
    for j = 1:size(tmp2,1)
        tmp2(j,:) = tmp2(j,:)/tmp2(j,1);
    end
    tmp = tmp + tmp2;
end

average_dorsal_behaviour = tmp/num_light_dark;

data = norm_ventral;
t = onPeriod + offPeriod;
tmp = zeros(size(data,1),t);
for i = 1:num_light_dark %Only the first light/dark cycle
    tmp2 = data(:,(lightOn(i)+1):(lightOn(i)+t));
    for j = 1:size(tmp2,1)
        tmp2(j,:) = tmp2(j,:)/tmp2(j,1);
    end
    tmp = tmp + tmp2;
end

average_ventral_behaviour = tmp/num_light_dark;
dorsal_data = average_dorsal_behaviour;
ventral_data = average_ventral_behaviour;
ld_averaged = true;
%}

%%
clusts_dorsal = zeros(size(dorsal_data,1),10); clusts_ventral = zeros(size(ventral_data,1),10);
for k = 1:10
    k
    clusts_dorsal(:,k) = kmeans(dorsal_data,k,'Distance','correlation','replicates',20,'MaxIter',1000);
    clusts_ventral(:,k) = kmeans(ventral_data,k,'Distance','correlation','replicates',20,'MaxIter',1000);
end

%%
tmp = zeros(10,10);
for k = 1:10
    tmp2 = zeros(10,1);
    for j = 1:10
        tmp2(j,1) = sum(clusts_ventral(:,k)==j);
    end
    tmp2 = sort(tmp2,'descend');
    tmp(:,k) = tmp2;
end

%%
clf; clc;
k = 3;
fig_id = 0;
d_id = [1 3 2];
titles = {'Dorsal-ON-Tonic','Ventral-ON-Tonic','Dorsal-OFF-Tonic','Ventral-OFF-Tonic','Dorsal-OFF-Phasic','Ventral-OFF-Phasic'};
for i = 1:k
    fig_id = fig_id + 1;
    subplot(k,2,fig_id);
    d = dorsal_data(clusts_dorsal(:,k)==i,:);
    plot(mean(d),'k','Linewidth',1.75); hold on;
    y_lim = ylim;
    for j = 1:length(lightOn)
        if ld_averaged
            rectangle('Position',[0, y_lim(1),20, y_lim(2)-y_lim(1)],'FaceColor',[1 0 0 0.1],'EdgeColor','none');
        else
            rectangle('Position',[lightOn(j), y_lim(1),20, y_lim(2)-y_lim(1)],'FaceColor',[1 0 0 0.25],'EdgeColor','none');
        end
    end
    ylim(y_lim);
    grid minor;
    title(['Dhb Cluster no. ',num2str(i),'. Num cells = ',num2str(size(d,1))]);
    
    fig_id = fig_id + 1;
    subplot(k,2,fig_id);
    d = ventral_data(clusts_ventral(:,k)==i,:);
    plot(mean(d),'k','Linewidth',1.75); hold on;
    y_lim = ylim;
    for j = 1:length(lightOn)
        if ld_averaged
            rectangle('Position',[0, y_lim(1),20, y_lim(2)-y_lim(1)],'FaceColor',[1 0 0 0.1],'EdgeColor','none');
        else
            rectangle('Position',[lightOn(j), y_lim(1),20, y_lim(2)],'FaceColor',[1 0 0 0.25],'EdgeColor','none');
        end
    end
    ylim(y_lim);
    grid minor;
    title(['Vhb Cluster no. ',num2str(i),'. Num cells = ',num2str(size(d,1))]);
end
