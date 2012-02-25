Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2BYBKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:10:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4456 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab2BYBKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:10:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6630"; a="166385562"
Date: Fri, 24 Feb 2012 17:10:00 -0800
From: David Brown <davidb@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
Message-ID: <20120225011000.GA4611@codeaurora.org>
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org>
 <20120222215533.GA31480@codeaurora.org>
 <4F476242.2020909@arm.com>
 <20120224170901.GA9312@codeaurora.org>
 <4F47C7C5.4090806@arm.com>
 <4F47C9AA.5060806@codeaurora.org>
 <4F47CAF5.4000709@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F47CAF5.4000709@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 05:37:57PM +0000, Marc Zyngier wrote:
> > This patch relies on the fact that the HAVE_SCHED_CLOCK config option no
> > longer exists. We could push it in if the patch had that option added to
> > the Kconfig, but then it would conflict with the removal of the Kconfig
> > by 6905a65 (ARM: Make the sched_clock framework mandatory, 2012-01-18).
> 
> Ah! Indeed, you're perfectly right.
> 
> > So I guess we send it through the arm-soc tree?
> 
> I don't think arm-soc tracks rmk/for-next, so this has to go via
> Russell's tree. I'll take the patch and send Russell another pull
> request then.

Thanks, Marc.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
