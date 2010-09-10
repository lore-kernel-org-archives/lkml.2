Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0IJGFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:05:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab0IJGFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:05:38 -0400
Date: Fri, 10 Sep 2010 08:05:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Swiecki <swiecki@google.com>,
        Eugene Teo <eugene@redhat.com>, stable@kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH][GIT PULL][v2.6.36] tracing: t_start: reset
 FTRACE_ITER_HASH in case of seek/pread
Message-ID: <20100910060506.GC17127@elte.hu>
References: <1284089048.5786.752.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284089048.5786.752.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> The previous fixed only fixed lseek, Chris's fix also handles pread().
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Chris Wright (1):
>       tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread
> 
> ----
>  kernel/trace/ftrace.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Pulled, thanks Steve!

	Ingo
