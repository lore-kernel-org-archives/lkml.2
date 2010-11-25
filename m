Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0KYJDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:03:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55413 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0KYJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:03:20 -0500
Date: Thu, 25 Nov 2010 10:03:11 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 4/4] [ARM] mxcmmc: remove a unnecessary
	release_resource() call
Message-ID: <20101125090311.GP6017@pengutronix.de>
References: <1290415359.5471.4.camel@mola> <1290415467.5471.7.camel@mola> <1290415534.5471.8.camel@mola> <1290415596.5471.10.camel@mola> <1290415671.5471.13.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290415671.5471.13.camel@mola>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:02:58 up 145 days, 13 min, 59 users,  load average: 0.29,
	0.24, 0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 04:47:51PM +0800, Axel Lin wrote:
> Remove release_resource() after release_mem_region().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/mmc/host/mxcmmc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 2b9f7c8..4428594 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -967,7 +967,6 @@ static int mxcmci_remove(struct platform_device *pdev)
>  	clk_put(host->clk);
>  
>  	release_mem_region(host->res->start, resource_size(host->res));
> -	release_resource(host->res);
>  
>  	mmc_free_host(mmc);
>  
> -- 
> 1.7.2
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
