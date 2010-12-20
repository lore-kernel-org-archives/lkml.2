Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0LTXWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:22:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20061 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0LTXWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:22:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67624860"
Message-ID: <4D0FE51A.4050506@codeaurora.org>
Date: Mon, 20 Dec 2010 15:22:02 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to      early_initcall
References: <4CF94DDD.8000409@codeaurora.org>    <20101203203653.GB10245@n2100.arm.linux.org.uk>    <4CFDD297.4020600@codeaurora.org>    <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>    <20101209103835.GA31465@n2100.arm.linux.org.uk>    <4D017B45.4000805@codeaurora.org>    <AANLkTi=PnnT8rVKMxK0tVTdKnKdcKf71fsX2o594Qx3e@mail.gmail.com>    <4D045692.4050607@codeaurora.org>    <AANLkTimwqC6DqN8ft10EyRbPh9XvibN1fA-Cug4OdS5m@mail.gmail.com>    <8c67e174d807416f0c6c190cc72d3f5a.squirrel@www.codeaurora.org>    <20101217094818.GA9937@n2100.arm.linux.org.uk>    <99eb693af85e07b01d81d45f1bc77f64.squirrel@www.codeaurora.org>    <AANLkTinsgqLDe3=KX59n1UAp9v0ErXQzxj+A+qQ8TRj_@mail.gmail.com> <7276921204ba82a2065faa61548f1699.squirrel@www.codeaurora.org>
In-Reply-To: <7276921204ba82a2065faa61548f1699.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/10 15:14, Saravana Kannan wrote:
> Catalin Marinas wrote:
>>> Russell,
>>>
>>> I agree with your point about using an API for purpose and not property.
>>> But I read Catalin's proposal as, let's treat secure domain as another
>>> DMA
>>> "device". If we make a conscious agreement to do that, then using the
>>> DMA
>>> API for secure domain would be "using it for its purpose" and we will
>>> make
>>> an effort to not break it with future updates. Of course, if we don't
>>> agree on that proposal, then we can't use the DMA API for secure domain
>>> stuff.
>>
>> If there is no better proposal, I'm for such extension to the DMA API.
>>  From the kernel perspecitve, the secure side is just another entity
>> that accesses the RAM directly. It's not a physically separate device
>> indeed but from a direct memory access perspective it can be treated
>> as any other device.
>>
>> In the DMA API we can fall back to the non-coherent ops when a NULL
>> struct device is passed. I assume in your code you already pass a NULL
>> device to dma_alloc_coherent().
>
> Russell,
>
> Would the extension of the DMA API as described above be acceptable to
> you? If not, can you please suggest an alternative that's acceptable to
> you?

Ping...

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
