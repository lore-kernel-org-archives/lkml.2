Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2LGEpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 23:45:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2LGEps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 23:45:48 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] regulator: lp8788-ldo: Remove val array in
 lp8788_config_ldo_enable_mode
Thread-Topic: [PATCH] regulator: lp8788-ldo: Remove val array in
 lp8788_config_ldo_enable_mode
Thread-Index: AQHN1BzpIZaSMI5KU0CEsU7TJfufRpgMwfcQ
Date: Fri, 7 Dec 2012 04:45:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64193910@DQHE02.ent.ti.com>
References: <1354844877.13831.1.camel@phoenix>
In-Reply-To: <1354844877.13831.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB74jsZM024572

> To clear the mask bit, setting data argument to be 0 with proper mask
> setting
> for lp8788_update_bits. We don't need the var array here.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks!

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
