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

% This program loads previously clustered Habenula subtypes, and computes the
% average of each cluster. The program also then extrapolates the responses
% to 100s and performs smoothing.

clc;
load Habenula_data_unsmoothed.mat

%%
d_on_t_smoothed = smooth(mean(d_on_t));
d_off_t_smoothed = smooth(mean(d_off_t));
d_off_p_smoothed = smooth(mean(d_off_p));

v_on_t_smoothed = smooth(mean(v_on_t));
v_off_t_smoothed = smooth(mean(v_off_t));
v_off_p_smoothed = smooth(mean(v_off_p));

%%
n = {'d_on_t','v_on_t','d_off_t','v_off_t','d_off_p','v_off_p'};
names = {'D-ON-Tonic','V-ON-Tonic','D-OFF-Tonic','V-OFF-Tonic','D-OFF-Phasic','V-OFF-Phasic'};

toAdd_x = [30;35;40];

for i = 1:6
    eval(['x = ',n{i},'_smoothed;']);
    toAdd = pchip([toAdd_x;70;80],[x(toAdd_x);1;1],40:80);   
    x2 = [ones(20,1);x(1:39);toAdd'];
    eval([n{i},'_smoothed_100s = x2;']);
end

%%
clf;
for i = 1:6
    subplot(3,2,i);
    eval(['d = ',n{i},'_smoothed_100s;']);
    plot(d,'k','LineWidth',1.75);
    hold on;
    y_lim = ylim;
    rectangle('Position',[21,y_lim(1),20,y_lim(2)-y_lim(1)],'FaceColor',[1 0 0 0.2],'EdgeColor','none');
    ylim(y_lim); xlim([1 100]);
    grid minor;
    xlabel('Time');
    title(names{i});
    set(gca,'fontsize',13,'box','off');
    ylabel('Intensity F/F0');
end

