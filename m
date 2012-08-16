Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab2HPJGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:06:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2HPJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:06:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] dma: amba-pl08x: Export pl08x_filter_id
Date: Thu, 16 Aug 2012 09:06:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <1345107396-27079-1-git-send-email-stigge@antcom.de> <20120816090041.GK18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120816090041.GK18957@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208160906.21950.arnd@arndb.de>
X-Provags-ID: V02:K0:kGiYArzYUKRIX1UPbTwYJn4aZz7rZNr5ijQcGBsz1ql
 4OHhfeUCRukpJNTPpI5OKGlSm71hM/QE3bVPLAfsN3gSYOlAHf
 htCc5nfQZcrHr22r5gQOIARZFIOe4fBuXB3liNkxM7HONoDJGm
 wKaSjyc+N3GGGFWHCBKB79drVd9+qJ9TqcajzY0gczMjDIR6bn
 P7gRulU/Xheb1EILG60TjyRQCYBtIJKvmajqctwGLPReb+nNOC
 yMuXUK+rkND+Jvbg+IVHWr6iqN6sdmNriGfTWIrv1kB/AuCrAU
 0q3mEx+rTvr9WphroXo3e8gmLBHLMKHsBOzVO4HOoaA/qR1ELO
 LjtYRguIYemnrJR1ZprU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Russell King - ARM Linux wrote:
> On Thu, Aug 16, 2012 at 10:56:36AM +0200, Roland Stigge wrote:
> > This patch fixes the following when compiling a driver module that uses
> > amba-pl08x:
> > 
> > ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko] undefined!
> > ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_mlc.ko] undefined!
> > 
> > (drivers/mtd/nand/lpc32xx_* are still in l2-mtd.git)
> 
> It is currently intended that this be passed from platform code into
> drivers via platform data, so that drivers can decide which DMA engine
> they wish to make use of.
> 
> See how all the AMBA drivers work in this regard (because they need to
> support more than just a single DMA engine implementation.)

Ah, you're right, I forgot about that. I'll take back my Ack then.

	Arnd
