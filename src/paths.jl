# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractPath

A path on a spatial domain of type `D`.
"""
abstract type AbstractPath{D<:AbstractDomain} end

"""
    Base.iterate(path, state=1)

Iterate `path` from a given `state`.
"""
Base.iterate(p::AbstractPath, state=1) = error("not implemented")

"""
    Base.length(path)

Return the length of a `path`.
"""
Base.length(p::AbstractPath) = npoints(p.domain)

"""
    Base.eltype(::Type{P})

Return element type of path type `P`.
"""
Base.eltype(::Type{P}) where {P<:AbstractPath} = Int

#------------------
# IMPLEMENTATIONS
#------------------
include("paths/simple_path.jl")
include("paths/random_path.jl")
include("paths/source_path.jl")
include("paths/shifted_path.jl")
