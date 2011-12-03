Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1LCJWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 04:22:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53992 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1LCJWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 04:22:37 -0500
Date: Sat, 3 Dec 2011 10:20:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various fixes
Message-ID: <20111203092043.GA2739@elte.hu>
References: <20111108012939.372220547@goodmis.org>
 <20111111083339.GD14347@elte.hu>
 <1322602385.17003.89.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322602385.17003.89.camel@frodo>
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

> On Fri, 2011-11-11 at 09:33 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > Please pull the latest tip/perf/core tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > > tip/perf/core
> > > 
> > > Head SHA1: 7e9a49ef542610609144d1afcd516dc3fafac4d6
> > > 
> > > 
> > > Gleb Natapov (1):
> > >       jump_label: jump_label_inc may return before the code is patched
> > > 
> > > Ilya Dryomov (1):
> > >       tracing: fix event_subsystem ref counting
> > > 
> > > Jiri Olsa (1):
> > >       tracing/latency: Fix header output for latency tracers
> > > 
> > > Li Zefan (2):
> > >       tracing: Restore system filter behavior
> > >       tracing: update Documentation on max preds limit
> > > 
> > > Steven Rostedt (5):
> > >       tracing: Add boiler plate for subsystem filter
> > >       lockdep: Show subclass in pretty print of lockdep output
> > >       ftrace: Remove force undef config value left for testing
> > >       perf: Fix parsing of __print_flags() in TP_printk()
> > >       ftrace: Fix hash record accounting bug
> > > 
> > > ----
> > >  Documentation/trace/events.txt      |    2 --
> > >  include/linux/ftrace_event.h        |    2 ++
> > >  kernel/jump_label.c                 |    3 ++-
> > >  kernel/lockdep.c                    |   30 +++++++++++++-----------------
> > >  kernel/trace/ftrace.c               |    5 +++--
> > >  kernel/trace/trace.c                |   15 +++++++++++++++
> > >  kernel/trace/trace.h                |    1 +
> > >  kernel/trace/trace_events.c         |    1 -
> > >  kernel/trace/trace_events_filter.c  |   33 +++++++++++++++++++++++++--------
> > >  kernel/trace/trace_irqsoff.c        |   13 ++++++++++++-
> > >  kernel/trace/trace_sched_wakeup.c   |   13 ++++++++++++-
> > >  tools/perf/util/trace-event-parse.c |    2 ++
> > >  12 files changed, 87 insertions(+), 33 deletions(-)
> > 
> > Pulled, thanks a lot Steve!
> 
> Hi Ingo,
> 
> All these were bug fixes and I was hopping that it would have 
> been pushed to Linus. I know it just missed the merge window 
> (it was posted during -rc1) but they are fixes, not 
> enhancements, and I still believe they are fine for an -rc3 
> release. I would have even had it pushed before -rc1 but it 
> took time running them through all my tests.

Hm, not all were regression fixes and the branch was named 
*/core so i took it into perf/core.

Could you perhaps cherry-pick the most crutial regression fixes 
into an urgent branch? We could still push that upstream.

Thanks,

	Ingo
