Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2CNE0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:26:00 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49144 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab2CNEZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:25:59 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Johan BJORNSTEDT <johan.bjornstedt@stericsson.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Date: Wed, 14 Mar 2012 05:25:29 +0100
Subject: RE: [PATCH 2/6] ab8500_btemp: Get rid of 'enum adc_therm'
Thread-Topic: [PATCH 2/6] ab8500_btemp: Get rid of 'enum adc_therm'
Thread-Index: Ac0Bfn+N5XEalGwIRsuI8kqHFAgCSQAG/EYg
Message-ID: <F45880696056844FA6A73F415B568C69589ECE976E@EXDCVYMBSTM006.EQ1STM.local>
References: <20120314005901.GB1778@oksana.dev.rtsoft.ru>
 <20120314010504.GB10798@oksana.dev.rtsoft.ru>
In-Reply-To: <20120314010504.GB10798@oksana.dev.rtsoft.ru>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E4Q9oT026002

> This is the same as abx500_adc_therm, but when the former is used,
> the following warning flood pops up:
> 
> drivers/power/ab8500_btemp.c: In function
> 'ab8500_btemp_batctrl_volt_to_res':
> ab8500_btemp.c:150:25: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> ab8500_btemp.c: In function 'ab8500_btemp_curr_source_enable':
> ab8500_btemp.c:212:25: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> ab8500_btemp.c:244:32: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> ab8500_btemp.c: In function 'ab8500_btemp_measure_temp':
> ab8500_btemp.c:462:25: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> ab8500_btemp.c: In function 'ab8500_btemp_id':
> ab8500_btemp.c:528:121: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> ab8500_btemp.c:551:25: warning: comparison between 'enum
> abx500_adc_therm' and 'enum adc_therm' [-Wenum-compare]
> 
> This patch fixes the issue by switching the driver to use more
> namespace-friendly enum.
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
