Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2H1GoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 02:44:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39408 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2H1GoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 02:44:05 -0400
Date: Tue, 28 Aug 2012 08:43:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: kernel@pengutronix.de, linux@arm.linux.org.uk,
        yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM i.MX: remove duplicated include from clk-imx21.c
Message-ID: <20120828064353.GO26594@pengutronix.de>
References: <CAPgLHd_pYM3otnZBZ=nz7aYTP4dorBSjQtj=x9Z+zz7yr1NgSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_pYM3otnZBZ=nz7aYTP4dorBSjQtj=x9Z+zz7yr1NgSg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:43:43 up 65 days, 21:55, 28 users,  load average: 0.04, 0.09,
 0.15
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 09:48:11AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied, thanks

Sascha

> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/arm/mach-imx/clk-imx21.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-imx21.c b/arch/arm/mach-imx/clk-imx21.c
> index ea13e61..cf65148 100644
> --- a/arch/arm/mach-imx/clk-imx21.c
> +++ b/arch/arm/mach-imx/clk-imx21.c
> @@ -23,7 +23,6 @@
>  #include <linux/clk-provider.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> -#include <linux/clkdev.h>
>  #include <linux/err.h>
>  
>  #include <mach/hardware.h>
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
