Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439Ab2JKVsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:48:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56228 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759414Ab2JKVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:48:35 -0400
Date: Thu, 11 Oct 2012 17:49:30 -0400
From: Matt Porter <mporter@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>, spi-devel-general@lists.sourceforge.net,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 00/16] DMA Engine support for AM33xx
Message-ID: <20121011214930.GF13724@beef>
References: <1349982281-10785-1-git-send-email-mporter@ti.com>
 <CACxGe6vL2ieaYN_YhZn9=e7=prwdfwZtgPr4Ei3VMNnViib6XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vL2ieaYN_YhZn9=e7=prwdfwZtgPr4Ei3VMNnViib6XA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:31:58PM +0100, Grant Likely wrote:
> Hey Matt,
> 
> Do you know now similar are the EDMA engines on the am33xx and am389x? I've
> been working on am389x upstreaming and I'll try these patches out if it is
> the same engine.

Hi Grant,

It's the same one. am389x/ti816x and am387x/ti814x are part of the same
architectural family as am33xx. They've just never had a lot of upstream
support from TI. I heard rumors that you might be working with am389x
and I'm glad you're confirming that for me! ;)

The only differences between am33xx's implementation and the others is
going to be the number PaRAM slots, number of TCs, the channel mapping,
and then the crossbar mapping. As you can see from the TODO list, I
don't yet support the crossbar, but it'll be in the next version of this
series. The other items are already covered in the DT binding so it
should be straightforward to hook this up for am389x assuming your hwmod
and clock data is good for that part.

-Matt
