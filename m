Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2GFUcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:32:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62931 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2GFUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <4FF1CBF2.8060303@xenotime.net>
References: <20120702172334.2618cae84cc57b4ec5a63ed7@canb.auug.org.au>
	<4FF1CBF2.8060303@xenotime.net>
Date: Fri, 6 Jul 2012 22:32:12 +0200
X-Google-Sender-Auth: XDONg2dLv-d10OnTTVKvpb9QjsM
Message-ID: <CAMuHMdVzPVLFozEV_26JtmFjPbgQAy-Eo2A0nMsbWu7pU5+sSg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 2 (crypto/hifn_795x)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 6:27 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/02/2012 12:23 AM, Stephen Rothwell wrote:
>> Changes since 20120629:
>
> on i386:
>
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!

Also on ppc6xx_defconfig
http://kisskb.ellerman.id.au/kisskb/buildresult/6650268/

It doesn't happen in mainline, but there were no changes in
drivers/crypto/hifn_795x.c.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
