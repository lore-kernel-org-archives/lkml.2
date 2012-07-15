Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2GOXxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 19:53:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41880 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2GOXxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 19:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <yw1x8vekd309.fsf@unicorn.mansr.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Jul 2012 16:53:21 -0700
X-Google-Sender-Auth: SRWHeV43ZuSBnHbJN0WYo2J3W1M
Message-ID: <CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 4:21 PM, Måns Rullgård <mans@mansr.com> wrote:
>
> FWIW, I'd prefer naming the directory either arm64 or armv8 for a few
> reasons:
>
> - Those are the names people actually use to refer to the architecture
> - They are more descriptive.
> - I think the official name is rather silly.

Agreed on those three for arm64.

However, please don't use the *INSANE* ARM "v8" naming. There must be
something in the water in Cambridge, but the ARM "version" naming is
just totally broken. They have separate versions for their
"architecture" (ex: arm v8) and for their "implementation" (ex:
ARM11), and maybe it all makes sense if you have drunk the ARM
cool-aid and have joined the ARM cult, but to sane people and
outsiders, it is just a f*cking mess.

So

 - aarch64 is just another druggie name that the ARM people came up
with after drinking too much of the spiked water in cambridge.

   It is apparently ARM deciding to emulate every single bad idea that
Intel ever cam up with, and is the ARM version of the "ia64" name
(which is Intel's equally confusing name for "Intel architecture 64",
which a few years ago meant Itanium, but now in more modern times when
Intel tries to forget Itanium ever existed it means x86-64).

   "ia64" was a horrible name, aarch64 is the exact same mistake. It sucks.

 - armv8 is totally idiotic and incomprehensible to anybody else,
since quite frankly, the difference between "ARMv8" (the architecture
spec) and "ARM7" (the processor family) is complete and utter
nonsense. It's only confusing.

Christ. Seriously. The insanity is so strong in the ARM version names
that it burns. If it really makes sense to anybody that "ARM A9"
(technically "Cortex-A9", but nobody seems to use the "Cortex" part at
least in cellphones) is an "ARM-v7" architecture microprocessor which
is *completely* different from the ARM9 family, which in turn is
different from ARMv9 that hasn't happened yet, you need to have your
head examined.

So please don't use "aarch64", because it's just f*cking crazy. And
please don't use "armv8", because it's just completely retarded and
confused.

I don't think *anybody* would be confused by "arm-64" (or "arm64").

Of course, some day ARM Ltd will (unless they install new water
filtration plants) have "v64" of their architecture spec or introduce
the "ARM64 processor family". But that day is a long time from now,
and hopefully we could head that off at the pass by just calling the
64-bit arm "arm64" and some sane people inside ARM.

          Linus
