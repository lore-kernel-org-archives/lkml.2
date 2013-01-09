Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3AIQIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:08:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:32029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab3AIQI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:08:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,438,1355126400"; 
   d="scan'208";a="274931440"
Date: Wed, 9 Jan 2013 07:44:11 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [resend][PATCH 00/16] dw_dmac related patchset
Message-ID: <20130109154411.GU19691@intel.com>
References: <20130108155423.GJ19691@intel.com>
 <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357719435-29955-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:16:59AM +0200, Andy Shevchenko wrote:
> There is a patchset against dw_dmac driver. It has been resent for Vinod to
> review after he returned back from vacation and holidays. That's why there is
> no Cc list.
Applied these:
21fe3c5 dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
f5c6a7d dw_dmac: update tx_node_active in dwc_do_single_block
21e93c1 dw_dmac: remove redundant check
cbd6531 dw_dmac: check for mapping errors
123de54 dw_dmac: absence of pdata isn't critical when autocfg is set

2, 9, 11(after fixing changelog) failed, possibly due to dependecy in series

> 
> Andy Shevchenko (15):
>   dw_dmac: call .probe after we have a device in place
>   dw_dmac: absence of pdata isn't critical when autocfg is set
>   dmaengine: introduce is_slave_xfer function
>   dma: at_hdmac: check direction properly for cyclic transfers
>   dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
>   dma: ep93xx_dma: reuse is_slave_xfer helper
>   dma: ipu_idmac: reuse is_slave_xfer helper
>   dma: ste_dma40: reuse is_slave_xfer helper
>   dw_dmac: store direction in the custom channel structure
>   dw_dmac: make usage of dw_dma_slave optional
>   dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
>   dw_dmac: check for mapping errors
>   dw_dmac: remove redundant check
>   dw_dmac: update tx_node_active in dwc_do_single_block
>   dma: dw_dmac: add dwc_chan_pause and dwc_chan_resume
> 
> Heikki Krogerus (1):
>   dma: dw_dmac: clear suspend bit during termination
> 
>  drivers/dma/at_hdmac.c      |   10 +--
>  drivers/dma/dw_dmac.c       |  152 +++++++++++++++++++++++++++++--------------
>  drivers/dma/dw_dmac_regs.h  |   17 +++--
>  drivers/dma/ep93xx_dma.c    |    3 +-
>  drivers/dma/ipu/ipu_idmac.c |    2 +-
>  drivers/dma/ste_dma40.c     |    2 +-
>  include/linux/dmaengine.h   |    5 ++
>  7 files changed, 123 insertions(+), 68 deletions(-)
> 
> -- 
> 1.7.10.4
> 
