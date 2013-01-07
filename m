Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3AGO6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:58:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:5125 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3AGO6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:58:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,424,1355126400"; 
   d="scan'208";a="273811708"
Date: Mon, 7 Jan 2013 06:33:56 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/16] various fixes and updates for ste_dma40
Message-ID: <20130107143356.GB15804@intel.com>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:21:42PM +0100, Fabio Baltieri wrote:
> Hi all,
> 
> this series contains many fixes and updates for the ste_dma40 driver.
> 
> The first patches of the series were originally sent weeks ago but did not
> receive any feedback, so I'm also resending those, but I've rebased everything
> on top of v3.8-rc2 to avoid a (trivial) file rename conflict.
> 
> Vinod, these should probably end up in the arm-soc tree so they can receive
> some testing from drivers using it.  Can I have your Acked-by for this?
Sure the patchset looks fine by me

Acked-by: Vinod Koul <vinod.koul@intel.com>

> 
> Thanks,
> Fabio
> 
> 
> Fabio Baltieri (7):
>   dmaengine: ste_dma40: add a done queue for completed descriptors
>   dmaengine: ste_dma40: add missing kernel-doc entry
>   dmaengine: ste_dma40: minor cosmetic fixes
>   dmaengine: ste_dma40: minor code readability fixes
>   dmaengine: ste_dma40: add software lli support
>   dmaengine: set_dma40: ignore spurious interrupts
>   dmaengine: set_dma40: balance clock in probe fail code
> 
> Gerald Baeza (2):
>   dmaengine: ste_dma40: support fixed physical channel allocation
>   dmaengine: ste_dma40: physical channels number correction
> 
> Narayanan (1):
>   dmaengine: ste_dma40: reset priority bit for logical channels
> 
> Narayanan G (1):
>   dmaengine: ste_dma40: don't check for pm_runtime_suspended()
> 
> Per Forlin (3):
>   dmaengine: ste_dma40: use writel_relaxed for lcxa
>   dmaengine: ste_dma40: set dma max seg size
>   dmaengine: ste_dma40: limit burst size to 16
> 
> Rabin Vincent (1):
>   dmaengine: ste_dma40: don't allow high priority dest event lines
> 
> Tong Liu (1):
>   dmaengine: ste_dma40: support more than 128 event lines
> 
>  drivers/dma/ste_dma40.c                     | 489 +++++++++++++++++++++-------
>  drivers/dma/ste_dma40_ll.c                  |  29 +-
>  drivers/dma/ste_dma40_ll.h                  | 130 +++++++-
>  include/linux/platform_data/dma-ste-dma40.h |  13 +
>  4 files changed, 518 insertions(+), 143 deletions(-)
> 
> -- 
> 1.7.12.1
> 
