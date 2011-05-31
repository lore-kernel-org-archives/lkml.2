Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab1EaS5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:57:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:42995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab1EaS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:57:43 -0400
Date: Tue, 31 May 2011 20:57:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andy Lutomirski <luto@MIT.EDU>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to
 feature-removal-schedule
In-Reply-To: <20110531183448.GA27166@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105312056120.3078@ionos>
References: <cover.1306851090.git.luto@mit.edu> <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu> <20110531183448.GA27166@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Andi Kleen wrote:
> > +What:	CONFIG_UNSAFE_VSYSCALLS (x86_64)
> > +When:	When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
> > +Why:	Having user-executable code at a fixed address is a security problem.
> > +	Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
> > +	make the time() function slower on glibc versions 2.13 and below.
> 
> I disagree with this description (and the whole idea really)
> 
> First it's time+gettimeofday+vgetcu, not just time.
> 
> A more accurate description is 
> 
> "will make all x86-64 Linux programs written to the original pre
> vDSO syscall ABI significantly slower"
> 
> And the assumption that all world is using glibc is still as bad
> as it was on the first po.st
> 
> And it's still a bad idea. Especially since there's a much better
> alternative anyways for the "security problem" which has none of 
> these drawbacks.

How about posting an alternative patch?

Thanks,

	tglx
