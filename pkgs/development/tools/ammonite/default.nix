{ stdenv, lib, fetchurl, makeWrapper, jre, gnused
, disableRemoteLogging ? true
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "ammonite-${version}";
  version = "1.2.1";
  scalaVersion = "2.12";

  src = fetchurl {
    url = "https://github.com/lihaoyi/Ammonite/releases/download/${version}/${scalaVersion}-${version}";
    sha256 = "096xychdq1pmyjfv4cv4pvm29dk539rxpq3iaz9rpznp01af4mjf";
  };

  propagatedBuildInputs = [ jre ] ;
  buildInputs = [ makeWrapper gnused ] ;

  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/amm
    chmod +x $out/bin/amm
    ${gnused}/bin/sed -i '0,/java/{s|java|${jre}/bin/java|}' $out/bin/amm
  '' + optionalString (disableRemoteLogging) ''
    ${gnused}/bin/sed -i '0,/ammonite.Main/{s|ammonite.Main|ammonite.Main --no-remote-logging|}' $out/bin/amm
  '';

  meta = {
    description = "Improved Scala REPL";
    longDescription = ''
        The Ammonite-REPL is an improved Scala REPL, re-implemented from first principles.
        It is much more featureful than the default REPL and comes
        with a lot of ergonomic improvements and configurability
        that may be familiar to people coming from IDEs or other REPLs such as IPython or Zsh.
    '';
    homepage = http://www.lihaoyi.com/Ammonite/;
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nequissimus ];
  };
}
