Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0IMS3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:29:01 -0400
Received: from mail.perches.com ([173.55.12.10]:1820 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:28:59 -0400
Subject: Re: [PATCH] sched: Improve latencies under load by decreasing
 minimum scheduling granularity
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100913182355.GC20171@elte.hu>
References: <20100912203712.GD32327@Krystal>
	 <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop>
	 <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop>
	 <20100913161641.GA28707@Krystal>
	 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
	 <20100913174533.GA15653@Krystal> <20100913180348.GA20171@elte.hu>
	 <20100913181925.GA15107@Krystal>  <20100913182355.GC20171@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 11:28:54 -0700
Message-ID: <1284402534.26719.2.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 20:23 +0200, Ingo Molnar wrote:
>       sched: Improve latencies under load by decreasing minimum scheduling granularity
>  kernel/sched_fair.c |    6 +++---
> @@ -54,13 +54,13 @@ enum sched_tunable_scaling sysctl_sched_tunable_scaling
>   * Minimal preemption granularity for CPU-bound tasks:
>   * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
>   */
> -unsigned int sysctl_sched_min_granularity = 2000000ULL;
> -unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
> +unsigned int sysctl_sched_min_granularity = 750000ULL;
> +unsigned int normalized_sysctl_sched_min_granularity = 750000ULL;

Change the comment as well?


