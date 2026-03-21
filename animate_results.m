function animate_results(results, configs, varargin)
%ANIMATE_RESULTS Animate controller responses against a fixed setpoint.
%
% The setpoint is fully visible from the first frame while each
% controller response is progressively revealed over time.
%
% Optional name-value arguments:
%   'PlaybackSpeed' (default 0.25) : 1.0 = realtime, 0.25 = 4x slower
%   'FrameRate'     (default 30)   : animation refresh rate in FPS
%   'SaveVideo'     (default false): save MP4 video if true
%   'VideoPath'     (default "results_animation.mp4")

p = inputParser;
addParameter(p, 'PlaybackSpeed', 0.25, @(x) isnumeric(x) && isscalar(x) && x > 0);
addParameter(p, 'FrameRate', 30, @(x) isnumeric(x) && isscalar(x) && x > 0);
addParameter(p, 'SaveVideo', false, @(x) islogical(x) && isscalar(x));
addParameter(p, 'VideoPath', "results_animation.mp4", @(x) isstring(x) || ischar(x));
parse(p, varargin{:});

playbackSpeed = p.Results.PlaybackSpeed;
frameRate = p.Results.FrameRate;
saveVideo = p.Results.SaveVideo;
videoPath = string(p.Results.VideoPath);

if isempty(results) || isempty(configs)
    error('results and configs must not be empty.');
end

% Use reference signal from first simulation.
tRef = results(1).r.Time(:);
yRef = results(1).r.Data(:);
tStart = tRef(1);
tEnd = tRef(end);

% Animation timeline.
totalDuration = tEnd - tStart;
animDuration = totalDuration / playbackSpeed;
nFrames = max(2, ceil(animDuration * frameRate));
tFrames = linspace(tStart, tEnd, nFrames);

fig = figure('Color', 'k', 'Position', [100 100 800 600]);
ax = axes(fig);
hold(ax, 'on');

% Fixed reference line (always fully visible).
hRef = plot(ax, tRef, yRef, '--', ...
    'LineWidth', 2, ...
    'DisplayName', 'Setpoint', ...
    'Color', '#D95319');

% Animated response lines.
nSignals = numel(configs);
hSignals = gobjects(nSignals, 1);
for i = 1:nSignals
    hSignals(i) = plot(ax, nan, nan, ...
        'LineWidth', 2, ...
        'DisplayName', configs{i}.name, ...
        'Color', configs{i}.color);
end

grid(ax, 'on');
ylabel(ax, 'Speed (m/s)');
xlabel(ax, 'Time (s)');
legend([hSignals; hRef], 'TextColor', 'w', 'Color', 'k', ...
    'EdgeColor', [0.5 0.5 0.5], 'LineWidth', 1, ...
    'FontSize', 10, 'Location', 'best');
ax.Color = 'k';
ax.GridColor = 'w';
ax.GridAlpha = 0.3;
ax.XColor = 'w';
ax.YColor = 'w';
xlim(ax, [tStart tEnd]);

% Keep y-limits stable during animation.
yMin = min(yRef);
yMax = max(yRef);
for i = 1:nSignals
    yMin = min(yMin, min(results(i).v.Data(:)));
    yMax = max(yMax, max(results(i).v.Data(:)));
end
if yMin == yMax
    yPad = max(1, abs(yMin) * 0.1);
else
    yPad = 0.05 * (yMax - yMin);
end
ylim(ax, [yMin - yPad, yMax + yPad]);

videoObj = [];
if saveVideo
    videoObj = VideoWriter(videoPath, 'MPEG-4');
    videoObj.FrameRate = frameRate;
    open(videoObj);
end

for k = 1:nFrames
    tNow = tFrames(k);
    for i = 1:nSignals
        tSig = results(i).v.Time(:);
        ySig = results(i).v.Data(:);
        idx = tSig <= tNow;

        if any(idx)
            set(hSignals(i), 'XData', tSig(idx), 'YData', ySig(idx));
        else
            set(hSignals(i), 'XData', nan, 'YData', nan);
        end
    end

    drawnow;
    if saveVideo
        writeVideo(videoObj, getframe(fig));
    end
end

if saveVideo
    close(videoObj);
end

hold(ax, 'off');
end
