Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab1IUOFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:05:30 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:55981 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1IUOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:05:29 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbGfhZnLaP9p27T1qbD0NVsW7Spp9ZVbR6zEGBSFU+M9g@mail.gmail.com>
References: <1312978697-18572-1-git-send-email-linus.walleij@stericsson.com>
 <CAMPhdO9eL_Sdq-=TCami=CkwWeYR3XeF0K=n9L0uzjS88YTsRA@mail.gmail.com> <CACRpkdbGfhZnLaP9p27T1qbD0NVsW7Spp9ZVbR6zEGBSFU+M9g@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 21 Sep 2011 22:04:59 +0800
Message-ID: <CAMPhdO-3AY-S6dsW4FU2qB5G_7ffqcpj7x3hD-T=uhBvSAzKBQ@mail.gmail.com>
Subject: Re: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
To: Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 4:45 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Aug 10, 2011 at 4:38 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
>> On Wed, Aug 10, 2011 at 8:18 PM, Linus Walleij
>> <linus.walleij@stericsson.com> wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> The <mach/gpio.h> file is included from upper directories
>>> and deal with generic GPIO and gpiolib stuff. Break out the
>>> platform and driver specific defines and functions into its own
>>> header file.
>>>
>>> Cc: Eric Miao <eric.y.miao@gmail.com>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> I think there is better way around this, am working on it with several
>> patches already, will release soon.
>
> Anything happening on this front or shall I update this patch set?

Hi Linus,

Several cleanup patches in my local tree but I didn't manage to find
time to finish the series. Please go ahead update the patch set. We
can fix the problems later.

Haojian,

Could you help on generalize the GPIO support code for PXA? Generally,
the goals are:

1. independent of <mach/gpio.h>, i.e. no #include <mach/gpio.h> so
to support multiple sub-arch in a single kernel, that's to say - possible
to build a single kernel supporting both mach-pxa/ and mach-mmp/

2. as a result of 1), independent of <plat/gpio.h>

Thanks
- eric

>
> Yours,
> Linus Walleij
>
