Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0EJQ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:59:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0EJQ7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:59:47 -0400
Date: Mon, 10 May 2010 18:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [GIT PULL 0/4] perf improvements and fixes
Message-ID: <20100510165918.GA15804@elte.hu>
References: <1273509141-15696-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273509141-15696-1-git-send-email-acme@infradead.org>
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
> 	The 3rd is important as it fixes a recently introduced bug (yesterday,
> I believe), that makes perf record segfault.
> 
> Regards,
> 
> Arnaldo Carvalho de Melo (4):
>   perf newt: Use newtAddComponent()
>   perf callchains: Use zalloc to allocate objects
>   perf session: create_kernel_maps should use ->host_machine
>   perf hist: Introduce hists class and move lots of methods to it
> 
>  tools/perf/builtin-annotate.c |   17 ++++----
>  tools/perf/builtin-diff.c     |   50 ++++++++++------------
>  tools/perf/builtin-report.c   |   71 +++++++++++++++----------------
>  tools/perf/builtin-trace.c    |    2 +-
>  tools/perf/util/callchain.c   |    6 +-
>  tools/perf/util/event.c       |    2 +-
>  tools/perf/util/event.h       |   14 ------
>  tools/perf/util/hist.c        |   92 ++++++++++++++++++----------------------
>  tools/perf/util/hist.h        |   48 ++++++++++++---------
>  tools/perf/util/newt.c        |    6 +-
>  tools/perf/util/session.c     |    7 +--
>  tools/perf/util/session.h     |   12 ++++-
>  12 files changed, 154 insertions(+), 173 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
