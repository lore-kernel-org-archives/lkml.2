Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab2CNEEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:04:01 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:37591 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797Ab2CNEEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:04:00 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 14 Mar 2012 05:03:25 +0100
Subject: RE: [PATCH 1/6] ab8500_charger: Convert to the new USB OTG calls
Thread-Topic: [PATCH 1/6] ab8500_charger: Convert to the new USB OTG calls
Thread-Index: Ac0BfnqIxFOewCn6RUqzhSdtAhQ5/wAGKN3w
Message-ID: <F45880696056844FA6A73F415B568C69589ECE9761@EXDCVYMBSTM006.EQ1STM.local>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
 <20120314010454.GA10798@oksana.dev.rtsoft.ru>
In-Reply-To: <20120314010454.GA10798@oksana.dev.rtsoft.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E448D2025943


> This patch fixes the following build errors:
> 
> ab8500_charger.c: In function 'ab8500_charger_remove':
> ab8500_charger.c:2519:2: error: implicit declaration of function
> 'otg_unregister_notifier' [-Werror=implicit-function-declaration]
> ab8500_charger.c:2520:2: error: implicit declaration of function
> 'otg_put_transceiver' [-Werror=implicit-function-declaration]
> ab8500_charger.c: In function 'ab8500_charger_probe':
> ab8500_charger.c:2688:2: error: implicit declaration of function
> 'otg_get_transceiver' [-Werror=implicit-function-declaration]
> ab8500_charger.c:2688:10: warning: assignment makes pointer from
> integer without a cast [enabled by default]
> ab8500_charger.c:2695:2: error: implicit declaration of function
> 'otg_register_notifier' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---

Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
