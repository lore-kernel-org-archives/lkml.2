Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2LNRVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:21:16 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64995 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756538Ab2LNRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:21:15 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18oQQPIYoZ9JayOx3pPyMiZ
Date: Fri, 14 Dec 2012 09:21:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thomas Weber <thomas@tomweber.eu>
Cc: Russell King <linux@arm.linux.org.uk>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP3: Devkit8000: Add DDC i2c_bus_num
Message-ID: <20121214172111.GQ4989@atomide.com>
References: <1353003123-7335-1-git-send-email-thomas@tomweber.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353003123-7335-1-git-send-email-thomas@tomweber.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Weber <thomas@tomweber.eu> [121115 10:14]:
> Add i2c bus number for DVI output.
> The driver uses this to detect if a panel is connected and to read EDID.

Thanks applying into omap-for-v3.8/fixes-for-merge-window.

Regards,

Tony
 
> Signed-off-by: Thomas Weber <thomas@tomweber.eu>
> ---
>  arch/arm/mach-omap2/board-devkit8000.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
> index 1fd161e..6f04f0f 100644
> --- a/arch/arm/mach-omap2/board-devkit8000.c
> +++ b/arch/arm/mach-omap2/board-devkit8000.c
> @@ -139,6 +139,7 @@ static struct omap_dss_device devkit8000_lcd_device = {
>  
>  static struct tfp410_platform_data dvi_panel = {
>  	.power_down_gpio	= -1,
> +	.i2c_bus_num		= 1,
>  };
>  
>  static struct omap_dss_device devkit8000_dvi_device = {
> -- 
> 1.8.0
> 
