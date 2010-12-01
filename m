Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab0LAIWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:22:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab0LAIWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:22:49 -0500
Date: Wed, 1 Dec 2010 09:22:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 00/11] perf/core performance improvements
Message-ID: <20101201082202.GA3140@elte.hu>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
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
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (2):
>   perf events: Precalculate the header space for PERF_SAMPLE_ fields
>   perf debug: Simplify trace_event
> 
> Thomas Gleixner (9):
>   perf session: Fix list sort algorithm
>   perf session: Use appropriate pointer type instead of silly typecasting
>   perf session: Cleanup __perf_session__process_events()
>   perf session: Move ui_progress_update in __perf_session__process_events()
>   perf session: Simplify termination checks
>   perf session: Use sensible mmap size
>   perf session: Keep file mmaped instead of malloc/memcpy
>   perf session: Cache sample objects
>   perf session: Allocate chunks of sample objects
> 
>  include/linux/perf_event.h |    2 +
>  kernel/perf_event.c        |  150 ++++++++++++++---------
>  tools/perf/util/debug.c    |   41 ++-----
>  tools/perf/util/session.c  |  289 ++++++++++++++++++++++++--------------------
>  tools/perf/util/session.h  |    8 +-
>  5 files changed, 269 insertions(+), 221 deletions(-)

Pulled, thanks a lot guys!

I also merged the followup fixes.

Note: I also merged the perf trace -> perf script rename commit that we tested in 
-tip for some time, into perf/core - please double check any 'perf script' fallout.

	Ingo
