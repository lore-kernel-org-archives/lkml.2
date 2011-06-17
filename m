Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1FQCkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:40:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1FQCke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:40:34 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=XnC8labONsAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=rNfO09MNk77xRJGuULUA:9 a=olrddiSTLPp_NRR1S4wA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 0/7] sched: various updates to the scheduler
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110617015516.301117218@goodmis.org>
References: <20110617015516.301117218@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 22:40:33 -0400
Message-ID: <1308278433.9218.163.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 21:55 -0400, Steven Rostedt wrote:
> Peter,
> 
> Can you review these patches and give your Acked-by, or explain what
> might be wrong with them. No hurry, I haven't pushed them through my
> full testing yet (starting that now). But I want to push them out for
> 3.1.
> 
> Thanks,
> 
> -- Steve
> 
> 
> This patch set can be found in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
> tip/sched/core
> 
> Head SHA1: cac554411989613131d899cfb51b622ce96d5136
> 
> 
> Hillf Danton (5):
>       sched: Fix need_resched() when checking peempt

You don't need to review this one. I just realized that I pushed that
already for 3.0 pull.

Thanks!

-- Steve



>       sched: Remove noop in next_prio()
>       sched: Remove noop in lowest_flag_domain()
>       sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()
>       sched: Remove resetting exec_start in put_prev_task_rt()
> 
> Steven Rostedt (2):
>       sched: Balance RT tasks when forked as well
>       sched: Use pushable_tasks to determine next highest prio
> 
> ----
>  kernel/sched_fair.c |    2 +-
>  kernel/sched_rt.c   |   88 +++++++++++++++++++--------------------------------
>  2 files changed, 34 insertions(+), 56 deletions(-)


