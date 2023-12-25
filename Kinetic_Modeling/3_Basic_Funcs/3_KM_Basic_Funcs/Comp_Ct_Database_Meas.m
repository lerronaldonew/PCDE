function [sort_val,sort_ind]=Comp_Ct_Database_Meas(true_database,Meas_Cts_temp)
%coder.gpu.kernelfun();

%true_database=single(ones(100000000,20));
%Meas_Cts_temp=double(ones(1,20));

%tic;
%[sort_val,sort_ind] = sort(sum(abs(gpuArray(true_database)-single(repmat(gpuArray(single(Meas_Cts_temp)), size(true_database,1),1))).^2,2));
%toc;

%tic;
%[sort_val,sort_ind] = sort(sum(abs(gpuArray(true_database)-single(repmat(gpuArray(Meas_Cts_temp), size(true_database,1),1))).^2,2));
%toc;

%tic;


tic;
[sort_val,sort_ind]= mink(sum( (true_database-Meas_Cts_temp).^(2),2 ),300);%toc;
toc;

%tic;
%size_db=size(true_database);
%%db_temp_gpu=gpuArray(single(zeros(size_db(1)/10,size_db(2))));
%repmat_gpu=gpuArray(repmat(single(Meas_Cts_temp),size_db(1)/10,1));
%%sum_gpu=gpuArray(single(zeros(size_db(1),1)));
%for b=1:1:10
%    db_temp_gpu=gpuArray(true_database(((b-1)*size_db(1)/10)+1:(size_db(1)/10)*b,:));
%    sum_gpu_temp=sum((db_temp_gpu-repmat_gpu).^(2), 2);   
%    if b==1
%        sum_gpu=sum_gpu_temp;
%    else
%        sum_gpu=cat(1,sum_gpu,sum_gpu_temp);
%    end
%end
%[sort_val,sort_ind]=sort(sum_gpu);
%toc;    

%db_temp=half(zeros(100000,size(true_database,2)));
%ind=half(zeros(size(Meas_Cts_temp,1),1));

%for i=1:1:size(Meas_Cts_temp,1)
    %db_temp=half(true_database( ((b-1)*100000+1):(b*100000),:));
%    [min_val,min_ind]=min( single(sum((true_database-repmat(Meas_Cts_temp(i,:), size(true_database,1),1)).^2,2)) );
%    ind(i,1)=half(min_ind+100000);
%end
%toc;







end