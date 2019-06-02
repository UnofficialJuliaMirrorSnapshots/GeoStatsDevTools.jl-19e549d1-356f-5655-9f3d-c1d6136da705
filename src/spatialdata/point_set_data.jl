# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    PointSetData(data, coords)

Spatial `data` georeferenced with coordinate matrix `coords`.
The `data` argument is a dictionary mapping variable names to Julia
arrays with the actual data.

See also: [`PointSet`](@ref)
"""
struct PointSetData{T<:Real,N} <: AbstractSpatialData{T,N}
  data::Dict{Symbol,<:AbstractArray}
  domain::PointSet{T,N}

  function PointSetData{T,N}(data, domain) where {N,T<:Real}
    nvals = [length(array) for array in values(data)]
    @assert all(nvals .== npoints(domain)) "data and coords must have the same number of points"
    new(data, domain)
  end
end

PointSetData(data::Dict{Symbol,<:AbstractArray},
             coords::AbstractMatrix{T}) where {T<:Real} =
  PointSetData{T,size(coords,1)}(data, PointSet(coords))

PointSetData(data::Dict{Symbol,<:AbstractArray},
             coords::AbstractVector{NTuple{N,T}}) where {N,T<:Real} =
  PointSetData(data, [c[i] for i in 1:N, c in coords])

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::PointSetData{T,N}) where {N,T<:Real}
  npts = npoints(geodata)
  print(io, "$npts PointSetData{$T,$N}")
end
