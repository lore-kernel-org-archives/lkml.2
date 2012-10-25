Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab2JYIVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:21:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2JYIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:21:42 -0400
Subject: Re: [PATCHv3 0/6] dw_dmac: few cleanups to the driver
From: Vinod Koul <vkoul@infradead.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: vinod.koul@intel.com, Viresh Kumar <viresh.linux@gmail.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        balbi@ti.com
In-Reply-To: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1350570852-10398-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Oct 2012 13:36:59 +0530
Message-ID: <1351152419.7077.10.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 17:34 +0300, Andy Shevchenko wrote:
> There are few cleanups to the driver which partialy acked and reviewed.
> 
> Since v2:
>  - add one more clean up (patch 6/6)
>  - make a separate patch to WARN a user in dwc_handle_error (suggested by
>    Felipe Balbi)
>  - add a description to patch 4/6
> 
> Andy Shevchenko (4):
>   dw_dmac: change dev_printk() to corresponding macros
>   dw_dmac: don't call platform_get_drvdata twice
>   dw_dmac: change dev_crit to dev_WARN in dwc_handle_error
>   dw_dmac: introduce to_dw_desc() macro
> 
> Heikki Krogerus (2):
>   dmaengine: dw_dmac: remove CLK dependency
>   dmaengine: dw_dmac: amend description and indentation
> 
>  drivers/dma/Kconfig        |    1 -
>  drivers/dma/dw_dmac.c      |   33 ++++++++++++++-------------------
>  drivers/dma/dw_dmac_regs.h |    2 ++
>  3 files changed, 16 insertions(+), 20 deletions(-)
> 

Applied thanks

-- 
Vinod Koul
Intel Corp.

