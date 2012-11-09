Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2KIMQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:16:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2KIMQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:16:38 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VRnYp3boO_EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=yJYF2qs8mCEA:10 a=VwQbUJbxAAAA:8 a=Gmbz1z3xq7cDKpY40e0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352463396.18025.0.camel@gandalf.local.home>
Subject: Re: [PATCH 00/19] [GIT PULL][3.8] tracing: updates (v2)
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 09 Nov 2012 07:16:36 -0500
In-Reply-To: <20121102181331.513782854@goodmis.org>
References: <20121102181331.513782854@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 14:13 -0400, Steven Rostedt wrote:
> Ingo,
> 
> I removed the few problem patches (and their dependencies) and
> retested the result.
> 
> Please pull the latest tip/perf/core-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/core-2
> 
> Head SHA1: 7bcfaf54f591a0775254c4ea679faf615152ee3a
> 

Hi Ingo,

Any hold up for pulling this patch set into tip?

-- Steve

> 
> Daniel Walter (1):
>       tracing: Replace strict_strto* with kstrto*
> 
> David Sharp (2):
>       tracing: Trivial cleanup
>       tracing: Reset ring buffer when changing trace_clocks
> 
> Hiraku Toyooka (1):
>       tracing: Change tracer's integer flags to bool
> 
> Michal Hocko (1):
>       linux/kernel.h: Remove duplicate trace_printk declaration
> 
> Slava Pestov (1):
>       ring-buffer: Add a 'dropped events' counter
> 
> Steven Rostedt (11):
>       tracing: Allow tracers to start at core initcall
>       tracing: Expand ring buffer when trace_printk() is used
>       tracing: Enable comm recording if trace_printk() is used
>       tracing: Have tracing_sched_wakeup_trace() use standard unlock_commit
>       tracing: Cache comms only after an event occurred
>       tracing: Separate open function from set_event and available_events
>       tracing: Remove unused function unregister_tracer()
>       tracing: Make tracing_enabled be equal to tracing_on
>       tracing: Remove deprecated tracing_enabled file
>       tracing: Use irq_work for wake ups and remove *_nowake_*() functions
>       tracing: Add trace_options kernel command line parameter
> 
> Vaibhav Nagarnaik (1):
>       tracing: Cleanup unnecessary function declarations
> 
> Yoshihiro YUNOMAE (1):
>       ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts() to u64
> 
> ----
>  Documentation/kernel-parameters.txt  |   16 ++
>  include/linux/ftrace_event.h         |   14 +-
>  include/linux/kernel.h               |    7 +-
>  include/linux/ring_buffer.h          |    3 +-
>  include/trace/ftrace.h               |    3 +-
>  include/trace/syscall.h              |   23 ---
>  kernel/trace/Kconfig                 |    1 +
>  kernel/trace/ftrace.c                |    6 +-
>  kernel/trace/ring_buffer.c           |   51 ++++-
>  kernel/trace/trace.c                 |  372 +++++++++++++++++-----------------
>  kernel/trace/trace.h                 |   14 +-
>  kernel/trace/trace_branch.c          |    4 +-
>  kernel/trace/trace_events.c          |   51 +++--
>  kernel/trace/trace_events_filter.c   |    4 +-
>  kernel/trace/trace_functions.c       |    5 +-
>  kernel/trace/trace_functions_graph.c |    6 +-
>  kernel/trace/trace_irqsoff.c         |   14 +-
>  kernel/trace/trace_kprobe.c          |   10 +-
>  kernel/trace/trace_probe.c           |   14 +-
>  kernel/trace/trace_sched_switch.c    |    4 +-
>  kernel/trace/trace_sched_wakeup.c    |   10 +-
>  kernel/trace/trace_selftest.c        |   13 +-
>  kernel/trace/trace_syscalls.c        |   61 +++---
>  kernel/trace/trace_uprobe.c          |    2 +-
>  24 files changed, 365 insertions(+), 343 deletions(-)


