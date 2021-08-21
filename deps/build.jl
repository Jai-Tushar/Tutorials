using Literate
using Printf

repo_src = joinpath(@__DIR__,"..","src")
notebooks_dir = joinpath(@__DIR__,"..","notebooks")

files = [
  "Poisson equation"=>"poisson.jl",
  "Code validation"=>"validation.jl",
  "Linear elasticity"=>"elasticity.jl",
  "p-Laplacian"=>"p_laplacian.jl",
  "Hyper-elasticity"=>"hyperelasticity.jl",
  "Poisson equation (with DG)"=> "dg_discretization.jl",
  "Darcy equation (with RT)"=>"darcy.jl",
  "Incompressible Navier-Stokes"=>"inc_navier_stokes.jl",
  "Stokes equation" => "stokes.jl",
  "Isotropic damage model" => "isotropic_damage.jl",
  "Fluid-Structure Interaction"=>"fsi_tutorial.jl",
  "Electromagnetic scattering in 2D"=>"emscatter.jl",
  "Low-level API Poisson equation"=>"poisson_dev_fe.jl",
  "On using DrWatson.jl"=>"validation_DrWatson.jl",
  "Interpolation"=>"interpolation_fe.jl"]

Sys.rm(notebooks_dir;recursive=true,force=true)
for (i,(title,filename)) in enumerate(files)
  notebook_prefix = string("t",@sprintf "%03d_" i)
  notebook = string(notebook_prefix,splitext(filename)[1])
  notebook_title = string("# # Tutorial ", i, ": ", title)
  function preprocess_notebook(content)
    return string(notebook_title, "\n\n", content)
  end
  Literate.notebook(joinpath(repo_src,filename), notebooks_dir; name=notebook, preprocess=preprocess_notebook, documenter=false, execute=false)
end

deps_jl = joinpath(@__DIR__, "deps.jl")

if isfile(deps_jl)
  rm(deps_jl)
end

open(deps_jl,"w") do f
  println(f, "# This file is automatically generated")
  println(f, "# Do not edit")
  println(f)
  println(f, :(const files = $files))
end
