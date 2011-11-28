Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1K1QEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:04:14 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:34807 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1QEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:04:12 -0500
Date: Mon, 28 Nov 2011 18:04:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@nokia.com>
Subject: Re: [trivial PATCH] omap24xxcam-dma: Fix logical test
Message-ID: <20111128160409.GF29805@valkosipuli.localdomain>
References: <1322422935.27199.3.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322422935.27199.3.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 11:42:15AM -0800, Joe Perches wrote:
> Likely misuse of & vs &&.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, Joe!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> ---
>  drivers/media/video/omap24xxcam-dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap24xxcam-dma.c b/drivers/media/video/omap24xxcam-dma.c
> index 1d54b86..3ea38a8 100644
> --- a/drivers/media/video/omap24xxcam-dma.c
> +++ b/drivers/media/video/omap24xxcam-dma.c
> @@ -506,7 +506,7 @@ int omap24xxcam_sgdma_queue(struct omap24xxcam_sgdma *sgdma,
>  	unsigned long flags;
>  	struct sgdma_state *sg_state;
>  
> -	if ((sglen < 0) || ((sglen > 0) & !sglist))
> +	if ((sglen < 0) || ((sglen > 0) && !sglist))
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&sgdma->lock, flags);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
