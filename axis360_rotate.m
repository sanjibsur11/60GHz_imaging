% Rotator function for Axis 360 control
% 
% Author: Sanjib Sur
% Institute: University of Wisconsin - Madison
% 
% Input
% dev_id: Device specific identifier to controller it through PC
% axis360: serial obj opened through MATLAB
% offset_ang: rotating offset from the current position, unit is in deg.
% reset:  0 - nothing; 1 - to reset the controller; 2 - close the serial
% obj.
% 
% Output: Rotates the Controller, return the new state of the obj
% 
% Comments: Rotator function for fine-grained control of Axis360.
% 

function axis360_out = axis360_rotate(dev_id, axis360, offset_ang, reset, default_params)
	% If the serial object is not opened, open it first 
	if isempty(axis360)
		axis360 = serial(dev_id);
		set(axis360, 'BaudRate', default_params.baud_rate);
		fopen(axis360);
        % Manual mode reading from the serial obj.
		axis360.ReadAsyncMode = 'manual';
		readasync(axis360);
		% Set the pulse rate
		fprintf(axis360, sprintf('pr 1 %d\r\n', default_params.pulse_rate));
		print_serial_data(dev_id, axis360);
		fprintf(axis360, sprintf('zm 1\r\n'));	
		print_serial_data(dev_id, axis360);
        pause(2);
	end
	% Reset the motor
	if reset == 1
		print_serial_data(dev_id, axis360);
        fprintf(axis360, sprintf('zm 1\r\n'));
		print_serial_data(dev_id, axis360);
    elseif reset == 2
        fclose(axis360);
        delete(axis360);
    else
		print_serial_data(dev_id, axis360);
		% Convert to motor angle
		angle = round(offset_ang/360*default_params.angle_factor);
		fprintf(axis360, sprintf('mm 1 %d\r\n', angle));
		print_serial_data(dev_id, axis360);
	end
	% Assign new state of the serial obj to output
	axis360_out = axis360;
end


% Prints the serial object data
function [] = print_serial_data(dev_id, axis360)
	if isempty(axis360)
		fprintf('Serial obj. not ready for communication!\n', dev_id);
		return;
	end
	while(axis360.BytesAvailable>0)
		serialdata = fscanf(axis360);
		fprintf('%s\n', serialdata);
	end
end
