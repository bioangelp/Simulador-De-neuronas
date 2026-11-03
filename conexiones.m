function [eferencias, aferencias] = conexiones()
   % se crea un randomizador de numeros del 1 al 100, 4 veces para cada
   % neurona, estasa son las eferencias que tendra cada neuronaclear
    reset = true;
    while reset
        clear eferencias
        eferencias{100} = 0;
        for n = 1:100 
            eferencias{n} = randi([1 100], 1, 4); 
        end
    
        %Encontrar todas las neuronas que le hablan a neurona (n)
    
        clear aferencias
        aferencias{100} = 0;
        for n = 1:100
            %se saca la posicion y se divide entre 4 para saber el # de
            %neurona que tiene esa aferencia de n.
            aferencias{n} = floor(((find([eferencias{:}] == n)-1)/4) + 1); 
            %Osea que las posiciones van del 1 al 400 divididos en grupos
            %de 4, el menos uno es para convertirlos en grupso de 3 que
            %cuando lo dividas entre 4 den un numero decimal 0.75 que al
            %redondear hacia abajo te da 0, mas 1 te da la verdadera
            %posicion de la neurona
        end
        %si por alguna probabilidad extraña (ya vi que si pasa), la neurona no tiene
        %ninguna aferencia, se repite el proceso de aleatoreidad hasta que
        %se cumpla el requisito
        for n = 1:100
            if isempty(aferencias{n})
                %disp("again")
                break
            end
            if n == 100
                reset = false; 
            end
        end
        
    end

      %disp(aferencias)
end