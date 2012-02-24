Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2BXRJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:09:05 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28647 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2BXRJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:09:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6629"; a="163948816"
Date: Fri, 24 Feb 2012 09:09:01 -0800
From: David Brown <davidb@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
Message-ID: <20120224170901.GA9312@codeaurora.org>
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org>
 <20120222215533.GA31480@codeaurora.org>
 <4F476242.2020909@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F476242.2020909@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:11:14AM +0000, Marc Zyngier wrote:
> On 22/02/12 21:55, David Brown wrote:
> > On Tue, Feb 21, 2012 at 05:39:37PM -0800, Stephen Boyd wrote:
> >> Now that sched_clock is mandatory on ARM it's simple to add
> >> sched_clock support to the MSM timer code. Add it so that we get
> >> more accurate sched_clock output than the jiffies based version
> >> that's provided by default.
> >>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: David Brown <davidb@codeaurora.org>
> > 
> > Marc, are you able to pull this into your series, so they can all go
> > in together?  If so:
> > 
> >   Acked-by: David Brown <davidb@codeaurora.org>
> 
> David, Stephen,
> 
> Russell already pulled my sched_clock() patch series, so I'm not sure it
> is actually useful for me to carry it (and there is actually no
> dependency between this patch and the series). Maybe putting it in the
> patch system or via armsoc would be best?
> 
> Otherwise:
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>

I'll keep an eye on it then, and push it into the ARM soc tree when
the dependencies are there.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
