Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0INTF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:05:57 -0400
Received: from void.printf.net ([89.145.121.20]:41450 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0INTF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:05:56 -0400
Date: Tue, 14 Sep 2010 20:05:49 +0100
From: Chris Ball <cjb@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saeed Bishara <saeed@marvell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Add architecture dependency for Marvell SoC
	controller
Message-ID: <20100914190549.GA21918@void.printf.net>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 13, 2010 at 09:24:39AM +0100, Mark Brown wrote:
> Since the driver is for controllers integrated into Marvells SoCs only
> offer MMC_SDHCI_MV if we're building for one.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mmc/host/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index ce099c4..5fa4e2b 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -133,6 +133,7 @@ config MMC_SDHCI_CNS3XXX
>  config MMC_SDHCI_MV
>  	tristate "SDHCI support on Marvell's SoC"
>  	depends on MMC_SDHCI
> +	depends on (PLAT_PXA || PLAT_ORION)
>  	select MMC_SDHCI_IO_ACCESSORS
>  	help
>  	  This selects the Secure Digital Host Controller Interface in
> -- 
> 1.7.1

This is fine with me.  Saeed, please can you ACK the choice of
platforms if you agree?

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
