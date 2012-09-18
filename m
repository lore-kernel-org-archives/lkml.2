Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab2IRMXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 08:23:08 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54584 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab2IRMXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 08:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <1347958810.1943.176.camel@vkoul-udesk3>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
	<1347543485-339-5-git-send-email-peter.ujfalusi@ti.com>
	<CACRpkdYAxFzPAZgMsdj9C3YVLzMc_w41Xs0SiqX-1DWaZqxAdw@mail.gmail.com>
	<20120918083146.GE12445@n2100.arm.linux.org.uk>
	<1347958810.1943.176.camel@vkoul-udesk3>
Date: Tue, 18 Sep 2012 14:22:59 +0200
Message-ID: <CACRpkdbphfZ+Q9L1H3x_cs_nxjYYg4xuerOHJzzdkogsKu948Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] dmaengine: Pass no_wakeup parameter via
 device_prep_dma_cyclic() callback
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Dan Williams <djbw@fb.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 11:00 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> On Tue, 2012-09-18 at 09:31 +0100, Russell King - ARM Linux wrote:
>> On Mon, Sep 17, 2012 at 11:01:23AM +0200, Linus Walleij wrote:
>> > On Thu, Sep 13, 2012 at 3:37 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
>> >
>> > After some discussion with clever people I know I have come to the conclusion
>> > that this is a good idea, so:
>> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> NAKed-by: me
>>
>> If you look at the other sub-threads of the patch you're acking, you'll
>> notice that there's a v3 of this patch set which changes the way this is
>> done.
>
> Was it a genuine mistake, think v3 reply v2? Or less caffeine..... :)

I think both, stupid me.
Ack on v3 indeed, I was probably fooled by some gmail autothreading, grrr.

Yours,
Linus Walleij
