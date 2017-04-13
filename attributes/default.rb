default[:resque][:queue] = '*'
default[:resque][:workers] = 2

node[:deploy].each do |application, deploy|
  
  default[:resque][application][:restart_command] = "sudo monit restart -g resque_#{application}_group"
  default[:resque][application][:queue] = node[:resque][:queue]
  default[:resque][application][:workers] = node[:resque][:workers]
  
end
