Vagrant.configure("2") do |config|

  # ── Auto-detect host platform ─────────────────────────────────────
  is_arm     = RUBY_PLATFORM =~ /arm|aarch64/i
  is_mac     = RUBY_PLATFORM =~ /darwin/i
  is_windows = Vagrant::Util::Platform.windows?

  # ── Dynamic box ───────────────────────────────────────────────────
  BOX = is_arm ? "bento/ubuntu-22.04" : "ubuntu/jammy64"

  # ── Dynamic resource allocation ───────────────────────────────────
  if is_windows
    host_cpus   = `wmic cpu get NumberOfCores`.split("\n")[1].strip.to_i
    host_mem_mb = `wmic computersystem get TotalPhysicalMemory`.split("\n")[1].strip.to_i / 1024 / 1024
  elsif is_mac
    host_cpus   = `sysctl -n hw.physicalcpu`.strip.to_i
    host_mem_mb = `sysctl -n hw.memsize`.strip.to_i / 1024 / 1024
  else
    host_cpus   = `nproc`.strip.to_i
    host_mem_mb = `grep MemTotal /proc/meminfo`.scan(/\d+/).first.to_i / 1024
  end

  # Give each VM 1/4 of host CPUs and 1/4 of host RAM (min 1 CPU, 2GB RAM)
  VM_CPUS = [[host_cpus / 4, 1].max, 4].min
  VM_MEM  = [[host_mem_mb / 4, 2048].max, 4096].min

  puts "──────────────────────────────────────────"
  puts " Platform : #{is_arm ? 'ARM' : 'x86'} | #{is_mac ? 'macOS' : is_windows ? 'Windows' : 'Linux'}"
  puts " Box      : #{BOX}"
  puts " vCPUs    : #{VM_CPUS} | RAM: #{VM_MEM}MB per VM"
  puts "──────────────────────────────────────────"

  # ── Node definitions ──────────────────────────────────────────────
  nodes = {
    "master"  => { ip: "192.168.56.10", role: "server" },
    "worker1" => { ip: "192.168.56.11", role: "agent"  },
    "worker2" => { ip: "192.168.56.12", role: "agent"  }
  }

  nodes.each do |name, node|
    config.vm.define name do |machine|
      machine.vm.box      = BOX
      machine.vm.hostname = name
      machine.vm.network "private_network", ip: node[:ip]

      machine.ssh.insert_key    = true
      machine.ssh.forward_agent = true

      machine.vm.provider "virtualbox" do |vb|
        vb.memory = VM_MEM
        vb.cpus   = VM_CPUS
        vb.name   = name
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
      end

      machine.vm.provision "shell",
        path: "bootstrap.sh",
        args: [node[:role], name]
    end
  end

end