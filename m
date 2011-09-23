Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1IWCkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 22:40:42 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51772 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669Ab1IWCkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 22:40:41 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Thu, 22 Sep 2011 19:37:09 -0700
Subject: RE: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
Thread-Topic: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
Thread-Index: Acx4Z4VPM62LkPzUQa6wRyhL22dL2gBMiJYA
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05E9AF9F8B@SC-VEXCH1.marvell.com>
References: <1312978697-18572-1-git-send-email-linus.walleij@stericsson.com>
 <CAMPhdO9eL_Sdq-=TCami=CkwWeYR3XeF0K=n9L0uzjS88YTsRA@mail.gmail.com>
 <CACRpkdbGfhZnLaP9p27T1qbD0NVsW7Spp9ZVbR6zEGBSFU+M9g@mail.gmail.com>
 <CAMPhdO-3AY-S6dsW4FU2qB5G_7ffqcpj7x3hD-T=uhBvSAzKBQ@mail.gmail.com>
In-Reply-To: <CAMPhdO-3AY-S6dsW4FU2qB5G_7ffqcpj7x3hD-T=uhBvSAzKBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8N2f9Tp002097



>-----Original Message-----
>From: Eric Miao [mailto:eric.y.miao@gmail.com]
>Sent: 2011å¹´9æœˆ21æ—¥ 10:05 PM
>To: Linus Walleij; Haojian Zhuang
>Cc: Linus Walleij; Grant Likely; linux-kernel@vger.kernel.org; linux-
>arm-kernel@lists.infradead.org; Lee Jones; Russell King
>Subject: Re: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
>
>On Tue, Sep 20, 2011 at 4:45 PM, Linus Walleij <linus.walleij@linaro.org>
>wrote:
>> On Wed, Aug 10, 2011 at 4:38 PM, Eric Miao <eric.y.miao@gmail.com>
>wrote:
>>> On Wed, Aug 10, 2011 at 8:18 PM, Linus Walleij
>>> <linus.walleij@stericsson.com> wrote:
>>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>>
>>>> The <mach/gpio.h> file is included from upper directories
>>>> and deal with generic GPIO and gpiolib stuff. Break out the
>>>> platform and driver specific defines and functions into its own
>>>> header file.
>>>>
>>>> Cc: Eric Miao <eric.y.miao@gmail.com>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> I think there is better way around this, am working on it with
>several
>>> patches already, will release soon.
>>
>> Anything happening on this front or shall I update this patch set?
>
>Hi Linus,
>
>Several cleanup patches in my local tree but I didn't manage to find
>time to finish the series. Please go ahead update the patch set. We
>can fix the problems later.
>
>Haojian,
>
>Could you help on generalize the GPIO support code for PXA? Generally,
>the goals are:
>
>1. independent of <mach/gpio.h>, i.e. no #include <mach/gpio.h> so
>to support multiple sub-arch in a single kernel, that's to say -
>possible
>to build a single kernel supporting both mach-pxa/ and mach-mmp/
>
>2. as a result of 1), independent of <plat/gpio.h>
>
OK. I'll follow this.

>Thanks
>- eric
>
>>
>> Yours,
>> Linus Walleij
>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
