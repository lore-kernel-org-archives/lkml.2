Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2ATMrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:47:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2ATMre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:47:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6594"; a="156598281"
Message-ID: <4F19625E.2070103@codeaurora.org>
Date: Fri, 20 Jan 2012 18:17:26 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Daniel Walker <dwalker@fifo99.com>, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bryanh@codeaurora.org,
        tsoni@qualcomm.com, dan.j.williams@intel.com, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, johlstei@qualcomm.com
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org> <1325901569.10425.14.camel@m0nster> <1326810935.1540.162.camel@vkoul-udesk3>
In-Reply-To: <1326810935.1540.162.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 8:05 PM, Vinod Koul wrote:
> On Fri, 2012-01-06 at 17:59 -0800, Daniel Walker wrote:
>>> +
>>> +#define FORCED_FLUSH         0
>>> +#define GRACEFUL_FLUSH          1
>>
>> Could be an enum ..
> Along with proper namespace...
I will update in next patch release
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
