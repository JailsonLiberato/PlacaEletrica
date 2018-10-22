import JSON

#Example
function writeJSON()
    dict1 = Dict("param1" => 1, "param2" => 2,
            "dict" => Dict("d1"=>1.,"d2"=>1.,"d3"=>1.))
    stringdata = JSON.json(dict1)

    open("write_read.json", "w") do f
        write(f, stringdata)
     end

end

function readJSON(filename::String)::Dict
    open(filename, "r") do f
        dicttxt = readstring(f) 
        dict=JSON.parse(dicttxt)
        return dict 
    end
    
end
