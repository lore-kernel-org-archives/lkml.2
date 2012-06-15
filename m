Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2FOUVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:21:21 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58828 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2FOUVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:21:20 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:21:03 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 2/6] rcu: Rationalize ordering of
 torture_ops list
Message-ID: <20120615202103.GB31184@leaf>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339786674-25265-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339786674-25265-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:57:50AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Move the raw SRCU interfaces out of the middle of the normal SRCU
> interfaces.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutorture.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index e66b34a..9850479 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -1908,8 +1908,8 @@ rcu_torture_init(void)
>  	static struct rcu_torture_ops *torture_ops[] =
>  		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
>  		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
> -		  &srcu_ops, &srcu_sync_ops, &srcu_raw_ops,
> -		  &srcu_raw_sync_ops, &srcu_expedited_ops,
> +		  &srcu_ops, &srcu_sync_ops, &srcu_expedited_ops,
> +		  &srcu_raw_ops, &srcu_raw_sync_ops,
>  		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
>  
>  	mutex_lock(&fullstop_mutex);
> -- 
> 1.7.8
> 
