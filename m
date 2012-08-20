Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2HTOvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:51:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab2HTOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:51:52 -0400
MIME-Version: 1.0
In-Reply-To: <1345442050.25011.38.camel@marge.simpson.net>
References: <CALKntY0G6WBYT-MGbzQ-e6X_XyRENzeJww7FiLGAgiHtrfwQiA@mail.gmail.com>
	<1345442050.25011.38.camel@marge.simpson.net>
Date: Mon, 20 Aug 2012 07:51:52 -0700
Message-ID: <CALKntY0dQFxmSz+61Bia-zxpvsQg7kySG1mfk1GVc90YCc27qw@mail.gmail.com>
Subject: Re: changing timeslice in linux
From: Xin Tong <xerox.time.tech@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 10:54 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2012-08-19 at 11:58 -0700, Xin Tong wrote:
>> I have 2 questions about linux 2.6 x86_64 scheduler.
>>
>> 1. is the default scheduling algorithm SCHED_NORMAL in linux ?
>
> Yes.
Is there any document describing what the sched_normal is ? it is more
difficult than SCHED_RR to infer its meaning just based on its name ?
>
>> 2. how do i change the time slice in linux source code ?
>
> You shouldn't need to.  You can tune "slice" by adjusting
> sched_latency_ns and sched_min_granularity_ns, but note that "slice" is
> not a fixed quantum.  Also note that CFS preemption decisions are based
> upon instantaneous state.  A task may have received a full (variable)
> "slice" of CPU time, but preemption will be triggered only if a more
> deserving task is available, so a "slice" is not the "max uninterrupted
> CPU time" that you may expect it to be.. but it is somewhat similar.
>
> -Mike
>
This can be done without recompiling and reinstalling the kernel ?
maybe one simply needs to write to a device file under /dev ?

Xin
