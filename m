Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2IMHVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:21:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59727 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2IMHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:21:49 -0400
Date: Thu, 13 Sep 2012 15:21:40 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
Message-ID: <20120913072137.GE3141@S2101-09.ap.freescale.net>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <201209111410.05698.arnd@arndb.de>
 <Pine.LNX.4.64.1209111624240.22084@axis700.grange>
 <201209121552.26004.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209121552.26004.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:52:25PM +0000, Arnd Bergmann wrote:
> On Tuesday 11 September 2012, Guennadi Liakhovetski wrote:
> > ipu.h is used by the dmaengine and IRQ driver under drivers/dma/ipu/, and 
> > by its users drivers/media/platform/soc_camera/mx3_camera.c and 
> > drivers/video/mx3fb.c. It has been placed under arch/arm/... because it's 
> > arch-specific, but in principle I don't see any reason why it cannot 
> > happily live anywhere under include/...
> 
> Right. We can do that as the next step, after the pure platform data is
> out of the way.
> 
I'm working on a series to clean up the remaining imx mach headers.

-- 
Regards,
Shawn
