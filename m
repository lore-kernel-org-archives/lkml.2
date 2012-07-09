Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2GINdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:33:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34718 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2GINdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FFA3B71.3020105@jonmasters.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de>
	<4FF93C99.80203@redhat.com>
	<4FF9D1E9.4050504@jonmasters.org>
	<20120708172419.2b2f2713@pegasus.ausil.us>
	<4FFA3B71.3020105@jonmasters.org>
Date: Mon, 9 Jul 2012 15:33:43 +0200
X-Google-Sender-Auth: KX9y2ntjkH_cg8hAxKQgLK-1kuw
Message-ID: <CAMuHMdV-pTjkUJW+Rx18nedXvMArG7NDA4qTNfrCwsrFOrethg@mail.gmail.com>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Dennis Gilmore <dgilmore@fedoraproject.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 4:01 AM, Jon Masters <jonathan@jonmasters.org> wrote:
> On 07/08/2012 06:24 PM, Dennis Gilmore wrote:
>> I know that the architecture really is new but thats not really clear
>> by adding AArch32 into the mix to represent 32 bit arm as ARM has done
>> or by calling it armv8. There is enough way to confuse them already why
>> confuse things more by adding yet another variable that is AArch64.
>> - From my and most of the other Fedora developers that i've discussed it
>> with its more like reluctant acceptance of AArch64 than thinking is a
>> good idea.
>
> btw, for clarification of anyone who is confused by the names...the new
> architecture is ARMv8. The 64-bit state is AArch64, during which the
> processor executes A64 instructions. The 32-bit state is AArch32, during
> which the processor executes either A32 ("ARM" version 7+) or T32
> ("Thumb" - I guess Thumb2+ really due to some of deprecation)
> instructions. I've noticed that there appears to be a clarification
> effort in which AArch64 is used as an architecture name when ARMv8 would
> be confusing, which is most of the time if you don't know whether you're
> referring to the new A64 instruction set or the older ones.

Ah, A64... sounds better than AArch64... Even AA64 sounds better than
AArch64....

> Perhaps this is useful if someone is trying to figure out heads or tails
> of the different terms.

Many thanks! I was just googleing what this "T32" thingy was...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
