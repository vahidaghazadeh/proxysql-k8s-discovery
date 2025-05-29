# ProxySQL k8s Discovery Helm Chart

A Helm chart for deploying a **highly configurable ProxySQL cluster** with optional **dynamic backend discovery** via a custom Go-based updater in a Kubernetes environment.

> Designed for use with **MariaDB Galera** or other MySQL-compatible clusters.
>
> ⚙Supports both **static** and **dynamic** backend server configuration.

---

## Features

- Deploy multiple replicas of ProxySQL with clustering enabled
- Optional dynamic backend server discovery using a custom updater
- Full support for `mysql_servers`, `mysql_users`, and `mysql_query_rules`
- Supports external Galera clusters (e.g., Bitnami MariaDB Galera)
- Highly customizable via `values.yaml`
- Includes persistent `admin` and `monitor` user configurations
- Built-in health checks and monitoring support

---

## Prerequisites

- Kubernetes 1.18+
- Helm 3.x
- Existing MySQL/MariaDB Galera backend (external or within the cluster)
- (Optional) A container registry if using a private image

---

## Installation

```bash
helm repo add proxysql-k8s-discovery https://vahidaghazadeh.github.io/proxysql-k8s-discovery
helm repo update
helm search repo proxysql-k8s-discovery
````

## Or install directly from a local chart:
```bash
git clone https://github.com/vahidaghazadeh/proxysql-k8s-discovery.git
helm install proxysql-k8s-discovery ./proxysql-k8s-discovery --namespace namespace 
```

## Configuration
The chart is highly configurable. The following are key sections you can modify:

### Global Metadata

```shell
fullnameOverride: ""   # Override full name of chart
nameOverride: ""       # Override chart name
```

## ProxySQL Settings
```shell
proxysql:
  replicaCount: 3                 # Number of ProxySQL pods
  image: "proxysql/proxysql:2.7.1"
  imagePullPolicy: IfNotPresent
```

## Admin & Cluster Users
```shell
  adminUser: "admin"
  adminPassword: "your_admin_password"

  cluster_username: "cluster_user"
  cluster_password: "your_cluster_password"
```

## Monitoring & Routing
```shell
  writer_hostgroup: 10
  reader_hostgroup: 1
  offline_hostgroup: 4
  active: 1
```

## Users Example
### You can define multiple frontend/backend users here:
```shell
  users:
    - username: "app_writer"
      password: "securePassword"
      default_hostgroup: 0
      active: 1
      frontend: 1
      backend: 1
```
> [!NOTE]
> Avoid storing passwords directly in production. Use Kubernetes Secrets instead.

### Static MySQL Backend Mapping
#### Enable static mode and specify servers:
```shell
  mysql:
    static_mod: "true"
    servers:
      - address: "10.10.10.10"
        port: 3306
        hostgroup: 0
        max_connections: 100
```
### This maps directly to this in proxysql.cnf:
```shell
mysql_servers =
(
  { address = "10.10.10.10", port = 3306, hostgroup = 0, max_connections = 100 }
)
```

## Dynamic Discovery (Optional)
### Enable the Go-based updater if you want automatic syncing from Kubernetes Galera pods:
```shell
proxysqlUpdater:
  enabled: true
  image: "registry.iwcs.ir/proxysql-k8s-discovery:0.1.0"
```

## External Galera Integration
### Use this if your Galera cluster is deployed externally (e.g., Bitnami chart):

```shell
externalGalera:
  enabled: true
  namespace: "mariadb-cluster"
  headlessServiceName: "mariadb-cluster-mariadb-galera-headless"
  port: 3306
  hostgroup: 0
  monitorPassword: "MonitorPassword"
  passwordSecretName: "mariadb-monitor-password"
```

## Security Tips
### Store sensitive credentials (admin/monitor passwords) in Kubernetes Secrets.

### Avoid hardcoding passwords in values.yaml.
### Use Network Policies to restrict ProxySQL traffic.

## Testing
### After deploying, test ProxySQL:
```shell
kubectl port-forward svc/proxysql 6032:6032
mysql -u admin -p -h 127.0.0.1 -P 6032
```

```shell
kubectl port-forward svc/proxysql 6032:6032
mysql -u admin -p -h 127.0.0.1 -P 6032
```

Inside the MySQL prompt:
```shell
SELECT * FROM mysql_servers;
SELECT * FROM mysql_users;
```

## Uninstall
```shell
helm uninstall proxysql
```

📁 Folder Structure
```text
├── charts
│   └── proxysql
├── Chart.yaml
├── README.md
├── templates
│   ├── _helpers.tpl
│   ├── mariadb-monitor-password-secret.yaml
│   ├── NOTES.txt
│   ├── proxysql-admin-secret.yaml
│   ├── proxysql-cluster-secret.yaml
│   ├── proxysql-configmap.yaml
│   ├── proxysql-headless-service.yaml
│   ├── proxysql-networkpolicy.yaml
│   ├── proxysql-service.yaml
│   ├── proxysql-statefulset.yaml
│   ├── proxysql-updater-cluster-rbac.yaml
│   ├── proxysql-updater-deployment.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

Original ProxySQL authors – https://github.com/sysown/proxysql


