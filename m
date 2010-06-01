Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0FAG76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:59:58 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:42963 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab0FAG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:59:57 -0400
Date: Tue, 1 Jun 2010 08:59:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100601065949.GB8486@elte.hu>
References: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275346940-18498-1-git-send-regression-fweisbec@gmail.com>
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
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (3):
>       perf: Process comm events by tid
>       perf: Use event__process_task from perf sched
>       perf: Do the comm inheritance per thread in event__process_task
> 
> Borislav Petkov (1):
>       perf-record: Check correct pid when forking
> 
> 
>  tools/perf/builtin-record.c |    3 +--
>  tools/perf/builtin-sched.c  |    1 +
>  tools/perf/util/event.c     |   13 ++++---------
>  3 files changed, 6 insertions(+), 11 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
