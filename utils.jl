using Weave

function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
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

function hfun_insert_weave(params)
    rpath = params[1]
    fullpath = joinpath(Franklin.path(:folder), rpath)
    (isfile(fullpath) && splitext(fullpath)[2] == ".jmd") || return ""
    print("Weaving... ")
    t = tempname()
    weave(fullpath, out_path=t)
    println("✓ [done].")
    fn = splitext(splitpath(fullpath)[end])[1]
    html = read(joinpath(t, fn * ".html"), String)
    start = findfirst("<BODY>", html)
    finish = findfirst("</BODY>", html)
    range = nextind(html, last(start)):prevind(html, first(finish))
    html = html[range]
    return html
end
