# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    WeightedSpatialData(spatialdata, weights)

Assign `weights` for each point in `spatialdata`.
"""
struct WeightedSpatialData{T<:Real,N,S<:AbstractSpatialData{T,N},V} <: AbstractSpatialData{T,N}
  spatialdata::S
  weights::Vector{V}
end

domain(d::WeightedSpatialData) = domain(d.spatialdata)

variables(d::WeightedSpatialData) = variables(d.spatialdata)

value(d::WeightedSpatialData, ind::Int, var::Symbol) = value(d.spatialdata, ind, var)

"""
    AbstractWeighter

A method to weight spatial data.
"""
abstract type AbstractWeighter end

"""
    weight(spatialdata, weighter)

Weight `spatialdata` with `weighter` method.
"""
weight(spatialdata::AbstractSpatialData, weighter::AbstractWeighter) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("weighting/block_weighter.jl")
