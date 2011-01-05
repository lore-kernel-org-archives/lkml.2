Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1AERcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:32:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab1AERcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:32:05 -0500
Date: Wed, 5 Jan 2011 18:31:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/5] perf/core fixes and cleanups
Message-ID: <20110105173140.GA2016@elte.hu>
References: <1294247046-32352-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294247046-32352-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	I removed the patch that introduced map__empty and caused those
> aliasing problems on f12 i386, I tried but couldn't reproduce it on a f14
> i386 machine, will investigate more later.
> 
> 	The synch of master.k.o to g.k.o these days is taking a long time, so
> beware.
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf test: Clarify some error reports in the open syscall test
>   perf session: Warn about errors when processing pipe events too
>   perf script: Use the default lost event handler
>   perf script: Make some lists static
> 
> Stephane Eranian (1):
>   perf tools: Fix perf_event.h header usage
> 
>  tools/perf/builtin-script.c    |   19 ++-----------
>  tools/perf/builtin-test.c      |   18 +++++++-----
>  tools/perf/util/evsel.h        |    2 +-
>  tools/perf/util/parse-events.h |    2 +-
>  tools/perf/util/session.c      |   57 +++++++++++++++++++++------------------
>  5 files changed, 47 insertions(+), 51 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
