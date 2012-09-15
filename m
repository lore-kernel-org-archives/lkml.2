Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2IORBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 13:01:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2IORA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 13:00:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6835"; a="237240495"
Date: Sat, 15 Sep 2012 10:00:26 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 1/2] ARM: arch timer: Set the TVAL before timer
 is enabled
Message-ID: <20120915170026.GA8706@codeaurora.org>
References: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347694914-1457-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 12:41:53AM -0700, Rohit Vaswani wrote:
> On some hardware, the timer deasserts the interrupt when a
> new TVAL is written only when the enable bit is cleared.
> Hence explicitly disable the timer and then program the
> TVAL followed by enabling the timer.
> If this order is not followed, there are chances that
> you would not receive any timer interrupts.

It's a little unclear to me who you intend to take this patch.  In the
To field, you've listed Marc, the MSM maintainers, as well as Russell.
The MSM tree doesn't really make sense, since this is general ARM
code.  Marc would make sense if you depend on an active patch series
he is working on, so he could include it.

I'm guessing you meant it for Russell, though, and the rest of us as
CCs.

Thanks,
David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
