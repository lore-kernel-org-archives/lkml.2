Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1LENg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:36:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab1LENgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:36:12 -0500
Date: Mon, 5 Dec 2011 14:34:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH][GIT PULL][v3.2] trace_events_filter: Use
 rcu_assign_pointer() when setting ftrace_event_call->filter
Message-ID: <20111205133425.GB28866@elte.hu>
References: <1322877399.30977.68.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322877399.30977.68.camel@frodo>
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
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/perf/urgent
> 
> Head SHA1: d3d9acf646679c1981032b0985b386d12fccc60c
> 
> 
> Tejun Heo (1):
>       trace_events_filter: Use rcu_assign_pointer() when setting ftrace_event_call->filter
> 
> ----
>  kernel/trace/trace_events_filter.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Pulled, thanks Steve!

	Ingo
