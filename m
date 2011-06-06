Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1FFSr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:47:26 -0400
Received: from r00tworld.com ([212.85.137.150]:47919 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab1FFSrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:47:24 -0400
From: pageexec@freemail.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 06 Jun 2011 20:46:06 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
Reply-to: pageexec@freemail.hu
CC: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DED206E.20356.13C155EA@pageexec.freemail.hu>
In-reply-to: <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DECAE68.16683.1203EBBB@pageexec.freemail.hu>, <BANLkTin5jEmUUxWUUkYn9pKzGRwcA-zRLw@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Mon, 06 Jun 2011 20:46:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 22:56, Linus Torvalds wrote:

> On Mon, Jun 6, 2011 at 7:39 PM,  <pageexec@freemail.hu> wrote:
> >
> > what is annoying is your covering up of security fixes on grounds that you don't want
> > to help script kiddies (a bullshit argument as it were) but at the same time question
> > proactive security measures (one can debate the implementation, see my other mail) that
> > would *actually* prevent the same kiddies from writing textbook exploits.
> 
> Shut up unless you have any real arguments. I know you have your
> hangups, and I just don't care.

i have real arguments, i told them to you but i have yet to see anything
expect silly name calling from you. is that the best you can do? seriously?

> Calling the old vdso "UNSAFE" as a config option is just plain stupid.
> t's a politicized name, with no good reason except for your political
> agenda. And when I call it out as such, you just spout the same tired
> old security nonsense.

i didn't choose this name, Andy did but i happen to agree with it. whether
you like it or not is frankly and quite obviously irrelevant to me ;). as
for political agenda, tell me more, i'd like to know what it is. exposing
your lies to the public about doing full disclosure but still covering up
the security fixes is not politics, it's called honesty. not yours, mine.
maybe that's what bothers you.

> I'm happy with perhaps moving away from the fixed-address vdso,

it's not about the vdso that has been mmap'ed and randomized for quite some
time now. it's about the amd64 specific vsyscall page.

> but that does not excuse bad naming and non-descriptive crap like the
> feature-removal thing, and all the insanity going on in the thread. If
> the config option is about removing the legacy vdso, then CALL IT
> THAT, instead of spouting idiotic and irrelevant nonsense.

noone wants to remove the legacy vdso as one can simply configure out that
option already. it's about introducing a similar option for vsyscall.

