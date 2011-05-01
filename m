Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240Ab1EARgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:36:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1EARgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:36:51 -0400
Date: Sun, 1 May 2011 19:36:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] [GIT PULL][2.6.40] ftrace: cleanups
Message-ID: <20110501173638.GA26864@elte.hu>
References: <20110430153040.354378898@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430153040.354378898@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I'm still working on the accounting of ftrace function tracer to be able
> to have multiple users that do not conflict with each other in selecting
> functions to trace. It's going well and is almost done.
> 
> But in doing this, there were several cleanups that had to be made first.
> This patch series contains those cleanups and I've already run my tests
> on them and wanted to get them out now, instead of sending them with
> the major changes. This will let reviews focus on the major changes
> and not have to worry about these cleanups. Reviewers can examine these
> cleanups now if they want.
> 
> One nice thing about this patch set is the stats:
>   141 insertions(+), 214 deletions(-)
> 
> Please pull the latest tip/perf/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/core
> 
> 
> Steven Rostedt (8):
>       ftrace: Make FTRACE_WARN_ON() work in if condition
>       ftrace: Remove unnecessary disabling of irqs
>       ftrace: Remove failures file
>       ftrace: Remove FTRACE_FL_FAILED flag
>       ftrace: Remove FTRACE_FL_CONVERTED flag
>       ftrace: Move record update for normal and modules into a separate function
>       ftrace: Consolidate updating of ftrace_trace_function
>       ftrace: Consolidate the function match routines for normal and mods
> 
> ----
>  include/linux/ftrace.h |    8 +-
>  kernel/trace/ftrace.c  |  347 +++++++++++++++++++-----------------------------
>  2 files changed, 141 insertions(+), 214 deletions(-)

Pulled, thanks Steve!

	Ingo
