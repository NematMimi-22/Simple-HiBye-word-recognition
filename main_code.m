arduino=serial('com3','BaudRate',9600);
fopen(arduino);
delete(arduino)
clear arduino
arduino=serial('com3','BaudRate',9600);
fopen(arduino);

recObj = audiorecorder(44000, 24, 1);% record at Fs=44khz, 24 bits per sample
for i=1:1
fprintf('Start speaking for audio please #%d\n',i)
recordblocking(recObj, 3); % record for 3 seconds
fprintf('Audio #%d ended\n',i)
%play(recObj);

y = getaudiodata(recObj); %get the voice to make calculation on it
y = y - mean(y); %shift for signal by subtract the avarge dc value
file_name0 = sprintf('test-HiBye/HB%d.wav',i); %how we name records file
audiowrite(file_name0, y, recObj.SampleRate);
file_name1 = sprintf('test-MaleFemale/FM%d.wav',i); %how we name records file
audiowrite(file_name1, y, recObj.SampleRate);

%figure
%plot(x);
end




training_files_female = dir('C:\Users\hp\Desktop\dsp project\train-female\*.wav');
training_files_male = dir('C:\Users\hp\Desktop\dsp project\train-male\*.wav');
training_files_hi = dir('C:\Users\hp\Desktop\dsp project\train\hi\*.wav');
training_files_bye = dir('C:\Users\hp\Desktop\dsp project\train\bye\*.wav');
testing_files_hibye = dir('C:\Users\hp\Desktop\dsp project\test-HiBye\*.wav');
testing_files_femalemale = dir('C:\Users\hp\Desktop\dsp project\test-MaleFemale\*.wav');


% read the 'female' training files and calculate the energy for each one.
data_female = [];
for i = 1:length(training_files_female)
file_path = strcat(training_files_female(i).folder,'\',training_files_female(i).name);
[y,fs] = audioread(file_path);
%divide the signal into 5 parts and calculate the ZCR for each part
ZCR_female1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_female2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_female3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_female4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_female5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);
ZCR_female = [ZCR_female1 ZCR_female2 ZCR_female3 ZCR_female4 ZCR_female5 energy];
data_female = [data_female ;ZCR_female];
end
ZCR_female=mean(data_female);
%fprintf('The ZCR of female is: \n');
%disp(ZCR_female);


% read the 'male' training files and calculate the energy for each one.
data_male = [];
for i = 1:length(training_files_male)
file_path = strcat(training_files_male(i).folder,'\',training_files_male(i).name);
[y,fs] = audioread(file_path);

%divide the signal into 5 parts and calculate the ZCR for each part
ZCR_male1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_male2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_male3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_male4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_male5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);

ZCR_male = [ZCR_male1 ZCR_male2 ZCR_male3 ZCR_male4 ZCR_male5 energy];

data_male = [data_male ;ZCR_male];
end
ZCR_male=mean(data_male);
%fprintf('The ZCR of male is: \n');
%disp(ZCR_male);


% read the 'Female male' tesing files and calculate the energy 

for i = 1:length(testing_files_femalemale )
file_path = strcat(testing_files_femalemale (i).folder,'\',testing_files_femalemale(i).name);
[y,fs] = audioread(file_path);

%divide the signal into 5 parts and calculate the ZCR for each part
ZCR_femalemale1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_femalemale2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_femalemale3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_femalemale4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_femalemale5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);

y_ZCR = [ZCR_femalemale1 ZCR_femalemale2 ZCR_femalemale3 ZCR_femalemale4 ZCR_femalemale5  energy];
    %make a comparative based on cosine distance
    if(pdist([y_ZCR;ZCR_female],'cosine') < pdist([y_ZCR;ZCR_male],'cosine'))
         fprintf('Test file [FM] #%d categorized as female \n',i);
          female = 2;
    else
         fprintf('Test file [FM] #%d categorized as male \n',i);
         male = 2;
    end
    
   
end





% read the 'hi' training files and calculate the energy for each one.
data_hi = [];
for i = 1:length(training_files_hi)
file_path = strcat(training_files_hi(i).folder,'\',training_files_hi(i).name);
[y,fs] = audioread(file_path);
%divide the signal into 5 parts and calculate the ZCR for each part
ZCR_hi1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_hi2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_hi3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_hi4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_hi5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);
ZCR_hi = [ZCR_hi1 ZCR_hi2 ZCR_hi3 ZCR_hi4 ZCR_hi5  energy];
data_hi = [data_hi ;ZCR_hi];
end
ZCR_hi=mean(data_hi);
%fprintf('The ZCR of hi is: \n');
%disp(ZCR_hi);

% read the 'bye' training files and calculate the energy for each one.
data_bye = [];
for i = 1:length(training_files_bye)
file_path = strcat(training_files_bye(i).folder,'\',training_files_bye(i).name);
[y,fs] = audioread(file_path);

%divide the signal into 5 parts and calculate the ZCR for each part
ZCR_bye1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_bye2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_bye3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_bye4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_bye5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);

ZCR_bye = [ZCR_bye1 ZCR_bye2 ZCR_bye3 ZCR_bye4 ZCR_bye5  energy];

data_bye = [data_bye ;ZCR_bye];
end
ZCR_bye=mean(data_bye);
%fprintf('The ZCR of bye is: \n');
%disp(ZCR_bye);




% read the 'Hi bye' tesing files and calculate the energy 

for i = 1:length(testing_files_hibye)
file_path = strcat(testing_files_hibye(i).folder,'\',testing_files_hibye(i).name);
[y,fs] = audioread(file_path);

%divide the signal into 5 parts and calculate the ZCR for each part

ZCR_hibye1 = mean(abs(diff(sign(y(1:floor(end/5))))))./2;
ZCR_hibye2 = mean(abs(diff(sign(y(floor(end/5):floor (end*2/5))))))./2;
ZCR_hibye3 = mean(abs(diff(sign(y(floor(end*2/5):floor (end*3/5))))))./2;
ZCR_hibye4 = mean(abs(diff(sign(y(floor(end*3/5):floor (end*4/5))))))./2;
ZCR_hibye5 = mean(abs(diff(sign(y(floor(end*4/5):end)))))./2;
%calculate the energy
energy = sum(y.^2);

y_ZCR = [ZCR_hibye1 ZCR_hibye2 ZCR_hibye3 ZCR_hibye4 ZCR_hibye5  energy];
    %make a comparative based on cosine distance
    if(pdist([y_ZCR;ZCR_hi],'cosine') < pdist([y_ZCR;ZCR_bye],'cosine'))
        fprintf('Test file [HB] #%d categorized as hi \n',i);
        hi = 1;
        
    else
        fprintf('Test file [HB] #%d categorized as bye \n',i);
        bye = 1;
    end


    
    
%how we sent a msg to arduino
    
    
%if hi and female sent a amsg to arduino
if (hi == 1 && female == 2)
      while 1
       fprintf(arduino, '%d',1);
      end
end




%if hi and male sent a amsg to arduino
if ( hi == 1 && male == 2)
      while 1
          fprintf(arduino, '%d', 2);
      end
end







%if bye and female sent a amsg to arduino
 if (bye == 2 && female ==2)
        while 1
        fprintf(arduino, '%d', 3);
        end
 end
 
 
 
 
 
 
%if hi and male sent a amsg to arduino
 if (bye == 2 && male == 2)
        while 1
        fprintf(arduino, '%d', 4);
        end
end