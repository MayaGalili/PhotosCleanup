%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Function goal is to rename all photos in folder by its take date
%
% @ Maya Galili. Dec 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = rename_files_by_date_taken()
dir_nn = uigetdir();
dir_nn = [dir_nn '\'];
file_type = '.jpg';
files = dir([dir_nn '*' file_type]);

% Loop through each
for id = 1:length(files)
    
    % Get the file name (minus extension)
    [~, f] = fileparts(files(id).name);
    
    %  rename
    old_file_path = [dir_nn files(id).name];
    
    pic_info = imfinfo(old_file_path);
    if isfield(pic_info, 'DateTime')
        time_pic_taken = pic_info.DateTime;
        t = datetime(time_pic_taken, 'InputFormat','yyyy:MM:dd HH:mm:ss');
        new_f = datestr(t,'yyyymmdd_hhMMss');
    else
        new_f = datestr(files(id).date,'yyyymmdd_hhMMss');
    end
    new_file_path = [dir_nn new_f file_type];
    if ~strcmp(old_file_path, new_file_path)
        fprintf('rename: %s \n', old_file_path);
        while exist(new_file_path, 'file')
            new_file_path = [dir_nn new_f '_' int2str(randi(100)) file_type];
        end
        movefile(old_file_path, new_file_path);
    end
end

