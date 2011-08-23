Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1HWHTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:19:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57014 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1HWHT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:19:28 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-1b-4e53547fecb7
Date: Tue, 23 Aug 2011 16:19:27 +0900
From: Boojin Kim <boojin.kim@samsung.com>
Subject: RE: [PATCH] DMA: PL330: add missing header
In-reply-to: <1314081133.22120.19.camel@vkoul-udesk3>
To: "'Koul, Vinod'" <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, "'Kukjin Kim'" <kgene.kim@samsung.com>
Message-id: <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcxhXnG+jtwpRubOTiaOhIY8wWjAZAABlyWw
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
 <1314081133.22120.19.camel@vkoul-udesk3>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Koul, Vinod wrote:
> Sent: Tuesday, August 23, 2011 3:32 PM
> To: Boojin Kim
> Cc: linux-kernel@vger.kernel.org; Kukjin Kim
> Subject: Re: [PATCH] DMA: PL330: add missing header
>
> On Tue, 2011-08-23 at 14:57 +0900, Boojin Kim wrote:
> > This patch fixup below build error
> >
> > drivers/dma/pl330.c: In function 'pl330_prep_slave_sg':
> > drivers/dma/pl330.c:603: error: implicit declaration of function
> 'for_each_sg'
> > drivers/dma/pl330.c:603: error: expected ';' before '{' token
> > drivers/dma/pl330.c:581: warning: unused variable 'flags'
> > drivers/dma/pl330.c: In function 'pl330_probe':
> > drivers/dma/pl330.c:720: warning: comparison of distinct pointer
> types lacks a cast
> > make[2]: *** [drivers/dma/pl330.o] Error 1
> >
> > Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
> > ---
> >  drivers/dma/pl330.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index 00eee59..fcad90c 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/amba/bus.h>
> >  #include <linux/amba/pl330.h>
> > +#include <linux/scatterlist.h>
> >
> >  #define NR_DEFAULT_DESC	16
> >
> Where tree is this error reported? scatterlist.h is already added to
> the
> dmaengine.h
Oops, I founded it just now in your tree.
OK, please kindly drop this.
As a note, since happens build error with latest mainline v3.1-rc3 so that 
should be merged for v3.1.

Thanks
Boojin kim

>
> --
> ~Vinod


