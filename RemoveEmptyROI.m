%remove empty ROIs

bad_ROI = [];
for i = 1:size(roi_stack,1)
    if isempty(roi_stack(i).Position)
        bad_ROI = [bad_ROI; i];
    end
end
roi_stack(bad_ROI) = [];
save RIO_new roi_stack