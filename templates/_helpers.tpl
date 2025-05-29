{{/*
Expand the name of the chart.
*/}}
{{- define "proxysql-k8s-discovery.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "proxysql-k8s-discovery.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as part of the labels.
*/}}
{{- define "proxysql-k8s-discovery.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "proxysql-k8s-discovery.labels" -}}
helm.sh/chart: {{ include "proxysql-k8s-discovery.chart" . }}
{{ include "proxysql-k8s-discovery.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "proxysql-k8s-discovery.selectorLabels" -}}
app.kubernetes.io/name: {{ include "proxysql-k8s-discovery.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the ProxySQL service (ClusterIP)
*/}}
{{- define "proxysql-k8s-discovery.proxysqlServiceName" -}}
{{- printf "%s-proxysql" (include "proxysql-k8s-discovery.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the ProxySQL headless service (for StatefulSet)
*/}}
{{- define "proxysql-k8s-discovery.proxysqlHeadlessServiceName" -}}
{{- printf "%s-proxysql-headless" (include "proxysql-k8s-discovery.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the ProxySQL admin secret
*/}}
{{- define "proxysql-k8s-discovery.proxysqlAdminSecretName" -}}
{{- printf "%s-proxysql-admin" (include "proxysql-k8s-discovery.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "proxysql-k8s-discovery.proxysqlClusterSecretName" -}}
{{- printf "%s-proxysql-cluster" (include "proxysql-k8s-discovery.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the ProxySQL Updater ServiceAccount
*/}}
{{- define "proxysql-k8s-discovery.proxysqlUpdaterServiceAccountName" -}}
{{- printf "%s-proxysql-updater-sa" (include "proxysql-k8s-discovery.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
