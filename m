Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1IEOi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:38:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:55399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab1IEOi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:38:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45208867"
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
From: Vinod Koul <vinod.koul@linux.intel.com>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
References: <1314688104.23734.1.camel@phoenix>
	 <1315228918.26251.78.camel@vkoul-udesk3>
	 <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 20:06:19 +0530
Message-ID: <1315233379.26251.152.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-05 at 21:32 +0800, Axel Lin wrote:
> 2011/9/5 Vinod Koul <vinod.koul@linux.intel.com>:
> > On Tue, 2011-08-30 at 15:08 +0800, Axel Lin wrote:
> >> Add missing include of linux/module.h to fix build error.
> > I don't see this build error in my tree (based on rc4), In which config
> > is this seen?
> The patch is against linux-next tree.
> I got the build error by "make imx_v4_v5_defconfig" on linux-next tree
> ( next-20110831 )
Sorry I am not able to find it, can you please point me to archives..

-- 
~Vinod

