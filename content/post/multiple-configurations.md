+++
date = "2017-06-11T12:00:00+01:00"
title = "Multiple configurations"
draft = false
+++

We're going to take a look at creating multiple configurations for our application, and then using schemes to point at each of the different configurations.

If you haven't checked out my [previous blog post](/app-with-multiple-environments/) on multiple environments, i'd suggest taking a look at that first, as this will be directly building upon some of the concepts shown in there.

## Creating configurations

To create another configuration, its recommended that you duplicate the existing `Debug` or `Release` configuration as a base.

You can do this, by selecting your project from the project hierarchy window, and then selecting your project (instead of your iOS app target) from the left pane.

This will bring up your project info settings, and show your current configurations. By default on a new project you should have `Debug` and `Release` configurations.

{{< image src="/static/configurations_default.png" width="1366px" height="616px" alt="Default configurations" >}}

For the example i'm going to show you, we're going to have 3 sets of configurations. One for our development environment and settings, one for staging, and a final one for production.

Start by duplicate the `Debug` configuration twice (using the `+` icon), renaming the first to `DebugDev` and the second to `DebugStaging`. Then duplicate the `Release` configuration twice, similarly naming them as `ReleaseDev` and `ReleaseStaging`. Once done, it should look like the below image.

{{< image src="/static/multiple_configurations.png" width="1120px" height="896px" alt="Multiple configurations" >}}

If you're using Cocoapods to manage your frameworks, you'll need to run the following command to ensure it regenerates the appropriate `.xcconfig` files. Otherwise it will continue to use your debug and release xcconfig cocoapod files, and may cause issues down the line.

{{< highlight shell >}}
$ pod install
{{< /highlight >}}

After running the command, if you look at each configuration - it should have appropriately named `.xcconfig` files.

## Verifying the configurations behave differently

Go to your target build settings, and search for `Other Swift Flags`, similarly as we did in the previous blog post.

Expand the build setting, and you should see all six configurations.
Lets set the `-D DEVELOPMENT` and `-D STAGING` flags for the development and staging configurations respectively (for both debug and release versions).

{{< image src="/static/other_swift_flags_2.png" width="1586px" height="450px" alt="Other Swift Flags" >}}

Once you have these flags set, you'll be able to use them inside your Swift code to [conditionally compile different functionality](/app-with-multiple-environments/).

Currently, when you run the application it will use the Debug or Release configurations. It will continue to use the production settings - and not use the development, or staging ones. This is because we've set it to default to production settings if a `DEVELOPMENT` or `STAGING` flag has not been set.

Lets try and make it use the development, and staging settings instead.
To do this, you'll need to create another Xcode Scheme.

## Schemes

Next to your run button at the top-left, is a drop down for your current schemes. Select the drop down, and then select manage schemes.

Alternatively, you can go to the menu at the top, select `Product`, then `Scheme`, then `Manage Schemes...`.

By default, Xcode should auto create a scheme for each target in your project or workspace.

You'll want to duplicate the auto-created scheme for your iOS target, and rename it to `<TargetName>Dev`, similarly for staging `<TargetName>Staging`. You should have three schemes now, representing your production environment, your development environment and your staging environment.

You'll also want to make sure you've marked each of those three schemes as 'Shared'. This option means the schemes are made available to other developers working on your code base, and also makes those schemes available to your Continuous Integration/Deployment servers. If you leave this option unticked, it will remain only available to you, and not visible to other developers on your project (which can be useful when you have schemes with personal settings setup).

{{< image src="/static/manage_schemes.png" width="1366px" height="408px" alt="Manage schemes" >}}

Now you have your schemes, we need to edit them a little to make sure they're using the appropriate configurations when building, testing, profiling, archiving and running.

Select your development scheme, and then select edit. By default your Run action will use the `Debug` configuration. You'll want to change this to use `DebugDev` instead. Similarly for the Analyze and Test actions, change it to your `DebugDev` config instead. For your Profile and Archive actions, change those to your `ReleaseDev` config.

Once done, you can close the edit scheme interface, and swap over to your staging scheme, and start editing that. Similarly you'll want to replace the `Debug` and `Release` configurations with your `DebugStaging` and `ReleaseStaging` configurations instead.

If you've managed to do this correctly, it should look similar to the following.

{{< image src="/static/different_configurations.png" width="1394px" height="530px" alt="Different configurations for scheme" >}}

Run you app using the different schemes, and observe how your app responds to the compiled code changing, without you having to manually change any of your code.

This is the starting point of you being able to have multiple configurations, for the same application. It gives you the freedom to be able to configure build settings on a per-configuration basis, and allows you to set different compiler flags per-configuration to change which code will get built in your application.

With this, you'll be able to setup your Continuous Integration server to build, and test each configuration - reducing the time you spend manually creating builds and swapping configurations each time you want to check your application against a development environment, or staging environment, or the production environment.

This is an extensible solution, and you can always create as many configurations, and as many schemes as your product requires.

In the next blog post, i'll be going over using `.xcconfig` files to [better manage your shared configuration build settings](/manage-your-build-settings-with-xcconfigs).
