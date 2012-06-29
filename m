Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2F2A5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 20:57:38 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:42220
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab2F2A5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 20:57:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzzz2dh87h2a8h668h839h944hd25he96hf0ah)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 29 Jun 2012 08:57:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mxs/tx28: fix odd include
Message-ID: <20120629005745.GC23422@S2101-09.ap.freescale.net>
References: <1340879945.1911.49.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340879945.1911.49.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 12:39:05PM +0200, Paul Bolle wrote:
> arch/arm/mach-mxs/module-tx28.c includes "../devices-mx28.h". That's a
> bit odd, because that header can be found in the same directory. This
> only works because arch/arm/mach-mxs/include should be in the header
> search path for this file. Nevertheless, this file can simply include
> "device-mx28.h" (just as the four other files including that header do).
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks.

Regards,
Shawn

> ---
> 0) Untested, but obviously correct.
> 
>  arch/arm/mach-mxs/module-tx28.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/module-tx28.c b/arch/arm/mach-mxs/module-tx28.c
> index 9a7b08b..0f71f82 100644
> --- a/arch/arm/mach-mxs/module-tx28.c
> +++ b/arch/arm/mach-mxs/module-tx28.c
> @@ -11,7 +11,7 @@
>  #include <linux/gpio.h>
>  
>  #include <mach/iomux-mx28.h>
> -#include "../devices-mx28.h"
> +#include "devices-mx28.h"
>  
>  #include "module-tx28.h"
>  
> -- 
> 1.7.7.6
> 

