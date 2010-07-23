Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0GWHMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:12:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab0GWHMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:12:46 -0400
Date: Fri, 23 Jul 2010 09:12:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] tracing: updates
Message-ID: <20100723071237.GB23461@elte.hu>
References: <20100722202411.920807480@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722202411.920807480@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Dan Carpenter (1):
>       trace: strlen() return doesn't account for the NULL
> 
> David Daney (1):
>       tracing: Fix $mcount_regex for MIPS in recordmcount.pl
> 
> KOSAKI Motohiro (1):
>       tracing: Shrink max latency ringbuffer if unnecessary
> 
> Lai Jiangshan (1):
>       tracing: Reduce latency and remove percpu trace_seq
> 
> Li Zefan (1):
>       tracing: Allow to disable cmdline recording
> 
> Mike Frysinger (1):
>       tracing/documentation: Document dynamic ftracer internals
> 
> Richard Kennedy (1):
>       trace: Reorder struct ring_buffer_per_cpu to remove padding on 64bit
> 
> ----
>  Documentation/trace/ftrace-design.txt |  153 +++++++++++++++++++++++++++++++-
>  include/linux/ftrace.h                |    5 +
>  include/linux/ftrace_event.h          |   12 ++-
>  include/trace/ftrace.h                |   12 +--
>  kernel/trace/ring_buffer.c            |    2 +-
>  kernel/trace/trace.c                  |   46 ++++++++--
>  kernel/trace/trace.h                  |    4 +
>  kernel/trace/trace_events.c           |   30 ++++++-
>  kernel/trace/trace_irqsoff.c          |    3 +
>  kernel/trace/trace_output.c           |    3 -
>  kernel/trace/trace_sched_wakeup.c     |    2 +
>  scripts/recordmcount.pl               |    2 +-
>  12 files changed, 241 insertions(+), 33 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
