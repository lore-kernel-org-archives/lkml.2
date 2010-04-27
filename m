Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0D0JQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:16:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0D0JQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:16:37 -0400
Date: Tue, 27 Apr 2010 11:15:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, William Cohen <wcohen@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       Stephane Eranian <eranian@google.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [GIT PULL] perf tools updates
Message-ID: <20100427091527.GA11348@elte.hu>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (6):
>       perf: Generalize perf lock's sample event reordering to the session layer
>       perf: Use generic sample reordering in perf sched
>       perf: Use generic sample reordering in perf kmem
>       perf: Use generic sample reordering in perf trace
>       perf: Use generic sample reordering in perf timechart
>       perf: Add a perf trace option to check samples ordering reliability
> 
> Hitoshi Mitake (1):
>       perf lock: Fix state machine to recognize lock sequence
> 
> Stephane Eranian (1):
>       perf: Fix initialization bug in parse_single_tracepoint_event()
> 
> William Cohen (1):
>       perf: Some perf-kvm documentation edits
> 
> 
>  tools/perf/Documentation/perf-kvm.txt |    9 +-
>  tools/perf/builtin-kmem.c             |    6 +-
>  tools/perf/builtin-lock.c             |  595 ++++++++++++++++++++-------------
>  tools/perf/builtin-sched.c            |    8 +-
>  tools/perf/builtin-timechart.c        |  112 +------
>  tools/perf/builtin-trace.c            |   13 +
>  tools/perf/util/parse-events.c        |   13 +-
>  tools/perf/util/session.c             |  179 ++++++++++-
>  tools/perf/util/session.h             |   10 +
>  9 files changed, 583 insertions(+), 362 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
