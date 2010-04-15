Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0DOHYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:24:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0DOHYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:24:37 -0400
Date: Thu, 15 Apr 2010 09:24:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, mhiramat@infradead.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] perf probe batch and a fix for sort_entries
Message-ID: <20100415072428.GF9240@elte.hu>
References: <20100415012743.GP25649@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415012743.GP25649@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> 	All patches already appeared on lkml,
> 
> Best Regards,
> 
> - Arnaldo
> 
> Frederic Weisbecker (1):
>   perf tools: Fix accidentally preprocessed snprintf callback
> 
> Masami Hiramatsu (16):
>   perf probe: Support argument name
>   perf probe: Use the last field name as the argument name
>   tracing/kprobes: Support basic types on dynamic events
>   perf probe: Query basic types from debuginfo
>   perf probe: Support basic type casting
>   perf probe: Support DW_OP_call_frame_cfa in debuginfo
>   perf probe: Remove die() from probe-finder code
>   perf probe: Remove die() from probe-event code
>   perf probe: Remove xzalloc() from util/probe-{event, finder}.c
>   perf probe: Remove xstrdup()/xstrndup() from util/probe-{event, finder}.c
>   perf probe: Fix to use correct debugfs path finder
>   perf probe: Fix mis-estimation for shortening filename
>   perf probe: Fix a bug that --line range can be overflow
>   perf probe: Fix line range to show end line
>   perf probe: Support DW_OP_plus_uconst in DW_AT_data_member_location
>   perf probe: Show function entry line as probe-able
> 
>  Documentation/trace/kprobetrace.txt     |    4 +-
>  kernel/trace/trace.h                    |   16 +-
>  kernel/trace/trace_kprobe.c             |  535 +++++++++++-------
>  tools/perf/Documentation/perf-probe.txt |   11 +-
>  tools/perf/builtin-probe.c              |   78 ++-
>  tools/perf/util/hist.c                  |   28 +-
>  tools/perf/util/probe-event.c           |  898 ++++++++++++++++++++++---------
>  tools/perf/util/probe-event.h           |   33 +-
>  tools/perf/util/probe-finder.c          |  753 ++++++++++++++++++--------
>  tools/perf/util/probe-finder.h          |    1 +
>  tools/perf/util/sort.c                  |   42 +-
>  tools/perf/util/sort.h                  |   12 +-
>  12 files changed, 1634 insertions(+), 777 deletions(-)

Pulled, thanks guys!

	Ingo
