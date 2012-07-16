Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2GPARp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 20:17:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38659 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GPARn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 20:17:43 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] regulator: lp872x: Simplify implementation of
 lp872x_find_regulator_init_data()
Thread-Topic: [PATCH] regulator: lp872x: Simplify implementation of
 lp872x_find_regulator_init_data()
Thread-Index: AQHNYmfaDStABXfz2k6IRl9sLlNvqJcrBfZQgAAFNlA=
Date: Mon, 16 Jul 2012 00:17:37 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FD599@DQHE02.ent.ti.com>
References: <1342342632.2939.2.camel@phoenix> 
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6G0Ihie023789

> Pass regulator id rahter than the index to
> lp872x_find_regulator_init_data(),
> then the code can be simpler.
> We can also get max_regulators by lp->num_regulators.

It looks good to me and tested successfully in the target board.
Thanks !

Acked-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Best Regards,
Milo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
