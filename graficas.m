function graficas(voltajeCompleto, tiempoCompleto, sumVoltaje, neuronType, eferencias)

    numNeuronas = 100;
% Identificar cuáles son excitatorias InE= 1  inhibitorias InEx =-1
    esExcitatoria = false(1, numNeuronas);
    for n = 1:numNeuronas
        if neuronType(n).InEx == 1
            esExcitatoria(n) = true;
        end
    end
% Obtener los índices para graficar primero las excitatorias y luego las inhibitorias
    indiceDeExcitatorias = find(esExcitatoria);
    indiceDeInhibitorias = find(~esExcitatoria);
    ordenRaster = [indiceDeExcitatorias, indiceDeInhibitorias];

%% registro de campo y raster plot 
    figure('Name', 'Actividad de la Red Neuronal', 'Color', [0.07 0.03 0.12], 'Position', [100 100 1000 700]);

% rasterplot
    subplot(2, 1, 1);
    hold on;
% recorrer neuronas en el orden
    for i = 1:numNeuronas
        n_original = ordenRaster(i);
        senalNeurona = voltajeCompleto(n_original, :);
        if max(senalNeurona) > 20
            [~, locs] = findpeaks(senalNeurona, 'MinPeakHeight', 20);
            tiemposDisparo = tiempoCompleto(locs);
            if ~isempty(tiemposDisparo)
                if esExcitatoria(n_original)
                    % excitatorias: naranja cempasúchil
                    plot(tiemposDisparo, repmat(i, size(tiemposDisparo)), '.', 'Color', [1 0.55 0.05], 'MarkerSize', 8);
                else
                    % inhibitorias: turquesa
                    plot(tiemposDisparo, repmat(i, size(tiemposDisparo)), '.', 'Color', [0.1 0.85 0.8], 'MarkerSize', 8);
                end
            end
        end
    end
% línea que separa excitatorias de inhibitoria
    yline(length(indiceDeExcitatorias) + 0.5, '--', 'Color', [1 0.95 0.85], 'LineWidth', 1.5);
    xlim([0, max(tiempoCompleto)]);
    ylim([0, numNeuronas + 1]);
% ejes
    set(gca, 'Color', [0.12 0.05 0.18], 'XColor', [1 0.95 0.85], 'YColor', [1 0.95 0.85], ...
        'GridColor', [1 0.95 0.85], 'GridAlpha', 0.15);
    xlabel('Tiempo (ms)', 'Color', [1 0.95 0.85]);
    ylabel('Neuronas', 'Color', [1 0.95 0.85]);
    title('Raster Plot de la Red (Naranja: Excitatorias   Turquesa: Inhibitorias)', 'Color', [1 0.8 0.15]);
    grid on;
    box on;
    hold off;

% registro de campo
    subplot(2, 1, 2);
    plot(tiempoCompleto, sumVoltaje, '-', 'Color', [0.95 0.2 0.7], 'LineWidth', 1);
    xlim([0, max(tiempoCompleto)]);
    set(gca, 'Color', [0.12 0.05 0.18], 'XColor', [1 0.95 0.85], 'YColor', [1 0.95 0.85], ...
        'GridColor', [1 0.95 0.85], 'GridAlpha', 0.15);
    xlabel('Tiempo (ms)', 'Color', [1 0.95 0.85]);
    ylabel('Voltaje Sumado (mV)', 'Color', [1 0.95 0.85]);
    title('Registro de Campo', 'Color', [1 0.8 0.15]);
    grid on;
    box on;

%% Gráfica 3D
    figure('Name', 'Red 3D', 'Color', [0.07 0.03 0.12], 'Position', [150 150 800 700]);
    hold on;
    [X, Y, Z] = meshgrid(1:5, 1:5, 1:4);
    posX = X(:);
    posY = Y(:);
    posZ = Z(:);
% Graficar las 100 neuronas: naranja las excitatorias, turquesa las inhibitorias
    for n = 1:numNeuronas
        if esExcitatoria(n)
            plot3(posX(n), posY(n), posZ(n), 'o', 'MarkerSize', 8, ...
                'MarkerFaceColor', [1 0.55 0.05], 'MarkerEdgeColor', [1 0.95 0.85]);
        else
            plot3(posX(n), posY(n), posZ(n), 'o', 'MarkerSize', 8, ...
                'MarkerFaceColor', [0.1 0.85 0.8], 'MarkerEdgeColor', [1 0.95 0.85]);
        end
    end
% Graficar las conexiones y las flechas (violeta claro, semitransparentes)
    for n = 1:numNeuronas
        conexionesSalida = eferencias{n};
        for c = 1:length(conexionesSalida)
            destino = conexionesSalida(c);
            if destino == n
                continue;
            end
            x_ini = posX(n);       y_ini = posY(n);       z_ini = posZ(n);
            x_fin = posX(destino); y_fin = posY(destino); z_fin = posZ(destino);
% Componentes del vector origen - destino
            distx = x_fin - x_ini;
            disty = y_fin - y_ini;
            distz = z_fin - z_ini;
            distancia = norm([distx, disty, distz]);
            multip = (distancia - 0.08) / distancia;
            dx_cables = distx * multip;
            dy_cables = disty * multip;
            dz_cables = distz * multip;
% graficando las lineas
            quiver3(x_ini, y_ini, z_ini, dx_cables, dy_cables, dz_cables, 0, ...
                'Color', [0.75 0.55 0.95 0.4], 'LineWidth', 0.8, 'MaxHeadSize', 0.3);
        end
    end
    view(3); % Vista 3D
    set(gca, 'Color', [0.12 0.05 0.18], 'XColor', [1 0.95 0.85], 'YColor', [1 0.95 0.85], ...
        'ZColor', [1 0.95 0.85], 'GridColor', [1 0.95 0.85], 'GridAlpha', 0.15);
    xlabel('Eje X', 'Color', [1 0.95 0.85]);
    ylabel('Eje Y', 'Color', [1 0.95 0.85]);
    zlabel('Eje Z', 'Color', [1 0.95 0.85]);
    title('Diagrama 3D de Conexiones', 'Color', [1 0.8 0.15]);
    grid on;
    box on;
    hold off;
end