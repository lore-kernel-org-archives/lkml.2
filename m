Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2IUSWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:22:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56748 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2IUSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:22:49 -0400
Date: Fri, 21 Sep 2012 14:24:33 -0400
From: Matt Porter <mporter@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20120921182433.GG16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-2-git-send-email-mporter@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EA8A6A9@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA8A6A9@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 07:10:52AM +0000, Hebbar, Gururaja wrote:
> On Thu, Sep 20, 2012 at 20:13:34, Porter, Matt wrote:
> > Move mach-davinci/dma.c to common/edma.c so it can be used
> > by OMAP (specifically AM33xx atm) as well. This just moves
> > the private EDMA API but does not support OMAP.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/Kconfig                           |    1 +
> >  arch/arm/common/Kconfig                    |    3 +
> >  arch/arm/common/Makefile                   |    1 +
> >  arch/arm/common/edma.c                     | 1588 ++++++++++++++++++++++++++++
> >  arch/arm/include/asm/mach/edma.h           |  267 +++++
> >  arch/arm/mach-davinci/Makefile             |    2 +-
> >  arch/arm/mach-davinci/devices.c            |    3 +-
> >  arch/arm/mach-davinci/dm355.c              |    2 +-
> >  arch/arm/mach-davinci/dm365.c              |    2 +-
> >  arch/arm/mach-davinci/dm644x.c             |    2 +-
> >  arch/arm/mach-davinci/dm646x.c             |    2 +-
> >  arch/arm/mach-davinci/dma.c                | 1588 ----------------------------
> 
> 
> Please use –M option, while generating patches via git-format-patch. 
> This reduces the patch size if files are copied/renamed/moved.

Yes, I didn't notice until the arm kernel list caught the >100k post.
Will take care of this in v2.

-Matt
