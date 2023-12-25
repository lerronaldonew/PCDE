function [params_10_AUC]=Rank_AUC_Multi(Ct_DB_Slice,Fitted_Meas_Slice,params_300_Slice)

%% Calc. AUC
%for i=1:1:size(Ct_DB,1)
%    AUC_Cts(i,:)=trapz(PI_Time_fine,Ct_DB(i,:),2); 
%end
Num_Vox=size(Ct_DB_Slice,3);

for v=1:1:Num_Vox
    Ct_DB_AUC(:,v)=sum(Ct_DB_Slice(:,:,v),2);
end

%% Calc. AUC for Noisy data
%AUC_Noisy=trapz(PI_Time_fine,Fitted_Noisy,2);
%AUC_Noisy=repmat(AUC_Noisy,size(Ct_DB,1),1);

for v=1:1:Num_Vox
    Meas_AUC(1,v)=sum(Fitted_Meas_Slice(:,v));
end


%% Sorting
parfor v=1:1:Num_Vox
    if Ct_DB_AUC(:,v)==0
        sort_ind_temp=zeros(300,1,'single');
    else
        [sort_val_temp,sort_ind_temp]=sort(abs(Ct_DB_AUC(:,v)-Meas_AUC(1,v)));
    end
    sort_ind_AUC(:,v)=sort_ind_temp;
end

parfor v=1:1:Num_Vox
    if sort_ind_AUC(:,v)==0
        params_10_AUC(:,v)=zeros(10,1,'single');
    else
        temp=params_300_Slice(sort_ind_AUC(:,v),v);
        params_10_AUC(:,v)=temp(1:10);
    end  
end

end