%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function goal is to find similar pictures and mark them by adding '_' as prefixs.
%  If not sure - the program will show the 2 photos and ask the user.
%
% @ Maya Galili. Dec 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function files = find_similar_pics(files)

[files, dir_nn] = choose_folder();

prev_sz = -1;
prev_nm = '';
pics_to_delete_sz = 0;

% Loop through each pic
for id = 1:height(files)
    this_pic = files(id,:);
    curr_sz = this_pic.bytes;
    curr_nm = this_pic.name{:};
	
    if prev_sz == curr_sz
		[pics_to_delete_sz, pics_to_delete_sz] = compar_photos(dir_nn, curr_nm, prev_nm, pics_to_delete_sz);
    end
    
    prev_sz = curr_sz;
    prev_nm = curr_nm;
    prev_dir = curr_dir;
end
fprintf('you can delete %d files [now starting with ''_'']! \n', pics_to_delete_sz);

end

function [files, dir_nn] = choose_folder()
dir_nn = uigetdir();
dir_nn = [dir_nn '\'];
files = dir([dir_nn '*.jpg']);
files = sortrows(struct2table(files),'bytes','ascend');
end


function [pics_to_delete_sz, pics_to_delete_sz] = compar_photos(dir_nn, curr_nm, prev_nm, pics_to_delete_sz)
        curr_file_path = [dir_nn curr_nm];
        prev_file_path = [dir_nn prev_nm];
        [Image1,map1]=imread(curr_file_path);
        [Image2,map2]=imread(prev_file_path);
        
        %  if identicle - add prefix without asking
        if (isequal(Image1,Image2))
			[pics_to_delete_sz] = rename_diplicated_photo(prev_file_path, dir_nn, prev_nm, curr_nm, pics_to_delete_sz);
        else
			[pics_to_delete_sz] = ask_user_approv(Image1, map1, Image2, map2, prev_file_path, dir_nn, prev_nm, curr_nm, pics_to_delete_sz);
        end
		end
		
%  present the 2 pics and ask the user
function [pics_to_delete_sz] = ask_user_approv(Image1, map1, Image2, map2, prev_file_path, dir_nn, prev_nm, curr_nm, pics_to_delete_sz)
            figure();
            subplot(1, 2, 1), imshow(Image1, map1)
            subplot(1, 2, 2), imshow(Image2, map2)
			
            choice = menu('Pictures Are The Same?','Yes','No');
            if choice==2 || choice==0
                fprintf('Leave Both Picures! \n');
            else
				[pics_to_delete_sz] = rename_diplicated_photo(prev_file_path, dir_nn, prev_nm, curr_nm, pics_to_delete_sz);
            end
            close();
			end

function [pics_to_delete_sz] = rename_diplicated_photo(prev_file_path, dir_nn, prev_nm, curr_nm, pics_to_delete_sz)
            fprintf('%s and %s are equal - please delete!! \n', curr_nm, prev_nm);
                movefile(prev_file_path, [dir_nn '_' prev_nm])
                pics_to_delete_sz = pics_to_delete_sz + 1;
				end