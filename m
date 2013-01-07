Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3AGMNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:13:42 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33141 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3AGMNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:13:40 -0500
MIME-Version: 1.0
In-Reply-To: <1356694851-1345-1-git-send-email-ch.naveen@samsung.com>
References: <1356694851-1345-1-git-send-email-ch.naveen@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Mon, 7 Jan 2013 17:36:17 +0530
Message-ID: <CAHfPSqCgYz8r05gBxOwCbi3a4_R0Kaatps8aOEmp_Ck=fakoFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: exynos5: Add gate clocks for HS-I2C
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 December 2012 17:10, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> Adds clock gating bits for High Speed I2C channels 0, 1, 2 and 3.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  arch/arm/mach-exynos/clock-exynos5.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
> index 0208c3a..f9fa0c7 100644
> --- a/arch/arm/mach-exynos/clock-exynos5.c
> +++ b/arch/arm/mach-exynos/clock-exynos5.c
> @@ -753,6 +753,30 @@ static struct clk exynos5_init_clocks_off[] = {
>                 .enable         = exynos5_clk_ip_peric_ctrl,
>                 .ctrlbit        = (1 << 27),
>         }, {
> +               .name           = "hsi2c",
> +               .devname        = "exynos5-hsi2c.0",
> +               .enable         = exynos5_clk_ip_peric_ctrl,
> +               .parent         = &exynos5_clk_aclk_66.clk,
> +               .ctrlbit        = (1 << 28),
> +       }, {
> +               .name           = "hsi2c",
> +               .devname        = "exynos5-hsi2c.1",
> +               .enable         = exynos5_clk_ip_peric_ctrl,
> +               .parent         = &exynos5_clk_aclk_66.clk,
> +               .ctrlbit        = (1 << 29),
> +       }, {
> +               .name           = "hsi2c",
> +               .devname        = "exynos5-hsi2c.2",
> +               .enable         = exynos5_clk_ip_peric_ctrl,
> +               .parent         = &exynos5_clk_aclk_66.clk,
> +               .ctrlbit        = (1 << 30),
> +       }, {
> +               .name           = "hsi2c",
> +               .devname        = "exynos5-hsi2c.3",
> +               .enable         = exynos5_clk_ip_peric_ctrl,
> +               .parent         = &exynos5_clk_aclk_66.clk,
> +               .ctrlbit        = (1 << 31),
> +       }, {
>                 .name           = "usbhost",
>                 .enable         = exynos5_clk_ip_fsys_ctrl ,
>                 .ctrlbit        = (1 << 18),
> --
> 1.7.9.5

Any comments on this patch please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
