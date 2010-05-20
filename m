Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0ETMlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:41:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57455 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab0ETMlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:41:01 -0400
Date: Thu, 20 May 2010 14:40:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100520124050.GA2734@elte.hu>
References: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Comply with new rcu checks API
>       perf: Fix unaligned accesses while fetching trace values
> 
> Tom Zanussi (1):
>       perf: Use read() instead of lseek() in trace_event_read.c:skip()
> 
> 
>  kernel/perf_event.c                |   58 ++++++++++++++++++++++++++++-------
>  tools/perf/util/trace-event-read.c |   19 ++++++++----
>  tools/perf/util/trace-event.h      |    7 ++++-
>  3 files changed, 65 insertions(+), 19 deletions(-)

Pulled, thanks Frederic!

	Ingo
