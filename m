Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1K2VdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:33:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36542 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1K2VdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:33:14 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=AyFK6pwGKUQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=yQCjd3IP5wDR1yPIEN4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20111111083339.GD14347@elte.hu>
References: <20111108012939.372220547@goodmis.org>
	 <20111111083339.GD14347@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 16:33:05 -0500
Message-ID: <1322602385.17003.89.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 09:33 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > Please pull the latest tip/perf/core tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > tip/perf/core
> > 
> > Head SHA1: 7e9a49ef542610609144d1afcd516dc3fafac4d6
> > 
> > 
> > Gleb Natapov (1):
> >       jump_label: jump_label_inc may return before the code is patched
> > 
> > Ilya Dryomov (1):
> >       tracing: fix event_subsystem ref counting
> > 
> > Jiri Olsa (1):
> >       tracing/latency: Fix header output for latency tracers
> > 
> > Li Zefan (2):
> >       tracing: Restore system filter behavior
> >       tracing: update Documentation on max preds limit
> > 
> > Steven Rostedt (5):
> >       tracing: Add boiler plate for subsystem filter
> >       lockdep: Show subclass in pretty print of lockdep output
> >       ftrace: Remove force undef config value left for testing
> >       perf: Fix parsing of __print_flags() in TP_printk()
> >       ftrace: Fix hash record accounting bug
> > 
> > ----
> >  Documentation/trace/events.txt      |    2 --
> >  include/linux/ftrace_event.h        |    2 ++
> >  kernel/jump_label.c                 |    3 ++-
> >  kernel/lockdep.c                    |   30 +++++++++++++-----------------
> >  kernel/trace/ftrace.c               |    5 +++--
> >  kernel/trace/trace.c                |   15 +++++++++++++++
> >  kernel/trace/trace.h                |    1 +
> >  kernel/trace/trace_events.c         |    1 -
> >  kernel/trace/trace_events_filter.c  |   33 +++++++++++++++++++++++++--------
> >  kernel/trace/trace_irqsoff.c        |   13 ++++++++++++-
> >  kernel/trace/trace_sched_wakeup.c   |   13 ++++++++++++-
> >  tools/perf/util/trace-event-parse.c |    2 ++
> >  12 files changed, 87 insertions(+), 33 deletions(-)
> 
> Pulled, thanks a lot Steve!

Hi Ingo,

All these were bug fixes and I was hopping that it would have been
pushed to Linus. I know it just missed the merge window (it was posted
during -rc1) but they are fixes, not enhancements, and I still believe
they are fine for an -rc3 release. I would have even had it pushed
before -rc1 but it took time running them through all my tests.

-- Steve


