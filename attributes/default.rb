default[:resque][:queue] = '*'
default[:resque][:workers] = 2

node[:deploy].each do |application, deploy|
  
  default[:resque][application][:restart_command] = "sudo monit restart -g resque_#{application}_group"
  default[:resque][application][:queue] = node[:resque][:queue]
  default[:resque][application][:workers] = node[:resque][:workers]

  force_override["deploy"][application]["migrate"] = false
  
end

unless node["opsworks"]["instance"]["layers"].include?("rails-app")
  force_override[:opsworks][:rails_stack][:restart_command] = "echo 'meow'"
end
