Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2HaAsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:48:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36624 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2HaAso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:48:44 -0400
Message-ID: <1346374554.15463.6.camel@vkoul-mobl4>
Subject: Re: [PATCH v3 3/3] spi: spi-davinci: convert to DMA engine API
From: Vinod Koul <vkoul@infradead.org>
To: Matt Porter <mporter@ti.com>
Cc: vinod.koul@intel.com, Sekhar Nori <nsekhar@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        grant.likely@secretlab.ca,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        cjb@laptop.org,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Aug 2012 06:25:54 +0530
In-Reply-To: <20120830144307.GA26737@beef>
References: <1345684176-21472-1-git-send-email-mporter@ti.com>
	 <1345684176-21472-4-git-send-email-mporter@ti.com>
	 <503F75C0.1050507@ti.com> <20120830144307.GA26737@beef>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-30 at 10:43 -0400, Matt Porter wrote:
> On Thu, Aug 30, 2012 at 07:46:32PM +0530, Sekhar Nori wrote:
> > Hi Matt,
> > 
> > On 8/23/2012 6:39 AM, Matt Porter wrote:
> > > Removes use of the DaVinci EDMA private DMA API and replaces
> > > it with use of the DMA engine API.
> > > 
> > > Signed-off-by: Matt Porter <mporter@ti.com>
> > 
> > I tried testing this patch on my OMAP-L138 EVM, but SPI fails to 
> > initialize after applying the patch.
> > 
> > root@arago:~# dmesg | grep -i spi                                               
> > spi_davinci spi_davinci.1: request RX DMA channel failed                        
> 
> Hi Sekhar,
> 
> Most likely CONFIG_TI_EDMA is off as it defaults to off in the v3
> series. Try enabling this and if it's the problem then this error
> path can be fixed to properly fallback to PIO only or fail to
> initialize as needed.
I didnt see any update on this one, is it okay, if so care to send a
tested-by?

-- 
~Vinod Koul
Intel Corp.

