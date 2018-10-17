import JSON

function writeJSON()
    dict1 = Dict("param1" => 1, "param2" => 2,
            "dict" => Dict("d1"=>1.,"d2"=>1.,"d3"=>1.))
    stringdata = JSON.json(dict1)

    open("write_read.json", "w") do f
        write(f, stringdata)
     end

end

function readJSON()
    dict2 = Dict()
    open("write_read.json", "r") do f
        global dict2
        dicttxt = readstring(f) 
        dict2=JSON.parse(dicttxt) 
        println(dict2["param2"])
    end
    
    println(dict2)
end
