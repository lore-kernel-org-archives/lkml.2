Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1IUGOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:14:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:52527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab1IUGN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:13:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,415,1312182000"; 
   d="scan'208";a="56019824"
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
From: Vinod Koul <vinod.koul@intel.com>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <CAF+7xWnkzfX7kWy5K-cHExkYZ-FS8zPXZsjqr2Gu1becbDvRyA@mail.gmail.com>
References: <1314688104.23734.1.camel@phoenix>
	 <1315228918.26251.78.camel@vkoul-udesk3>
	 <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
	 <1315233379.26251.152.camel@vkoul-udesk3>
	 <CAF+7xWnQAT+rLTz0tj3j1KyUO4Zq-+V=ggHAJVMROXGWp5FA+w@mail.gmail.com>
	 <1316536921.31295.6.camel@vkoul-udesk3>
	 <CAF+7xWnkzfX7kWy5K-cHExkYZ-FS8zPXZsjqr2Gu1becbDvRyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 11:39:46 +0530
Message-ID: <1316585386.1573.0.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 07:50 +0800, Axel Lin wrote:
> > Can you pls send me your .config?
> I got the error by "make imx_v4_v5_defconfig; make"
> 
> It's available in arch/arm/configs/imx_v4_v5_defconfig.
Applied, Thanks

-- 
~Vinod

