Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1FPOhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:37:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52894 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1FPOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:37:16 -0400
Date: Thu, 16 Jun 2011 08:37:12 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH 2/2] gpio: include linux/gpio.h where needed
Message-ID: <20110616143712.GA2806@ponder.secretlab.ca>
References: <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com>
 <20110527201201.GA6645@ponder.secretlab.ca>
 <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
 <20110603171837.GA9918@opensource.wolfsonmicro.com>
 <BANLkTi=oko_C8_46Y8p5O1Qvw1KEn-1PjA@mail.gmail.com>
 <4DEC4D67.6010506@oracle.com>
 <20110614091211.465553de.randy.dunlap@oracle.com>
 <20110614161357.GB1839@ponder.secretlab.ca>
 <20110614170602.7a51b1af.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614170602.7a51b1af.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:06:02PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Some files use GPIOF_ macros but don't include the header file
> for them.  These macros are being moved to <linux/gpio.h>, so add
> includes for <linux/gpio.h> where needed.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks.

g.

> ---
>  arch/arm/mach-pxa/spitz_pm.c    |    1 +
>  drivers/pcmcia/pxa2xx_vpac270.c |    1 +
>  2 files changed, 2 insertions(+)
> 
> --- linux-next-20110614.orig/arch/arm/mach-pxa/spitz_pm.c
> +++ linux-next-20110614/arch/arm/mach-pxa/spitz_pm.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
>  #include <linux/apm-emulation.h>
> --- linux-next-20110614.orig/drivers/pcmcia/pxa2xx_vpac270.c
> +++ linux-next-20110614/drivers/pcmcia/pxa2xx_vpac270.c
> @@ -11,6 +11,7 @@
>   *
>   */
>  
> +#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  
