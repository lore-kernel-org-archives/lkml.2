Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab0EFUqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:46:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47612 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab0EFUqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:46:24 -0400
Date: Thu, 6 May 2010 22:44:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] One more additional RCU fix for 2.6.34
Message-ID: <20100506204412.GA7134@elte.hu>
References: <20100506202646.GA4903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506202646.GA4903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello again, Ingo,
> 
> Here is one more commit with the RCU infrastructure for an RCU-lockdep
> fix in vfs.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
> The actual fix in vfs will be sent to the vfs folks once the above commit
> hits mainline.  In the meantime, I am carrying the vfs commit in my -rcu
> tree as branch vfs.2010.05.06a.
> 
> 							Thanx, Paul
> 
> ------------------>
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> (1)
> 	rcu: create rcu_my_thread_group_empty() wrapper
> 
>  include/linux/rcupdate.h |    2 --
>  kernel/rcupdate.c        |   11 -----------
>  2 files changed, 13 deletions(-)

Pulled, thanks Paul!

	Ingo
