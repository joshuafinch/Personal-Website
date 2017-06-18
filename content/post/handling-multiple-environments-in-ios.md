+++
date = "2017-06-10T12:00:00+01:00"
title = "Handling multiple environments in iOS"
draft = false
+++

Most iOS applications need to connect to one or more web services, when developing these applications, you normally need to connect to various different environments for each of these web services as they're being developed, especially if you're creating the web service yourself.<!--more-->

The majority of iOS applications i've developed in the past have had to connect to various different environments for each of the web services they connect to. Usually we have a development, test (or staging) and production (or live) environment for each independent web service we develop ourselves.  

The benefit of having multiple environments means you can ensure rapid development, and adapt to changes in a development environment without having to worry about your changes affecting current users in a production environment.

But having to go into your code, and change the url's that you're connecting to each time you want to test your application against each of the environments is prone to human error, and slows down your development, testing and deployment processes.

## The good, the bad and the ugly

Having seen how myself and other developers have managed applications that need to connect to different environments, with different settings for each configuration, there are various ways this can be achieved.

One of the ways i've seen this done is by creating another target, and separate application executable. Personally I find this error-prone as it relies on each of the application developers remembering to add their source files to each application target as they're created. It also makes it harder to reason as a tester of the application, whether a release version will be using the same code as the development version, barring expected configuration changes.

Another way i've seen this problem tackled, was to have separate configuration source code files - and allow the build process to switch between them using a run script as a part of an Xcode scheme, or as a build script as a part of the target. Like the above solution, this can work but it is also prone to similar errors. When developing with these separate files - you need to make sure they're kept in-sync, can all compile, and behave as expected. You will have no guarantee that the run/build scripts will copy and replace the file with the correct configuration; and it creates source-level changes each time you need to do a build will affect your version control.

There is a better way that doesn't make source-level changes at build time, and as such won't mess about with your files in version control. It also won't have the problem of multiple targets, with different build settings, different run/build scripts, and different files being compiled.

## Conditional compilation

In Objective-C and Swift you have the option of conditional compilation, using `Preprocessor Macros` for Objective-C code, and `Other Swift Flags` for Swift code. You can of course use both if you have setup Objective-C and Swift interoperability for your project with bridging headers.

The basics behind this are you set a flag for example `PRODUCTION`, `STAGING` or `DEVELOPMENT` and then switch between these flags in your code using `#if`, `#elseif` and `#else` conditionals, where you can then change what your source code does at compile time.

Only the code that passes the condition at compile time is compiled into the application binary and distributed. This is great for making sure your development, and testing configuration data isn't leaked in your production application code.

The example below will create a `Config` object from different fictional base URLs for the same API across different environments. Which can then be passed across the code base to relevant areas that need to make use of this API.

{{< highlight swift >}}
private var config: Config {

    #if DEVELOPMENT
        let c = Config(baseUrlString: "https://dev.joshua.codes/api/")
    #elseif STAGING
        let c = Config(baseUrlString: "https://test.joshua.codes/api/")
    #else
        let c = Config(baseUrlString: "https://joshua.codes/api/")
    #endif

    guard let config = c else {
        fatalError("Error: Could not create config!")
    }

    return config
}
{{< /highlight >}}

To setup the above flags, `DEVELOPMENT` and `STAGING` you will need to go to your target build settings, and search for `Other Swift Flags`. You can then set your flags for each configuration, prefixed by a `-D`, for example `-D DEVELOPMENT` or `-D STAGING`.

{{< image src="/static/other_swift_flags.png" width="1510" height="420" alt="Other Swift Flags" >}}

The above example only has the two default configurations, `Debug` and `Release` - by default you'll be able to test you changes by running the app in the simulator for the `Debug` configuration, or creating an archive and running that on device for the `Release` configuration. You can also test the different configurations by changing the run behaviour of your scheme to use `Release` instead of `Debug`.

Not only can conditional compilation be used for changes in environment urls, you can use it for pretty much anything. Some other examples might include setting different client ids for your app analytics to avoid mixing development and production data, or even preventing your application from hitting a web api, and serving data locally from the code, or file system instead.  

Over the next few blog posts, i'll be showing you how you can setup multiple configurations (if the two default ones are not enough), how you can utilise multiple schemes to run the application against different configurations, how you can use `xcconfig` files to better manage and track changes to your build settings across multiple configurations, and allow your continuous integration server to create different builds of your application.

We'll also look into some nice benefits you can gain such as being able to have the same app installed multiple times on the same device, and optionally giving them different names, and app icons representing each of their configurations.

Check out my next blog post on {{< link relref="multiple-configurations" text="multiple configurations" >}}.
