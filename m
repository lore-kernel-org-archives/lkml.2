Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2EIIM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:12:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42887 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2EIIMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUR4mk6ErCj8o2xt2k3vw9RYe5c7MvtQ3q0Xq2sfnV32A@mail.gmail.com>
References: <20120503144645.6390.62303.sendpatchset@w520>
	<201205050722.45500.arnd@arndb.de>
	<201205052108.03001.rjw@sisk.pl>
	<201205051921.13209.arnd@arndb.de>
	<CAMuHMdUR4mk6ErCj8o2xt2k3vw9RYe5c7MvtQ3q0Xq2sfnV32A@mail.gmail.com>
Date: Wed, 9 May 2012 17:12:52 +0900
Message-ID: <CANqRtoTamkCfu0yHiF8oGXdLKDjSxhBO-GqPDJ00Ejw5LkSqkw@mail.gmail.com>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 4:57 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, May 5, 2012 at 9:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Saturday 05 May 2012, Rafael J. Wysocki wrote:
>>> Now, if you insist on us having a separate mach- directory for every platform
>>> (SoC), we can do that I think, but then we should start with splitting up the
>>> existing mach-shmobile into a number of SoC-specific directories rather than
>>> adding new mach- directories for random new parts, because that goes against
>>> our development history to date, which is important too IMHO.
>>
>> All the chips in there so far share a common ancestry and they all use a
>> significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
>> sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
>> uses none of those and apparently was developed by NEC before the merger with
>> Renesas.
>
> Ah, I didn't know NEC joined Renesas, but Wikipedia proves you're right.

Actually, for those of you who care about details - NEC Electronics
and Renesas merged into Renesas Electronics. Other parts of NEC are
still around as usual.

> So, any similarities with the MIPS-based NEC EMMA SOCs, i.e. more code to
> share?

That would be very interested to know. I've grepped the kernel tree
for existing code matching Uart, STI and GPIO but nothing so far. Does
anyone know where I can find docs for the MIPS based ones?

Good news is that documentation for Emma Mobile EV2 and Emma Mobile
1-S can be downloaded from renesas.com.

Cheers,

/ magnus
