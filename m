Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0DNGop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:44:45 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56677 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab0DNGoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:44:44 -0400
Date: Wed, 14 Apr 2010 09:44:37 +0300
From: Amit Kucheria <amit.kucheria@canonical.com>
To: Dinh.Nguyen@freescale.com, Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCH 2.6.34-rc4 1/1] mx5: Fix build error for mx51_defconfig
Message-ID: <20100414064437.GA9919@matterhorn.verdurent.com>
Mail-Followup-To: Dinh.Nguyen@freescale.com,
	Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
	valentin.longchamp@epfl.ch, daniel@caiaq.de,
	grant.likely@secretlab.ca, r.herring@freescale.com,
	bryan.wu@canonical.com
References: <1271185508-7038-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1271185508-7038-1-git-send-email-Dinh.Nguyen@freescale.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Apr 13, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Need to include <asm/div64.h> for do_div calls.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> index 8f85f73..1ee6ce4 100644
> --- a/arch/arm/mach-mx5/clock-mx51.c
> +++ b/arch/arm/mach-mx5/clock-mx51.c
> @@ -16,6 +16,7 @@
>  #include <linux/io.h>
>  
>  #include <asm/clkdev.h>
> +#include <asm/div64.h>
>  
>  #include <mach/hardware.h>
>  #include <mach/common.h>
> -- 
> 1.6.0.4
 
Acked-by: Amit Kucheria <amit.kucheria@canonical.com>

Sascha, I can collect all the mx5 patches and make them available to you in a
git pull-request. Would that be ok?

Regards,
Amit
p.s. Your patches are on my todo list. Will get to them now.

-- 
----------------------------------------------------------------------
Amit Kucheria, Kernel Engineer || amit.kucheria@canonical.com
----------------------------------------------------------------------
