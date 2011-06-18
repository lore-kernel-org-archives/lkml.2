Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1FRQ3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 12:29:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43198 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1FRQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 12:29:30 -0400
Date: Sat, 18 Jun 2011 10:29:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org
Subject: Re: [PATCH 0/3] Add basic device support for imx51 babbage
Message-ID: <20110618162927.GM8195@ponder.secretlab.ca>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 11:19:11PM +0800, Shawn Guo wrote:
> This patch set adds the basic device tree support for imx51 babbage
> board.  With uart and fec dt support added, the dt kernel can boot
> into console with nfs root on babbage, so that we get a good base
> to start playing dt and converting further drivers to use dt on
> imx51.
> 
> It creates the platform imx51-dt for using the device tree, and
> leaves existing board support files alone, so nothing should be
> broken.  The plan is to add stuff step by step into imx51-dt to
> get it support every existing imx51 boards, and then remove the
> existing board files.
> 
> It works against Linus tree plus the dt infrastructure patches
> posted by Grant Likely as part of the following series.
> 
>   [RFC PATCH 00/11] Full device tree support for ARM Versatile
> 
> Comments are appreciated.
> 
> Shawn Guo (3):
>       serial/imx: add device tree support
>       net/fec: add device tree support
>       ARM: mx5: add basic device tree support for imx51 babbage

Good work!  Other than minor comments, this series looks awesome.

g.

> 
>  Documentation/devicetree/bindings/net/fsl-fec.txt  |   14 +++
>  .../bindings/tty/serial/fsl-imx-uart.txt           |   21 +++++
>  arch/arm/boot/dts/imx51-babbage.dts                |   89 ++++++++++++++++++++
>  arch/arm/mach-mx5/Kconfig                          |    8 ++
>  arch/arm/mach-mx5/Makefile                         |    1 +
>  arch/arm/mach-mx5/imx51-dt.c                       |   70 +++++++++++++++
>  drivers/net/fec.c                                  |   28 ++++++
>  drivers/tty/serial/imx.c                           |   81 ++++++++++++++++--
>  8 files changed, 302 insertions(+), 10 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
