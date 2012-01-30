Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2A3EAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:00:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:9942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab2A3EAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:00:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117872426"
Subject: Re: How is dmaengine_prep_slave_single supposed to be used?
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4F22B593.3010402@metafoo.de>
References: <4F22B593.3010402@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 09:31:30 +0530
Message-ID: <1327896090.1527.0.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 15:32 +0100, Lars-Peter Clausen wrote:
> Hi,
> 
> I've tried using dmaengine_prep_slave_single in one of my drivers an run
> into an issue, the dma_address attribute of the sg element is not
> initialized and thus the dma transfer and the DMA transfer fails.
> 
> Quoting from Documentation/dmaengine.txt:
> 
>    The peripheral driver is expected to have mapped the scatterlist for
>    the DMA operation prior to calling device_prep_slave_sg, and must
>    keep the scatterlist mapped until the DMA operation has completed.
> 
> So this is clearly not the case with dmaengine_prep_slave_single, so I'm
> wondering how is ut supposed to be used and can it work properly at all?
> 
Yes this is broken now, I will fix this up

-- 
~Vinod

