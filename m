Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0DPKBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:01:32 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51637 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0DPKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:01:31 -0400
Date: Fri, 16 Apr 2010 12:01:26 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jakob Viketoft <jakob.viketoft@bitsim.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100416100126.GI30801@buzzloop.caiaq.de>
References: <4BC8330E.6000503@bitsim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC8330E.6000503@bitsim.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 11:51:10AM +0200, Jakob Viketoft wrote:
> The recent addition of (Colibri) PXA3xx specific declarations breaks
> the building of the Colibri 270 with similar features.

Hmm, I can't see any problem here. Which error did you get? Which boards
did you select in your config?

Daniel


> 
> CC: Daniel Mack <daniel@caiaq.de>
> CC: Eric Miao <eric.y.miao@gmail.com>
> Signed-off-by <jakob.viketoft@bitsim.com>
> 
> --- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15
> 17:09:39.000000000 +0100
> +++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16
> 11:06:15.000000000 +0200
> @@ -7,6 +7,7 @@
>   * common settings for all modules
>   */
> 
> +#if defined(CONFIG_MACH_COLIBRI300) || defined(CONFIG_MACH_COLIBRI320)
>  #if defined(CONFIG_MMC_PXA) || defined(CONFIG_MMC_PXA_MODULE)
>  extern void colibri_pxa3xx_init_mmc(mfp_cfg_t *pins, int len, int
> detect_pin);
>  #else
> @@ -28,6 +29,7 @@
>  #else
>  static inline void colibri_pxa3xx_init_nand(void) {}
>  #endif
> +#endif
> 
>  /* physical memory regions */
>  #define COLIBRI_SDRAM_BASE	0xa0000000      /* SDRAM region */
> 
