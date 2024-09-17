
/**
 * Provides base help content structure as a string.
 *
 * @todo refactor this when implementing a javascript tour using messages to invoke vscode commands.
 */
export function getHelpContent(): string {
  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initila-scale=1.0">
    <title>Getting Started Contributing with DrupalPod</title>

    <style type="text/css">
body {
  font-family: sans-serif;
  font-size: 15px;
}
#header,
#main,
#footer {
  width: 100%;
  margin: .5rem 0;
}
.footer__nav {
  display: flex;
  justify-content: flex-start;
  align-items: baseline;
}
.emoji {
  font-size: 20px;
}
.nav__link {
  padding: .15rem .25rem;
  margin: 0 .25rem;
}
    </style>
  </head>
  <body>
    <div id="page-help">
      <header id="header">
        <h1>Getting Started Contributing to Drupal</h1>
      </header>
      <main id="main">
        <section>
          <header>
            <h2>Getting Started with DrupalPod</h2>
          </header>
          <ol class="list--ordered">
            <li><span class="emoji">⬇️</span> Wait until the “Terminal” completes its operations. Drupal will open in the panel when it is complete <span class="emoji">➡️</span></li>
            <li><span class="emoji">➡️</span> You can use the “Simple Browser” to use Drupal. Go ahead and install Drupal now if it is not installed.
              <ul>
                <li>Note: You will use <code>db</code> as the username, password, database name and host (Advanced Options).</li>
              </ul>
            </li>
            <li><span class="emoji">⬅️</span> Press the “Explorer” button. You can access and modify files in Drupal core and contrib by going expanding the "repos" directory.</li>
            <li><span class="emoji">⬅️</span> Press the “Remote Explorer” button. It shows the services provided by DrupalPod.
              <ul>
                <li>Find the “8080” item in the list.</li>
                <li>Press the “Globe" button to open Drupal in a new tab or window.</li>
                <li>Press the “Open Preview” button to open Drupal in the Simple Browser as a panel in the editor.</li>
              </ul>
            </li>
            <li><span class="emoji">⬇️</span> You can use the “Terminal” below to run git, ddev and drush. But first we need to setup SSH access if you have not done so already.
              <ul>
                <li>Run the following command in the Terminal: <code>.gitpod/drupal/ssh/00-interactive-ssh-setup.sh</code> and then follow the instructions in the tab that appears.</li>
              </ul>
            </li>
          </ol>
        </section>

        <section>
          <header>
            <h2>What's Next?</h2>
          </header>
          <ul class="list--unordered">
            <li><a href="https://drupal.org/user/register">Create a drupal.org user account</a>.</li>
            <li>Join us on <a href="https://drupal.org/slack">Drupal Slack</a> in the <a href="https://drupal.slack.com/archives/C1BMUQ9U6">#contribute</a> channel.</li>
            <li>Find a <a href="https://www.drupal.org/community/contributor-guide/find-a-task">Contributor Task</a> such as
              <ul>
                <li>Manually test an issue</li>
                <li>Write a patch or contribute to an issue fork</li>
                <li>Write an automated test</li>
                <li>Run automated tests:
                  <ul>
                    <li>Nightwatch: <code>ddev nightwatch</code></li>
                    <li>PHPUnit: <code>ddev phpunit</code></li>
                  </ul>
                </li>
              </ul>
            </li>
            <li>Find your <a href="https://www.drupal.org/community/contributor-guide/find-your-role">role</a> or <a href="https://www.drupal.org/community/contributor-guide/use-or-improve-your-skills">skill</a> to learn more about how to contribute, or ask if anyone needs some help on an issue in #contribute.</li>
          </ul>
          <aside>Remember there are many <a href="https://www.drupal.org/community/contributor-guide/contribution-areas">Contribution areas</a> that need your help.</aside>
        </section>
      </main>
      <footer id="footer">
        <nav class="footer__nav" aria-describedby="footerNavHeader">
          <strong id="footerNavHeader">Helpful Links:</strong>
          <a href="https://github.com/shaal/DrupalPod" class="nav__link">DrupalPod</a>
          <a href="https://drupal.org/community/contributor-guide" class="nav__link">Contributor Guide</a>
          <a href="https://drupal.org/project/issues/search/drupal" class="nav__link">Core Issue Queue</a>
          <a href="https://drupal.org/chat" class="nav__link">Chat With the Community</a>
        </nav>
      </footer>
    </div>
  </body>
</html>`;
}
