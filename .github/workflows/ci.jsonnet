local checkout() = {
    name: "Checkout repository",
    uses: "actions/checkout@v2",
};

local setup_go() = {
    uses: "actions/setup-go@v3",
    with: {
        "go-version": "1.18",
        cache: true,
        "cache-dependency-path": "go.sum",
    },
};

local ci() = {
  name: 'CI',
  on: {
    push: {
        paths: [
             '**.js',
        ],
    },
  },
  jobs: {
    "go-test": {
        "runs-on": "self-hosted",
        steps: [
            checkout(),
            setup_go(),
        ],
    },
  },
};


ci()
