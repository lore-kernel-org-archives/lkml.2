Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1KXGZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:25:20 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:1597
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1KXGZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:25:19 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 24 Nov 2011 14:37:22 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Bolle <pebolle@tiscali.nl>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'
Message-ID: <20111124063720.GG17979@S2100-06.ap.freescale.net>
References: <1321882445.32195.3.camel@x61.thuisdomein>
 <20111121133603.GR9581@n2100.arm.linux.org.uk>
 <20111122090718.GD27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111122090718.GD27267@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:07:18AM +0100, Sascha Hauer wrote:
[...]
> Indeed, I never realized that it's missing arch/arm/mach-imx
> 
> 8<----------------------------------------
> 
> MAINTAINERS: Add missing directory
> 
> arch/arm/mach-imx/ is part of the i.MX support. Add it.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 071a996..c9ae02a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -789,6 +789,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  T:	git git://git.pengutronix.de/git/imx/linux-2.6.git
>  F:	arch/arm/mach-mx*/
> +F:	arch/arm/mach-imx/
>  F:	arch/arm/plat-mxc/
>  
>  ARM/FREESCALE IMX51

I think as the part of the update, 'arch/arm/mach-mx*/' should be
removed, since I'm now responsible for maintaining mach-mxs, and
mach-mx5 is going into mach-imx anyway.

-- 
Regards,
Shawn

