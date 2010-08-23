Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab0HWJUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:20:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50518 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0HWJUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:20:40 -0400
Date: Mon, 23 Aug 2010 11:20:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] perf callchain improvement and fixes
Message-ID: <20100823092023.GA9003@elte.hu>
References: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282511740-22631-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
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
> Unfortunately we were missing a lot of callchains in multithread
> cases. And this was not a regression, it was rather the fact I
> was missing a part of the histogram processing: the collapsing.
> 
> Anyway, this is eventually fixed. Thanks a lot to Chistoph Hellwig
> who reported this.
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (3):
>       perf: Keep track of the max depth of a callchain
>       perf: Rename append_callchain into callchain_append
>       perf: Support for callchains merge
> 
> 
>  tools/perf/builtin-report.c |    3 +-
>  tools/perf/util/callchain.c |   98 ++++++++++++++++++++++++++++++++++---------
>  tools/perf/util/callchain.h |   25 +++++++----
>  tools/perf/util/hist.c      |    4 +-
>  tools/perf/util/sort.h      |    2 +-
>  5 files changed, 100 insertions(+), 32 deletions(-)

Pulled, thanks a lot!

	Ingo
