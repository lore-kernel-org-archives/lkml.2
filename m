Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1JLHr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:47:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34536 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1JLHr0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:47:26 -0400
Subject: Re: [PATCH 1/1] sched_fair: Fix a typo in the comment describing
 update_sd_lb_stats
From: Peter Zijlstra <peterz@infradead.org>
To: hkang.sunysb@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 09:47:21 +0200
In-Reply-To: <1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com>
References: <hkang.sunysb>
	 <1318388459-4427-1-git-send-email-hkang.sunysb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318405641.3968.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 23:00 -0400, hkang.sunysb@gmail.com wrote:
> From: Hui Kang <hkang.sunysb@gmail.com>
> 
> 
> Signed-off-by: Hui Kang <hkang.sunysb@gmail.com>
> ---
>  kernel/sched_fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index bc8ee99..6d49c82 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2854,7 +2854,7 @@ static bool update_sd_pick_busiest(struct sched_domain *sd,
>  }
>  
>  /**
> - * update_sd_lb_stats - Update sched_group's statistics for load balancing.
> + * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
>   * @sd: sched_domain whose statistics are to be updated.
>   * @this_cpu: Cpu for which load balance is currently performed.
>   * @idle: Idle status of this_cpu

Thanks!
