function Y = SEASP(A, k) 
% A: The Hyperspectral Datasets
% k: The number of selected bands
    [W, H, L] = size(A);
   
    for i = 1 : L - 1
        R(i) = corr2(A(:,:,i),A(:,:,i+1));
    end

    [~,y] = findpeaks(-R);   
    
    B = reshape(A, W * H, L);
 
    S =  Entrop(B)'; 
    
    num_y = length(y) + 1;
    count = 1;
    
    for i = 1 : num_y
          if i == 1
              subtract(i) = y(1) ;
          elseif i == num_y
              subtract(i) = L - y(i - 1);
          else
                subtract(i) = y(i) - y(i - 1);
           end
     end
     [sub, id] = sort(subtract , 'descend');

  if num_y < k     
       for i = 1 : num_y
             if id(i) == 1
                 index = 1;
                 [temp, temp_id] = sort(S(index : y(id(i))), 'descend');
                 num = (y(id(i)) - index + 1) / L * k;
             elseif id(i) == num_y
                 index = y(id(i)-1) + 1;
                 [temp, temp_id] = sort(S(index : L), 'descend');
                 num = (L - index + 1) / L * k;
             else 
                  index = y(id(i)-1)+1;
                  [temp, temp_id] = sort(S(index : y(id(i))), 'descend');
                  num = (y(id(i)) - index + 1) / L * k;
             end   
            if  num < 1
                num = 1;
            else
                num = round(num);  
            end
            temp_id = temp_id + index - 1;
            Y(:,count:count+num-1) = temp_id(1:num);
            count = count + num;
            
            if count > k
                break;
            end
            
       end
  else
         for i = 1 : k
              if id(i) == 1
                  [temp, temp_id] = sort(S(1 : y(1)), 'descend');
              elseif id(i) == num_y
	              [temp, temp_id] = sort(S(y(id(i)-1)+1 : L), 'descend');
	              temp_id = temp_id + y(id(i) - 1);
             else
                  [temp, temp_id] = sort(S(y(id(i)-1)+1 : y(id(i))), 'descend');
	              temp_id = temp_id + y(id(i) - 1);
              end
	          Y(:,count) = temp_id(1);
              count = count + 1;
         end   
  end 
  
      Y = sort(Y);
end
