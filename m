Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1FHJa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:30:57 -0400
Received: from r00tworld.com ([212.85.137.150]:48219 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1FHJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:30:55 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Wed, 08 Jun 2011 11:29:37 +0200
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
Message-ID: <4DEF4101.17745.1C109461@pageexec.freemail.hu>
In-reply-to: <20110608071620.GB6747@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>, <20110608071620.GB6747@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 11:30:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Jun 2011 at 9:16, Ingo Molnar wrote:

> The thing is, as i explained it before, your claim:
> 
>   > a page fault is never a fast path
> 
> is simply ridiculous on its face and crazy talk.

you didn't *explain* a thing. you *claimed* something but offered *no*
proof. where's your measurement showing the single cycle improvement?
how many times do i get to ask you for it before you're willing to provide
it? does it even exist? you see, i'm beginning to think that you simply
just made up that claim, or in plain english, you lied about it. is that
really the case?

> Beyond all the reasons why we don't want to touch the page fault path 
> we have a working, implemented, tested IDT based alternative approach 
> here that is faster

btw, the pf based approach can be made as fast as well since the necessary
checks can be moved up early. but then we'll face the single cycle brigade ;).

> and more compartmented 

what does that even mean here? the pf based approach is less code btw.

> Even if you do not take my word for it, several prominent kernel 
> developers told you already that you are wrong,

you must have been reading a different thread or i wasn't cc'd on those
claims. care to quote them back (i only remember Pekka's mail and he has
yet to back up his claim about single/low cycle counts being important
for the bootup case)?

also claiming something and proving something are different things. as
i told you already, ex cathedra statements don't work here.

> and i also showed you  the commits that prove you wrong.

unfounded single cycle improvement claims don't a proof make. show your
measurements instead. provided they exist that is.

> Your reply to that was to try to change the topic,

what change are you talking about? you insisted on calling the pf path
fast and your single cycle improvements relevant, you get to prove it.

> laced with frequent insults thrown at me. You called me an 'asshole' yet
> the only thing i did was that i argued with you patiently.

i wish you had argued (i.e., presented well thought out, true and releavant
statements) but instead you only threw out completely baseless accusations,
insinuations, or even outright lies, never mind the several ad hominem
statements that i generously overlooked since unlike you, i can handle
the heat of a discussion ;). IOW, stop pretending to be the hurt angel
here, you're very far from it.

> Is there *any* point where you are willing to admit that you are 
> wrong or should i just start filtering out your emails to save me all 
> this trouble?

sure, just prove me wrong on a claim and i'll admit it ;).

> When you comment on technical details you generally 
> make very good suggestions so i'd hate to stop listening to your 
> feedback, but there's a S/N ratio threshold under which i will need 
> to do it ...

you sound like i care about who you listen to. if you're a mature person
you might as well act as one. like start answering the questions i posed
you in the last round of emails then we'll see about that S/N ratio.

