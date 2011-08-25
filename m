Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1HYKoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:44:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52361 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HYKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:44:10 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz936eK1432Nzz1202hzz8275bh8275dhz32i2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Thu, 25 Aug 2011 11:43:53 +0100
Subject: RE: [PATCH] Input: adp5588-keys - remove incorrect modalias
Thread-Topic: [PATCH] Input: adp5588-keys - remove incorrect modalias
Thread-Index: AcxjEhEa4LFDLETEQBqOjQdxz35ujwAAcl6g
Message-ID: <544AC56F16B56944AEC3BD4E3D59177146E6D0708C@LIMKCMBX1.ad.analog.com>
References: <1314268238.2663.1.camel@phoenix>
In-Reply-To: <1314268238.2663.1.camel@phoenix>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7PAiQQ1005930

Axel Lin wrote on 2011-08-25:
> From 2b642fd34e59291764f5149f083d84760d8b41b2 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Thu, 25 Aug 2011 18:26:56 +0800
> Subject: [PATCH] Input: adp5588-keys - remove incorrect modalias
>
> For i2c drivers, we should use "i2c:" prefix for modalias.
> MODULE_DEVICE_TABLE will setup the modulalias for us,
> thus adding a MODULE_ALIAS here seems redundant.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/input/keyboard/adp5588-keys.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> diff --git a/drivers/input/keyboard/adp5588-keys.c
> b/drivers/input/keyboard/adp5588-keys.c index 7b404e54..e34eeb8 100644
> --- a/drivers/input/keyboard/adp5588-keys.c +++
> b/drivers/input/keyboard/adp5588-keys.c @@ -668,4 +668,3 @@
> module_exit(adp5588_exit);
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("ADP5588/87 Keypad driver");
> -MODULE_ALIAS("platform:adp5588-keys");

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
