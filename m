Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1DSLfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:35:10 -0400
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:54138 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab1DSLfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:35:09 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Date: Tue, 19 Apr 2011 04:33:42 -0700
Subject: RE: [PATCH 13/14] regulator: check name in initialization of	max8925
Thread-Topic: [PATCH 13/14] regulator: check name in initialization of
	max8925
Thread-Index: Acv+f7D5wp2DRx1kR+CB4pigVsc7oAABepHg
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B529@SC-VEXCH1.marvell.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
 <20110418142855.GE2466@opensource.wolfsonmicro.com>
 <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
 <20110418160424.GG1765@opensource.wolfsonmicro.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B424@SC-VEXCH1.marvell.com>
 <20110419080919.GC16357@opensource.wolfsonmicro.com>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B4CC@SC-VEXCH1.marvell.com>
 <20110419105103.GF9462@sirena.org.uk>
In-Reply-To: <20110419105103.GF9462@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3JBZKRO012938



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê4ÔÂ19ÈÕ 6:51 PM
>To: Haojian Zhuang
>Cc: Haojian Zhuang; sameo@linux.intel.com; linux-kernel@vger.kernel.org;
>dmitry.torokhov@gmail.com; a.zummo@towertech.it; johnpol@2ka.mipt.ru;
>cbou@mail.ru; dwmw2@infradead.org; lrg@slimlogic.co.uk
>Subject: Re: [PATCH 13/14] regulator: check name in initialization of
>max8925
>
>On Tue, Apr 19, 2011 at 01:28:23AM -0700, Haojian Zhuang wrote:
>
>> >> 	There's issue in max8925_core.c since we can't assume regulator[0]
>> >always declared in machine driver.
>
>> >What is the issue?  It's trivial to skip the regulator if the data is
>> >null.
>
>> It skiped all regulators if regulator[0] isn't decleared.
>> 	(pdata == NULL) || (pdata->regulator[0] == NULL)
>
>> So it's a bug.
>
>Surely the obvious fix is to fix the issue and not skip all the
>regulators if an individual regulator has no data?

Yes.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
