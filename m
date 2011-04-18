Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1DRNxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:53:11 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51803 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827Ab1DRNxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:53:06 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Date: Mon, 18 Apr 2011 06:49:44 -0700
Subject: RE: [PATCH 12/13] regulator: check name in initialization of max8925
Thread-Topic: [PATCH 12/13] regulator: check name in initialization of
 max8925
Thread-Index: Acv8YFNQQjYZqhrkQAyC05LzI/e0XgBbwhJw
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05B23D@SC-VEXCH1.marvell.com>
References: <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
 <20110416180140.GE25811@opensource.wolfsonmicro.com>
In-Reply-To: <20110416180140.GE25811@opensource.wolfsonmicro.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3IDrODS007391



>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>Sent: 2011Äê4ÔÂ17ÈÕ 2:02 AM
>To: Haojian Zhuang
>Cc: sameo@linux.intel.com; haojian.zhuang@gmail.com; linux-
>kernel@vger.kernel.org; Liam Girdwood
>Subject: Re: [PATCH 12/13] regulator: check name in initialization of
>max8925
>
>On Wed, Apr 13, 2011 at 10:51:03PM +0800, Haojian Zhuang wrote:
>> Check name in initialization of max8925 regulator driver.
>
>> +		if (!strcmp(ri->desc.name, pdata->constraints.name))
>> +			break;
>
>This isn't a good change - the whole point of the name in the
>constraints is that it allows the user to assign an arbatrary string
>which is useful for the board.  The driver should never be looking
>inside the constraints at all, the core will apply the constraints for
>you.

I'll move the name of regulator into regulator_init_data->driver_data.

Thanks
Haojian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
