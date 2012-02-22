Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2BVVzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:55:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42838 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BVVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:55:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6628"; a="163153824"
Date: Wed, 22 Feb 2012 13:55:33 -0800
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] msm: timer: Support sched_clock()
Message-ID: <20120222215533.GA31480@codeaurora.org>
References: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329874777-12758-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 05:39:37PM -0800, Stephen Boyd wrote:
> Now that sched_clock is mandatory on ARM it's simple to add
> sched_clock support to the MSM timer code. Add it so that we get
> more accurate sched_clock output than the jiffies based version
> that's provided by default.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: David Brown <davidb@codeaurora.org>

Marc, are you able to pull this into your series, so they can all go
in together?  If so:

  Acked-by: David Brown <davidb@codeaurora.org>

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
