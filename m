Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2IRIcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:32:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34860 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2IRIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:32:29 -0400
Date: Tue, 18 Sep 2012 09:31:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
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
        Vista Silicon <javier.martin@vista-silicon.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via
	device_prep_dma_cyclic() callback
Message-ID: <20120918083146.GE12445@n2100.arm.linux.org.uk>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-5-git-send-email-peter.ujfalusi@ti.com> <CACRpkdYAxFzPAZgMsdj9C3YVLzMc_w41Xs0SiqX-1DWaZqxAdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYAxFzPAZgMsdj9C3YVLzMc_w41Xs0SiqX-1DWaZqxAdw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 11:01:23AM +0200, Linus Walleij wrote:
> On Thu, Sep 13, 2012 at 3:37 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
> > Change the parameter list of device_prep_dma_cyclic() so the DMA drivers
> > can receive the no_wakeup request coming from client drivers.
> > This feature can be used during audio operation to disable all audio
> > related interrupts.
> >
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > CC: Nicolas Ferre <nicolas.ferre@atmel.com>
> > CC: Barry Song <baohua.song@csr.com>
> > CC: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> > CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > CC: Vista Silicon <javier.martin@vista-silicon.com>
> > CC: Zhangfei Gao <zhangfei.gao@marvell.com>
> > CC: Shawn Guo <shawn.guo@linaro.org>
> > CC: Laxman Dewangan <ldewangan@nvidia.com>
> 
> After some discussion with clever people I know I have come to the conclusion
> that this is a good idea, so:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

NAKed-by: me

If you look at the other sub-threads of the patch you're acking, you'll
notice that there's a v3 of this patch set which changes the way this is
done.
