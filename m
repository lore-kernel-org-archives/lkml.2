Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab2CIP7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:38 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36519 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913Ab2CIP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:35 -0500
Date: Thu, 8 Mar 2012 11:03:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 1/6] remove unused srcu_barrier()
Message-ID: <20120308190311.GK2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-7182-0000-0000-0000010115B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 05:57:33PM +0800, Lai Jiangshan wrote:
> srcu_barrier() is unused now.
> This identifier is need for later.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Queued, thank you!

							Thanx, Paul

> ---
>  include/linux/srcu.h |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index 5b49d41..df8f5f7 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -49,12 +49,6 @@ struct srcu_struct {
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  };
> 
> -#ifndef CONFIG_PREEMPT
> -#define srcu_barrier() barrier()
> -#else /* #ifndef CONFIG_PREEMPT */
> -#define srcu_barrier()
> -#endif /* #else #ifndef CONFIG_PREEMPT */
> -
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> 
>  int __init_srcu_struct(struct srcu_struct *sp, const char *name,
> -- 
> 1.7.4.4
> 

