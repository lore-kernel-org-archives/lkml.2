Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1EPLiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:38:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51717 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1EPLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:38:22 -0400
Date: Mon, 16 May 2011 12:37:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Glauber Costa <glommer@redhat.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris McDermott <lcm@us.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: manual merge of the tip tree with the arm tree
Message-ID: <20110516113707.GQ30539@n2100.arm.linux.org.uk>
References: <20110513083738.GA19733@n2100.arm.linux.org.uk> <20110513092646.GK13647@elte.hu> <20110513213640.GB30539@n2100.arm.linux.org.uk> <20110516073144.GF24836@elte.hu> <20110516074230.GI30539@n2100.arm.linux.org.uk> <20110516091744.GB12325@elte.hu> <20110516091927.GK30539@n2100.arm.linux.org.uk> <20110516094056.GA25039@elte.hu> <20110516100750.GN30539@n2100.arm.linux.org.uk> <20110516110652.GC19837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516110652.GC19837@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 01:06:52PM +0200, Ingo Molnar wrote:
> 
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Mon, May 16, 2011 at 11:40:56AM +0200, Ingo Molnar wrote:
> > >    maintainers (and not assume lack of ack after 24 hours means acceptance), or 
> > 
> > Wrong, 72 to 96 hours.  Sunday to Wednesday/Thursday.
> 
> Not that this is really material (the argument is pretty much the same even had 
> you waited 3 days), but you are already wrong about the 'Sunday' part, because 
> you posted it to lkml on *Monday* 13:27 GMT:
> 
>         Message-ID: <20110509132738.GB16919@n2100.arm.linux.org.uk>
>         Mon, 9 May 2011 09:27:52 -0400

Sigh.  So you're only looking at the _second_ posting of them, not the first.
Here's the message, minus the patch.

| Date: Sun, 8 May 2011 19:24:07 +0100
| From: Russell King - ARM Linux <linux@arm.linux.org.uk>
| To: Ralf Baechle <ralf@linux-mips.org>, John Stultz <johnstul@us.ibm.com>,
|         "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
| Subject: i8253 clocksource consolidation
| Message-ID: <20110508182407.GN27807@n2100.arm.linux.org.uk>
| 
| Ralf, John, Ingo, hpa,
| 
| Below you'll find a work in progress patch.  We have three i8253 PIT
| clocksource implementations in the kernel tree, which are all very
| similar.  It seems pointless to have three copies of the code knocking
| about, so this patch creates a common version in drivers/clocksource.
| 
| This is a combined patch; I have it broken out into a series locally,
| and follows on from other consolidation work which I've been doing with
| ARM clocksources.
| 
| This patch build-tests cleanly on ARM for NetWinder (one of the footbridge
| platforms which uses an i8253.)
| 
| So, do we think moving this to drivers/clocksource in this way is a
| good idea?  Any other comments?  If feedback is positive, I'll rebase
| them onto mainline, add the necessary cc's, and send them out properly.

To which I had this _single_ response:

| Date: Mon, 9 May 2011 14:07:35 +0100
| From: Ralf Baechle <ralf@linux-mips.org>
| To: Russell King - ARM Linux <linux@arm.linux.org.uk>
| Cc: John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
|         Ingo Molnar <mingo@redhat.com>
| 
| I like this patch; it's been long overdue and and while atm the patch
| does not seem to apply it seems to be mostly right.
| 
|   Ralf

And "it doesn't seem to apply" is precisely what I expected with the patch
because of the conflicts with _other_ work which was in progress, and as I
was asking in the original message about the _idea_, that is perfectly
acceptable.

> How hard can it be for you to look up the dates of the events before you
> accuse others of not listening?

I think I've just proven above that it was Sunday, not Monday.

> Then you committed/amdended it on Tuesday 7:20 GMT:
> 
>  commit 3490f584b9ba5a0b6f63832fbc9c5ec72506697b
>  Author:     Russell King <rmk+kernel@arm.linux.org.uk>
>  AuthorDate: Sun May 8 18:55:19 2011 +0100
>  Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
>  CommitDate: Tue May 10 08:20:54 2011 +0100

Yes.  Committed on _Sunday_ before I sent out the _first_ message which
I've included above.  Then tweaked and after Ralf's response, the series
was then posted on _Monday_ in full.  Then John responded with his ack,
which caused the amendment on _Tuesday_ morning.

And then _36_ further hours passed before the branch was merged into
for-next on _Wednesday_ _evening_.  So, Sunday evening to Wednesday
evening.  Three times 24 is 72 hours, which is what I corrected you to.

> which is a mere 18 hours after it was mailed to lkml - and then you pushed it 
> out to linux-next some time after that, probably on the next day, Wednesday, 
> right?

Are you _seriously_ trying to tell me that you have a problem with a commit
dated 18 hours after being mailed out?  If so, you're being rediculous here.

Obviously I shouldn't have added John's ack, which was sent during Monday
nighttime to the commit so quickly, but instead waited a week before doing
so.  Had I done that you wouldn't be complaining about "24 hours" or "18
hours".

> It does not matter one little bit that you'd have been 'ready to rebase' once 
> more had some objection come in that short 2 days time window from Monday to 
> Wednesday, or any of the dates after that.

Well, stop making such a big deal about "24 hours" or "18 hours" then,
but start realizing that the commit date is actually a total
_irrelevance_ to the time that it appeared in linux-next.

Your continual waving of that point, and reduction in time period, just
shows that you're trying to make this a _political_ issue, not a technical
or social one, which again is born out by the amount of people _you_ added
to this thread.

> What i'm saying for the fourth time is that what you did here is not a proper 
> Git workflow: we only push bits out into permanent branches (and expose them to 
> conflicts, etc.) once they are final, and we only do that after making sure 
> that maintainers who maintain the trees of the affected files are fine with it 
> and make sure that there are no conflicts.

Well, the fact that I messed up the function name was unfortunate and
should've been caught locally, which I appologize for.  I would have
thought that much was obvious, but since you seem to believe that I
_intentionally_ broke the x86 build.

Anyway, the issue has been resolved _properly_ over the weekend, off-list,
between Thomas and myself, in a way that results in no conflicts being
exposed in any tree.
