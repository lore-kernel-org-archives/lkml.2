Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2DQMxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:53:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61517 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2DQMxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <1334661361-3699-1-git-send-email-valentin.ilie@gmail.com>
References: <1334661361-3699-1-git-send-email-valentin.ilie@gmail.com>
Date: Tue, 17 Apr 2012 14:53:12 +0200
X-Google-Sender-Auth: NgXE5t33GifDoo3ssaV3avuSQRs
Message-ID: <CAMuHMdUQmTzjVfb=fwKJCmov+OuFYDHU-wW4T2kEXigpVxeGPg@mail.gmail.com>
Subject: Re: [PATCH] Drivers: ps3: ps3av.c: fixed checkpatch warnings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: geoff@infradead.org, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 13:16, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> diff --git a/drivers/ps3/ps3av.c b/drivers/ps3/ps3av.c
> index a409fa0..46136b0 100644
> --- a/drivers/ps3/ps3av.c
> +++ b/drivers/ps3/ps3av.c
> @@ -25,8 +25,8 @@
>  #include <linux/ioctl.h>
>  #include <linux/fb.h>
>  #include <linux/slab.h>
> +#include <linux/firmware.h>
>
> -#include <asm/firmware.h>

NAK. It really needs <asm/firmware.h> (have you compiled the result?).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
