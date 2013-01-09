Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3AIIi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:38:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43695 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3AIIi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:38:28 -0500
Date: Wed, 9 Jan 2013 09:38:23 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, p.zabel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] staging: imx-drm: ipu-common: Remove unused variable
Message-ID: <20130109083823.GP1906@pengutronix.de>
References: <1357698722-7187-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357698722-7187-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:38:04 up 199 days, 23:49, 51 users,  load average: 0.26, 0.64,
 1.69
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 12:32:02AM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Fix the following warning when building with W=1 option:
> 
> drivers/staging/imx-drm/ipu-v3/ipu-common.c: In function 'ipu_remove':
> drivers/staging/imx-drm/ipu-v3/ipu-common.c:1145:19: warning: variable 'res' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/ipu-v3/ipu-common.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> index f7059cd..366f259 100644
> --- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> +++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
> @@ -1142,9 +1142,6 @@ failed_ioremap:
>  static int ipu_remove(struct platform_device *pdev)
>  {
>  	struct ipu_soc *ipu = platform_get_drvdata(pdev);
> -	struct resource *res;
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  
>  	platform_device_unregister_children(pdev);
>  	ipu_submodules_exit(ipu);
> -- 
> 1.7.9.5
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
