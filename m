Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab1FGX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:26:45 -0400
Received: from r00tworld.com ([212.85.137.150]:50290 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051Ab1FGXZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:25:52 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 01:24:11 +0200
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
Message-ID: <4DEEB31B.19443.19E64A01@pageexec.freemail.hu>
In-reply-to: <20110607101315.GG4133@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>, <20110607101315.GG4133@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 01:24:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 Jun 2011 at 12:13, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > > You generally seem to assume that security is an absolute goal 
          ^^^^^^^^^
> > > with no costs attached.
> > 
> > quote me on that back please or admit you made this up. [...]
> 
> Just one quick example of your delusion:
> 
>    |
>    | "a page fault is never a fast path"
>    |

i don't see 'security', 'absolute', 'goal' and 'cost' in the above, do you?
(btw, nice try to extract a single sentence out of context, looks like you're
running out of steam if you have to descend this low ;)

but more importantly, did you see 'generally' above? do you think a single
sample would justify it? i think even you're not that dumb. or maybe that's
how you cook up your performance measurements too?

so try harder. say, find all the PaX features i implemented over the years,
see what kind of decisions i made, determine which one was for or against
performance (vs. security, usability, etc) and then let's see if you can
draw your conclusion or not. until then, you stay in the hole you dug
yourself into ;).

>    (PageExec, Jun 6, 2011)
> 
>    http://lkml.org/lkml/2011/6/6/209
> 
> I think that sentence will become a classic quote to chuckle about.

heh, if Ingo 'single cycle' Molnar says so... i'm still ROTFL whenever
i think about it, it was really priceless, thank you! ;)))))

