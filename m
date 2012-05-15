Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982Ab2EODZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:25:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:23405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964926Ab2EODZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 23:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144038420"
Subject: Re: [PATCH 0/3] dmaengine: at_hdmac: slave configuration
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, ludovic.desroches@atmel.com
In-Reply-To: <cover.1336644470.git.nicolas.ferre@atmel.com>
References: <cover.1336644470.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 08:48:34 +0530
Message-ID: <1337051914.16185.5293.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 12:17 +0200, Nicolas Ferre wrote:
> This patch series is composed of two cleanup patches and one "slave
> configuration" patch. The last one uses configuration data passed through the
> slave configuration API to setup the DMA controller.
> Corresponding custom configuration is removed from the slave DMA private
> structure and its use in the AT91 files. Header definitions are then moved
> accordingly.
> 
> Nicolas Ferre (3):
>   dmaengine: at_hdmac: remove some at_dma_slave comments
>   dmaengine: at_hdmac: remove ATC_DEFAULT_CTRLA constant
>   dmaengine: at_hdmac: take maxburst from slave configuration
> 
>  arch/arm/mach-at91/at91sam9g45_devices.c   |    1 -
>  arch/arm/mach-at91/include/mach/at_hdmac.h |   26 --------------------------
>  drivers/dma/at_hdmac.c                     |   15 +++++++--------
>  drivers/dma/at_hdmac_regs.h                |   21 ++++++++++++++++++++-
>  4 files changed, 27 insertions(+), 36 deletions(-)
Applied, Thanks


-- 
~Vinod

