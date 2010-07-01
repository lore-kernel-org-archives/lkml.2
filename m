Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0GAIsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:48:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47146 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0GAIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:48:39 -0400
Date: Thu, 1 Jul 2010 10:48:28 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
       Russell King <linux@arm.linux.org.uk>,
       Amit Kucheria <amit.kucheria@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 14/33] Removing dead SDMA_IRAM
Message-ID: <20100701084828.GE12115@pengutronix.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <3dc9983ca244c19f18da8951444e1cc9fae0226f.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dc9983ca244c19f18da8951444e1cc9fae0226f.1277911346.git.siccegge@cs.fau.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:48:09 up 24 days,  1:16, 34 users,  load average: 0.61, 1.20,
	1.28
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 05:58:25PM +0200, Christoph Egger wrote:
> SDMA_IRAM doesn't exist in Kconfig, therefore removing all references
> for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  arch/arm/plat-mxc/include/mach/mx51.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/mx51.h b/arch/arm/plat-mxc/include/mach/mx51.h
> index 5aad344..fd5ec07 100644
> --- a/arch/arm/plat-mxc/include/mach/mx51.h
> +++ b/arch/arm/plat-mxc/include/mach/mx51.h
> @@ -149,11 +149,7 @@
>  #define MX51_MXC_DMA_CHANNEL_SSI1_RX	MXC_DMA_DYNAMIC_CHANNEL
>  #define MX51_MXC_DMA_CHANNEL_SSI1_TX	MXC_DMA_DYNAMIC_CHANNEL
>  #define MX51_MXC_DMA_CHANNEL_SSI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> -#ifdef CONFIG_SDMA_IRAM
> -#define MX51_MXC_DMA_CHANNEL_SSI2_TX	(MX51_MXC_DMA_CHANNEL_IRAM + 1)
> -#else				/*CONFIG_SDMA_IRAM */
>  #define MX51_MXC_DMA_CHANNEL_SSI2_TX	MXC_DMA_DYNAMIC_CHANNEL
> -#endif				/*CONFIG_SDMA_IRAM */
>  #define MX51_MXC_DMA_CHANNEL_CSPI1_RX	MXC_DMA_DYNAMIC_CHANNEL
>  #define MX51_MXC_DMA_CHANNEL_CSPI1_TX	MXC_DMA_DYNAMIC_CHANNEL
>  #define MX51_MXC_DMA_CHANNEL_CSPI2_RX	MXC_DMA_DYNAMIC_CHANNEL
> -- 
> 1.7.0.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
