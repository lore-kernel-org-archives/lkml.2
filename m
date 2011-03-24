Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab1CXWpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:45:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30462 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab1CXWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:45:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6295"; a="81927017"
From: David Brown <davidb@codeaurora.org>
To: "Subhash Jadavani" <subhashj@codeaurora.org>
Cc: "'Daniel Walker'" <dwalker@fifo99.com>, <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <bryanh@codeaurora.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
	<1300454644-11361-2-git-send-email-subhashj@codeaurora.org>
	<1300885535.6117.15.camel@m0nster>
	<005601cbe9f5$a5088750$ef1995f0$@org>
Date: Thu, 24 Mar 2011 15:45:46 -0700
In-Reply-To: <005601cbe9f5$a5088750$ef1995f0$@org> (Subhash Jadavani's message
	of "Thu, 24 Mar 2011 13:02:31 +0530")
Message-ID: <8yak4fo16jp.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24 2011, Subhash Jadavani wrote:

> Here "DMA engine" means we are using SPS BAM as DMA HW.

> No, we are not using the "drivers/dma/dmaengine.c" because MSM SPS
> driver is not exporting the dma compliant APIs to client. We are using
> the MSM SPS driver's exported APIs directly from our driver. Not sure
> what extra description we can put it in commit text. Any suggestion?

I think the commit text should explain why this driver doesn't just use
the DMA engine API.  People are going to want to know that later on as
well.  I know you did an analysis for this driver, and it would be good
to include that information in the commit text.  Email me privately if
you want some help with that.

Currently none of the MSM DMA hardware uses the DMA engine API, and I
think we need to figure out if we want to move to that at some point.  I
realize that the hardware (especially SPS BAM) does a lot more than
regular DMA, this may involve extending DMA engine, which may or may not
be appropriate.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
