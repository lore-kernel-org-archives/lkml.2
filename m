Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2LUUyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:54:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57395 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2LUUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:53:57 -0500
Message-ID: <50D4CC62.6080304@wwwdotorg.org>
Date: Fri, 21 Dec 2012 13:53:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>, "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] dma: tegra: implement flags parameters for cyclic transfer
References: <1355924434-7930-1-git-send-email-ldewangan@nvidia.com> <50D1F33D.1050709@wwwdotorg.org> <50D2ABF7.8090308@nvidia.com> <50D340E1.7040600@wwwdotorg.org> <50D3E44F.4060007@nvidia.com>
In-Reply-To: <50D3E44F.4060007@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 09:23 PM, Laxman Dewangan wrote:
> On Thursday 20 December 2012 10:16 PM, Stephen Warren wrote:
>> On 12/19/2012 11:11 PM, Laxman Dewangan wrote:
>>> On Wednesday 19 December 2012 10:32 PM, Stephen Warren wrote:
>>>> On 12/19/2012 06:40 AM, Laxman Dewangan wrote:
>>>>> The flag parameter is added in the cyclic transfer request.
>>>>> Use the flag option of:
>>>>> - DMA_PREP_INTERRUPT for enabling interrupt.
>>>>> - DMA_CTRL_ACK for deciding whether ack is requred or not for
>>>>>     descriptor.
>>>> Do the relevant drivers that use Tegra's DMA engine already set flags
>>>> correctly, so that this change won't cause any regressions?
>>>
>>> Currently, the sound soc driver uses the cyclic mode of dma transfer and
>>> it has already enable the proper flags. This was done recently after
>>> adding flags in cyclic api.
>>> Also, there was bug in our dma driver for not setting DMA_CTRL_ACK by
>>> default for cyclic case.
>>> This will fix the issue.
>>
>> OK. I assume "This was done recently after adding flags in cyclic api."
>> was a patch that went into 3.8?  So, this patch is a bug-fix that should
>> be included in 3.8 then?
>
> I can see this in Linux 3.7 tag.

So I assume that means that when Vinod applies *this* patch, it should
be Cc: stable for 3.7 and up?

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=history;f=drivers/dma/tegra20-apb-dma.c;h=528c62dd4b00e1b52928ff66f3a54e7ae206680f;hb=29594404d7fe73cd80eaa4ee8c43dcc53970c60e

I don't think that points where you want; it just shows a log of 3.7 for me.
