#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

REPO="garethr/kubernetes-json-schema"

declare -a arr=(
    #master
    v1.14.0
)

declare -a old=(
    v1.14.0
    v1.13.5
    v1.13.4
    v1.13.3
    v1.13.2
    v1.13.1
    v1.13.0
    v1.12.6
    v1.12.5
    v1.12.4
    v1.12.3
    v1.12.2
    v1.12.1
    v1.12.0
    v1.11.9
    v1.11.8
)

for version in "${arr[@]}"
do
schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
prefix=https://raw.githubusercontent.com/${REPO}/master/${version}/_definitions.json

openapi2jsonschema -o "${version}-standalone-strict" --expanded --kubernetes --stand-alone --strict "${schema}"
openapi2jsonschema -o "${version}-standalone" --expanded --kubernetes --stand-alone "${schema}"
openapi2jsonschema -o "${version}-local" --expanded --kubernetes "${schema}"
openapi2jsonschema -o "${version}" --expanded --kubernetes --prefix "${prefix}" "${schema}"

#openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
#openapi2jsonschema -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
#openapi2jsonschema -o "${version}-local" --kubernetes "${schema}"
#openapi2jsonschema -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
done
