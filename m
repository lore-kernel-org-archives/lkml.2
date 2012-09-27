Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2I0IhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:37:02 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33128 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2I0Ig7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=murAv=UaqZ2B7E+W8zwa4oP2+6uHqAVy20QPyaJ+i3pA@mail.gmail.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<20120927074522.GJ12592@arwen.pp.htv.fi>
	<CAOh2x=murAv=UaqZ2B7E+W8zwa4oP2+6uHqAVy20QPyaJ+i3pA@mail.gmail.com>
Date: Thu, 27 Sep 2012 11:36:57 +0300
Message-ID: <CAHp75Vfcad171=nwKjuGm8MreEjgfOfRR5vppU=eZChkbCQnRQ@mail.gmail.com>
Subject: Re: [PATCHv3 4/7] dmaengine: dw_dmac: amend description and indentation
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: balbi@ti.com, vinod.koul@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:19 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Thu, Sep 27, 2012 at 1:15 PM, Felipe Balbi <balbi@ti.com> wrote:
>> On Thu, Sep 27, 2012 at 10:31:58AM +0300, Andy Shevchenko wrote:
>>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>
>>> The driver will be used as a core part for various implementations of the
>>> DesignWare DMA device. The patch adjusts description on the top and corrects
>>> paragraph indentation in few places across the code.
>>>
>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>> ---
>>>  drivers/dma/dw_dmac.c |    7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>>> index bbb2a82..9f0129d 100644
>>> --- a/drivers/dma/dw_dmac.c
>>> +++ b/drivers/dma/dw_dmac.c
>>> @@ -1,14 +1,15 @@
>>>  /*
>>> - * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
>>> - * AVR32 systems.)
>>> + * Core driver for the Synopsys DesignWare DMA Controller
>>>   *
>>>   * Copyright (C) 2007-2008 Atmel Corporation
>>>   * Copyright (C) 2010-2011 ST Microelectronics
>>> + * Copyright (C) 2012 Intel Corporation
>>
>> I'm not a lawyer, but I'm not sure the few changes done to this driver
>> is enough for Intel to hold a copyright here... dunno, though.
>
> Neither do i :)
I only have one precedent where was a collision between two versions
of the as3645a driver.
In the result Nokia's version was modified accordingly to my comments
and few patches.

> @Vinod: Can we have some inputs from you here?
Agree, it's good to have an additional opinion here.

-- 
With Best Regards,
Andy Shevchenko
