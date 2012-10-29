Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982Ab2J2VMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:12:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48743 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab2J2VMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:12:19 -0400
Date: Mon, 29 Oct 2012 22:12:13 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: wim@iguana.be, grant.likely@secretlab.ca, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] watchdog: Support imx watchdog on SOC_IMX53
Message-ID: <20121029211213.GY1641@pengutronix.de>
References: <1351164513-27999-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351164513-27999-1-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:11:58 up 128 days, 12:23, 39 users,  load average: 0.33, 0.33,
 0.38
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:28:33PM +0200, Roland Stigge wrote:
> This patch fixes watchdog support after devicetree switch for imx53
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied, thanks

Sascha

> 
> ---
>  arch/arm/mach-imx/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.orig/arch/arm/mach-imx/Kconfig
> +++ linux-2.6/arch/arm/mach-imx/Kconfig
> @@ -739,6 +739,7 @@ config	SOC_IMX53
>  	select ARCH_MX5
>  	select ARCH_MX53
>  	select HAVE_CAN_FLEXCAN if CAN
> +	select IMX_HAVE_PLATFORM_IMX2_WDT
>  	select PINCTRL
>  	select PINCTRL_IMX53
>  	select SOC_IMX5
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
