Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1LHWlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:41:37 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10856 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1LHWlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:41:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 08 Dec 2011 14:41:25 -0800
From: Stephen Warren <swarren@nvidia.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 8 Dec 2011 14:41:24 -0800
Subject: RE: [PATCH v2] Documentation/pinctrl: various minor fixes
Thread-Topic: [PATCH v2] Documentation/pinctrl: various minor fixes
Thread-Index: Acy1+cvxT7Ktmxk6Tni3+vVJW5N8AQAAKeIA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1750B77BB0@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1750B77B9F@HQMAIL01.nvidia.com>
 <1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1323383765-30742-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB8Mfjd3032664

Uwe Kleine-KÃ¶nig wrote at Thursday, December 08, 2011 3:36 PM:
> - add some consts
> - don't use the group index alone to determine the value to write to
>   foo's mux register. For spi and i2c the group index is always 0.
>   Additionally using the function index makes much more sense as it
>   generates a different value for each function/group pair.
> - fix a few syntax errors
> 
> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
