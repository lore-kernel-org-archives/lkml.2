Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2LNRf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:35:29 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46232 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2LNRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:35:27 -0500
MIME-Version: 1.0
In-Reply-To: <1355501608-2955-1-git-send-email-tobetter@gmail.com>
References: <1355501608-2955-1-git-send-email-tobetter@gmail.com>
Date: Fri, 14 Dec 2012 23:05:26 +0530
Message-ID: <CAJuYYwS-+x9=V5z+POGYCHL8TkUDjrRB663Mys6ppCBXRASxFQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Fix MSHC clocks instance names
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Dongjin Kim <tobetter@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2012 21:43, Dongjin Kim <tobetter@gmail.com> wrote:
> Replace clock instance name of MSHC controller for BIC and CIU of Exynos4412.
>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  arch/arm/mach-exynos/clock-exynos4.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-exynos/clock-exynos4.c
> index efead60..bbcb3de 100644
> --- a/arch/arm/mach-exynos/clock-exynos4.c
> +++ b/arch/arm/mach-exynos/clock-exynos4.c
> @@ -529,7 +529,7 @@ static struct clk exynos4_init_clocks_off[] = {
>                 .enable         = exynos4_clk_ip_fsys_ctrl,
>                 .ctrlbit        = (1 << 8),
>         }, {
> -               .name           = "dwmmc",
> +               .name           = "biu",
>                 .parent         = &exynos4_clk_aclk_133.clk,
>                 .enable         = exynos4_clk_ip_fsys_ctrl,
>                 .ctrlbit        = (1 << 9),
> @@ -1134,7 +1134,7 @@ static struct clksrc_clk exynos4_clksrcs[] = {
>                 .reg_div = { .reg = EXYNOS4_CLKDIV_MFC, .shift = 0, .size = 4 },
>         }, {
>                 .clk    = {
> -                       .name           = "sclk_dwmmc",
> +                       .name           = "ciu",
>                         .parent         = &exynos4_clk_dout_mmc4.clk,
>                         .enable         = exynos4_clksrc_mask_fsys_ctrl,
>                         .ctrlbit        = (1 << 16),
> --

Acked-by: Thomas Abraham <thomas.abraham@linaro.org>

> 1.7.9.5



>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
