using Weave

function hfun_bar(vname)
    val = Meta.parse(vname[1])
    return round(sqrt(val), digits = 2)
end

function hfun_m1fill(vname)
    var = vname[1]
    return pagevar("index", var)
end

function lx_baz(com, _)
    # keep this first line
    brace_content = Franklin.content(com.braces[1]) # input string
    # do whatever you want here
    return uppercase(brace_content)
end

function insert_weave_toc(file)
    lines = readlines(file)
    toc = []
    for l in lines
        if !isempty(l) && string(l[1]) == "#"
            count = length(findall("#", l))
            section = l[(count + 1):end] |> strip
            section_link = "#" * section |> x -> replace(x, " " => "-") |> lowercase
            push!(toc, "$(repeat("  ", count - 1))- [$section]($section_link)")
        end
    end

    t = tempname() |> x -> joinpath(Franklin.path(:folder), x * ".jmd")
    open(t, "w") do f
        write(f, lines[1])
        write(f, "\n")
        write(f, toc[1] * "\n")
        for s in toc[2:end]
            write(f, s * "\n")
        end
        write(t, "\n")
        for l in lines[2:end]
            write(f, l * "\n")
        end
    end
    return t
end

function mermaidify(html)

    mermaid_weave = "<pre><code class=\"language-mermaid\">"
    mermaid_tag = "<div class=\"mermaid\">"

    while occursin(mermaid_weave, html)
        tag_location = findfirst(mermaid_weave, html)
        tag_start = first(tag_location) - 1
        tag_finish = last(tag_location) + 1
        html = html[1:tag_start] * mermaid_tag * html[tag_finish:end]
        close_location = findnext("</code></pre>", html, tag_start)
        close_start = first(close_location) - 1
        close_finish = last(close_location) + 1
        html = html[1:close_start] * "</div>" * html[close_finish:end]
    end

    return html

end

function hfun_insert_weave(params)
    rpath = params[1]
    fullpath = joinpath(Franklin.path(:folder), rpath)
    (isfile(fullpath) && splitext(fullpath)[2] == ".jmd") || return ""
    print("Weaving... ")
    t = tempname()
    weave(fullpath, out_path = t)
    println("✓ [done].")
    fn = splitext(splitpath(fullpath)[end])[1]
    html = read(joinpath(t, fn * ".html"), String)
    start = findfirst("<BODY>", html)
    finish = findfirst("</BODY>", html)
    range = nextind(html, last(start)):prevind(html, first(finish))
    html = html[range]
    html = mermaidify(html)
    # TODO: Add ability to create TOC off of default HTML
    # html = insert_weave_toc(html)
    return html
end

function hfun_insert_pandoc(params)
    rpath = params[1]
    file_path = joinpath(Franklin.path(:folder), rpath)
    (isfile(file_path) && splitext(file_path)[2] == ".md") || return ""
    t = tempname()
    s = ""
    if length(params) == 2
        cite_path = file_path = joinpath(Franklin.path(:folder), params[2])
        s = read(
            `pandoc --citeproc -i $file_path --bibliography=$cite_path -t html`,
            String,
        )
    else
        s = read(
            `pandoc --citeproc -i $file_path -t html`,
            String,
        )
    end
    println("✓ [done].")
    return s
end

function env_mermaid(e, _)
    content = Franklin.content(e)
    return "@@mermaid ~~~$content~~~@@"
end
