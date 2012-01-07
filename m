Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2AGLht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 06:37:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2AGLhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 06:37:48 -0500
Date: Sat, 7 Jan 2012 12:35:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/debug changes for v3.3
Message-ID: <20120107113545.GA28573@elte.hu>
References: <20120105144757.GA6043@elte.hu>
 <CA+55aFzzpMSoRdmqFT7gnH3On43qj8ZVz7C8Dpw6dHB18jtyqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzzpMSoRdmqFT7gnH3On43qj8ZVz7C8Dpw6dHB18jtyqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 5, 2012 at 6:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest x86-debug-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus
> 
> Hell no!
> 
> Why do you send me this sh*t? The "Use NMI instead of 
> REBOOT_VECTOR" commit has been reported to not work AT ALL.
> 
> It was totally broken - Don Zickus sent out the email to fix 
> the completely bogus parenthesis in that commit just a day ago 
> - yet you send me this KNOWN BROKEN CRAP.

My bad.

My primary mistake was that i could have noticed the original 
regression breaking kdump that Yinghai reported - i should have 
delayed the tree until a fix came in - like i delayed a couple 
of other trees that you didn't get sent.

Then, to compound it with another mistake, the fix for the kdump 
breakage was sent to me a couple of hours after i sent you the 
tree - and i havent processed all subsequent mails yet up until 
today - so you noticed it before i did. Double fail.

Anyway, i've queued up the fix and will send you the new tree
after some testing.

> And yes, I checked. The version you sent me is the f*cked one. 
> I was hoping that you would have fixed it up. But no.
> 
> In short, you didn't merge the fix, and yet you sent me a 
> patch series that was *known* to be broken for the last three+ 
> weeks! And I know you were cc'd on the report, which was in 
> the same thread as the automatic tip-bot message for the 
> particular broken commit, so the particular broken commit that 
> introduced it was well-known.
> 
> So that thing has been known broken since before Christmas, 
> and was due to a major typo that made a "atomic_cmpxchg()" not 
> work *at*all* - yet you blithely send me this crap.
> 
> Why? WHAT THE F*CK HAPPENED, INGO?
> 
> Yes, I'm angry as hell. Shit like this should NOT happen.  I 
> don't want people sending me known-buggy pull requests.

You are perfectly right, i messed up - sorry about that.

Thanks,

	Ingo
