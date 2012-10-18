Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2JRIqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:46:48 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:47628 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab2JRIqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:46:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1202h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah107ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1155h)
Message-ID: <507FC290.10205@freescale.com>
Date: Thu, 18 Oct 2012 16:49:20 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Vinod Koul <vinod.koul@linux.intel.com>, <djbw@fb.com>,
        <khali@linux-fr.org>, <ben-linux@fluff.org>, <w.sang@pengutronix.de>,
        <cjb@laptop.org>, <dwmw2@infradead.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <shawn.guo@linaro.org>,
        <artem.bityutskiy@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        Huang Shijie <shijie8@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: add new DMA control commands
References: <1350538335-29026-1-git-send-email-b32955@freescale.com> <201210180914.58527.marex@denx.de> <507FB495.7050104@freescale.com> <201210181016.06782.marex@denx.de>
In-Reply-To: <201210181016.06782.marex@denx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月18日 16:16, Marek Vasut 写道:
> So we can't stream data from the chip? About time to adjust the MTD framework to
> allow that. Maybe implement a command queue?
>
IMHO, it's not possible. Because the READ-PAGE(00h-30h) command needs to 
check the busy status
which means we have to stop in the middle, so we can not chain the all 
the read-pages DMA commands.

thanks
Huang Shijie


