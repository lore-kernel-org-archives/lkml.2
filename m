Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2EBNyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:54:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2EBNyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:54:03 -0400
Date: Wed, 2 May 2012 21:53:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v2 3/3] ARM: imx: Add imx6q cpuidle driver
Message-ID: <20120502135357.GC2194@S2101-09.ap.freescale.net>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-4-git-send-email-rob.lee@linaro.org>
 <20120502032336.GU2194@S2101-09.ap.freescale.net>
 <CAMXH7KHnN3YDwM6crgaFqwrgb4W=CErjgNiTPaZ8wrZ5dvKLuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KHnN3YDwM6crgaFqwrgb4W=CErjgNiTPaZ8wrZ5dvKLuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 08:50:20AM -0500, Rob Lee wrote:
> >> --- a/arch/arm/mach-imx/mach-imx6q.c
> >> +++ b/arch/arm/mach-imx/mach-imx6q.c
> >> @@ -21,6 +21,9 @@
> >>  #include <linux/of_platform.h>
> >>  #include <linux/phy.h>
> >>  #include <linux/micrel_phy.h>
> >> +#include <linux/export.h>
> >> +#include <linux/cpuidle.h>
> >> +#include <asm/cpuidle.h>
> >>  #include <asm/smp_twd.h>
> >>  #include <asm/hardware/cache-l2x0.h>
> >>  #include <asm/hardware/gic.h>
> >> @@ -29,6 +32,7 @@
> >>  #include <asm/system_misc.h>
> >>  #include <mach/common.h>
> >>  #include <mach/hardware.h>
> >> +#include <mach/cpuidle.h>
> >
> > The headers here are mostly sorted in names, so please ...
> >
> 
> Do you mean sorted alphabetically per group?  So the last three
> includes should look like this instead?
> ...
> #include <mach/common.h>
> #include <mach/cpuidle.h>
> #include <mach/hardware.h>
> ...

Yes.  And do not forget <linux/export.h> and <linux/cpuidle.h>.

-- 
Regards,
Shawn
