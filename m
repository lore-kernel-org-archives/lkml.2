Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0EYXCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:02:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab0EYXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:02:00 -0400
Date: Tue, 25 May 2010 16:01:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NUC900: add maintainer entries for Wan ZongShun.
Message-Id: <20100525160130.6e5aeb60.akpm@linux-foundation.org>
In-Reply-To: <4BF7E6EC.7010505@gmail.com>
References: <4BF7E6EC.7010505@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 22:15:08 +0800
Wan ZongShun <mcuos.com@gmail.com> wrote:

> Dear Andrew,
> 
> I want to add some files entries in MAINTAINER files
> for Winbond/Nuvoton ARM platform.
> 
> Could you help me merge this patch?
> 

I can do that.

> 
> >From 4e5326dbfbfdad58eb2c333df91c15993bce6c47 Mon Sep 17 00:00:00 2001
> From: zswan <zswan@zswan-marvell.(none)>
> Date: Sat, 22 May 2010 21:56:26 +0800
> Subject: [PATCH] add maintainer file entries
> 

Please send your Signed-off-by: for this change.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index d329b05..d6b3777 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -970,6 +970,18 @@ M:	Wan ZongShun <mcuos.com@gmail.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:	http://www.mcuos.com
>  S:	Maintained
> +F:	arch/arm/mach-w90x900/
> +F:	arch/arm/mach-nuc93x/
> +F:	drivers/input/keyboard/w90p910_keypad.c
> +F:	drivers/input/touchscreen/w90p910_ts.c
> +F:	drivers/watchdog/nuc900_wdt.c
> +F:	drivers/net/arm/w90p910_ether.c
> +F:	drivers/mtd/nand/w90p910_nand.c
> +F:	drivers/rtc/rtc-nuc900.c
> +F:	drivers/spi/spi_nuc900.c
> +F:	drivers/usb/host/ehci-w90x900.c
> +F:	drivers/video/nuc900fb.c
> +F:	drivers/sound/soc/nuc900/
> 
>  ARM/U300 MACHINE SUPPORT
>  M:	Linus Walleij <linus.walleij@stericsson.com>
> -- 
> 1.6.3.3
