Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0KJQqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:46:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46373 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0KJQqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:46:42 -0500
Date: Wed, 10 Nov 2010 17:46:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
Message-ID: <20101110164640.GV6017@pengutronix.de>
References: <1288972551-21877-1-git-send-email-Dinh.Nguyen@freescale.com> <20101109214607.GG6017@pengutronix.de> <86A0E76937111F4C92FABEC0A20988510523D224@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86A0E76937111F4C92FABEC0A20988510523D224@az33exm21>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:45:36 up 130 days,  7:56, 40 users,  load average: 1.89, 0.79,
	0.43
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 08:51:19AM -0700, Nguyen Dinh-R00091 wrote:
> Hi Sascha,
> 
> >-----Original Message-----
> >From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
> >Sent: Tuesday, November 09, 2010 3:46 PM
> >To: Nguyen Dinh-R00091
> >Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linux@arm.linux.org.uk;
> >u.kleine-koenig@pengutronix.de; amit.kucheria@canonical.com;
> eric@eukrea.com
> >Subject: Re: [PATCHv3 1/2] ARM: imx: Add core definitions for MX53
> >
> >Hi Dinh,
> >
> >On Fri, Nov 05, 2010 at 10:55:50AM -0500, Dinh.Nguyen@freescale.com
> wrote:
> >> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >>
> >> Add iomux, clocks,  and memory map for Freescale's MX53 SoC.
> >> Add cpu_is_mx53 function to common.h.
> >> Add 3 more banks of gpio's to mxc_gpio_ports.
> >> Add MX53 phys offset address.
> >>
> >> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> >> ---
> >>  arch/arm/mach-mx5/clock-mx53.c              |  857
> +++++++++++++++++++++++++++
> >>  arch/arm/mach-mx5/devices.c                 |   27 +
> >>  arch/arm/plat-mxc/include/mach/common.h     |    4 +
> >>  arch/arm/plat-mxc/include/mach/iomux-mx53.h |  303 ++++++++++
> >>  arch/arm/plat-mxc/include/mach/memory.h     |    1 +
> >>  arch/arm/plat-mxc/include/mach/mx53.h       |  406 +++++++++++++
> >>  6 files changed, 1598 insertions(+), 0 deletions(-)
> >>  create mode 100644 arch/arm/mach-mx5/clock-mx53.c
> >>  create mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
> >>  create mode 100644 arch/arm/plat-mxc/include/mach/mx53.h
> >>
> >> diff --git a/arch/arm/mach-mx5/clock-mx53.c
> b/arch/arm/mach-mx5/clock-mx53.c
> >> new file mode 100644
> >> index 0000000..d547cb8
> >> --- /dev/null
> >> +++ b/arch/arm/mach-mx5/clock-mx53.c
> >
> >Most of this code looks like it could be shared with clock-mx51.c
> 
> Agreed, but I was unsure how to proceed with adding clock code for mx53.
> Should I merge mx53 clock code into clock-mx51 and rename clock-mx51?

Yes, to something like clock-mx51-mx53.c

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
