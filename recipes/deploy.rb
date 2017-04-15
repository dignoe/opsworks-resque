include_recipe "opsworks-resque::setup"

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping resque::deploy application #{application} as it is not an Rails app")
    next
  end

  execute "restart resque processes for app #{application}" do
    cwd deploy[:current_path]
    command node[:resque][application][:restart_command]
    action :run
    
    only_if do 
      File.exists?(deploy[:current_path])
    end
  end

end
