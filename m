Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab1DZEie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:38:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:54602 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1DZEid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="425446811"
Subject: Re: [PATCH v2 1/5] dmaengine: at_hdmac: modify way to use
 interrupts
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1303790574.896.11.camel@vkoul-udesk3>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
	 <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
	 <1303790574.896.11.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:36:56 +0530
Message-ID: <1303790816.896.12.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 09:32 +0530, Koul, Vinod wrote:
> On Fri, 2011-04-22 at 19:41 +0200, Nicolas Ferre wrote:
> > Now we use Buffer Transfer Completed interrupts. If we
> > want a chained buffer completed information, we setup the
> > ATC_IEN bit in CTRLB register in the lli.
> > This is done by set_desc_eol() function and used by
> > memcpy/slave_sg functions.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  drivers/dma/at_hdmac.c      |    4 ++--
> >  drivers/dma/at_hdmac_regs.h |   11 ++++++++---
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> >  
> Looks like your forgot to run checkpatch
> WARNING: line over 80 characters
> #401: FILE: drivers/dma/at_hdmac_regs.h:106:
> +#define MEM_IF			0		/* specify AHB interface 0 as memory interface */
> 
> WARNING: line over 80 characters
> #402: FILE: drivers/dma/at_hdmac_regs.h:107:
> +#define PER_IF			1		/* specify AHB interface 1 as peripheral interface
> */
> 
> WARNING: line over 80 characters
> #689: FILE: drivers/dma/at_hdmac.c:899:
> +			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
> 
> total: 0 errors, 3 warnings, 465 lines checked
> 
> While I am okay with 3rd one, you can easily reformat code for first two
> and avoid these two warnings...
> 
And your 4th patch fails to apply on my tree, please rebase these to my
tree as well

-- 
~Vinod

