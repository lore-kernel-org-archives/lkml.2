Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KHQRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:17:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:44365 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab1KHQRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:17:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,477,1315206000"; 
   d="scan'208";a="82468511"
Subject: Re: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
From: Vinod Koul <vinod.koul@linux.intel.com>
To: balbi@ti.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20111108140756.GA20728@legolas.emea.dhcp.ti.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
	 <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
	 <20111108140222.GT6921@legolas.emea.dhcp.ti.com>
	 <20111108140756.GA20728@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 21:42:52 +0530
Message-ID: <1320768772.32205.149.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-08 at 16:07 +0200, Felipe Balbi wrote:
> On Tue, Nov 08, 2011 at 04:02:25PM +0200, Felipe Balbi wrote:
> > On Fri, Oct 14, 2011 at 10:09:09PM +0530, Vinod Koul wrote:
> > > fixup usage of dma direction by introducing dma_transfer_direction,
> > > this patch moves usb/musb driver to use new enum
> > > 
> > > Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > applied, thanks
> 
> I replied too early, this breaks compilation. Please review both
> patches, compile test them at least, and resend Ccing linux-usb and the
> maintainers of musb (myself) and Renesas... to make it easier, run
> scripts/get_maintainer.pl on both patches.
These cant be applied individually as they depends on 1/10 of v1 I had
sent across, that explains your compilation failure.

If you are fine with this, please ACK it and I can carry these thru
slave-dmaengine tree


-- 
~Vinod

