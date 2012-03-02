Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2CBUuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:50:55 -0500
Received: from void.printf.net ([89.145.121.20]:32808 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab2CBUuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:50:54 -0500
From: Chris Ball <cjb@laptop.org>
To: Huang Shijie <shijie8@gmail.com>
Cc: "Bityutskiy\, Artem" <artem.bityutskiy@intel.com>,
        Huang Shijie <b32955@freescale.com>,
        "alsa-devel\@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Koul\, Vinod" <vinod.koul@intel.com>,
        "broonie\@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "w.sang\@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd\@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shawn.guo\@linaro.org" <shawn.guo@linaro.org>,
        "lrg\@ti.com" <lrg@ti.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "LW\@KARO-electronics.de" <LW@karo-electronics.de>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
	<4F4D9725.3090100@freescale.com>
	<1330502098.3545.78.camel@sauron.fi.intel.com>
	<4F4DE0E5.8070808@freescale.com>
	<1330516974.3545.104.camel@sauron.fi.intel.com>
	<CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
Date: Fri, 02 Mar 2012 15:50:25 -0500
In-Reply-To: <CAMiH66HmV+58w36DGCt+e=ihTrYUwXf1Cur+678YX2GKcB1-jA@mail.gmail.com>
	(Huang Shijie's message of "Wed, 29 Feb 2012 08:13:15 -0500")
Message-ID: <m2mx7yn2we.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 29 2012, Huang Shijie wrote:
>> Pushed both to l2-mtd.git tree, thanks. I am worried that it touches
>> other subsystems like dma, sound, and mmc and there are no acks for
>> those. Would be nice to get them somehow.
>
> I ever thought Vinod could accept this patch set.
>
> To Vinod & Chris:
>       Could you give the ack to the first patch?

Yes -- for the first patch:

Acked-by: Chris Ball <cjb@laptop.org>

(I think Shawn's ACK is sufficient for the second patch.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
