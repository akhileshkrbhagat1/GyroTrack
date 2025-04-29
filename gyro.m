% --- Real-time UDP Gyroscope Data Plotter ---

% --- Configuration ---
udpPort = 5005;           % Port to listen on
sampleRate = 10;          % Hz
plotDuration = 30;        % Seconds to display

% --- Setup UDP Receiver ---
fprintf('Setting up UDP receiver on port %d...\n', udpPort);
try
    u = udpport("localport", udpPort);  % Setup UDP port (MATLAB R2020b+)
    fprintf('UDP receiver ready.\n');
catch ME
    fprintf('Error: %s\n', ME.message);
    return;
end

% --- Setup Plots ---
figure('Name', 'Real-time Gyroscope Data');

% X-Axis Plot
subplot(2, 2, 1);
hPlotX = animatedline('Color', 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Gyroscope X (rad/s)');
title('Gyroscope X-Axis');
grid on;
legend('Gyro X');

% Y-Axis Plot
subplot(2, 2, 2);
hPlotY = animatedline('Color', 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Gyroscope Y (rad/s)');
title('Gyroscope Y-Axis');
grid on;
legend('Gyro Y');

% Z-Axis Plot
subplot(2, 2, 3);
hPlotZ = animatedline('Color', 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Gyroscope Z (rad/s)');
title('Gyroscope Z-Axis');
grid on;
legend('Gyro Z');

% Overall Magnitude Plot
subplot(2, 2, 4);
hPlotMagnitude = animatedline('Color', 'm', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Gyroscope Magnitude (rad/s)');
title('Gyroscope Overall Magnitude');
grid on;
legend('Magnitude');

% Buffers for storing data
timeBuffer = [];
xBuffer = [];
yBuffer = [];
zBuffer = [];
magnitudeBuffer = [];

maxSamples = sampleRate * plotDuration;
t = 0;

fprintf('Listening for UDP data...\nPress Ctrl+C to stop.\n');

% --- Main Loop ---
while true
    if u.NumBytesAvailable > 0
        % Receive and convert data to char array
        rawData = read(u, u.NumBytesAvailable, 'uint8');
        dataStr = native2unicode(rawData, 'UTF-8');  % Convert bytes to text using UTF-8 encoding
        
        % Debug: Check the received data
        disp('Received Data:');
        disp(dataStr);  % Display the raw data for debugging

        % Ensure dataStr is a valid string
        if ischar(dataStr) && ~isempty(dataStr)
            % Find all 'GYRO' entries in the data
            gyroIdx = strfind(dataStr, 'GYRO,');
            for i = 1:length(gyroIdx)
                startIdx = gyroIdx(i) + 5;  % Skip the 'GYRO,' part
                nextAcc = strfind(dataStr(startIdx:end), 'ACC,');  % Look for 'ACC,' to determine end of gyro data
                nextGyro = strfind(dataStr(startIdx:end), 'GYRO,');  % Look for next 'GYRO,' entry

                endIdx = length(dataStr);
                if ~isempty(nextAcc)
                    endIdx = min(endIdx, startIdx + nextAcc(1) - 2);
                end
                if ~isempty(nextGyro)
                    endIdx = min(endIdx, startIdx + nextGyro(1) - 2);
                end

                if startIdx <= endIdx
                    segment = dataStr(startIdx:endIdx);
                    parts = strsplit(segment, ',');  % Split the data by commas

                    % Extract X, Y, Z axis values (1st, 2nd, and 3rd entries)
                    if length(parts) >= 3
                        x = str2double(parts{1});  % Gyroscope X-axis is the first entry
                        y = str2double(parts{2});  % Gyroscope Y-axis is the second entry
                        z = str2double(parts{3});  % Gyroscope Z-axis is the third entry

                        if ~isnan(x) && ~isnan(y) && ~isnan(z)
                            % Calculate magnitude (Euclidean norm)
                            magnitude = sqrt(x^2 + y^2 + z^2);

                            % Update time
                            t = t + 1/sampleRate;  
                            timeBuffer(end+1) = t;
                            xBuffer(end+1) = x;
                            yBuffer(end+1) = y;
                            zBuffer(end+1) = z;
                            magnitudeBuffer(end+1) = magnitude;

                            % Trim buffers to maxSamples
                            if length(timeBuffer) > maxSamples
                                timeBuffer = timeBuffer(end-maxSamples+1:end);
                                xBuffer = xBuffer(end-maxSamples+1:end);
                                yBuffer = yBuffer(end-maxSamples+1:end);
                                zBuffer = zBuffer(end-maxSamples+1:end);
                                magnitudeBuffer = magnitudeBuffer(end-maxSamples+1:end);
                            end

                            % Update plots
                            clearpoints(hPlotX);
                            addpoints(hPlotX, timeBuffer, xBuffer);
                            
                            clearpoints(hPlotY);
                            addpoints(hPlotY, timeBuffer, yBuffer);
                            
                            clearpoints(hPlotZ);
                            addpoints(hPlotZ, timeBuffer, zBuffer);
                            
                            clearpoints(hPlotMagnitude);
                            addpoints(hPlotMagnitude, timeBuffer, magnitudeBuffer);

                            drawnow limitrate;
                        end
                    end
                end
            end
        else
            fprintf('Error: Received data is not a valid string or is empty.\n');
        end
    end
end