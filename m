Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab1J1EMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 00:12:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:7081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab1J1EMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 00:12:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="68427986"
Subject: RE: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E98419F7FF@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
	 <1319703535.20054.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E98419F7FF@SHAASIEXM01.ASIA.ROOT.PRI>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 09:39:42 +0530
Message-ID: <1319774982.20054.228.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 01:49 +0000, Barry Song wrote:
> > Also, Please ensure you send patches which compile with ZERO warnings:
> > drivers/dma/sirf-dma.c: In function 'sirfsoc_dma_probe':
> > drivers/dma/sirf-dma.c:616: warning: assignment from incompatible pointer
> > type
> > drivers/dma/sirf-dma.c:617: warning: assignment from incompatible pointer
> > type
> > which comes from the fact that your prep_interleaved_dma does not have
> > last argument of flags.
> > On the second one you have not rebased to patch from Jassi which I
> > applied after converting direction stuff.
> 
> 
[pls wrap 80chars within paragraphs, i have reformatted below)
> I rebased to both yours and Jassi by my merging manually. I remember
> you have changed the last param of device_prep_dma_cyclic from
> dma_data_direction to dma_transfer_direction. After checking the tree
> interleaved_dma @ git://git.infradead.org/users/vkoul/slave-dma.git,
> it doesn't. then make another compiling warning in
> sirfsoc_dma_prep_cyclic(). so I'll still use dma_data_direction in
> sirfsoc_dma_prep_cyclic().
Yes for cyclic, I have missed to fix that. I will push the fixed version
now

-- 
~Vinod

