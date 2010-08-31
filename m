Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0HaXAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 19:00:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38737 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0HaXAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 19:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jXoGIxjXu6T4rGzRTtlOZNLP5v1NlNQSVAiz3cidHP1WKkyATkkrhY9CANGDjh1SwJ
         98aT/0aBBBfH0oLxGUc2iLRlA5WeRfTp10OB7cfSN3PP9fsmldwRosPQetTA0YUaolJO
         mr7qlD4Kg6g6is0Pma4a6SgPk+nWDlbhyfZj0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinmWzTBPEsicB-AWv9-=mA8HE2qqEoYqhbV39t8@mail.gmail.com>
References: <AANLkTinmWzTBPEsicB-AWv9-=mA8HE2qqEoYqhbV39t8@mail.gmail.com>
Date: Tue, 31 Aug 2010 16:00:32 -0700
Message-ID: <AANLkTimzMcydUF-8fK+L-Lkp3HMZ=8jLp+NdjrJuV+kx@mail.gmail.com>
Subject: Re: [PATCH] watchdog: Enable NXP LPC32XX support in Kconfig (resend)
From: Kevin Wells <wellsk40@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vitaly Wool <vitalywool@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's been a few weeks on this one, can you please get this into the
watchdog tree?

thanks,
Kevin

> The NXP LPC32XX processor use the same watchdog as the Philips
> PNX4008 processor.
>
> Signed-off-by: Kevin Wells <wellsk40@gmail.com>
> Tested-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/watchdog/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index b04b184..c442b2a 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -206,11 +206,11 @@ config OMAP_WATCHDOG
>          here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430
> watchdog timer.
>
>  config PNX4008_WATCHDOG
> -       tristate "PNX4008 Watchdog"
> -       depends on ARCH_PNX4008
> +       tristate "PNX4008 and LPC32XX Watchdog"
> +       depends on ARCH_PNX4008 || ARCH_LPC32XX
>        help
>          Say Y here if to include support for the watchdog timer
> -         in the PNX4008 processor.
> +         in the PNX4008 or LPC32XX processors.
>          This driver can be built as a module by choosing M. The module
>          will be called pnx4008_wdt.
>
> --
> 1.7.1.1
>
