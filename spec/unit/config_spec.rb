require 'spec_helper'

platforms = %w(debian ubuntu centos)
platforms.each do |platform, value|
  describe "grafana_ on #{platform}" do
    step_into :grafana_config, :grafana_install, :grafana_config_enterprise
    platform platform

    context 'create config with enterprise license key' do
      recipe do
        grafana_install 'package'

        grafana_config 'config' do
        end

        grafana_config_enterprise 'config' do
          license_path 'license.txt'
        end
      end

      it('should render config file') do
        is_expected.to render_file('/etc/grafana/grafana.ini').with_content(/license.txt/)
      end

      it('should reload grafana-server') do
        template = chef_run.template('/etc/grafana/grafana.ini')
        expect(template).to notify('service[grafana-server]').to(:restart).delayed
      end
    end
  end
end
