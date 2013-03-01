maintainer       "Akretion"
maintainer_email "contact@akretion.com"
license          "Apache 2.0"
description      "Installs/Configures LNMP"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends          "ak-tools"

%w{ ubuntu }.each do |os|
      supports os
end
