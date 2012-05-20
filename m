Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2ETPpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:45:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44836 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab2ETPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:45:05 -0400
Date: Sun, 20 May 2012 08:44:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
        a.p.zijlstra@chello.nl, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]ipc:fixed spacing issues in coding style.
Message-ID: <20120520154458.GG2895@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1337511673-3485-1-git-send-email-ahiliation@yahoo.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337511673-3485-1-git-send-email-ahiliation@yahoo.co.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052015-4242-0000-0000-000001B92E4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2012 at 04:31:13PM +0530, Jeffrin Jose wrote:
> Fixed spacing issues related to different operators
> like * and : found by checkpatch.pl tool in ipc/sem.c
> 
> Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

Looks good to me!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  ipc/sem.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 10386b8..9301595 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -964,7 +964,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
>  		up_read(&sem_ids(ns).rw_mutex);
>  		if (copy_to_user (arg.__buf, &seminfo, sizeof(struct seminfo))) 
>  			return -EFAULT;
> -		return (max_id < 0) ? 0: max_id;
> +		return (max_id < 0) ? 0 : max_id;
>  	}
>  	case IPC_STAT:
>  	case SEM_STAT:
> @@ -1372,7 +1372,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
>  	spin_lock(&ulp->lock);
>  	un = lookup_undo(ulp, semid);
>  	spin_unlock(&ulp->lock);
> -	if (likely(un!=NULL))
> +	if (likely(un != NULL))
>  		goto out;
>  	rcu_read_unlock();
> 
> @@ -1732,7 +1732,7 @@ void exit_sem(struct task_struct *tsk)
> 
>  		/* perform adjustments registered in un */
>  		for (i = 0; i < sma->sem_nsems; i++) {
> -			struct sem * semaphore = &sma->sem_base[i];
> +			struct sem *semaphore = &sma->sem_base[i];
>  			if (un->semadj[i]) {
>  				semaphore->semval += un->semadj[i];
>  				/*
> -- 
> 1.7.10
> 

