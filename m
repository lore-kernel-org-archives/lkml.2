Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0EQX3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:29:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33453 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0EQX3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:29:52 -0400
Date: Tue, 18 May 2010 01:29:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] perf options type checking
Message-ID: <20100517232920.GA16977@elte.hu>
References: <1274124678-24781-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274124678-24781-1-git-send-email-acme@infradead.org>
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
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf
> 
> Regards,
> 
> - Arnaldo
> 
> Arnaldo Carvalho de Melo (4):
>   perf options: Introduce OPT_UINTEGER
>   perf options: Check v type in OPT_U?INTEGER
>   perf options: Type check OPT_BOOLEAN and fix the offenders
>   perf options: Type check all the remaining OPT_ variants
> 
>  tools/perf/bench/sched-messaging.c     |    6 ++----
>  tools/perf/builtin-bench.c             |    4 ++--
>  tools/perf/builtin-help.c              |    6 +++---
>  tools/perf/builtin-kvm.c               |    6 +++---
>  tools/perf/builtin-lock.c              |    3 +--
>  tools/perf/builtin-record.c            |    8 +++-----
>  tools/perf/builtin-report.c            |    4 ++--
>  tools/perf/builtin-sched.c             |    8 ++++----
>  tools/perf/builtin-test.c              |    2 +-
>  tools/perf/builtin-top.c               |    7 +++----
>  tools/perf/perf.h                      |    3 ++-
>  tools/perf/util/hist.c                 |    2 +-
>  tools/perf/util/include/linux/kernel.h |    2 ++
>  tools/perf/util/parse-options.c        |   32 +++++++++++++++++++++++++-------
>  tools/perf/util/parse-options.h        |   27 +++++++++++++++++----------
>  tools/perf/util/sort.c                 |    8 ++++----
>  tools/perf/util/sort.h                 |    8 ++++----
>  tools/perf/util/symbol.h               |    2 +-
>  18 files changed, 80 insertions(+), 58 deletions(-)

Pulled, thanks a lot Arnaldo!

	Ingo
