Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab1ETQKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 12:10:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:51056 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861Ab1ETQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 12:10:50 -0400
Date: Fri, 20 May 2011 12:10:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.LFD.2.02.1105201712501.3078@ionos>
Message-ID: <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 May 2011, Thomas Gleixner wrote:

> On Fri, 20 May 2011, Justin Piszcz wrote:
>> On Fri, 20 May 2011, Thomas Gleixner wrote:
>>> Does it crash right away or just when doing something particular?
>> It crashed at 2100, this is when I run a few I/O intensive processes:
>> - backup (dump ext4 filesystem -> to a separate raid device)
>> - backup (dump ext4 on remote host -> to separate raid device)
>> - backup (dump xfs on remote host -> to separate raid device)
>>
>> This looks like it is what caused it to crash.
>
> That narrows it down somewhat, but does not give us a clue at all :(
>
>>> Is the box fully dead after the crash ?
>> The host was online and I went away for awhile, when I came back the system
>> had rebooted on its own (as I lost all of my X windows/etc).
>
> Hmm. Did you have panic_timeout set ?

Hi,

No, I do not use panic_timeout or any type of watchdog that would reboot
the system upon a lockup/crash.

Justin.

