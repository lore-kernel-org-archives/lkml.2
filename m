Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1FIGtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:49:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39718 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1FIGtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:49:16 -0400
Date: Thu, 9 Jun 2011 08:48:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to
 COMPAT_VSYSCALLS
Message-ID: <20110609064847.GC7734@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
 <20110607095637.GE4133@elte.hu>
 <4DEEB31B.15655.19E64916@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEB31B.15655.19E64916@pageexec.freemail.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 7 Jun 2011 at 11:56, Ingo Molnar wrote:
> 
> > Fedora was able to disable the fixed-address vdso in its newer 32-bit 
> > distro kernels because it *upgraded glibc*.
> 
> and what happened to those apps that users statically linked against
> the older glibc? what happened to their chroots that had dynamically
> linked binaries with an older glibc? did you not break those either?

There's two reasons why a distributor will generally not worry about 
that case:

 - No such binaries come with a default distro install

 - Keeping such old libraries linked or chrooted can be a security
   hole in itself, so i dou guarantee something like this.

If another distribution considers this a serious enough issue it can 
keep the COMPAT_VDSO option enabled forever. Few (none?) did.

Thanks,

	Ingo
