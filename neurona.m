% esto esta basicamente copiado tal cual del codigo de Izhikevich, pero con
% la clalibracion de en que barridos y a que pks si sirve.
function [vectorTiempo,VV,Io]=neurona(tiempoBarrido,I,parametros,db,calibracion)  
% definir los valores maximos y minimmos de corriente
    if I >= 1
        I = 1;
    elseif I <= -1
        I = -1;
    end

    I = parametros.I*I;
    a=parametros.a; 
    b=parametros.b;  
    c=parametros.c;  
    d=parametros.d;
    ie=parametros.InEx;
    %provicional para hacer pruebas entre versiones:
    %ie = 1;
    V=parametros.V;  
    u=b*V;

    VV=[];  uu=[];
    tau = 0.25; 
    vectorTiempo = tau:tau:tiempoBarrido;
    %solo para las neuronas que tienen corriente en rampa:
    IconRampa = I;
    
    for t = vectorTiempo

        %para la neurona clase 1
        if  strcmp(parametros.nombre,"class 1 exc")
            I = IconRampa(t/tau);
            if calibracion == 0
                I = awgn(I,db);
            end
            V = V + tau*(0.04*V^2+4.1*V+108-u+I);
         
        
        elseif strcmp(parametros.nombre,"class 2 exc")
            I = IconRampa(t/tau);
            if calibracion == 0
                I = awgn(I,db);
            end
            V = V + tau*(0.04*V^2+5*V+140-u+I);

        %para los tipos de neurona que no requieren condiciones especiales
        else
            if calibracion == 0
                I = awgn(I,db);
            end
            
            V = V + tau*(0.04*V^2+5*V+140-u+I);
        end

        u = u + tau*a*(b*V-u);

        if V > 30
            VV(end+1)=30;
            V = c;
            u = u + d;
        else
            VV(end+1)=V;
        end
        uu(end+1)=u;
    end

    if calibracion == 0
        %condicion para saber si la neurona disparo y evitar warnings de no
        %picos encontrados
        if max(VV) >20
            pks= length(findpeaks(VV,"MinPeakHeight",20));
            Io = ie*(pks/parametros.pks);
        else
            Io = 0;
        end
    else
        Io = nan;
    end

end