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
    potenciaMaximaPainel = placa["Pmaxe"]
    tensaoCircuitoAberto = parse(Float16, placa["Vocn"])
    correnteCurtoCircuito = placa["Iscn"]
    tensaoMaximaPotencia = parse(Float16, placa["Vmp"])
    correnteMaximaPotencia = parse(Float16, placa["Imp"])
    coeficienteCorrente = placa["KI"]
    coeficienteTensao = placa["KV"]
    coeficientePotencia = placa["KP"]
    coeficienteDiodo = placa["a"]
    numeroCelulasSerie = placa["Ns"]

    #Informações sobre ambiente.
    temperaturaOperacaoSTC = ambiente["Tn"]
    temperaturaOperacaoPainel =  ambiente["T"]
    variacaoTemperatura = ambiente["dT"]
    temperaturaNominalKelvin = ambiente["Tkn"]
    temperaturaKelvin = ambiente["Tk"]
    irradiacaoTestes = ambiente["G"]
    irradiacaoSTC = ambiente["Gn"]

    #Informações sobre físicas.
    boltzman = fisico["k"]
    electron = fisico["q"]
    tensaoTermicaNominal = fisico["Vtn"]
    tensaoTermica = fisico["Vt"]

    #Informações iniciais
    rs = iniciais["Rs"]
    rs_max::Float16 =  (tensaoCircuitoAberto - tensaoMaximaPotencia)/correnteMaximaPotencia 
    rp_min = iniciais["Rp_min"]
    rp::Float16 = tensaoMaximaPotencia/(correnteCurtoCircuito-correnteMaximaPotencia) - rs_max

    #Cálculo de IO
    ion = io["Io"]
    erro = io["erro"]
    tolerancia::Float16 = parse(Float16,io["tol"])
    iteracao = io["n"]
    passoVetor = io["nv"]
    incrementoIteracao = io["Rs_inc"]

    # erro = Inf
    while rp > 0 #erro > tolerancia && 
        
    end
end

main()