module VBoxUtils
    def self.check_version(min_version)
      min_vbox_version = Gem::Version.new(min_version)
  
      vboxmanage_path = Vagrant::Util::Which.which("VBoxManage") || Vagrant::Util::Which.which("VBoxManage.exe")
  
      if vboxmanage_path == nil
          if (ENV.key?("VBOX_INSTALL_PATH") || ENV.key?("VBOX_MSI_INSTALL_PATH"))
                path = ENV["VBOX_INSTALL_PATH"] || ENV["VBOX_MSI_INSTALL_PATH"]
  
                # There can actually be multiple paths in here, so we need to
                # split by the separator ";" and see which is a good one.
                path.split(";").each do |single|
                  # Make sure it ends with a \
                  single += "\\" if !single.end_with?("\\")
  
                  # If the executable exists, then set it as the main path
                  # and break out
                  vboxmanage = "#{single}VBoxManage.exe"
                  if File.file?(vboxmanage)
                    vboxmanage_path = Vagrant::Util::Platform.cygwin_windows_path(vboxmanage)
                    break
                  end
                end
          else
              # If we still don't have one, try to find it using common locations
              drive = ENV["SYSTEMDRIVE"] || "C:"
              [
                "#{drive}/Program Files/Oracle/VirtualBox",
                "#{drive}/Program Files (x86)/Oracle/VirtualBox",
                "#{ENV["PROGRAMFILES"]}/Oracle/VirtualBox"
              ].each do |maybe|
                  path = File.join(maybe, "VBoxManage.exe")
                  if File.file?(path)
                     vboxmanage_path = path
                     break
                  end
              end
          end
      end
  
      if vboxmanage_path == nil
      Warning.warn("VBoxManage not found. Check your VirtualBox installation\n")
      return
      end
  
      s = Vagrant::Util::Subprocess.execute(vboxmanage_path, '--version')
      version = s.stdout.strip!
      clean_version = /[0-9]+\.[0-9]+\.[0-9]+/.match(version)
  
      if Gem::Version.new(clean_version) < min_vbox_version
      puts "VBoxManage path: #{vboxmanage_path}"
      puts "VirtualBox version: #{clean_version} (#{version})"
      abort "Please upgrade to Virtualbox >= #{min_vbox_version}"
      end
    end
  end