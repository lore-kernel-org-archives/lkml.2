Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0LQXOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:14:51 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61702 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0LQXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:14:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6200"; a="67093034"
Message-ID: <7276921204ba82a2065faa61548f1699.squirrel@www.codeaurora.org>
In-Reply-To: <AANLkTinsgqLDe3=KX59n1UAp9v0ErXQzxj+A+qQ8TRj_@mail.gmail.com>
References: <4CF94DDD.8000409@codeaurora.org>
    <20101203203653.GB10245@n2100.arm.linux.org.uk>
    <4CFDD297.4020600@codeaurora.org>
    <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
    <20101209103835.GA31465@n2100.arm.linux.org.uk>
    <4D017B45.4000805@codeaurora.org>
    <AANLkTi=PnnT8rVKMxK0tVTdKnKdcKf71fsX2o594Qx3e@mail.gmail.com>
    <4D045692.4050607@codeaurora.org>
    <AANLkTimwqC6DqN8ft10EyRbPh9XvibN1fA-Cug4OdS5m@mail.gmail.com>
    <8c67e174d807416f0c6c190cc72d3f5a.squirrel@www.codeaurora.org>
    <20101217094818.GA9937@n2100.arm.linux.org.uk>
    <99eb693af85e07b01d81d45f1bc77f64.squirrel@www.codeaurora.org>
    <AANLkTinsgqLDe3=KX59n1UAp9v0ErXQzxj+A+qQ8TRj_@mail.gmail.com>
Date: Fri, 17 Dec 2010 15:14:35 -0800 (PST)
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to 
     early_initcall
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "Nicolas Pitre" <nico@marvell.com>, linux-kernel@vger.kernel.org,
        "Jeff Ohlstein" <johlstei@codeaurora.org>, "Tejun Heo" <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
>> Russell,
>>
>> I agree with your point about using an API for purpose and not property.
>> But I read Catalin's proposal as, let's treat secure domain as another
>> DMA
>> "device". If we make a conscious agreement to do that, then using the
>> DMA
>> API for secure domain would be "using it for its purpose" and we will
>> make
>> an effort to not break it with future updates. Of course, if we don't
>> agree on that proposal, then we can't use the DMA API for secure domain
>> stuff.
>
> If there is no better proposal, I'm for such extension to the DMA API.
> From the kernel perspecitve, the secure side is just another entity
> that accesses the RAM directly. It's not a physically separate device
> indeed but from a direct memory access perspective it can be treated
> as any other device.
>
> In the DMA API we can fall back to the non-coherent ops when a NULL
> struct device is passed. I assume in your code you already pass a NULL
> device to dma_alloc_coherent().

Russell,

Would the extension of the DMA API as described above be acceptable to
you? If not, can you please suggest an alternative that's acceptable to
you?

-Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


