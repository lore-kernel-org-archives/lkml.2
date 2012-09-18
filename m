Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2IRQtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:49:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2IRQtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1347986174-30287-2-git-send-email-peter.senna@gmail.com>
References: <1347986174-30287-1-git-send-email-peter.senna@gmail.com> <1347986174-30287-2-git-send-email-peter.senna@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Sep 2012 22:19:21 +0530
Message-ID: <CA+V-a8tNCjXKgfV9TtWroZ+FvFQFqmrVfczVxEmUkZt2pQL3RQ@mail.gmail.com>
Subject: Re: [PATCH] arch/arm/mach-davinci/board-dm646x-evm.c: Remove unecessary
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: nsekhar@ti.com, khilman@ti.com,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for the patch.

On Tue, Sep 18, 2012 at 10:06 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> Found by http://coccinelle.lip6.fr/
>
The commit message 'Remove unecessary' doesn't explain
what are you trying to do.

Thanks,
--Prabhakar

> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  arch/arm/mach-davinci/board-dm646x-evm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 958679a..1ccaace 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -193,7 +193,7 @@ static int evm_led_setup(struct i2c_client *client, int gpio,
>         while (ngpio--) {
>                 leds->gpio = gpio++;
>                 leds++;
> -       };
> +       }
>
>         evm_led_dev = platform_device_alloc("leds-gpio", 0);
>         platform_device_add_data(evm_led_dev, &evm_led_data,
> --
> 1.7.11.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
