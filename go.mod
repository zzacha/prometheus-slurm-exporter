module prometheus-slurm-exporter

go 1.17 //latest go version avail on OCPv4.12 az uks

require (
	github.com/prometheus/client_golang v1.14.0 // latest supported for go v1.17
	github.com/stretchr/testify v1.10.0
	google.golang.org/protobuf v1.33.0 // indirect; Addressed CVE-2024-24786

)

require (
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/golang/protobuf v1.5.2 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.1 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/prometheus/client_model v0.3.0 // indirect
	github.com/prometheus/common v0.37.0 // indirect
	github.com/prometheus/procfs v0.8.0 // indirect
	golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)
