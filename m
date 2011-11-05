Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1KEAOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:14:34 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39021 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1KEAOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:14:33 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19FPvCXNHYFWdxK7BMauY/1
Date: Fri, 4 Nov 2011 17:14:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP: dmtimer: Include linux/module.h
Message-ID: <20111105001429.GK31337@atomide.com>
References: <1320198586.9065.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320198586.9065.2.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@gmail.com> [111101 18:15]:
> Include linux/module.h to fix below build error:
...

> I got the build error by make omap2plus_defconfig on linux-next 20111101.
> 
>  arch/arm/plat-omap/dmtimer.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
> index 2def4e1..af3b92b 100644
> --- a/arch/arm/plat-omap/dmtimer.c
> +++ b/arch/arm/plat-omap/dmtimer.c
> @@ -35,6 +35,7 @@
>   * 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/module.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>

Thanks, applying into fixes.

Tony
