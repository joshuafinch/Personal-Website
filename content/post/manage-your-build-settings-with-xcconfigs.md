+++
date = "2017-06-12T12:00:00+01:00"
title = "Manage your build settings with xcconfigs"
draft = false
+++

These magical `.xcconfig` files, what are they exactly?

Apple describes them as follows:

> A build configuration file, also known as an xcconfig file, is a plain text file that defines and overrides the build settings for a particular build configuration of a project or target. This type of file can be edited outside of Xcode and integrates well with source control systems. Build configuration files adhere to specific formatting rules, and produce build warnings if they do not.<!--more-->

Since using them in my own personal projects, and at work - I've not looked back. They make understanding changes made to build settings when looking at version control significantly easier than attempting to understand changes made through the normal Build Settings pane of Xcode - which just changes your underlying XML-based Xcode project file.

They also have the added benefit of being reusable between projects, targets, and configurations.

In the previous blog post on {{< link relref="multiple-configurations" text="multiple configurations" >}} we grew from two configurations (`Debug` and `Release`) to around six configurations, to represent our three environments (Development, Staging and Production).

This meant duplicating a lot of build settings for the Debug, and Release configurations - for us to only change a few build settings for each environment.

Similar to repeating yourself, and duplicating code - duplication of build settings suffers from the same problems. It leads to human error, where a change may be made to one of the configurations, which was meant to be applied to all of the configurations, and is therefore harder to manage, and harder to reason about when trying to fix your mistakes.

Thankfully, adopting use of an xcconfig file is a simple process. Although there is a little bit of manual labour required to start things off.

I'd seriously recommend at this point making sure your project is checked into version control and fully committed. Changing your build settings, can be particularly troublesome for your first time, and you'll want to make sure you can reset any changes back to a working state.

## Creating your .xcconfig file

In your project hierarchy, right-click and select new file. Search for "Configuration Settings File", select it, and then select next. Name the file "Config", or anything you desire really. Make sure no targets are selected (as you don't want to add this file to your application bundle, and its not being compiled). Then select create.

You'll have an empty file created, albeit with a few comments at the top. This file is used to handle key-value pairs of build settings.

We'll now want to make sure all of our configurations are using this configuration file at their base, so that all their build settings in the Xcode build settings pane will default to these values.

Select your project in the project hierarchy, then select the project in the left pane again. You should see all of your configurations.

Expand each configuration, and next to where it shows the Xcode project icon, and your project name it will say "None". Select this drop-down and change it to "Config" (or whatever you named your configuration file).

This will set the configuration file to be used at the project level for each configuration.

If you're using Cocoapods, you'll notice Cocoapods have their own `.xconfig` files they're using - and they by default set their config to be used at the target level for each configuration. Cocoapods is quite intrusive in how it affects your project/workspace, and is generally one of the reasons I prefer to use Carthage where possible instead.

{{< image src="/static/configurations_with_xcconfig.png" width="1052" height="540" alt="Configurations with xcconfig" >}}

## Filling your .xcconfig file

With your configuration file now being used by each of your configurations, its time for the fairly laborious initial process of filling it with the default settings.

The way I've done this in the past is to copy the build settings from the target. This way, you can guarantee that at the end you will have all of the same build settings that you started with, but in configuration file form instead of in your customised build settings pane of Xcode.

Start by going to your target build settings (not your project build settings).

Then change the options at the top-left to "Customised", and "Levels".

Ensure you have cleared any filters from the search box (so that it shows all the customised build settings).

Select all the build settings by pressing `Cmd` + `A` when you have focused on a build setting. Then copy them all with `Cmd` + `C`.

Return to your configuration file you created earlier, and paste the results with `Cmd` + `V`.

Your configuration file will begin to look similar to this:

{{< highlight properties >}}
//:configuration = ReleaseDev
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT
SWIFT_VERSION = 3.0

//:configuration = DebugDev
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT
SWIFT_VERSION = 3.0

//:configuration = Release
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
SWIFT_VERSION = 3.0

//:configuration = ReleaseStaging
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D STAGING
SWIFT_VERSION = 3.0

//:configuration = Debug
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
SWIFT_VERSION = 3.0

//:configuration = DebugStaging
LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D STAGING
SWIFT_VERSION = 3.0

//:completeSettings = some
LD_RUNPATH_SEARCH_PATHS
INFOPLIST_FILE
PRODUCT_BUNDLE_IDENTIFIER
PRODUCT_NAME
DEVELOPMENT_TEAM
ASSETCATALOG_COMPILER_APPICON_NAME
OTHER_SWIFT_FLAGS
SWIFT_VERSION
{{< /highlight >}}

In its current form, the keys at the bottom of the file will override the keys that come before them.

You'll want to start de-duplicating common keys, with the same value used between all configurations.

For example, the `SWIFT_VERSION`, `ASSETCATALOG_COMPILER_APPICON_NAME`, `DEVELOPMENT_TEAM`, `PRODUCT_NAME`, `PRODUCT_BUNDLE_IDENTIFIER`, `INFOPLIST_FILE` and `LD_RUNPATH_SEARCH_PATHS` are all using the same value, regardless of the current configuration.

Once deduplicated, it should be reduced to the following:

{{< highlight properties >}}
// MARK: Common Properties

LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
SWIFT_VERSION = 3.0

// MARK: Per-Configuration Properties

//:configuration = ReleaseDev
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT

//:configuration = DebugDev
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT

//:configuration = Release

//:configuration = ReleaseStaging
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D STAGING

//:configuration = Debug

//:configuration = DebugStaging
OTHER_SWIFT_FLAGS = $(inherited) "-D" "COCOAPODS" -D STAGING
{{< /highlight >}}

With the duplicates removed, we can easily see the main difference between configurations is the `OTHER_SWIFT_FLAGS` changing per-configuration.

With a little magic, we can rewrite the `OTHER_SWIFT_FLAGS` key so that it swaps between the current configuration, and gives the appropriate value in the build settings.

{{< highlight properties >}}
// MARK: Common Properties

LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
INFOPLIST_FILE = Sample/Info.plist
PRODUCT_BUNDLE_IDENTIFIER = codes.joshua.Sample
PRODUCT_NAME = $(TARGET_NAME)
DEVELOPMENT_TEAM = MV2JZMSBKV
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
SWIFT_VERSION = 3.0

// MARK: Per-Configuration Properties

OTHER_SWIFT_FLAGS_Debug = $(inherited)
OTHER_SWIFT_FLAGS_Release = $(inherited)
OTHER_SWIFT_FLAGS_DebugDev = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT
OTHER_SWIFT_FLAGS_ReleaseDev = $(inherited) "-D" "COCOAPODS" -D DEVELOPMENT
OTHER_SWIFT_FLAGS_DebugStaging = $(inherited) "-D" "COCOAPODS" -D STAGING
OTHER_SWIFT_FLAGS_ReleaseStaging = $(inherited) "-D" "COCOAPODS" -D STAGING
OTHER_SWIFT_FLAGS = $(OTHER_SWIFT_FLAGS_$(CONFIGURATION))
{{< /highlight >}}

You configuration may be a little different, depending on if its a new project, and if you have some build settings from before. Anywhere you notice the build settings changing between configurations is a chance to use the little dance we created above.

The below shows how to do this for any build setting. Just replace `<YOUR_BUILD_SETTING>`, with the build setting (the raw value from Xcode Build Settings), and replace `<CONFIGX>` with the names matching exactly with the configuration names in your project. You don't need to replace the `$(CONFIGURATION)` as that is what switches to your current configuration when building, and uses the appropriate value for the build setting.

{{< highlight properties >}}
// Setup values for your build setting, by configuration
<YOUR_BUILD_SETTING>_<CONFIG1> = <YOUR VALUE>
<YOUR_BUILD_SETTING>_<CONFIG2> = <YOUR VALUE>
<YOUR_BUILD_SETTING>_<CONFIG3> = <YOUR VALUE>
<YOUR_BUILD_SETTING>_<CONFIG4> = <YOUR VALUE>
<YOUR_BUILD_SETTING>_<CONFIG5> = <YOUR VALUE>
<YOUR_BUILD_SETTING>_<CONFIG6> = <YOUR VALUE>

// Setup your build setting, with the value for the current configuration
<YOUR_BUILD_SETTING> = $(<YOUR_BUILD_SETTING>_$(CONFIGURATION))
{{< /highlight >}}

With your configuration file setup, you can go back to your target build settings, select all of the values (`Cmd` + `A`), and then delete all of them (`BACKSPACE`). This should be safe if you've setup your configuration file correctly - as it will default back to the values set in your configuration file.

You now have all of your build settings in a `.xcconfig` file. Its far easier to comprehend than random values sporadically spread across an XML-based Xcode project file, and its also far easier to track changes made by yourself, or other developers in your team when looking at the version control history for this file.

Just be sure to try your best to update your build settings in the future using this file, instead of manually setting (and overriding) the build settings in the Xcode build settings pane.

In my next blog post, I'll be going over some of the other benefits you can gain from having multiple configurations, other than just conditional compilation which we've demonstrated here.
