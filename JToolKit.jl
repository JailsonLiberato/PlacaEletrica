    function clear()
        Base.run(`clear`)
        for var in names(Main)
            try
                eval(parse("$var=0"))
            catch e
            end
        end
        gc()
    end