Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab2EKIsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:48:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:32770 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab2EKIse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:48:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98884807"
Subject: Re: [PATCH V2 2/2] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4FAB4C7D.7030406@nvidia.com>
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
	 <1336030889-32269-3-git-send-email-ldewangan@nvidia.com>
	 <1336558444.1540.243.camel@vkoul-udesk3>  <4FAA4EA3.70001@nvidia.com>
	 <1336620844.1540.269.camel@vkoul-udesk3>  <4FAB4C7D.7030406@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 14:11:53 +0530
Message-ID: <1336725713.15424.1856.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 10:35 +0530, Laxman Dewangan wrote:

> But when we update the chan->completed_cookie for aborted cookie?
> Otherwise I will get the DMA_IN_PROGRSS when I call dma_cookie_status() 
> but actually it is aborted.
no in .device_tx_status, you should check if the descriptor is aborted
or not and rteurn error for aborted descriptor.


-- 
~Vinod

