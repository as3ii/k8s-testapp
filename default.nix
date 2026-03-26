{
  lib,
  buildGo125Module,
  glibc,
  static ? false,
}:

buildGo125Module (final: {
  pname = "k8s-testapp";
  version = "0.0.2";

  src = lib.cleanSource ./src/.;
  vendorHash = "sha256-aOcwjelq68EMOje6gGjBWMY5GUlnD4Gy9ZhMQjnbvs4=";

  buildInputs = lib.optionals static [ glibc.static ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${final.version}"
  ]
  ++ lib.optionals static [
    "-linkmode external"
    "-extldflags '-static'"
  ];

  meta = {
    description = "App to test my k8s cluster";
    mainProgram = "k8s-testapp";
  };
})
