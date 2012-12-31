Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2LaKDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 05:03:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab2LaKDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 05:03:39 -0500
Message-ID: <50E162F8.8030403@ti.com>
Date: Mon, 31 Dec 2012 11:03:36 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
References: <1356358796.1688.3.camel@cliu38-desktop-build>
In-Reply-To: <1356358796.1688.3.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2012 03:19 PM, Chuansheng Liu wrote:
> This patch fix the below build error:
> drivers/built-in.o: In function `twl_probe':
> drivers/mfd/twl-core.c:1256: undefined reference to `devm_regmap_init_i2c'
> make: *** [vmlinux] Error 1

Thanks Liu, I have missed this one.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 1c0abd4..47ad4e2 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -292,6 +292,7 @@ config TWL4030_CORE
>  	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	select IRQ_DOMAIN
> +	select REGMAP_I2C
>  	help
>  	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
>  	  This core driver provides register access and IRQ handling
> 
