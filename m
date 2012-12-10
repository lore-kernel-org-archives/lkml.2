Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab2LJCaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:30:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36761 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2LJCaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:30:17 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] regulator: lp872x: Kill _rdev_to_offset() function
Thread-Topic: [PATCH] regulator: lp872x: Kill _rdev_to_offset() function
Thread-Index: AQHN1OdQglZ3Yg97bkCj5/q+rINbu5gRUkow
Date: Mon, 10 Dec 2012 02:30:11 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E05769@DQHE02.ent.ti.com>
References: <1354931808.6623.0.camel@phoenix>
In-Reply-To: <1354931808.6623.0.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBA2UM4Y002843

> There is only one user calling _rdev_to_offset() function.
> Remove _rdev_to_offset() makes the code simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

It looks good to me, thanks!

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
