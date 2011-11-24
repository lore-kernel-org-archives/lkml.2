Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1KXIP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:15:26 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45082 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995Ab1KXIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:15:25 -0500
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Nov 2011 00:14:03 -0800
Subject: RE: [PATCH 1/3] leds: Convert led platform drivers to
 module_platform_driver
Thread-Topic: [PATCH 1/3] leds: Convert led platform drivers to
 module_platform_driver
Thread-Index: AcyqgAnb9OEWBze1TpG3p+Lt7YxEVQAAOeIQ
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C05EC95D44D@SC-VEXCH1.marvell.com>
References: <1322122004.10476.1.camel@phoenix>
In-Reply-To: <1322122004.10476.1.camel@phoenix>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAO8FXdG012718



>-----Original Message-----
>From: Axel Lin [mailto:axel.lin@gmail.com]
>Sent: 2011å¹´11æœˆ24æ—¥ 4:07 PM
>To: linux-kernel@vger.kernel.org
>Cc: Haojian Zhuang; Michael Hennerich; Mark Brown; Mike Rapoport;
>Richard Purdie; Andrew Morton
>Subject: [PATCH 1/3] leds: Convert led platform drivers to
>module_platform_driver
>
>Factor out some boilerplate code for platform driver registration
>into module_platform_driver.
>
>Signed-off-by: Axel Lin <axel.lin@gmail.com>
>---
> drivers/leds/leds-88pm860x.c      |   12 +-----------
> drivers/leds/leds-adp5520.c       |   12 +-----------
> drivers/leds/leds-ams-delta.c     |   13 +------------
> drivers/leds/leds-asic3.c         |   16 ++--------------
> drivers/leds/leds-atmel-pwm.c     |   17 +++--------------
> drivers/leds/leds-cobalt-qube.c   |   17 ++---------------
> drivers/leds/leds-da903x.c        |   12 +-----------
> drivers/leds/leds-fsg.c           |   15 +--------------
> drivers/leds/leds-gpio.c          |   16 ++--------------
> drivers/leds/leds-hp6xx.c         |   17 ++---------------
> drivers/leds/leds-lt3593.c        |   16 ++--------------
> drivers/leds/leds-mc13783.c       |   12 +-----------
> drivers/leds/leds-netxbig.c       |   15 ++-------------
> drivers/leds/leds-ns2.c           |   15 ++-------------
> drivers/leds/leds-pwm.c           |   13 +------------
> drivers/leds/leds-rb532.c         |   16 ++--------------
> drivers/leds/leds-regulator.c     |   12 +-----------
> drivers/leds/leds-renesas-tpu.c   |   13 +------------
> drivers/leds/leds-s3c24xx.c       |   13 +------------
> drivers/leds/leds-wm831x-status.c |   12 +-----------
> drivers/leds/leds-wm8350.c        |   12 +-----------
> 21 files changed, 31 insertions(+), 265 deletions(-)
>
Acked for led-88pm860x.c

Thanks
Haojian
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
