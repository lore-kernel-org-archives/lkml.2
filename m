Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1CNMl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:41:56 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33819 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521Ab1CNMlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:41:55 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Mar 2011 05:41:35 -0700
Subject: RE: [PATCH] input: touchscreen: use polling mode in 88pm860x
Thread-Topic: [PATCH] input: touchscreen: use polling mode in 88pm860x
Thread-Index: AcvhShwyRHAe1bpVRtKaO/8HA2oT9AA+qjHw
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB99@SC-VEXCH1.marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <20110313064426.GG31566@core.coreip.homeip.net>
In-Reply-To: <20110313064426.GG31566@core.coreip.homeip.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2ECg2LM023097



>-----Original Message-----
>From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
>Sent: 2011Äê3ÔÂ13ÈÕ 2:44 PM
>To: Haojian Zhuang
>Cc: johnpol@2ka.mipt.ru; sameo@linux.intel.com; a.zummo@towertech.it;
>lrg@slimlogic.co.uk; broonie@opensource.wolfsonmicro.com;
>rpurdie@rpsys.net; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] input: touchscreen: use polling mode in 88pm860x
>
>On Mon, Mar 07, 2011 at 11:43:14PM +0800, Haojian Zhuang wrote:
>> Measuring point on touchscreen with IRQ mode can only monitor pen-down
>> event. If finger is moving on touchscreen, it can't be monitored by
>> IRQ pen-down event. So switch to polling mode after pen-down event.
>>
>
>Instead of scheduling work you could stay in the interrupt handler
>(which is a separate thread) and poll from it. Or is it a nested
>interrupt and it is sharing the interrupt thread?
>
>Thanks.
>
>--
>Dmitry

I'm using a nested interrupt. Do you mean that I should keep polling in the nested interrupt handler?

Thanks
Haojian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
