Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1FKFu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 01:50:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65269 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1FKFuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 01:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BGRD7dZogOQr9OeyxOoBXuTtW+m6+Og6B9TqbB94KIYduXYJ4RBcHURsFGANb4WLEk
         Aq0Oku5GFh5ytoTHoHThgXEV2vqw4w2LbiC0eY3Nt1Nr5wK5FtRbsiaHxrdkr+oHnI0b
         rD44v3hGjAH7rRj/UJpwgeUAc1GPKUKkUGBww=
Date: Sat, 11 Jun 2011 08:47:51 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
        vinod.koul@intel.com
Subject: Re: [PATCH] dma/ep93xx_dma.c: local symbols should be static
Message-ID: <20110611054751.GA2651@acer>
References: <201106101515.05990.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106101515.05990.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:15:05PM -0700, H Hartley Sweeten wrote:
> The symbol 'ep93xx_dma_prep_dma_memcpy' is only used in this driver
> and should be marked static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> 
> ---
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 0766c1e..5d7a49b 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -902,7 +902,7 @@ static void ep93xx_dma_free_chan_resources(struct dma_chan *chan)
>   *
>   * Returns a valid DMA descriptor or %NULL in case of failure.
>   */
> -struct dma_async_tx_descriptor *
> +static struct dma_async_tx_descriptor *
>  ep93xx_dma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest,
>  			   dma_addr_t src, size_t len, unsigned long flags)
>  {
