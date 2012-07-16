Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2GPJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:26:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43616 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2GPJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <201207151943.08183.arnd@arndb.de>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<20120714093032.GA23316@elf.ucw.cz>
	<20120715121644.GB10597@arm.com>
	<201207151943.08183.arnd@arndb.de>
Date: Mon, 16 Jul 2012 11:26:17 +0200
X-Google-Sender-Auth: klk2Hd0K_VZne19Z1WT8MU0NETU
Message-ID: <CAMuHMdV6aCT1LXuKUDv51-b8eb+QApGX9tpz=7wq+DuYC1EfHA@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Ingo Molnar <mingo@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 9:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Yes, I agree that's the best way to handle this. Compared to other
> architectures, I think x86 is the only that allows booting either a
> 32 or 64 bit kernel on the same system. We used to support 32 bit
> kernels on 64 bit PowerMac, but nobody used it and we discontinued
> it long ago. Tile 64 bit is actually incompatible with 32 bit kernels
> at the architecture level and would require a third mode. On sparc,
> parisc and mips, AFAIK we could support 32 bit kernels on 64 bit
> machines, but never did.

Linux on MIPS supports both 32-bit and 64-bit kernels on 64-bit capable CPUs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
