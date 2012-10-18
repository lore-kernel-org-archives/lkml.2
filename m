Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2JRHVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:21:50 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:40373 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785Ab2JRHVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:21:48 -0400
From: Yong Ding <yongd@marvell.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Chris Ball <cjb@laptop.org>, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Daniel Drake <dsd@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, Zhangfei Gao <zgao6@marvell.com>,
        Kevin Liu <kliu5@marvell.com>, Jialing Fu <jlfu@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 00:19:22 -0700
Subject: RE: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Topic: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself
Thread-Index: Ac2s+yU4BGyy9Z6vSg2BMWiWlBvPUwAAYEqw
Message-ID: <89813612683626448B837EE5A0B6A7CB3038856013@SC-VEXCH4.marvell.com>
References: <1348828113-19668-1-git-send-email-yongd@marvell.com>
 <1348828113-19668-2-git-send-email-yongd@marvell.com>
 <20121007140648.GA10148@S2101-09.ap.freescale.net>
 <89813612683626448B837EE5A0B6A7CB30388601C9@SC-VEXCH4.marvell.com>
 <20121018054053.GA4513@S2101-09.ap.freescale.net>
 <89813612683626448B837EE5A0B6A7CB3038855FF9@SC-VEXCH4.marvell.com>
 <20121018063825.GC4513@S2101-09.ap.freescale.net>
In-Reply-To: <20121018063825.GC4513@S2101-09.ap.freescale.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9I7Lt9b009048

Shawn,
Thanks, I will update the patch for sdhci-esdhc-imx.c and also fix my mail ASAP:-)

-----Original Message-----
From: Shawn Guo [mailto:shawn.guo@linaro.org] 
Sent: 2012Äê10ÔÂ18ÈÕ 14:38
To: Yong Ding
Cc: Chris Ball; Anton Vorontsov; Marek Szyprowski; Wolfram Sang; Daniel Drake; Sascha Hauer; Wilson Callan; Ben Dooks; Zhangfei Gao; Kevin Liu; Jialing Fu; linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: esdhc: enable polling to detect card by itself

Can you fix your mailer to use bottom posting rather than top posting,
and have texts wrap around column 70?  Otherwise, you message stands
a good chance to be ignored by people.

On Wed, Oct 17, 2012 at 11:27:17PM -0700, Yong Ding wrote:
> Shawn,
> Thanks. Oh, sorry I really have missed the fact u mentioned. U are right in the current code, the bit will also be cleared for ESDHC_CD_GPIO. 
> But I think this is improper since for GPIO detection type, we don't use the host controller internal card detection(ESDHC_CD_CONTROLLER), but with SDHCI_QUIRK_BROKEN_CARD_DETECTION cleared, we'll still enable/disable relevant INT bits (in sdhci_set_card_detection in sdhci.c). This is my biggest concern. And I think the SDHCI_QUIRK_BROKEN_CARD_DETECTION shall be purely used to notify whether the host controller detection method is used or not. So even for the ESDHC_CD_GPIO type, we should still set this flag. How do u think?
> 
I'm fine with that.  Just remind you a fact you seem missed in case
you need to change sdhci-esdhc-imx.c to adapt the changes you are going
to make on sdhci.c.

Shawn 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
