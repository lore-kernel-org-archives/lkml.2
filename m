Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab0EDGpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:45:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab0EDGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:45:22 -0400
Date: Tue, 4 May 2010 08:45:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] RCU fixes for 2.6.34
Message-ID: <20100504064511.GC10464@elte.hu>
References: <20100504033616.GA6155@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504033616.GA6155@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> Here are RCU fixes for 2.6.34, mainly RCU-lockdep fixes:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git urgent-to-mingo
> 
> This set excludes the three needing Acked-by, and also excludes the
> commits targeted for 2.6.35.
> 
> 							Thanx, Paul
> 
> ------------------>
> David Howells (2)
>     KEYS: Fix an RCU warning in the reading of user keys
>     KEYS: Fix an RCU warning
> 
> Lai Jiangshan (1)
>     rcu: v2: optionally leave lockdep enabled after RCU lockdep splat
> 
> Li Zefan (4)
>     cgroup: Check task_lock in task_subsys_state()
>     sched: Fix an RCU warning in print_task()
>     cgroup: Fix an RCU warning in alloc_css_id()
>     cgroup: Fix an RCU warning in cgroup_path()
> 
>  include/linux/cgroup.h       |    1 +
>  include/linux/rcupdate.h     |   15 +++++++++++----
>  kernel/cgroup.c              |   16 +++++++++++-----
>  kernel/lockdep.c             |    2 ++
>  kernel/sched_debug.c         |    2 ++
>  lib/Kconfig.debug            |   12 ++++++++++++
>  security/keys/request_key.c  |   13 ++++++++-----
>  security/keys/user_defined.c |    3 ++-
>  8 files changed, 49 insertions(+), 15 deletions(-)

Pulled, thanks a lot Paul!!

	Ingo
