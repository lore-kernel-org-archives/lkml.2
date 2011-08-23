Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1HWIQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:16:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:56901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab1HWIQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:16:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,267,1312182000"; 
   d="scan'208";a="44117967"
Subject: RE: [PATCH] DMA: PL330: add missing header
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Boojin Kim <boojin.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>
In-Reply-To: <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
	 <1314081133.22120.19.camel@vkoul-udesk3>
	 <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 13:45:42 +0530
Message-ID: <1314087342.22120.100.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 16:19 +0900, Boojin Kim wrote:
> Koul, Vinod wrote:
> > Sent: Tuesday, August 23, 2011 3:32 PM
> > To: Boojin Kim
> > Cc: linux-kernel@vger.kernel.org; Kukjin Kim
> > Subject: Re: [PATCH] DMA: PL330: add missing header
> >
> > On Tue, 2011-08-23 at 14:57 +0900, Boojin Kim wrote:
> > > This patch fixup below build error
> > >
> > > drivers/dma/pl330.c: In function 'pl330_prep_slave_sg':
> > > drivers/dma/pl330.c:603: error: implicit declaration of function
> > 'for_each_sg'
> > > drivers/dma/pl330.c:603: error: expected ';' before '{' token
> > > drivers/dma/pl330.c:581: warning: unused variable 'flags'
> > > drivers/dma/pl330.c: In function 'pl330_probe':
> > > drivers/dma/pl330.c:720: warning: comparison of distinct pointer
> > types lacks a cast
> > > make[2]: *** [drivers/dma/pl330.o] Error 1
> > >
> > > Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> > > ---
> > >  drivers/dma/pl330.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > > index 00eee59..fcad90c 100644
> > > --- a/drivers/dma/pl330.c
> > > +++ b/drivers/dma/pl330.c
> > > @@ -17,6 +17,7 @@
> > >  #include <linux/interrupt.h>
> > >  #include <linux/amba/bus.h>
> > >  #include <linux/amba/pl330.h>
> > > +#include <linux/scatterlist.h>
> > >
> > >  #define NR_DEFAULT_DESC	16
> > >
> > Where tree is this error reported? scatterlist.h is already added to
> > the
> > dmaengine.h
> Oops, I founded it just now in your tree.
> OK, please kindly drop this.
> As a note, since happens build error with latest mainline v3.1-rc3 so that 
> should be merged for v3.1.
Russell had fixed compilation of pl330 driver, and was supposed to send
the fix to Linus as part of his fixes. If thats not done I can send it
for next -rc


-- 
~Vinod

