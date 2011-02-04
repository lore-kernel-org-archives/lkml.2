Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1BDRnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:43:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43780 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab1BDRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:43:18 -0500
Date: Fri, 4 Feb 2011 17:42:44 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Nicolas Pitre <nico@fluxnic.net>, Greg KH <greg@kroah.com>,
        David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20110204174244.GA7396@flint.arm.linux.org.uk>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au> <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com> <20110202200030.GA26104@flint.arm.linux.org.uk> <20110202203252.GD28479@kroah.com> <20110202204453.GB26104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1102021557530.8212@xanadu.home> <1296839855.4078.12.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296839855.4078.12.camel@m0nster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:17:34AM -0800, Daniel Walker wrote:
> On Wed, 2011-02-02 at 16:47 -0500, Nicolas Pitre wrote:
> > The actual problem here is that some people, notably the msm folks,
> > are 
> > bypassing the maintainer hierarchy and going straight to Linus for
> > their 
> > pull requests instead of asking RMK to pull.  We once debated this at 
> 
> I don't think it's fair to single out MSM here. Going straight to Linus
> was discussed at one point, as I recall, and Russell didn't oppose it at
> the time. There are a number of ARM sub-architecture maintainers that do
> this.. None of that is related to the rejects created here, those would
> happen no matter who we submitted pull requests to.
> 
> I think the issue is more that MSM is actively being cleanup , and
> Russell is touching code that we're working on also. So we need a way to
> work together .. In this case the collision is so simple that either
> Linus or Russell would just fix it up while pulling, and both would
> likely be fine with that. In the past I've tried to fix up these issues,
> but now I think maybe it's doesn't matter.
> 
> In terms of Russell rebasing, I don't really like that. I've based MSM
> trees on Russell's stable branch and it's worked in the past. If
> Russell's rebasing then we can't really do that, so one tool to fix
> these problems is gone.

The alternative is that I don't publish patches in git form.  Or do I
publish patches in git form and never add any acks or tested-by
information to them ever.

It's really no skin off my nose if I never add any acks, tested-by or
reviewed-by tags to my patches - it actually means _less_ work for me.
I'd prefer to give credit where credit is due, but if idiotic rules
mean that I can't, that's really not my problem.

Goody, I can spend that time doing more productive work.

So, here's a questionaire:

1. Would it be acceptable to keep the p2v changes hidden from public view
via git for months, and only available in patch form as I'm waiting for
acks from people?

2. Would you have found this if these changes weren't in linux-next?

3. Would you have found it by applying my patches from the mailing list to
your tree?

4. Is it acceptable not to acknowledge people who've tested and reviewed?

The answers are most probably: no, no, no and no.

And now you see my dilema: 1 is incompatible with 4.

I argue that you're better off _seeing_ the changes via git and linux-next
because then linux-next can pick up these conflicts when they happen and
we can sort out the resulting mess when that happens.

I've no problem _eventually_ freezing the p2v branch, but the p2v stuff is
currently in flux: althrough I've requested acks from Nicolas, none are
forthcoming yet - and there's going to be some further work:

| > Thanks, merged those in.  Can I have new acks for the p2v branch please?
|
| Yes, hopefully soon.  I should also restore Thumb2
| support in the process.

So you tell me - do I take the p2v stuff out of public view tonight
because it's not stable, and therefore you don't even know about the
conflict?

Or do I continue publishing the unstable changes so that people have
the ability to see what's going on in my tree and find potential
conflicts?

I really don't care which - but I'll warn you that keeping changes
hidden will result in a reduction of patch quality, and much much
much less testing of those changes.  And I won't care at all when you
complain that MSM's broken because of one of my patches.

Exactly what would you prefer?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
