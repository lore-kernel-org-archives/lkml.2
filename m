Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2LTKFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:05:49 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:49424 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2LTKFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:05:41 -0500
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 05:05:41 EST
MIME-Version: 1.0
In-Reply-To: <1355871705-19720-1-git-send-email-sboyd@codeaurora.org>
References: <1355871705-19720-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 20 Dec 2012 17:40:15 +0800
Message-ID: <CAA_GA1fDv4OP+7sZ-Hxr0Zyb_gGe3Xpn7DvkokMAG2u4AByScQ@mail.gmail.com>
Subject: Re: [PATCH/TRIVIAL] blackfin: time-ts: Remove duplicate assignment
From: Bob Liu <lliubbo@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-msm@vger.kernel.org, Steven Miao <realmz6@gmail.com>,
        trivial@kernel.org, jj@chaosbits.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 7:01 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> It seems that this assignment is done twice in a row. Remove the
> duplicate assignment.
>

That's right.
Will be applied, thanks.

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Steven Miao <realmz6@gmail.com>
> Cc: trivial@kernel.org
> ---
>
> Noticed while grepping for broadcast users.
>
>  arch/blackfin/kernel/time-ts.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
> index f608f02..cb0a484 100644
> --- a/arch/blackfin/kernel/time-ts.c
> +++ b/arch/blackfin/kernel/time-ts.c
> @@ -329,12 +329,6 @@ void bfin_coretmr_clockevent_init(void)
>         evt->broadcast = smp_timer_broadcast;
>  #endif
>
> -
> -#ifdef CONFIG_SMP
> -       evt->broadcast = smp_timer_broadcast;
> -#endif
> -
> -
>         evt->name = "bfin_core_timer";
>         evt->rating = 350;
>         evt->irq = -1;
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>

-- 
Regards,
--Bob
