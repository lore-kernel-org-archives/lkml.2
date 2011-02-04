Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1BDRRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:17:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33844 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1BDRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:17:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6245"; a="73215820"
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
From: Daniel Walker <dwalker@codeaurora.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
References: <20110131131401.5d6c7646.sfr@canb.auug.org.au>
	 <8ya4o8m70jp.fsf@huya.qualcomm.com> <20110202194359.GC27065@kroah.com>
	 <20110202200030.GA26104@flint.arm.linux.org.uk>
	 <20110202203252.GD28479@kroah.com>
	 <20110202204453.GB26104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1102021557530.8212@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 09:17:34 -0800
Message-ID: <1296839855.4078.12.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 16:47 -0500, Nicolas Pitre wrote:
> The actual problem here is that some people, notably the msm folks,
> are 
> bypassing the maintainer hierarchy and going straight to Linus for
> their 
> pull requests instead of asking RMK to pull.  We once debated this at 

I don't think it's fair to single out MSM here. Going straight to Linus
was discussed at one point, as I recall, and Russell didn't oppose it at
the time. There are a number of ARM sub-architecture maintainers that do
this.. None of that is related to the rejects created here, those would
happen no matter who we submitted pull requests to.

I think the issue is more that MSM is actively being cleanup , and
Russell is touching code that we're working on also. So we need a way to
work together .. In this case the collision is so simple that either
Linus or Russell would just fix it up while pulling, and both would
likely be fine with that. In the past I've tried to fix up these issues,
but now I think maybe it's doesn't matter.

In terms of Russell rebasing, I don't really like that. I've based MSM
trees on Russell's stable branch and it's worked in the past. If
Russell's rebasing then we can't really do that, so one tool to fix
these problems is gone.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


