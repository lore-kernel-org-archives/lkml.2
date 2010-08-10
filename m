Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0HJXOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 19:14:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:15638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0HJXOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 19:14:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,350,1278313200"; 
   d="scan'208";a="543835044"
Date: Wed, 11 Aug 2010 01:14:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mfd: tps6586x depends on GPIOLIB
Message-ID: <20100810231421.GA2571@sortiz-mobl>
References: <20100810135601.4777e310.sfr@canb.auug.org.au>
 <20100810094059.c320b916.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100810094059.c320b916.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 09:40:59AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> tps6586x uses gpio interfaces, so it should depend on GPIOLIB.
Thanks Randy, I merged this one into the yet to be pulled tps6586x driver.

Cheers,
Samuel.

> Fixes these build errors:
> 
> drivers/mfd/tps6586x.c:41: error: field 'gpio' has incomplete type
> drivers/mfd/tps6586x.c:195: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/tps6586x.c:195: warning: initialization from incompatible pointer type
> drivers/mfd/tps6586x.c:210: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/tps6586x.c:210: warning: initialization from incompatible pointer type
> drivers/mfd/tps6586x.c:219: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/tps6586x.c:219: warning: initialization from incompatible pointer type
> drivers/mfd/tps6586x.c:249: error: implicit declaration of function 'gpiochip_add'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20100810.orig/drivers/mfd/Kconfig
> +++ linux-next-20100810/drivers/mfd/Kconfig
> @@ -543,7 +543,7 @@ config MFD_JZ4740_ADC
>  
>  config MFD_TPS6586X
>  	tristate "TPS6586x Power Management chips"
> -	depends on I2C
> +	depends on I2C && GPIOLIB
>  	select MFD_CORE
>  	help
>  	  If you say yes here you get support for the TPS6586X series of

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
