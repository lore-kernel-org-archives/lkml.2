Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1FTJcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 05:32:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57264 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1FTJcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 05:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e5J2CygEWdBX24Vj7rg44WIwWVqsqdKNX4EPmk1uyeOm9XDl2Q3Rv/ovGqti8oQL2k
         gPVMR7Nvof59SZ4Fn5AXhwwk6VlAP1uBgwLpvVt0sjrG4O/GS6oCf8AQhq9b0wb1gsJM
         a/72ZdXI6Yiy0/iJZmOF5q6Avs9r+/e65PP2I=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
Date: Mon, 20 Jun 2011 12:32:49 +0300
Message-ID: <BANLkTimjoiDxDX-_Qg4U6TSW6jjEa5xSsw@mail.gmail.com>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h include
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jusper/Linus/All,

On Mon, Jun 20, 2011 at 11:40 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> Remove the duplicate inclusion of linux/leds.h from
> arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  h1940-bluetooth.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
> index 2c126bb..a5eeb62 100644
> --- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
> +++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
> @@ -18,7 +18,6 @@
>  #include <linux/leds.h>
>  #include <linux/gpio.h>
>  #include <linux/rfkill.h>
> -#include <linux/leds.h>
>
>  #include <mach/regs-gpio.h>
>  #include <mach/hardware.h>
>
> --

Some time ago I already sent a patch to handle all the headers
duplication corrections. Please check this:

https://lkml.org/lkml/2011/6/16/301

It should handle all the cases you described at:

https://lkml.org/lkml/2011/6/20/72
https://lkml.org/lkml/2011/6/20/78
https://lkml.org/lkml/2011/6/20/75

I didn't receive any comments and still can see that it's not in
mainline Linus' tree.


Thanks,
Vitaliy
