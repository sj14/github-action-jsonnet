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
    "chart-test": {
        "runs-on": "self-hosted",
        steps: [
        {
            name: "Checkout repository",
            uses: "actions/checkout@v2",
        },
        ],
    },
  },
};


// jobs:
//   chart-test:
//     runs-on: self-hosted
//     steps:
//       - name: Checkout repository
//         uses: actions/checkout@v2
//       - name: Perform Chart tests
//         run: |
//           make chart-tests
//           git diff --exit-code

ci()
