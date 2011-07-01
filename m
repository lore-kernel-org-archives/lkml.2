Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1GAIIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:08:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49131 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1GAIIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:08:42 -0400
Date: Fri, 1 Jul 2011 10:08:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM i.MX23/28: platform-mxsfb: Add missing include of
 linux/dma-mapping.h
Message-ID: <20110701080838.GU6069@pengutronix.de>
References: <1309440903.22791.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309440903.22791.1.camel@phoenix>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:08:26 up 9 days, 13:55, 31 users,  load average: 0.73, 0.44, 0.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 09:35:03PM +0800, Axel Lin wrote:
> Fix below build error:
>   CC      arch/arm/mach-mxs/devices/platform-mxsfb.o
> arch/arm/mach-mxs/devices/platform-mxsfb.c: In function 'mx23_add_mxsfb':
> arch/arm/mach-mxs/devices/platform-mxsfb.c:27: error: implicit declaration of function 'DMA_BIT_MASK'
> make[2]: *** [arch/arm/mach-mxs/devices/platform-mxsfb.o] Error 1
> make[1]: *** [arch/arm/mach-mxs/devices] Error 2
> make: *** [arch/arm/mach-mxs] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied for next

Sascha

> ---
>  arch/arm/mach-mxs/devices/platform-mxsfb.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/devices/platform-mxsfb.c b/arch/arm/mach-mxs/devices/platform-mxsfb.c
> index bf72c9b..5a75b71 100644
> --- a/arch/arm/mach-mxs/devices/platform-mxsfb.c
> +++ b/arch/arm/mach-mxs/devices/platform-mxsfb.c
> @@ -5,6 +5,7 @@
>   * the terms of the GNU General Public License version 2 as published by the
>   * Free Software Foundation.
>   */
> +#include <linux/dma-mapping.h>
>  #include <asm/sizes.h>
>  #include <mach/mx23.h>
>  #include <mach/mx28.h>
> -- 
> 1.7.4.1
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
