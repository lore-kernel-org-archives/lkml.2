Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2IQUKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:10:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46748 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab2IQUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <505754EB.8060907@oracle.com>
References: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au>
	<505745CF.8040202@xenotime.net>
	<505754EB.8060907@oracle.com>
Date: Mon, 17 Sep 2012 22:10:27 +0200
X-Google-Sender-Auth: LbBGneDXz2u_ryfXzPDdCCt6AYM
Message-ID: <CAMuHMdWSTNb+YAyHR5F0kkHjDM8iVgRV352OcZ-epvNTcx+pBA@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 17 (jfs)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tino Reichardt <list-jfs@mcmilk.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave.

On Mon, Sep 17, 2012 at 6:50 PM, Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>> modular build:
>> ERROR: "__divdi3" [fs/jfs/jfs.ko] undefined!
>>
>> or builtin:
>> fs/built-in.o: In function `dbDiscardAG':
>> (.text+0x12988b): undefined reference to `__divdi3'
>
> Thanks Randy.
>
> This should fix it. I'll integrate it back into the proper patch in the
> jfs tree for the next pull.
>
> jfs: fix i386 build error. Replace 64-bit division with do_div()
>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>

Thx, same issue on m68k, and your patch fixed it, so
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
