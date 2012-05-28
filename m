Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2E1FfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 01:35:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42191 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2E1FfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 01:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <1337941231.1580.19.camel@vkoul-udesk3>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
	<1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
	<20120321160913.GF3226@opensource.wolfsonmicro.com>
	<CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
	<20120326154009.GA17506@sirena.org.uk>
	<CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
	<20120523093857.GC4085@opensource.wolfsonmicro.com>
	<CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
	<20120524100742.GH5361@opensource.wolfsonmicro.com>
	<CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
	<1337941231.1580.19.camel@vkoul-udesk3>
Date: Mon, 28 May 2012 14:35:15 +0900
Message-ID: <CANKRQnjnHvK_oUOumLyN-s_GY5wYboC-zjQ0niV6+kRHfR14bg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, lars@metafoo.de,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 7:20 PM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
>> >> > Nobody seems to be working on it as far as I can tell, I've certainly
>> >> > not seen any patches.
>> >
>> >> If so, could you accept current platform/machine driver ?
>> >
>> > Ideally what would be happening here is that you or other people who
>> > have such systems would be working to add the required support to the
>> > core code, there's clearly a need for common code here as there are a
>> > number of different systems that don't have cyclic DMA and it wouldn't
>> > be great to end up with duplicated code.
>> >
>> > Is there some great difficulty in factoring out the support for
>> > non-cyclic audio DMA on dmaengine - it seems like if there is we must
>> > have a serious problem in dmaengine which we should fix?  If there is a
>> > substantial difficulty then that's different but it doesn't feel like
>> > we've tried doing common code yet, if there's problems doing that I'd
>> > like to understand what they are before we jump ahead of ourselves.
>>
>> I'm not so familiar with Linux's DMA idea.
>> So we don't know whether non-cyclic dmaengine has problem or not.
> First you should not be writing your own dma driver, it *needs* to use
> dmaenegine. We already have bunch of driver supported, so there may be a
> case that existing driver works straight or with little modifications.
> Using your own dma driver is a dead road, so sooner you move over better
> it is.
I've never developed our own dma driver.
I've developed our ASoC driver using linux standard DMA framework.

-- 
ROHM Co., Ltd.
tomoya
