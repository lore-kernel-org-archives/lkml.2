Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2HBDqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 23:46:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61838 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2HBDq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 23:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <201208012304.56859.linux@rainbow-software.org>
References: <201208012304.56859.linux@rainbow-software.org>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 2 Aug 2012 11:46:08 +0800
X-Google-Sender-Auth: P-VH8SS3t3fGsfrbWr8ZNJEYX1M
Message-ID: <CAK5ve-KteUOsFqzZG+QBDYYukUs6hzB4Hvg9+rrQ+-ACJi09yQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds-clevo-mail: Fix Clevo M5x0V DMI strings
To: Ondrej Zary <linux@rainbow-software.org>
Cc: =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 5:04 AM, Ondrej Zary <linux@rainbow-software.org> wrote:
> There are more variants of Clevo M5x0V laptops and Positivo Mobile is just one of them.
> Another one is UMAX VisionBook 2400WXC. Use only generic Clevo DMI strings to match all
> variants.
>

Thanks, applied to my for-next branch
-Bryan

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> --- a/drivers/leds/leds-clevo-mail.c
> +++ b/drivers/leds/leds-clevo-mail.c
> @@ -59,11 +59,10 @@ static struct dmi_system_id __initdata clevo_mail_led_dmi_table[] = {
>         },
>         {
>                 .callback = clevo_mail_led_dmi_callback,
> -               .ident = "Positivo Mobile",
> +               .ident = "Clevo M5x0V",
>                 .matches = {
>                         DMI_MATCH(DMI_BOARD_VENDOR, "CLEVO Co. "),
>                         DMI_MATCH(DMI_BOARD_NAME, "M5X0V "),
> -                       DMI_MATCH(DMI_PRODUCT_NAME, "Positivo Mobile"),
>                         DMI_MATCH(DMI_PRODUCT_VERSION, "VT6198")
>                 }
>         },
>
>
>
>
> --
> Ondrej Zary



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
