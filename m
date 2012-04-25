Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab2DYLX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:23:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57784 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab2DYLXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <1335341466.28150.248.camel@twins>
References: <20120424161039.293018424@chello.nl>
	<20120424162224.526249106@chello.nl>
	<20120425102342.45cf5c5e81e8aeb3bec67d0b@canb.auug.org.au>
	<1335341466.28150.248.camel@twins>
Date: Wed, 25 Apr 2012 13:23:25 +0200
X-Google-Sender-Auth: sAcZq0BAClR-PtOWEtM5RGXZso4
Message-ID: <CAMuHMdUqgR8Z8wtBjm=-g9ff6CVmEd=FpbC2tk-CMU7B3XVVDg@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] math128: Introduce {mult,add,cmp}_u128
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:11, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  ls arch/*/include/asm/Kbuild | while read file; do quilt add $file;
> echo "generic-y += math128.h" >> $file; done

That may fail if your "ls" is an alias.
Better: "for file in arch/*/include/asm/Kbuild;do ..; done".

Still using quilt? I didn't regret ditching it in favor of git (yummy,
git rebase ;-).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
