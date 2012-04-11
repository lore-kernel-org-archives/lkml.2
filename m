Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2DKPjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:39:19 -0400
Received: from void.printf.net ([89.145.121.20]:58174 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996Ab2DKPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:39:17 -0400
From: Chris Ball <cjb@laptop.org>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] mmc: remove linux/blkdev.h include from host drivers
References: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
Date: Wed, 11 Apr 2012 11:39:12 -0400
In-Reply-To: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru> (Dmitry
	Artamonow's message of "Tue, 10 Apr 2012 23:06:23 +0400")
Message-ID: <87ty0qs2fz.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha, Wolfram,

On Tue, Apr 10 2012, Dmitry Artamonow wrote:
> I've compile tested everything with and without CONFIG_BLOCK enabled,
> except for imxmmc.c - this driver seems to be long time broken
> (at least since the removal of mach-imx in 2.6.31 - see commit
> 1341d34ffc296f98dc84876f35f3151525dc02a2 ) 

I can confirm that it no longer builds:

/home/cjb/git/mmc/drivers/mmc/host/imxmmc.c:32:26: fatal error: mach/imx-dma.h: No such file or directory

Should imxmmc simply be removed from drivers/mmc/host?  Do any of the
more current i.MX MMC drivers support the same hardware?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
