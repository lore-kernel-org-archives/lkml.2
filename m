Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab2GMD24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:28:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:31615 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2GMD2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:28:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165242306"
Subject: Re: [PATCH 2/2] dma: tegra: fix residual calculation for cyclic
 case
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, dan.j.williams@intel.com,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
In-Reply-To: <4FF1C62B.5070005@wwwdotorg.org>
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com>
	 <4FF1C62B.5070005@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jul 2012 08:45:36 +0530
Message-ID: <1342149336.1726.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 10:02 -0600, Stephen Warren wrote:
> On 07/02/2012 02:22 AM, Laxman Dewangan wrote:
> > In cyclic mode of DMA, the byte transferred can be more
> > than the requested size and in this case, calculating
> > residuals based on the current position of DMA transfer to
> > bytes requested i.e. bytes required to transfer to reach
> > bytes requested from current DMA position.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> This makes sense to me, although I wonder if details like this aren't
> something that the dmaengine core should be handling.
No core doesn't know anything about the how much you are transferring
and where you are. That is the driver to calculate and provide.

-- 
~Vinod

