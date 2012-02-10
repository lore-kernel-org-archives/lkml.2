Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab2BJQVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:21:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56222 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2BJQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:21:43 -0500
Date: Fri, 10 Feb 2012 08:21:35 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, shijie8@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, LW@KARO-electronics.de,
        alsa-devel@alsa-project.org, b29396@freescale.com
Subject: Re: [PATCH v3 1/2] mxs-dma : move the mxs dma.h to a more common
 place
Message-ID: <20120210162134.GA2723@r65073-Latitude-D630>
References: <1328612075-5825-1-git-send-email-b32955@freescale.com>
 <1328612075-5825-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328612075-5825-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 06:54:34PM +0800, Huang Shijie wrote:
> Move the header to a more common place.
> The mxs dma engine is not only used in mx23/mx28, but also used
> in mx50/mx6q.  It will also be used in the future chips.
> 
> Rename it to mxs-dma.h
> 
> change mxs-dma driver, mxs-mmc driver, gpmi-nand driver, mxs-saif driver
> to the new header file.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/dma/mxs-dma.c                              |    2 +-
>  drivers/mmc/host/mxs-mmc.c                         |    2 +-
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
>  .../include/mach/dma.h => include/linux/mxs-dma.h  |    0
>  sound/soc/mxs/mxs-pcm.c                            |    2 +-
>  sound/soc/mxs/mxs-pcm.h                            |    2 +-
>  sound/soc/mxs/mxs-saif.c                           |    2 +-
>  7 files changed, 6 insertions(+), 6 deletions(-)
>  rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/mxs-dma.h (100%)

I suggested you rename it include/linux/fsl/mxs-dma.h [1].  It seems
you are ignoring the comment.  Can you explain why it's not a
reasonable suggestion?

And Wolfram and Mark told you that you need to Cc subsystem maintainers
to collect their acks [2].  But you are still not Ccing Mark Brown and
Chris Ball for sound/soc/ and drivers/mmc changes.  So you are not
listening.

Regards,
Shawn

[1] http://article.gmane.org/gmane.linux.kernel.mmc/12301
[2] http://article.gmane.org/gmane.linux.alsa.devel/93751
