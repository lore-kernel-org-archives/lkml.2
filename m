Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2IUJey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:34:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46761 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2IUJew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:34:52 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Porter, Matt" <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
	arm/common
Thread-Topic: [RFC PATCH 01/13] ARM: davinci: move private EDMA API to
	arm/common
Thread-Index: AQHNl9u40QawS97+1kKyI+aS1pelCJeUiGZQ
Date: Fri, 21 Sep 2012 09:33:42 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA8AA3C@DBDE01.ent.ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
	<1348152226-13588-2-git-send-email-mporter@ti.com>
 <20120921092923.GA31374@n2100.arm.linux.org.uk>
In-Reply-To: <20120921092923.GA31374@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 14:59:23, Russell King - ARM Linux wrote:
> On Thu, Sep 20, 2012 at 10:43:34AM -0400, Matt Porter wrote:
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
> 
> asm/mach should not be used as a dumping ground for platform header files.
> It is there to provide the interfaces between generic ARM architecture
> code and platform code.  (At least four files that are there at the
> moment need to be moved out of there - patch series to follow...)

Can this be moved to include/linux/platform_data/ ?

> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
