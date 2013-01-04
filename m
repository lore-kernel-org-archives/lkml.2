Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab3ADSeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:34:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52646 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3ADSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:34:10 -0500
Date: Fri, 4 Jan 2013 10:33:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: comment: correct 'optimized' to 'optimize'.
Message-ID: <20130104183353.GB19783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1357322381-9573-1-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357322381-9573-1-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010418-2876-0000-0000-000003CBD240
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 12:59:40PM -0500, Cody P Schafer wrote:
> Small gramar fix in rcutree comment regarding 'rcu_scheduler_active'
> var.

Queued, thank you!  I could not resist fixing a small nit in the commit
log as well.  ;-)

							Thanx, Paul

> ---
>  kernel/rcutree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e441b77..bfb8972 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -105,7 +105,7 @@ int rcu_num_nodes __read_mostly = NUM_RCU_NODES; /* Total # rcu_nodes in use. */
>   * The rcu_scheduler_active variable transitions from zero to one just
>   * before the first task is spawned.  So when this variable is zero, RCU
>   * can assume that there is but one task, allowing RCU to (for example)
> - * optimized synchronize_sched() to a simple barrier().  When this variable
> + * optimize synchronize_sched() to a simple barrier().  When this variable
>   * is one, RCU must actually do all the hard work required to detect real
>   * grace periods.  This variable is also used to suppress boot-time false
>   * positives from lockdep-RCU error checking.
> -- 
> 1.8.0.3
> 

