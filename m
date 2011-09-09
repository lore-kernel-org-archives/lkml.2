Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1IIGlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:41:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1IIGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:41:38 -0400
Date: Fri, 9 Sep 2011 08:41:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: manual merge of the i.MX tree with the arm-soc tree
Message-ID: <20110909064136.GG28816@pengutronix.de>
References: <20110909114016.4a2a35295d3c84e37663289e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110909114016.4a2a35295d3c84e37663289e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 09, 2011 at 11:40:16AM +1000, Stephen Rothwell wrote:
> The conflict looks like this:
> 
> diff --cc arch/arm/mach-imx/Makefile
> index f87cc55,d22096a..0000000
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@@ -3,7 -3,7 +3,11 @@@ obj-$(CONFIG_IMX_HAVE_DMA_V1) += dma-v1
>   obj-$(CONFIG_SOC_IMX1) += clock-imx1.o mm-imx1.o
>   obj-$(CONFIG_SOC_IMX21) += clock-imx21.o mm-imx21.o
>   
> ++<<<<<<< HEAD
>  +obj-$(CONFIG_SOC_MX25) += clock-imx25.o mm-imx25.o ehci-imx25.o cpu-imx25.o
> ++=======
> + obj-$(CONFIG_SOC_IMX25) += clock-imx25.o mm-imx25.o ehci-imx25.o cpu-imx25.o
> ++>>>>>>> i.MX/for-next
>   
>   obj-$(CONFIG_SOC_IMX27) += cpu-imx27.o pm-imx27.o
>   obj-$(CONFIG_SOC_IMX27) += clock-imx27.o mm-imx27.o ehci-imx27.o
> 
> Given that there are no other references to SOC_MX25 in the resulting
> tree, I used the latter version.
That's right.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
