Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab1BKVDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:03:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKVDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:03:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="73901399"
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
From: Daniel Walker <dwalker@codeaurora.org>
To: Steve Muckle <smuckle@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D55A372.9090705@codeaurora.org>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	 <1297456934.4852.11.camel@m0nster>  <4D55A16A.7030300@codeaurora.org>
	 <1297457899.4852.14.camel@m0nster>  <4D55A372.9090705@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 13:03:05 -0800
Message-ID: <1297458185.4852.15.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:00 -0800, Steve Muckle wrote:
> On 02/11/11 12:58, Daniel Walker wrote:
> > On Fri, 2011-02-11 at 12:51 -0800, Steve Muckle wrote:
> >> On 02/11/11 12:42, Daniel Walker wrote:
> >>>>  static struct resource msm_iommu_jpegd_resources[] = {
> >>>>  	{
> >>>> -		.start = MSM_IOMMU_JPEGD_PHYS,
> >>>> -		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
> >>>> +		.start = 0x07300000,
> >>>> +		.end   = 0x07300000 + SZ_1M - 1,
> >>>
> >>> Looks worse .. Just put the macros into a static header file for both.
> >>
> >> Why bother defining macros for these if they only appear here? I don't
> >> think that adds any value or readability - these addresses are clearly
> >> the physical area for the msm_iommu_jpegd. It just makes it more
> >> annoying to have to look up the values in a separate file if you are
> >> wondering what they are.
> > 
> > So your saying if you look at the number 0x07300000 you instantly know
> > that this JPEGD?
> 
> Yes, because it's the start address for the msm_iommu_jpegd resource.

Yeah I guess that's true .. I still think it's better design not to do
it this way.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


