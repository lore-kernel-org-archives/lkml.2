Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0IUGyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:54:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60701 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0IUGyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:54:03 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.86.31]
In-Reply-To: <20100921120919.a38723d3.sfr@canb.auug.org.au>
References: <20100921120919.a38723d3.sfr@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 21 Sep 2010 08:53:43 +0200
Message-ID: <AANLkTinxssqohSCfod8Q1emhJ6AB4Hkxo7EmkTtTxuf=@mail.gmail.com>
Subject: Re: linux-next: manual merge of the wireless tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Sep 21, 2010 at 4:09 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> The wireless tree commit copied the include/linux/spi/wl12xx.h to
> include/linux but did not remove the spi/ one.

We had that one fixed in
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg34910.html
but it seems an older patch accidentally got in.

> only the new one ... I fixed the above conflict (see below) on the
> assumption that the spi/ version of the header file should have been
> removed.

Yes, thank you. I'll send a patch to fix that in the wireless tree too.

Thanks,
Ohad.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/mach-omap2/board-omap3pandora.c
> index dd3af2b,9b62b62..0000000
> --- a/arch/arm/mach-omap2/board-omap3pandora.c
> +++ b/arch/arm/mach-omap2/board-omap3pandora.c
> @@@ -25,9 -25,7 +25,9 @@@
>  #include <linux/spi/ads7846.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/i2c/twl.h>
> - #include <linux/spi/wl12xx.h>
> + #include <linux/wl12xx.h>
>  +#include <linux/mtd/partitions.h>
>  +#include <linux/mtd/nand.h>
>  #include <linux/leds.h>
>  #include <linux/input.h>
>  #include <linux/input/matrix_keypad.h>
>
