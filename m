Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1ITQqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:46:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:63670 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1ITQqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:46:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,412,1312182000"; 
   d="scan'208";a="50968799"
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
From: Vinod Koul <vinod.koul@intel.com>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <CAF+7xWnQAT+rLTz0tj3j1KyUO4Zq-+V=ggHAJVMROXGWp5FA+w@mail.gmail.com>
References: <1314688104.23734.1.camel@phoenix>
	 <1315228918.26251.78.camel@vkoul-udesk3>
	 <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
	 <1315233379.26251.152.camel@vkoul-udesk3>
	 <CAF+7xWnQAT+rLTz0tj3j1KyUO4Zq-+V=ggHAJVMROXGWp5FA+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 22:12:01 +0530
Message-ID: <1316536921.31295.6.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 21:22 +0800, Axel Lin wrote:
> 2011/9/5 Vinod Koul <vinod.koul@linux.intel.com>:
> > On Mon, 2011-09-05 at 21:32 +0800, Axel Lin wrote:
> >> 2011/9/5 Vinod Koul <vinod.koul@linux.intel.com>:
> >> > On Tue, 2011-08-30 at 15:08 +0800, Axel Lin wrote:
> >> >> Add missing include of linux/module.h to fix build error.
> >> > I don't see this build error in my tree (based on rc4), In which config
> >> > is this seen?
> >> The patch is against linux-next tree.
> >> I got the build error by "make imx_v4_v5_defconfig" on linux-next tree
> >> ( next-20110831 )
> > Sorry I am not able to find it, can you please point me to archives..
> Hi Vinod,
> Currently you can get linux-next tree at
> git://github.com/sfrothwell/linux-next.git
> ( http://linux.f-seidel.de/linux-next/pmwiki/pmwiki.php?n=Linux-next.FAQ )
> 
> I still got below build error in today's linux-next tree.
>   CC      drivers/dma/imx-sdma.o
> drivers/dma/imx-sdma.c:336: warning: data definition has no type or
> storage class
> drivers/dma/imx-sdma.c:336: warning: type defaults to 'int' in
> declaration of 'MODULE_DEVICE_TABLE'
> drivers/dma/imx-sdma.c:336: warning: parameter names (without types)
> in function declaration
> drivers/dma/imx-sdma.c:343: warning: data definition has no type or
> storage class
> drivers/dma/imx-sdma.c:343: warning: type defaults to 'int' in
> declaration of 'MODULE_DEVICE_TABLE'
> drivers/dma/imx-sdma.c:343: warning: parameter names (without types)
> in function declaration
> drivers/dma/imx-sdma.c: In function 'sdma_get_firmware':
> drivers/dma/imx-sdma.c:1193: error: 'THIS_MODULE' undeclared (first
> use in this function)
> drivers/dma/imx-sdma.c:1193: error: (Each undeclared identifier is
> reported only once
> drivers/dma/imx-sdma.c:1193: error: for each function it appears in.)
> drivers/dma/imx-sdma.c: At top level:
> drivers/dma/imx-sdma.c:1457: error: expected declaration specifiers or
> '...' before string constant
> drivers/dma/imx-sdma.c:1457: warning: data definition has no type or
> storage class
> drivers/dma/imx-sdma.c:1457: warning: type defaults to 'int' in
> declaration of 'MODULE_AUTHOR'
> drivers/dma/imx-sdma.c:1457: warning: function declaration isn't a prototype
> drivers/dma/imx-sdma.c:1458: error: expected declaration specifiers or
> '...' before string constant
> drivers/dma/imx-sdma.c:1458: warning: data definition has no type or
> storage class
> drivers/dma/imx-sdma.c:1458: warning: type defaults to 'int' in
> declaration of 'MODULE_DESCRIPTION'
> drivers/dma/imx-sdma.c:1458: warning: function declaration isn't a prototype
> drivers/dma/imx-sdma.c:1459: error: expected declaration specifiers or
> '...' before string constant
> drivers/dma/imx-sdma.c:1459: warning: data definition has no type or
> storage class
> drivers/dma/imx-sdma.c:1459: warning: type defaults to 'int' in
> declaration of 'MODULE_LICENSE'
> drivers/dma/imx-sdma.c:1459: warning: function declaration isn't a prototype
> make[2]: *** [drivers/dma/imx-sdma.o] Error 1
> make[1]: *** [drivers/dma] Error 2
> make: *** [drivers] Error 2
> 
Can you pls send me your .config?
-- 
~Vinod

