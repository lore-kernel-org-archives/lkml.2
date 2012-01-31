Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2AaKjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:39:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48181 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab2AaKjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:39:23 -0500
MIME-Version: 1.0
In-Reply-To: <1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
References: <1328006193-13902-1-git-send-email-k.lewandowsk@samsung.com>
	<1328006193-13902-3-git-send-email-k.lewandowsk@samsung.com>
Date: Tue, 31 Jan 2012 19:39:23 +0900
X-Google-Sender-Auth: f765UhHng6GTUGx_7-5NBIczTLg
Message-ID: <CAH9JG2VgaSHyTMHxD7xSgu+Ugez9tD3ucDH_XC_n2VDfH+hxfw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: Exynos4: Convert exynos4-dt to CONFIG_MULTI_IRQ_HANDLER
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-samsung-soc@vger.kernel.org, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

restart is also required.

On 1/31/12, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> Commit 4e44d2cb95bd ("ARM: exynos4: convert to CONFIG_MULTI_IRQ_HANDLER")
> converted all exynos boards but exynos4-dt.c.
>
> This commit fixes that omission.
>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/mach-exynos/mach-exynos4-dt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c
> b/arch/arm/mach-exynos/mach-exynos4-dt.c
> index 98e79c9..8aef6aa 100644
> --- a/arch/arm/mach-exynos/mach-exynos4-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
> @@ -15,6 +15,7 @@
>  #include <linux/serial_core.h>
>
>  #include <asm/mach/arch.h>
> +#include <asm/hardware/gic.h>
>  #include <mach/map.h>
>
>  #include <plat/cpu.h>
> @@ -83,4 +84,5 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4
> (Flattened Device Tree)")
>  	.init_machine	= exynos4210_dt_machine_init,
>  	.timer		= &exynos4_timer,
>  	.dt_compat	= exynos4210_dt_compat,
> +	.handle_irq	= gic_handle_irq,
>  MACHINE_END
> --
> 1.7.8.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
