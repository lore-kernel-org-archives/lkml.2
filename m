Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2KDBUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 21:20:23 -0400
Received: from smtp.getmail.no ([84.208.15.66]:46093 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2KDBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 21:20:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Subject: Fwd: Re: Scheduler queues for less os-jitter?
References: <op.wly58nr56426ze@localhost.localdomain>
 <1349923594.6989.19.camel@marge.simpson.net>
 <op.wm75y11n6426ze@localhost.localdomain>
Date: Sun, 04 Nov 2012 02:20:20 +0100
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wm75z6uw6426ze@localhost.localdomain>
In-reply-to: <op.wm75y11n6426ze@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



------- Forwarded message -------
From: "Uwaysi Bin Kareem" <uwaysi.bin.kareem@paradoxuncreated.com>
To: "Mike Galbraith" <efault@gmx.de>
Cc:
Subject: Re: Scheduler queues for less os-jitter?
Date: Sun, 04 Nov 2012 02:19:39 +0100

On Thu, 11 Oct 2012 04:46:34 +0200, Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2012-10-10 at 20:13 +0200, Uwaysi Bin Kareem wrote:
>> I was just wondering, have you considered this?
>>
>> If daemons are contributing to os-jitter, wouldn`t having them all on
>> their own queue reduce jitter? So people could have the stuff like in
>> Ubuntu they want, without affecting jitter, or needing stuff like Tiny
>> Core, for tiny jitter?
>>
>> So you get (simplified) something like mainapp - process1 in queue 2,
>> mainapp - process2 in queue 2, mainapp - process 3 in queue 2, etc.
>>
>> Or is that already batch maybe, lol.
>
> You could try SCHED_AUTOGROUP, or create whatever task groups manually,
> or use systemd to do that for you.  Like everything else having anything
> to do with scheduling, all are double edged swords, so may help, may
> hurt.
>
> -Mike
>

Actually I did achieve this with fifo-relatime. Low jitter OpenGL seems to
be able to do, running the opengl app as realtime, with a low
sched_rt_period_us value and a high sched_rt_runtime_us value.

Peace Be With You.
