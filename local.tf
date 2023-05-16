#--local/main--

locals {

  source_files = [
    "${path.module}/start.py",
    "${path.module}/stop.py",
  ]
}