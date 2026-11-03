function neuronType = construirNeuronas(cantidades, inhibitorias, nombres, catalogoCalibrado)
% CONSTRUIRPOBLACION Valida, ensambla y baraja el struct array neuronType (1x100)

    TOTAL_NEURONAS = 100;


    % Ensamblado por bloques
    plantilla = catalogoCalibrado(1);
    plantilla.InEx = 1;
    neuronType = repmat(plantilla, 1, TOTAL_NEURONAS);

    posicion = 1;
    for k = 1:6
        cant = cantidades(k);
        if cant == 0
            continue; 
        end
        
        inh = inhibitorias(k);
        exc = cant - inh;
        base = catalogoCalibrado(k);
        
        for e = 1:exc
            neuronType(posicion) = base;
            neuronType(posicion).InEx = 1;
            posicion = posicion + 1;
        end
        for i = 1:inh
            neuronType(posicion) = base;
            neuronType(posicion).InEx = -1;
            posicion = posicion + 1;
        end
    end

    % Barajado completo
    neuronType = neuronType(randperm(TOTAL_NEURONAS));
    save('neurontype.mat', 'neuronType');
end