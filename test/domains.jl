@testset "Spatial domain" begin
  @testset "RegularGrid" begin
    grid = RegularGrid{Float32}(200,100)
    @test ndims(grid) == 2
    @test coordtype(grid) == Float32
    @test size(grid) == (200,100)
    @test npoints(grid) == 200*100
    @test coordinates(grid, 1) == [0.,0.]
    @test origin(grid) == (0f0, 0f0)
    @test spacing(grid) == (1f0, 1f0)

    grid = RegularGrid((200,100,50), (0.,0.,0.), (1.,1.,1.))
    @test ndims(grid) == 3
    @test coordtype(grid) == Float64
    @test size(grid) == (200,100,50)
    @test npoints(grid) == 200*100*50
    @test coordinates(grid, 1) == [0.,0.,0.]
    @test origin(grid) == (0.,0.,0.)
    @test spacing(grid) == (1.,1.,1.)

    grid = RegularGrid((-1.,-1.), (1.,1.), dims=(200,100))
    @test ndims(grid) == 2
    @test coordtype(grid) == Float64
    @test size(grid) == (200,100)
    @test npoints(grid) == 200*100
    @test coordinates(grid, 1) == [-1.,-1.]
    @test coordinates(grid, 200*100) == [1.,1.]
    @test origin(grid) == (-1.,-1.)

    grid = RegularGrid{Float64}(100,200)
    @test sprint(show, grid) == "100×200 RegularGrid{Float64,2}"
    @test sprint(show, MIME"text/plain"(), grid) == "RegularGrid{Float64,2}\n  dimensions: (100, 200)\n  origin:     (0.0, 0.0)\n  spacing:    (1.0, 1.0)"

    if visualtests
      gr(size=(800,800))
      @plottest plot(RegularGrid{Float64}(10)) joinpath(datadir,"grid1D.png") !istravis
      @plottest plot(RegularGrid{Float64}(10,20)) joinpath(datadir,"grid2D.png") !istravis
      @plottest plot(RegularGrid{Float64}(10,20,30)) joinpath(datadir,"grid3D.png") !istravis
      @plottest plot(RegularGrid{Float64}(10),[1,2,3,4,5,5,4,3,2,1]) joinpath(datadir,"grid1D-data.png") !istravis
      @plottest plot(RegularGrid{Float64}(10,10),1:100) joinpath(datadir,"grid2D-data.png") !istravis
    end
  end

  @testset "PointSet" begin
    ps = PointSet([1. 0.; 0. 1.])
    @test npoints(ps) == 2
    @test coordinates(ps, 1) == [1., 0.]
    @test coordinates(ps, 2) == [0., 1.]

    @test sprint(show, ps) == "2×2 PointSet{Float64,2}"
    @test sprint(show, MIME"text/plain"(), ps) == "2×2 PointSet{Float64,2}\n 1.0  0.0\n 0.0  1.0"

    if visualtests
      gr(size=(800,800))
      Random.seed!(2019)
      @plottest plot(PointSet(rand(1,10))) joinpath(datadir,"pset1D.png") !istravis
      @plottest plot(PointSet(rand(2,10))) joinpath(datadir,"pset2D.png") !istravis
      @plottest plot(PointSet(rand(3,10))) joinpath(datadir,"pset3D.png") !istravis
      @plottest plot(PointSet(rand(1,10)),1:10) joinpath(datadir,"pset1D-data.png") !istravis
      @plottest plot(PointSet(rand(2,10)),1:10) joinpath(datadir,"pset2D-data.png") !istravis
      @plottest plot(PointSet(rand(3,10)),1:10) joinpath(datadir,"pset3D-data.png") !istravis
    end
  end

  @testset "StructuredGrid" begin
    nx, ny, nz = 20, 10, 10

    X = [1.,5.,6.,10.]
    g1 = StructuredGrid(X)
    @test npoints(g1) == 4
    @test coordinates(g1) == [1. 5. 6. 10.]

    @test sprint(show, g1) == "4 StructuredGrid{Float64,1}"
    @test sprint(show, MIME"text/plain"(), g1) == "4 StructuredGrid{Float64,1}\n 1.0  5.0  6.0  10.0"

    X  = [x for x in range(0,10,length=nx), j in 1:ny]
    Y  = sin.(X) .+ [0.5j for i in 1:nx, j in 1:ny]
    g2 = StructuredGrid(X, Y)
    @test npoints(g2) == nx*ny
    @test size(g2) == (nx, ny)
    @test size(coordinates(g2)) == (2, nx*ny)

    @test sprint(show, g2) == "20×10 StructuredGrid{Float64,2}"

    X = [x for x in range(0,10,length=nx), j in 1:ny, k in 1:nz]
    Y = sin.(X) .+ [0.5j for i in 1:nx, j in 1:ny, k in 1:nz]
    Z = [1.0(k-1) for i in 1:nx, j in 1:ny, k in 1:nz]
    g3 = StructuredGrid(X, Y, Z)
    @test npoints(g3) == nx*ny*nz
    @test size(g3) == (nx, ny, nz)
    @test size(coordinates(g3)) == (3, nx*ny*nz)

    @test sprint(show, g3) == "20×10×10 StructuredGrid{Float64,3}"

    if visualtests
      gr(size=(800,800))
      @plottest plot(g1) joinpath(datadir,"sgrid1D.png") !istravis
      @plottest plot(g2) joinpath(datadir,"sgrid2D.png") !istravis
      @plottest plot(g3,camera=(30,60)) joinpath(datadir,"sgrid3D.png") !istravis
    end
  end
end
