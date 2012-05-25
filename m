Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2EYJah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:30:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55680 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab2EYJaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120524100742.GH5361@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
	<1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
	<20120321160913.GF3226@opensource.wolfsonmicro.com>
	<CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
	<20120326154009.GA17506@sirena.org.uk>
	<CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
	<20120523093857.GC4085@opensource.wolfsonmicro.com>
	<CANKRQnhNWC2F6zKgBMJY7HnipJbA5p-=6Lz4uGZqBKNQ688Z3w@mail.gmail.com>
	<20120524100742.GH5361@opensource.wolfsonmicro.com>
Date: Fri, 25 May 2012 18:30:06 +0900
Message-ID: <CANKRQnj_LdGQPYPV7d5NNZBx8oM5aAGHu4qZidiiS6C4eNtNJQ@mail.gmail.com>
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 7:07 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> > Nobody seems to be working on it as far as I can tell, I've certainly
>> > not seen any patches.
>
>> If so, could you accept current platform/machine driver ?
>
> Ideally what would be happening here is that you or other people who
> have such systems would be working to add the required support to the
> core code, there's clearly a need for common code here as there are a
> number of different systems that don't have cyclic DMA and it wouldn't
> be great to end up with duplicated code.
>
> Is there some great difficulty in factoring out the support for
> non-cyclic audio DMA on dmaengine - it seems like if there is we must
> have a serious problem in dmaengine which we should fix?  If there is a
> substantial difficulty then that's different but it doesn't feel like
> we've tried doing common code yet, if there's problems doing that I'd
> like to understand what they are before we jump ahead of ourselves.

I'm not so familiar with Linux's DMA idea.
So we don't know whether non-cyclic dmaengine has problem or not.

Until now, we've developed device drivers use DMA driver like UART, SPI.
These drivers are  implemented using the same way, you called
"non-cyclic", and already applied.

As you said, common code for DMA code can be best solution.
However, currently, the code is nothing.
So, I want you to accept our driver as first step.
Because I think supporting new device is more important for linux than
dmaengine common.

thanks
-- 
ROHM Co., Ltd.
tomoya
