Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1JDH7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:59:06 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:39505 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1JDH7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:59:05 -0400
Date: Tue, 4 Oct 2011 09:57:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jim Cromie <jim.cromie@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Neil Horman <nhorman@tuxdriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 00/16] perf/core improvements and fixes
Message-ID: <20111004075720.GB14474@elte.hu>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please consider pulling from:
> 
> git://github.com/acmel/linux.git perf/core
> 
> 	This was rebased against your perf/core on tesla.
> 
> Regards,
> 
> - Arnaldo
> 
> Andi Kleen (2):
>   perf tools: Make stat/record print fatal signals of the target program
>   perf: Support setting the disassembler style
> 
> Arnaldo Carvalho de Melo (6):
>   perf symbols: Stop using 'self' in map_groups__ methods
>   perf buildid-list: Add option to show the running kernel build id
>   perf buildid-list: Support showing the build id in an ELF file
>   perf top browser: Fix up line width calculation
>   perf top: Improve lost events warning
>   perf report: Fix stdio event name header printing
> 
> Jim Cromie (5):
>   perf stat: Add --log-fd <N> option to redirect stderr elsewhere
>   perf stat: Fix +- nan% in --no-aggr runs
>   perf stat: Suppress printing std-dev when its 0
>   perf stat: Allow tab as cvs delimiter
>   perf stat: Fix spelling in comment
> 
> Jiri Olsa (2):
>   perf sched: Fix script command documentation
>   perf symbols: Treat all memory maps without dso file as loaded
> 
> Neil Horman (1):
>   perf script: Add drop monitor script
> 
>  tools/perf/Documentation/perf-annotate.txt         |    3 +
>  tools/perf/Documentation/perf-buildid-list.txt     |    6 +
>  tools/perf/Documentation/perf-report.txt           |    3 +
>  tools/perf/Documentation/perf-sched.txt            |    6 +-
>  tools/perf/Documentation/perf-stat.txt             |   11 ++-
>  tools/perf/builtin-annotate.c                      |    2 +
>  tools/perf/builtin-buildid-list.c                  |   52 ++++++++++-
>  tools/perf/builtin-record.c                        |   19 ++++-
>  tools/perf/builtin-report.c                        |    7 +-
>  tools/perf/builtin-stat.c                          |   35 ++++++-
>  tools/perf/builtin-top.c                           |   34 ++++----
>  .../perf/scripts/python/bin/net_dropmonitor-record |    2 +
>  .../perf/scripts/python/bin/net_dropmonitor-report |    4 +
>  tools/perf/scripts/python/net_dropmonitor.py       |   72 ++++++++++++++
>  tools/perf/util/annotate.c                         |    6 +-
>  tools/perf/util/annotate.h                         |    2 +
>  tools/perf/util/map.c                              |   98 +++++++++++---------
>  tools/perf/util/map.h                              |   42 ++++----
>  tools/perf/util/top.h                              |    3 +
>  tools/perf/util/ui/browsers/top.c                  |   28 +++++-
>  20 files changed, 333 insertions(+), 102 deletions(-)
>  create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-record
>  create mode 100755 tools/perf/scripts/python/bin/net_dropmonitor-report
>  create mode 100755 tools/perf/scripts/python/net_dropmonitor.py

Pulled, thanks a lot Arnaldo!

	Ingo
