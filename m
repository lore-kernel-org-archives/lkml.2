Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1FJNHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:07:43 -0400
Received: from lucidpixels.com ([75.144.35.66]:43139 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab1FJNHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:07:41 -0400
Date: Fri, 10 Jun 2011 09:07:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.39: crash w/threadirqs option enabled
In-Reply-To: <alpine.LFD.2.02.1106101450030.11814@ionos>
Message-ID: <alpine.DEB.2.02.1106100854250.23139@p34.internal.lan>
References: <alpine.DEB.2.02.1105200405210.24033@p34.internal.lan> <alpine.LFD.2.02.1105201445300.3078@ionos> <alpine.DEB.2.02.1105200850080.19553@p34.internal.lan> <alpine.LFD.2.02.1105201528500.3078@ionos> <alpine.DEB.2.02.1105200945300.19553@p34.internal.lan>
 <alpine.LFD.2.02.1105201712501.3078@ionos> <alpine.DEB.2.02.1105201210030.19553@p34.internal.lan> <alpine.LFD.2.02.1105201819310.3078@ionos> <alpine.DEB.2.02.1106100414550.32450@p34.internal.lan> <alpine.LFD.2.02.1106101450030.11814@ionos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jun 2011, Thomas Gleixner wrote:

> On Fri, 10 Jun 2011, Justin Piszcz wrote:
>> On Fri, 20 May 2011, Thomas Gleixner wrote:
>> Crashed again and it rebooted too:
>>
>> reboot   system boot  2.6.39             Thu Jun  9 23:58 - 04:05  (04:06)
>> user1      pts/0        X                Thu Jun  9 19:25 - 19:30  (00:04)
>> user1      pts/10       X                Thu Jun  9 18:23 - crash  (05:35)
>>
>> Any thoughts on what could be causing this?
>> Should I go back to 2.6.38?
>
> If you remove the threadirqs option from the commandline it does not
> happen, right?
Yes, most often anyhow (still using that option)

>
> Can you try the following patch ?
Yup, patched:

# patch -p1 < ../patch-for-cpu 
patching file arch/x86/kernel/smpboot.c
#

New kernel running now, I also plugged in my USB devices back in as well, we'll see what happens.

Justin.

