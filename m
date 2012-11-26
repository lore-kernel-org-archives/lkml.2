Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2KZIrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 03:47:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50016 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2KZIrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 03:47:04 -0500
Date: Mon, 26 Nov 2012 09:46:57 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/24] MAINTAINERS: fix .../plat-mxc/include/mach/imxfb.h
Message-ID: <20121126084657.GY10369@pengutronix.de>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-12-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353716808-16375-12-git-send-email-cesarb@cesarb.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:46:40 up 155 days, 23:58, 33 users,  load average: 0.29, 1.10,
 1.58
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 10:26:35PM -0200, Cesar Eduardo Barros wrote:
> This file was moved to include/linux/platform_data/video-imxfb.h by
> commit 82906b1 (ARM: imx: move platform_data definitions).
> 
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-fbdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a67a67a..887d717 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3137,7 +3137,7 @@ M:	Sascha Hauer <kernel@pengutronix.de>
>  L:	linux-fbdev@vger.kernel.org
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
> -F:	arch/arm/plat-mxc/include/mach/imxfb.h
> +F:	include/linux/platform_data/video-imxfb.h
>  F:	drivers/video/imxfb.c
>  
>  FREESCALE SOC FS_ENET DRIVER
> -- 
> 1.7.11.7
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
