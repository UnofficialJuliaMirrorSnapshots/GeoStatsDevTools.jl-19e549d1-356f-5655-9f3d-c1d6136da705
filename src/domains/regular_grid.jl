# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    RegularGrid(dims, origin, spacing)

A regular grid with dimensions `dims`, lower left corner at `origin`
and cell spacing `spacing`. The three arguments must have the same length.

    RegularGrid(start, finish, dims=dims)

Alternatively, construct a regular grid from a `start` point (lower left)
to a `finish` point (upper right), optionally passing `dims`.

    RegularGrid{T}(dims)
    RegularGrid{T}(dim1, dim2, ...)

Finally, a regular grid can be constructed by only passing the dimensions
`dims` as a tuple, or by passing each dimension `dim1`, `dim2`, ... separately.
In this case, the origin and spacing default to (0,0,...) and (1,1,...).

## Examples

Create a 3D grid with 100x100x50 locations:

```julia
julia> RegularGrid{Float64}(100,100,50)
```

Create a 2D grid with 100x100 locations and origin at (10.,20.) units:

```julia
julia> RegularGrid((100,100),(10.,20.),(1.,1.))
```

Create a 1D grid from -1 to 1 with 100 locations:

```julia
julia> RegularGrid((-1.,),(1.,), dims=(100,))
```
"""
struct RegularGrid{T<:Real,N} <: AbstractDomain{T,N}
  dims::Dims{N}
  origin::NTuple{N,T}
  spacing::NTuple{N,T}

  function RegularGrid{T,N}(dims, origin, spacing) where {N,T<:Real}
    @assert all(dims .> 0) "dimensions must be positive"
    @assert all(spacing .> 0) "spacing must be positive"
    new(dims, origin, spacing)
  end
end

RegularGrid(dims::Dims{N}, origin::NTuple{N,T}, spacing::NTuple{N,T}) where {N,T<:Real} =
  RegularGrid{T,N}(dims, origin, spacing)

RegularGrid(start::NTuple{N,T}, finish::NTuple{N,T}; dims::Dims{N}=ntuple(i->100, N)) where {N,T<:Real} =
  RegularGrid{T,N}(dims, start, ntuple(i->(finish[i]-start[i])/(dims[i]-1), N))

RegularGrid(extent::NTuple{N,A}; dims::Dims{N}=ntuple(i->100, N)) where {N,T<:Real,A<:Tuple{T,T}} =
  RegularGrid(first.(extent), last.(extent), dims=dims)

RegularGrid{T}(dims::Dims{N}) where {N,T<:Real} =
  RegularGrid{T,N}(dims, ntuple(i->zero(T), N), ntuple(i->one(T), N))

RegularGrid{T}(dims::Vararg{Int,N}) where {N,T<:Real} = RegularGrid{T}(dims)

Base.size(grid::RegularGrid) = grid.dims
origin(grid::RegularGrid) = grid.origin
spacing(grid::RegularGrid) = grid.spacing

npoints(grid::RegularGrid) = prod(grid.dims)

function coordinates!(buff::AbstractVector{T}, grid::RegularGrid{T,N},
                      location::Int) where {N,T<:Real}
  intcoords = CartesianIndices(grid.dims)[location]
  for i in 1:N
    @inbounds buff[i] = grid.origin[i] + (intcoords[i] - 1)*grid.spacing[i]
  end
end

function extent(grid::RegularGrid{T,N}) where {N,T<:Real}
  lowerleft  = grid.origin
  upperright = @. grid.origin + (grid.dims - 1)*grid.spacing
  ntuple(i->(lowerleft[i],upperright[i]), N)
end

function nearestlocation(grid::RegularGrid{T,N}, coords::AbstractVector{T}) where {N,T<:Real}
  sz = size(grid)
  or = origin(grid)
  sp = spacing(grid)

  units = ntuple(i -> @inbounds(return round(Int, (coords[i] - or[i]) / sp[i])), N)
  icoords = ntuple(i -> @inbounds(return units[i] + 1), N) # 1-based indexing

  # make sure integer coordinates lie inside of the grid
  c = ntuple(i -> @inbounds(return clamp(icoords[i], 1, sz[i])), N)

  if N == 1
    @inbounds return c[1]
  elseif N == 2
    @inbounds return c[1] + sz[1]*(c[2]-1)
  elseif N == 3
    @inbounds return c[1] + sz[1]*(c[2]-1) + sz[1]*sz[2]*(c[3]-1)
  else # higher dimensions
    LinearIndices(sz)[c...]
  end
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, grid::RegularGrid{T,N}) where {N,T<:Real}
  dims = join(grid.dims, "×")
  print(io, "$dims RegularGrid{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", grid::RegularGrid{T,N}) where {N,T<:Real}
  println(io, "RegularGrid{$T,$N}")
  println(io, "  dimensions: ", grid.dims)
  println(io, "  origin:     ", grid.origin)
  print(  io, "  spacing:    ", grid.spacing)
end
