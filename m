Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1BQNul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:50:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44991 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab1BQNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:50:39 -0500
Date: Thu, 17 Feb 2011 14:50:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 00/10] [GIT PULL][v2.6.39] tracing: updates
Message-ID: <20110217135023.GA5235@elte.hu>
References: <20110208221612.084294240@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110208221612.084294240@goodmis.org>
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
> Ian Munsie (5):
>       tracing/syscalls: Don't add events for unmapped syscalls
>       tracing/syscalls: Convert redundant syscall_nr checks into WARN_ON
>       tracing/syscalls: Make arch_syscall_addr weak
>       tracing/syscalls: Allow arch specific syscall symbol matching
>       tracing/syscalls: Early terminate search for sys_ni_syscall
> 
> Jiri Olsa (1):
>       tracing: Add unstable sched clock note to the warning
> 
> Lai Jiangshan (1):
>       tracing: Compile time initialization for event flags value
> 
> Steven Rostedt (2):
>       tracing: Remove obsolete sched_switch tracer
>       tracing: Deprecate tracing_enabled for tracing_on
> 
> Uwe Kleine-König (1):
>       trivial: Fix Steven's Copyright typos
> 
> ----
>  Documentation/trace/ftrace-design.txt |    7 ++
>  Documentation/trace/ftrace.txt        |  148 ++++----------------------------
>  include/linux/syscalls.h              |   10 ++-
>  kernel/trace/ring_buffer.c            |    8 ++-
>  kernel/trace/trace.c                  |    4 +
>  kernel/trace/trace_sched_switch.c     |   48 -----------
>  kernel/trace/trace_syscalls.c         |   42 +++++++---
>  scripts/kconfig/streamline_config.pl  |    2 +-
>  tools/testing/ktest/ktest.pl          |    2 +-
>  9 files changed, 74 insertions(+), 197 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
