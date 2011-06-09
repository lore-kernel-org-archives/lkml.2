Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1FIHCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:02:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FIHCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:02:48 -0400
Date: Thu, 9 Jun 2011 09:02:15 +0200
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
Message-ID: <20110609070215.GD7734@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>
 <4DED6AAC.12348.14E3578E@pageexec.freemail.hu>
 <20110607100519.GF4133@elte.hu>
 <4DEEB31B.30013.19E648C8@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEEB31B.30013.19E648C8@pageexec.freemail.hu>
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

> On 7 Jun 2011 at 12:05, Ingo Molnar wrote:
> 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > 
> > > you called this feature "borderline security FUD" but have yet 
> > > to prove it.
> > 
> > No, i did not claim that this feature is "borderline security 
> > FUD", at all.
> 
> so can i take it as your concession that the vsyscall feature is 
> indeed a security problem and it's being randomized/(re)moved for 
> security reasons?

Again, i made two statements:

  "That naming is borderline security FUD"
  "It's only a security problem if there's a security hole elsewhere."

I stand by those statements and i reject your repeated attempts to 
put words in my mouth that i did not say, such as:

   > you called this feature "borderline security FUD" [...]

> in that case the naming of this feature is correct and you have no 
> reason to call it "borderline security FUD". so make up your mind!
> 
> > That the *NAMING* is borderline security FUD. (I already applied 
> > the patches before i wrote that mail, see the commit 
> > notifications on lkml.)
> 
> how can the name be "borderline security FUD" but what the name 
> refers to not be that? you see, we name things for a reason, mostly 
> because we think the name has something to do with the thing it 
> names, duh?

It's borderline security FUD because it suggests that keeping the 
vsyscall around is in itself a security hole. As i outlined whether 
there's *another* bug that *can be exploited* is highly dependent on 
the usecase - while the Kconfig name made no such distinction. (For 
example a device maker might choose to keep the option enabled in 
some embedded usecase, those are pretty limited environments that 
have few vectors of attack.)

Anyway, repeating and explaining my arguments a dozen times did not 
make any difference to you, and there's a point where i have to stop 
wasting time on a person, so i've started filtering out your mails. 
If you want to send me any patches then please send it to any of my 
co-maintainers who will be able to review them.

Thanks,

	Ingo
