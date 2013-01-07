Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3AGBRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:17:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59571 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3AGBRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:17:17 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Topic: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Thread-Index: AQHN6xcHWa3VEY62mE+Yi0u7YatEY5g9AjgA
Date: Mon, 7 Jan 2013 01:17:08 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E117BB@DQHE02.ent.ti.com>
References: <1357371223.22227.1.camel@phoenix>
In-Reply-To: <1357371223.22227.1.camel@phoenix>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.78]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r071HLjD024607

Hi Axel,

> -----Original Message-----
> From: Axel Lin [mailto:axel.lin@ingics.com]
> Sent: Saturday, January 05, 2013 4:34 PM
> To: Mark Brown
> Cc: Kim, Milo; Girdwood, Liam; linux-kernel@vger.kernel.org
> Subject: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
> regulator is enabled by external pin
> 
> ldo->en_pin is set iff the regulator is enabled by external pin.
> 
> This patch sets ldo->en_pin to NULL if lp8788_gpio_request_ldo_en()
> fails, then
> we can use it to determinate if the regulator is controlled by external
> pin or
> register.
> 
> lp8788_get_ldo_enable_mode(), lp8788_ldo_ctrl_by_extern_pin() and
> lp8788_ldo_is_enabled_by_extern_pin() functions are not used now,
> remove them.

I love this patch and it works in a real board.

Initial driver code controls LDOs by reading the regulator control mode.
It guarantees working even if the control mode is changed by mistake.
But this case can be fixed using LP8788 platform data.
This patch makes the driver simpler, so I do ack your patch.
Thanks!

Acked-by: Milo Kim <milo.kim@ti.com>
Tested-by: Milo Kim <milo.kim@ti.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
