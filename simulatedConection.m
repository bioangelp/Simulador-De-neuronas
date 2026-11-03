function [voltajeCompleto, tiempoCompleto, picosCompletos, sumVoltaje]...
    = simulatedConection(tiempo, barrido, dB, gatillo, neuronType, aferencias)

 %% PRUEBA
 %{
    clear
    tiempo = 1000;
    gatillo = 1;
    db = 20;
    barrido = 100;
    load("neurontype.mat","neuronType")
    %definir las aferencias
     [eferencias, aferencias] = conexiones();
 %}

%%  
    neuronasParaGatillo = 50;

    vectorVoltaje = zeros(100, barrido/0.25);
    corrienteSalida = zeros(1,100);

    voltajeCompleto = zeros(100, tiempo/barrido * barrido/0.25);
    tiempoCompleto = zeros(1, tiempo/barrido * barrido/0.25);

    
    %contador de barridos
    for contadorBarrido = barrido:barrido:tiempo
        
        %si es el prier barrido, las corrientes de las neuronas 1-50 serán
        %corriente gatillo y las demas son 0
        if contadorBarrido == barrido
            corrientesBarrido = zeros(100,1);
            corrientesBarrido(1:neuronasParaGatillo) = gatillo;
        end
    
        %correr la red con las corrientes de barrido
        for n = 1:100
            [vectorTiempo, vectorVoltaje(n, :), corrienteSalida(n)]...
                = neurona(barrido, corrientesBarrido(n), neuronType(n), dB, 0);
            %disp(contadorBarrido)
            %disp(n)
        end
    
        %calcular la corriente para el siguiente barrido para cada neurona
        %corrientesBarrido = zeros(100,1);
        for n = 1:100
            sumaCorrientes = 0;
            for aferencia = aferencias{n}
                sumaCorrientes = sumaCorrientes + corrienteSalida(aferencia);
            end
            %añadir la corriente gatillo si aun no estamos fuera de los
            %primeros 3 barridos
            if contadorBarrido < barrido * 3 && n <= neuronasParaGatillo 
                sumaCorrientes = sumaCorrientes + gatillo;
                % calcular el promedio para cada neurona considerando la
                % existencia de la corriente gatillo para los primeros 3
                % barridos
                corrientesBarrido(n) = sumaCorrientes/(length(aferencias{n}) + 1);
            else
                corrientesBarrido(n) = sumaCorrientes/length(aferencias{n});
            end
        end

        % concatenar los valores para el final

        inicio = (contadorBarrido / barrido - 1) * (barrido / 0.25) + 1;
        fin = (contadorBarrido / barrido) * (barrido / 0.25);

        voltajeCompleto(:, inicio : fin) = vectorVoltaje;
        tiempoCompleto(inicio : fin) = vectorTiempo + (contadorBarrido - barrido);
    end

    % Detectar picos para cada neurona en su tiempo completo.
    picosCompletos = nan(100,length(tiempoCompleto));
    sumVoltaje = nan(1,length(tiempoCompleto));

    for n = 1:100
        for p = 1:length(tiempoCompleto)
            %disp(p * 0.25)
            if voltajeCompleto(n,p) == 30
                picosCompletos(n,p) = n;
            end
            %para electrodo de campo
            sumVoltaje(p) = sum(voltajeCompleto(:,p));
        end
    end

    sumVoltaje = detrend(sumVoltaje);
   
    %% grafica provisional 
    %{
        hold on
        for n = 1:100
           plot(tiempoCompleto, picosCompletos(n,:), "*")
           
        end
        hold off
    %}
    %%

end
