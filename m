Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2DGBwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:52:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42293 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2DGBwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:52:02 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Update GPIO_PCA953X Kconfig entry to include more supported devices
To: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1333703506.3957.1.camel@phoenix>
References: <1333703506.3957.1.camel@phoenix>
Date: Fri, 06 Apr 2012 15:43:53 -0700
Message-Id: <20120406224353.A1C8A3E0D65@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2012 17:11:46 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> Update the supported devices for gpio-pca953x driver.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks

g.

> ---
>  drivers/gpio/Kconfig |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index e03653d..b35ac52 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -243,7 +243,7 @@ config GPIO_MC9S08DZ60
>  	  Select this to enable the MC9S08DZ60 GPIO driver
>  
>  config GPIO_PCA953X
> -	tristate "PCA953x, PCA955x, TCA64xx, and MAX7310 I/O ports"
> +	tristate "PCA953x, PCA955x, PCA957x, TCA64xx, and MAX7310 I/O ports"
>  	depends on I2C
>  	help
>  	  Say yes here to provide access to several register-oriented
> @@ -252,10 +252,11 @@ config GPIO_PCA953X
>  
>  	  4 bits:	pca9536, pca9537
>  
> -	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557,
> -	  		tca6408
> +	  8 bits:	max7310, max7315, pca6107, pca9534, pca9538, pca9554,
> +			pca9556, pca9557, pca9574, tca6408
>  
> -	  16 bits:	pca9535, pca9539, pca9555, tca6416
> +	  16 bits:	max7312, max7313, pca9535, pca9539, pca9555, pca9575,
> +			tca6416
>  
>  config GPIO_PCA953X_IRQ
>  	bool "Interrupt controller support for PCA953x"
> -- 
> 1.7.5.4
> 
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
