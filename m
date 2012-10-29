Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948Ab2J2VAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:00:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46914 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596Ab2J2VAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:00:15 -0400
Date: Mon, 29 Oct 2012 22:00:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: a.zummo@towertech.it, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] rtc-imxdi: Support for i.MX53
Message-ID: <20121029210007.GU1641@pengutronix.de>
References: <1350576370-29098-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350576370-29098-1-git-send-email-stigge@antcom.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:59:40 up 128 days, 12:11, 39 users,  load average: 0.54, 0.52,
 0.43
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 06:06:08PM +0200, Roland Stigge wrote:
> This patch enables support for i.MX53 in addition to i.MX25 by enabling the
> driver on ARCH_MXC generally.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/rtc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/drivers/rtc/Kconfig
> +++ linux-2.6/drivers/rtc/Kconfig
> @@ -768,7 +768,7 @@ config RTC_DRV_DAVINCI
>  
>  config RTC_DRV_IMXDI
>  	tristate "Freescale IMX DryIce Real Time Clock"
> -	depends on SOC_IMX25
> +	depends on ARCH_MXC
>  	help
>  	   Support for Freescale IMX DryIce RTC
>  
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
