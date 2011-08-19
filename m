Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1HSMys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:54:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:26945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1HSMyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:54:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40031720"
Subject: Re: [GIT PULL] dmaengine: at_hdmac fixes for next
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <4E4A7713.1070902@atmel.com>
References: <4E4A7713.1070902@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Aug 2011 18:23:46 +0530
Message-ID: <1313758426.2336.2.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 15:56 +0200, Nicolas Ferre wrote:
> Vinod,
> 
> Please pull from:
> 
>   git://github.com/at91linux/linux-2.6-at91.git nfe/sdma_at_hdmac
> 
> to receive latest updates for the Atmel at_hdmac dmaengine driver. Those changes are made on top of current linus' git tree (v3.1-rc2-59-g5bad33c).
> The patches below have been discussed on the linux-arm-kernel mailing-list.
> 
> Thanks,
> 
> Nicolas Ferre (4):
>       dmaengine: at_hdmac: replace spin_lock* with irqsave variants
>       dmaengine: at_hdmac: improve power management routines
>       dmaengine: at_hdmac: add wrappers for testing channel state
>       dmaengine: at_hdmac: fix way to specify cyclic capability
> 
>  drivers/dma/at_hdmac.c      |  159 +++++++++++++++++++++++++++++++++---------
>  drivers/dma/at_hdmac_regs.h |   24 +++++++
>  2 files changed, 149 insertions(+), 34 deletions(-)
> 
Hi Nicolas,

I tried to merge your branch, but I also get lot on unwanted commits :(
Looks like this branch is based on current Linus's tree, I typically
base my next on rc-X and not any random commit.

Either you can rebase to latest rc-X and I will merge, or since I
created a test branch I can extract your 4 patches and apply to my next.

Let me know which way you prefer


-- 
~Vinod

