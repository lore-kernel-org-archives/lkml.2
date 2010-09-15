Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0IOI2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:28:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0IOI2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:28:35 -0400
Date: Wed, 15 Sep 2010 10:28:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] [GIT PULL] tracing: real fix for set_ftrace_filter
Message-ID: <20100915082824.GC16593@elte.hu>
References: <20100914202714.376849326@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914202714.376849326@goodmis.org>
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

> Ingo,
> 
> This includes the real fix for the bug that was found for
> set_ftrace_filter. Since I noticed that Linus's tree has the
> quick fix that Christ Wright and I made, I just based off of
> mainline.
> 
> -- Steve
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (4):
>       tracing: Do not reset *pos in set_ftrace_filter
>       tracing: Replace typecasted void pointer in set_ftrace_filter code
>       tracing: Keep track of set_ftrace_filter position and allow lseek again
>       tracing: Fix reading of set_ftrace_filter across lists
> 
> ----
>  kernel/trace/ftrace.c |  105 +++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 76 insertions(+), 29 deletions(-)

Pulled, thanks a lot Steve! I wanted to merge -rc4 into perf/core anyway 
;-)

	Ingo
