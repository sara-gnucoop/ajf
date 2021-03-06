#!/bin/bash

set -e

BAZEL_BINARY="./node_modules/.bin/bazel"

echo "Setup"
yarn install --non-interactive

echo "Lint"
"${BAZEL_BINARY}" build //:rollup_globals
yarn check-rollup-globals $("${BAZEL_BINARY}" info bazel-bin)/rollup_globals.json
"${BAZEL_BINARY}" build //:entry_points_manifest
yarn check-entry-point-setup $("${BAZEL_BINARY}" info bazel-bin)/entry_points_manifest.json
yarn -s lint
yarn -s ts-circular-deps:check

echo "Build - View Engine"
"${BAZEL_BINARY}" build src/... --build_tag_filters=-docs-package,-release-package --config=view-engine

echo "Unit tests - View Engine"
"${BAZEL_BINARY}" test src/... --build_tag_filters=-docs-package,-e2e --test_tag_filters=-e2e --config=view-engine --build_tests_only

echo "Integration tests"
yarn integration-tests:view-engine

echo "Build - Ivy"
"${BAZEL_BINARY}" build src/... --build_tag_filters=-docs-package,-release-package

echo "API guard tests"
"${BAZEL_BINARY}" test tools/public_api_guard/...

echo "Unit tests - Ivy"
"${BAZEL_BINARY}" test src/... --build_tag_filters=-e2e --test_tag_filters=-e2e --build_tests_only

echo "E2E tests"
"${BAZEL_BINARY}" test src/... --build_tag_filters=e2e --test_tag_filters=e2e --build_tests_only

echo "Release output"
yarn build
pkg_json_version=$(node -pe "require('./package.json').version")
expected_version="${pkg_json_version}-sha-$(git rev-parse --short HEAD)"
yarn check-release-output ${expected_version}
cp -R dist/releases/* node_modules/@ajf/
mv node_modules/__ngcc_entry_points__.json node_modules/__ngcc_entry_points__.json.back
yarn ngcc --error-on-failed-entry-point --no-tsconfig
mv node_modules/__ngcc_entry_points__.json.back node_modules/__ngcc_entry_points__.json
rm -Rf node_modules/@ajf/{calendars,core,ionic,material}
