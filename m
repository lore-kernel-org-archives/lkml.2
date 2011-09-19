Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab1ISNyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:54:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:41264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab1ISNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:54:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50117392"
Date: Mon, 19 Sep 2011 15:56:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        gadiyar@ti.com, parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        paul@pwsan.com, johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 0/5 v9] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
Message-ID: <20110919135653.GR32263@sortiz-mobl>
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keshava,

On Thu, Sep 15, 2011 at 06:52:45PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
> 
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
> 
> these patches are rebased to kevin's pm branch and
> usbhs latest mainline kernel patches

I'm ready to apply this one to my MFD for-next branch. Or do you want it to go
through Kevin's tree ?

Cheers,
Samuel

 
> TODO:
>    - Adding pad configurations to Hwmods
>    - Aggressive clock cutting in usb bus suspends
>    - Remote Wakeup implementation using irq-chaining
> 
> 
> Benoit Cousson (1):
>   arm: omap: usb: ehci and ohci hwmod structures for omap4
> 
> Keshava Munegowda (4):
>   arm: omap: usb: ehci and ohci hwmod structures for omap3
>   arm: omap: usb: register hwmods of usbhs
>   arm: omap: usb: device name change for the clk names of usbhs
>   mfd: omap: usb: Runtime PM support
> 
>  arch/arm/mach-omap2/clock3xxx_data.c       |   26 +-
>  arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  281 +++++++++++
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247 ++++++++++
>  arch/arm/mach-omap2/usb-host.c             |  114 ++---
>  arch/arm/plat-omap/include/plat/usb.h      |    3 -
>  drivers/mfd/omap-usb-host.c                |  733 +++++++++++-----------------
>  drivers/usb/host/ehci-omap.c               |   17 +-
>  drivers/usb/host/ohci-omap3.c              |   18 +-
>  9 files changed, 891 insertions(+), 558 deletions(-)
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
