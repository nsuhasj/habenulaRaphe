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

% This program loads previously smoothened Habenula subtypes, interpolates their
% responses at a resolution of 0.01s. the program also sets the Habenula responses 
% to 0 for the ablation experiments and concatenates the four ablation
% versions together to produce a matrix of size 39604*6

clc;
load Habenula_data_smoothed.mat;
cell_types = {'d_on_t','d_off_t','d_off_p','v_on_t','v_off_t','v_off_p'};
data_pt01s = zeros(9901,6);

for i = 1:6
    eval(['d = ',cell_types{i},'_smoothed_100s;']);
    tmp = interp1(1:100,d,1:0.01:100)';
    data_pt01s(:,i) = tmp;
end

%%
ablations = [...
    1 1 1 1 1 1;...
    0 1 1 1 1 1;...
    1 1 1 0 1 1;...
    1 1 1 1 0 0];

%%
hb_data_pt01s_abls = [];

for i = 1:4
    tmp = repmat(ablations(i,:),9901,1);
    tmp = tmp.*data_pt01s;
    hb_data_pt01s_abls = [hb_data_pt01s_abls;tmp];
end
%%
csvwrite('hb_all_for_mlp.csv',hb_data_pt01s_abls);
%%
clf;
for i = 1:6
    subplot(6,1,i);
    plot(hb_data_pt01s_abls(:,i)); grid minor;
end
