Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1IDJdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 05:33:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45793 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1IDJdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 05:33:02 -0400
MIME-Version: 1.0
In-Reply-To: <1315091917.8552.16.camel@hp>
References: <1315091917.8552.16.camel@hp>
Date: Sun, 4 Sep 2011 11:33:01 +0200
X-Google-Sender-Auth: EhoadNjHb6P0jBYt-sFKZyBzMoM
Message-ID: <CAMuHMdUz4vwti4YtE_sSTQ1XWDZcXes4CGk7A9B7DgV75NLNqQ@mail.gmail.com>
Subject: Re: [PATCH]Finally remove letfover markers section
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p849XP43003623

On Sun, Sep 4, 2011 at 01:18, Kirill Tkhai <tkhai@yandex.ru> wrote:
> Markers have removed already twice:
>
> 1: fc5377668c3d808e1d53c4aee152c836f55c3490
> 2: eb878b3bc0349344dbf70c51bf01fc734d5cf2d3
>
> But a little bit is still here.
>
> Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>

Thanks, applied, and will queue for 3.2.

> diff --git a/arch/m68k/kernel/vmlinux.lds_no.S
> b/arch/m68k/kernel/vmlinux.lds_no.S
> index 7dc4087..4e23893 100644
> --- a/arch/m68k/kernel/vmlinux.lds_no.S
> +++ b/arch/m68k/kernel/vmlinux.lds_no.S
> @@ -77,7 +77,6 @@ SECTIONS {
>
>                *(.rodata) *(.rodata.*)
>                *(__vermagic)           /* Kernel version magic */
> -               *(__markers_strings)
>                *(.rodata1)
>                *(.rodata.str1.1)
>
> diff --git a/include/asm-generic/vmlinux.lds.h
> b/include/asm-generic/vmlinux.lds.h
> index db22d13..b5e2e4c 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -222,7 +222,6 @@
>                VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;         \
>                *(__tracepoints_ptrs)   /* Tracepoints: pointer array */\
>                VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;          \
> -               *(__markers_strings)    /* Markers: strings */          \
>                *(__tracepoints_strings)/* Tracepoints: strings */      \
>        }                                                               \
>                                                                        \

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
