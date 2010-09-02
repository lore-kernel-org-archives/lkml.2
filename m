Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0IBG6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:58:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58414 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0IBG6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:58:44 -0400
Date: Thu, 2 Sep 2010 08:58:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/urgent] make setpgid() system call use RCU
 read-side critical section
Message-ID: <20100902065831.GC29972@elte.hu>
References: <20100901203730.GA23152@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901203730.GA23152@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This pull request fixes an RCU lockdep splat noticed by Andrew Morton.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
> 							Thanx, Paul
> 
> ------------------>
> Paul E. McKenney (1):
>       pid: make setpgid() system call use RCU read-side critical section
> 
>  kernel/sys.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Pulled, thanks a lot Paul!

	Ingo
