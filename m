Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1JXDNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:13:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:7910 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1JXDNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:13:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,396,1315206000"; 
   d="scan'208";a="65552778"
Subject: Re: [PATCH v3 0/4] dmaengine: Device Tree support for Atmel DMA
From: Vinod Koul <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4EA424FF.50103@atmel.com>
References: <1318438634-11826-1-git-send-email-nicolas.ferre@atmel.com>
	 <4E9C258D.3030509@atmel.com>  <4EA424FF.50103@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Oct 2011 08:34:02 +0530
Message-ID: <1319425442.9355.27.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-23 at 16:30 +0200, Nicolas Ferre wrote:
> On 10/17/2011 02:54 PM, Nicolas Ferre :
> > On 10/12/2011 06:57 PM, Nicolas Ferre :
> >> This series add the device tree support to Atmel DMA controller driver:
> >> at_hdmac.
> >> The removal of platform data ease the conversion to device tree. It also have
> >> the additional benefit of being simpler and cleaner.
> >>
> >> Nicolas Ferre (4):
> >>       dmaengine: at_hdmac: platform data move to use .id_table
> >>       dmaengine: at_hdmac: add device tree support
> >>       ARM: at91/dma: remove platform data from DMA controller
> >>       ARM: at91/dma: DMA controller registering with DT support
> >>
> >>  .../devicetree/bindings/dma/atmel-dma.txt          |   14 ++++
> >>  arch/arm/mach-at91/at91sam9g45_devices.c           |   17 ++---
> >>  arch/arm/mach-at91/at91sam9rl_devices.c            |    8 +--
> >>  arch/arm/mach-at91/include/mach/at_hdmac.h         |   10 ---
> >>  drivers/dma/at_hdmac.c                             |   76 +++++++++++++++++---
> >>  drivers/dma/at_hdmac_regs.h                        |    8 ++
> >>  6 files changed, 97 insertions(+), 36 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/dma/atmel-dma.txt
> > 
> > Vinod,
> > 
> > I have just rebased the dmaengine at_hdmac driver patches on top of your
> > "next" branch as a "v4" series. I send it to you with Grant's "Acked-by"
> > right now.
> 
> Vinod,
> 
> Ping?
> 
> Do you want me to provide you a git tree for those two patches?
> Do you think it can make it for 3.2 merge window?
> 
Sorry lokks like this indeed got missed :(

I will review this right away and if good will apply :)

-- 
~Vinod

