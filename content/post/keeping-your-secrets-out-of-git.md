+++
date = "2018-01-04T15:00:00+01:00"
title = "Keeping your secrets out of git"
draft = false
+++

Ever had problems with pesky API keys, or developer-specific configurations making their way to your git upstream and overwriting their default values?<!--more-->

API keys, client secrets and other little gems slowly creep their way into your project. If your project is going to be public-facing, or ever wants to be in the future, you probably don't want these values to be committed to your git history for the world to see.

In a lot of the projects i've worked on in the past, theres usually a configuration file or two with default values for the application. Generally during development, i'd change these files for example to point to different environments, turn on / off various features of an application or to quickly get to certain parts of an application during development.

When working in a team, each developer or tester might want different values for the configurations and therefore its important that when they change these configuration files, they're not overwriting the default file in the index.

## Skipping the worktree

This little git command is great for ignoring changes to already tracked files, so that they don't accidentally get staged and committed / pushed to the remote. Great for keeping developer-specific configurations to the developers, and secrets kept secret.

{{< highlight shell >}}
$ git update-index --skip-worktree CustomSettings.plist
{{< /highlight >}}

When you do however want to start tracking changes to the file again you can simply use this command.

{{< highlight shell >}}
$ git update-index --no-skip-worktree CustomSettings.plist
{{< /highlight >}}

Its important to note, if you have `skip-worktree` set and do a `git reset --hard` it won't reset the local changes you've made to this file.

Also, if you're pulling from the remote and the file has changed there, you may need to unset the `skip-worktree` flag with `no-skip-worktree`, stash your changes, pull again and reapply your stashed changes (fixing merge-conflicts), and setting the `skip-worktree` flag.

Hopefully this little command will help you and your teams out! :)
