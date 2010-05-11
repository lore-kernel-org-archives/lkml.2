Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0EKGNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:13:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0EKGNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:13:48 -0400
Date: Tue, 11 May 2010 08:13:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 00/10] perf fixes and improvements
Message-ID: <20100511061333.GC4282@elte.hu>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
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

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> Arnaldo Carvalho de Melo (1):
>   perf hist: Calculate max_sym name len and nr_entries
> 
> Tom Zanussi (9):
>   perf/trace/scripting: failed-syscalls script cleanup
>   perf/trace/scripting: rw-by-pid script cleanup
>   perf/trace/scripting: rwtop script cleanup
>   perf/trace/scripting: wakeup-latency script cleanup
>   perf/trace/scripting: workqueue-stats script cleanup
>   perf/trace/scripting: don't show script start/stop messages by default
>   perf/trace/scripting: failed-syscalls-by-pid script cleanup
>   perf/trace/scripting: syscall-counts-by-pid script cleanup
>   perf/trace/scripting: syscall-counts script cleanup
> 
>  tools/perf/builtin-report.c                        |    6 +-
>  tools/perf/builtin-trace.c                         |    3 +
>  tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
>  tools/perf/scripts/perl/failed-syscalls.pl         |    6 ++-
>  tools/perf/scripts/perl/rw-by-pid.pl               |   60 ++++++++++++--------
>  tools/perf/scripts/perl/rwtop.pl                   |   48 +++++++++++----
>  tools/perf/scripts/perl/wakeup-latency.pl          |   12 +++-
>  tools/perf/scripts/perl/workqueue-stats.pl         |   12 ++--
>  .../python/bin/failed-syscalls-by-pid-report       |    2 +-
>  .../python/bin/syscall-counts-by-pid-report        |    2 +-
>  .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
>  tools/perf/util/hist.c                             |   27 +++++++--
>  tools/perf/util/hist.h                             |    4 +-
>  .../perf/util/scripting-engines/trace-event-perl.c |    3 -
>  .../util/scripting-engines/trace-event-python.c    |    4 -
>  tools/perf/util/symbol.c                           |    5 +-
>  tools/perf/util/symbol.h                           |    1 +
>  17 files changed, 128 insertions(+), 71 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
