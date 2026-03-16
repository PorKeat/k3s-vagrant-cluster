# K3s Cluster with Vagrant

A local K3s Kubernetes cluster with 1 master and 2 worker nodes using Vagrant and VirtualBox.

**Author:** Porkeat

---

## Requirements

| Tool       |
| ---------- |
| Vagrant    |
| VirtualBox |
| Just       |

### Install on macOS

```bash
brew install vagrant just
brew install --cask virtualbox
```

### Install on Windows

```powershell
winget install Hashicorp.Vagrant
winget install Oracle.VirtualBox
winget install Casey.Just
```

### Install on Linux

```bash
sudo apt install vagrant virtualbox
cargo install just
```

---

## Cluster Overview

| Node    | IP            | Role       |
| ------- | ------------- | ---------- |
| master  | 192.168.56.10 | K3s Server |
| worker1 | 192.168.56.11 | K3s Agent  |
| worker2 | 192.168.56.12 | K3s Agent  |

---

## Getting Started

**1. Clone the repo**

```bash
git clone https://github.com/PorKeat/k3s-vagrant-cluster.git
cd k3s
```

**2. Start the cluster**

```bash
just up
```

**3. SSH into master**

```bash
just ssh
```

**4. Verify nodes are ready**

```bash
kubectl get nodes
```

Expected output:

```
NAME      STATUS   ROLES                  AGE   VERSION
master    Ready    control-plane,master   1m    v1.34.5+k3s1
worker1   Ready    <none>                 1m    v1.34.5+k3s1
worker2   Ready    <none>                 1m    v1.34.5+k3s1
```

---

## Commands

| Command             | Description                      |
| ------------------- | -------------------------------- |
| `just up`           | Start the cluster                |
| `just down`         | Stop the cluster                 |
| `just destroy`      | Destroy the cluster              |
| `just restart`      | Restart the cluster              |
| `just status`       | Show VM status                   |
| `just ssh`          | SSH into master                  |
| `just ssh-worker1`  | SSH into worker1                 |
| `just ssh-worker2`  | SSH into worker2                 |
| `just nodes`        | Show K3s node status             |
| `just pods`         | Show all running pods            |
| `just logs`         | Stream master logs               |
| `just logs-worker1` | Stream worker1 logs              |
| `just logs-worker2` | Stream worker2 logs              |
| `just kubeconfig`   | Copy kubeconfig to local machine |

---

## Project Structure

```
k3s/
├── Vagrantfile       # VM configuration
├── bootstrap.sh      # K3s install script
├── Justfile          # Task runner commands
└── README.md         # This file
```

---

## Platform Support

| Platform            | Box                        | Provider        |
| ------------------- | -------------------------- | --------------- |
| macOS Apple Silicon | `bento/ubuntu-22.04` (ARM) | VirtualBox 7.1+ |
| macOS Intel         | `ubuntu/jammy64`           | VirtualBox      |
| Windows x86         | `ubuntu/jammy64`           | VirtualBox      |
| Linux x86           | `ubuntu/jammy64`           | VirtualBox      |

> The Vagrantfile auto-detects your platform and selects the correct box automatically.

---

## Teardown

```bash
just destroy
```
