Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1CKI2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 03:28:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1CKI2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 03:28:01 -0500
Date: Fri, 11 Mar 2011 09:27:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/15] [GIT PULL] tracing: updates for 2.6.39
Message-ID: <20110311082749.GD7624@elte.hu>
References: <20110310155800.478792851@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310155800.478792851@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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
> 
> David Sharp (8):
>       tracing: Add an 'overwrite' trace_option.
>       ring-buffer: Remove unused #include <linux/trace_irq.h>
>       tracing: Fix event alignment: ftrace:context_switch and ftrace:wakeup
>       tracing: Fix event alignment: module:module_request
>       tracing: Fix event alignment: kvm:kvm_hv_hypercall
>       tracing: Fix event alignment: mce:mce_record
>       tracing: Fix event alignment: skb:kfree_skb
>       tracing: Adjust conditional expression latency formatting.
> 
> Jiri Olsa (1):
>       tracing: Explain about unstable clock on resume with ring buffer warning
> 
> Steven Rostedt (5):
>       tracing: Remove lock_depth from event entry
>       ftrace: Add .ref.text as one of the safe areas to trace
>       ftrace/graph: Trace function entry before updating index
>       tracing: Align 4 byte ints together in struct tracer
>       tracing: Fix irqoff selftest expanding max buffer
> 
> Yuanhan Liu (1):
>       tracing: Export trace_set_clr_event()
> 
> ----
>  Documentation/trace/ftrace.txt |    5 +++++
>  arch/x86/kernel/ftrace.c       |   15 ++++++++-------
>  arch/x86/kvm/trace.h           |    8 ++++----
>  include/linux/ftrace_event.h   |    1 -
>  include/linux/ring_buffer.h    |    2 ++
>  include/trace/events/mce.h     |    8 ++++----
>  include/trace/events/module.h  |    5 ++---
>  include/trace/events/skb.h     |    4 ++--
>  kernel/trace/ring_buffer.c     |   24 +++++++++++++++++++++---
>  kernel/trace/trace.c           |   34 +++++++++++++++++++++++-----------
>  kernel/trace/trace.h           |    3 ++-
>  kernel/trace/trace_entries.h   |    6 +++---
>  kernel/trace/trace_events.c    |    2 +-
>  kernel/trace/trace_output.c    |   36 ++++++++++++++++++++----------------
>  scripts/recordmcount.c         |    3 ++-
>  scripts/recordmcount.pl        |    1 +
>  16 files changed, 100 insertions(+), 57 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
