Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab1E3GpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:45:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48022 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1E3GpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:45:06 -0400
Date: Mon, 30 May 2011 08:45:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, arnd@arndb.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Subject: Re: [PATCH v2 0/2] Move Freescale MXS gpio driver into drivers/gpio
Message-ID: <20110530064502.GC23771@pengutronix.de>
References: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:43:41 up 3 days, 23:45, 18 users,  load average: 0.52, 0.42, 0.30
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

I suppose we should take this through the architecture tree. Can I have
your Ack for this?

Sascha

On Sat, May 28, 2011 at 11:09:32PM +0800, Shawn Guo wrote:
> The patch set moves Freescale MXS gpio driver from mach-mxs into
> drivers/gpio.
> 
> Changes since v1:
>  * Squash the 4 gpio-mxs patches into one
>  * Do not add new gpio Kconfig option and use ARCH_MXS directly
>  * Clean up platform-gpio-mxs.c per Arnd's comments
>  * Add device mxs_apbh_bus and set it as the parent of gpio devices
> 
> Shawn Guo (2):
>       gpio: gpio-mxs: add gpio driver for Freescale MXS architecture
>       ARM: mxs: use gpio-mxs driver by adding platform device
> 
>  arch/arm/mach-mxs/Makefile                         |    2 +-
>  arch/arm/mach-mxs/devices.c                        |   11 +
>  arch/arm/mach-mxs/devices/Makefile                 |    1 +
>  arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |   53 +++++
>  arch/arm/mach-mxs/gpio.h                           |   34 ---
>  arch/arm/mach-mxs/include/mach/devices-common.h    |    2 +
>  arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
>  arch/arm/mach-mxs/mm-mx23.c                        |    1 -
>  arch/arm/mach-mxs/mm-mx28.c                        |    1 -
>  drivers/gpio/Makefile                              |    1 +
>  .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |  228 ++++++++++++--------
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
