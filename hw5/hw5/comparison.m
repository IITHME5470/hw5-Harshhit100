clc; clear; close all;

% Define grid size (change accordingly)
nx = 800;  % Total number of grid points in x-direction
ny = 800;  % Total number of grid points in y-direction

% Initialize matrices
parallel_solution = NaN(nx, ny); % Global matrix for parallel run
serial_solution = NaN(nx, ny);   % Global matrix for serial run

%% Step 1: Read and Combine Parallel Files
parallel_files = dir('parallel_solution_10steps_*.dat');

for file = parallel_files'
    filename = file.name;
    data = load(filename);
    
    % Extract indices and values
    i = data(:,1) + 1; % Convert to 1-based index
    j = data(:,2) + 1;
    T = data(:,3);
    
    % Store in global matrix
    for k = 1:length(i)
        parallel_solution(i(k), j(k)) = T(k);
    end
end

%% Step 2: Load Serial Solution
serial_data = load('serial_solution_10steps.dat');
i_serial = serial_data(:,1) + 1;  % Convert to 1-based index
j_serial = serial_data(:,2) + 1;
T_serial = serial_data(:,3);

% Fill serial solution matrix
for k = 1:length(i_serial)
    serial_solution(i_serial(k), j_serial(k)) = T_serial(k);
end

%% Step 3: Compute Differences
differences = abs(serial_solution - parallel_solution);

% Compute min, max, and average difference
max_diff = max(differences(:));
min_diff = min(differences(:));
avg_diff = mean(differences(:));

%% Step 4: Display Results
fprintf('Comparison of Serial and Parallel Runs After 10 Time Steps:\n');
fprintf('-------------------------------------------------------------\n');
fprintf('Maximum Difference: %.24e\n', max_diff);
fprintf('Minimum Difference: %.24e\n', min_diff);
fprintf('Average Difference: %.24e\n', avg_diff);

% Check if differences are within machine precision
tolerance = eps;
if max_diff < tolerance
    fprintf('\nAll differences are within machine precision.\n');
else
    fprintf('\nSome differences exceed machine precision! Investigate further.\n');
end
