Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1FHGt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:49:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41605 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab1FHGtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:49:25 -0400
Date: Wed, 8 Jun 2011 08:48:57 +0200
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
Message-ID: <20110608064857.GA6747@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED5985.542.14A05486@pageexec.freemail.hu>
 <20110607083059.GB4133@elte.hu>
 <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEB31B.3353.19E649C2@pageexec.freemail.hu>
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

> On 7 Jun 2011 at 10:30, Ingo Molnar wrote:
> 
> > 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > 
> > > > A fastpath is defined by optimization considerations applied 
> > > > to a codepath (the priority it gets compared to other 
> > > > codepaths), *not* by its absolute performance.
> > > 
> > > we're not talking about random arbitrarily defined paths here 
> > > but the impact of putting well predicted branches into the pf 
> > > handler vs. int xx (are you perhaps confused by 'fast path' vs. 
> > > 'fastpath'?).
> > 
> > So please educate me, what is the difference between 'fast path' 
> > versus 'fastpath', as used by kernel developers, beyond the 
> > space?
> 
> you seemed to have made a distinction, you tell me ;), [...]

I have not made any distinction at all, *you* wrote:

> > > (are you perhaps confused by 'fast path' vs. 'fastpath'?).

and several people have asked you why you wrote that and you have not 
replied to any of those questions yet.

Thanks,

	Ingo
