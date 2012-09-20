Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2ITQDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:03:44 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50969 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2ITQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:03:41 -0400
Date: Thu, 20 Sep 2012 12:05:20 -0400
From: Matt Porter <mporter@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 13/13] Documentation: add schedule for removing
 private EDMA API
Message-ID: <20120920160520.GD16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-14-git-send-email-mporter@ti.com>
 <20120920155858.GA4583@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920155858.GA4583@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 04:58:58PM +0100, Mark Brown wrote:
> On Thu, Sep 20, 2012 at 10:43:46AM -0400, Matt Porter wrote:
> 
> >  Documentation/feature-removal-schedule.txt |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> 
> We decided at kernel summit that we'd stop bothering with this, it's
> mostly just bitrot and rarely read.  I guess the ASoC driver update
> isn't ready yet?

Ok, I'll drop this from the series.

No, I'm just getting real time now to work on the davinci-pcm dma engine
conversion and cyclic dma support for edma. That driver is somewhat of a
mess as it has some older platforms dependent on SRAM-based ping-pong
buffering and that all need to be sorted during this. It is the only
remaining blocker though for getting rid of the private API.

-Matt
