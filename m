Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2CNEh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:37:59 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:51845 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab2CNEh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:37:58 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 14 Mar 2012 05:37:44 +0100
Subject: RE: [PATCH 6/6] ab8500: Turn unneeded global symbols into local ones
Thread-Topic: [PATCH 6/6] ab8500: Turn unneeded global symbols into local
 ones
Thread-Index: Ac0Bfo0wbyihhrvfRWWWVuNF4uW+JAAHY/Ig
Message-ID: <F45880696056844FA6A73F415B568C69589ECE9778@EXDCVYMBSTM006.EQ1STM.local>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
 <20120314010525.GF10798@oksana.dev.rtsoft.ru>
In-Reply-To: <20120314010525.GF10798@oksana.dev.rtsoft.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E4c5pq026057

> The patch fixes the following sparse warning:
> 
> drivers/power/ab8500_charger.c:1619:6: warning: symbol
> 'ab8500_charger_detect_usb_type_work' was not declared. Should it be
> static?
> drivers/power/abx500_chargalg.c:1709:24: warning: symbol
> 'abx500_chargalg_sysfs_ops' was not declared. Should it be static?
> drivers/power/ab8500_fg.c:2328:24: warning: symbol
> 'ab8500_fg_sysfs_ops' was not declared. Should it be static?
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>

Thanks for all the fixes:-)

Thanks and Regards,
Arun R Murthy
--------------
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
