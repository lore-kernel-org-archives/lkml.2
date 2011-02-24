Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1BXV37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:29:59 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab1BXV35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:29:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76507277"
Message-ID: <4D66CDD4.7080103@codeaurora.org>
Date: Thu, 24 Feb 2011 13:29:56 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: Update MSM maintainers
References: <1298419415-3973-1-git-send-email-davidb@codeaurora.org>	 <1298420395.17118.6.camel@m0nster>	 <AANLkTikuaOL7mdARoNtx2ZJGJm6FBrqizrit6_uSaUte@mail.gmail.com>	 <4D657B69.4000107@codeaurora.org> <1298512932.17118.16.camel@m0nster>
In-Reply-To: <1298512932.17118.16.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 06:02 PM, Daniel Walker wrote:

> There's nothing really to figure out. I don't feel like you and David
> can do the job alone. My intentions are just to make sure that you don't
> mess with my targets, and that you do the right thing by the community.
> 
> Daniel

I'd like to address the points you mention.  I disagree with your
personal feelings about David's suitability for the task.  David has
been involved with Linux MSM development for it's entire history.  This
is important because he knows the HW behavior and SW designs for all the
MSM chips and drivers.  This gives him the context to recognize
potentially subtle interactions and behavioral issues.  I hope you would
agree that this type of expertise and insight is valuable for any
maintainer to have.  Regarding his ability to do this on his own, public
maintainership of the MSM architecture is David's primary
responsibility.  I agree that this is a somewhat new role for him, but
maintainers have to start somewhere.  From what I've seen so far, David
is showing the proper maturity and judgement expected from a
maintainer.  As an example, I would point to David's handling of Arnd's
comments in this thread; https://lkml.org/lkml/2010/12/16/434.  This
caused a considerable amount re-work and testing for us but David made
sure that it was addressed and resolved correctly and in a timely manner.

For your second point, would you please explain how we're "messing with
your targets"?  I understand that you have a personal interest in
getting G1 and NexusOne support into the kernel.  This is a great goal
and I would encourage you to continue with this effort.  We're happy to
accept any patches you submit in this regard.  Additionally, I think you
would provide value to the MSM maintainer and the community by testing
patches on these targets once there is support for them in the kernel.
However, I would like to point out that the MSM architecture includes
much more that just G1 or NexusOne.  By my last last count, there were
about 47 MSM machines registered.

For your last point, would you please explain why it falls to you to
"make sure ... that we do the right thing by the community"?  We are
trying very hard to become good citizens in the Linux kernel development
community.  This is not always an easy thing to do.  The issues with SOC
vendors are well known.  I think the fact that one of our key MSM
developers, David Brown, has stepped up to handle public maintainership
of the MSM architecture, as well as the fact that many of our developers
are now submitting patches upstream, demonstrates that we are trying to
do the right thing.  I'm sure there are lots of areas where we could
improve and many things we could do better.  This is a learning process
for many of us.  If you have specific examples of things that should be
fixed or could be done better, please let us know.  That kind of
feedback is why we're participating and sending patches out for public
review in the first place.  If you have specific examples of us doing
wrong by the community please share those as well.  To my knowledge, no
such issues have been raised by anyone in the community so far.

Finally, it's my hope that you and Linux community will help and support
David as the MSM maintainer by reviewing MSM-related patches and
pointing out areas where the MSM architecture could be improved.  In
this spirit, I'm asking you to please acknowledge the patch that started
this email chain.  Please let the MSM developers take full
responsibility for the MSM architecture.  That is, after all, what the
community typically asks from SOC vendors.  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
