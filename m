Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1BDSK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:10:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1BDSK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:10:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73014406"
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>, Greg KH <greg@kroah.com>,
        David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <20110204174244.GA7396@flint.arm.linux.org.uk>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
	 <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
	 <20110202200030.GA26104@flint.arm.linux.org.uk>
	 <20110202203252.GD28479@kroah.com>
	 <20110202204453.GB26104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
	 <1296839855.4078.12.camel@m0nster>
	 <20110204174244.GA7396@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 10:10:55 -0800
Message-ID: <1296843055.4078.25.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 17:42 +0000, Russell King wrote:
> So you tell me - do I take the p2v stuff out of public view tonight
> because it's not stable, and therefore you don't even know about the
> conflict?
> 
> Or do I continue publishing the unstable changes so that people have
> the ability to see what's going on in my tree and find potential
> conflicts?
> 
> I really don't care which - but I'll warn you that keeping changes
> hidden will result in a reduction of patch quality, and much much
> much less testing of those changes.  And I won't care at all when you
> complain that MSM's broken because of one of my patches.
> 
> Exactly what would you prefer? 

I'm not really opposed to any of your objectives. What it sounds like is
that you have a "stable" branch, and an "unstable" branch. Both branches
are in linux-next , and we're seeing conflicts from the unstable one. Is
that accurate?

I think we can deal with the issues as long as you have one branch that
you don't rebase, and things eventually move into that branch. So if we
have a conflict then we can base our tree on your stable branch , and
have confidence that your not rebasing it, or merge that into our tree.

I think the problem is that when you say your rebase it's not clear if
your rebasing all your branches, or if you only rebasing one unstable
branch..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


