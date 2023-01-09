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

% This function performs extrapolation and smoothing of the 100s characteristic 
% responses for the unablated case, and the D-ON, V-ON and V-OFF ablation
% experiments. 

function smooth_data = smoothExtrapolateRapheData(data,toAdd_x)

data2 = [];
for i = 1:4
    x = smooth(data(i,:)./data(i,1));
    toAdd = pchip([toAdd_x;60;80],[x(toAdd_x);1;1],31:80);
    x2 = [ones(20,1);x(1:30);toAdd'];
    data2(:,i) = x2;
end

tmp = smooth(data2(1:100,1));
data2(1:100,1) = tmp;

tmp = smooth(data2(1:100,2));
data2(1:100,2) = tmp;

tmp = smooth(data2(1:100,3));
data2(1:100,3) = tmp;

tmp = smooth(data2(1:100,4));
data2(1:100,4) = tmp;

smooth_data = data2;
end