using Gadfly

Pmaxe=130; #Potência máxima do painél
Vocn=21.5; #Tensão de circuito aberto.
Iscn=7.99; #Corrente de curto circuito
Vmp=17.4; #Tensão de máxima potência
Imp=7.49; #Corrente de máxima potência
KI=0.034/100*Iscn; #Coeficiente de corrente
KV=-0.34/100*Vocn; #Coeficiente de tensão
a=1.35; #Constante do diodo. valor pode ser 1.0<a<2.0
Ns=36; #Numero de células em série
## Constantes físicas e condições ambientais
#Condições ambientais
Tn=25; #Temperatura de operação no STC
T=25; #Temperatura de operação do painél.
dT=T-Tn; #Variação de temperatura
Tkn=Tn+273.15; #Temperatura nominal em Kelvin
Tk=T+273.15; #Temperatura em Kelvin
G=1000; #Irradiação utilizada nos testes
Gn=1000; #Irradiação STC
#Parâmetros físicos
k = 1.38064852e-23; #Boltzmann [J/K]
q = 1.60217662e-19; #Electron charge [C]
Vtn=k*Tkn/q; #Tensão térmica nominal
Vt=k*Tk/q; #Tensão térmica
## Considerações iniciais
Rs = 0; #Valor inicial de Rs
Rs_max = (Vocn - Vmp)/ Imp; #Valor máximo de Rs
Rp_min = Vmp/(Iscn-Imp) - Rs_max; #Valor mínimo de Rp
Rp = Rp_min; #Valor inicial de Rp
#Cálculo de Io
Io=(Iscn+KI*dT)/(exp((Vocn+KV*dT)/(Ns*a*Vt))-1); #Para dT=0, temos Ion
erro = Inf #Diferença entre Pmaxc e Pmaxe
tol = .6; #Tolerância entre Pcalc e Pmaxe
n = 0; #Iteração 0
nv = 500; #Step do vetor V
Rs_inc = 0.01; #Incremento de Rs por iteração
Rp_ant = 0
P = 0
Ipvn = 0
Ipv = 0
Isc = 0
Io = 0
## Começo da iteração:
while (erro>tol) && (Rp > 0)
    n = n + 1; #incremento iteração
    global Ipvn = (Rs+Rp)/Rp * Iscn; #Corrente Ipc nominal
    global Ipv = (Ipvn + KI*dT) *G/Gn; #Corrente Ipv atual
    global Isc = (Iscn + KI*dT) *G/Gn; #Corrente de curto circuito atual
    global Io=(Iscn+KI*dT)/(exp((Vocn+KV*dT)/(Ns*a*Vt))-1);
    global Rp_ant = Rp; #Salva Rp anterior.
    Rs = Rs + Rs_inc; #Incremento em Rs135
    Rp = Vmp*(Vmp+Imp*Rs)/(Vmp*Ipv-Vmp*Io*exp((Vmp+Imp*Rs)/Vtn/Ns/a)+Vmp*Io-Pmaxe); #Calcula novo Rp
    global V = 0:(Vocn/nv):Vocn; #Vetor de tensão
    global I = zeros(size(V,1)); #Vetor de corrente
    @assert (size(V) == size(I)) "Mismatched Vectors"
    #Calcula g = I - f(I,V) = 0 através do método de Newton-Raphson
    for j in 1:size(V,1)
        g(j) = Ipv-Io*(exp((V[j]+I[j]*Rs)/Vt/Ns/a)-1)-(V[j]+I[j]*Rs)/Rp-I[j]; #Função g = I - f(I,V)
        glin(j) = -Io*Rs/Vt/Ns/a*exp((V[j]+I[j]*Rs)/Vt/Ns/a)-Rs/Rp-1; #Derivada de g
        loop_value = g(j)
        while (abs(loop_value) > 0.0001)
            I_(x) = (I[x] - g(x)/glin(x));
            global I[j] = I_(j);
            loop_value = g(j)
        end
    end
    global P = (Ipv-Io*(exp.((V+I.*Rs)/Vt/Ns/a)-1)-(V+I.*Rs)/Rp).*V; #Calcula P através da curva I-V
    global Pmaxc = maximum(P); #Acha maior ponto de P
    erro = (Pmaxc-Pmaxe) #calcula erro entre Pmax e Pmaxe
    #Variáveis locais ao loop
end
## Consideração Caso Rp < 0
if Rp < 0
     Rp = Rp_ant #Caso Rp fique negativo.
     print("RP negativo\n\n")
end
## Cálculo Imp_calc e Vmp_calc
b = 1; #Variável incremental
    while P[b] ≈ maximum(P)
b = b+1;
end
Imp_calc = I[b];
Vmp_calc = V[b];
# telapsed = toc(start);
# printLn("tempo = $telapsed")
# Variáveis:
println("Model info:\n")
println("Rp = $Rp")
println("Rs = $Rs")
println("a = $a")
println("T = $T")
println("G = $G")
println("Ipv_n = $Ipvn")
println("Isc = $Iscn")
println("Io_n = $Io")
println("KI = $KI")
println("KV = $KV")
println("Vocn = $Vocn")
println("Ns = $Ns")
println("Rsmax = $((Vocn-Vmp)/Imp)")
println("Pmax = $Pmaxc (calculado), Pmax = $Pmaxe (experimental)")
println("Imp = $Imp_calc (calculado), Imp = $Imp (experimental)")
println("Vmp = $Vmp_calc (calculado), Vmp = $Vmp (experimental)")
V = collect(V)
plot(x = V,y = I)
plot(x = V,y = P)
