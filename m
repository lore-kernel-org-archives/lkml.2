Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1FHJP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:15:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab1FHJP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:15:56 -0400
Date: Wed, 8 Jun 2011 11:15:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
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
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110608091531.GA8761@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
 <20110608064857.GA6747@elte.hu>
 <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>
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

> On 8 Jun 2011 at 8:48, Ingo Molnar wrote:
> 
> > > you seemed to have made a distinction, you tell me ;), [...]
> > 
> > I have not made any distinction at all, *you* wrote:
> 
> i asked you that question because for all this time you seemed to 
> have been very worked up by the fact that i called the page fault 
> path as not 'fast'. i thought maybe what caused your nervous 
> reaction and desperate attempts at trying to justify it was due to 
> some misunderstanding in wording, but i now see that we probably 
> talked about the same thing. with the exception that you *still* 
> have not provided any evidence for your claim. why is that Ingo? do 
> you have nothing to prove your single cycle 'improvemnt'? (sorry, 
> had a chuckle again ;).

You are again trying to shift the topic. Your original claim, which 
you snipped from your reply:

  > a page fault is never a fast path

is simply ridiculous on its face and crazy talk, and no amount of 
insults you hurl at me will change that fact - you ignored the 
various pieces of evidence that i cited that the page fault code is 
very much a fastpath: past commits, cycles estimations, a list of 
various (obvious) types of impact, the statements of several 
prominent kernel developers (including Linus) that establish that the 
page fault path is very much treated as a fastpath by everyone who 
develops it and you also ignored the fact that there's a working 
alternative that has none of those disadvantages.

Thanks,

	Ingo
