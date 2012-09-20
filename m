Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2ITP7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:59:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54934 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab2ITP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:59:00 -0400
Date: Thu, 20 Sep 2012 16:58:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matt Porter <mporter@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH 13/13] Documentation: add schedule for removing
	private EDMA API
Message-ID: <20120920155858.GA4583@opensource.wolfsonmicro.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com> <1348152226-13588-14-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348152226-13588-14-git-send-email-mporter@ti.com>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:43:46AM -0400, Matt Porter wrote:

>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  1 file changed, 10 insertions(+)

We decided at kernel summit that we'd stop bothering with this, it's
mostly just bitrot and rarely read.  I guess the ASoC driver update
isn't ready yet?
