Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2GaGrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:47:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:62633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab2GaGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="173465675"
Subject: Re: [PATCH V2] dma: tegra: enable/disable dma clock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <50124D54.3020405@nvidia.com>
References: <1342771268-5252-1-git-send-email-ldewangan@nvidia.com>
	 <1343106498.1726.5974.camel@vkoul-udesk3> <500E2BE0.7060602@nvidia.com>
	 <50124D54.3020405@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jul 2012 12:18:44 +0530
Message-ID: <1343717324.1726.14410.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 13:42 +0530, Laxman Dewangan wrote:
> On Tuesday 24 July 2012 10:30 AM, Laxman Dewangan wrote:
> > On Tuesday 24 July 2012 10:38 AM, Vinod Koul wrote:
> >> On Fri, 2012-07-20 at 13:31 +0530, Laxman Dewangan wrote:
> >>> Enable the DMA clock when allocating channel and
> >>> disable clock when freeing channels.
> >>>
> >>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> >>> ---
> >>> +	clk_disable_unprepare(tdma->dma_clk);
> >> What if another channel is active, disabling clock can cause bad
> >> behavior. You should check here if all channels are idle and then
> >> disable, or is this handled by clock API?
> > Yes, clock driver keeps the reference count and so client driver need
> > not to take care.
> >
> Hi Vinod,
> Is there any thing remaining from my side here?
Nope, I will take care of it
> Is it possible to make it for K3.6?
Nope 3.6 is released, too late for that

-- 
~Vinod

