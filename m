Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1EJXCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:02:25 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:42601 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1EJXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:02:23 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-131.messagelabs.com!1305068542!24186206!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 10 May 2011 18:02:20 -0500
Subject: RE: [PATCH] [wip] ARM: imx: register "leds-gpio" device using new
 helper function
Thread-Topic: [PATCH] [wip] ARM: imx: register "leds-gpio" device using new
 helper function
Thread-Index: AcwO75FmTnyaR4cJROObV4/Z/rEgNQAdoB/Q
Message-ID: <0D753D10438DA54287A00B027084269764D2C3CD1E@AUSP01VMBX24.collaborationhost.net>
References: <20110510073152.GF29089@pengutronix.de>
 <1305017456-10910-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1305017456-10910-2-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1305017456-10910-2-git-send-email-u.kleine-koenig@pengutronix.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4AN2WJm000943

On Tuesday, May 10, 2011 1:51 AM, Uwe Kleine-KÃ¶nig wrote:
>
> This converts eukrea_mbimx27-baseboard to the new helper function.
>
> bloat-o-meter reports for this change:
>
>	add/remove: 1/1 grow/shrink: 0/1 up/down: 128/-220 (-92)
>	function                                     old     new   delta
>	gpio_led_register_device                       -     128    +128
>	platform_devices                              28      24      -4
>	leds_gpio                                    216       -    -216
>
> Additionally gpio_led_info (12 bytes) and gpio_leds (32 Bytes) are
> initdata now as is gpio_led_register_device.

FWIW, similar results with ep93xx:

add/remove: 1/1 grow/shrink: 2/0 up/down: 137/-240 (-103)
function                                     old     new   delta
gpio_led_register_device                       -     128    +128
kernel_config_data                         10474   10479      +5
ep93xx_init_devices                          116     120      +4
ep93xx_leds                                  240       -    -240

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
