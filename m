Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2B0JYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:24:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51209 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2B0JYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:24:32 -0500
Date: Mon, 27 Feb 2012 10:24:21 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH][trivial] ARM: Remove redundant ';' from
 avic_irq_set_priority()
Message-ID: <20120227092421.GX3852@pengutronix.de>
References: <alpine.LNX.2.00.1202262307210.6089@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202262307210.6089@swampdragon.chaosbits.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:24:07 up 106 days, 17:11, 16 users,  load average: 0.02, 0.05,
 0.13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 11:09:40PM +0100, Jesper Juhl wrote:
> One semi-colon at the end of the return statement is sufficient.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied

Sascha

> ---
>  arch/arm/plat-mxc/avic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/plat-mxc/avic.c b/arch/arm/plat-mxc/avic.c
> index 55f1569..689f81f 100644
> --- a/arch/arm/plat-mxc/avic.c
> +++ b/arch/arm/plat-mxc/avic.c
> @@ -60,7 +60,7 @@ static int avic_irq_set_priority(unsigned char irq, unsigned char prio)
>  	unsigned int mask = 0x0F << irq % 8 * 4;
>  
>  	if (irq >= AVIC_NUM_IRQS)
> -		return -EINVAL;;
> +		return -EINVAL;
>  
>  	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
>  	temp &= ~mask;
> -- 
> 1.7.9.2
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
