Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab2JCP7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:59:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:63504 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932472Ab2JCP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:59:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eX8A8T8EIUUwCTDNi4k/r
Date: Wed, 3 Oct 2012 08:59:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3.7-rc1] omap zoom2.c: Fix compile error by including
 correct header files
Message-ID: <20121003155900.GA4840@atomide.com>
References: <1349274686-45668-1-git-send-email-tim.gardner@canonical.com>
 <506C5124.3050200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C5124.3050200@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [121003 07:52]:
> On 10/03/2012 05:31 PM, Tim Gardner wrote:
> > Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
> > Cc: Liam Girdwood <lrg@ti.com>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Jaroslav Kysela <perex@perex.cz>
> > Cc: Takashi Iwai <tiwai@suse.de>
> > Cc: linux-omap@vger.kernel.org
> > Cc: alsa-devel@alsa-project.org
> > Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> > ---
> >  sound/soc/omap/zoom2.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/sound/soc/omap/zoom2.c b/sound/soc/omap/zoom2.c
> > index 23de2b2..d0a8c92 100644
> > --- a/sound/soc/omap/zoom2.c
> > +++ b/sound/soc/omap/zoom2.c
> > @@ -27,9 +27,10 @@
> >  
> >  #include <asm/mach-types.h>
> >  #include <mach/hardware.h>
> > -#include <mach/gpio.h>
> > +#include <linux/gpio.h>
> >  #include <mach/board-zoom.h>
> >  #include <linux/platform_data/asoc-ti-mcbsp.h>
> > +#include <linux/platform_data/gpio-omap.h>
> >  
> >  /* Register descriptions for twl4030 codec part */
> >  #include <linux/mfd/twl4030-audio.h>
> > 
> 
> I have the same patch stashed away for the same issue. Was waiting for rc1 to
> send it.

Can you please update the patch to also to remove the
"#include <mach/board-zoom.h>" while at it?

AFAIK it's not needed at all and just adds a dependency to asoc with
my upcoming plat header cleanup patches.

Regards,

Tony
