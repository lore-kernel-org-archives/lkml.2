Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2FSJB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:01:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62063 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FSJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:01:55 -0400
Date: Tue, 19 Jun 2012 17:01:11 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, a.p.zijlstra@chello.nl,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v2 5/5] sched: cpu_power: enable ARCH_POWER
Message-ID: <20120619090110.GA1692@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
 <1340094536-20873-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340094536-20873-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:28:56AM +0200, Vincent Guittot wrote:
> Heteregeneous ARM platform uses arch_scale_freq_power function
> to reflect the relative capacity of each core
> 
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

Hmmm...seems we can remove this knob completely.

__weak arch_scale_smt_power() is doing all the trick.

Thanks,
Yong
