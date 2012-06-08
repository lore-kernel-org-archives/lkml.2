Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2FHFkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:40:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:20774 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468Ab2FHFkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:40:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176561416"
Subject: Re: [PATCH V5 2/2] dma: tegra: add dmaengine based dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org, olof@lixom.net,
        linux-tegra@vger.kernel.org
In-Reply-To: <1338960327-31453-2-git-send-email-ldewangan@nvidia.com>
References: <1338960327-31453-1-git-send-email-ldewangan@nvidia.com>
	 <1338960327-31453-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 11:03:46 +0530
Message-ID: <1339133626.1927.1173.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 10:55 +0530, Laxman Dewangan wrote:
> Add dmaengine based NVIDIA's Tegra APB DMA driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Applied, both Thanks


-- 
~Vinod

