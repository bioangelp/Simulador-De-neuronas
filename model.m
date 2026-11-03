%{
%
% Red neuronal
% main
% Programado por:
%    Christopher Manzo Hernandez
%    Emiliano Marquez Fregoso
%    Sasha Abigail Lopez Garcia
%    Angel Paramo Quirarte  
%   
%}

function model()
    resp = "y";
    while resp == "y"
        close all;
        % llamando al menu 
        app = Seleccionador;
        %esperar para no continuar model, se reanuda en la app
        uiwait(app.UIFigure)
        %verificar si la app no se cerro antes de tiempo
        check = isvalid(app);
        if ~check
            disp('La ventana de selección se cerró inesperadamente.');
            pause(1)
        
        else
            pause(1)
            load("catalogo.mat")
            load('datosCapturados.mat')
            
            %se toma el catalogo de las 6 neuronas disponibles y se calibra con
            %respecto al barrido
            catalogoCalibrado = calibrarCatalogo(catalogo,barrido);
        
            %se construye el arreglo de 100 neuronas
            neuronType = construirNeuronas(cantidades, inhibitorias, nombres, catalogoCalibrado);
            %% valores prueba:
            %{
                tiempo = 5000; barrido = 100; db = 15; gatillo = 1; 
                load neurontype.mat;
            %}
            %%
            % se crean las eferencias de las neuronas y por consiguiente salen las
            % aferencias
            [eferencias, aferencias] = conexiones();
        
            %ejecucion de red
            [voltajeCompleto, tiempoCompleto, picosCompletos, sumVoltaje]...
                = simulatedConection(tiempo, barrido, dB, gatillo, neuronType, aferencias);
        
            %borrando la pestaña de la app
           delete(app)
            graficas(voltajeCompleto, tiempoCompleto, sumVoltaje, neuronType, eferencias)
        end
        band = false;
        while ~band
            clc;
            resp = input(" ¿Desea volver a correrlo? y/n ", "s");
            if resp == "y"
                break;
            elseif resp == "n"
                break;
            else
                disp("respuesta invalida.")
                pause(1)
                band = false;
            end
        end
        
    end
close all;
clc
end