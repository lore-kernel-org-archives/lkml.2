Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0EEHED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:04:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42147 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab0EEHEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=mkpJlHB+vw4txSSBWONqvYc6izXxO9AqxJ2102FHqwmV0/EgF92OV4Lf7Zlu5N5CCy
         /nkUkf3qJaS48vjzR+8/YFJfaHoDCr9rfi0ILSxxy2VfKGKy4HxwMH/JwVGI+uf00cj+
         kp//+1NJToEnK5Zr3QLY7UTm1n44CS7+YX2N4=
MIME-Version: 1.0
In-Reply-To: <20100416131245.GA1306@ucw.cz>
References: <20100416131245.GA1306@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 5 May 2010 15:03:40 +0800
Message-ID: <k2nf17812d71005050003x74225885h7dc29e4361890e5d@mail.gmail.com>
Subject: Re: spitz 2.6.34-rc4: fix On/off key name to fix warning during boot
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 9:12 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On/Off contains slash in the name, which causes warning during boot.
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>

Applied.

> --- ./arch/arm/mach-pxa/spitz.c 2010-03-21 22:09:12.000000000 +0100
> +++ ./arch/arm/mach-pxa/spitz.c 2010-04-16 03:45:07.000000000 +0200
> @@ -363,7 +363,7 @@
>                .type   = EV_PWR,
>                .code   = KEY_SUSPEND,
>                .gpio   = SPITZ_GPIO_ON_KEY,
> -               .desc   = "On/Off",
> +               .desc   = "On Off",
>                .wakeup = 1,
>        },
>        /* Two buttons detecting the lid state */
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
