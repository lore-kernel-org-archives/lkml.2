Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1BWBfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:35:03 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:48349 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab1BWBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:35:01 -0500
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Eric Miao <eric.y.miao@gmail.com>, Axel Lin <axel.lin@gmail.com>
CC: Igor Grinberg <grinberg@compulab.co.il>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Feb 2011 17:33:19 -0800
Subject: RE: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
Thread-Topic: [PATCH] ARM: pxa: support 806MHz operating points for PXA31x
 processors A2 stepping
Thread-Index: AcvSkx6VMzd6OW4PT8++5QRURoUK/wAZhzqg
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05C96553FE@SC-VEXCH1.marvell.com>
References: <1297786849.2596.13.camel@phoenix>
 <4D5AB09C.9000106@compulab.co.il>
 <AANLkTino2vLisNgKeyXppuHwDyhLMMAcOOZjA0hgmkj6@mail.gmail.com>
 <4D637557.2070707@compulab.co.il>
 <AANLkTikTHnz+7C-QmXaHwFE0a+pw7U-t2JP11a0qdoyU@mail.gmail.com>
 <AANLkTin7E9j6Q32JR-t13ekpdveiSrPCqAorT08DdM=6@mail.gmail.com>
In-Reply-To: <AANLkTin7E9j6Q32JR-t13ekpdveiSrPCqAorT08DdM=6@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p1N1ZCGW008669



>-----Original Message-----
>From: Eric Miao [mailto:eric.y.miao@gmail.com]
>Sent: 2011å¹´2æœˆ22æ—¥ 9:19 PM
>To: Axel Lin; Haojian Zhuang
>Cc: Igor Grinberg; linux-kernel@vger.kernel.org; Russell King; linux-
>arm-kernel@lists.infradead.org
>Subject: Re: [PATCH] ARM: pxa: support 806MHz operating points for
>PXA31x processors A2 stepping
>
>>> Another thing (which could be related to the patch) is the package
>marking.
>>> We have PXA3xx SoCs marked A2 stepping, but C624, which means that
>the
>>> highest running frequency should not exceed 624MHz.
>>
>> This means not all PXA310 A2 stepping supports 806Mhz.
>> Can we differentiate the Cxxx option in software?
>>
>>> What is your PXA3xx A2 marking in respect to Cxxx option?
>>
>> Mine is 88AP310-A2-BGK2C806.
>>
>
>Haojian,
>
>Can you help check on the stepping/markings on these processors
>to see which of them supports 806MHz, reliably?
>
>- eric

Hi Eric,

There's no way to recognize 806MHz on PXA310 A2 since not all A2 chips 
can support 806MHz. The only way to recognize 806MHz is to read marks on
the top of chip.

Thanks
Haojian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
