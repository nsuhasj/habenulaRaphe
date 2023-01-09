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

% This function removes 10% of the data as a validation set and returns the
% rest as the training set.

function [data_cv_removed, cv_data] = removeDataForCrossVal(data,num_cv,cv_ind)

l = size(data,1);
num_to_rem = floor(l/num_cv);
rem_to_start = 1 + ((cv_ind-1)*num_to_rem);
rem_to_end = rem_to_start + num_to_rem - 1;
if cv_ind == num_cv
    rem_to_end = l;
end

data_cv_removed = data;
data_cv_removed(rem_to_start:rem_to_end,:) = [];
cv_data = data(rem_to_start:rem_to_end,:);

