#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

REPO="garethr/kubernetes-json-schema"

declare -a arr=(master
                v1.11.0
                v1.10.5
                v1.10.4
                v1.10.3
                v1.10.2
                v1.10.1
                v1.10.0
                v1.9.9
                v1.9.8
                v1.9.7
                v1.9.6
                v1.9.5
                v1.9.4
                v1.9.3
                v1.9.2
                v1.9.1
                v1.9.0
                v1.8.14
                v1.8.13
                v1.8.12
                v1.8.11
                v1.8.10
                v1.8.9
                v1.8.8
                v1.8.7
                v1.8.6
                v1.8.5
                v1.8.4
                v1.8.3
                v1.8.2
                v1.8.1
                v1.8.0
                v1.7.16
                v1.7.15
                v1.7.14
                v1.7.13
                v1.7.12
                v1.7.11
                v1.7.10
                v1.7.9
                v1.7.8
                v1.7.7
                v1.7.6
                v1.7.5
                v1.7.4
                v1.7.3
                v1.7.2
                v1.7.1
                v1.7.0
                v1.6.13
                v1.6.12
                v1.6.11
                v1.6.10
                v1.6.9
                v1.6.8
                v1.6.7
                v1.6.6
                v1.6.5
                v1.6.4
                v1.6.3
                v1.6.2
                v1.6.1
                v1.6.0
                v1.5.8
                v1.5.7
                v1.5.6
                v1.5.4
                v1.5.3
                v1.5.2
                v1.5.1
                v1.5.0
                )

for version in "${arr[@]}"
do
    recreate=false
    schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
    prefix=https://raw.githubusercontent.com/${REPO}/master/${version}/_definitions.json

    if [ "${recreate}" = true ] || [ ! -d "${version}-standalone-strict" ]; then
        openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
    fi

    if [ "${recreate}" = true ] || [ ! -d "${version}-standalone" ]; then
        openapi2jsonschema -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
    fi

    if [ "${recreate}" = true ] || [ ! -d "${version}-local" ]; then
        openapi2jsonschema -o "${version}-local" --kubernetes "${schema}"
    fi

    if [ "${recreate}" = true ] || [ ! -d "${version}-local-strict" ]; then
        openapi2jsonschema -o "${version}-local-strict" --kubernetes --strict "${schema}"
    fi


    if [ "${recreate}" = true ] || [ ! -d "${version}" ]; then
        openapi2jsonschema -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
    fi
done
