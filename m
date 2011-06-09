Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1FIXfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:35:19 -0400
Received: from r00tworld.com ([212.85.137.150]:46311 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1FIXfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:35:13 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Fri, 10 Jun 2011 01:33:29 +0200
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
Message-ID: <4DF15849.13114.243B8330@pageexec.freemail.hu>
In-reply-to: <20110609070215.GD7734@elte.hu>
References: <cover.1307292171.git.luto@mit.edu>, <4DEEB31B.30013.19E648C8@pageexec.freemail.hu>, <20110609070215.GD7734@elte.hu>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Fri, 10 Jun 2011 01:34:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Jun 2011 at 9:02, Ingo Molnar wrote:

> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > so can i take it as your concession that the vsyscall feature is 
> > indeed a security problem and it's being randomized/(re)moved for 
> > security reasons?
> 
> Again, i made two statements:
> 
>   "That naming is borderline security FUD"
>   "It's only a security problem if there's a security hole elsewhere."
> 
> I stand by those statements and i reject your repeated attempts to 
> put words in my mouth that i did not say, such as:
> 
>    > you called this feature "borderline security FUD" [...]

it's no more putting words into your mouth than your own attempt:

> You generally seem to assume that security is an absolute goal 
> with no costs attached.

(for which i'm still waiting for an actual proof btw ;)

also, notice i didn't quote you ("..." or >... style), i simply paraphrased
what you said and explained why. i got no response to those arguments though
so i guess you conceded them. then why do you keep arguing the same nonsense?

> > how can the name be "borderline security FUD" but what the name 
> > refers to not be that? you see, we name things for a reason, mostly 
> > because we think the name has something to do with the thing it 
> > names, duh?
> 
> It's borderline security FUD because it suggests that keeping the 
> vsyscall around is in itself a security hole.

it's not a hole per se, rather it's an accessory to writing reliable
exploits (not only userland ones btw). that's the *only* reason this
patchset even exists. do you deny that? now, if you don't deny it then
you also agree that the current vsyscall page *is* a security problem
(problem != hole). therefore the suggested name for the config option
that removes it for good cannot be "borderline security FUD".

> As i outlined whether there's *another* bug that *can be exploited* is
> highly dependent on the usecase - while the Kconfig name made no such
> distinction. (For example a device maker might choose to keep the
> option enabled in some embedded usecase, those are pretty limited
> environments that have few vectors of attack.) 

but you see, your own argument defeats your point: if for another use
case the presence of the vsyscall page *is* a security hazard (like,
i don't know, every single server and desktop out there?) then *not*
making it clear in the option name *is* a problem. see how it cuts
both ways? what now? ;) prudent people err on the side of safety.

also if the above device maker disables it even if their devices would
never ever be exploited using the vsyscall page, they haven't lost anything.
heck, they'll have reduced their kernel image and gained some all too
important cycles ;).

> Anyway, repeating and explaining my arguments a dozen times

repeated - yes, explained - no, that's the problem. you didn't even address
what *i* said (how many questions of mine have you left unanswered?). i'm
guessing because you realized how wrong you were but you're not the kind of
person who'd admit it.

> did not make any difference to you, and there's a point where i have
> to stop wasting time on a person, so i've started filtering out your
> mails. If you want to send me any patches then please send it to any
> of my co-maintainers who will be able to review them. 

PS: thanks for the cycles^Wchuckles ;)

