Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1LVFNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:13:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:22150 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1LVFN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:13:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="90264971"
Subject: Re: [PATCH 0/4] Fix the left DMA_NONE from dma_transfer_direction
 migration
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Artem Bityutskiy <artem.bityutskiy@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111221045805.GE5983@S2101-09.ap.freescale.net>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
	 <1324373044.1641.10096.camel@vkoul-udesk3>
	 <20111220125401.GA5129@S2101-09.ap.freescale.net>
	 <1324440424.1641.10104.camel@vkoul-udesk3>
	 <20111221044517.GD5983@S2101-09.ap.freescale.net>
	 <1324442451.1641.10109.camel@vkoul-udesk3>
	 <20111221045805.GE5983@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Dec 2011 10:43:22 +0530
Message-ID: <1324530802.1641.10123.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 12:58 +0800, Shawn Guo wrote:
> On Wed, Dec 21, 2011 at 10:10:51AM +0530, Vinod Koul wrote:
> > On Wed, 2011-12-21 at 12:45 +0800, Shawn Guo wrote:
> > > > 
> > > The term PIO here may not the one on your mind.  I call it 'mxs-dma
> > > pio'.  In this mode, mxs-dma hardware can write values into mmc
> > > controller register without cpu involved.
> > what do you mean by values here?
> > 
> The register values that we want to write to mmc controller registers
> in this case.
Okay I am going to put this in my queue as this is fixing a regression
But, I still don't agree that DMA_NONE as a direction is the correct way
to tell dma driver about this. Perhaps we need to find a better
mechanism.


-- 
~Vinod

