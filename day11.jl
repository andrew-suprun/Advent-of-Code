mutable struct Monkey
    items::Vector{Int}
    operation::Function
    divisible::Int
    iftrue::Int
    iffalse::Int
    inspected::Int
    Monkey() = new([], () -> nothing, 0, 0, 0, 0)
end

function day11(lines, part, rounds)
    monkeys = Vector{Monkey}()
    monkey = Monkey()
    lines = strip.(lines)
    for line in lines
        terms = split(line, [',', ' '])
        if startswith(line, "Starting")
            monkey.items = map(x -> parse(Int, x), (terms[i] for i in 3:2:length(terms)))
        elseif startswith(line, "Operation")
            if terms[6] == "old"
                monkey.operation = x -> x * x
            elseif terms[5] == "+"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x + op
            elseif terms[5] == "*"
                op = parse(Int, terms[6])
                monkey.operation = (x) -> x * op
            end
        elseif startswith(line, "Test")
            monkey.divisible = parse(Int, terms[4])
        elseif startswith(line, "If true")
            monkey.iftrue = parse(Int, terms[6])
        elseif startswith(line, "If false")
            monkey.iffalse = parse(Int, terms[6])
            push!(monkeys, monkey)
            monkey = Monkey()
        end
    end

    common_multiple = lcm(monkeys .|> m -> m.divisible)

    for _ in 1:rounds, monkey in monkeys
        while !isempty(monkey.items)
            monkey.inspected += 1
            item = popfirst!(monkey.items)
            level = part == :part1 ? monkey.operation(item) ÷ 3 : monkey.operation(item) % common_multiple
            target = rem(level, monkey.divisible) == 0 ? monkey.iftrue : monkey.iffalse
            push!(monkeys[target+1].items, level)
        end
    end
    inspected = monkeys .|> m -> m.inspected
    partialsort!(inspected, 1:2, rev=true)
    return inspected[1] * inspected[2]
end

using BenchmarkTools
lines = readlines("day11.txt")
println(@btime day11(lines, :part1, 20))
println(@btime day11(lines, :part2, 10_000))

#   106.500 μs (424 allocations: 38.38 KiB)
# 57838
#   61.697 ms (3597214 allocations: 54.92 MiB)
# 15050382231