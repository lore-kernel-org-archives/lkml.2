Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1LaNmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 08:42:06 -0500
Received: from nm6-vm0.bullet.mail.ird.yahoo.com ([77.238.189.210]:27101 "HELO
	nm6-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753146Ab1LaNlo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 08:41:44 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Dec 2011 08:41:43 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 508355.14925.bm@omp1007.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BBHfHvQkrIsHpvgb0ECSRmFXN9uhLmj9iKg0XCWW8ah9VJ+xHtae11hJbZ/h8svUj3+8xC/v39QzEn/OtuX9u/rc1DeJ3ymtqqig5mmRILRrxGb0Jol5dcITWTQrNc4Hj7nQ8qHOy46r5q4harhcmeZ0gk2GQ3vUdlcCPLXfKxg=;
X-YMail-OSG: cuc_8_sVM1mWiKRkMHGgil_tDw66DUOE_XrmLpN5PiELQMT
 d3jRygTtbG1FoGhRkLT.hXl0XXdJYqFRxUjapPmh1DqGeo8e7HdpvOcTNulz
 B.zA6HVFV9c3fpSp4Z_Gz8.J.zQdDd3wA6ql9BGAd1tF7PYak2elErcXh8.W
 t6Q22aA9BM_GdjKXhwAylv_roOH.6_Pp9.hzGT8gueVArJ248UgI5YrPwKNl
 LjzlMi106YLlNW7tvWO6IgEVr9Vx6dgFYpGgAR2x_014nSesljxu7gw1LBZn
 OBAnoBMzYxbwVpZVWrFMcF_ySFzVcsGULmcsHNDr4kIxISboBZ0b3RoBxn4r
 t_AEcGC1CO7dkCEzSe1YGnEQ0DHicR8PW6V22a0Pp2.65MwovtaOo9pZwh3O
 pMm7etS1m.5aJOTtbXUXE7L4EEQnl_bgzbNTycvg4fJgwgYQlptyKWL7Qo8P
 NXliu5gfe.QkXjlXyxiR2r6I03aSOI3BH3UwfbT0dlA--
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.331698
Message-ID: <1325338529.24725.YahooMailClassic@web29008.mail.ird.yahoo.com>
Date: Sat, 31 Dec 2011 13:35:29 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH v2] pxa/hx4700: add platform device and I2C info for AK4641 codec
To: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
        Dmitry Artamonow <mad_soft@inbox.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1325217971.4022.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Works for me on linux-3.2-rc7.

Tested-by: Paul Parsons <lost.distance@yahoo.com>

--- On Fri, 30/12/11, Axel Lin <axel.lin@gmail.com> wrote:

> From: Axel Lin <axel.lin@gmail.com>
> Subject: [PATCH v2] pxa/hx4700: add platform device and I2C info for AK4641 codec
> To: linux-kernel@vger.kernel.org
> Cc: "Philipp Zabel" <philipp.zabel@gmail.com>, "Dmitry Artamonow" <mad_soft@inbox.ru>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, "Liam Girdwood" <lrg@ti.com>, "Haojian Zhuang" <haojian.zhuang@marvell.com>, "Eric Miao" <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org
> Date: Friday, 30 December, 2011, 4:06
> The audio on hx4700 needs this to
> properly work.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Marek Vasut <marek.vasut@gmail.com>
> ---
> v2: Avoid rename AK4641 power GPIOs.
> 
>  arch/arm/mach-pxa/hx4700.c |   25
> +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/hx4700.c
> b/arch/arm/mach-pxa/hx4700.c
> index fb9b62d..208eef1 100644
> --- a/arch/arm/mach-pxa/hx4700.c
> +++ b/arch/arm/mach-pxa/hx4700.c
> @@ -45,6 +45,7 @@
>  #include <mach/hx4700.h>
>  #include <mach/irda.h>
>  
> +#include <sound/ak4641.h>
>  #include <video/platform_lcd.h>
>  #include <video/w100fb.h>
>  
> @@ -765,6 +766,28 @@ static struct i2c_board_info
> __initdata pi2c_board_info[] = {
>  };
>  
>  /*
> + * Asahi Kasei AK4641 on I2C
> + */
> +
> +static struct ak4641_platform_data ak4641_info = {
> +    .gpio_power = GPIO27_HX4700_CODEC_ON,
> +    .gpio_npdn  =
> GPIO109_HX4700_CODEC_nPDN,
> +};
> +
> +static struct i2c_board_info i2c_board_info[] __initdata =
> {
> +    {
> +       
> I2C_BOARD_INFO("ak4641", 0x12),
> +        .platform_data =
> &ak4641_info,
> +    },
> +};
> +
> +static struct platform_device audio = {
> +    .name    =
> "hx4700-audio",
> +    .id    = -1,
> +};
> +
> +
> +/*
>   * PCMCIA
>   */
>  
> @@ -790,6 +813,7 @@ static struct platform_device
> *devices[] __initdata = {
>      &gpio_vbus,
>      &power_supply,
>      &strataflash,
> +    &audio,
>      &pcmcia,
>  };
>  
> @@ -827,6 +851,7 @@ static void __init hx4700_init(void)
>      pxa_set_ficp_info(&ficp_info);
>      pxa27x_set_i2c_power_info(NULL);
>      pxa_set_i2c_info(NULL);
> +    i2c_register_board_info(0,
> ARRAY_AND_SIZE(i2c_board_info));
>      i2c_register_board_info(1,
> ARRAY_AND_SIZE(pi2c_board_info));
>      pxa2xx_set_spi_info(2,
> &pxa_ssp2_master_info);
>     
> spi_register_board_info(ARRAY_AND_SIZE(tsc2046_board_info));
> -- 
> 1.7.5.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
