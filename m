Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2F0NmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:42:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:8594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab2F0NmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116539706"
Subject: Re: [PATCH] dma: tegra: use sg_dma_address() for getting dma
 buffer address
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
In-Reply-To: <4FE4A78F.4090307@wwwdotorg.org>
References: <1340377870-10035-1-git-send-email-ldewangan@nvidia.com>
	 <4FE4A78F.4090307@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jun 2012 19:02:36 +0530
Message-ID: <1340803956.1562.245.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 11:12 -0600, Stephen Warren wrote:
> On 06/22/2012 09:11 AM, Laxman Dewangan wrote:
> > Use the sg_dma_address() to get the segment buffer address for
> > DMA transfer in place of sg_phys() which returns the physical
> > address of an sg entry.
> > The sg_dma_address() returns the correct buffer memory address
> > for DMA transfer.
> 
> It's what everyone else is doing, so:
And this is the right thing to do. 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Applied, thanks

-- 
~Vinod

