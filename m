Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0IOJWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:22:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0IOJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:22:18 -0400
Date: Wed, 15 Sep 2010 11:22:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced forks)
 (v3)
Message-ID: <20100915092205.GG16593@elte.hu>
References: <20100914202503.GA1496@Krystal>
 <1284539831.21727.6.camel@marge.simson.net>
 <1284541405.22863.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1284541405.22863.8.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> Tangent: cgroups with classification user/pgid
>
> taskset -c 3 ./wakeup-latency& sleep 30 && killall wakeup-latency
> (taskset -c 3 make -j10 running)
> 
> maximum latency: 256.5 µs
> average latency: 25.7 µs
> missed timer events: 0
> 
> Rather spiffy for this case.

Ouch, nothing beats proper segregation of workloads.

It would be _really_ nice to get that automatically somehow, for make -j 
jobs. Perhaps a per tty auto-cgroup-classification kernel feature?

We cannot really rely on distros to pull this off.

Thanks,

	Ingo
