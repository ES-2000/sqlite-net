
SRC=src\SQLite.cs src\SQLiteAsync.cs
nuget=C:\Users\klaus.bleck\Documents\nuget.exe
msbuild="C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\MSBuild.exe"

all: test nuget

test: tests\bin\Debug\SQLite.Tests.dll tests\ApiDiff\bin\Debug\ApiDiff.exe
	nunit-console tests\bin\Debug\SQLite.Tests.dll
	mono tests\ApiDiff\bin\Debug\ApiDiff.exe

tests/bin/Debug/SQLite.Tests.dll: tests\SQLite.Tests.csproj $(SRC)
	$(msbuild) tests\SQLite.Tests.csproj

tests/ApiDiff/bin/Debug/ApiDiff.exe: tests\ApiDiff\ApiDiff.csproj $(SRC)
	$(msbuild) tests\ApiDiff\ApiDiff.csproj

nuget: srcnuget pclnuget basenuget sqlciphernuget

packages: nuget\SQLite-net\packages.config
	$(nuget) restore SQLite.sln

srcnuget: sqlite-net.nuspec $(SRC)
	$(nuget) pack sqlite-net.nuspec

pclnuget: sqlite-net-pcl.nuspec packages $(SRC)
	$(msbuild) -p:Configuration=Release "nuget\SQLite-net\SQLite-net.csproj"
	$(msbuild) -p:Configuration=Release "nuget\SQLite-net-std\SQLite-net-std.csproj"
	$(nuget) pack sqlite-net-pcl.nuspec -OutputDirectory .\

basenuget: sqlite-net-pcl.nuspec packages $(SRC)
	$(msbuild) -p:Configuration=Release "nuget\SQLite-net-base\SQLite-net-base.csproj"
	$(nuget) pack sqlite-net-base.nuspec -OutputDirectory .\

sqlciphernuget: sqlite-net-sqlcipher.nuspec packages $(SRC)
	$(msbuild) -p:Configuration=Release "nuget\SQLite-net-sqlcipher\SQLite-net-sqlcipher.csproj" 
	$(nuget) pack sqlite-net-sqlcipher.nuspec -OutputDirectory .\
