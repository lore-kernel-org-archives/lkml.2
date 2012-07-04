Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2GDIAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:00:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52083 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2GDIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <1341329015-28207-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341329015-28207-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Wed, 4 Jul 2012 10:00:50 +0200
X-Google-Sender-Auth: tfaFV8ERoT9v48m3ma2fyFr_LfY
Message-ID: <CAMuHMdXzE48MCpQWjaxdrYMEwi-Cn5GR6NYrDAOAKwqiJ3m7Yg@mail.gmail.com>
Subject: Re: [PATCH] clkdev: Add default clkdev.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, mturquette@ti.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 5:23 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> --- a/include/asm-generic/Kbuild.asm
> +++ b/include/asm-generic/Kbuild.asm
> @@ -13,6 +13,10 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
>  header-y += a.out.h
>  endif
>
> +ifeq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/clkdev.h),)
> +generic-y += clkdev.h
> +endif

Quoting Sam:
"Any use of wildcards in include/asm-generic/Kbuild.asm is bogus."

http://lkml.indiana.edu/hypermail/linux/kernel/1206.2/01507.html

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
