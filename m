Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2BQVco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:32:44 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44343 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2BQVcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:32:42 -0500
MIME-Version: 1.0
In-Reply-To: <4F3E9DC8.6090304@xenotime.net>
References: <20120217165045.2394d944d6efc37104421d2e@canb.auug.org.au>
	<4F3E9DC8.6090304@xenotime.net>
Date: Fri, 17 Feb 2012 22:32:40 +0100
X-Google-Sender-Auth: oI9WTegT-EVoVzLKxMH5wGgSvi0
Message-ID: <CAMuHMdUKDFBuWbbCp5maBQHDz7F+=XSUvf=i2nGsgnixUQSSdA@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 17 (uml)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 19:34, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 02/16/2012 09:50 PM, Stephen Rothwell wrote:
>> Changes since 20120216:
>
> uml on x86_64 (defconfig):
>
>  CC      arch/um/kernel/asm-offsets.s
> In file included from linux-next-20120217/include/linux/slab.h:12:0,
>                 from linux-next-20120217/include/linux/crypto.h:23,
>                 from
> linux-next-20120217/arch/x86/um/shared/sysdep/kernel-offsets.h:4,
>                 from linux-next-20120217/arch/um/kernel/asm-offsets.c:1:
> linux-next-20120217/include/linux/gfp.h: In function 'gfp_zonelist':
> linux-next-20120217/include/linux/gfp.h:267:1: error:
> '__enabled_CONFIG_NUMA' undeclared (first use in this function)
> linux-next-20120217/include/linux/gfp.h:267:1: note: each undeclared
> identifier is reported only once for each function it appears in
> linux-next-20120217/include/linux/gfp.h:267:1: error:
> '__enabled_CONFIG_NUMA_MODULE' undeclared (first use in this function)

That's due to the lack of CONFIG_NUMA in various archs (also m68k).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
