{
  callPackage,
  dockerTools,
  cacert,
  created ? "now",
  revision ? null,
  k8s-testapp ? callPackage ./default.nix { },
}:

dockerTools.streamLayeredImage {
  inherit created;
  name = "k8s-testapp";

  contents = [
    cacert
    k8s-testapp
  ];

  config = {
    WorkingDir = "/root";
    ExposedPorts = {
      "8080" = { };
    };
    Cmd = [ "/bin/k8s-testapp" ];
    Labels = {
      "org.opencontainers.image.title" = "k8s-testapp";
      "org.opencontainers.image.revision" = revision;
      "org.opencontainers.image.version" = k8s-testapp.version;
      "org.opencontainers.image.source" = "https://github.com/as3ii/k8s-testapp";
    };
  };
}
