Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0EOGg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 02:36:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46954 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0EOGgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 02:36:55 -0400
Date: Sat, 15 May 2010 08:36:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] perf tools improvements
Message-ID: <20100515063621.GC23275@elte.hu>
References: <1273878577-12578-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273878577-12578-1-git-send-email-acme@infradead.org>
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
>   perf hist: Make event__totals per hists
>   perf hist: Clarify events_stats fields usage
>   perf report: Report number of events, not samples
>   perf newt: Make <- zoom out filters
> 
>  tools/perf/Makefile           |    2 +
>  tools/perf/builtin-annotate.c |    2 +-
>  tools/perf/builtin-diff.c     |    8 ++--
>  tools/perf/builtin-report.c   |   44 +++++++++++-----
>  tools/perf/builtin-sched.c    |   17 ++----
>  tools/perf/builtin-trace.c    |    2 +-
>  tools/perf/util/event.c       |   19 ++++++-
>  tools/perf/util/event.h       |    2 +
>  tools/perf/util/hist.c        |  121 +++++++++++++++++++++++++----------------
>  tools/perf/util/hist.h        |   24 +++++++-
>  tools/perf/util/newt.c        |   46 +++++++++++++---
>  tools/perf/util/pstack.c      |   75 +++++++++++++++++++++++++
>  tools/perf/util/pstack.h      |   12 ++++
>  tools/perf/util/session.c     |   36 +------------
>  tools/perf/util/session.h     |    8 ++-
>  tools/perf/util/sort.h        |   11 ++--
>  tools/perf/util/util.c        |   22 ++++++++
>  tools/perf/util/util.h        |    1 +
>  18 files changed, 322 insertions(+), 130 deletions(-)
>  create mode 100644 tools/perf/util/pstack.c
>  create mode 100644 tools/perf/util/pstack.h

Pulled, thanks a lot Arnaldo!

	Ingo
