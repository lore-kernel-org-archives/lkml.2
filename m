Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1BDTkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:40:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:33955 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1BDTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:40:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 04 Feb 2011 14:40:04 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1296839855.4078.12.camel@m0nster>
Message-id: <alpine.LFD.2.00.1102041421310.12104@xanadu.home>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
 <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
 <20110202200030.GA26104@flint.arm.linux.org.uk>
 <20110202203252.GD28479@kroah.com>
 <20110202204453.GB26104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
 <1296839855.4078.12.camel@m0nster>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011, Daniel Walker wrote:

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
> this..

The point still stands for msm as well as for the others.  And this is 
now causing fuss amongst second guessers as this thread is showing.  
But this aside, this is still putting more load on Linus while this load 
could be more distributed.

> None of that is related to the rejects created here, those would
> happen no matter who we submitted pull requests to.

Indeed.  And trivial is the fix, which is what I've said too.

> I think the issue is more that MSM is actively being cleanup , and
> Russell is touching code that we're working on also. So we need a way to
> work together .. In this case the collision is so simple that either
> Linus or Russell would just fix it up while pulling, and both would
> likely be fine with that. 

Exact.

Maybe this would be nicer to Russell and others performing wide ranging 
changes to the ARM code if the msm tree was more visible downstream, and 
potentially help to avoid making a mountain out of a mole hill.

> In the past I've tried to fix up these issues,
> but now I think maybe it's doesn't matter.

I'm sure Stephen knows about git's rerere facility, or he might have 
developed one of his own by now, hence his proposal to carry simple 
conflict resolution for as long as required.  So yes, I don't think this 
is something that must be "fixed" if carrying the fix in the downstream 
tree causes more trouble than the trivial merge involved.

> In terms of Russell rebasing, I don't really like that. I've based MSM
> trees on Russell's stable branch and it's worked in the past. If
> Russell's rebasing then we can't really do that, so one tool to fix
> these problems is gone.

Russell has so named his "stable" branch for a reason.  I'll let you 
guess what it is.  :-)


Nicolas
