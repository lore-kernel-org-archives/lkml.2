Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0HPRbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:31:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0HPRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:31:03 -0400
Date: Mon, 16 Aug 2010 19:30:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH][GIT PULL] tracing: Sanitize value returned from
 write(trace_marker, "...", len)
Message-ID: <20100816173054.GB2383@elte.hu>
References: <1281732907.3058.77.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281732907.3058.77.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4648]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I had this sitting in my quilt queue, and did not realize I never
> committed it. This is on top of my previous two pull requests.
> 
> Thanks,
> 
> -- Steve
> 
> Please pull the latest tip/perf/urgent-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent-3
> 
> 
> Marcin Slusarz (1):
>       tracing: Sanitize value returned from write(trace_marker, "...", len)
> 
> ----
>  kernel/trace/trace.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
