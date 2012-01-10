Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2AJI7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:59:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab2AJI7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:59:52 -0500
Date: Tue, 10 Jan 2012 09:59:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 0/3] Additional RCU commits for 3.3
Message-ID: <20120110085911.GA5405@elte.hu>
References: <20120109221457.GA28184@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109221457.GA28184@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> Further -next and other testing uncovered one upcoming change and some
> build warnings.  The three commits below address these.  I am putting
> them forward for 3.3, but of course if the risk of change exceeds the
> magnitude of the problems, I can keep them queued for 3.4.  These are
> all quite small, have been exposed to -next testing, and I retested them
> against current tip/master.
> 
> The specific changes are as follows:
> 
> 1.	Change rcutorture's module parameters of type int to instead
> 	be bool.  This is in preparation for Rusty's patch that makes
> 	type-int module parameters illegal.  (Courtesy of Rusty Russell.)
> 
> 2.	Add "const" to the new is_idle_task()'s argument, which
> 	addresses a build warning located by Stephen Rothwell.
> 
> 3.	Add __cpuinit to rcu_torture_onoff() to address a section
> 	mismatch build warning.  (Courtesy of Heiko Carstens.)
> 
> These changes are based off of 3.2-rc7 and are available in the git
> repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent
> 
> 							Thanx, Paul
> 
> ------------------>
> 
> Heiko Carstens (1):
>       rcu: Add missing __cpuinit annotation in rcutorture code
> 
> Paul E. McKenney (1):
>       sched: Add "const" to is_idle_task() parameter
> 
> Rusty Russell (1):
>       rcu: Make rcutorture bool parameters really bool (core code)
> 
>  include/linux/sched.h |    2 +-
>  kernel/rcutorture.c   |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)

Pulled them into tip:core/urgent, thanks Paul!

Thanks,

	Ingo
