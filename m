Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2IQJB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:01:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64060 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2IQJB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:01:26 -0400
MIME-Version: 1.0
In-Reply-To: <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
	<1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
Date: Mon, 17 Sep 2012 11:01:23 +0200
Message-ID: <CACRpkdYAxFzPAZgMsdj9C3YVLzMc_w41Xs0SiqX-1DWaZqxAdw@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via
 device_prep_dma_cyclic() callback
From: Linus Walleij <linus.walleij@linaro.org>
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
        Shawn Guo <shawn.guo@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 3:37 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

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

After some discussion with clever people I know I have come to the conclusion
that this is a good idea, so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
