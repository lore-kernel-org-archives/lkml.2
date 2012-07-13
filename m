Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab2GMDW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:22:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:34016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab2GMDWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:22:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176763712"
Subject: Re: linux-next: manual merge of the slave-dma tree with the arm
 tree
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhangfei Gao <zhangfei.gao@marvell.com>, Leo Yan <leoy@marvell.com>,
        Qiao Zhou <zhouqiao@marvell.com>, Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20120702131645.a318e0db6ee778718b6de271@canb.auug.org.au>
References: <20120702131645.a318e0db6ee778718b6de271@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Jul 2012 08:39:02 +0530
Message-ID: <1342148942.1726.0.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 13:16 +1000, Stephen Rothwell wrote:
> Hi Vinod,
> 
> Today's linux-next merge of the slave-dma tree got conflicts in
> drivers/dma/Kconfig and drivers/dma/Makefile between commit 06dba53e6fcf
> ("dmaengine: add OMAP DMA engine driver") from the arm tree and commit
> c6da0ba8dfc8 ("dmaengine: mmp_tdma: add mmp tdma support") from the
> slave-dma tree.
Thanks, Looks like Russell has merged the OMAP changes into his tree?


-- 
~Vinod

