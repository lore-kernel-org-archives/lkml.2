Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1DXJaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:30:30 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52605 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1DXJa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lW5sgPOUzucDfrhsjdQfc4B9fWOF5fA3J2qOLr5qVe1rGQGXBzreEJB13y4TKJlAmY
         YzQoO522oRzH7VxW/QZ2njmicJxJbqc4jPcFzIj+Ml7Ep3M2S9yCJMyHUPKCu69/Onzh
         cEkt9pLBcIG34p9kkrl4Gzh4Es46ZPWL/SJE4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <alpine.DEB.2.00.1104241036570.16333@ayla.of.borg>
References: <alpine.DEB.2.00.1104241036570.16333@ayla.of.borg>
Date: Sun, 24 Apr 2011 11:30:25 +0200
Message-ID: <BANLkTin0xsg9+1yRc2NXP=D5cU8bR9q8kQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Roman Zippel has been MIA for several years.
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Roman Zippel <zippel@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIA?

Missing In Action?
Maintainer Is Absent?
( Miami International Airport? )

- Sedat -

On Sun, Apr 24, 2011 at 10:38 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hence make AFFS and HFS orphans, and remove him as an m68k maintainer.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  MAINTAINERS |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ec36003..0a84d29 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -404,8 +404,8 @@ S:  Maintained
>  F:     sound/oss/aedsp16.c
>
>  AFFS FILE SYSTEM
> -M:     Roman Zippel <zippel@linux-m68k.org>
> -S:     Maintained
> +L:     linux-fsdevel@vger.kernel.org
> +S:     Orphan
>  F:     Documentation/filesystems/affs.txt
>  F:     fs/affs/
>
> @@ -2943,8 +2943,8 @@ F:        drivers/block/cciss*
>  F:     include/linux/cciss_ioctl.h
>
>  HFS FILESYSTEM
> -M:     Roman Zippel <zippel@linux-m68k.org>
> -S:     Maintained
> +L:     linux-fsdevel@vger.kernel.org
> +S:     Orphan
>  F:     Documentation/filesystems/hfs.txt
>  F:     fs/hfs/
>
> @@ -3992,7 +3992,6 @@ F:        arch/m32r/
>
>  M68K ARCHITECTURE
>  M:     Geert Uytterhoeven <geert@linux-m68k.org>
> -M:     Roman Zippel <zippel@linux-m68k.org>
>  L:     linux-m68k@lists.linux-m68k.org
>  W:     http://www.linux-m68k.org/
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git
> --
> 1.7.0.4
>
> Gr{oetje,eeting}s,
>
>                                                Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                            -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
