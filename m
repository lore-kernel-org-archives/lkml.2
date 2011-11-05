Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1KEANp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 20:13:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21299 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566Ab1KEANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 20:13:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19H5rMVd4IkqsE+HhS6NITQ
Date: Fri, 4 Nov 2011 17:13:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP2+: l3-noc: Include linux/module.h
Message-ID: <20111105001340.GJ31337@atomide.com>
References: <1320198011.9065.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320198011.9065.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@gmail.com> [111101 18:05]:
> Include linux/module.h to fix below build error:
> 
>   CC      arch/arm/mach-omap2/omap_l3_noc.o
> arch/arm/mach-omap2/omap_l3_noc.c:240: error: expected ',' or ';' before 'MODULE_DEVICE_TABLE'
> arch/arm/mach-omap2/omap_l3_noc.c:250: error: 'THIS_MODULE' undeclared here (not in a function)
> make[1]: *** [arch/arm/mach-omap2/omap_l3_noc.o] Error 1
> make: *** [arch/arm/mach-omap2] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I got the build error by make omap2plus_defconfig on linux-next 20111101.
> 
>  arch/arm/mach-omap2/omap_l3_noc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_l3_noc.c b/arch/arm/mach-omap2/omap_l3_noc.c
> index c8b1bef..6a66aa5 100644
> --- a/arch/arm/mach-omap2/omap_l3_noc.c
> +++ b/arch/arm/mach-omap2/omap_l3_noc.c
> @@ -20,6 +20,7 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
>   * USA
>   */
> +#include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>

Thanks applying into fixes.

Tony
