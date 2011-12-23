Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1LWPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:21:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:18484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab1LWPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:21:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="89777161"
Subject: Re: [PATCH 0/4] dma: mxs-dma: several bugfixes for the MXS DMA
 driver
From: Vinod Koul <vinod.koul@intel.com>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Huang Shijie <b32955@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1323176362.git.LW@KARO-electronics.de>
References: <cover.1323176362.git.LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Dec 2011 20:51:17 +0530
Message-ID: <1324653677.1633.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 09:15 +0100, Lothar Waßmann wrote:
> The following patchset fixes some bugs in the MXS DMA driver.
> 
> Lothar Waßmann (4):
>   fix a typo in comment
>   Always leave mxs_dma_init() with the clock disabled.
>   Using a static variable for counting the number of CCWs attached to
>   Don't use CLKGATE to disable DMA clock.
> 
All Applied, Thanks

-- 
~Vinod

