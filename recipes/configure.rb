include_recipe "resque::service"

# setup resque service per app
node[:deploy].each do |application, deploy|
  
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping resque::setup application #{application} as it is not a Rails app")
    next
  end
  
  # Allow deploy user to restart workers
  template "/etc/sudoers.d/#{deploy[:user]}" do
    mode 0440
    source "sudoer.erb"
    variables :user => deploy[:user]
  end
  
  template "/etc/monit.d/resque_#{application}.monitrc" do
    mode 0644
    source "resque.monitrc.erb"
    variables(:deploy => deploy, :application => application, :queue => node[:resque][application][:queue], :worker_count => node[:resque][application][:workers])
    
    notifies :reload, resources(:service => "monit"), :immediately
  end
  
end