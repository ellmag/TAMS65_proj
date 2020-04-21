function [model, mse] = all_subset(y,X)

[n nvar]= size(X);

MSe = [];
k = 0;
for i = 1:nvar
    combos = nchoosek([1:nvar],i);
    for j = 1:size(combos,1)
        k = k + 1;
        COMBOS{k} = combos(j,:);
        regr = regstats(y,X(:,combos(j,:)));
        MSe = [MSe regr.mse];
    end
end

[~ , model_ind] = min(MSe);

model = COMBOS{model_ind};
mse = MSe(model_ind);
end

    

