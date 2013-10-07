packages = %w{git}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

# create wpcli dir
directory node['wp-cli']['wpcli-dir'] do
  recursive true
end

# download installer
remote_file "#{node['wp-cli']['wpcli-dir']}/installer.sh" do
  source 'http://wp-cli.org/installer.sh'
  mode 0755
  action :create_if_missing
end

bin = ::File.join(node['wp-cli']['wpcli-dir'], 'bin', 'wp')

# run installer
bash 'install wp-cli' do
  code './installer.sh'
  cwd node['wp-cli']['wpcli-dir']
  environment 'INSTALL_DIR' => node['wp-cli']['wpcli-dir'],
              'VERSION' => node['wp-cli']['wpcli-version']
  creates bin
end

# link wp bin
link node['wp-cli']['wpcli-link'] do
  to bin
end
