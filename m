Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2AWSBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 13:01:43 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56270 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2AWSBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 13:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120123165752.GA1980@homer.localdomain>
References: <CAPVoSvSXMvRb=1itu9DjF+s=6zfAChvUxS-x=b8EV9kOZinNpA@mail.gmail.com>
	<20120123165752.GA1980@homer.localdomain>
Date: Mon, 23 Jan 2012 19:01:41 +0100
Message-ID: <CAPVoSvQYaCC9WcYBeZJtQ++DQhq4QCS8D=nChNjhVNKUHefYdg@mail.gmail.com>
Subject: Re: [3.3-rc1]radeon 0000:07:00.0: GPU lockup CP stall for more than 10000msec
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 5:57 PM, Jerome Glisse <j.glisse@gmail.com> wrote:
> On Sat, Jan 21, 2012 at 08:03:37PM +0100, Torsten Kaiser wrote:
>> After updating to kernel 3.3-rc1 I have experienced a lockup of my GPU.
>> I left my KDE desktop running until the screensaver turned off the
>> monitors. But on key presses it would not turn back on. Ctrl+Alt+F1 to
>> switch to another virtual console also did not work.
>> Alt+SysRq magic still worked, so I was able to force the syslog to
>> disk and restart the system.
>>
>
> Can you test if attached patch help your case ?

Patch is installed, but I can't reproduce the hang on demand.
It did happen a second time yesterday while letting the screensaver
kick in, but only at around the third or fourth try. Just using "xset
dpms force standby/suspend/off" did not trigger it.

> Of course it would be best if we did not lockup in the first place.

Not sure if this is important: I also upgraded to mesa 8.0-rc1 before
the first hang, but after switching back to 3.2 but still using mesa
8.0 I did not have any problems.
Except the KDE desktop effects there should not have been any OpenGL
programs running.
The screen saver itself is just turning the screens off via the KDE
power profile.

I will report again, when I succeeded in triggering the GPU lockup again...

Torsten
