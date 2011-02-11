Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1BKU6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:58:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4858 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab1BKU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:58:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74108440"
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
From: Daniel Walker <dwalker@codeaurora.org>
To: Steve Muckle <smuckle@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D55A16A.7030300@codeaurora.org>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	 <1297456934.4852.11.camel@m0nster>  <4D55A16A.7030300@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 12:58:19 -0800
Message-ID: <1297457899.4852.14.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 12:51 -0800, Steve Muckle wrote:
> On 02/11/11 12:42, Daniel Walker wrote:
> >>  static struct resource msm_iommu_jpegd_resources[] = {
> >>  	{
> >> -		.start = MSM_IOMMU_JPEGD_PHYS,
> >> -		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
> >> +		.start = 0x07300000,
> >> +		.end   = 0x07300000 + SZ_1M - 1,
> > 
> > Looks worse .. Just put the macros into a static header file for both.
> 
> Why bother defining macros for these if they only appear here? I don't
> think that adds any value or readability - these addresses are clearly
> the physical area for the msm_iommu_jpegd. It just makes it more
> annoying to have to look up the values in a separate file if you are
> wondering what they are.

So your saying if you look at the number 0x07300000 you instantly know
that this JPEGD? What if I pick a random other kernel developer do you
think they would instantly know that? I have no idea what 0x07300000 is.

Also if it's in a header you could ifdef them with out touching the C
file, which is just forward looking.

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


