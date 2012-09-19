Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2ISCWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 22:22:12 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:27695
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab2ISCWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 22:22:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh87h2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 19 Sep 2012 10:45:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        <alsa-devel@alsa-project.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v3 04/15] dmaengine: Pass flags via
 device_prep_dma_cyclic() callback
Message-ID: <20120919024528.GA6460@S2100-06.ap.freescale.net>
References: <1347624358-25582-1-git-send-email-peter.ujfalusi@ti.com>
 <1347624358-25582-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347624358-25582-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:05:47PM +0300, Peter Ujfalusi wrote:
> Change the parameter list of device_prep_dma_cyclic() so the DMA drivers
> can receive the flags coming from clients.
> This feature can be used during audio operation to disable all audio
> related interrupts when the DMA_PREP_INTERRUPT is cleared from the flags.
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
...
>  drivers/dma/imx-dma.c         | 2 +-
>  drivers/dma/imx-sdma.c        | 2 +-
...
>  drivers/dma/mxs-dma.c         | 2 +-

Acked-by: Shawn Guo <shawn.guo@linaro.org>

