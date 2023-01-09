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

% This function interpolates raphe responses at a resolution of 0.01s 
% for the unablated case, and the D-ON, V-ON and V-OFF ablation
% experiments. 

function data_pt01 = getRapheOutputForMLP(raphe_data)

data_pt01 = [];
for i = 1:4
    tmp = interp1(1:100,raphe_data(:,i),1:0.01:100)';
    data_pt01 = [data_pt01; tmp];
end

end
