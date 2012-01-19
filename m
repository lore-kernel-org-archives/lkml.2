Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2ASMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:52:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53060 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2ASMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:52:40 -0500
Date: Thu, 19 Jan 2012 21:04:06 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, shijie8@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, LW@KARO-electronics.de,
        alsa-devel@alsa-project.org, b29396@freescale.com
Subject: Re: [PATCH 01/10] MXS-DMA : move the mxs-dma.h to a more common place
Message-ID: <20120119130404.GI2247@S2101-09.ap.freescale.net>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
 <1326953767-24155-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326953767-24155-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:15:58PM +0800, Huang Shijie wrote:
> Move the header to a more common place.
> The DMA engine is not only used in mx23/mx28, but also used
> in mx50/mx6q.
> It will also be used in the future chips.
> 
> Rename it to mxs-dma.h
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  arch/arm/mach-mxs/include/mach/dma.h |   28 ----------------------------
>  include/linux/mxs-dma.h              |   28 ++++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+), 28 deletions(-)
>  delete mode 100644 arch/arm/mach-mxs/include/mach/dma.h
>  create mode 100644 include/linux/mxs-dma.h
> 
I'm wondering if it would be better to create folder include/linux/fsl
for mxs-dma.h accommodation, so that any headers that need to shared
between mxs and imx later can find a place.  Considering that Freescale
has many IPs shared between MPCxxx (PowerPC) and i.MX (ARM) families,
it could also be a good place for any headers that need to be shared
between these two product lines from Freescale.

-- 
Regards,
Shawn
