Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1CWJfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:35:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52787 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab1CWJfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:35:46 -0400
Date: Wed, 23 Mar 2011 10:35:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH][GIT PULL][v2.6.39] tracing: Fix set_ftrace_filter probe
 function display
Message-ID: <20110323093536.GA1690@elte.hu>
References: <1300843966.14261.126.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300843966.14261.126.camel@gandalf.stny.rr.com>
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
> This patch was buried away in my INBOX, and I recently discovered it. I
> tested out the scenario that Jiri posted and sure enough it is broken.
> This patch does indeed fix the issue.
> 
> As the merge window is still open and this is a simple patch that fixes
> a long standing bug, could you pull it for 2.6.39.
> 
> Thanks!
> 
> -- Steve
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> 
> Jiri Olsa (1):
>       tracing: Fix set_ftrace_filter probe function display
> 
> ----
>  kernel/trace/ftrace.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Pulled, thanks Steve!

	Ingo
