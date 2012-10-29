Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2J2JtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:49:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45948 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2J2JtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:49:10 -0400
Date: Mon, 29 Oct 2012 02:49:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com, fengguang.wu@intel.com
Subject: Re: [PATCH] rcu: Fix the code style issue in rcutree_trace_init()
Message-ID: <20121029094903.GB3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1351479733-6978-1-git-send-email-wangyun@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351479733-6978-1-git-send-email-wangyun@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102909-7408-0000-0000-000009B9FB65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:02:13AM +0800, Michael Wang wrote:
> This patch fix the code style issue caused by:
> 
> 	commit 622afdb3bd6288837a37bac137dfeff4e771798d
> 	"rcu: Optimize the 'rcudata' for RCU trace"

Queued, thank you Michael.

							Thanx, Paul

> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  kernel/rcutree_trace.c |   60 ++++++++++++++++++++++++------------------------
>  1 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 73abfb0..e84679c 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -436,44 +436,44 @@ static int __init rcutree_trace_init(void)
>  		if (!rspdir)
>  			goto free_out;
> 
> -			retval = debugfs_create_file("rcudata", 0444,
> -					rspdir, rsp, &rcudata_fops);
> -			if (!retval)
> -				goto free_out;
> +		retval = debugfs_create_file("rcudata", 0444,
> +				rspdir, rsp, &rcudata_fops);
> +		if (!retval)
> +			goto free_out;
> 
> -			retval = debugfs_create_file("rcuexp", 0444,
> -					rspdir, rsp, &rcuexp_fops);
> -			if (!retval)
> -				goto free_out;
> +		retval = debugfs_create_file("rcuexp", 0444,
> +				rspdir, rsp, &rcuexp_fops);
> +		if (!retval)
> +			goto free_out;
> 
> -			retval = debugfs_create_file("rcu_pending", 0444,
> -					rspdir, rsp, &rcu_pending_fops);
> -			if (!retval)
> -				goto free_out;
> +		retval = debugfs_create_file("rcu_pending", 0444,
> +				rspdir, rsp, &rcu_pending_fops);
> +		if (!retval)
> +			goto free_out;
> 
> -			retval = debugfs_create_file("rcubarrier", 0444,
> -					rspdir, rsp, &rcubarrier_fops);
> -			if (!retval)
> -				goto free_out;
> +		retval = debugfs_create_file("rcubarrier", 0444,
> +				rspdir, rsp, &rcubarrier_fops);
> +		if (!retval)
> +			goto free_out;
> 
>  #ifdef CONFIG_RCU_BOOST
> -			if (rsp == &rcu_preempt_state) {
> -				retval = debugfs_create_file("rcuboost", 0444,
> -					rspdir, NULL, &rcu_node_boost_fops);
> -				if (!retval)
> -					goto free_out;
> -			}
> -#endif
> -
> -			retval = debugfs_create_file("rcugp", 0444,
> -					rspdir, rsp, &rcugp_fops);
> +		if (rsp == &rcu_preempt_state) {
> +			retval = debugfs_create_file("rcuboost", 0444,
> +				rspdir, NULL, &rcu_node_boost_fops);
>  			if (!retval)
>  				goto free_out;
> +		}
> +#endif
> 
> -			retval = debugfs_create_file("rcuhier", 0444,
> -					rspdir, rsp, &rcuhier_fops);
> -			if (!retval)
> -				goto free_out;
> +		retval = debugfs_create_file("rcugp", 0444,
> +				rspdir, rsp, &rcugp_fops);
> +		if (!retval)
> +			goto free_out;
> +
> +		retval = debugfs_create_file("rcuhier", 0444,
> +				rspdir, rsp, &rcuhier_fops);
> +		if (!retval)
> +			goto free_out;
>  	}
> 
>  	retval = debugfs_create_file("rcutorture", 0444, rcudir,
> -- 
> 1.7.4.1
> 

