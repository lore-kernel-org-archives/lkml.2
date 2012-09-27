Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2I0KLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:11:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:4234 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab2I0KLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:11:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,495,1344236400"; 
   d="scan'208";a="197859241"
Subject: Re: [PATCHv2 0/6] dw_dmac: introduce autoconfiguration
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
In-Reply-To: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 15:35:44 +0530
Message-ID: <1348740344.1648.26.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 15:05 +0300, Andy Shevchenko wrote:
> Here is a patchset that allows to adapt the driver to the hardware
> configuration during probe time. The hardware should have the specific optional
> parameters enabled. Otherwise the driver will consider values stored in the
> platform data.
> 
> Additionally it brings support of the software LLP transfers. It means that
> normal linked list transfer is substituted by set of single block transfers
> transparently to the user.
> 
> Since v1:
>  - addressed all Viresh's comments.
Applied all, Thanks

> 
> Andy Shevchenko (6):
>   dw_dmac: mark dwc_dump_chan_regs as inline
>   dw_dmac: fill optional encoded parameters in register structure
>   dw_dmac: get number of channels from hardware if possible
>   dw_dmac: autoconfigure block_size or use platform data
>   dw_dmac: autoconfigure data_width or get it via platform data
>   dw_dmac: introduce software emulation of LLP transfers
> 
>  arch/arm/mach-spear13xx/spear13xx.c |    3 +
>  arch/avr32/mach-at32ap/at32ap700x.c |    3 +
>  drivers/dma/dw_dmac.c               |  209 +++++++++++++++++++++++++++++------
>  drivers/dma/dw_dmac_regs.h          |   46 ++++++++
>  include/linux/dw_dmac.h             |    7 ++
>  5 files changed, 235 insertions(+), 33 deletions(-)
> 


-- 
~Vinod

