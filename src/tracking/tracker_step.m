
function [newTargetPosition, bestScale] = tracker_step(net_x, s_x, s_z, scoreId, z_out, x_crops, pad_masks_x, targetPosition, window, p)
    % run a forward pass of the CNN
    %x_crops dims: 255x255x3x3 (W,H,RGB,Scale) (rgb and scale maybe are
    %swaped)
    net_x.eval([z_out, {'instance', x_crops}]); %Se mete en la red y se obtiene el mapa por correlación
    %x_crops es la zona de busqueda, con sus tres escalas
    %(imshow(uint8(x_crops(:,:,:,1))) )
    responseMaps = reshape(net_x.vars(scoreId).value, [p.scoreSize p.scoreSize p.numScale]);


    % init upsampled response map
    responseMapsUP = gpuArray(single(zeros(p.scoreSize*p.responseUp, p.scoreSize*p.responseUp, p.numScale)));
    % get the response map
    currentScaleID = ceil(p.numScale/2);
    % pick the response with the highest peak ratio
    bestScale = currentScaleID;
    bestPeak = -Inf;
    for s=1:p.numScale
        responseMapsUP(:,:,s) = imresize(responseMaps(:,:,s), p.responseUp, 'bicubic');
        thisResponse = responseMapsUP(:,:,s);
        % penalize change of scale
        if s~=currentScaleID
            thisResponse = thisResponse * p.scalePenalty;
        end
        thisPeak = max(thisResponse(:));
        if thisPeak > bestPeak
            bestPeak = thisPeak;
            bestScale = s;
        end
    end
    responseMap = responseMapsUP(:,:,bestScale);    %this is the one that we want to save
    bestScale
    %%%%%%%
%     string = sprintf('/home/aia/Matlab/cfnetMaster/data/responseMapsGT/%s/', p.video);
%     if ~exist(string,'dir')
%         mkdir(string);
%     end
%     string = sprintf('/home/aia/Matlab/cfnetMaster/data/responseMapsGT/%s/responseMap_%d', p.video, p.numFrame);
%     bestResponseMap = responseMaps(:,:,bestScale);
%     save(string,'bestResponseMap');
    %%%%%%
%     string = sprintf('/home/aia/Matlab/cfnetMaster/data/ResponseMapsBestScaleUP/%s/', p.video);
%     if ~exist(string,'dir')
%         mkdir(string);
%     end
%     string = sprintf('/home/aia/Matlab/cfnetMaster/data/ResponseMapsBestScaleUP/%s/responseMap_%d', p.video, p.numFrame);
%     save(string,'responseMap');
    %%%%%%%
    
    responseMap = responseMap - min(responseMap(:));

    % apply displacement-penalty window
    responseMap = responseMap / sum(responseMap(:));
    response_final = (1-p.wInfluence)*responseMap + p.wInfluence*window;
    
    if p.debug==true
        string = sprintf("mapa de la mejor escala, beastPeak = %.3f", bestPeak); %print network "confidence"
        figure(1);subplot(2,2,2);imshow(uint8(x_crops(:,:,:,1)));
        xlabel("zona de busqueda (una escala cualquiera de las 3)");
        subplot(2,2,3);imagesc(responseMap);xlabel(string);
        subplot(2,2,4);imagesc(response_final);xlabel("mapa final");
        pause(0.2);
    end
    
    %% update position and scale
    %Nueva posicion maximo del mapa por correlación obtenido
    [r_max, c_max] = find(response_final == max(response_final(:)), 1);
    [r_max, c_max] = avoid_empty_position(r_max, c_max, p);
    p_corr = [r_max, c_max];
    % displacement from the center in instance final representation ...
    disp_instanceFinal = p_corr - (p.scoreSize*p.responseUp + 1)/2;
    % ... in instance input ...
    disp_instanceInput = disp_instanceFinal * p.totalStride / p.responseUp;
    % ... in instance original crop (in frame coordinates)
    disp_instanceFrame = disp_instanceInput * s_x / p.instanceSize;
    % position within frame in frame coordinates
    newTargetPosition = targetPosition + disp_instanceFrame;
end

function [r_max, c_max] = avoid_empty_position(r_max, c_max, params)
    if isempty(r_max)
        r_max = ceil(params.scoreSize/2);
    end
    if isempty(c_max)
        c_max = ceil(params.scoreSize/2);
    end
end
