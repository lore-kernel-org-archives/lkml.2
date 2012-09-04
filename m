Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2IDIFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:05:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41558 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2IDIFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:05:38 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF20FD@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF20FD@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 4 Sep 2012 16:05:15 +0800
X-Google-Sender-Auth: jJIigbi1wIEGyzJCnutYR19B2uo
Message-ID: <CAK5ve-+EzHsuAkC2ra1xjx3zQKZs=jyW2n_+ZrjBKkqVh49_Rw@mail.gmail.com>
Subject: Re: [PATCH 1/3] leds-lp5523: support new LP55231 device
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 3:06 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  New TI LP55231 device has same I2C register layout as LP5523.
>  Therefore, all of LED operations can be shared with the LP5523 driver.
>
>  To support new LP55231 device explicitly, the device description
>  is added in the configuration file.
>

Looks good, I will apply this into my for-next

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/Kconfig |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 16578d3..0bc80bd 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -192,11 +192,12 @@ config LEDS_LP5521
>           programming the engines.
>
>  config LEDS_LP5523
> -       tristate "LED Support for N.S. LP5523 LED driver chip"
> +       tristate "LED Support for TI/National LP5523/55231 LED driver chip"
>         depends on LEDS_CLASS && I2C
>         help
> -         If you say yes here you get support for the National Semiconductor
> -         LP5523 LED driver. It is 9 channel chip with programmable engines.
> +         If you say yes here you get support for TI/National Semiconductor
> +         LP5523/55231 LED driver.
> +         It is 9 channel chip with programmable engines.
>           Driver provides direct control via LED class and interface for
>           programming the engines.
>
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
