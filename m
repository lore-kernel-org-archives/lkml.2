Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2GMG3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:29:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:36692 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab2GMG3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:29:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="171314420"
Subject: Re: [PATCH 2/2] dma: tegra: fix residual calculation for cyclic
 case
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4FFFB476.9050006@nvidia.com>
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
	 <4FF1C62B.5070005@wwwdotorg.org> <1342149336.1726.5.camel@vkoul-udesk3>
	 <4FFFB476.9050006@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jul 2012 11:58:43 +0530
Message-ID: <1342160923.1726.11.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 11:09 +0530, Laxman Dewangan wrote:
> On Friday 13 July 2012 08:45 AM, Vinod Koul wrote:
> > On Mon, 2012-07-02 at 10:02 -0600, Stephen Warren wrote:
> >> On 07/02/2012 02:22 AM, Laxman Dewangan wrote:
> >>> In cyclic mode of DMA, the byte transferred can be more
> >>> than the requested size and in this case, calculating
> >>> residuals based on the current position of DMA transfer to
> >>> bytes requested i.e. bytes required to transfer to reach
> >>> bytes requested from current DMA position.
> >>>
> >>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> >> This makes sense to me, although I wonder if details like this aren't
> >> something that the dmaengine core should be handling.
> > No core doesn't know anything about the how much you are transferring
> > and where you are. That is the driver to calculate and provide.
> 
> Just for confirmation, are you going to apply this patch or do I need to 
> do anything here.
???

You didnt get my other mail about applying?

-- 
~Vinod

