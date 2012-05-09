Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2EIH5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:57:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61094 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2EIH5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <201205051921.13209.arnd@arndb.de>
References: <20120503144645.6390.62303.sendpatchset@w520>
	<201205050722.45500.arnd@arndb.de>
	<201205052108.03001.rjw@sisk.pl>
	<201205051921.13209.arnd@arndb.de>
Date: Wed, 9 May 2012 09:57:36 +0200
X-Google-Sender-Auth: 1p3VcQGZUeZrDFBMtYO59W0tqL0
Message-ID: <CAMuHMdUR4mk6ErCj8o2xt2k3vw9RYe5c7MvtQ3q0Xq2sfnV32A@mail.gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 5, 2012 at 9:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 05 May 2012, Rafael J. Wysocki wrote:
>> Now, if you insist on us having a separate mach- directory for every platform
>> (SoC), we can do that I think, but then we should start with splitting up the
>> existing mach-shmobile into a number of SoC-specific directories rather than
>> adding new mach- directories for random new parts, because that goes against
>> our development history to date, which is important too IMHO.
>
> All the chips in there so far share a common ancestry and they all use a
> significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
> sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
> uses none of those and apparently was developed by NEC before the merger with
> Renesas.

Ah, I didn't know NEC joined Renesas, but Wikipedia proves you're right.

So, any similarities with the MIPS-based NEC EMMA SOCs, i.e. more code to
share?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
