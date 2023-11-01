resource "shoreline_notebook" "no_space_left_on_device_error_when_pulling_docker_images" {
  name       = "no_space_left_on_device_error_when_pulling_docker_images"
  data       = file("${path.module}/data/no_space_left_on_device_error_when_pulling_docker_images.json")
  depends_on = [shoreline_action.invoke_analyze_directory,shoreline_action.invoke_check_syslog_size,shoreline_action.invoke_remove_dangling_images]
}

resource "shoreline_file" "analyze_directory" {
  name             = "analyze_directory"
  input_file       = "${path.module}/data/analyze_directory.sh"
  md5              = filemd5("${path.module}/data/analyze_directory.sh")
  description      = "Identify the files or directories consuming excessive space on the disk by using a disk space analyzer tool like 'ncdu' or running the 'df' command to see the disk usage."
  destination_path = "/tmp/analyze_directory.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_syslog_size" {
  name             = "check_syslog_size"
  input_file       = "${path.module}/data/check_syslog_size.sh"
  md5              = filemd5("${path.module}/data/check_syslog_size.sh")
  description      = "Truncate the /var/log/syslog if the size is large and your containers emit logs"
  destination_path = "/tmp/check_syslog_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "remove_dangling_images" {
  name             = "remove_dangling_images"
  input_file       = "${path.module}/data/remove_dangling_images.sh"
  md5              = filemd5("${path.module}/data/remove_dangling_images.sh")
  description      = "Remove any dangling docker images"
  destination_path = "/tmp/remove_dangling_images.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_analyze_directory" {
  name        = "invoke_analyze_directory"
  description = "Identify the files or directories consuming excessive space on the disk by using a disk space analyzer tool like 'ncdu' or running the 'df' command to see the disk usage."
  command     = "`chmod +x /tmp/analyze_directory.sh && /tmp/analyze_directory.sh`"
  params      = ["OUTPUT_FILE_PATH","DIRECTORY_PATH"]
  file_deps   = ["analyze_directory"]
  enabled     = true
  depends_on  = [shoreline_file.analyze_directory]
}

resource "shoreline_action" "invoke_check_syslog_size" {
  name        = "invoke_check_syslog_size"
  description = "Truncate the /var/log/syslog if the size is large and your containers emit logs"
  command     = "`chmod +x /tmp/check_syslog_size.sh && /tmp/check_syslog_size.sh`"
  params      = ["MAX_SIZE"]
  file_deps   = ["check_syslog_size"]
  enabled     = true
  depends_on  = [shoreline_file.check_syslog_size]
}

resource "shoreline_action" "invoke_remove_dangling_images" {
  name        = "invoke_remove_dangling_images"
  description = "Remove any dangling docker images"
  command     = "`chmod +x /tmp/remove_dangling_images.sh && /tmp/remove_dangling_images.sh`"
  params      = []
  file_deps   = ["remove_dangling_images"]
  enabled     = true
  depends_on  = [shoreline_file.remove_dangling_images]
}

