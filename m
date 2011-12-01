Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1LAT1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:27:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1LAT1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:27:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6547"; a="140485033"
Date: Thu, 1 Dec 2011 11:27:05 -0800
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Message-ID: <20111201192705.GA23641@huya.qualcomm.com>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
 <1322752657.3704.2.camel@m0nster>
 <20111201181736.GA13182@huya.qualcomm.com>
 <1322764745.3704.9.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322764745.3704.9.camel@m0nster>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 10:39:05AM -0800, Daniel Walker wrote:

> > If someone is willing to step up and make it work, then we can keep it
> > around.  My only G1 is fried, so I have no way to do anything other
> > than keep it compiling.
> 
> Unfortunately, You can't remove it regardless of whether or not you have
> one to test on.. Your job is to do the best you can to keep it working
> and maintained. If you don't have one then you can't boot test but you
> still have to your best to keep it as close to working as possible.

I was trying to get an idea if anyone uses the target.  If people
want the target around, we can just ignore my patches to remove it.

Remember, though, it is a tradeoff.  The msm7201 is fairly different
than the other MSM targets, and adds some effort to the consolidation
work across all of ARM.  I think it would be better, overall, to drop
support for it, if there are no users.

I'm pretty sure that the chips themselves are past end-of-life, so
there isn't going to be any new hardware based on the msm7201.

I'm curious what kinds of uses people have for their G1s.

Speaking of old targets, it doesn't look like the mahimahi (Nexus One)
ever made it to the point of building.  I have a dev board board on
the msm8650, and the chip support does work.  It'd be nice to get
patches to get the Nexus One target to work as well.  (the
board-mahimahi.c includes a board-mahimahi.h that isn't present).

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
