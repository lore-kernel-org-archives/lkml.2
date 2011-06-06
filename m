Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1FFQVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:21:25 -0400
Received: from r00tworld.com ([212.85.137.150]:34812 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab1FFQVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:21:23 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Mon, 06 Jun 2011 18:19:36 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DECFE18.23229.133B32ED@pageexec.freemail.hu>
In-reply-to: <20110606155953.GB7374@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DECF6E8.19026.131F1F1F@pageexec.freemail.hu>, <20110606155953.GB7374@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 18:20:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 17:59, Ingo Molnar wrote:

> > > FYI, incredible amount of work has gone into making pagefaults as 
> > > fast and scalable as possible.
> > 
> > i wasn't talking about scalability (it's irrelevant anyway here), 
> > only speed. [...]
> 
> Which part of "fast and scalable" did you not understand?

uhm, not sure why you're so worked up here. is it because i said
'scalability' was completely irrelevant for the nx vsyscall page
approach? elaborate!

> Just a couple of days ago i noticed a single cycle inefficiency in 
> the pagefault fastpath, introduced in the 3.0 merge window. I 
> requested (and got) an urgent fix for that:

so you must have measurements. what's the mentioned page faults take
in cycles before/after your fix? what's a normal int xx path take?

> So i ask you again, what is your basis for calling the #PF path on 
> Linux a 'slowpath'? Is Linus's and my word and 5 years of Git history 
> showing that it's optimized as a fastpath not enough proof for you?

which part of

> you must have realized by now that slow/fast path in this context were
> relative to int xx vs. pf processing.

did you not understand? do you have "Linus's and my word and 5 years of
Git history" to show that pf processing is seriously that much faster
than int xx processing?

