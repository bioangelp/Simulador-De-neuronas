function catalogoCalibrado = calibrarCatalogo(catalogo, barrido)
% CALIBRARCATALOGO Calibra cada uno de los 6 tipos para el barrido seleccionado

    catalogoCalibrado = catalogo;
    
    for i = 1:6
        tipo = catalogo(i);
        
        % Inyección de rampa en Class 1 y Class 2

       % solamente para mantener orden
        tipo.InEx = 1;
        
        % Simulación basal casi sin ruido
        [~, VV, ~] = neurona(barrido, 1, tipo, nan, 1);
        
        if max(VV) > 20
            picos = findpeaks(VV, 'MinPeakHeight', 20);
            conteoPks = length(picos);
        else
            conteoPks = 0.0001;
        end
        
        catalogoCalibrado(i).pks = conteoPks;
        catalogoCalibrado(i).InEx = 1;
    end
end

