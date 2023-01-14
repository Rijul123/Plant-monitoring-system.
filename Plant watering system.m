clear all;
a = arduino('/dev/cu.usbserial-0001','Uno');
while 1
    date = datestr(now);
    initial = readVoltage(a,'A1'); // reading initial voltage from moisture sensor
    message = sprintf("Date: %s moisture level of the plant is: %f", date,initial);
    disp(message)
    threshhold = 1.8; // threshold voltage reading from sensor
    if initial > threshhold
        disp('The plant is thirsty.')
        moisture = readVoltage(a,'A1'); // higher voltage = drier soil
        while moisture > threshhold // water the plant until soil is moist enough
            writeDigitalPin(a,'D2',1); // turn on pump, to pump water
            pause(1.5);
            writeDigitalPin(a,'D2',0); // turn off pump
            pause(10);
            moisture = readVoltage(a,'A1'); // read moisture again after 10 seconds
            fprintf("Date: %s moisture level of the plant is: %f \n", datestr(now),moisture);
            if moisture > threshhold
                disp('the plant is still thirsty')
            end
        end
        disp('plant is now fine')
    
    else
        disp('the plant is fine')
    end
    pause(3600) // check the soil again in one hour
end // end of loop
