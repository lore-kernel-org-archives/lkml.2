Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1AKK6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:58:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1AKK56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:57:58 -0500
Date: Tue, 11 Jan 2011 11:57:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Chris Samuel <chris@csamuel.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/6] perf/urgent fixes and improvements
Message-ID: <20110111105708.GA5253@elte.hu>
References: <1294705692-9537-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294705692-9537-1-git-send-email-acme@infradead.org>
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
>         Please consider pulling from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/urgent
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf sched: Fix allocation result check
>   perf tools: Emit clearer message for sys_perf_event_open ENOENT return
>   perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)
>   perf session: Fix infinite loop in __perf_session__process_events
> 
> David Ahern (1):
>   perf stat: better error message for unsupported events
> 
> Jiri Pirko (1):
>   perf sched: Use PTHREAD_STACK_MIN to avoid pthread_attr_setstacksize() fail
> 
>  tools/perf/builtin-record.c |    3 +
>  tools/perf/builtin-sched.c  |    5 +-
>  tools/perf/builtin-stat.c   |    2 +
>  tools/perf/builtin-test.c   |  110 +++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/builtin-top.c    |    2 +
>  tools/perf/util/evsel.c     |   82 +++++++++++++++++++-------------
>  tools/perf/util/session.c   |    2 +-
>  7 files changed, 170 insertions(+), 36 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
