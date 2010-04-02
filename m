Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0DBUHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:07:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34555 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab0DBUH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:07:29 -0400
Date: Fri, 2 Apr 2010 22:07:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v2.6.34] tracing: fixes
Message-ID: <20100402200722.GB4045@elte.hu>
References: <20100330025800.713540457@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330025800.713540457@goodmis.org>
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
> I rebased my branch against yours and removed the module patch since it 
> looks like it is no longer urgent. I moved it over to my core branch along 
> with a fix to the compile error you saw with it. I'll be pushing that later 
> this week.
> 
> These two patchs still should go into 34.
> 
> Please pull the latest tip/tracing/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/urgent
> 
> 
> Julia Lawall (1):
>       ring-buffer: Add missing unlock
> 
> Li Zefan (1):
>       tracing: Fix lockdep warning in global_clock()
> 
> ----
>  kernel/trace/ring_buffer.c |    8 +++++---
>  kernel/trace/trace_clock.c |    4 ++--
>  2 files changed, 7 insertions(+), 5 deletions(-)

Pulled, thanks Steve!

	Ingo
