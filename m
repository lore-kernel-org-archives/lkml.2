Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1DFIFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:05:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38558 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1DFIFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:05:30 -0400
Date: Wed, 6 Apr 2011 10:05:22 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC 1/5]arch/arm/common/Makefile Remove unused config in the
 Makefile.
Message-ID: <20110406080522.GZ13963@pengutronix.de>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 05, 2011 at 09:58:18AM -0700, Justin P. Mattock wrote:
> The patch below removes an unused config variable found by using a kernel
> cleanup script.
> Note: I did try to cross compile these but hit erros while doing so..
> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
> Please have a look if/when anybody has free time.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: linux-arm-kernel@lists.infradead.org
The file was removed by commit

	6d803ba (ARM: 6483/1: arm & sh: factorised duplicated clkdev.c)

(added the persons involved to Cc).

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

> ---
>  arch/arm/common/Makefile |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/Makefile b/arch/arm/common/Makefile
> index e7521bca..6ea9b6f 100644
> --- a/arch/arm/common/Makefile
> +++ b/arch/arm/common/Makefile
> @@ -16,5 +16,4 @@ obj-$(CONFIG_SHARP_SCOOP)	+= scoop.o
>  obj-$(CONFIG_ARCH_IXP2000)	+= uengine.o
>  obj-$(CONFIG_ARCH_IXP23XX)	+= uengine.o
>  obj-$(CONFIG_PCI_HOST_ITE8152)  += it8152.o
> -obj-$(CONFIG_COMMON_CLKDEV)	+= clkdev.o
>  obj-$(CONFIG_ARM_TIMER_SP804)	+= timer-sp.o
> -- 
> 1.7.4.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
