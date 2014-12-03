function [] = rss_trace_collect_continuous_txrx()

%% Read the global variables
mmWaveImage_GlobalVars;


%% Collect traces

% Azimuthal steps
azi_steps = ceil((azi_max_angle - azi_min_angle)/azi_angle_resolution);
elev_steps = ceil(((elev_max_angle - elev_min_angle)/elev_angle_resolution));

% How many locations to collect for the heat map?
num_locations = azi_steps*elev_steps;

% Heat map matrix
rss_heatmap = zeros(azi_steps, elev_steps);

Ts = 1/40.96e6;
t = [0:Ts:(WARPLab_txLength-1)*Ts].'; % Create time vector(Sample Frequency is Ts (Hz))
txData = exp(t*sqrt(-1)*2*pi*5e6);
wl_basebandCmd(WARPLab_node_tx,[WARPLab_RF_TX], 'write_IQ', txData);

wl_interfaceCmd(WARPLab_node_tx,WARPLab_RF_TX,'tx_en');
wl_basebandCmd(WARPLab_node_tx,WARPLab_RF_TX,'tx_buff_en');

wl_interfaceCmd(WARPLab_node_rx,WARPLab_RF_RX,'rx_en');
wl_basebandCmd(WARPLab_node_rx,WARPLab_RF_RX,'rx_buff_en');

azi_angle = azi_min_angle;
elev_angle = elev_min_angle;

% Reset motors: azimuth and elevation
reset = 0;
% serial_obj_azi = axis360_rotate(dev_id_azi, serial_obj_azi, azi_angle, reset, sport_default_params);
serial_obj_elev = axis360_rotate(dev_id_elev, serial_obj_elev, elev_angle, reset, sport_default_params);
pause(5);

for i = 1:azi_steps
    for j = 1:elev_steps
        num_pkt = 1;        
        while num_pkt <= packet_per_resolution
            WARPLab_eth_trig.send();
            rx_IQ = wl_basebandCmd(WARPLab_node_rx,[WARPLab_RF_RX],'read_IQ', 0, WARPLab_rxLength);
            rss_heatmap(i, j) = rss_heatmap(i, j) + mean(abs(rx_IQ));
            num_pkt = num_pkt + 1;
        end
        rss_heatmap(i, j) = rss_heatmap(i, j) / (num_pkt - 1);
        % Rotate elevation motor by steps
        elev_angle = elev_angle + elev_angle_resolution;
        % Rotate elevation motor
        serial_obj_elev = axis360_rotate(dev_id_elev, serial_obj_elev, -elev_angle, reset, sport_default_params);
        pause(0.2);
    end
    pause(1);
    elev_angle = 0;
    serial_obj_elev = axis360_rotate(dev_id_elev, serial_obj_elev, (elev_max_angle - elev_min_angle - 90 + elev_angle_resolution), reset, sport_default_params);
    % Rotate azimuth motor by steps
    azi_angle = azi_angle + azi_angle_resolution;
	% Rotate the azimuth motor
% 	serial_obj_azi = axis360_rotate(dev_id_azi, serial_obj_azi, azi_angle, reset, sport_default_params);
	prompt = sprintf('Move azimuth? (y/n)');
    c = input(prompt,'s');
    if (c == 'y' || c == 'Y')
        continue;
    else
        return;
    end
    
end

reset = 2;
% serial_obj_azi = axis360_rotate(dev_id_azi, serial_obj_azi, 0, reset, sport_default_params);
serial_obj_elev = axis360_rotate(dev_id_azi, serial_obj_elev, 0, reset, sport_default_params);

csvwrite('rss_heatmap_bg_wo_pccabinet.dat', rot90(rss_heatmap));

%% Trace write to file

% for num_pkt = trace_packet_removal_cnt+1:trace_packet_removal_cnt + trace_packet_count
%     fprintf('Trace count: %d\n', num_pkt-trace_packet_removal_cnt);
%     fwrite(trace_file_handle, trace_data(:, num_pkt), 'double');
% end
%                                                             
% fclose(trace_file_handle);

end