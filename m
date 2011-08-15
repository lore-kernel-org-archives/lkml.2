Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1HOPvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:51:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40911 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1HOPvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:51:03 -0400
Date: Mon, 15 Aug 2011 08:51:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10]include:linux Remove pointless "@" from various
 parts of the kernel
Message-ID: <20110815155101.GJ2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
 <1313195235-4522-10-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313195235-4522-10-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 05:27:15PM -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The patch series below removes some pointless "@"'s in various parts of the kernel.
> Note: some might be useful, but then again, some just seemed a waste of space.
> (and since the kernel is become bloated, might as well diet! even if it's a few bits)

I would like to keep the RCU "@@@", please!

							Thanx, Paul

> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  include/linux/jbd.h      |    2 +-
>  include/linux/jbd2.h     |    2 +-
>  include/linux/rcupdate.h |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index e6a5e34..7f3b109 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -273,7 +273,7 @@ typedef struct journal_superblock_s
>  enum jbd_state_bits {
>  	BH_JBD			/* Has an attached ext3 journal_head */
>  	  = BH_PrivateStart,
> -	BH_JWrite,		/* Being written to log (@@@ DEBUGGING) */
> +	BH_JWrite,		/* Being written to log DEBUGGING */
>  	BH_Freed,		/* Has been freed (truncated) */
>  	BH_Revoked,		/* Has been revoked from the log */
>  	BH_RevokeValid,		/* Revoked flag is valid */
> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> index 38f307b..4a7ad4b 100644
> --- a/include/linux/jbd2.h
> +++ b/include/linux/jbd2.h
> @@ -305,7 +305,7 @@ typedef struct journal_superblock_s
>  enum jbd_state_bits {
>  	BH_JBD			/* Has an attached ext3 journal_head */
>  	  = BH_PrivateStart,
> -	BH_JWrite,		/* Being written to log (@@@ DEBUGGING) */
> +	BH_JWrite,		/* Being written to log DEBUGGING */
>  	BH_Freed,		/* Has been freed (truncated) */
>  	BH_Revoked,		/* Has been revoked from the log */
>  	BH_RevokeValid,		/* Revoked flag is valid */
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 8f4f881..cfb5d7b 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -443,7 +443,7 @@ extern int rcu_my_thread_group_empty(void);
>  	__rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
>  				__rcu)
> 
> -#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
> +#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /* needed? */
> 
>  /**
>   * rcu_access_index() - fetch RCU index with no dereferencing
> -- 
> 1.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
