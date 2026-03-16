# ── Detect platform ───────────────────────────────────────────────
arch := `uname -m`
os   := `uname -s`

# ── Default recipe ────────────────────────────────────────────────
default:
    @just --list

# ── Cluster lifecycle ─────────────────────────────────────────────
up:
    @echo "Platform: {{os}} | Arch: {{arch}}"
    @echo "Starting K3s cluster..."
    vagrant up
    @echo "✅ Cluster is up!"
    @just status

down:
    @echo "Stopping K3s cluster..."
    vagrant halt
    @echo "✅ Cluster stopped."

destroy:
    @echo "⚠️  Destroying K3s cluster..."
    vagrant destroy -f
    @echo "✅ Cluster destroyed."

restart:
    @echo "Restarting K3s cluster..."
    vagrant reload
    @echo "✅ Cluster restarted."
    @just status

provision:
    @echo "Re-provisioning K3s cluster..."
    vagrant provision
    @echo "✅ Provisioning complete."

# ── SSH access ────────────────────────────────────────────────────
ssh:
    vagrant ssh master

ssh-master:
    vagrant ssh master

ssh-worker1:
    vagrant ssh worker1

ssh-worker2:
    vagrant ssh worker2

# ── Monitoring ────────────────────────────────────────────────────
status:
    vagrant status

logs:
    vagrant ssh master -- "sudo journalctl -u k3s -f"

logs-worker1:
    vagrant ssh worker1 -- "sudo journalctl -u k3s-agent -f"

logs-worker2:
    vagrant ssh worker2 -- "sudo journalctl -u k3s-agent -f"

# ── K3s cluster info ──────────────────────────────────────────────
nodes:
    vagrant ssh master -- "sudo kubectl get nodes -o wide"

pods:
    vagrant ssh master -- "sudo kubectl get pods -A"

kubeconfig:
    @echo "Copying kubeconfig to ~/.kube/config..."
    vagrant ssh master -- "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config
    sed -i '' 's/127.0.0.1/192.168.56.10/g' ~/.kube/config
    @echo "✅ kubeconfig ready. Run: kubectl get nodes"