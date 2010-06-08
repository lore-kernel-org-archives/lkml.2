Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0FHRfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 13:35:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38974 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab0FHRfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 13:35:30 -0400
Date: Tue, 8 Jun 2010 19:35:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: removal of ftrace_preempt_disable
Message-ID: <20100608173513.GA11585@elte.hu>
References: <20100604013506.159506222@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604013506.159506222@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0039]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This bug has been around for a while, and it only causes
> missed preemption checks (nothing to crash the kernel). This can
> wait till 2.6.36.
> 
> Please pull the latest tip/perf/core-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core-3
> 
> 
> Steven Rostedt (2):
>       tracing/sched: Make preempt_schedule() notrace
>       tracing: Remove ftrace_preempt_disable/enable
> 
> ----
>  kernel/sched.c                    |    6 ++--
>  kernel/trace/ftrace.c             |    5 +--
>  kernel/trace/ring_buffer.c        |   38 ++++++-----------------------
>  kernel/trace/trace.c              |    5 +--
>  kernel/trace/trace.h              |   48 -------------------------------------
>  kernel/trace/trace_clock.c        |    5 +--
>  kernel/trace/trace_events.c       |    5 +--
>  kernel/trace/trace_functions.c    |    6 ++--
>  kernel/trace/trace_sched_wakeup.c |    5 +--
>  kernel/trace/trace_stack.c        |    6 ++--
>  10 files changed, 27 insertions(+), 102 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
