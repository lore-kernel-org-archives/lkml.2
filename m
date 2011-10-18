Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab1JRHMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:12:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1JRHMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E9CA772.4000509@zytor.com>
References: <1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	<20111017045806.GA11561@elte.hu>
	<alpine.LFD.2.02.1110171101250.3240@ionos>
	<20111017184916.GA5545@elte.hu>
	<4E9C917B.2050802@zytor.com>
	<20111017211951.GA8043@elte.hu>
	<4E9C9CAE.9090207@zytor.com>
	<20111017213958.GA27126@elte.hu>
	<4E9CA772.4000509@zytor.com>
Date: Tue, 18 Oct 2011 09:12:20 +0200
X-Google-Sender-Auth: KHMhYIzt4e1uIo4jgyLFZyJpYNQ
Message-ID: <CAMuHMdVRV6jx3Lj27U=xmM8QJWAcrKvLH6o1yTWVM1Ag6XkU-Q@mail.gmail.com>
Subject: Re: Linux 3.1-rc9
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 00:08, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/17/2011 02:39 PM, Ingo Molnar wrote:
>>> We can do much better than that with reciprocal multiplication.
>>
>> Yes, 2^64/1e9 is the reciprocal.
>
> What I mean is that it's pretty easy to work it so it doesn't have the
> errors.  We have 32*32 = 64 multiplication on all 32-bit platforms I'm
> 99.9% sure.

I assume you mean "we have in hardware"?

Is that muldi3?

$ git ls-files "*muldi3*"
arch/arm/lib/muldi3.S
arch/blackfin/lib/muldi3.S
arch/frv/lib/__muldi3.S
arch/m68k/lib/muldi3.c
arch/microblaze/lib/muldi3.c
arch/sparc/lib/muldi3.S
$

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
