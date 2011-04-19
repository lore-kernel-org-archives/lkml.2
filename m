Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1DSCre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:47:34 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40698 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1DSCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:47:32 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Mon, 18 Apr 2011 19:45:06 -0700
Subject: RE: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint name
 in driver
Thread-Topic: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint
 name in driver
Thread-Index: Acv94hKMCJglBy7mT6qbbLEoGhEzmAAWVHZA
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B425@SC-VEXCH1.marvell.com>
References: <1303135451-26362-15-git-send-email-haojian.zhuang@marvell.com>
 <20110418143044.GF2466@opensource.wolfsonmicro.com>
 <BANLkTi=EFdzNN5GYNbGn+B8H=13C6W7s3A@mail.gmail.com>
 <20110418160247.GF1765@opensource.wolfsonmicro.com>
In-Reply-To: <20110418160247.GF1765@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3J2lie6010886



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011å¹´4æœˆ19æ—¥ 12:03 AM
>To: Haojian Zhuang
>Cc: Haojian Zhuang; sameo@linux.intel.com; linux-kernel@vger.kernel.org;
>dmitry.torokhov@gmail.com; a.zummo@towertech.it; johnpol@2ka.mipt.ru;
>cbou@mail.ru; dwmw2@infradead.org; lrg@slimlogic.co.uk
>Subject: Re: [PATCH 14/14] regulator: 88pm8607: avoid to use constraint
>name in driver
>
>On Mon, Apr 18, 2011 at 11:38:00PM +0800, Haojian Zhuang wrote:
>> On Mon, Apr 18, 2011 at 10:30 PM, Mark Brown
>
>> > Why not just use #defines in the header? Â It'd be less error prone
>if
>> > nothing else.
>
>> I don't understand this. desc.name is assigned in regulator driver.
>> pdata->driver_data is assigned in platform driver. I need to use same
>> name to link them together.
>
>I assume that by "platform driver" you mean the machine driver for the
>system?  What I'm saying is that instead of using a string to match it'd
>be more normal to use an enum in the driver header, that way if someone
>typos the string or something then there will be a build failure whereas
>with strings like this there will only be a runtime failure.
>
It's nearly same whatever it's string or index number. In machine driver,
it's more convenient on using string. Otherwise, I still need to create
a new integer array to store index since I transfer them into regulator data
by driver_data parameter in regulator_init_data.

>Part of the problem here is that your changelogs aren't really saying
>why you're making these changes...
Yes, the changelog is too simple.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
