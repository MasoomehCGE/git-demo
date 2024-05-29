clc;clear;close
%% data reading
opts = delimitedTextImportOptions("NumVariables", 14);

opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [12, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["soc_tmp", "voltage_tmp", "capacity_tmp", "R0_tmp", "tau0_tmp", "RC_tmp", "tau_RC_tmp", "sigma_Ohms05", "k_tmp", "R_diffusion_Ohm", "R_squared"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

cellName = 0042;
current = [0.34, 1, 2, 3, 4, 5, 6];

data_read_tmp = struct([]);
for ii = 1:length(current)

filename = sprintf("dataset\\Parameters_of_%04d_DCH_C-Rate_%0.2f A.csv", cellName, current(ii));
data_read = readtable(filename, opts);
data_read.capacity_tmp = data_read.capacity_tmp - min(data_read.capacity_tmp);
data_read_tmp(ii,1).data = data_read;
end

clear opts

%% 

figure(1)
for ii = 1:length(current)
    plot(data_read_tmp(ii, 1).data.capacity_tmp, data_read_tmp(ii,1).data.voltage_tmp, 'LineWidth', 2, 'DisplayName', sprintf("charge %0.2f A", current(ii)))
    
hold on
end
grid on
legend( 'show', 'Location', 'best' )
xlabel('SoC'); ylabel('Voltage | V')
hold off
%%
addpath(genpath("C:\Users\mshahafv\Desktop\Research Proj_1\dataset\ICI_dataset\Python_results"))

figure(2)
for ii = 1:length(current)
out = OCV(current(ii), data_read_tmp(ii, 1).data.R0_tmp, data_read_tmp(ii, 1).data.tau0_tmp, data_read_tmp(ii, 1).data.RC_tmp,...
    data_read_tmp(ii, 1).data.tau_RC_tmp, data_read_tmp(ii, 1).data.k_tmp,...
    data_read_tmp(ii, 1).data.soc_tmp, data_read_tmp(1, 1).data.capacity_tmp, data_read_tmp(1, 1).data.voltage_tmp);
plot(out(1, :), out(2, :), 'o', 'DisplayName', sprintf("charge %0.2f A", current(ii)))
hold on
end
grid on
legend( 'show', 'Location', 'best' )
xlabel('SoC'); ylabel('Voltage | V')
hold off
%%
