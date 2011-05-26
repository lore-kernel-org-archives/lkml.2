Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1EZFLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:11:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:28218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1EZFLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,271,1304319600"; 
   d="scan'208";a="9045259"
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
In-Reply-To: <20110525190055.GB2996@acer>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
	 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
	 <1306310403.30236.94.camel@vkoul-udesk3>  <20110525190055.GB2996@acer>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 10:08:10 +0530
Message-ID: <1306384690.30236.202.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 00:30 +0530, Mika Westerberg wrote:
> On Wed, May 25, 2011 at 01:30:03PM +0530, Koul, Vinod wrote:
> > 
> > Which tree are these patches going thru?
> 
> I was hoping that the dmaengine driver itself would go via dmaengine tree (is
> it you or Dan who maintain it?) and rest of the patches probably through their
> respective trees. However, since there are dependencies between the patches,
> I'm not entirely sure how to proceed with these. Any ideas appreciated :)
Okay, I can take the DMA one only. 
It stoo late for .40, I can take it for .41 or whatever that turns out to be 

> Fortunately arch/arm/configs/ep93xx_defconfig doesn't have audio nor SPI
> enabled by default so it shouldn't matter if the patches go out of order to
> the mainline.

-- 
~Vinod

