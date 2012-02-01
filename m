Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2BAIix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:38:53 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44919 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2BAIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:38:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6606"; a="159575159"
Message-ID: <4F28FA14.1030505@codeaurora.org>
Date: Wed, 01 Feb 2012 14:08:44 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-arch@vger.kernel.org, tsoni@codeaurora.org, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bryanh@codeaurora.org,
        johlstei@codeaurora.org, Daniel Walker <dwalker@fifo99.com>,
        dan.j.williams@intel.com, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/2] Add Qualcomm MSM ADM DMAEngine driver
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>  <1326807902.1540.116.camel@vkoul-udesk3> <4F195E4C.6080805@codeaurora.org>  <1327066287.517.4.camel@vkoul-udesk3> <4F1D4052.3070701@codeaurora.org>  <1327326713.517.32.camel@vkoul-udesk3> <4F1FFF7E.3000802@codeaurora.org>  <1327911315.1527.8.camel@vkoul-udesk3>  <4F278341.4020600@codeaurora.org>  <1327990151.1527.80.camel@vkoul-udesk3>  <4F28D8A2.9050605@codeaurora.org> <1328084998.1610.11.camel@vkoul-udesk3>
In-Reply-To: <1328084998.1610.11.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/2012 1:59 PM, Vinod Koul wrote:
> On Wed, 2012-02-01 at 11:46 +0530, Ravi Kumar V wrote:
>> On 1/31/2012 11:39 AM, Vinod Koul wrote:
>>> On Tue, 2012-01-31 at 11:29 +0530, Ravi Kumar V wrote:
>>>>> [1]: https://lkml.org/lkml/2011/10/24/275
>>>>> [2]: https://lkml.org/lkml/2012/1/26/405
>>>>>
>>>>
>>>> Yes if we follow the above RFC and add extra context parameter also
>>>> in
>>>> device_prep_dma_sg()&   device_prep_interleaved_dma() then it supports
>>>> our hardware and our work will be completed.
>>>>
>>>> can we follow above RFC and implement our driver.
>>>> Is above RFC finalized and included in mainline?
>>> Alexandre will post an updated one soon, but the idea is same
>>>
>>
>> Can we add extra parameter context to device_prep_dma_sg()&
>> device_prep_interleaved_dma() API's and implement our driver.
> So what one are you going to use...
>
>> From the description sounds like you need interleaved API but with
> changes to make it interleaved in both src and dtsn, right?
> Then why prep_dma_sg?
>
>

Our hardware supports single transfer mode,scatter gather mode & box mode.

we are using these dmaengine API's for our HW
device_prep_memcpy() for single mode.
device_prep_dma_sg() for sg mode.
device_prep_interleaved_dma() for box mode.

We need to pass command configuration parameter to all of the above 
three modes and it can be possible if extra context parameter is added 
into these API's

Thanks
Ravi Kumar

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
