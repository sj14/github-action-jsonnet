local step_checkout() = {
    name: "Checkout repository",
    uses: "actions/checkout@v2",
};

local step_setup_go(version="1.18", cache=true, cache_dependency_path="go.sum") = {
    uses: "actions/setup-go@v3",
    with: {
        "go-version": version,
        "cache": cache,
        "cache-dependency-path": cache_dependency_path,
    },
};

local step_check_go_modules() = {
    name: "Check Go modules",
    run: |||
        set -xu
        go mod verify
        go mod tidy
        git diff --exit-code
    |||
};

local step_go_tests() = {
    name: "Run Go tests",
    run: |||
        set -xu
        go test ./...
    |||
};

local step_golangci(version="v1.46.2", skip_cache=true) = {
    name: "Run golangci linting",
    uses: "golangci/golangci-lint-action@v3.2.0",
    with: {
        version: version,
        # Otherwise, the prepare environment step fails :-(
        # closed issue but still present: https://github.com/golangci/golangci-lint-action/issues/135
        "skip-cache": skip_cache,
    },
};



local job_go_tests(runs_on="ubuntu-22.04",) = {
    "go-tests": {
        "runs-on": runs_on,
        steps: [
            step_checkout(),
            step_setup_go(),
            step_check_go_modules(),
            step_go_tests(),
            step_golangci(),
        ],
    },
};

local on_push_paths(paths) = {
    push: {
        paths: paths,
    },
};


local worfklow(name, on, jobs) = {
  name: name,
  on: on,
  jobs: jobs,
};


worfklow(
    name="CI", 
    on=on_push_paths(["**"]),
    jobs=job_go_tests(),
    )
