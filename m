Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2FMMua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:50:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FMMu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:50:28 -0400
Message-ID: <1339591819.8980.28.camel@twins>
Subject: Re: [RFC 4/4] sched: cpu_power: enable ARCH_POWER
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Date: Wed, 13 Jun 2012 14:50:19 +0200
In-Reply-To: <1339502524-10265-5-git-send-email-vincent.guittot@linaro.org>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-5-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> Heteregeneous ARM platform uses arch_scale_freq_power function
> to reflect the relative capacity of each core

I think I've pointed out before that this breaks x86.. you need a patch
killing at that stuff before this.

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/features.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/features.h b/kernel/sched/features.h
> index de00a48..d98ae90 100644
> --- a/kernel/sched/features.h
> +++ b/kernel/sched/features.h
> @@ -42,7 +42,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
>  /*
>   * Use arch dependent cpu power functions
>   */
> -SCHED_FEAT(ARCH_POWER, false)
> +SCHED_FEAT(ARCH_POWER, true)
>  
>  SCHED_FEAT(HRTICK, false)
>  SCHED_FEAT(DOUBLE_TICK, false)

