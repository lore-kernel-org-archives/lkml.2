Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861Ab2DLGb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:31:28 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:47501 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab2DLGb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:31:26 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 02:31:26 EDT
X-Spam-Flag: NO
X-Spam-Score: -3.613
Message-ID: <4F8674DF.3070101@openwrt.org>
Date: Thu, 12 Apr 2012 08:23:27 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Frederic Lambert <frdrc66@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: Remove redundant spi driver bus initialization
References: <1334091089-10138-1-git-send-email-lars@metafoo.de> <1334091089-10138-4-git-send-email-lars@metafoo.de>
In-Reply-To: <1334091089-10138-4-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012.04.10. 22:51 keltezéssel, Lars-Peter Clausen írta:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register() so
> we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Gabor Juhos <juhosg@openwrt.org>
> Cc: Frederic Lambert <frdrc66@gmail.com>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/phy/spi_ks8995.c |    1 -
>  1 file changed, 1 deletion(-)

Acked-by: Gabor Juhos <juhosg@openwrt.org>
