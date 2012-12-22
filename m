Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab2LVMvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 07:51:37 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64015 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2LVMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 07:51:35 -0500
MIME-Version: 1.0
In-Reply-To: <201212171612.44126.arnd@arndb.de>
References: <1355679527-1207-1-git-send-email-geert@linux-m68k.org>
	<1355679527-1207-2-git-send-email-geert@linux-m68k.org>
	<201212171612.44126.arnd@arndb.de>
Date: Sat, 22 Dec 2012 13:51:32 +0100
X-Google-Sender-Auth: Jx2RewGUol86NsBe3txDWbHZ1ME
Message-ID: <CAMuHMdXhi_dA9Q04YoQ9yDRrJRpH8mNsLgU88oCdhAgcsQLpyg@mail.gmail.com>
Subject: Re: [PATCH 2/2] asm-generic/dma-mapping-broken.h: Provide dma_alloc_attrs()/dma_free_attrs()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, Dec 17, 2012 at 5:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 16 December 2012, Geert Uytterhoeven wrote:
>> Since commit 0049fb2603b7afb1080776ee691dfa5a3d282357 ("OMAPFB: use
>> dma_alloc_attrs to allocate memory") we have one non-arch user of
>> dma_{alloc,free}_attrs().
>>
>> Hence provide these functions, as wrappers around
>> dma_{alloc,free}_coherent().
>>
>> Note that most architectures do it the other way around. But as these are
>> dummy functions, we don't care.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  include/asm-generic/dma-mapping-broken.h |   16 ++++++++++++++++
>>  1 files changed, 16 insertions(+), 0 deletions(-)
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

> Maybe you can put this one in your m68k tree along with your other
> patch.

Will do.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
