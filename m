Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2CNEgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:36:31 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:48823 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab2CNEga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:36:30 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 14 Mar 2012 05:36:16 +0100
Subject: RE: [PATCH 3/6] ab8500_fg: Get rid of 'struct v_to_cap'
Thread-Topic: [PATCH 3/6] ab8500_fg: Get rid of 'struct v_to_cap'
Thread-Index: Ac0BfoLvazk/dy6GRoGk3Zwmn70K3QAHWarw
Message-ID: <F45880696056844FA6A73F415B568C69589ECE9775@EXDCVYMBSTM006.EQ1STM.local>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
 <20120314010509.GC10798@oksana.dev.rtsoft.ru>
In-Reply-To: <20120314010509.GC10798@oksana.dev.rtsoft.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E4abiO026035

> The struct is duplicated, plus when used it causes the following
> warnings:
> 
>   CHECK   drivers/power/ab8500_fg.c
> ab8500_fg.c:818:13: warning: incorrect type in assignment (different
> base types)
> ab8500_fg.c:818:13:    expected struct v_to_cap *tbl
> ab8500_fg.c:818:13:    got struct abx500_v_to_cap *const v_to_cap_tbl
>   CC      drivers/power/ab8500_fg.o
> ab8500_fg.c: In function 'ab8500_fg_volt_to_capacity':
> ab8500_fg.c:818:6: warning: assignment from incompatible pointer type
> [enabled by default]
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
