Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1HSNPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:15:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:52210 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1HSNP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:15:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,251,1312182000"; 
   d="scan'208";a="43065191"
Subject: Re: [GIT PULL] dmaengine: at_hdmac fixes for next
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4E4E5F52.7070605@atmel.com>
References: <4E4A7713.1070902@atmel.com>
	 <1313758426.2336.2.camel@vkoul-udesk3>  <4E4E5F52.7070605@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 18:45:04 +0530
Message-ID: <1313759704.2336.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 15:04 +0200, Nicolas Ferre wrote:
> Le 19/08/2011 14:53, Koul, Vinod :
> > On Tue, 2011-08-16 at 15:56 +0200, Nicolas Ferre wrote:
> >> Vinod,
> >>
> >> Please pull from:
> >>
> >>   git://github.com/at91linux/linux-2.6-at91.git nfe/sdma_at_hdmac
> >>
> >> to receive latest updates for the Atmel at_hdmac dmaengine driver. Those changes are made on top of current linus' git tree (v3.1-rc2-59-g5bad33c).
> >> The patches below have been discussed on the linux-arm-kernel mailing-list.
> >>
> >> Thanks,
> >>
> >> Nicolas Ferre (4):
> >>       dmaengine: at_hdmac: replace spin_lock* with irqsave variants
> >>       dmaengine: at_hdmac: improve power management routines
> >>       dmaengine: at_hdmac: add wrappers for testing channel state
> >>       dmaengine: at_hdmac: fix way to specify cyclic capability
> >>
> >>  drivers/dma/at_hdmac.c      |  159 +++++++++++++++++++++++++++++++++---------
> >>  drivers/dma/at_hdmac_regs.h |   24 +++++++
> >>  2 files changed, 149 insertions(+), 34 deletions(-)
> >>
> > Hi Nicolas,
> > 
> > I tried to merge your branch, but I also get lot on unwanted commits :(
> > Looks like this branch is based on current Linus's tree, I typically
> > base my next on rc-X and not any random commit.
> 
> Yes, I am sorry for that and realize that it can be a mess for you... I
> will take the habit to cling to a -rcX for my pull requests.
> 
> > Either you can rebase to latest rc-X and I will merge, or since I
> > created a test branch I can extract your 4 patches and apply to my next.
> 
> If you have a test branch close at hand you can extract my patches.
> Thanks for your help.
Okay, Applied, it should be pushing out now :)

yes I always create test branch for applying patches and do a ff merge
to next. That makes my workspace easy to manage and discard if anything
in my checks go wrong


-- 
~Vinod

