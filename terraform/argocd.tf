resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argocd"
  create_namespace = true
  version = "5.27.3"

  set {
    name = "server.extraArgs"
    value = "{--insecure}"
  }
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.hosts[0]"
    value = ""
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
}