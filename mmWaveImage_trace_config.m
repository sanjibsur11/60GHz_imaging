% Trace collection
% 
% Author: Sanjib Sur
% Institute: University of Wisconsin - Madison
% 
% Comments: 


%% Basic control
DEBUG_ON = 1;


%% Cinemoco device related
dev_id_azi = 'COM6';
dev_id_elev = 'COM7';

serial_obj_azi = [];
serial_obj_elev = [];

% Serial port default parameters
sport_default_params = [];
sport_default_params.baud_rate = 57600;
sport_default_params.pulse_rate = 5000;
sport_default_params.angle_factor = 32000;


%% Angle related variables
% Azimuthal angle resolution by 1 deg
azi_angle_resolution = 1;
% Max. angle
azi_min_angle = 0;
% Min. angle
azi_max_angle = 60;

% Elevation angle resolution by 1 deg
elev_angle_resolution = 1;
% Max. angle
elev_min_angle = 0;
% Min. angle
elev_max_angle = 60;


%% Trace collection/procedure variables

% How many packets to collect from one resolution i.e. (r, theta, phi)
packet_per_resolution = 50;

% Trace file config
trace_dir = 'C:\Users\Xinyu Zhang\Desktop\Sanjib\60GHz_imaging\traces/body_shape';
trace_file_name = 'location';

% Collect traces on different dates
data_string = date;
trace_dir_wdate = sprintf('%s/%s', trace_dir, data_string);
% If the directory does not exist, create it
if ~exist(trace_dir_wdate, 'dir')
    mkdir(trace_dir, data_string);
end
trace_file = sprintf('%s/%s.dat', trace_dir_wdate, trace_file_name);

% Make sure the previous file does not get overwritten while collecting
% the trace data
if exist(trace_file, 'file')
    prompt = sprintf('%s\n file exists! Do you want to overwrite? (y/n)', trace_file);
    c = input(prompt,'s');
    if (c == 'y' || c == 'Y')
        % Delete the existing file and open a new file in append mode
        fid = fopen(trace_file, 'w');
        fclose (fid);
        trace_file_handle = fopen(trace_file, 'a');
    else
        break;
    end
else
    trace_file_handle = fopen(trace_file, 'w');    
end