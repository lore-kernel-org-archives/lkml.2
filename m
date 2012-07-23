Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2GWA7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 20:59:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44758 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab2GWA7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 20:59:23 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: lp8788-buck: Remove
 lp8788_set_default_dvs_ctrl_mode function
Thread-Topic: [PATCH] regulator: lp8788-buck: Remove
 lp8788_set_default_dvs_ctrl_mode function
Thread-Index: AQHNZoMa1BkZIdhyCUi7/kl8jaek45c2DtVg
Date: Mon, 23 Jul 2012 00:59:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FDC69@DQHE02.ent.ti.com>
References: <1342794140.3401.1.camel@phoenix>
In-Reply-To: <1342794140.3401.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.177.86]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6N10Pvi001006

> We already know the mask in lp8788_init_dvs() function, and we can
> update
> the corresponding bit for default_dvs_mode in lp8788_init_dvs()
> function.
> This function looks not necessary to me.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Thanks for catching this !

Best Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
