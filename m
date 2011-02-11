Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1BKUv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:51:57 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:51:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="73899893"
Message-ID: <4D55A16A.7030300@codeaurora.org>
Date: Fri, 11 Feb 2011 12:51:54 -0800
From: Steve Muckle <smuckle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110119 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org> <1297456934.4852.11.camel@m0nster>
In-Reply-To: <1297456934.4852.11.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/11 12:42, Daniel Walker wrote:
>>  static struct resource msm_iommu_jpegd_resources[] = {
>>  	{
>> -		.start = MSM_IOMMU_JPEGD_PHYS,
>> -		.end   = MSM_IOMMU_JPEGD_PHYS + MSM_IOMMU_JPEGD_SIZE - 1,
>> +		.start = 0x07300000,
>> +		.end   = 0x07300000 + SZ_1M - 1,
> 
> Looks worse .. Just put the macros into a static header file for both.

Why bother defining macros for these if they only appear here? I don't
think that adds any value or readability - these addresses are clearly
the physical area for the msm_iommu_jpegd. It just makes it more
annoying to have to look up the values in a separate file if you are
wondering what they are.

thanks,
Steve

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
