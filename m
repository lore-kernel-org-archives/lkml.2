Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1GUJLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:11:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33706 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GUJLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:11:32 -0400
Date: Thu, 21 Jul 2011 11:10:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/20] [GIT PULL] perf/tracing: various updates
Message-ID: <20110721091046.GM9216@elte.hu>
References: <20110716112200.096203519@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716112200.096203519@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> Head SHA1: 14a8fd7ceea6915c613746203d6e9a2bf273f16c
> 
> 
> Cyrill Gorcunov (1):
>       perf, x86: P4 PMU - Introduce event alias feature
> 
> Masami Hiramatsu (12):
>       tracing/kprobes: Rename probe_* to trace_probe_*
>       tracing/kprobes: Merge trace probe enable/disable functions
>       kprobes: Return -ENOENT if probe point doesn't exist
>       tracing/kprobes: Support module init function probing
>       tracing/kprobe: Update symbol reference when loading module
>       perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
>       perf probe: Move strtailcmp to string.c
>       perf probe: Remove redundant dwarf functions
>       perf-probe: Move dwarf library routines to dwarf-aux.{c, h}
>       perf probe: Introduce debuginfo to encapsulate dwarf information
>       perf probe: Add probed module in front of function
>       perf probe: Support adding probes on offline kernel modules
> 
> Sonny Rao (1):
>       perf: Robustify proc and debugfs file recording
> 
> Steven Rostedt (6):
>       tracing: Still trace filtered irq functions when irq trace is disabled
>       ftrace: Do not disable interrupts for modules in mcount update
>       ftrace: Balance records when updating the hash
>       ftrace: Update filter when tracing enabled in set_ftrace_filter()
>       ftrace: Fix dynamic selftest failure on some archs
>       tracing: Have dynamic size event stack traces
> 
> ----
>  Documentation/trace/kprobetrace.txt     |    9 +-
>  arch/x86/include/asm/perf_event_p4.h    |   33 ++
>  arch/x86/kernel/cpu/perf_event.c        |    7 -
>  arch/x86/kernel/cpu/perf_event_p4.c     |  135 +++++--
>  include/linux/ftrace_event.h            |    1 +
>  kernel/kprobes.c                        |   33 +-
>  kernel/trace/ftrace.c                   |   95 +++-
>  kernel/trace/trace.c                    |   92 ++++-
>  kernel/trace/trace.h                    |   50 ++-
>  kernel/trace/trace_entries.h            |    3 +-
>  kernel/trace/trace_functions_graph.c    |    2 +-
>  kernel/trace/trace_kprobe.c             |  318 +++++++++----
>  kernel/trace/trace_output.c             |   11 +-
>  kernel/watchdog.c                       |    2 -
>  tools/perf/Documentation/perf-probe.txt |    6 +-
>  tools/perf/Makefile                     |    2 +
>  tools/perf/builtin-probe.c              |    3 +-
>  tools/perf/util/dwarf-aux.c             |  663 +++++++++++++++++++++++++++
>  tools/perf/util/dwarf-aux.h             |  100 ++++
>  tools/perf/util/probe-event.c           |  165 +++++--
>  tools/perf/util/probe-event.h           |    1 +
>  tools/perf/util/probe-finder.c          |  752 +++++--------------------------
>  tools/perf/util/probe-finder.h          |   43 ++-
>  tools/perf/util/string.c                |   19 +
>  tools/perf/util/trace-event-info.c      |  120 ++----
>  tools/perf/util/util.h                  |    1 +
>  26 files changed, 1663 insertions(+), 1003 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
