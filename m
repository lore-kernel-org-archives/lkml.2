Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab0EIRtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 13:49:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37321 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0EIRt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 13:49:29 -0400
Date: Sun, 9 May 2010 19:48:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tom@infradead.org,
       "Zanussi <tzanussi"@gmail.com
Subject: Re: [PATCH 0/3] perf tools minor fixes
Message-ID: <20100509174853.GA17881@elte.hu>
References: <1273421697-30138-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273421697-30138-1-git-send-email-acme@infradead.org>
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
> Arnaldo Carvalho de Melo (3):
>   perf callchain: Move validate_callchain to callchain lib
>   perf report: Fix leak of resolved callchains array on error path
>   perf hist: Simplify the insertion of new hist_entry instances
> 
>  tools/perf/builtin-annotate.c |    9 ++-----
>  tools/perf/builtin-diff.c     |   14 ++----------
>  tools/perf/builtin-report.c   |   43 +++++++++-------------------------------
>  tools/perf/util/callchain.c   |    7 ++++++
>  tools/perf/util/callchain.h   |    3 ++
>  tools/perf/util/hist.c        |   36 +++++++++++++++++++++------------
>  tools/perf/util/hist.h        |    5 +---
>  7 files changed, 50 insertions(+), 67 deletions(-)

Pulled, thanks Arnaldo!

	Ingo
