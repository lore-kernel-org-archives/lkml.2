Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0JDRyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:54:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57616 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab0JDRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:54:32 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zX7uwjM1N2oFW2itvAaNM
Date: Mon, 4 Oct 2010 10:54:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/omap: remove duplicated include
Message-ID: <20101004175429.GW3117@atomide.com>
References: <20101004174344.21577085@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004174344.21577085@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Kaiser <nikai@nikai.net> [101004 08:35]:
> Remove duplicated include.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
>  drivers/video/omap/lcd_omap3beagle.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/omap/lcd_omap3beagle.c b/drivers/video/omap/lcd_omap3beagle.c
> index ca75cc2..ac715f9 100644
> --- a/drivers/video/omap/lcd_omap3beagle.c
> +++ b/drivers/video/omap/lcd_omap3beagle.c
> @@ -26,7 +26,6 @@
>  #include <linux/i2c/twl.h>
>  
>  #include <plat/mux.h>
> -#include <plat/mux.h>
>  #include <asm/mach-types.h>
>  
>  #include "omapfb.h"

Can you please updated this to remove both mux.h entries?

Including mux.h should no longer be needed for omap2/3/4 SoCs
outside arch/arm/mach-omap2 files. For omap1 machines those are still
needed in some drivers..

Regards,

Tony
