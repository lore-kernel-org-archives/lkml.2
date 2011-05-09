Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1EIIYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:24:48 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39845 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab1EIIYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:24:46 -0400
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Andres Salomon <dilinger@queued.net>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <spyro@f2s.com>, "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Matt Reimer <mreimer@vpop.net>,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        =?utf-8?B?UmljaGFyZCBSw7ZqZm9ycw==?= 
	<richard.rojfors@pelagicore.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Wim Van Sebroeck <wim@iguana.be>,
        Wolfgang Grandegger <wg@grandegger.com>
Date: Mon, 9 May 2011 01:22:21 -0700
Subject: RE: [PATCH 19/19] mfd: Remove mfd_data
Thread-Topic: [PATCH 19/19] mfd: Remove mfd_data
Thread-Index: AcwN4MxxOiU4f64uSeWCsU/RLYWDNQAQWF9g
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05D178BDD4@SC-VEXCH1.marvell.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-20-git-send-email-sameo@linux.intel.com>
In-Reply-To: <1304901131-7104-20-git-send-email-sameo@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p498OxE6023751



>-----Original Message-----
>From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>Sent: 2011å¹´5æœˆ9æ—¥ 8:32 AM
>To: linux-kernel
>Cc: Samuel Ortiz; Andres Salomon; Artem Bityutskiy; Dmitry Baryshkov;
>Dmitry Torokhov; Florian Fainelli; Grant Likely; Guennadi Liakhovetski;
>Haojian Zhuang; Ian Molton; Ira W. Snyder; Liam Girdwood; Linus Walleij;
>Mark Brown; Matti Aaltonen; Matt Reimer; Miguel Aguilar; Paul Mundt;
>Peter Ujfalusi; Philipp Zabel; Richard Purdie; Richard RÃ¶jfors; Uwe
>Kleine-KÃ¶nig; Wim Van Sebroeck; Wolfgang Grandegger
>Subject: [PATCH 19/19] mfd: Remove mfd_data
>
>Cell pointers are passed through device->mfd_cell and platform data
>is passed through the MFD cell platform_data pointer.
>
>Cc: Andres Salomon <dilinger@queued.net>
>Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
>Cc: Dmitry Torokhov <dtor@mail.ru>
>Cc: Florian Fainelli <florian@openwrt.org>
>Cc: Grant Likely <grant.likely@secretlab.ca>
>Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
>Cc: Ian Molton <spyro@f2s.com>
>Cc: Ira W. Snyder <iws@ovro.caltech.edu>
>Cc: Liam Girdwood <lrg@slimlogic.co.uk>
>Cc: Linus Walleij <linus.walleij@linaro.org>
>Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
>Cc: Matt Reimer <mreimer@vpop.net>
>Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
>Cc: Paul Mundt <lethal@linux-sh.org>
>Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>
>Cc: Philipp Zabel <philipp.zabel@gmail.com>
>Cc: Richard Purdie <rpurdie@rpsys.net>
>Cc: Richard RÃ¶jfors <richard.rojfors@pelagicore.com>
>Cc: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
>Cc: Wim Van Sebroeck <wim@iguana.be>
>Cc: Wolfgang Grandegger <wg@grandegger.com>
>Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>---
> include/linux/mfd/core.h |   21 ---------------------
> 1 files changed, 0 insertions(+), 21 deletions(-)
>
Tested. It's OK.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
