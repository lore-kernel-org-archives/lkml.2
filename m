Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1FRTsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:48:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1FRTsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:48:36 -0400
Date: Sat, 18 Jun 2011 21:48:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        benh@kernel.crashing.org, fweisbec@gmail.com, ak@linux.intel.com,
        tim.c.chen@linux.intel.com
Subject: Re: [GIT PULL rcu/urgent] Banishing kthreads
Message-ID: <20110618194811.GA9871@elte.hu>
References: <20110617145723.GA3261@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617145723.GA3261@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull request banishes RCU kthreads in the RCU_BOOST=n case,
> in response to popular demand.  There are two commits in this
> series:
> 
> 1.	Minimal patch that #ifdefs out the kthread code.
> 
> 2.	Code-movement patch that puts the code #ifdefed out above
> 	under existing #ifdefs in kernel/rcutree_plugin.h.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
>   							Thanx, Paul
> 
> ------------------>
> 
> Paul E. McKenney (1):
>       rcu: Simplify curing of load woes
> 
> Shaohua Li (1):
>       rcu: Use softirq to address performance regression
> 
>  Documentation/filesystems/proc.txt  |    1 +
>  include/linux/interrupt.h           |    1 +
>  include/trace/events/irq.h          |    3 +-
>  kernel/rcutree.c                    |   88 ++++++++++++++++-------------------
>  kernel/rcutree.h                    |    1 +
>  kernel/rcutree_plugin.h             |   20 ++++----
>  kernel/softirq.c                    |    2 +-
>  tools/perf/util/trace-event-parse.c |    1 +
>  8 files changed, 57 insertions(+), 60 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
