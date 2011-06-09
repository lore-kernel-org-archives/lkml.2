Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1FIXfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:35:12 -0400
Received: from r00tworld.com ([212.85.137.150]:46307 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1FIXfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:35:09 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Jun 2011 01:33:37 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <4DF15851.20914.243BA32B@pageexec.freemail.hu>
In-reply-to: <20110609064847.GC7734@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.15655.19E64916@pageexec.freemail.hu>, <20110609064847.GC7734@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 10 Jun 2011 01:34:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Jun 2011 at 8:48, Ingo Molnar wrote:
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > On 7 Jun 2011 at 11:56, Ingo Molnar wrote:
> > 
> > > Fedora was able to disable the fixed-address vdso in its newer 32-bit 
> > > distro kernels because it *upgraded glibc*.
> > 
> > and what happened to those apps that users statically linked against
> > the older glibc? what happened to their chroots that had dynamically
> > linked binaries with an older glibc? did you not break those either?
> 
> There's two reasons why a distributor will generally not worry about 
> that case:

so you went from "There was no breakage of binary compatibility." to
saying that you didn't care about it. you could have just admitted it
from the beginning.

