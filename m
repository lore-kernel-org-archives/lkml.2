Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2DYOfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:35:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62186 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DYOft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <1335355106.28150.254.camel@twins>
References: <20120424161039.293018424@chello.nl>
	<20120424162224.526249106@chello.nl>
	<20120425102342.45cf5c5e81e8aeb3bec67d0b@canb.auug.org.au>
	<1335341466.28150.248.camel@twins>
	<CAMuHMdUqgR8Z8wtBjm=-g9ff6CVmEd=FpbC2tk-CMU7B3XVVDg@mail.gmail.com>
	<1335355106.28150.254.camel@twins>
Date: Wed, 25 Apr 2012 16:35:47 +0200
X-Google-Sender-Auth: lXpdLW3YBqZBpFJUmlaem91mO_Q
Message-ID: <CAMuHMdVSjX1ZRc_Q0cuL+U_f+zzuD+1cjW-OBdn1c3mC8Ya_Rg@mail.gmail.com>
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

On Wed, Apr 25, 2012 at 13:58, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> Still using quilt? I didn't regret ditching it in favor of git (yummy,
>> git rebase ;-).
>
> Yeah, I can't seem to deal with git, I edit my patches by hand way too
> often, also quilt is a _LOT_ faster pushing/popping patches than git is
> (and yes I use an SSD).
>
> Not using git also means I don't have to deal with the trainwreck that
> is git-merge,.. /me runs like hell.

But you have to deal with the quilt-oh-no-the-patch-no-longer-applies
trainwreck...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
