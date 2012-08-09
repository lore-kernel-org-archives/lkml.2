Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2HISLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:11:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37024 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2HISLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:11:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6798"; a="220785907"
Date: Thu, 9 Aug 2012 11:11:12 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] msm: io: Change the default static iomappings to be
 shared
Message-ID: <20120809181112.GA24633@codeaurora.org>
References: <1343696061-11445-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343696061-11445-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 05:54:21PM -0700, Rohit Vaswani wrote:
> With 3.4 kernel the static iomappings can be shared with the ioremap
> mappings. If ioremap is called with an address for which a static
> mapping already exists, then that mapping should be used instead
> of creating a new one.
> However, the MT_DEVICE_NONSHARED flag prevents this. Hence, get rid
> of this flag. Some targets (7X00) that require the static iomappings
> to be NONSHARED use the MSM_DEVICE_TYPE and MSM_CHIP_DEVICE_TYPE macros.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/mach-msm/io.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)

I don't seem to be able to find a tree that this change applies to.
Can you apply this patch to a recent kernel tree (v3.5 is good), and
resend.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
