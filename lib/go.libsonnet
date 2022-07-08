local utils = import 'utils.libsonnet';

{
  step_setup_go(version=null, go_version_file='go.mod', check_latest=false, cache=true, cache_dependency_path='go.sum'): {
    uses: 'actions/setup-go@v3',
    with: {
      'go-version': version,  // has precedence over go-version-file when set
      'go-version-file': go_version_file,
      'check-latest': check_latest,
      cache: cache,
      'cache-dependency-path': cache_dependency_path,
    },
  },

  step_check_go_modules(): {
    name: 'Check Go modules',
    run: |||
      set -ux
      go mod verify
      go mod tidy
      git diff --exit-code
    |||,
  },

  step_go_fmt(): {
    name: 'Check Go formatting',
    run: |||
      set -ux
      go fmt ./...
      git diff --exit-code
    |||,
  },

  step_go_tests(): {
    name: 'Run Go tests',
    run: |||
      set -ux
      go test -race ./...
    |||,
  },

  step_golangci(version='v1.46.2', skip_cache=true): {
    name: 'Run golangci linting',
    uses: 'golangci/golangci-lint-action@v3.2.0',
    with: {
      version: version,
      // Otherwise, the prepare environment step fails :-(
      // closed issue but still present: https://github.com/golangci/golangci-lint-action/issues/135
      'skip-cache': skip_cache,
    },
  },

  job_go_tests(runs_on=utils.runs_on()):: {
    'go-tests': {
      'runs-on': runs_on,
      steps: [
        utils.step_checkout(),
        $.step_setup_go(),
        $.step_check_go_modules(),
        $.step_go_fmt(),
        $.step_go_tests(),
        $.step_golangci(),
      ],
    },
  },

}
