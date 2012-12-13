Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2LMHbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:31:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54888 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2LMHbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:31:01 -0500
Date: Thu, 13 Dec 2012 08:30:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
Message-ID: <20121213073056.GA13156@gmail.com>
References: <20121211090910.GA22985@gmail.com>
 <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com>
 <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com>
 <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
 <50C95A21.1010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C95A21.1010101@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> > But doing it this way was wrong. Switch that "exclude_guest" 
> > attribute around, and admit that "H" was bogus, and that the 
> > right thing to do was to add a "V" flag that sets the 
> > "force_guest" flag instead.
> 
> I understand this is annoying. [...]

It's not annoying, it's outright broken - it's a regression that 
we'll fix.

> [...] Older binaries on newer kernels was the only case I 
> could not fix. [...]

The "only" case?? Old, working binaries are actually our _most_ 
important usecase: it's 99.9% of our current installed base ...

> [...] (I guess a message could be added kernel side to at 
> least give a hint.) But the alternative -- based on code that 
> has existed for some time -- is for older binaries to crash 
> VMs.

That should be fixed differently, by not breaking existing 
working functionality.

Thanks,

	Ingo
