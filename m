Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0K3SHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:07:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60395 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab0K3SHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W8Os7EEH1HFIB3HfhjfReqjSfH4ccCsMCEb2+j2pT2IbCRufu75oU2Xzbiihc2mpao
         wflo33GkBLgHZPYZVekcp2/ThlVX1aHFC6ZJ8XFUWvLpP1GIsKjsEv3erV1GtBEB2a1a
         v7GE6/UmGeppx7dVYyEJIpX86heI9AMIgaSDI=
MIME-Version: 1.0
In-Reply-To: <20101130184949.4e54dba3@endymion.delvare>
References: <20101130184949.4e54dba3@endymion.delvare>
Date: Tue, 30 Nov 2010 13:07:06 -0500
Message-ID: <AANLkTikgWX9CqWCNVPfRYNbeFS9q5akTEJmqnVef3kSz@mail.gmail.com>
Subject: Re: [PATCH] Haavard Skinnemoen has left Atmel
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 30, 2010 at 12:49 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Haavard's e-mail address at Atmel is no longer valid.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
Who are you to propose such a change ? I would have expected to see
such changes from someone with an @atmel.com email, not with a
@linux-fr.org address.

Thanks,
 - Arnaud

> ---
>  drivers/dma/dmatest.c               |    2 +-
>  drivers/i2c/busses/i2c-gpio.c       |    2 +-
>  drivers/net/macb.c                  |    2 +-
>  drivers/spi/atmel_spi.c             |    2 +-
>  drivers/usb/gadget/atmel_usba_udc.c |    2 +-
>  drivers/video/backlight/ltv350qv.c  |    2 +-
>  scripts/checkstack.pl               |    2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>
> --- linux-2.6.37-rc3.orig/drivers/dma/dmatest.c 2010-10-21 10:01:12.000000000 +0200
> +++ linux-2.6.37-rc3/drivers/dma/dmatest.c      2010-11-30 18:43:39.000000000 +0100
> @@ -624,5 +624,5 @@ static void __exit dmatest_exit(void)
>  }
>  module_exit(dmatest_exit);
>
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_LICENSE("GPL v2");
> --- linux-2.6.37-rc3.orig/drivers/i2c/busses/i2c-gpio.c 2010-08-02 00:11:14.000000000 +0200
> +++ linux-2.6.37-rc3/drivers/i2c/busses/i2c-gpio.c      2010-11-30 18:43:10.000000000 +0100
> @@ -219,7 +219,7 @@ static void __exit i2c_gpio_exit(void)
>  }
>  module_exit(i2c_gpio_exit);
>
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_DESCRIPTION("Platform-independent bitbanging I2C driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:i2c-gpio");
> --- linux-2.6.37-rc3.orig/drivers/net/macb.c    2010-11-02 09:19:35.000000000 +0100
> +++ linux-2.6.37-rc3/drivers/net/macb.c 2010-11-30 18:43:22.000000000 +0100
> @@ -1351,5 +1351,5 @@ module_exit(macb_exit);
>
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("Atmel MACB Ethernet driver");
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_ALIAS("platform:macb");
> --- linux-2.6.37-rc3.orig/drivers/spi/atmel_spi.c       2010-11-02 09:19:36.000000000 +0100
> +++ linux-2.6.37-rc3/drivers/spi/atmel_spi.c    2010-11-30 18:43:31.000000000 +0100
> @@ -931,6 +931,6 @@ static void __exit atmel_spi_exit(void)
>  module_exit(atmel_spi_exit);
>
>  MODULE_DESCRIPTION("Atmel AT32/AT91 SPI Controller driver");
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:atmel_spi");
> --- linux-2.6.37-rc3.orig/drivers/usb/gadget/atmel_usba_udc.c   2010-11-30 15:53:30.000000000 +0100
> +++ linux-2.6.37-rc3/drivers/usb/gadget/atmel_usba_udc.c        2010-11-30 18:43:48.000000000 +0100
> @@ -2093,6 +2093,6 @@ static void __exit udc_exit(void)
>  module_exit(udc_exit);
>
>  MODULE_DESCRIPTION("Atmel USBA UDC driver");
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:atmel_usba_udc");
> --- linux-2.6.37-rc3.orig/drivers/video/backlight/ltv350qv.c    2010-08-02 00:11:14.000000000 +0200
> +++ linux-2.6.37-rc3/drivers/video/backlight/ltv350qv.c 2010-11-30 18:43:00.000000000 +0100
> @@ -326,7 +326,7 @@ static void __exit ltv350qv_exit(void)
>  module_init(ltv350qv_init);
>  module_exit(ltv350qv_exit);
>
> -MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
> +MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
>  MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("spi:ltv350qv");
> --- linux-2.6.37-rc3.orig/scripts/checkstack.pl 2010-08-02 00:11:14.000000000 +0200
> +++ linux-2.6.37-rc3/scripts/checkstack.pl      2010-11-30 18:43:57.000000000 +0100
> @@ -12,7 +12,7 @@
>  #      sh64 port by Paul Mundt
>  #      Random bits by Matt Mackall <mpm@selenic.com>
>  #      M68k port by Geert Uytterhoeven and Andreas Schwab
> -#      AVR32 port by Haavard Skinnemoen <hskinnemoen@atmel.com>
> +#      AVR32 port by Haavard Skinnemoen (Atmel)
>  #      PARISC port by Kyle McMartin <kyle@parisc-linux.org>
>  #      sparc port by Martin Habets <errandir_news@mph.eclipse.co.uk>
>  #
>
>
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
