Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1EIIWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:22:10 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:38203 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379Ab1EIIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:22:05 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Richard Purdie <rpurdie@rpsys.net>
Date: Mon, 9 May 2011 01:21:30 -0700
Subject: RE: [PATCH 17/19] mfd: Use mfd cell platform_data for 88pm860x
 cells platform bits
Thread-Topic: [PATCH 17/19] mfd: Use mfd cell platform_data for 88pm860x
 cells platform bits
Thread-Index: AcwN4MZ062aeKcRISPqK9BNWcTGnGwAQTtLA
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05D178BDD2@SC-VEXCH1.marvell.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-18-git-send-email-sameo@linux.intel.com>
In-Reply-To: <1304901131-7104-18-git-send-email-sameo@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p498MLsk023735



>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>Sent: 2011Äê5ÔÂ9ÈÕ 8:32 AM
>To: linux-kernel
>Cc: Samuel Ortiz; Haojian Zhuang; Mark Brown; Liam Girdwood; Richard
>Purdie
>Subject: [PATCH 17/19] mfd: Use mfd cell platform_data for 88pm860x
>cells platform bits
>
>With the addition of a platform device mfd_cell pointer, MFD drivers
>can go back to passing platform back to their sub drivers.
>This allows for an mfd_cell->mfd_data removal and thus keep the
>sub drivers MFD agnostic. This is mostly needed for non MFD aware
>sub drivers.
>
>Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
>Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>Cc: Richard Purdie <rpurdie@rpsys.net>
>Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>---
> drivers/leds/leds-88pm860x.c          |    7 +------
> drivers/mfd/88pm860x-core.c           |   18 ++++++++++++------
> drivers/regulator/88pm8607.c          |    7 +------
> drivers/video/backlight/88pm860x_bl.c |    7 +------
> 4 files changed, 15 insertions(+), 24 deletions(-)
>
Tested. It's OK.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
