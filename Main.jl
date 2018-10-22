include("JSONUtil.jl")
include("JToolKit.jl")

function main()
    clear()
    variaveisDict::Dict = readJSON("configuracao_inicial.json")
    placa::Dict = variaveisDict["placa"]
    ambiente::Dict = variaveisDict["ambiente"]
    fisico::Dict = variaveisDict["fisico"]
    iniciais::Dict = variaveisDict["iniciais"]
    io::Dict = variaveisDict["io"]

    #Informações sobre as placas.
    potenciaMaximaPainel = parse(Int,placa["Pmaxe"])
    tensaoCircuitoAberto = parse(Float64, placa["Vocn"])
    correnteCurtoCircuito = parse(Float64, placa["Iscn"])
    tensaoMaximaPotencia = parse(Float64, placa["Vmp"])
    correnteMaximaPotencia = parse(Float64, placa["Imp"])
    coeficienteCorrente = parse(Float64, placa["KI"])
    coeficienteTensao = parse(Float64,placa["KV"]) * tensaoCircuitoAberto
    coeficientePotencia = placa["KP"]
    coeficienteDiodo = parse(Float64, placa["a"])
    numeroCelulasSerie = parse(Int,placa["Ns"])

    #Informações sobre ambiente.
    temperaturaOperacaoSTC = parse(Int,ambiente["Tn"])
    temperaturaOperacaoPainel =  parse(Int,ambiente["T"])
    variacaoTemperatura = ambiente["dT"]
    temperaturaNominalKelvin = parse(Float64,ambiente["Tkn"])
    temperaturaKelvin = parse(Float64,ambiente["Tk"])
    irradiacaoTestes = parse(Int,ambiente["G"])
    irradiacaoSTC = parse(Int,ambiente["Gn"])

    #Informações sobre físicas.
    boltzman = parse(Float64, fisico["k"])
    electron = parse(Float64, fisico["q"])
    tensaoTermicaNominal::Float64 = (boltzman*temperaturaNominalKelvin)/electron
    tensaoTermica = (boltzman * temperaturaKelvin) / electron

    #Informações iniciais
    rs = parse(Int, iniciais["Rs"])
    rs_max::Float64 =  (tensaoCircuitoAberto - tensaoMaximaPotencia)/correnteMaximaPotencia 
    rp_min = iniciais["Rp_min"]
    rp::Float64 = tensaoMaximaPotencia/(correnteCurtoCircuito-correnteMaximaPotencia) - rs_max

    #Cálculo de IO
    erro = io["erro"]
    tolerancia::Float64 = parse(Float64,io["tol"])
    cont = 0
    passoVetor = io["nv"]
    incrementoIteracao = parse(Float64, io["Rs_inc"])

    # erro = Inf
    while rp > 0 #erro > tolerancia && 
       cont = cont + 1
       correnteIpcNominal = (rs+rp)/rp * correnteCurtoCircuito
       correnteIpvAtual::Float64 = correnteIpcNominal + (coeficienteCorrente * (temperaturaOperacaoSTC + temperaturaOperacaoPainel)) * irradiacaoTestes/irradiacaoSTC
       correnteCurtoCircuitoAtual = correnteCurtoCircuito + (coeficienteCorrente * (temperaturaOperacaoSTC + temperaturaOperacaoPainel)) * irradiacaoTestes/irradiacaoSTC
       ion::Float64 = (correnteCurtoCircuito+coeficienteCorrente*(temperaturaOperacaoPainel - temperaturaOperacaoSTC))/(exp((tensaoCircuitoAberto+coeficienteTensao*(temperaturaOperacaoPainel - temperaturaOperacaoSTC))/(numeroCelulasSerie*coeficienteDiodo*tensaoTermica))-1); 
       rpAnterior = rp
       rs = rs + incrementoIteracao
       rp = tensaoMaximaPotencia*(tensaoMaximaPotencia+correnteMaximaPotencia*rs)/(tensaoMaximaPotencia*correnteIpvAtual-tensaoMaximaPotencia*ion*exp((tensaoMaximaPotencia+correnteMaximaPotencia*rs)/tensaoTermicaNominal/numeroCelulasSerie/coeficienteDiodo)+tensaoMaximaPotencia*ion-
       potenciaMaximaPainel);
       println(rp)
    end
end

main()