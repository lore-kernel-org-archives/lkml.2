Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1LRLo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 06:44:26 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56426 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1LRLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 06:44:24 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Sisir Koppaka <sisir.koppaka@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Simplify task_group_is_autogroup
In-Reply-To: <CAJd0RV=NdYFY8sLnB5EQY9wiWm+0U0C3EaCmKE8jpunHdYkcAA@mail.gmail.com>
References: <CAJd0RV=NdYFY8sLnB5EQY9wiWm+0U0C3EaCmKE8jpunHdYkcAA@mail.gmail.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Sun, 18 Dec 2011 17:15:31 +0530
Message-ID: <8762heumqs.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121811-2674-0000-0000-000002AC7EF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Dec 2011 15:42:53 +0530, Sisir Koppaka <sisir.koppaka@gmail.com> wrote:
> Removing the !! in task_group_is_autogroup doesn't impede functionality.
> 
> Tested with and without CONFIG_SCHED_AUTOGROUP.
> 
> Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
> ---
>  kernel/sched/auto_group.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/auto_group.h b/kernel/sched/auto_group.h
> index 8bd0471..f628798 100644
> --- a/kernel/sched/auto_group.h
> +++ b/kernel/sched/auto_group.h
> @@ -21,7 +21,7 @@ extern void autogroup_free(struct task_group *tg);
> 
>  static inline bool task_group_is_autogroup(struct task_group *tg)
>  {
> -	return !!tg->autogroup;
> +	return tg->autogroup;
>
The return is supposed to be a boolean. So the code is correct.

Regards,
Nikunj

