Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2J0Qdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:33:40 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:56576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2J0Qdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:33:39 -0400
Date: Sat, 27 Oct 2012 18:33:26 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: mvebu: support for the Globalscale Mirabox MBX0001
 board
Message-ID: <20121027183326.62ab505a@skate>
In-Reply-To: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
References: <1351354965-23875-1-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, 27 Oct 2012 18:22:45 +0200, Gregory CLEMENT wrote:
> This platform, available from Globalscale has an Armada 370. For now,
> only the serial port is supported. Support for network, USB and other
> peripherals will be added as drivers for them become available for
> Armada 370 in mainline.

Great!

> +++ b/arch/arm/boot/dts/mbx001.dts

If you decided to name your platform with four zeros (00001), then the
file should be mbx0001.dts here.

> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
> index 49d7915..e5269b4 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -49,6 +49,7 @@ static void __init armada_370_xp_dt_init(void)
>  static const char * const armada_370_xp_dt_board_dt_compat[] = {
>  	"marvell,a370-db",
>  	"marvell,axp-db",
> +	"globalscale,mbx0001",
>  	NULL,
>  };

As Andrew said, sorted entries would be nicer.

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
