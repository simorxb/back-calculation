%% Run simulations for discrete time controllers (only clamping and general back-calculation)

% Define configurations
configs = {
    struct('name', 'PID - no anti-windup', 'ctrl_type', 0, 'color', '#0072BD');
    struct('name', 'PID - integral clamping', 'ctrl_type', 1, 'color', '#EDB120');
    struct('name', 'PID - back-calculation - classic', 'ctrl_type', 2, 'color', '#77AC30');
    struct('name', 'PID - back-calculation - general', 'ctrl_type', 3, 'color', '#4DBEEE')
};
results = struct([]);

% Loop through configurations
for i = 1:length(configs)
    ctrl_type = configs{i}.ctrl_type;

    % Load the model
    load_system('speed_control_disc');

    % Set the scenario for Signal Editor to "Scenario2"
    set_param('speed_control_disc/Signal Editor', 'ActiveScenario', 'Scenario2');

    % Run the model with the ith configuration
    simOut = sim("speed_control_disc", 'StopTime', '120');

    % Access the signals from out.logsout
    results(i).r = simOut.logsout.get('r').Values;
    results(i).F = simOut.logsout.get('F').Values;
    results(i).F_c = simOut.logsout.get('F_c').Values;
    results(i).z = simOut.logsout.get('z').Values;
    results(i).v = simOut.logsout.get('v').Values;

end

% Create animation of the results
animate_results(results, configs, 'PlaybackSpeed', 20, 'FrameRate', 30, 'SaveVideo', true, 'VideoPath', 'results_animation_disc_clamping_vs_bc.mp4');
