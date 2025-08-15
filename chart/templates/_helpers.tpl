{{/*
Expand the name of the chart.
*/}}
{{- define "pm-cb-redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pm-cb-redis.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pm-cb-redis.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pm-cb-redis.labels" -}}
helm.sh/chart: {{ include "pm-cb-redis.chart" . }}
{{ include "pm-cb-redis.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pm-cb-redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pm-cb-redis.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate Redis password
*/}}
{{- define "pm-cb-redis.password" -}}
{{- if .Values.security.password -}}
    {{- .Values.security.password -}}
{{- else if .Values.security.useRandomPassword -}}
    {{- randAlphaNum 16 -}}
{{- else -}}
    {{- fail "A password is required. Set security.password or security.useRandomPassword=true" -}}
{{- end -}}
{{- end -}}