Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0KKG6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:58:04 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33614 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0KKG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:58:01 -0500
Date: Wed, 10 Nov 2010 22:56:58 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: matthieu castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101111065658.GA5876@outflux.net>
References: <20101107193520.GO5327@outflux.net>
 <20101108061324.GA30540@elte.hu>
 <20101108214228.GQ5876@outflux.net>
 <20101110090415.GC8370@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110090415.GC8370@elte.hu>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Wed, Nov 10, 2010 at 10:04:15AM +0100, Ingo Molnar wrote:
> * Kees Cook <kees.cook@canonical.com> wrote:
> > Oh, well, yes, that's a good reason. :) Where was this covered? I'd like to help 
> > get it reproduced and ironed out.
> 
> Matthieu Castet seems to have dusted off those patches and submitted two of them in 
> this mail:
> 
>   Subject: [RFC] reworked NX protection for kernel data
> 
> Matthieu, are you still interested in this topic?
> 
> The original, broken patches were these -tip commits:
> 
>  1e858c081af5: x86, mm: RO/NX protection for loadable kernel modules
>  18c60ddc9eff: x86, mm: NX protection for kernel data
>  c226a2feba21: x86, mm: Set first MB as RW+NX
>  b29d530510d4: x86, mm: Correcting improper large page preservation
> 
> I reported one of the crashes in:
> 
>   Subject: Re: [tip:x86/mm] x86, mm: Set first MB as RW+NX
> 
> on lkml.

Thanks for looking this up!

Can we get 1e858c081af5 and 18c60ddc9eff back in, and then work forward
from there?

-Kees

-- 
Kees Cook
Ubuntu Security Team
