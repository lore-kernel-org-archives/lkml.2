Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2E3Os0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:48:26 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:34625 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754201Ab2E3OsY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:48:24 -0400
MIME-Version: 1.0
In-Reply-To: <1338375394-16268-2-git-send-email-kishon@ti.com>
References: <1338375394-16268-1-git-send-email-kishon@ti.com> <1338375394-16268-2-git-send-email-kishon@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Wed, 30 May 2012 20:18:02 +0530
Message-ID: <CAMQu2gw___u=g0=EQ3Q0fVuzG1gZKAoMpt268_Npbp26sWPHaA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] arm: omap: hwmod: make *phy_48m* as the main_clk
 of ocp2scp
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 4:26 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp.
> Since this ocp2scp module does not have any fck but does have a
> single opt_clock, it is added as the main_clk for ocp2scp.
>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---


>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> index 950454a..249ff76 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -2508,6 +2508,7 @@ static struct omap_hwmod omap44xx_ocp2scp_usb_phy_hwmod = {
>        .name           = "ocp2scp_usb_phy",
>        .class          = &omap44xx_ocp2scp_hwmod_class,
>        .clkdm_name     = "l3_init_clkdm",
> +       .main_clk       = "ocp2scp_usb_phy_phy_48m",
>        .prcm = {
>                .omap4 = {
>                        .clkctrl_offs = OMAP4_CM_L3INIT_USBPHYOCP2SCP_CLKCTRL_OFFSET,
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Minor ..
$subject
s/arm: omap: / ARM: OMAP

An maintain this naming consistency since one of
the patch in the series uses capital where as others
not
