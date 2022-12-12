function day12(lines, part)
    nlines, nrows = length(lines), length(lines[1])
    heightmap = Matrix{Int}(undef, nlines, nrows)
    start = (0, 0)
    target = (0, 0)
    for l in eachindex(lines), r in eachindex(lines[l])
        if lines[l][r] == 'S'
            heightmap[l, r] = 0
            start = (l, r)
        elseif lines[l][r] == 'E'
            heightmap[l, r] = 'z' - 'a'
            target = (l, r)
        else
            heightmap[l, r] = lines[l][r] - 'a'
        end
    end
    visited = Set([start])
    current_level::Vector{Tuple{Int,Int}} = [start]

    if part == :part2
        for l in eachindex(lines), r in eachindex(lines[l])
            if lines[l][r] == 'a'
                push!(visited, (l, r))
                push!(current_level, (l, r))
            end
        end
    end

    steps = 0
    while true
        next_level = Vector{Tuple{Int,Int}}()
        for (l, r) in current_level
            current_height = heightmap[l, r]

            if r < nrows && heightmap[l, r+1] - 1 <= current_height && !((l, r + 1) in visited)
                push!(visited, (l, r + 1))
                push!(next_level, (l, r + 1))
            end
            if r > 1 && heightmap[l, r-1] - 1 <= current_height && !((l, r - 1) in visited)
                push!(visited, (l, r - 1))
                push!(next_level, (l, r - 1))
            end
            if l < nlines && heightmap[l+1, r] - 1 <= current_height && !((l + 1, r) in visited)
                push!(visited, (l + 1, r))
                push!(next_level, (l + 1, r))
            end
            if l > 1 && heightmap[l-1, r] - 1 <= current_height && !((l - 1, r) in visited)
                push!(visited, (l - 1, r))
                push!(next_level, (l - 1, r))
            end
        end

        current_level = next_level
        steps += 1
        target in visited && break
    end
    return steps
end

using BenchmarkTools
lines = readlines("day12.txt")
println(@btime day12(lines, :part1))
println(@btime day12(lines, :part2))

#   428.167 μs (1181 allocations: 669.47 KiB)
# 472
#   444.125 μs (1137 allocations: 730.16 KiB)
# 465