#!/bin/bash -xe

# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

REPO="garethr/kubernetes-json-schema"

declare -a arr=(master
                v1.18.2
                v1.18.1
                v1.18.0
                v1.17.5
                v1.17.4
                v1.17.3
                v1.17.2
                v1.17.1
                v1.17.0
                v1.16.9
                v1.16.8
                v1.16.7
                v1.16.6
                v1.16.5
                v1.16.4
                v1.16.3
                v1.16.2
                v1.16.1
                v1.16.0
                v1.15.11
                v1.15.10
                v1.15.9
                v1.15.4
                v1.15.8
                v1.15.7
                v1.15.6
                v1.15.5
                v1.15.4
                v1.15.3
                v1.15.2
                v1.15.1
                v1.15.0
                v1.14.10
                v1.14.9
                v1.14.8
                v1.14.7
                v1.14.6
                v1.14.5
                v1.14.4
                v1.14.3
                v1.14.2
                v1.14.1
                v1.14.0

                )

for version in "${arr[@]}"
do
    schema=https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json
    prefix=https://raw.githubusercontent.com/${REPO}/master/${version}/_definitions.json

    if [ -n "${RECREATE}" ] || [ ! -d "${version}-standalone-strict" ]; then
        openapi2jsonschema -o "${version}-standalone-strict" --kubernetes --stand-alone --strict "${schema}"
    fi

    if [ -n "${RECREATE}" ] || [ ! -d "${version}-standalone" ]; then
        openapi2jsonschema -o "${version}-standalone" --kubernetes --stand-alone "${schema}"
    fi

    if [ -n "${RECREATE}" ] || [ ! -d "${version}-local" ]; then
        openapi2jsonschema -o "${version}-local" --kubernetes "${schema}"
    fi

    if [ -n "${RECREATE}" ] || [ ! -d "${version}-local-strict" ]; then
        openapi2jsonschema -o "${version}-local-strict" --kubernetes --strict "${schema}"
    fi


    if [ "${recreate}" = true ] || [ ! -d "${version}" ]; then
        openapi2jsonschema -o "${version}" --kubernetes --prefix "${prefix}" "${schema}"
    fi
done
