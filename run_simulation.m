%% Run simulations

% Define configurations
configs = {
    struct('name', 'PID - no anti-windup', 'ctrl_type', 0, 'color', '#0072BD');
    struct('name', 'PID - back-calculation - classic', 'ctrl_type', 1, 'color', '#EDB120');
    struct('name', 'PID - back-calculation - general', 'ctrl_type', 3, 'color', '#77AC30');
    struct('name', 'PID - back-calculation - general - discrete time', 'ctrl_type', 4, 'color', '#4DBEEE')
};
results = struct([]);

% Loop through configurations
for i = 1:length(configs)
    ctrl_type = configs{i}.ctrl_type;

    % Run the model with the ith configuration
    simOut = sim("speed_control");

    % Access the signals from out.logsout
    results(i).r = simOut.logsout.get('r').Values;
    results(i).F = simOut.logsout.get('F').Values;
    results(i).F_c = simOut.logsout.get('F_c').Values;
    results(i).z = simOut.logsout.get('z').Values;
    results(i).v = simOut.logsout.get('v').Values;

end