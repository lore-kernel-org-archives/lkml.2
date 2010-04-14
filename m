Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab0DNGyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:54:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DNGyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:54:41 -0400
Date: Wed, 14 Apr 2010 08:54:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       r.herring@freescale.com, bryan.wu@canonical.com
Subject: Re: [PATCH 2.6.34-rc4 1/1] mx5: Fix build error for mx51_defconfig
Message-ID: <20100414065440.GE7882@pengutronix.de>
References: <1271185508-7038-1-git-send-email-Dinh.Nguyen@freescale.com> <20100414064437.GA9919@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414064437.GA9919@matterhorn.verdurent.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:52:18 up 24 days, 19:41, 25 users,  load average: 3.37, 2.63,
	2.91
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 09:44:37AM +0300, Amit Kucheria wrote:
> On 10 Apr 13, Dinh.Nguyen@freescale.com wrote:
> > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > 
> > Need to include <asm/div64.h> for do_div calls.
> > 
> > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > ---
> >  arch/arm/mach-mx5/clock-mx51.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
> > index 8f85f73..1ee6ce4 100644
> > --- a/arch/arm/mach-mx5/clock-mx51.c
> > +++ b/arch/arm/mach-mx5/clock-mx51.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/io.h>
> >  
> >  #include <asm/clkdev.h>
> > +#include <asm/div64.h>
> >  
> >  #include <mach/hardware.h>
> >  #include <mach/common.h>
> > -- 
> > 1.6.0.4
>  
> Acked-by: Amit Kucheria <amit.kucheria@canonical.com>
> 
> Sascha, I can collect all the mx5 patches and make them available to you in a
> git pull-request. Would that be ok?

I prefer collecting them myself since many patches will be not i.MX51
specific but i.MX specific and I'm afraid of too many merge conflicts.

> 
> Regards,
> Amit
> p.s. Your patches are on my todo list. Will get to them now.

They are already mainline.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
