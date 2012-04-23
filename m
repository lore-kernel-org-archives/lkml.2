Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2DWM1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:27:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:58147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab2DWM1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144833158"
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rmk <rmk@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
In-Reply-To: <4F95483F.5020005@nvidia.com>
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>
	 <1334920487.31825.98.camel@vkoul-udesk3>  <4F9153AF.7020901@nvidia.com>
	 <1335170491.31825.104.camel@vkoul-udesk3>  <4F95483F.5020005@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 17:53:39 +0530
Message-ID: <1335183819.31825.110.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 17:47 +0530, Laxman Dewangan wrote:
> Hi Russell,
> On Monday 23 April 2012 02:11 PM, Vinod Koul wrote:
> > On Fri, 2012-04-20 at 17:46 +0530, Laxman Dewangan wrote:
> >> Thanks Vinod for quick review.
> > Since I was on vacation, I hadn't noticed Russell has already sent the
> > patches for omap dma support.
> > http://permalink.gmane.org/gmane.linux.ports.arm.omap/75034
> >
> > It would be nice if both the efforts are coordinated.
> >
> > Btw I like the virtual channel support introduced by Russell
> >
> 
> Can you please point me the virtual channel related change? I am not 
> able to locate this like search for function vchan_* ().
> My driver is also on same line but not used vchan_* and also having 
> support for cyclic transfer.
See the patch 3/8 in this series


-- 
~Vinod

