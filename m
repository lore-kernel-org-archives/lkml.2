Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1KGMNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:13:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1KGMNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:13:20 -0500
Message-ID: <4EB7CB54.7020207@gmail.com>
Date: Mon, 07 Nov 2011 14:13:08 +0200
From: =?ISO-8859-1?Q?Lars_Nood=E9n?= <lars.nooden@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: guenter.roeck@ericsson.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Hardware running hot and without the fan
References: <4EB1108F.6070009@gmail.com> <20111103020301.GA22333@ericsson.com> <4EB250FD.3070000@gmail.com> <20111103134902.GA26121@ericsson.com> <4EB2A46B.8080600@gmail.com> <1320332801.2309.60.camel@groeck-laptop> <4EB2B0FD.309@gmail.com> <20111103174635.GA12229@polaris.bitmath.org>
In-Reply-To: <20111103174635.GA12229@polaris.bitmath.org>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/11 7:46 PM, Henrik Rydberg wrote:
[snip]
> I am confused.
> 
> From what I gather, the fans work, and it should be possible to run
> the macfanctld daemon (not fancontrol) to tune the fans.
>
> If there really is a problem with the applesmc, following
> http://ubuntuforums.org/showthread.php?t=924096 is a good idea.
> 
> However, the root problem is most likely the GPU consuming too much
> power. Depending on the exact laptop model, there may or may not be a
> viable workaround. If you model is very new, there is most likely and
> active thread about it on the ubuntu forums.

Not that I could find, at least not useful ones.
Starting a new thread gained no results.

> After checking around on the forums, if you find that this is still a
> fan or temperature sensor problem, and not a GPU problem, then please
> restate the problem as exactly as you can.

Can it be both a fan / sensor / GPU problem?
To restate the symptoms:

- the hardware runs hot in Linux, the same hardware runs cool in OS X
- the fan(s) do not run automatically when the machines get hot
- the fan(s) can be controlled manually
- the temperatures from /usr/bin/sensors on the notebook seem
  suspiciously low

The kernels are

- 3.1.0-999-generic #201111070407 SMP Mon Nov 7
  09:08:05 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

- 3.1.0-2-generic #3-Ubuntu SMP Fri Oct 28
  20:28:07 UTC 2011 i686 i686 i386 GNU/Linux

Output from apport can be found in Launchpad:

 https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593

The notebook is a MacBookPro8,2 and the desktop is a Macmini3,1

How should I split the problem up and where should I pursue their
resolution?

/Lars
