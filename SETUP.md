## Setup notes

This setup notes include setup information of how to create this repository.

### Create the application chart

#### Create the skeleton chart by using helm create

```sh

helm create production
mv production chart
```

#### Enable environment variables passthrough & support Istio

Update the `chart/templates/deployment.yaml`

```diff
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
+         env:
+           {{- toYaml .Values.env | nindent 12 }}
```

Update the `Chart.yaml`

```diff
-appVersion: "1.16.0"
+appVersion: "latest"
```

### Add helm hook for database migration

Create the `chart/templates/db-migrate-hook.yaml`

```yaml
{{- if .Values.migrateCommand -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "production.fullname" . }}-db-migrate
  labels:
    {{- include "production.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-install, pre-upgrade
    "helm.sh/hook-delete-policy": before-hook-creation
    "helm.sh/hook-weight": "0"
spec:
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "production.selectorLabels" . | nindent 8 }}
    spec:
      restartPolicy: Never
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          command: ["/bin/sh"]
          args: ["-c", "{{ .Values.migrateCommand }}"]
          env:
            {{- toYaml .Values.env | nindent 12 }}
{{- end -}}
```
