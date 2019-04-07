# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    boundgrid(spatialdata, dims)

Returns a `RegularGrid` of given `dims` covering all the
locations in `spatialdata`.
"""
function boundgrid(spatialdata::AbstractSpatialData{T,N}, dims::Dims{N}) where {N,T<:Real}
  @assert all(dims .> 0) "dimensions must be positive"

  start  = fill(typemax(T), N)
  finish = fill(typemin(T), N)

  for ind in 1:npoints(spatialdata)
    x = coordinates(spatialdata, ind)
    for d in 1:N
      x[d] < start[d] && (start[d] = x[d])
      x[d] > finish[d] && (finish[d] = x[d])
    end
  end

  RegularGrid(tuple(start...), tuple(finish...), dims=dims)
end

"""
    readgeotable(args; coordnames=[:x,:y,:z], kwargs)

Read data from disk using `CSV.read`, optionally specifying
the columns `coordnames` with spatial coordinates.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `CSV.read` function, please check their
documentation for more details.

This function returns a [`GeoDataFrame`](@ref) object.
"""
function readgeotable(args...; coordnames=[:x,:y,:z], kwargs...)
  data = CSV.read(args...; kwargs...)
  GeoDataFrame(data, coordnames)
end
