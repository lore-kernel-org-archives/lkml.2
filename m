Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2BOT4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:56:37 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2BOT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:56:35 -0500
Date: Wed, 15 Feb 2012 11:56:28 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, w.sang@pengutronix.de,
        LW@KARO-electronics.de, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mxs-dma : move the mxs dma.h to a more common
 place
Message-ID: <20120215195627.GC2399@r65073-Latitude-D630>
References: <1329110756-14434-1-git-send-email-b32955@freescale.com>
 <1329110756-14434-2-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329110756-14434-2-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 01:25:55PM +0800, Huang Shijie wrote:
> Move the header to a more common place.
> The mxs dma engine is not only used in mx23/mx28, but also used
> in mx50/mx6q.  It will also be used in the future chips.
> 
> Rename it to mxs-dma.h, and create a new folder include/linux/fsl/ to
> store the Freescale's header files.
> 
> change mxs-dma driver, mxs-mmc driver, gpmi-nand driver, mxs-saif driver
> to the new header file.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
