# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    BallPartitioner(radius; metric=Euclidean())

A method for partitioning spatial objects into balls of a given
`radius` using a `metric`.
"""
struct BallPartitioner{T<:Real,M<:Metric} <: AbstractSpatialFunctionPartitioner
  radius::T
  metric::M
end

BallPartitioner(radius::T; metric::M=Euclidean()) where {T<:Real,M<:Metric} =
  BallPartitioner{T,M}(radius, metric)

(p::BallPartitioner)(x, y) = evaluate(p.metric, x, y) < p.radius
