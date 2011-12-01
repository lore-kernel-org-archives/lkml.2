Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1LAURV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 15:17:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17975 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1LAURS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 15:17:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6547"; a="142814584"
Date: Thu, 1 Dec 2011 12:17:09 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Message-ID: <20111201201709.GA24943@huya.qualcomm.com>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
 <1322752657.3704.2.camel@m0nster>
 <20111201181736.GA13182@huya.qualcomm.com>
 <1322764745.3704.9.camel@m0nster>
 <20111201192705.GA23641@huya.qualcomm.com>
 <1322767992.3704.13.camel@m0nster>
 <20111201194353.GA24293@huya.qualcomm.com>
 <1322769207.3704.19.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322769207.3704.19.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:53:27AM -0800, Daniel Walker wrote:
> On Thu, 2011-12-01 at 11:43 -0800, David Brown wrote:
> > On Thu, Dec 01, 2011 at 11:33:12AM -0800, Daniel Walker wrote:
> > > On Thu, 2011-12-01 at 11:27 -0800, David Brown wrote:
> > > > On Thu, Dec 01, 2011 at 10:39:05AM -0800, Daniel Walker wrote:
> > > > 
> > > > > > If someone is willing to step up and make it work, then we can keep it
> > > > > > around.  My only G1 is fried, so I have no way to do anything other
> > > > > > than keep it compiling.
> > > > > 
> > > > > Unfortunately, You can't remove it regardless of whether or not you have
> > > > > one to test on.. Your job is to do the best you can to keep it working
> > > > > and maintained. If you don't have one then you can't boot test but you
> > > > > still have to your best to keep it as close to working as possible.
> > > > 
> > > > I was trying to get an idea if anyone uses the target.  If people
> > > > want the target around, we can just ignore my patches to remove it.
> > > 
> > > Please don't ever do this again.
> > 
> > That's awfully harsh.  I sent an email a few weeks back asking about
> > removing the target, and I only got one positive response.  Sometimes
> > sending a patch is the best way to get a reaction.
> 
> You didn't CC me on that (or I didn't see it) .. You know who supports
> the G1 target and who has the target (i.e. me) .. It also goes against
> the philosophy of this community to arbitrarily remove hardware support.

Any idea if the tip code works on the G1?  There are also some
DEBUG_LL changes in the ARM soc tree, and it'd be nice to know if
those still work on 7201.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
