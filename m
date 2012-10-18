Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2JRPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:11:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38811 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab2JRPLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <201210181251.15116.marex@denx.de>
References: <1350538335-29026-1-git-send-email-b32955@freescale.com>
	<201210181049.21556.marex@denx.de>
	<507FC827.40601@freescale.com>
	<201210181251.15116.marex@denx.de>
Date: Thu, 18 Oct 2012 11:11:15 -0400
Message-ID: <CAMiH66HCDLZaxXckQz1bfqscNm2X2480HTr4bFHdJNteDLb=ig@mail.gmail.com>
Subject: Re: [PATCH] dma: add new DMA control commands
From: Huang Shijie <shijie8@gmail.com>
To: Marek Vasut <marex@denx.de>
Cc: Huang Shijie <b32955@freescale.com>,
        Vinod Koul <vinod.koul@linux.intel.com>, djbw@fb.com,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        cjb@laptop.org, dwmw2@infradead.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        shawn.guo@linaro.org, artem.bityutskiy@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 6:51 AM, Marek Vasut <marex@denx.de> wrote:
> Dear Huang Shijie,
>
>> 于 2012年10月18日 16:49, Marek Vasut 写道:
>> > Dear Huang Shijie,
>> >
>> >> 于 2012年10月18日 16:16, Marek Vasut 写道:
>> >>> So we can't stream data from the chip? About time to adjust the MTD
>> >>> framework to allow that. Maybe implement a command queue?
>> >>
>> >> IMHO, it's not possible. Because the READ-PAGE(00h-30h) command needs to
>> >> check the busy status
>> >> which means we have to stop in the middle, so we can not chain the all
>> >> the read-pages DMA commands.
>> >
>> > Can the DMA not branch?
>>
>> it's too complicated to the MTD layer, as well as the gpmi driver.
>
> Can you please elaborate ?
could you read the nand spec about how to read a page out with the
READ-PAGE(00-30) command,
and tell me how to make the DMA branch?
I really have no idea about how to make the DMA branch.

thanks
Huang Shijie
.


> Best regards,
> Marek Vasut
