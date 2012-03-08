Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2CHVEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:04:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49315 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2CHVEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:04:33 -0500
MIME-Version: 1.0
In-Reply-To: <1331238865.25686.474.camel@gandalf.stny.rr.com>
References: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
	<1331237840.25686.470.camel@gandalf.stny.rr.com>
	<20120308142257.145e0968@redhat.com>
	<1331238865.25686.474.camel@gandalf.stny.rr.com>
Date: Thu, 8 Mar 2012 22:04:32 +0100
X-Google-Sender-Auth: AD5kCUChauRdQhctTX6DjXOz7M0
Message-ID: <CAONaPpGrmKq-CE3RQzLnKqCZV0DRm9niR+3eeywUFtGkYoL5Uw@mail.gmail.com>
Subject: Re: [PATCH-RT] preempt.h: Fix implicit declaration of 'preempt_check_resched_rt'
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <williams@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 9:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-03-08 at 14:22 -0600, Clark Williams wrote:
>> On Thu, 08 Mar 2012 15:17:20 -0500
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> > On Thu, 2012-03-08 at 21:13 +0100, John Kacur wrote:
>> > > When building a non-preempt kernel where CONFIG_PREEMPT_COUNT is not
>> > > defined the following build break occurs.
>> > >
>> > > /home/jkacur/linux-rt/block/blk-softirq.c: In function ‘trigger_softirq’:
>> > > /home/jkacur/linux-rt/block/blk-softirq.c:54: error: implicit declaration of function ‘preempt_check_resched_rt’
>> > > make[2]: *** [block/blk-softirq.o] Error 1
>> > > make[1]: *** [block/blk-softirq.o] Error 2
>> > > make: *** [sub-make] Error 2
>> > >
>> > > This patch fixes the build error by adding a define to the
>> > > !CONFIG_PREEMPT_COUNT section.
>> > >
>> > > Signed-off-by: Clark Williams <williams@redhat.com>
>> >
>> > Why Clark's SOB? Did he write it and send it to you?
>>
>> I suppose to be technically correct it should have been a Tested-by:
>>
>> John found it while I was working on it and I tested it for him.
>
> Either a "Reported-by" if you mentioned it to John and he fixed it, or a
> "Tested-by" if he fixed it and you tested it. You can have both if that
> is true too.
>
> But "Signed-off-by" has supposed legal significance. It means that you
> are responsible for this patch. Either you authored it, or it went
> through you to get to the git repo (ie. you are the maintainer that took
> the patch).
>
> All other tags are FYI only. Only the SOB is required and has real
> meaning. Also, you should *never* add a SOB to a patch without the
> person explicitly giving it to you.
>
> -- Steve
>

Good, understood. Please change to

Tested-by: Clark Willilams <williams@redhat.com>
Signed-off-by: John Kacur <jkacur@redhat.com>

Note that the patch is for 3.2.9-rt17

Thanks
