Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2HYTck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:32:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50434 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2HYTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120822131130.d669275edf903d9a38a35789@canb.auug.org.au>
References: <20120822131130.d669275edf903d9a38a35789@canb.auug.org.au>
Date: Sat, 25 Aug 2012 21:32:37 +0200
X-Google-Sender-Auth: kTfPM6SjwBm-jxz0IrPTKGxeWGQ
Message-ID: <CAMuHMdV9VdJ__yWZwzUnM3=XiRo7NWxiJnnoOBgZ9Jg8v0RTNg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the rr tree with the mips tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, David,

On Wed, Aug 22, 2012 at 5:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the rr tree got a conflict in
> arch/mips/kernel/module.c between commit c54de490a2e4 ("MIPS: Module:
> Deal with malformed HI16/LO16 relocation sequences") from the mips tree
> and commit 9db0bbe072c8 ("MIPS: Fix module.c build for 32 bit") from the
> rr tree.
>
> Just context changes (I think).  I fixed it up (see below) and can carry
> the fix as necessary.

> + #endif

At first I thought this merge conflict resolution introduced the bogus #endif:

arch/mips/kernel/module.c:247:2: error: #endif without #if

(e.g. http://kisskb.ellerman.id.au/kisskb/buildresult/6999289/)

but it seems to be present already in David's commit
bd029f48459adc8a72a2db95f7d79a7296c5ad5a ("Make most arch
asm/module.h files use asm-generic/module.h")..

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
