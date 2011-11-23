Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1KWLcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:32:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:1718 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1KWLcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,557,1315206000"; 
   d="scan'208";a="78341440"
Subject: Re: linux-next: manual merge of the slave-dma tree with the s5p
 tree
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <20111121110837.05684cae0be90d4e7f0df47e@canb.auug.org.au>
References: <20111121110837.05684cae0be90d4e7f0df47e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Nov 2011 16:58:41 +0530
Message-ID: <1322047721.1516.261.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 11:08 +1100, Stephen Rothwell wrote:
> Hi Vinod,
> 
> Today's linux-next merge of the slave-dma tree got a conflict in
> drivers/dma/pl330.c between commit fc0b5cccc8dd ("DMA: PL330: Infer
> transfer direction from transfer request instead of platform data") from
> the s5p tree and commit db8196df4bb6 ("dmaengine: move drivers to
> dma_transfer_direction") from the slave-dma tree.
> 
> The former removed the code modified by the latter, so I did that.

Thanks Stephan,

It seems to be the right fix


-- 
~Vinod

