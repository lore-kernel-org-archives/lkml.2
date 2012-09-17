Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2IQGfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 02:35:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2IQGen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 02:34:43 -0400
Date: Mon, 17 Sep 2012 14:34:53 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Barry Song <baohua.song@csr.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vista Silicon <javier.martin@vista-silicon.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via
 device_prep_dma_cyclic() callback
Message-ID: <20120917063451.GB6413@S2101-09.ap.freescale.net>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
 <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:37:54PM +0300, Peter Ujfalusi wrote:
> Change the parameter list of device_prep_dma_cyclic() so the DMA drivers
> can receive the no_wakeup request coming from client drivers.
> This feature can be used during audio operation to disable all audio
> related interrupts.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Nicolas Ferre <nicolas.ferre@atmel.com>
> CC: Barry Song <baohua.song@csr.com>
> CC: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
> CC: Vista Silicon <javier.martin@vista-silicon.com>
> CC: Zhangfei Gao <zhangfei.gao@marvell.com>
> CC: Shawn Guo <shawn.guo@linaro.org>
> CC: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/dma/at_hdmac.c        | 3 ++-
>  drivers/dma/ep93xx_dma.c      | 4 +++-
>  drivers/dma/imx-dma.c         | 2 +-
>  drivers/dma/imx-sdma.c        | 2 +-
>  drivers/dma/mmp_tdma.c        | 2 +-
>  drivers/dma/mxs-dma.c         | 2 +-
>  drivers/dma/omap-dma.c        | 3 ++-
>  drivers/dma/pl330.c           | 2 +-
>  drivers/dma/sa11x0-dma.c      | 2 +-
>  drivers/dma/sirf-dma.c        | 2 +-
>  drivers/dma/ste_dma40.c       | 3 ++-
>  drivers/dma/tegra20-apb-dma.c | 2 +-
>  include/linux/dmaengine.h     | 5 +++--
>  13 files changed, 20 insertions(+), 14 deletions(-)
> 
API changes without updating users?

Regards,
Shawn
