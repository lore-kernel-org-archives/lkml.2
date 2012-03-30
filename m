Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849Ab2C3OKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:10:52 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:35470 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759385Ab2C3OKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:10:45 -0400
From: Kevin Hilman <khilman@ti.com>
To: Geoff Levand <geoff@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Ingo Molnar <mingo@kernel.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Max Krasnyansky <maxk@qualcomm.com>, Zen Lin <zen@openhuawei.org>,
        Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
Organization: Texas Instruments, Inc.
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	<87r4wbhqqd.fsf@ti.com> <20120330004527.GB2571@somewhere.redhat.com>
	<1333073233.4912.44.camel@smoke>
Date: Fri, 30 Mar 2012 07:10:43 -0700
In-Reply-To: <1333073233.4912.44.camel@smoke> (Geoff Levand's message of "Thu,
	29 Mar 2012 19:07:13 -0700")
Message-ID: <87k422gows.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geoff Levand <geoff@infradead.org> writes:

> Hi All,
>
> On Fri, 2012-03-30 at 02:45 +0200, Frederic Weisbecker wrote:
>> On Thu, Mar 29, 2012 at 05:33:46PM -0700, Kevin Hilman wrote:
>> > For anyone interested in collaborating on ARM support, my
>> > work-in-progress branch is below[1] based on Frederic's cpuset-v2
>> > branch.  Patches and testing welcome.
>> > 
>> > [1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git wip/arm-nohz-cpusets
>> 
>> Nice! Thanks for working on this. You may want to work with Geoff Levand who's working
>> on the ARM port too.
>
> You can see my work here:
>
>   http://git.kernel.org/?p=linux/kernel/git/geoff/nohz.git

Great! Will have a closer look.

A quick look suggests we've done almost exactly the same thing.  Guess
that's a good sign. :) 

> I also put a simple test I got from Frederic here:
>
>   http://git.kernel.org/?p=linux/kernel/git/geoff/nohz-tests.git

Great, having a common test to compare results was going to be my next
question.  I'll start playing with these next week.   Thanks.

> Feel free to expand on either!

> Kevin, I'll take a look at your work, I guess it has the same things as
> mine.  

Yeah, we've done basically the same thing.  I see though that you've
also already handled some RCU idle cases that I hadn't.

Since you're a little further than me, I'll switch you yours and 
start using that as the base

> Will you be at the Collaboration Summit next week?

Unfortunately, no.

Kevin
