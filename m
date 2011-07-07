Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab1GGOPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:15:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab1GGOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:15:42 -0400
Date: Thu, 7 Jul 2011 16:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.0] tracing: Add refcount for system
 filter and enable
Message-ID: <20110707141525.GA19193@elte.hu>
References: <20110706211931.764277374@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706211931.764277374@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

> 
> Ingo,
> 
> Please pull the latest tip/perf/urgent tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/urgent
> 
> Head SHA1: 57f124ca21d216fca3ba3995235c15855f9b9980
> 
> 
> Steven Rostedt (2):
>       tracing: Add ref_count to event systems for freeing
>       tracing: Have enable system events use the subsystem_open routine
> 
> ----
>  kernel/trace/trace.h               |    1 +
>  kernel/trace/trace_events.c        |  113 ++++++++++++++++++++++++++++++------
>  kernel/trace/trace_events_filter.c |    6 ++
>  3 files changed, 102 insertions(+), 18 deletions(-)

Hm, i'm wondering, when was this bug introduced?

Thanks,

	Ingo
