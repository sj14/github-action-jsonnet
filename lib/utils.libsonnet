local go = import 'go.libsonnet';

{
  runs_on():: ['self-hosted', 'generic'],

  step_checkout():: {
    name: 'Checkout repository',
    uses: 'actions/checkout@v2',
  },

  step_get_version():: {
    name: 'Get latest release version number',
    uses: 'battila7/get-version-action@v2',
    id: 'get_version',
  },

  step_setup_yq():: {
    name: 'Setup yq',
    run: |||
      set -ux
      sudo wget https://github.com/mikefarah/yq/releases/download/v4.25.3/yq_linux_amd64 -O /usr/bin/yq
      sudo chmod +x /usr/bin/yq
    |||,
  },

  step_setup_jsonnet():: {
    name: 'Setup jsonnet',
    run: |||
      set -ux
      wget https://github.com/google/go-jsonnet/releases/download/v0.18.0/go-jsonnet_0.18.0_Linux_x86_64.tar.gz -O jsonnet.tar.gz
      tar -zxvf jsonnet.tar.gz jsonnet jsonnetfmt
      sudo rm jsonnet.tar.gz
      sudo chmod +x jsonnet jsonnetfmt
      sudo mv jsonnet jsonnetfmt /usr/bin/
    |||,
  },

  // job_check_workflows(runs_on=self.runs_on()):: {
  //   'check-workflows': {
  //     'runs-on': runs_on,
  //     steps: [
  //       $.step_checkout(),
  //       $.step_setup_jsonnet(),
  //       {
  //         name: 'Generate Workflows',
  //         run: |||
  //           set -ux
  //           make generate-github-workflows
  //           git diff --exit-code
  //         |||,
  //       },
  //     ],
  //   },
  // },

  // job_link_check(runs_on=self.runs_on()):: {
  //   'link-checker': {
  //     'runs-on': runs_on,
  //     steps: [
  //       $.step_checkout(),
  //       {
  //         name: 'Link Checker',
  //         uses: 'lycheeverse/lychee-action@v1.2.1',
  //         with: {
  //           args: '--verbose --exclude-file=./.lycheeignore "**/*.md"',
  //           fail: true,
  //           format: 'detailed',
  //         },
  //         env: {
  //           GITHUB_TOKEN: '${{ secrets.GOVERNANCE_GITHUB_TOKEN }}',
  //         },
  //       },
  //     ],
  //   },
  // },

}
