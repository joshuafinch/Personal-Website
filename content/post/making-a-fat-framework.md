+++
date = "2017-01-12T14:00:00+01:00"
title = "Making a fat framework"
draft = false
+++

Recently, I've had the joy of working with the [Microsoft Cognitive Services Speech SDK](https://docs.microsoft.com/en-gb/azure/cognitive-services/speech/home). Which works amazingly.

Although it has a minor annoyance of different frameworks to be used for the iPhoneSimulator and iPhoneOS architectures. This is an annoyance when switching between device/simulator as you need to swap the framework you're referencing each time.

To go about solving this problem, I decided to create it into a "fat" framework - which was actually pretty simple.

Given the iPhoneSimulator framework binary and the iPhoneOS framework binary, I ran the following command to create a new framework binary that contained support for both architectures.

{{< highlight shell >}}
$ lipo -create -output "SpeechSDK" "iPhoneOS/SpeechSDK.framework/SpeechSDK" "iPhoneSimulator/SpeechSDK.framework/SpeechSDK"
{{< /highlight >}}

The above command creates a fat framework binary, to be able to use it however, we need to inject it back into a framework. To do this, copy either of the iPhoneOS or iPhoneSimulator frameworks - and then inject the fat framework binary, replacing the existing one.

{{< highlight shell >}}
$ cp -R iPhoneOS/SpeechSDK.framework .
$ mv SpeechSDK SpeechSDK.framework/SpeechSDK
{{< /highlight >}}

You'll be able to use the above framework for both iPhoneOS and iPhoneSimulator architectures in your projects, without having to switch. Just use it like any other framework you reference manually.
