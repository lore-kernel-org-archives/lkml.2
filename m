Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0EYNt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:49:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47039 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0EYNt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:49:27 -0400
Date: Tue, 25 May 2010 15:49:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: Add __used annotation to event
 variable
Message-ID: <20100525134915.GA18479@elte.hu>
References: <1274794290.22648.209.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274794290.22648.209.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This fixes the warning/error on PowerPC.
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (1):
>       tracing: Add __used annotation to event variable
> 
> ----
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pulled, thanks Steve!

	Ingo
