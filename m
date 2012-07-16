Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2GPOFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:05:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44329 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753403Ab2GPOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:05:13 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18z2hoxf4oz+ib89zSbmpTE4oZKEpodlQmVJ67saM
	ALdQO3KEpkSpOE
Message-ID: <50041C1E.8070203@gmx.de>
Date: Mon, 16 Jul 2012 15:50:22 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120625 Thunderbird/13.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rcX: wakeup after s2ram doesn't work after a longer sleep
 time
References: <500319E9.8010001@gmx.de> <201207152221.48232.rjw@sisk.pl>
In-Reply-To: <201207152221.48232.rjw@sisk.pl>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2012 10:21 PM, Rafael J. Wysocki wrote:
> On Sunday, July 15, 2012, Toralf Förster wrote:
>> My ThinkPad T400 (Gentoo Linux booted from an external USB drive) does
>> not wake up after s2ram, if the  sleep time was longer than about 1 hour.
>> I'm unsure whether this started after 3.5-rc5, at least with -rc7 I
>> observed this now several times. Unfortunately it is not 100% reproduceable.
>>
>> 3.4.x works flawlessly.
>>
>> Any idea whether a particular commit could be the culprit ? (Bisecting
>> such an issue is a night mare)
> 
> Please check
> 
> commit 5baefd6d84163443215f4a99f6a20f054ef11236
> Author: John Stultz <johnstul@us.ibm.com>
> Date:   Tue Jul 10 18:43:25 2012 -0400
> 
>     hrtimer: Update hrtimer base offsets each hrtimer_interrupt
> 
> Thanks,
> Rafael
> 

No,
reverting doesn#t help.

I can r2ram several times in a row w/o problems, if the sleep time as
within seconds.
After 20 min however the system doesn't came back (the internal hard
disk spins up, but the sleep-state-led is still on).


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


