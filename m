Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1FFLVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:21:49 -0400
Received: from r00tworld.com ([212.85.137.150]:37511 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab1FFLVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:21:47 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 13:20:08 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
Reply-to: pageexec@freemail.hu
CC: Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECB7E8.5549.12290923@pageexec.freemail.hu>
In-reply-to: <20110606102419.GA837@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com>, <20110606102419.GA837@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 13:20:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 12:24, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Jun 6, 2011 at 2:50 AM, Andy Lutomirski <luto@mit.edu> wrote:
> > > CONFIG_UNSAFE_VSYSCALLS was added in the previous patch as a
> > > temporary hack to avoid penalizing users who don't build glibc from
> > > git.
> > 
> > I really hate that name.
> > 
> > Do you have *any* reason to call this "unsafe"?
> 
> No, there's no reason at all for that. That naming is borderline 
> security FUD and last time i saw the series i considered renaming
> it but got distracted :-)

security FUD? for real? ;) does that mean that you guys would accept a patch
that would map the vdso at a fixed address for old times's sake? if not, on
what grounds would you refuse it? see, you can't have it both ways.

the fixed address of the vsyscall page *is* a very real security problem, it
should have never been accepted as such and it's high time it went away finally
in 2011AD.

