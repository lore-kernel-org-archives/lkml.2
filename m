Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2JRIt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:49:26 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:36467 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2JRItY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:49:24 -0400
X-Auth-Info: hT30O8S5QNkotNqMnqNnvXFW3ITy4STBOGKqGG5iBAo=
From: Marek Vasut <marex@denx.de>
To: Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH] dma: add new DMA control commands
Date: Thu, 18 Oct 2012 10:49:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Vinod Koul <vinod.koul@linux.intel.com>, djbw@fb.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, cjb@laptop.org,
        dwmw2@infradead.org, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de, shawn.guo@linaro.org,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Huang Shijie <shijie8@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1350538335-29026-1-git-send-email-b32955@freescale.com> <201210181016.06782.marex@denx.de> <507FC290.10205@freescale.com>
In-Reply-To: <507FC290.10205@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210181049.21556.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Huang Shijie,

> 于 2012年10月18日 16:16, Marek Vasut 写道:
> > So we can't stream data from the chip? About time to adjust the MTD
> > framework to allow that. Maybe implement a command queue?
> 
> IMHO, it's not possible. Because the READ-PAGE(00h-30h) command needs to
> check the busy status
> which means we have to stop in the middle, so we can not chain the all
> the read-pages DMA commands.

Can the DMA not branch?

> thanks
> Huang Shijie

Best regards,
Marek Vasut
