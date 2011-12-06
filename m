Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1LFFpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:45:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50277 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1LFFpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:45:20 -0500
Date: Tue, 6 Dec 2011 06:43:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] [GIT PULL][v3.2] tracing: fixes
Message-ID: <20111206054335.GA1580@elte.hu>
References: <20111206014110.079874115@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206014110.079874115@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> These are the patches that were also in a tip/perf/core push, but
> as they are all bug fixes, we should get them into 3.2.
> 
> Thanks,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: ddf6e0e50723b62ac76ed18eb53e9417c6eefba7
> 
> 
> Gleb Natapov (1):
>       jump_label: jump_label_inc may return before the code is patched
> 
> Ilya Dryomov (1):
>       tracing: fix event_subsystem ref counting
> 
> Li Zefan (1):
>       tracing: Restore system filter behavior
> 
> Steven Rostedt (3):
>       ftrace: Remove force undef config value left for testing
>       perf: Fix parsing of __print_flags() in TP_printk()
>       ftrace: Fix hash record accounting bug
> 
> ----
>  include/linux/ftrace_event.h        |    2 ++
>  kernel/jump_label.c                 |    3 ++-
>  kernel/trace/ftrace.c               |    5 +++--
>  kernel/trace/trace_events.c         |    1 -
>  kernel/trace/trace_events_filter.c  |    7 ++++++-
>  tools/perf/util/trace-event-parse.c |    2 ++
>  6 files changed, 15 insertions(+), 5 deletions(-)

Pulled, thanks a lot Steve!

If it's problem-free i'll get it to Linus today-ish. Note that i 
also merged perf/urgent into perf/core, to neutralize the 
conflict-creation properties of the cherry-picks.

Thanks,

	Ingo
