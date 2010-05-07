Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0EGGeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 02:34:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60760 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0EGGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 02:34:17 -0400
Date: Fri, 7 May 2010 08:34:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] [GIT PULL] tracing: various fixes
Message-ID: <20100507063404.GC3870@elte.hu>
References: <20100506230459.278936703@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506230459.278936703@goodmis.org>
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
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Li Zefan (1):
>       tracing: Make the documentation clear on trace_event boot option
> 
> Steven Rostedt (1):
>       tracing: Fix tracepoint.h DECLARE_TRACE() to allow more than one header
> 
> Thiago Farina (1):
>       tracing: Fix "integer as NULL pointer" warning.
> 
> ----
>  Documentation/trace/events.txt |    3 +-
>  include/linux/tracepoint.h     |  114 +++++++++++++++++++++-------------------
>  include/trace/define_trace.h   |    5 ++
>  include/trace/events/napi.h    |   10 +++-
>  kernel/trace/trace_output.c    |    2 +-
>  5 files changed, 75 insertions(+), 59 deletions(-)

Pulled, thanks Steve!

	Ingo
