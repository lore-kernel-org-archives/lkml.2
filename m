Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2LJXxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:53:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39754 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2LJXxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E0581F@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E0581F@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 10 Dec 2012 15:52:40 -0800
Message-ID: <CAK5ve-+JNPgYVkTKxa=sNt0aK3Yf73YHVqa12pZLHSo5Up_i3g@mail.gmail.com>
Subject: Re: [PATCH 4/4] MAINTAINERS: add LP8788 MFD driver entry
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 9:27 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan

> ---
>  MAINTAINERS |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ee7e9ee..9339a4b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7570,6 +7570,16 @@ S:       Maintained
>  F:     drivers/regulator/lp872x.c
>  F:     include/linux/regulator/lp872x.h
>
> +TI LP8788 MFD DRIVER
> +M:     Milo Kim <milo.kim@ti.com>
> +S:     Maintained
> +F:     drivers/iio/adc/lp8788_adc.c
> +F:     drivers/leds/leds-lp8788.c
> +F:     drivers/mfd/lp8788*.c
> +F:     drivers/power/lp8788-charger.c
> +F:     drivers/regulator/lp8788-*.c
> +F:     include/linux/mfd/lp8788*.h
> +
>  TI TWL4030 SERIES SOC CODEC DRIVER
>  M:     Peter Ujfalusi <peter.ujfalusi@ti.com>
>  L:     alsa-devel@alsa-project.org (moderated for non-subscribers)
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>
